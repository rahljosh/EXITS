<!--- ------------------------------------------------------------------------- ----
	
	File:		_app.cfm
	Author:		Marcus Melo
	Date:		October, 14 2010
	Desc:		Sets App-related  variables such as web address, webmaster 
				email, company name, etc.

	Updated:  	

----- ------------------------------------------------------------------------- --->

<cfscript>
	// Set up DSN information
	APPLICATION.DSN = StructNew();
	APPLICATION.DSN.Source = "mySql";
	APPLICATION.DSN.Username = "";
	APPLICATION.DSN.Password = "";


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
	APPLICATION.CSB.WAT.phone = "1-631-893-4549";
	APPLICATION.CSB.WAT.toolFreePhone = "1-877-669-0717";
	APPLICATION.CSB.WAT.fax = "1-631-893-4547";
	APPLICATION.CSB.WAT.phoneIDCard = "1-877-669-0717";
	APPLICATION.CSB.WAT.logo = "8.gif";
	APPLICATION.CSB.WAT.smallLogo = "8s.gif";
	APPLICATION.CSB.WAT.address = '119 Cooper Street';
	APPLICATION.CSB.WAT.city = 'Babylon';
	APPLICATION.CSB.WAT.state = 'NY';
	APPLICATION.CSB.WAT.zipCode = '11702';
	APPLICATION.CSB.WAT.country = 'United States';

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
	APPLICATION.CSB.INTO.country = 'United States';

	// Set CSB Trainee Information
	APPLICATION.CSB.Trainee = StructNew();		
	APPLICATION.CSB.Trainee.name = "International Student Exchange";
	// APPLICATION.CSB.Trainee.name = "CSB International, Inc.";
	APPLICATION.CSB.Trainee.programName = "Trainee Program";
	APPLICATION.CSB.Trainee.shortProgramName = "ISE Trainee";
	//APPLICATION.CSB.Trainee.shortProgramName = "CSB Trainee";
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
	APPLICATION.CSB.Trainee.country = 'United States';


	/***** Create APPLICATION.SETTINGS structure *****/
	APPLICATION.SETTINGS = StructNew();		
	APPLICATION.SETTINGS.watdisplayUserSSNIDList = "7935,19658"; // Anca, Ryan


	/***** Create APPLICATION.METADATA structure / Stores Default Metadata Information *****/
	APPLICATION.METADATA = StructNew();		
	
	// SET CSB Default Information
	APPLICATION.METADATA.pageTitle = 'CSB International, Inc.';
	APPLICATION.METADATA.pageDescription = '';
	APPLICATION.METADATA.pageKeywords = 'Trainee Program, Work and Travel Program, Work Experience';
	
	// Set CSB Trainee Information
	// APPLICATION.METADATA.Trainee.pageTitle = 'CSB International, Inc. - Trainee Program';
	APPLICATION.METADATA.Trainee.pageTitle = 'International Student Exchange - Trainee Program';
	APPLICATION.METADATA.Trainee.pageDescription = '';
	APPLICATION.METADATA.Trainee.pageKeywords = 'Trainee Program';
	
	// Set CSB WAT Information
	APPLICATION.METADATA.WAT.pageTitle = 'CSB International, Inc. - Summer Work and Travel Program';
	APPLICATION.METADATA.WAT.pageDescription = '';
	APPLICATION.METADATA.WAT.pageKeywords = 'Work and Travel Program';


	/***** Create APPLICATION.QUERY structure - This will hold queries that are used in the database and do not change frequently *****/
	APPLICATION.QUERY = StructNew();


	/***** Create APPLICATION.SITE structure *****/
	APPLICATION.SITE = StructNew();		
	// Create new structure to store site information
	APPLICATION.SITE.URL = StructNew();	

	
	/***** Create APPLICATION.EMAIL structure / Stores Email Information *****/
	APPLICATION.EMAIL = StructNew();		
	APPLICATION.EMAIL.flightReport = 'anca@csb-usa.com;ryan@csb-usa.com';
	APPLICATION.EMAIL.traineeFlightReport = 'ryan@iseusa.com';
	APPLICATION.EMAIL.watMissingDocuments = 'ryan@csb-usa.com';
	
	/***** Create APPLICATION.PATH structure *****/
	APPLICATION.PATH = StructNew();	
	APPLICATION.PATH.TRAINEE = StructNew();		
	APPLICATION.PATH.WAT = StructNew();		

	/* jQuery Latest Version 
	http://code.jquery.com/jquery-latest.min.js  /  http://code.jquery.com/jquery.js */		
	APPLICATION.PATH.jQuery = 'https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js';	
	APPLICATION.PATH.jQueryUI = 'https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.18/jquery-ui.min.js';
	APPLICATION.PATH.jQueryTheme = 'https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.6/themes/excite-bike/jquery-ui.css';
	// 	APPLICATION.PATH.jQueryTheme = 'https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.6/themes/redmond/jquery-ui.css';

	/***** Set Settings based on Live or Dev Servers *****/
	
	/***** Create APPLICATION.KEY structure *****/
	APPLICATION.KEY = StructNew();	
	
	// Check if this is Dev or Live 
	if ( APPLICATION.isServerLocal ) {
		// ***** DEVELOPMENT Server Settings *****

		// Set Site URL
		//APPLICATION.SITE.URL.main = 'http://brazil/';
		//APPLICATION.SITE.URL.activation = 'http://brazil/accountActivation.cfm';
		APPLICATION.SITE.URL.main = 'http://extra.local/';
		APPLICATION.SITE.URL.activation = 'http://extra.local/accountActivation.cfm';
		
		// Email Settings
		APPLICATION.EMAIL.contactUs = 'james@iseusa.com';
		APPLICATION.EMAIL.support = 'james@iseusa.com';
		APPLICATION.EMAIL.errors = 'james@iseusa.com';

		// APPLICATION.PATH.base = getDirectoryFromPath(getBaseTemplatePath());	'
		APPLICATION.PATH.base = 'C:/websites/www/exitsApplication/extra/internal/';
		
		APPLICATION.KEY.googleMapsAPI = 'ABQIAAAAiT0TfDoNFmmMRtOgGZNu_RQ7SAcFHxXg_-mJGkd4r8IEQsqs-RTA-mZLUkFOvNCYFwvV4y4wGdOOyg'; // URL: http://smg.local

	
	} else {
		// ***** PRODUCTION Server Settings *****

		// Set Site URL
		APPLICATION.SITE.URL.main = 'http://extra.exitsApplication.com/';
		APPLICATION.SITE.URL.activation =  APPLICATION.SITE.URL.main & 'accountActivation.cfm';
		
		// Email Settings
		APPLICATION.EMAIL.contactUs = 'info@csb-usa.com';
		APPLICATION.EMAIL.support = 'support@student-management.com';
		APPLICATION.EMAIL.errors = 'errors@student-management.com';
		
		// APPLICATION.PATH.base = getDirectoryFromPath(getBaseTemplatePath());	'
		APPLICATION.PATH.base = 'C:/websites/exitsApplication/extra/internal/';
		
		APPLICATION.KEY.googleMapsAPI = 'ABQIAAAAiT0TfDoNFmmMRtOgGZNu_RRLNEIHL1-VAyvTpFfu6UHsH4aa6RS5HJTmI0cZToeRuO_UU4JcIi2qaw'; // URL: http://exitsapplication.com

	}
	
	// Set up so emails sent from EXTRA are stored in this address.
	APPLICATION.EMAIL.sentEmail = 'sentEmail@csb-usa.com';
	
	// Set Uploaded Files 
	APPLICATION.PATH.uploadedFiles = APPLICATION.PATH.base & 'uploadedFiles/';

	APPLICATION.PATH.pdfFiles = APPLICATION.PATH.uploadedFiles & 'pdf_docs/';
	
	APPLICATION.PATH.TRAINEE.pdfDocs = APPLICATION.PATH.pdfFiles & 'trainee/';

	APPLICATION.PATH.WAT.pdfDocs = APPLICATION.PATH.pdfFiles & 'wat/';

	/***************
		Set up folders used to uplaod documents in the application.
	***************/


	// Document Root
	APPLICATION.PATH.UploadDocumentRoot = APPLICATION.PATH.base & 'uploadedFiles/';

	// DELETE THESE FROM TRAINEE AND H2B
	/*
	APPLICATION.PATH.uploadedFiles = = APPLICATION.PATH.base & "uploadedFiles/";
	APPLICATION.PATH.pdfDocs = APPLICATION.PATH.UploadDocumentRoot & 'pdf_docs/wat/';
	APPLICATION.PATH.candidatePicture = APPLICATION.PATH.UploadDocumentRoot & "web-candidates/";
	*/
	
	// Host Company Logo
	APPLICATION.PATH.hostLogo = APPLICATION.PATH.UploadDocumentRoot & 'web-hostlogo/';

	// Business License - Secretary of State Authentication
	APPLICATION.PATH.businessLicense = APPLICATION.PATH.UploadDocumentRoot & 'business-license/';
	
	// Department of Labor Authentication
	APPLICATION.PATH.departmentOfLabor = APPLICATION.PATH.UploadDocumentRoot & 'departmentOfLabor/';
	
	// Google Earth Authentication
	APPLICATION.PATH.googleEarth = APPLICATION.PATH.UploadDocumentRoot & 'googleEarth/';
	
	// Authentications
	APPLICATION.PATH.authentications = APPLICATION.PATH.UploadDocumentRoot & 'authentications/';
	
	// Workmens Compensation
	APPLICATION.PATH.workmensCompensation = APPLICATION.PATH.UploadDocumentRoot & 'workmensCompensation/';

	// Candidate Picture
	APPLICATION.PATH.uploadCandidatePicture = APPLICATION.PATH.UploadDocumentRoot & 'web-candidates/';
	
	// Candidate Application Files		
	APPLICATION.PATH.uploadDocumentCandidate = APPLICATION.PATH.UploadDocumentRoot & 'candidate/';
	
	// Temp Folder 
	APPLICATION.PATH.uploadDocumentTemp = APPLICATION.PATH.UploadDocumentRoot & 'temp/';

	// Make sure folder exists
	APPLICATION.CFC.DOCUMENT.createFolder(APPLICATION.PATH.UploadDocumentRoot);
	APPLICATION.CFC.DOCUMENT.createFolder(APPLICATION.PATH.uploadCandidatePicture);
	APPLICATION.CFC.DOCUMENT.createFolder(APPLICATION.PATH.uploadDocumentCandidate);	
	APPLICATION.CFC.DOCUMENT.createFolder(APPLICATION.PATH.uploadDocumentTemp);	
</cfscript>
