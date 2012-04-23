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


		/*******************************************
			Set up DSN information
		*******************************************/
		APPLICATION.DSN = StructNew();
		APPLICATION.DSN.Source = "mySql";
		APPLICATION.DSN.Username = "";
		APPLICATION.DSN.Password = "";
		
		
		/*******************************************
			Set up SETTINGS
		*******************************************/
		APPLICATION.SETTINGS = StructNew();
		APPLICATION.SETTINGS.IPInfoDBKey = '0fc7fb53672eaf186d2c41db1c9b63224ef8f31e0270d8c351d2097794352bfb';
		
		// Key for Encrypt/Decrypt Strings
		APPLICATION.SETTINGS.encryptKey = 'BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR';
		
		
		/*******************************************
			Create APPLICATION.CFC structure 
		*******************************************/
		APPLICATION.CFC = StructNew();
	
		// Set a short name for the CFCs
		AppCFC = APPLICATION.CFC;

		// Store the initialized UDF Library object in the Application scope
		APPLICATION.CFC.UDF = CreateCFC("udf").Init();
		
		// Store Application.IsServerLocal - This needs be declare before the other CFC components
		APPLICATION.IsServerLocal = APPLICATION.CFC.UDF.IsServerLocal();

		// Store the initialized CBC Library object in the Application scope
		APPLICATION.CFC.CBC = CreateCFC("cbc").Init();

		// Store the initialized Company Library object in the Application scope
		APPLICATION.CFC.CBC = CreateCFC("company").Init();

		// Store the initialized host Library object in the Application scope
		APPLICATION.CFC.HOST = CreateCFC("host").Init();

		// Store the initialized lookUpTables Library object in the Application scope
		APPLICATION.CFC.LOOKUPTABLES = CreateCFC("lookUpTables").Init();

		// Store the initialized metadata Library object in the Application scope
		APPLICATION.CFC.metadata = CreateCFC("metadata").Init();

		// Store the initialized paymentGateway Library object in the Application scope
		APPLICATION.CFC.paymentGateway = CreateCFC("paymentGateway").Init();

		// Store the initialized UDF Library object in the Application scope
		APPLICATION.CFC.UDF = CreateCFC("udf").Init();

		// Store the initialized session Library object in the Application scope
		APPLICATION.CFC.SESSION = CreateCFC("session").Init();


		/*******************************************
			Site URL
		*******************************************/
		APPLICATION.siteURL = 'http://' & CGI.HTTP_HOST & '/';


		/*******************************************
			jQuery Latest Version 
			http://code.jquery.com/jquery-latest.min.js
			http://code.jquery.com/jquery.js
		*******************************************/
		APPLICATION.PATH = StructNew();
		/* jQuery Latest Version 
		http://code.jquery.com/jquery-latest.min.js  /  http://code.jquery.com/jquery.js */		
		APPLICATION.PATH.jQuery = 'https://ajax.googleapis.com/ajax/libs/jquery/1.5.1/jquery.min.js';	
		APPLICATION.PATH.jQueryUI = 'https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.6/jquery-ui.min.js';
		APPLICATION.PATH.jQueryTheme = 'https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.6/themes/excite-bike/jquery-ui.css';
		// 	APPLICATION.PATH.jQueryTheme = 'https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.6/themes/redmond/jquery-ui.css';


		// Local Enviroment
		if ( APPLICATION.isServerLocal ) {
			// Production
			APPLICATION.PATH.TEMP = 'C:/websites/www/student-management/nsmg/uploadedfiles/temp/';
			APPLICATION.PATH.tour = 'C:/websites/www/student-management/nsmg/uploadedfiles/tours/';
			// Trips URL
			APPLICATION.tripsURL = 'http://trips.local/';
		} else {
			// Production
			APPLICATION.PATH.TEMP = 'C:/websites/student-management/nsmg/uploadedfiles/temp/';
			APPLICATION.PATH.tour = 'C:/websites/student-management/nsmg/uploadedfiles/tours/';
			// Trips URL
			APPLICATION.tripsURL = 'https://trips.exitsapplication.com/';
		}


		/*******************************************
			Create APPLICATION.EMAIL structure
		*******************************************/
		APPLICATION.EMAIL = StructNew();		
	
		// Set a short name for the APPLICATION.EMAIL
		AppEmail = APPLICATION.EMAIL;

		APPLICATION.EMAIL.support = 'support@iseusa.com';
		APPLICATION.EMAIL.finance = 'marcel@iseusa.com';
		APPLICATION.EMAIL.errors = 'errors@student-management.com';
		APPLICATION.EMAIL.hostLead = 'bob@iseusa.com;lamonica@iseusa.com';
		APPLICATION.EMAIL.trips = 'trips@iseusa.com';
		
		
		// APPLICATION.QUERY should persist in the application scope. 
		if ( NOT StructKeyExists(APPLICATION, 'QUERY') OR VAL(URL.init) ) {
			
			/***** Create APPLICATION.QUERY structure - This will hold queries that are used in the database and do not change frequently *****/
			APPLICATION.Query = StructNew();
			// Set the reference to the struct
			Query = APPLICATION.Query;
			
			// Store metadata in the application scope since we call on every request
			Query.qMetadata = AppCFC.metadata.getMetadataBySite();
			
			// Store the initialized session Library object in the Application scope
			APPLICATION.CFC.SESSION = CreateCFC("session").Init();
			
		}
			

		/*******************************************
			Constants
		*******************************************/
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
		

		//Set up constant for payment methods
		APPLICATION.Constants.paymentMethod = ArrayNew(1);		
		APPLICATION.Constants.paymentMethod[1] = "Credit Card";	
		/*
		APPLICATION.Constants.paymentMethod[2] = "Personal Check";
		APPLICATION.Constants.paymentMethod[3] = "Wire Transfer";
		APPLICATION.Constants.paymentMethod[4] = "Money Order";
		*/
	
		//Set up constant for credit card types
		APPLICATION.Constants.creditCardType = ArrayNew(1);		
		APPLICATION.Constants.creditCardType[1] = "American Express";
		APPLICATION.Constants.creditCardType[2] = "Discover";
		APPLICATION.Constants.creditCardType[3] = "MasterCard";
		APPLICATION.Constants.creditCardType[4] = "Visa";

		/*******************************************
			Metadata
		*******************************************/
		APPLICATION.MetaData = StructNew();
		// Set the reference to the struct
		MetaData = APPLICATION.MetaData;
		
		// Get Metadata for current page
		qGetMetadata = AppCFC.metadata.getPageMetadata(URL=CGI.SCRIPT_NAME); 
		
		// Set up the Application Meta Data
		APPLICATION.MetaData.pageTitle = qGetMetadata.pageTitle;
		APPLICATION.MetaData.pageDescription = qGetMetadata.pageDescription;
		APPLICATION.MetaData.pageKeywords = qGetMetadata.pageKeywords;
    </cfscript>