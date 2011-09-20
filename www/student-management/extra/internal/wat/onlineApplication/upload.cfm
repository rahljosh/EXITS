<!--- ------------------------------------------------------------------------- ----
	
	File:		upload.cfm
	Author:		Marcus Melo
	Date:		July 01, 2010
	Desc:		This file is called from _documents to upload application files
	
	Update:		09/20/2011 - Session information has not been passed in some cases 
				so I decided to pass the variables via URL.
	
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Param Variables --->
    <cfparam name="URL.foreignTable" default="#APPLICATION.foreignTable#"> <!--- extra_candidates --->
    <cfparam name="URL.foreignID" default="0"> <!--- #APPLICATION.CFC.CANDIDATE.getCandidateID()# --->
	<cfparam name="URL.uploadPath" default="">

    <cfscript>
		// APPLICATION.CFC.CANDIDATE.getCandidateSession().myUploadFolder
	
		// Decrypt Variables 
		URL.foreignID = URLDecode(URL.foreignID);
		URL.uploadPath = URLDecode(URL.uploadPath);
	</cfscript>		
    
</cfsilent>


<cfscript>
    if ( structKeyExists(FORM, "fileData") AND VAL(URL.foreignID) AND LEN(URL.uploadPath) ) {
    
        // Upload Document		
        APPLICATION.CFC.DOCUMENT.upload(
            foreignTable=URL.foreignTable,
            foreignID=URL.foreignID,
            formField=FORM.fileData,
            uploadPath=URL.uploadPath
        );
    
	}
	
	// We must pass this back otherwise it won't upload multiple files.
	str.STATUS = 200;
	str.MESSAGE = "passed";
	WriteOutput(serializeJSON(str));
</cfscript>