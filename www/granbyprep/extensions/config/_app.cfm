<!--- ------------------------------------------------------------------------- ----
	
	File:		_app.cfm
	Author:		Marcus Melo
	Date:		June, 14 2010
	Desc:		Sets App-related  variables such as web address, webmaster 
				email, company name, etc.

	Updated:  	

----- ------------------------------------------------------------------------- --->

<cfscript>
	// Store User Defined Functions
	APPLICATION.UDF = StructNew();
	APPLICATION.UDF.CreateCFC = CreateCFC;


	// Set up DSN information
	APPLICATION.DSN = StructNew();
	APPLICATION.DSN.Source = "GranbyPrep";
	APPLICATION.DSN.Username = "";
	APPLICATION.DSN.Password = "";


	/***** Create APPLICATION.SCHOOL structure / Stores School Information *****/
	APPLICATION.SCHOOL = StructNew();		
	APPLICATION.SCHOOL.name = 'The MacDuffie School';
	APPLICATION.SCHOOL.address = '66 School Street';
	APPLICATION.SCHOOL.city = 'Granby';
	APPLICATION.SCHOOL.state = 'MA';
	APPLICATION.SCHOOL.zipCode = '01033';
	APPLICATION.SCHOOL.tollFree = '(800) 766-4656';
	APPLICATION.SCHOOL.phone = '(413) 467-1601';
	
	// School Departments
	APPLICATION.SCHOOL.headMaster = 'Brian Chatterley ';
	APPLICATION.SCHOOL.admissions = 'Anneke Skidmore';

	
	/***** Create APPLICATION.SETTINGS structure / Stores System Information *****/
	APPLICATION.SETTINGS = StructNew();		
	APPLICATION.SETTINGS.adminToolVersion = 'AdminTool v.1.0';
	

	/***** Create APPLICATION.QUERY structure - This will hold queries that are used in the database and do not change frequently *****/
	APPLICATION.QUERY = StructNew();


	/***** Create APPLICATION.METADATA structure / Stores Default Metadata Information *****/
	APPLICATION.METADATA = StructNew();		
	
	// Set up a short name for APPLICATION.METADATA
	APPLICATION.METADATA = APPLICATION.METADATA;
	APPLICATION.METADATA.pageTitle = 'The MacDuffie School';
	APPLICATION.METADATA.pageDescription = '';
	APPLICATION.METADATA.pageKeywords = '';
	
	
	/***** Create APPLICATION.EMAIL structure / Stores Email Information *****/
	APPLICATION.EMAIL = StructNew();		


	/***** Create APPLICATION.PATH structure *****/
	APPLICATION.PATH = StructNew();		


	/***** Create APPLICATION.SITE structure *****/
	APPLICATION.SITE = StructNew();		
	// Create new structure to store site information
	APPLICATION.SITE = APPLICATION.SITE.URL = StructNew();	
	
	// Set Up Online Application URL
	APPLICATION.SITE.URL.httpHost = 'macduffie.exitsapplication.com';
	
	// Set Site URL
	APPLICATION.SITE.URL.main = 'http://' & CGI.SERVER_NAME;
	APPLICATION.SITE.URL.adminTool = APPLICATION.SITE.URL.main & '/admin';
	APPLICATION.SITE.URL.admissions = APPLICATION.SITE.URL.main & '/admissions';

	/***** Set Settings based on Live or Dev Servers *****/
	
	// Check if this is Dev or Live 
	if ( APPLICATION.isServerLocal ) {
		// ***** DEVELOPMENT Server Settings *****

		// Getting error on querys/upload_logo.cfm. Getting full path including /query
		// APPLICATION.PATH.base = getDirectoryFromPath(getBaseTemplatePath());	'
		// Base Path eg. C:\websites\granbyprep\
		APPLICATION.PATH.base = 'C:/websites/www/granbyprep/';
				
		// Email Settings
		APPLICATION.EMAIL.headMaster = 'marcus@iseusa.com';
		APPLICATION.EMAIL.admissions = 'marcus@iseusa.com';
		APPLICATION.EMAIL.admissionsOfficer = 'marcus@iseusa.com';
		APPLICATION.EMAIL.submittedApplication = 'marcus@iseusa.com';
		APPLICATION.EMAIL.contactUs = 'marcus@iseusa.com';
		APPLICATION.EMAIL.support = 'marcus@iseusa.com';
		APPLICATION.EMAIL.errors = 'marcus@iseusa.com';
		APPLICATION.EMAIL.finance = 'marcus@iseusa.com';	
		
	} else {
		// ***** PRODUCTION Server Settings *****

		// Getting error on querys/upload_logo.cfm. Getting full path including /query
		// APPLICATION.PATH.base = getDirectoryFromPath(getBaseTemplatePath());	'
		// Base Path eg. C:\websites\granbyprep\
		APPLICATION.PATH.base = 'C:/websites/granbyprep/';

		// Email Settings
		APPLICATION.EMAIL.headMaster = 'bchatterley@macduffie.org';
		APPLICATION.EMAIL.admissions = 'admissions@macduffie.org';
		APPLICATION.EMAIL.admissionsOfficer = 'askidmore@macduffie.org'; // askidmore@granbyprep.com
		APPLICATION.EMAIL.submittedApplication = 'askidmore@granbyprep.com;bchatterley@macduffie.org';
		APPLICATION.EMAIL.contactUs = 'admissions@macduffie.org'; // info@granbyprep.com
		APPLICATION.EMAIL.support = 'support@granbyprep.com';
		APPLICATION.EMAIL.errors = 'errors@granbyprep.com';
		APPLICATION.EMAIL.finance = 'bchatterley@macduffie.org';	
		
	}

	// Path for CSS, JS and Images
	APPLICATION.PATH.css = "linked/css/"; 
	APPLICATION.PATH.js = "linked/js/"; 
	APPLICATION.PATH.Images = "images/";
	APPLICATION.PATH.onlineAppImages = APPLICATION.PATH.Images & "onlineApp/";
	
	
	/***************
		Set up folders used to uplaod documents in the application.
	***************/
	
	// Document Root
	APPLICATION.PATH.UploadDocumentRoot = APPLICATION.PATH.base & "documents/";
	
	APPLICATION.PATH.uploadDocumentGranby = APPLICATION.PATH.UploadDocumentRoot & "granbyPrep/";
	
	APPLICATION.PATH.uploadDocumentStudent = APPLICATION.PATH.UploadDocumentRoot & "student/";
	
	// Temp Folder 
	APPLICATION.PATH.uploadDocumentTemp = APPLICATION.PATH.UploadDocumentRoot & "temp/";

	// Make sure folder exists
	APPLICATION.CFC.DOCUMENT.createFolder(APPLICATION.PATH.UploadDocumentRoot);
	APPLICATION.CFC.DOCUMENT.createFolder(APPLICATION.PATH.uploadDocumentGranby);
	APPLICATION.CFC.DOCUMENT.createFolder(APPLICATION.PATH.uploadDocumentStudent);	
	APPLICATION.CFC.DOCUMENT.createFolder(APPLICATION.PATH.uploadDocumentTemp);	


	/* jQuery Latest Version 
	http://code.jquery.com/jquery-latest.min.js  /  http://code.jquery.com/jquery.js */		
	APPLICATION.PATH.jQuery = 'https://ajax.googleapis.com/ajax/libs/jquery/1.5.1/jquery.min.js';	
	APPLICATION.PATH.jQueryUI = 'https://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js';
	APPLICATION.PATH.jQueryTheme = 'https://ajax.googleapis.com/ajax/libs/jqueryui/1.7.2/themes/excite-bike/jquery-ui.css';
		  
	/* 
		Create the constant object in the application scope - can be used to store states, countries and statuses 
		that are often used in the system so we do not need to call the database to get them
	*/
	APPLICATION.Constants = StructNew();
	
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
</cfscript>
