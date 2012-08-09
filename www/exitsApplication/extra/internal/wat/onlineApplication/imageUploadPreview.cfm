<!--- ------------------------------------------------------------------------- ----
	
	File:		thumbnailUpload.cfm
	Author:		Marcus Melo
	Date:		August 2-, 2010
	Desc:		Upload / Preview an image

----- ------------------------------------------------------------------------- --->

<cfsilent>
	
    <!--- Do not display debug output --->
	<cfsetting showdebugoutput="no">
    
    <!--- Param URL Variable --->
    <cfparam name="URL.file" default="">
    <cfparam name="URL.candidateID" default="0">

	<cfscript>
		// Set Image Folder
		imagePath = APPLICATION.PATH.uploadCandidatePicture;
	</cfscript>

</cfsilent>

<cfif LEN(URL.file)>

    <!--- Preview Image --->

	<cfif fileExists("#imagePath##URL.file#") AND isImageFile("#imagePath##URL.file#")>
        <cfimage action="read" source="#imagePath##URL.file#" name="image">
        <cfcontent type="image/jpg" variable="#imageGetBlob(image)#">
    </cfif>

<cfelse>
	
	<!--- Upload File --->
            
    <cffile action="upload" filefield="image" destination="#imagePath#" nameconflict="makeunique" result="result">
    
    <cfset newFilePath = imagePath & result.serverfile>

	<cfif isImageFile(newFilePath)>
        
		<cfset jpgVersion = imagePath & URL.candidateID & ".jpg">
		<!--- Resize Image --->
        <cfimage action="resize" width="150" height="150" source="#newFilePath#" destination="#jpgVersion#" overwrite="true">
		<!--- Delete File --->
        <cffile action="delete" file="#newFilePath#">            
        
        <cfscript>
			// Update Candidate Session Variables
			APPLICATION.CFC.CANDIDATE.setCandidateSession(candidateID=URL.candidateID);
		</cfscript>
		
		<cfoutput>#getFileFromPath(jpgVersion)#</cfoutput>
        
	<cfelse>
		
		<!--- Delete File --->
        <cffile action="delete" file="#newFilePath#">   
	
	</cfif>

</cfif>