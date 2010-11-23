<cfapplication
	name="ISEUSA" 
    clientmanagement="yes" 
    sessionmanagement="yes" 
    sessiontimeout="#CreateTimeSpan(0,4,0,0)#">

	<!----
	<cferror type="EXCEPTION" template="AlertForm.cfm">
    
    <cferror type="REQUEST" template="AlertForm.cfm">  
	---->

    <!--- Param URL variable --->
	<cfparam name="URL.init" default="0">


	<!--- Param Client Variables --->
	<cfparam name="CLIENT.hostID" default="0">
	<cfparam name="CLIENT.name" default="">
    <cfparam name="CLIENT.email" default="">
    <cfparam name="CLIENT.isAdWords" default="0">  


	<cfscript>
		// Create a function that let us create CFCs from any location
		function CreateCFC(strCFCName){
			return(CreateObject("component", ("extensions.components." & ARGUMENTS.strCFCName)));
		}

		// Page Messages
		SESSION.PageMessages = CreateCFC("pageMessages").Init();
		
		// Form Errors
		SESSION.formErrors = CreateCFC("formErrors").Init();

		// Set up DSN information
		APPLICATION.DSN = StructNew();
		APPLICATION.DSN.Source = "mySql";
		APPLICATION.DSN.Username = "";
		APPLICATION.DSN.Password = "";
		
		
		// Set up SETTINGS
		APPLICATION.SETTINGS = StructNew();
		APPLICATION.SETTINGS.IPInfoDBKey = '0fc7fb53672eaf186d2c41db1c9b63224ef8f31e0270d8c351d2097794352bfb';

		/***** Create APPLICATION.CFC structure *****/
		APPLICATION.CFC = StructNew();
	
		// Set a short name for the CFCs
		AppCFC = APPLICATION.CFC;
	
		// Store the initialized metadata Library object in the Application scope
		AppCFC.metadata = CreateCFC("metadata").Init();


		// Site URL
		APPLICATION.siteURL = 'http://' & CGI.HTTP_HOST & '/';


		/* jQuery Latest Version 
		http://code.jquery.com/jquery-latest.min.js
		http://code.jquery.com/jquery.js
		*/		
		APPLICATION.PATH = StructNew();
		APPLICATION.PATH.jQuery = 'http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js';
		

		/***** Create APPLICATION.EMAIL structure *****/
		APPLICATION.EMAIL = StructNew();		
	
		// Set a short name for the APPLICATION.EMAIL
		AppEmail = APPLICATION.EMAIL;

		AppEmail.support = 'support@iseusa.com';
		AppEmail.finance = 'marcel@iseusa.com';
		AppEmail.errors = 'errors@student-management.com';
		AppEmail.hostLead = 'bob@iseusa.com;lamonica@iseusa.com';

		
		// APPLICATION.QUERY should persist in the application scope. 
		if ( NOT StructKeyExists(APPLICATION, 'QUERY') OR VAL(URL.init) ) {
			
			/***** Create APPLICATION.QUERY structure - This will hold queries that are used in the database and do not change frequently *****/
			APPLICATION.Query = StructNew();
			// Set the reference to the struct
			Query = APPLICATION.Query;
			
			// Store metadata in the application scope since we call on every request
			Query.qMetadata = AppCFC.metadata.getMetadataBySite();
			Query.test = now();
			
		}
			

		/***** Constants *****/
		APPLICATION.Constants = StructNew();
		// Set the reference to the struct
		Constants = APPLICATION.Constants;
		
		// Set up constant for host lead application
		Constants.hearAboutUs = ArrayNew(1);		
		Constants.hearAboutUs[1] = "Google Search";
		Constants.hearAboutUs[2] = "Printed Material";
		Constants.hearAboutUs[3] = "Friend / Acquaintance";
		Constants.hearAboutUs[4] = "ISE Representative";
		Constants.hearAboutUs[5] = "Church Group";
		Constants.hearAboutUs[6] = "Other";
		// ArrayAppend(Constants.hearAboutUs, "Other");
		
		
		/***** Metadata *****/
		APPLICATION.MetaData = StructNew();
		// Set the reference to the struct
		MetaData = APPLICATION.MetaData;
		
		// Get Metadata for current page
		qGetMetadata = AppCFC.metadata.getPageMetadata(URL=CGI.SCRIPT_NAME); 
		
		// Set up the Application Meta Data
		MetaData.pageTitle = qGetMetadata.pageTitle;
		MetaData.pageDescription = qGetMetadata.pageDescription;
		MetaData.pageKeywords = qGetMetadata.pageKeywords;
    </cfscript>