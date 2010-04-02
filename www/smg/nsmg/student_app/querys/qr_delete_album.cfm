<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>Delete Family Picture</title>
</head>
<body>

<cftry>

<cfoutput>
	
<cfset picture = URLDecode(url.img)>

<cfset directory = '#AppPath.onlineApp.familyAlbum##url.studentid#'>

<cffile action="delete" file="#directory#/#picture#" mode="777">

<cfquery name="delete_picture_description" datasource="MySQL">
	DELETE from smg_student_app_family_album
	WHERE studentid = '#url.studentid#'
		AND filename = '#picture#'
	LIMIT 1
</cfquery>

<script language="JavaScript">
<!-- 
alert("You have successfully deleted #picture# file.");
	location.replace("../index.cfm?curdoc=section1/page4&id=1&p=4");
//-->
</script>

</cfoutput>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">	
</cfcatch>
</cftry>	

</body>
</html>