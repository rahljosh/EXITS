<cfapplication 
	name="extra" 
    clientmanagement="yes" 
    sessionmanagement="yes" 
    sessiontimeout="#CreateTimeSpan(0,10,40,1)#">

    <cfscript>
		/***** Create APPLICATION.PATH structure *****/
		APPLICATION.PATH = StructNew();		
	
        // Set a short name for the APPLICATION.PATH
        AppPath = APPLICATION.PATH;
    
        // Base Path eg. C:\websites\student-management\extra\internal\trainee\ 
        AppPath.base = getDirectoryFromPath(getBaseTemplatePath());
    		
		// Remove the last item from Base (trainee, h2b or wat)
		AppPath.base = ListDeleteAt(AppPath.base, ListLen(APPPath.base, '\'), '\') & '/';

        AppPath.uploadedFiles = AppPath.base & 'uploadedfiles/';
        AppPath.pdfDocs = AppPath.uploadedFiles & 'pdf_docs/trainee/';
		
		// These are one level up
		AppPath.baseRoot = AppPath.base; 
		AppPath.baseRoot = ReplaceNoCase(AppPath.baseRoot, 'trainee/', '');
		AppPath.baseRoot = ReplaceNoCase(AppPath.baseRoot, 'candidate/', '');
		AppPath.baseRoot = ReplaceNoCase(AppPath.baseRoot, 'hostcompany/', '');

		AppPath.candidatePicture = AppPath.baseRoot & "uploadedfiles/web-candidates/";
		AppPath.hostLogo = AppPath.baseRoot & "uploadedfiles/web-hostlogo/";
    </cfscript>
    
    <CFQUERY name="selectdb" datasource="MySQL" >
        USE smg
    </CFQUERY>
    
    <link rel="SHORTCUT ICON" href="pics/favicon.ico">

    <cfif IsDefined('url.client.usertype')>
        You do not have rights to see this page.
        <cfabort>
    </cfif>
    
    <cfif IsDefined('url.client.userid')>
        You do not have rights to see this page.
        <cfabort>
    </cfif>
    
    <cfif IsDefined('url.client.companyid')>
        You do not have rights to see this page.
        <cfabort>
    </cfif>
    
    <cfif NOT IsDefined('client.usertype')>
        You must log in to view this page.
        <cfabort>
    </cfif>
    
