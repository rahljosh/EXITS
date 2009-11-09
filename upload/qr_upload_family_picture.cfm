<cftry>

<cfoutput>

	<cfset directory = '/var/www/smg_upload_files/online_app/picture_album/#url.student#'>

	<cfif NOT DirectoryExists('#directory#')>
		<cfdirectory action="create" directory="#directory#" mode="777">
	</cfif>

	<!--- RENAME FILE #createUUID()# --->
	<cfif form.file_name NEQ ''>
		<cffile action="upload" destination="#directory#/picture.#Right(form.file_name, 3)#" fileField="form.family_pic" nameConflict="MakeUnique" mode=777>
	<cfelse>
		<cffile action="upload" destination="#directory#" fileField="form.family_pic" nameConflict="MakeUnique" charset="utf-8" mode=777>
	</cfif>
	  		  
	<!--- check file size - 1mb limit --->
	<cfset newfilesize = #file.FileSize# / 1024>
	<cfif newfilesize GT 2048>  
		<cffile action = "delete" file = "#directory#/#cffile.serverfile#">
			<script language="JavaScript">
			<!-- 
			alert("The photo you are trying to upload is bigger than 2mb. Please try again. Files can not be bigger than 2mb.");
			location.replace("upload_family_album.cfm?student=#url.student#");
			-->
			</script>
		<cfabort>
	</cfif>

	<!--- check image extension --->
	<cfif cffile.ClientFileExt NEQ 'gif' AND cffile.ClientFileExt NEQ 'jpg' AND cffile.ClientFileExt NEQ 'jpeg'>
		<cffile action = "delete" file = "#directory#/#cffile.serverfile#">
			<script language="JavaScript">
			<!-- 
			alert("Only images that are .gif, .jpg, or .jpeg can be uploaded.  Please re-save in the appropriate format, and resubmit.");
			location.replace("upload_family_album.cfm?student=#url.student#");
			-->
			</script>
		<cfabort>
	</cfif>
	
	<!--- Resize Image Files to 800 width --->
	<cfif file.ServerFileExt EQ 'jpg' OR file.ServerFileExt EQ 'gif' OR file.ServerFileExt EQ 'jpeg'> 
		<cfset filename = '#file.ServerFileName#'>
		<cfset uploadedImage = cffile.serverfile>
		<cfset filename = '#file.ServerFileName#'>
		<!--- Invoke image.cfc component --->
		<cfset imageCFC = createObject("component","image") />
		<!--- scaleX image to 1000px wide --->
		<cfset scaleX800 = imageCFC.scaleX("", "#directory#/#uploadedImage#", "#directory#/new#uploadedImage#", 800)>
		<!--- if file has been resized ---->
		<cfif #FileExists("#directory#/new#filename#.#file.ServerFileExt#")#>
			<!--- delete big file --->
			<cffile action = "delete" file = "#directory#/#uploadedImage#">
			<!--- rename new file --->
			<cffile action="rename" source="#directory#/new#filename#.#file.ServerFileExt#" destination="#directory#/#filename#.#file.ServerFileExt#">
		</cfif>
	</cfif>
	
	<cflocation url="upload_family_album.cfm?student=#url.student#" addtoken="no">

</cfoutput>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">	
</cfcatch>
</cftry>	