<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>Page [22] - Delete Supplements</title>
</head>

<body>

<cftry>

<cfset directory = "D:\home\exitsapplication.com\wwwroot\exits\upload\virtualfolder/#form.studentid#/page22">

<cffile action = "delete" file = "#directory#/#form.deletefile#">

<html>
<head>
<cfoutput>

<script language="JavaScript">
<!-- 
alert("You have successfully deleted the #form.deletefile# file.");
	location.replace("http://www.exitsapplication.com/exits/student_app/index.cfm?curdoc=section4/page22&id=4&p=22");
//-->
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