<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Upload File</title>
</head>

<body>

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
	<cfset get_region_info.email = 'support@student-management.com'>
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
<cfif ListFind("jpg,peg,gif,png,tif", LCase(file.ServerFileExt))>
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
	<cfset emailrecipient = 'support@student-management.com'> <!--- NO FACILITATOR - GOES TO SUPPORT ACCOUNT --->
<cfelseif get_student_info.companyid EQ '6'>
	<cfset emailrecipient = 'rich@phpusa.com'> <!--- PHP MESSAGE GOES TO RICH --->
<cfelse>	
	<cfset emailrecipient = '#get_region_info.email#'> <!--- FACILITATOR --->
</cfif>

<CFMAIL SUBJECT="SMG EXITS - Virtual Folder - Upload Notification for #get_student_info.firstname# #get_student_info.familylastname# (###get_student_info.studentid#)"
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
	<tr><td bgcolor=b5d66e><img src="http://www.student-management.com/nsmg/student_app/pics/top-email.gif" width=550 height=75></td></tr>
	<tr><td><br>Dear #get_region_info.firstname# #get_region_info.lastname#,<br><br></td></tr>
	<tr><td>This e-mail is just to let you know a new document has been uploaded into #get_student_info.firstname# #get_student_info.familylastname#'s (###get_student_info.studentid#) virtual folder by #get_user.businessname# #get_user.firstname# #get_user.lastname#.
			The document has been recorded in the category #get_category.category# <cfif form.other_category NEQ ''>&nbsp; - &nbsp; #form.other_category#</cfif>.<br><br></td></tr>	
	<tr><td>
		Please click 
		<a href="http://www.student-management.com/nsmg/index.cfm?curdoc=student_info&studentid=#get_student_info.studentid#">here</a>
		to see the student's virtual folder.<br><br>
	</td></tr>	
	<tr><td>
		 Sincerely,<br>
		 EXITS - Student Management Group<br><br>
	</td></tr>
	</table>
	
	</body>
	</html>
</CFMAIL>

<!----Email to Int. Representative---->
<cfquery name="email_int_rep" datasource="mysql">
select email
from smg_users 
where userid = #get_student_info.intrep#
</cfquery>

<CFMAIL SUBJECT="SMG EXITS - Virtual Folder - Upload Notification for #get_student_info.firstname# #get_student_info.familylastname# (###get_student_info.studentid#)"
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
	<tr><td bgcolor=b5d66e><img src="http://www.student-management.com/nsmg/student_app/pics/top-email.gif" width=550 height=75></td></tr>
		<tr><td>This e-mail is just to let you know a new document has been uploaded into #get_student_info.firstname# #get_student_info.familylastname#'s (###get_student_info.studentid#) virtual folder by #get_user.businessname# #get_user.firstname# #get_user.lastname#.
			The document has been recorded in the category #get_category.category# <cfif form.other_category NEQ ''>&nbsp; - &nbsp; #form.other_category#</cfif>.<br><br></td></tr>	
	<tr><td>
		Please click
		<a href="http://www.student-management.com/nsmg/virtualfolder/list_vfolder.cfm?unqid=#form.unqid#">here</a> and
		to see the student's virtual folder.<br><br>
		<!---
        <a href="http://www.student-management.com/nsmg/index.cfm?curdoc=intrep/int_student_info&unqid=#form.unqid#">here</a> and click on Virtual Folder (top-right)
		to see the student's virtual folder.<br><br> --->
	</td></tr>	
	<tr><td>
		 Sincerely,<br>
		 EXITS - Student Management Group<br><br>
	</td></tr>
	</table>
	
	</body>
	</html>
</CFMAIL>

<cfoutput>
<script language="JavaScript">
<!-- 
alert("You have successfully uploaded this file.");
	location.replace("list_vfolder.cfm?unqid=#form.unqid#");
-->
</script>
</cfoutput>

</body>
</html>