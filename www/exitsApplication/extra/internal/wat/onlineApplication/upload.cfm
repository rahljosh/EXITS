<!--- ------------------------------------------------------------------------- ----
	
	File:		upload.cfm
	Author:		Marcus Melo
	Date:		July 01, 2010
	Desc:		This file is called from _documents to upload application files
	
	Update:		09/20/2011 - Session information has not been passed in some cases 
				so I decided to pass the variables via URL.
	
----- ------------------------------------------------------------------------- --->

<cfscript>
    if ( structKeyExists(FORM, "fileData") ) {

        // Upload Document		
        APPLICATION.CFC.DOCUMENT.upload(
            foreignTable="extra_candidates",
            foreignID=APPLICATION.CFC.CANDIDATE.getCandidateID(),
            uploadPath=APPLICATION.CFC.CANDIDATE.getCandidateSession().myUploadFolder
        );
    
	}
	
	// We must pass this back otherwise it won't upload multiple files.
	str.STATUS = 200;
	str.MESSAGE = "passed";
	WriteOutput(serializeJSON(str));
</cfscript>