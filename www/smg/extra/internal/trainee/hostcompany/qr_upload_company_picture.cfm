<link rel="stylesheet" href="../../smg.css" type="text/css">
<body onLoad="opener.location.reload()">
<!----
<cftry>
---->
<cfoutput>
	<cfset directory = AppPath.hostLogo>
	
	<!----Upload File---->
	<cffile action = "upload" fileField = "form.company_pic"  destination = "#directory#"  nameConflict = "MakeUnique">
													<!--- accept = "image/jpg, image/gif, image/jpeg, image/pjpeg" --->
	<!--- check file size - 1mb limit --->
	<cfset newfilesize = #file.FileSize# / 1024>
	<cfif newfilesize GT 1024>  
		<cffile action = "delete" file = "#directory#/#cffile.serverfile#">
			<script language="JavaScript">
			<!-- 
			alert("The photo you are trying to upload is bigger than 1mb. Please try again. Files can not be bigger than 1mb.");
			location.replace("../upload_picture.cfm");
			-->
			</script>
		<cfabort>
	</cfif>
	
	<!--- check image extension --->
	<cfif cffile.ClientFileExt NEQ 'gif' AND cffile.ClientFileExt NEQ 'jpg' AND cffile.ClientFileExt NEQ 'jpeg' AND cffile.ClientFileExt NEQ 'pjpeg'>
		<cffile action = "delete" file = "#directory#\#cffile.serverfile#">
			<script language="JavaScript">
			<!-- 
			alert("Only images that are .gif, .jpg, or .jpeg can be uploaded.  Please re-save in the appropriate format, and resubmit.");
			location.replace("../upload_picture.cfm");
			-->
			</script>
		<cfabort>
	</cfif>

	<!--- Resize Image Files to 150 width --->
	<cfif cffile.ClientFileExt NEQ 'gif' AND cffile.ClientFileExt NEQ 'jpg' AND cffile.ClientFileExt NEQ 'jpeg' AND cffile.ClientFileExt NEQ 'pjpeg'> 
		<cfset filename = '#file.ServerFileName#'>
		<cfset uploadedImage = cffile.serverfile>
		<cfset filename = '#file.ServerFileName#'>
		<!--- Invoke image.cfc component --->
		<cfset imageCFC = createObject("component","image") />
		<!--- scaleX image to 1000px wide --->
		<cfset scaleX150 = imageCFC.scaleX("", "#directory#/#uploadedImage#", "#directory#\new#uploadedImage#", 150)>
		<!--- if file has been resized ---->
		<cfif #FileExists("#directory#\new#filename#.#file.ServerFileExt#")#>
			<!--- delete big file --->
			<cffile action = "delete" file = "#directory#/#uploadedImage#">
			<!--- rename new file --->
			<cffile action="rename" source="#directory#/new#filename#.#file.ServerFileExt#" destination="#directory#/#filename#.#file.ServerFileExt#">
		</cfif>
	</cfif>

	<cffile	action="rename" source="#directory#/#CFFILE.ServerFile#" destination="#directory#/#url.hostcompanyid#.#cffile.ClientFileExt#">
	<cfquery name="picture_extension" datasource="MySQL">
		update extra_hostcompany
		set picture_type = <cfif file.ClientFileExt is 'pjpeg'>'jpg'<cfelse>'#file.ClientFileExt#'</cfif>
		where hostcompanyid = #url.hostcompanyid#
	</cfquery>
	
	<cflocation url="reload_window.cfm">

</cfoutput>
<!----
<cfcatch type="any">
	<cfinclude template="../email_error.cfm">
</cfcatch>
</cftry>
--->