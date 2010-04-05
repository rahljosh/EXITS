<link rel="stylesheet" href="../../smg.css" type="text/css">
<body onLoad="opener.location.reload()">
<!---
<cftry>
---->
<cfquery name="get_id" datasource="mysql">
select candidateid from extra_candidates
where uniqueid = '#url.uniqueid#'
</cfquery>
<cfset url.candidateid = #get_id.candidateid#>
<cfoutput>

	<cfset directory = AppPath.candidatePicture>
	 <!----'d:\websites\extra\internal\uploadedfiles\web-candidates'>---->
	
	<!----Upload File---->
	<cffile action = "upload" fileField = "form.candidate_pic"  destination = "#directory#"  nameConflict = "MakeUnique" mode=666>
	<cfdump var="#cffile#">

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
		<cffile action = "delete" file = "#directory#/#cffile.serverfile#">
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
		<cfset scaleX150 = imageCFC.scaleX("", "#directory#/#uploadedImage#", "#directory#/new#uploadedImage#", 150)>
		<!--- if file has been resized ---->
		<cfif #FileExists("#directory#/new#filename#.#file.ServerFileExt#")#>
			<!--- delete big file --->
			<cffile action = "delete" file = "#directory#/#uploadedImage#">
			<!--- rename new file --->
			<cffile action="rename" source="#directory#/new#filename#.#file.ServerFileExt#" destination="#directory#/#filename#.#file.ServerFileExt#">
		</cfif>
	</cfif>
	Source=#directory#/#CFFILE.ServerFile#<br>
	Dest: #directory#/#url.candidateid#.#cffile.ClientFileExt#



	<cffile	action="rename" source="#directory#/#CFFILE.ServerFile#" destination="#directory#/#url.candidateid#.#cffile.ClientFileExt#">
	
	<cfquery name="picture_extension" datasource="MySQL">
		update extra_candidates
		set picture_type = <cfif file.ClientFileExt is 'pjpeg'>'jpg'<cfelse>'#file.ClientFileExt#'</cfif>
		where uniqueid = '#url.uniqueid#'
	</cfquery>
	
	<cflocation url="reload_window.cfm">

</cfoutput>



<!----
<cfcatch type="any">
	<cfinclude template="../email_error.cfm">
</cfcatch>

</cftry>
---->