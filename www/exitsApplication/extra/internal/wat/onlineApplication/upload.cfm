<!--- ------------------------------------------------------------------------- ----
	
	File:		upload.cfm
	Author:		Marcus Melo
	Date:		July 01, 2010
	Desc:		This file is called from _documents to upload application files
	
	Update:		09/20/2011 - Session information has not been passed in some cases 
				so I decided to pass the variables via URL.
	
----- ------------------------------------------------------------------------- --->

<cfscript>
    // Upload Document	
	APPLICATION.CFC.DOCUMENT.upload(
		foreignTable="extra_hostCompany",
		foreignID=5250,
		uploadPath="#APPLICATION.PATH.uploadedFiles#hostCompany/#URL.hostCompanyID#/",
		documentTypeID=42);
</cfscript>