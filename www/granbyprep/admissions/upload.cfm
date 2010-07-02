<!--- ------------------------------------------------------------------------- ----
	
	File:		upload.cfm
	Author:		Marcus Melo
	Date:		July 01, 2010
	Desc:		This file is called from _documents to upload application files

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Param Variables --->
    <cfparam name="URL.foreignTable" default="student">
    <cfparam name="URL.foreignID" default="">
	
</cfsilent>

<cfif structKeyExists(FORM, "fileData")>
	
    <cfscript>
		// Upload Document		
		APPLICATION.CFC.DOCUMENT.upload(
			foreignTable=URL.foreignTable,
			foreignID=APPLICATION.CFC.STUDENT.getStudentID(),
			formField=FORM.fileData,
			uploadPath=SESSION.STUDENT.myUploadFolder
		);
	</cfscript>
    
</cfif>

<cfscript>
	// We must pass this back otherwise it won't upload multiple files.
	str.STATUS = 200;
	str.MESSAGE = "passed";
	WriteOutput(serializeJSON(str));
</cfscript>
