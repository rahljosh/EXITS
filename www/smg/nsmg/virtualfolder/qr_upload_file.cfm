<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Upload File</title>
</head>

<body>
<!----
<cftry>
---->
<!--- Check to see if the Form variable exists. --->
<cfif NOT isDefined("form.UploadFile") OR NOT IsDefined('form.unqid')>
	<cfinclude template="error_message.cfm">
	<cfabort>
</cfif>

<cfquery name="get_student_info" datasource="MySql">
	SELECT *
	FROM smg_students
	WHERE uniqueid = '#form.unqid#'
</cfquery>

<cfquery name="get_user" datasource="MySql">
	SELECT userid, firstname, lastname, businessname, email
	FROM smg_users
	WHERE userid = '#client.userid#'
</cfquery>

<!--- EMAIL FACILITATORS TO LET THEM KNOW THERE IS A DOCUMENT ---->
<cfquery name="get_region_info" datasource="MySQL">
	SELECT s.regionassigned, 
			r.regionname, r.regionfacilitator, r.regionid, r.company,
			u.firstname, u.lastname, u.email 
	FROM smg_students s 
	INNER JOIN smg_regions r ON s.regionassigned = r.regionid
	LEFT JOIN smg_users u ON r.regionfacilitator = u.userid
	WHERE s.studentid = '#client.studentid#'
</cfquery>

<cfif get_region_info.email EQ ''>
	<cfset get_region_info.email = '#client.support_email#'>
</cfif>

<!--- If TRUE, upload the file. --->
<cffile action="upload" filefield="UploadFile" destination="#form.directory#" nameconflict="makeunique" mode="777">

<!--- check file size - 4mb limit --->
<cfset newfilesize = #file.FileSize# / 4024>
<cfif newfilesize GT 4048>  
	<cffile action = "delete" file = "#form.directory#/#cffile.serverfile#">
	<cfoutput>
	<script language="JavaScript">
	<!-- 
	alert("The file you are trying to upload is bigger than 4mb. Please try again. Files can not be bigger than 4mb.");
		location.replace("list_vfolder.cfm?unqid=#form.unqid#");
	-->
	</script>
	</cfoutput>
</cfif>

<!--- Resize Image Files --->
<cfif file.ServerFileExt EQ 'jpg' OR file.ServerFileExt EQ 'gif' OR file.ServerFileExt EQ 'png' OR file.ServerFileExt EQ 'tif'> 
	<cfset filename = '#file.ServerFileName#'>
	<cfset uploadedImage = cffile.serverfile>
	<cfset filename = '#file.ServerFileName#'>
	
	<!--- Invoke image.cfc component --->
	<cfset imageCFC = createObject("component","image") />
	<!--- scaleX image to 1000px wide --->
	<cfset scaleX1000 = imageCFC.scaleX("", "#form.directory#/#uploadedImage#", "#form.directory#/new#uploadedImage#", 1000)>

	<!--- if file has been resized ---->
	<cfif #FileExists("#form.directory#/new#filename#.#file.ServerFileExt#")#>
		<!--- delete big file --->
		<cffile action = "delete" file = "#form.directory#/#uploadedImage#">
		<!--- rename new file --->
		<cffile action="rename" source="#form.directory#/new#filename#.#file.ServerFileExt#" destination="#form.directory#/#filename#.#file.ServerFileExt#" attributes="normal" mode="777">
	</cfif>
</cfif>

<cfif NOT IsDefined('form.other_category')>
	<cfset form.other_category = ''>
</cfif>

<cfdirectory directory="#form.directory#" name="mydirectory" sort="datelastmodified DESC" filter="*.*">

<cfquery name="insert_category" datasource="MySql">
	INSERT INTO smg_virtualfolder (studentid, categoryid, other_category, filename, filesize)
	VALUES ('#get_student_info.studentid#', '#form.category#', '#form.other_category#', '#mydirectory.name#', '#mydirectory.size#')
</cfquery>

<cfquery name="get_category" datasource="MySql">
	SELECT category
	FROM smg_virtualfolder_cat
	WHERE categoryid = '#form.category#'
</cfquery>

<cfif client.usertype LTE 4>
	<cfset emailsender = ''>
<cfelse>
	<cfset emailsender = ''>
</cfif>

