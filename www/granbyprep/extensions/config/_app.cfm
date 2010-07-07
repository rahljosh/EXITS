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
	APPLICATION.SCHOOL.name = 'Granby Preparatory Academy';
	APPLICATION.SCHOOL.address = '66 School Street, Granby, MA 01033';
	APPLICATION.SCHOOL.tollFree = '(800) 766-4656';
	APPLICATION.SCHOOL.phone = '(631) 893-4540';


	/***** Create APPLICATION.METADATA structure / Stores Default Metadata Information *****/
	APPLICATION.METADATA = StructNew();		
	
	// Set up a short name for APPLICATION.METADATA
	AppMetadata = APPLICATION.METADATA;
	AppMetadata.pageTitle = 'Granby Preparatory Academy';
	AppMetadata.pageDescription = '';
	AppMetadata.pageKeywords = '';
	
	
	/***** Create APPLICATION.EMAIL structure / Stores Email Information *****/
	APPLICATION.EMAIL = StructNew();		

	// Set up a short name for the APPLICATION.EMAIL
	AppEmail = APPLICATION.EMAIL;

	AppEmail.contactUs = 'info@granbyprep.com';
	AppEmail.support = 'support@granbyprep.com';
	AppEmail.errors = 'errors@student-management.com';
	AppEmail.admissions = 'bhause@iseusa.com';
	AppEmail.finance = 'marcel@iseusa.com';	
	
	
	/***** Create APPLICATION.PATH structure *****/
	APPLICATION.PATH = StructNew();		
	// Set a short name for the APPLICATION.PATH
	AppPath = APPLICATION.PATH;

	/***** Create APPLICATION.SITE structure *****/
	APPLICATION.SITE = StructNew();		
	// Set a short name for the APPLICATION.PATH
	AppSite = APPLICATION.SITE;	
	
	AppSite = APPLICATION.SITE.URL = StructNew();	

	/***** Set Settings based on Live or Dev Servers *****/
	
	// Check if this is Dev or Live 
	if ( APPLICATION.isServerLocal ) {
		// DEVELOPMENT Server Settings	

		// Getting error on querys/upload_logo.cfm. Getting full path including /query
		// AppPath.base = getDirectoryFromPath(getBaseTemplatePath());	'
		// Base Path eg. C:\websites\granbyprep\
		AppPath.base = 'C:/websites/www/granbyprep/';
		
		// Set Site URL
		APPLICATION.SITE.URL.main = 'http://granbyprep.local/';
		APPLICATION.SITE.URL.admissions = 'http://granbyprep.local/admissions';
		
	} else {
		// PRODUCTION Server Settings

		// Getting error on querys/upload_logo.cfm. Getting full path including /query
		// AppPath.base = getDirectoryFromPath(getBaseTemplatePath());	'
		// Base Path eg. C:\websites\granbyprep\
		AppPath.base = 'C:/websites/granbyprep/';

		// Set Site URL
		APPLICATION.SITE.URL.main = 'http://www.granbyprep.com/';
		APPLICATION.SITE.URL.admissions = 'http://www.granbyprep.com/admissions';
	}

	// Path for CSS, JS and Images
	AppPath.css = "linked/css/"; 
	AppPath.js = "linked/js/"; 
	AppPath.Images = "images/";
	AppPath.onlineAppImages = AppPath.Images & "onlineApp/";
	
	
	/***************
		Set up folders used to uplaod documents in the application.
	***************/
	
	// Upload Path
	AppPath.UploadRoot = AppPath.base & "upload/";
	// Documents Folder
	AppPath.UploadDocuments = AppPath.UploadRoot & "documents/";
	AppPath.UploadStudentDocuments = AppPath.UploadDocuments & "student/";
	// Temp Folder 
	AppPath.UploadRootTemp = AppPath.UploadDocuments & "temp/";

	// Make sure folder exists
	APPLICATION.CFC.DOCUMENT.createFolder(AppPath.UploadStudentDocuments);	
	APPLICATION.CFC.DOCUMENT.createFolder(AppPath.UploadRootTemp);	


	/* jQuery Latest Version 
	http://code.jquery.com/jquery-latest.min.js  /  http://code.jquery.com/jquery.js */		
	AppPath.jQuery = 'http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js';	
	AppPath.jQueryUI = 'http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js';
	

	/* 
		Create the constant object in the application scope - can be used to store states, countries and statuses 
		that are often used in the system so we do not need to call the database to get them
	*/
	APPLICATION.Constants = StructNew();
	
	// Set the reference to the struct
	Constants = APPLICATION.Constants;

	//Set up constant for payment methods
	Constants.paymentType = ArrayNew(1);		
	Constants.paymentType[1] = "Credit Card";
	/*
	Constants.paymentType[2] = "Personal Check";
	Constants.paymentType[3] = "Wire Transfer";
	Constants.paymentType[4] = "Money Order";
	*/

	//Set up constant for credit card types
	Constants.creditCardType = ArrayNew(1);		
	Constants.creditCardType[1] = "Visa";
	Constants.creditCardType[2] = "MasterCard";
	Constants.creditCardType[3] = "American Express";
	Constants.creditCardType[4] = "Discovery";
</cfscript>
