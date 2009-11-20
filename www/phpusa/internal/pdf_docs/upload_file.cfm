<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Upload File</title>
</head>

<body>

<!--- Check to see if the Form variable exists. --->
<cfif NOT isDefined("form.UploadFile")>
	An Error has ocurred, please try again.
	<cfabort>
</cfif>

<!--- If TRUE, upload the file. --->
<cffile action="upload" fileField="UploadFile" destination="#form.directory#" nameConflict="MakeUnique">

<html>
<head>
<cfoutput>
<script language="JavaScript">
<!-- 
alert("You have successfully uploaded this file.");
	location.replace("?curdoc=pdf_docs/docs_forms");
-->
</script>
</cfoutput>
</head>
</html> 		
	
</body>
</html>