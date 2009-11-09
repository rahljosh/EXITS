<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Delete File</title>
</head>

<body>

<cfif NOT IsDefined("form.DeleteFile") AND NOT IsDefined('form.directory')>
	An Error has ocurred, please try again.
	<cfabort>
</cfif>

<cffile action = "delete" file = "#form.directory#/#form.DeleteFile#">

<html>
<head>
<cfoutput>
<script language="JavaScript">
<!-- 
alert("You have successfully deleted the file #form.DeleteFile# from this Virtual Folder.");
	location.replace("?curdoc=pdf_docs/docs_forms");
-->
</script>
</cfoutput>
</head>
</html> 				
	
</body>
</html>