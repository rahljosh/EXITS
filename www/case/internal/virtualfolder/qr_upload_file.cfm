<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Upload File</title>
</head>

<body>

<cftry>

<!--- Check to see if the Form variable exists. --->
<cfif NOT isDefined("form.UploadFile") OR NOT IsDefined('form.unqid')>
	<cfinclude template="error_message.cfm">
	<cfabort>
</cfif>

<cfquery name="get_student_info" datasource="caseusa">
	SELECT *
	FROM smg_students
	WHERE uniqueid = '#form.unqid#'
</cfquery>

<cfquery name="get_user" datasource="caseusa">
	SELECT userid, firstname, lastname, businessname, email
	FROM smg_users
	WHERE userid = '#client.userid#'
</cfquery>

<!--- EMAIL FACILITATORS TO LET THEM KNOW THERE IS A DOCUMENT ---->
<cfquery name="get_region_info" datasource="caseusa">
	SELECT s.regionassigned, 
			r.regionname, r.regionfacilitator, r.regionid, r.company,
			u.firstname, u.lastname, u.email 
	FROM smg_students s 
	INNER JOIN smg_regions r ON s.regionassigned = r.regionid
	LEFT JOIN smg_users u ON r.regionfacilitator = u.userid
	WHERE s.studentid = '#client.studentid#'
</cfquery>

<cfif get_region_info.email EQ ''>
	<cfset get_region_info.email = 'support@case-usa.org'>
</cfif>

<!--- If TRUE, upload the file. --->
<cffile action="upload" filefield="UploadFile" destination="#form.directory#" nameconflict="makeunique" mode="777">

<!--- check file size - 2mb limit --->
<cfset newfilesize = #file.FileSize# / 1024>
<cfif newfilesize GT 2048>  
	<cffile action = "delete" file = "#form.directory#/#cffile.serverfile#">
	<cfoutput>
	<script language="JavaScript">
	<!-- 
	alert("The file you are trying to upload is bigger than 2mb. Please try again. Files can not be bigger than 2mb.");
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

<cfquery name="insert_category" datasource="caseusa">
	INSERT INTO smg_virtualfolder (studentid, categoryid, other_category, filename, filesize)
	VALUES ('#get_student_info.studentid#', '#form.category#', '#form.other_category#', '#mydirectory.name#', '#mydirectory.size#')
</cfquery>

<cfquery name="get_category" datasource="caseusa">
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
	<cfset emailrecipient = 'support@case-usa.org'> <!--- NO FACILITATOR - GOES TO SUPPORT ACCOUNT --->
<cfelseif get_student_info.companyid EQ '6'>
	<cfset emailrecipient = 'alicia@phpusa.com'> <!--- PHP MESSAGE GOES TO RICH --->
<cfelse>	
	<cfset emailrecipient = '#get_region_info.email#'> <!--- FACILITATOR --->
</cfif>

<CFMAIL SUBJECT="CASE EXITS - Virtual Folder - Upload Notification for #get_student_info.firstname# #get_student_info.familylastname# (###get_student_info.studentid#)"
TO="#emailrecipient#"
FROM="""#get_user.businessname# #get_user.firstname# #get_user.lastname#"" <#get_user.email#>"
TYPE="HTML">
	<HTML>
	<HEAD>
	<style type="text/css">
		.thin-border{ border: 1px solid ##000000;}
	</style>
	</HEAD>
	<BODY>	
	
	<table width=550 class="thin-border" cellspacing="3" cellpadding=0>
	<tr><td bgcolor=b5d66e><img src="http://www.case-usa.org/internal/student_app/pics/top-email.gif" width=550 height=75></td></tr>
	<tr><td><br>Dear #get_region_info.firstname# #get_region_info.lastname#,<br><br></td></tr>
	<tr><td>This e-mail is just to let you know a new document has been uploaded into #get_student_info.firstname# #get_student_info.familylastname#'s (###get_student_info.studentid#) virtual folder by #get_user.businessname# #get_user.firstname# #get_user.lastname#.
			The document has been recorded in the category #get_category.category# <cfif form.other_category NEQ ''>&nbsp; - &nbsp; #form.other_category#</cfif>.<br><br></td></tr>	
	<tr><td>
		Please click 
		<a href="http://www.case-usa.org/internal/index.cfm?curdoc=student_info&studentid=#get_student_info.studentid#">here</a>
		to see the student's virtual folder.<br><br>
	</td></tr>	
	<tr><td>
		 Sincerely,<br>
		 EXITS - Cultural Academic Student Exchange<br><br>
	</td></tr>
	</table>
	
	</body>
	</html>
</CFMAIL>
<!----Email to Int. Representative---->
<cfquery name="email_int_rep" datasource="caseusa">
select email
from smg_users 
where userid = #get_student_info.intrep#
</cfquery>
<CFMAIL SUBJECT="CASE EXITS - Virtual Folder - Upload Notification for #get_student_info.firstname# #get_student_info.familylastname# (###get_student_info.studentid#)"
TO="#email_int_rep.email#" 
FROM="""#get_user.businessname# #get_user.firstname# #get_user.lastname#"" <#get_user.email#>"
TYPE="HTML">
	<HTML>
	<HEAD>
	<style type="text/css">
		.thin-border{ border: 1px solid ##000000;}
	</style>
	</HEAD>
	<BODY>	
	
	<table width=550 class="thin-border" cellspacing="3" cellpadding=0>
	<tr><td bgcolor=b5d66e><img src="http://www.case-usa.org/internal/student_app/pics/top-email.gif" width=550 height=75></td></tr>
		<tr><td>This e-mail is just to let you know a new document has been uploaded into #get_student_info.firstname# #get_student_info.familylastname#'s (###get_student_info.studentid#) virtual folder by #get_user.businessname# #get_user.firstname# #get_user.lastname#.
			The document has been recorded in the category #get_category.category# <cfif form.other_category NEQ ''>&nbsp; - &nbsp; #form.other_category#</cfif>.<br><br></td></tr>	
	<tr><td>
		Please click 
		<a href="http://www.case-usa.org/internal/index.cfm?curdoc=student_info&studentid=#get_student_info.studentid#">here</a>
		to see the student's virtual folder.<br><br>
	</td></tr>	
	<tr><td>
		 Sincerely,<br>
		 EXITS - Cultural Academic Student Exchange<br><br>
	</td></tr>
	</table>
	
	</body>
	</html>
</CFMAIL>


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

<cfcatch type="any">
	<cfinclude template="error_message.cfm">
</cfcatch>
</cftry>
	
</body>
</html>