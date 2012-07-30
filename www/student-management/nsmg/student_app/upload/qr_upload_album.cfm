<cfoutput>
	<cfset directory = ExpandPath('../../uploadedFiles/online_app/picture_album/#FORM.studentID#')>

	<cfif NOT DirectoryExists('#directory#')>
		<cfdirectory action="create" directory="#directory#">
	</cfif>

	<!--- RENAME FILE #createUUID()# --->
	<cfif form.file_name NEQ ''>
		<cffile action="upload" destination="#directory#/album.#LCase(Right(form.file_name, 3))#" fileField="form.family_pic" nameConflict="MakeUnique" mode=777>
	<cfelse>
		<cffile action="upload" destination="#directory#" fileField="form.family_pic" nameConflict="MakeUnique" mode=777>
	</cfif>
	  		  
	<!--- check file size - 1mb limit --->
	<cfset newfilesize = file.FileSize / 1024>
	<cfif newfilesize GT 2048>  
		<cffile action = "delete" file = "#directory#/#cffile.serverfile#">
			<script language="JavaScript">
			<!-- 
			alert("The photo you are trying to upload is bigger than 2mb. Files can not be bigger than 2mb. Please try again.");
			location.replace("form_upload_album.cfm?studentid=#form.studentid#");
			-->
			</script>
		<cfabort>
	</cfif>

	<!--- check image extension --->
	<cfif NOT ListFind("jpg,jpeg,gif,tif,tiff,png", LCase(CFFILE.clientfileext))>
		<cffile action = "delete" file = "#directory#/#cffile.serverfile#">
			<script type="text/javascript">
				alert("Only images that are .gif, .jpg, or .jpeg can be uploaded.  Please save the file in the appropriate format, and resubmit.");
				location.replace("form_upload_album.cfm?studentid=#form.studentid#");
			</script>
		<cfabort>
	</cfif>

	<cfscript>
		// Invoke image.cfc component to resize image
		imageCFC = createObject("component","image");
		
		//scaleX image to 1000px wide
		scaleX800 = imageCFC.scaleX("", "#directory#/#CFFILE.serverfile#", "#directory#/#CFFILE.serverfile#", 800);
	</cfscript>
    
	<script type="text/javascript">
		opener.location.reload(true);
   		self.close();
	</script>

</cfoutput>