<cfapplication
	name="extra" 
    clientmanagement="yes" 
    sessionmanagement="yes" 
    sessiontimeout="#CreateTimeSpan(0,3,0,0)#">

    <!--- Param Application variables --->
	<cfparam name="APPLICATION.applicationID" default="0">
	<cfparam name="APPLICATION.foreignTable" default="">

	<!--- Param URL variables --->
	<cfparam name="URL.init" default="0">
	<cfparam name="URL.link" default="">
	
    <!--- Param CLIENT variables --->
    <cfparam name="CLIENT.isLoggedIn" default="">
    <cfparam name="CLIENT.loginType" default="">
    
    <!--- User Specific --->
	<cfparam name="CLIENT.companyID" default="0">    
    <cfparam name="CLIENT.userType" default="">
    <cfparam name="CLIENT.userID" default=""> 
    <cfparam name="CLIENT.firstName" default="">  
    <cfparam name="CLIENT.lastname" default="">  
    <cfparam name="CLIENT.lastLogin" default="">  
    <cfparam name="CLIENT.email" default="">     
    
    <!--- SESSION Variables --->
    <cfparam name="SESSION.CANDIDATE.companyID" default="0">
    <cfparam name="SESSION.CANDIDATE.isLoggedIn" default="0">
    <cfparam name="SESSION.CANDIDATE.ID" default="0">
    <cfparam name="SESSION.CANDIDATE.applicationStatusID" default="0">
    <cfparam name="SESSION.CANDIDATE.firstName" default="">
    <cfparam name="SESSION.CANDIDATE.lastName" default="">
    <cfparam name="SESSION.CANDIDATE.email" default="">
    <cfparam name="SESSION.CANDIDATE.dateLastLoggedIn" default="">
    <cfparam name="SESSION.CANDIDATE.isReadOnly" default="0">
    <cfparam name="SESSION.CANDIDATE.isSection1Complete" default="0">
    <cfparam name="SESSION.CANDIDATE.section1FieldList" default="">
    <cfparam name="SESSION.CANDIDATE.isSection2Complete" default="0">
    <cfparam name="SESSION.CANDIDATE.section2FieldList" default="">
    <cfparam name="SESSION.CANDIDATE.isSection3Complete" default="0">
    <cfparam name="SESSION.CANDIDATE.section3FieldList" default="">
    <cfparam name="SESSION.CANDIDATE.intlRepID" default="0">
    <cfparam name="SESSION.CANDIDATE.branchID" default="0">
    <cfparam name="SESSION.CANDIDATE.intlRepName" default="">
    
	<cfscript>
		// Check if we need to initialize Application scope
		if ( VAL(URL.init) ) {
			// Clear the Application structure	
			StructClear(APPLICATION);	
		}
	
        // Stores Into & CSB Information
        APPLICATION.Constants = StructNew();
        
		// Work and Travel ID
		APPLICATION.applicationID = 4;
		
		// Set Foreign Table
		APPLICATION.foreignTable = 'extra_candidates';
		
		// Set APPLICATION.CSB if it does not exist
		if ( NOT StructKeyExists(APPLICATION, 'CSB') ) {
			// Stores Company Information
			APPLICATION.CSB = StructNew();	
			
			// SET CSB Default Information
			APPLICATION.CSB.name = "CSB International, Inc.";
			APPLICATION.CSB.phone = "(631) 893-4549";
			APPLICATION.CSB.toolFreePhone = "1-877-669-0717";		
			APPLICATION.CSB.address = '119 Cooper Street';
			APPLICATION.CSB.city = 'Babylon';
			APPLICATION.CSB.state = 'NY';
			APPLICATION.CSB.zipCode = '11702';
			
			// Set CSB WAT Information
			APPLICATION.CSB.WAT = StructNew();		
			APPLICATION.CSB.WAT.name = "CSB International, Inc.";
			APPLICATION.CSB.WAT.programName = "Summer Work Travel Program";
			APPLICATION.CSB.WAT.shortProgramName = "CSB SWT";
			APPLICATION.CSB.WAT.programNumber = "P-4-13299";
			APPLICATION.CSB.WAT.phone = "(631) 893-4549";
			APPLICATION.CSB.WAT.toolFreePhone = "1-877-669-0717";		
			APPLICATION.CSB.WAT.phoneIDCard = "1-877-669-0717";
			APPLICATION.CSB.WAT.logo = "8.gif";
			APPLICATION.CSB.WAT.smallLogo = "8s.gif";
			APPLICATION.CSB.WAT.address = '119 Cooper Street';
			APPLICATION.CSB.WAT.city = 'Babylon';
			APPLICATION.CSB.WAT.state = 'NY';
			APPLICATION.CSB.WAT.zipCode = '11702';

			// Set INTO Information
			APPLICATION.CSB.INTO = StructNew();		
			APPLICATION.CSB.INTO.name = "Into EdVentures";
			APPLICATION.CSB.INTO.programName = "Into EdVentures Work &amp; Travel";
			APPLICATION.CSB.INTO.shortProgramName = "INTO WAT";
			APPLICATION.CSB.INTO.programNumber = "P-3-06010";
			APPLICATION.CSB.INTO.phone = "(631) 893-8059";
			APPLICATION.CSB.INTO.toolFreePhone = "1-888-INTO USA";
			APPLICATION.CSB.INTO.phoneIDCard = "1-888-468-6872";
			APPLICATION.CSB.INTO.logo = "2.gif";
			APPLICATION.CSB.INTO.smallLogo = "2.gif";
			APPLICATION.CSB.INTO.address = '119 Cooper Street';
			APPLICATION.CSB.INTO.city = 'Babylon';
			APPLICATION.CSB.INTO.state = 'NY';
			APPLICATION.CSB.INTO.zipCode = '11702';

			// Set CSB Trainee Information
			APPLICATION.CSB.Trainee = StructNew();		
			APPLICATION.CSB.Trainee.name = "CSB International, Inc.";
			APPLICATION.CSB.Trainee.programName = "Trainee Program";
			APPLICATION.CSB.Trainee.shortProgramName = "CSB Trainee";
			APPLICATION.CSB.Trainee.programNumber = "";
			APPLICATION.CSB.Trainee.phone = "(631) 893-4549";
			APPLICATION.CSB.Trainee.toolFreePhone = "1-877-669-0717";		
			APPLICATION.CSB.Trainee.phoneIDCard = "1-877-669-0717";
			APPLICATION.CSB.Trainee.logo = "7.gif";
			APPLICATION.CSB.Trainee.smallLogo = "7s.gif";
			APPLICATION.CSB.Trainee.address = '119 Cooper Street';
			APPLICATION.CSB.Trainee.city = 'Babylon';
			APPLICATION.CSB.Trainee.state = 'NY';
			APPLICATION.CSB.Trainee.zipCode = '11702';
		}


		// Set APPLICATION.CSB if it does not exist
		if ( NOT StructKeyExists(APPLICATION, 'METADATA') ) {
			
			/***** Create APPLICATION.METADATA structure / Stores Default Metadata Information *****/
			APPLICATION.METADATA = StructNew();		
			// Set up a short name for APPLICATION.METADATA
			AppMetadata = APPLICATION.METADATA;
			
			// SET CSB Default Information
			AppMetadata.pageTitle = 'CSB International, Inc.';
			AppMetadata.pageDescription = '';
			AppMetadata.pageKeywords = 'Trainee Program, Work and Travel Program, Work Experience';
			
			// Set CSB Trainee Information
			AppMetadata.Trainee.pageTitle = 'CSB International, Inc. - Trainee Program';
			AppMetadata.Trainee.pageDescription = '';
			AppMetadata.Trainee.pageKeywords = 'Trainee Program';

			// Set CSB WAT Information
			AppMetadata.WAT.pageTitle = 'CSB International, Inc. - Summer Work and Travel Program';
			AppMetadata.WAT.pageDescription = '';
			AppMetadata.WAT.pageKeywords = 'Work and Travel Program';
		}


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
