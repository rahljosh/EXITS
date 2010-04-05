<cfapplication
	name="extra" 
    clientmanagement="yes" 
    sessionmanagement="yes" 
    sessiontimeout="#CreateTimeSpan(0,10,40,1)#">
    
	<cfscript>
        // Stores Into & CSB Information
        APPLICATION.Constants = StructNew();
        
        APPLICATION.INTO = StructNew();		
        APPLICATION.INTO.name = "Into EdVentures";
		APPLICATION.INTO.programName = "Into EdVentures Work And Travel";
		APPLICATION.INTO.shortProgramName = "INTO WAT";
		APPLICATION.INTO.programNumber = "P-3-06010";
		APPLICATION.INTO.toolFreePhone = "1-888-INTO USA";
		APPLICATION.INTO.phone = "(631) 893-8059";
		APPLICATION.INTO.phoneIDCard = "1-888-468-6872";
		APPLICATION.INTO.logo = "2.gif";
		APPLICATION.INTO.smallLogo = "2.gif";
	
		// Set CSB Information
        APPLICATION.CSB = StructNew();		
		APPLICATION.CSB.name = "CSB International, Inc.";
		APPLICATION.CSB.programName = "Summer Work Travel Program";
		APPLICATION.CSB.shortProgramName = "CSB SWT";
        APPLICATION.CSB.programNumber = "P-4-13299";
		APPLICATION.CSB.toolFreePhone = "1-877-669-0717";
		APPLICATION.CSB.phone = "(631) 893-4549";
		APPLICATION.CSB.phoneIDCard = "1-877-669-0717";
		APPLICATION.CSB.logo = "8.gif";
		APPLICATION.CSB.smallLogo = "8s.gif";

		/***** Create APPLICATION.PATH structure *****/
		APPLICATION.PATH = StructNew();		

		// Set a short name for the APPLICATION.PATH
        AppPath = APPLICATION.PATH;
    
        // Base Path eg. C:\websites\smg\nsmg\
        AppPath.base = getDirectoryFromPath(getBaseTemplatePath());

		// Remove the last item from Base (trainee, h2b or wat)
		AppPath.base = ListDeleteAt(AppPath.base, ListLen(APPPath.base, '\'), '\') & '/';

		AppPath.uploadedFiles = AppPath.base & 'uploadedfiles/';
        AppPath.pdfDocs = AppPath.uploadedFiles & 'pdf_docs/wat/';
		AppPath.candidatePicture = AppPath.uploadedFiles & "web-candidates/";
		AppPath.hostLogo = AppPath.uploadedFiles & "web-hostlogo/";
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