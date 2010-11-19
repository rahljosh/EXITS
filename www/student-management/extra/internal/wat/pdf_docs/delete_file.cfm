<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Delete File</title>
</head>

<body>

<cftry>

<cffile action = "delete" file = "#form.directory#\#form.DeleteFile#">

<html>
<head>
<cfoutput>
<script language="JavaScript">
<!-- 
alert("You have successfully deleted the file #form.DeleteFile#.");
	location.replace("?curdoc=pdf_docs/docs_forms");
-->
</script>
</cfoutput>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>

</cftry>

</head>
</html> 				
	
</body>
</html>