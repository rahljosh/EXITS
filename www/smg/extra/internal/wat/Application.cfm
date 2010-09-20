<cfapplication
	name="extra" 
    clientmanagement="yes" 
    sessionmanagement="yes" 
    sessiontimeout="#CreateTimeSpan(0,10,40,1)#">
    
	<cfscript>
        // Stores Into & CSB Information
        APPLICATION.Constants = StructNew();
        
		// Work and Travel ID
		APPLICATION.applicationID = 4;
		
		// Set INTO Information
        APPLICATION.INTO = StructNew();		
        APPLICATION.INTO.name = "Into EdVentures";
		APPLICATION.INTO.programName = "Into EdVentures Work &amp; Travel";
		APPLICATION.INTO.shortProgramName = "INTO WAT";
		APPLICATION.INTO.programNumber = "P-3-06010";
		APPLICATION.INTO.phone = "(631) 893-8059";
		APPLICATION.INTO.toolFreePhone = "1-888-INTO USA";
		APPLICATION.INTO.phoneIDCard = "1-888-468-6872";
		APPLICATION.INTO.logo = "2.gif";
		APPLICATION.INTO.smallLogo = "2.gif";
		APPLICATION.INTO.address = '119 Cooper Street';
		APPLICATION.INTO.city = 'Babylon';
		APPLICATION.INTO.state = 'NY';
		APPLICATION.INTO.zipCode = '11702';

		// Set CSB Information
        APPLICATION.CSB = StructNew();		
		APPLICATION.CSB.name = "CSB International, Inc.";
		APPLICATION.CSB.programName = "Summer Work Travel Program";
		APPLICATION.CSB.shortProgramName = "CSB SWT";
        APPLICATION.CSB.programNumber = "P-4-13299";
		APPLICATION.CSB.phone = "(631) 893-4549";
		APPLICATION.CSB.toolFreePhone = "1-877-669-0717";		
		APPLICATION.CSB.phoneIDCard = "1-877-669-0717";
		APPLICATION.CSB.logo = "8.gif";
		APPLICATION.CSB.smallLogo = "8s.gif";
		APPLICATION.CSB.address = '119 Cooper Street';
		APPLICATION.CSB.city = 'Babylon';
		APPLICATION.CSB.state = 'NY';
		APPLICATION.CSB.zipCode = '11702';


		/***** Create APPLICATION.METADATA structure / Stores Default Metadata Information *****/
		APPLICATION.METADATA = StructNew();		
		// Set up a short name for APPLICATION.METADATA
		AppMetadata = APPLICATION.METADATA;

		AppMetadata.pageTitle = 'CSB International, Inc. - Summer Work Travel Program';
		AppMetadata.pageDescription = '';
		AppMetadata.pageKeywords = 'Work and Travel';
		

        // Base Path eg. C:\websites\smg\nsmg\
        // AppPath.base = getDirectoryFromPath(getBaseTemplatePath());
		AppPath.base = 'C:/Websites/www/smg/extra/internal/';
		// Remove the last item from Base (trainee, h2b or wat)
		// AppPath.base = ListDeleteAt(AppPath.base, ListLen(APPPath.base, '\'), '\') & '/';

		// DELETE THESE 
		AppPath.uploadedFiles = AppPath.base & 'uploadedfiles/';
        AppPath.pdfDocs = AppPath.uploadedFiles & 'pdf_docs/wat/';
		AppPath.candidatePicture = AppPath.uploadedFiles & "web-candidates/";
		AppPath.hostLogo = AppPath.uploadedFiles & "web-hostlogo/";
    </cfscript>
    
    <cfscript>
		// Check User Rights
		if ( CLIENT.loginType EQ 'user' ) { 
			
			if ( NOT VAL(CLIENT.userType) OR NOT VAL(CLIENT.userID) OR NOT VAL(CLIENT.companyID) ) {
				
				WriteOutput('You do not have rights to see this page.');
				abort;
				
			}
			
		}
	</cfscript>
