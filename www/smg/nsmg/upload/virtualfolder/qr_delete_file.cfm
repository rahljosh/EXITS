<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Delete File</title>
</head>

<body>
<cftry>

	<cfif NOT IsDefined("form.DeleteFile") AND NOT IsDefined('form.directory') AND NOT IsDefined('form.unqid')>
		<cfinclude template="error_message.cfm">
		<cfabort>
	</cfif>

	<cfquery name="get_student_info" datasource="MySql">
		SELECT studentid
		FROM smg_students
		WHERE uniqueid = '#form.unqid#'
	</cfquery>

	<cffile action = "delete" file = "#form.directory#/#form.DeleteFile#">
	
	<cfquery name="delete_category" datasource="MySql">
		DELETE FROM smg_virtualfolder
		WHERE studentid = '#get_student_info.studentid#'
			AND filename = '#form.DeleteFile#'
			AND filesize = '#form.filesize#'
	</cfquery>
	
	<html>
	<head>
	<cfoutput>
	<script language="JavaScript">
	<!-- 
	alert("You have successfully deleted the file #form.DeleteFile# from this Virtual Folder.");
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