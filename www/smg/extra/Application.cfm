<cfapplication 
	name="extra" 
    clientmanagement="yes" 
    sessionmanagement="yes" 
    sessiontimeout="#CreateTimeSpan(0,3,0,0)#">
    
    <CFQUERY name="selectdb" datasource="MySQL" >
        USE smg
    </CFQUERY>
    
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
		// Create a function that let us create CFCs from any location
		function CreateCFC(strCFCName){
            return(CreateObject("component", ("extensions.components." & ARGUMENTS.strCFCName)));
        }


		// Check if we need to initialize Application scope
		if ( VAL(URL.init) ) {
			// Clear the Application structure	
			StructClear(APPLICATION);	
		}
		
		
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
		

		// Store User Defined Functions
		APPLICATION.UDF = StructNew();
		APPLICATION.UDF.CreateCFC = CreateCFC;
	
	
		// Set up DSN information
		APPLICATION.DSN = StructNew();
		APPLICATION.DSN.Source = "mySql";
		APPLICATION.DSN.Username = "";
		APPLICATION.DSN.Password = "";


		// Set APPLICATION.CFC if it does not exist
		if ( NOT StructKeyExists(APPLICATION, 'CFC') ) {
			/***** Create APPLICATION.CFC structure *****/
			APPLICATION.CFC = StructNew();
			
			// Set a short name for the APPLICATION.CFC
			AppCFC = APPLICATION.CFC;
	
			// Store the initialized UDF Library object in the Application scope
			AppCFC.UDF = CreateCFC("udf").Init();
			
			// Store Application.IsServerLocal - This needs be declare before the other CFC components
			APPLICATION.IsServerLocal = APPLICATION.CFC.UDF.IsServerLocal();
			
			// Store the initialized candidate Library object in the Application scope
			AppCFC.candidate = CreateCFC("candidate").Init();
	
			// Store the initialized content Library object in the Application scope
			AppCFC.content = CreateCFC("content").Init();
	
			// Store the initialized document Library object in the Application scope
			AppCFC.document = CreateCFC("document").Init();
	
			// Store the initialized email Library object in the Application scope
			AppCFC.email = CreateCFC("email").Init();
	
			// Store the initialized lookUpTables Library object in the Application scope
			AppCFC.lookUpTables = CreateCFC("lookUpTables").Init();
	
			// Store the initialized onlineApp Library object in the Application scope
			AppCFC.onlineApp = CreateCFC("onlineApp").Init();
	
			// Store the initialized User Library object in the Application scope
			AppCFC.user = CreateCFC("user").Init();
		}


		/***** Create APPLICATION.SITE structure *****/
		APPLICATION.SITE = StructNew();		
		// Set a short name for the APPLICATION.SITE
		AppSite = APPLICATION.SITE;	
		// Create new structure to store site information
		AppSite = APPLICATION.SITE.URL = StructNew();	


		/***** Create APPLICATION.EMAIL structure / Stores Email Information *****/
		APPLICATION.EMAIL = StructNew();		
		// Set up a short name for the APPLICATION.EMAIL
		AppEmail = APPLICATION.EMAIL;


		/***** Create APPLICATION.PATH structure *****/
		APPLICATION.PATH = StructNew();		
		// Set a short name for the APPLICATION.PATH
		AppPath = APPLICATION.PATH;


		// Check if this is Dev or Live 
		if ( APPLICATION.isServerLocal ) {
			// ***** DEVELOPMENT Server Settings *****
	
			// Set Site URL
			APPLICATION.SITE.URL.main = 'http://brazil/extra/';
			APPLICATION.SITE.URL.activation = 'http://brazil/extra/accountActivation.cfm';
			//APPLICATION.SITE.URL.main = 'http://smg.local/extra/';
			//APPLICATION.SITE.URL.activation = 'http://smg.local/extra/accountActivation.cfm';
			
			// Email Settings
			AppEmail.contactUs = 'marcus@iseusa.com';
			AppEmail.support = 'marcus@iseusa.com';
			AppEmail.errors = 'marcus@iseusa.com';

			// AppPath.base = getDirectoryFromPath(getBaseTemplatePath());	'
			AppPath.base = 'C:/Websites/www/smg/extra/internal/';
			
		} else {
			// ***** PRODUCTION Server Settings *****

			// Set Site URL
			APPLICATION.SITE.URL.main = 'http://www.student-management.com/extra';
			APPLICATION.SITE.URL.activation = 'http://www.student-management.com/extra/accountActivation.cfm';
			
			// Email Settings
			AppEmail.contactUs = 'info@csb-usa.com';
			AppEmail.support = 'support@student-management.com';
			AppEmail.errors = 'errors@student-management.com';

			// AppPath.base = getDirectoryFromPath(getBaseTemplatePath());	'
			AppPath.base = 'C:/Websites/student-management/extra/internal/';
			
		}


		// Page Messages
		SESSION.PageMessages = CreateCFC("pageMessages").Init();
		
		// Form Errors
		SESSION.formErrors = CreateCFC("formErrors").Init();


		/***************
			Set up folders used to uplaod documents in the application.
		***************/
		
		// Document Root
		AppPath.UploadDocumentRoot = AppPath.base & "uploadedFiles/";
		
		// Candidate Picture
		AppPath.uploadCandidatePicture = AppPath.UploadDocumentRoot & "web-candidates/";
		
		// Candidate Application Files		
		AppPath.uploadDocumentCandidate = AppPath.UploadDocumentRoot & "candidate/";
		
		// Temp Folder 
		AppPath.uploadDocumentTemp = AppPath.UploadDocumentRoot & "temp/";
	
		// Make sure folder exists
		APPLICATION.CFC.DOCUMENT.createFolder(AppPath.UploadDocumentRoot);
		APPLICATION.CFC.DOCUMENT.createFolder(AppPath.uploadCandidatePicture);
		APPLICATION.CFC.DOCUMENT.createFolder(AppPath.uploadDocumentCandidate);	
		APPLICATION.CFC.DOCUMENT.createFolder(AppPath.uploadDocumentTemp);	
		
		/* jQuery Latest Version 
		http://code.jquery.com/jquery-latest.min.js  /  http://code.jquery.com/jquery.js */		
		AppPath.jQuery = 'https://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js';	
		AppPath.jQueryUI = 'https://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js';
		AppPath.jQueryTheme = 'https://ajax.googleapis.com/ajax/libs/jqueryui/1.7.2/themes/excite-bike/jquery-ui.css';
	</cfscript>
