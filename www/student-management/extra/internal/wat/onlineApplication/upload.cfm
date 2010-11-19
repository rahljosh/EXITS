<!--- ------------------------------------------------------------------------- ----
	
	File:		upload.cfm
	Author:		Marcus Melo
	Date:		July 01, 2010
	Desc:		This file is called from _documents to upload application files

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Param Variables --->
    <cfparam name="URL.foreignTable" default="#APPLICATION.foreignTable#">
    <cfparam name="URL.foreignID" default="">
	
</cfsilent>


<cfscript>
    if ( structKeyExists(FORM, "fileData") ) {
    
        // Upload Document		
        APPLICATION.CFC.DOCUMENT.upload(
            foreignTable=URL.foreignTable,
            foreignID=APPLICATION.CFC.CANDIDATE.getCandidateID(),
            formField=FORM.fileData,
            uploadPath=APPLICATION.CFC.CANDIDATE.getCandidateSession().myUploadFolder
        );
    
	}
	
	// We must pass this back otherwise it won't upload multiple files.
	str.STATUS = 200;
	str.MESSAGE = "passed";
	WriteOutput(serializeJSON(str));
</cfscript>