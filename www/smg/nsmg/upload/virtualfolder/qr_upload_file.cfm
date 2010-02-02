<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Upload File</title>
</head>

<body>
<!----
<cftry>
---->
<!--- Check to see if the Form variable exists. --->
<cfoutput>
<cfset directory = '/var/www/smg_upload_files/virtualfolder/#url.student#'>



<!--- If TRUE, upload the file. --->

<cffile action="upload" filefield="form.UploadFile" destination="#directory#" nameconflict="makeunique" mode="777">
l
</cfoutput>

<!--- check file size - 4mb limit --->
<cfset newfilesize = #file.FileSize# / 4024>
<cfif newfilesize GT 4048>  
	<cffile action = "delete" file = "#directory#/#cffile.serverfile#">
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
<cfif file.ServerFileExt EQ 'jpg' OR file.ServerFileExt EQ 'gif' OR file.ServerFileExt EQ 'png' OR file.ServerFileExt EQ 'tif'> 
	<cfset filename = '#file.ServerFileName#'>
	<cfset uploadedImage = cffile.serverfile>
	<cfset filename = '#file.ServerFileName#'>
	
	<!--- Invoke image.cfc component --->
	<cfset imageCFC = createObject("component","image") />
	<!--- scaleX image to 1000px wide --->
	<cfset scaleX1000 = imageCFC.scaleX("", "#directory#/#uploadedImage#", "#directory#/new#uploadedImage#", 1000)>

	<!--- if file has been resized ---->
	<cfif #FileExists("#directory#/new#filename#.#file.ServerFileExt#")#>
		<!--- delete big file --->
		<cffile action = "delete" file = "#directory#/#uploadedImage#">
		<!--- rename new file --->
		<cffile action="rename" source="#directory#/new#filename#.#file.ServerFileExt#" destination="#directory#/#filename#.#file.ServerFileExt#" attributes="normal" mode="777">
	</cfif>
</cfif>
