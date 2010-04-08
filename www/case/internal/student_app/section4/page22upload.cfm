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
<cfif NOT isDefined("form.UploadFile")>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<!--- If TRUE, upload the file. --->
<cffile action="upload" fileField="UploadFile" destination="#form.directory#" nameConflict="MakeUnique">

<!--- check file size - 2mb limit --->
<cfset newfilesize = #file.FileSize# / 1024>
<cfif newfilesize GT 2048>  
	<cffile action = "delete" file = "#form.directory#/#cffile.serverfile#">
	<cfoutput>
	<script language="JavaScript">
	<!-- 
	alert("The file you are trying to upload is bigger than 2mb. Files can not be bigger than 2mb. Please resize your file and try again.");
		location.replace("?curdoc=section4/page22&id=4&p=22");
	-->
	</script>
	</cfoutput>
</cfif>

<!--- file type --->
<cfif cffile.clientfileext NEQ 'jpg' AND cffile.clientfileext NEQ 'jpeg' AND cffile.clientfileext NEQ 'gif' AND cffile.clientfileext NEQ 'pdf' AND cffile.clientfileext NEQ 'doc'>  
	<cffile action = "delete" file = "#directory#/#cffile.serverfile#">
	<cfoutput>
	<script language="JavaScript">
	<!-- 
	alert("Unfortunately EXITS Online Application does not accept #cffile.clientfileext# files. \n EXITS only accepts files in the following formats: JPG, JPEG, GIF, PDF AND DOC. Please change the file type and try again.");
		location.replace("?curdoc=section4/page22&id=4&p=22");
	-->
	</script>
	</cfoutput>
</cfif>

<!--- Resize Image Files --->
<cfif cffile.clientfileext EQ 'jpg' OR cffile.clientfileext EQ 'gif' OR cffile.clientfileext EQ 'jpeg'>  
	<cfset filename = '#file.ServerFileName#'>
	<cfset uploadedImage = cffile.serverfile>
	<cfset filename = '#file.ServerFileName#'>
	
	<!--- Invoke image.cfc component --->
	<cfset imageCFC = createObject("component","image") />
	<!--- scaleX image to 800px wide --->
	<cfset scaleX800 = imageCFC.scaleX("", "#form.directory#/#uploadedImage#", "#form.directory#/new#uploadedImage#", 800)>

	<!--- if file has been resized ---->
	<cfif #FileExists("#form.directory#/new#filename#.#file.ServerFileExt#")#>
		<!--- delete big file --->
		<cffile action = "delete" file = "#form.directory#/#uploadedImage#">
		<!--- rename new file --->
		<cffile action="rename" source="#form.directory#/new#filename#.#file.ServerFileExt#" destination="#form.directory#/#filename#.#file.ServerFileExt#" attributes="normal">
	</cfif>
</cfif>

<html>
<head>
<cfoutput>
<script language="JavaScript">
<!-- 
alert("You have successfully uploaded this file.");
	location.replace("?curdoc=section4/page22&id=4&p=22");
-->
</script>
</cfoutput>
</head>
</html> 		

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>
	
</body>
</html>