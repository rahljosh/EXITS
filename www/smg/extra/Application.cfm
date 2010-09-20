<cfapplication 
	name="extra" 
    clientmanagement="yes" 
    sessionmanagement="yes" 
    sessiontimeout="#CreateTimeSpan(0,3,0,0)#">
    
    <CFQUERY name="selectdb" datasource="MySQL" >
        USE smg
    </CFQUERY>
    
	<cfparam name="APPLICATION.applicationID" default="0">
    
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
    
	<cfscript>
        // Check if we need to initialize Application scope
		if ( VAL(URL.init) ) {
			// Clear the Application structure	
			StructClear(APPLICATION);	
		}
		
		// Create a function that let us create CFCs from any location
		function CreateCFC(strCFCName){
            return(CreateObject("component", ("extensions.components." & ARGUMENTS.strCFCName)));
        }


		// Store User Defined Functions
		APPLICATION.UDF = StructNew();
		APPLICATION.UDF.CreateCFC = CreateCFC;
	
	
		// Set up DSN information
		APPLICATION.DSN = StructNew();
		APPLICATION.DSN.Source = "mySql";
		APPLICATION.DSN.Username = "";
		APPLICATION.DSN.Password = "";

		
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
			APPLICATION.SITE.URL.main = 'http://smg.local/extra/';
			APPLICATION.SITE.URL.activation = 'http://smg.local/extra/accountActivation.cfm';
			
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
