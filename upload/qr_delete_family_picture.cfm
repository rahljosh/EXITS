<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Delete Family Picture</title>
</head>

<body>

<cftry>

<cfif  NOT IsDefined('url.studentid') OR NOT IsDefined('url.img')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<cfoutput>
	
<cfset picture = #URLDecode(url.img)#>

<!---
<cfset directory = '/var/www/smg_upload_files/online_app/picture_album/#url.studentid#'>

<cffile action="delete" file="#directory#/#picture#" mode="777">

<cfquery name="delete_picture_description" datasource="MySQL">
	DELETE from smg_student_app_family_album
	WHERE studentid = '#url.studentid#'
		AND filename = '#url.img#'
</cfquery>
---->

<html>
<head>
<cfoutput>
<script language="JavaScript">
<!-- 
alert("You have successfully deleted #picture# file.");
	location.replace("http://www.student-management.com/nsmg/student_app/index.cfm?curdoc=curdoc=section1/page4&id=1&p=4");
//-->
</script>
</cfoutput>
</head>
</html>	

</cfoutput>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">	
</cfcatch>
</cftry>	

</body>
</html>