<cfif get_region_info.email EQ ''>
	<cfset emailrecipient = '#client.support_email#'> <!--- NO FACILITATOR - GOES TO SUPPORT ACCOUNT --->
<cfelseif get_student_info.companyid EQ '6'>
	<cfset emailrecipient = 'rich@phpusa.com'> <!--- PHP MESSAGE GOES TO RICH --->
<cfelse>	
	<cfset emailrecipient = '#get_region_info.email#'> <!--- FACILITATOR --->
</cfif>

<!---Email to Local Person---->
<!----Email To be Send. nsmg cfc emal cfc---->
    		
            <cfoutput>
                <cfsavecontent variable="email_message">
                        
                    Dear #get_region_info.firstname# #get_region_info.lastname#,<br><br>T
                    his e-mail is just to let you know a new document has been uploaded into #get_student_info.firstname# #get_student_info.familylastname#'s (###get_student_info.studentid#) virtual folder by #get_user.businessname# #get_user.firstname# #get_user.lastname#.
                    The document has been recorded in the category #get_category.category# <cfif form.other_category NEQ ''>&nbsp; - &nbsp; #form.other_category#</cfif>.<br><br>
                    Please login to <a href="http://#exits_url#/">#exits_url#</a> and click on Students from the menu, select this student from the list, and then select the Virtual Folder from the right menu in the student profile.  <br><br>
                    
                    Sincerely,<br>
                    EXITS - #client.companyname#<br><br>
                    
                    <!----
                    <p>To login please visit: <cfoutput><a href="#application.site_url#">#application.site_url#</a></cfoutput></p>
                    ---->
                </cfsavecontent>
            </cfoutput>
            
			<!--- send email --->
            <cfinvoke component="nsmg.cfc.email" method="send_mail">
                <cfinvokeargument name="email_to" value="#emailrecipient#">
                <cfinvokeargument name="email_subject" value="Virtual Folder - Upload Notification for #get_student_info.firstname# #get_student_info.familylastname# (###get_student_info.studentid#)">
                <cfinvokeargument name="email_message" value="#email_message#">
                <cfinvokeargument name="email_from" value="#client.support_email#">
                
            </cfinvoke>
    <!----End of Email---->


<!----Email to Int. Representative---->
<cfquery name="email_int_rep" datasource="mysql">
select email
from smg_users 
where userid = #get_student_info.intrep#
</cfquery>
<cfoutput>
	<cfsavecontent variable="email_message">
           			
This e-mail is just to let you know a new document has been uploaded into #get_student_info.firstname# #get_student_info.familylastname#'s (###get_student_info.studentid#) virtual folder by #get_user.businessname# #get_user.firstname# #get_user.lastname#.
			The document has been recorded in the category #get_category.category# <cfif form.other_category NEQ ''>&nbsp; - &nbsp; #form.other_category#</cfif>.<br><br>
Please click 
<a href="http://#exits_url#/nsmg/index.cfm?curdoc=student_info&studentid=#get_student_info.studentid#">here</a>
to see the student's virtual folder.<br><br>
 Sincerely,<br>
 EXITS - #client.companyname#<br><br>
				
                <!----
				<p>To login please visit: <cfoutput><a href="#application.site_url#">#application.site_url#</a></cfoutput></p>
				---->
			</cfsavecontent>
			</cfoutput>
			<!--- send email --->
            <cfinvoke component="nsmg.cfc.email" method="send_mail">
                <cfinvokeargument name="email_to" value="#email_int_rep.email#">
                <cfinvokeargument name="email_subject" value="Virtual Folder - Upload Notification for #get_student_info.firstname# #get_student_info.familylastname# (###get_student_info.studentid#)">
                <cfinvokeargument name="email_message" value="#email_message#">
                <cfinvokeargument name="email_from" value="#client.support_email#">
                
            </cfinvoke>




<html>
<head>
<cfoutput>
<script language="JavaScript">
<!-- 
alert("You have successfully uploaded this file.");
	location.replace("list_vfolder.cfm?unqid=#form.unqid#");
-->
</script>
</cfoutput>
</head>
</html> 		
<!----
<cfcatch type="any">
	<cfinclude template="error_message.cfm">
</cfcatch>
</cftry>
	---->
</body>
</html>