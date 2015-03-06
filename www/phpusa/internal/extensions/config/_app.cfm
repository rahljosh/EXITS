<!--- ------------------------------------------------------------------------- ----
	
	File:		_app.cfm
	Author:		Marcus Melo
	Date:		March, 30 2010
	Desc:		Sets App-related  variables such as web address, webmaster 
				email, company name, etc.

	Updated:  	

----- ------------------------------------------------------------------------- --->

<cfscript>
	APPLICATION.DSN = 'MySQL';

	/***** Create APPLICATION.INVOICE structure *****/
	APPLICATION.INVOICE = StructNew();
	// Set a short name for the APPLICATION.INVOICE
	AppInvoice = APPLICATION.INVOICE;

	AppInvoice.companyName = 'KCK, Inc.';
	AppInvoice.bankName = 'Chase Bank';
	AppInvoice.bankAddress = '595 Sunrise Highway';
	AppInvoice.bankCity = 'West Babylon';
	AppInvoice.bankState = 'NY';
	AppInvoice.bankZip = '11704';
	AppInvoice.bankSwift = 'CHASUS33';
	AppInvoice.bankRouting = '021000021';
	AppInvoice.bankAccount = '951162106';
	
	
	/***** Create APPLICATION.EMAIL structure *****/
	APPLICATION.EMAIL = StructNew();
	// Set a short name for the APPLICATION.EMAIL
	AppEmail = APPLICATION.EMAIL;

	APPLICATION.EMAIL.support = 'support@phpusa.com';
	APPLICATION.EMAIL.finance = 'jennifer@student-management.com';
	APPLICATION.EMAIL.cancellation = 'luke@phpusa.com;jennifer@student-management.com;bmccready@student-management.com';
	APPLICATION.EMAIL.programManager = 'luke@phpusa.com';
	APPLICATION.EMAIL.errors = 'errors@student-management.com';
	APPLICATION.EMAIL.schoolNotification = 'luke@phpusa.com;tina@phpusa.com;joanna@phpusa.com';
	APPLICATION.EMAIL.hostFamilyNotification = 'bmccready@student-management.com;luke@phpusa.com';
	

	/***** Create APPLICATION.PATH structure *****/
	APPLICATION.PATH = StructNew();	
	// These are for EXITS links 
	APPLICATION.PATH.PHP = StructNew();	
	
	/* jQuery Latest Version 
	http://code.jquery.com/jquery-latest.min.js  /  http://code.jquery.com/jquery.js */		
	APPLICATION.PATH.jQuery = 'https://ajax.googleapis.com/ajax/libs/jquery/1.5.1/jquery.min.js';	
	APPLICATION.PATH.jQueryUI = 'https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.6/jquery-ui.min.js';
	APPLICATION.PATH.jQueryTheme = 'https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.6/themes/excite-bike/jquery-ui.css';
	// 	APPLICATION.PATH.jQueryTheme = 'https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.6/themes/redmond/jquery-ui.css';

	/***** Set Settings based on Live or Dev Servers *****/
	
	// Check if this is Dev or Live 
	if ( APPLICATION.isServerLocal ) {
		// DEVELOPMENT Server Settings	

		// Set Site URL
		APPLICATION.site_url = 'http://php.local/';
		
		// Getting error on querys/upload_logo.cfm. Getting full path including /query
		// APPLICATION.PATH.base = getDirectoryFromPath(getBaseTemplatePath());	'
		APPLICATION.PATH.PHP.base = "C:/websites/phpusa/";
		
		APPLICATION.PATH.PHP.base = "C:/websites/www/phpusa/";
		APPLICATION.PATH.PHP.baseInternal = "C:/websites/www/phpusa/internal";
		APPLICATION.PATH.PHP.phpusa = "http://php.local/internal/";

		// Getting error on querys/upload_logo.cfm. Getting full path including /query
		// APPLICATION.PATH.base = getDirectoryFromPath(getBaseTemplatePath());	'
		APPLICATION.PATH.base = "C:/websites/www/student-management/nsmg/";
		APPLICATION.PATH.SmgURL = "http://smg.local/nsmg/";
		
	} else {
		// PRODUCTION Server Settings

		// Set Site URL
		APPLICATION.site_url = 'http://www.phpusa.com';

		// Getting error on querys/upload_logo.cfm. Getting full path including /query
		// APPLICATION.PATH.base = getDirectoryFromPath(getBaseTemplatePath());	'
		APPLICATION.PATH.PHP.base = "C:/websites/phpusa/";
		APPLICATION.PATH.PHP.baseInternal = "C:/websites/phpusa/internal";
		APPLICATION.PATH.PHP.phpusa = "http://www.phpusa.com/internal/";

		// Getting error on querys/upload_logo.cfm. Getting full path including /query
		// APPLICATION.PATH.base = getDirectoryFromPath(getBaseTemplatePath());	'
		APPLICATION.PATH.base = "C:/websites/student-management/nsmg/";
		APPLICATION.PATH.SmgURL = "https://ise.exitsapplication.com/nsmg/";
	}


	/********************
		PHP SPECIFIC
	********************/ 
	APPLICATION.PATH.PHP.schoolImage = APPLICATION.PATH.PHP.base & "newschools/";
	APPLICATION.PATH.PHP.pics = APPLICATION.PATH.PHP.base & "pics/"; 
	

	/* 
		Create the constant object in the application scope - can be used to store states, countries and statuses 
		that are often used in the system so we do not need to call the database to get them
	*/
	APPLICATION.CONSTANTS = StructNew();
	
	/********************
		APPLICATION TYPE - These are the values stored on application table
	********************/ 	
	APPLICATION.CONSTANTS.TYPE = StructNew();	
	APPLICATION.CONSTANTS.TYPE.publicHighSchool = 1;
	APPLICATION.CONSTANTS.TYPE.privateHighSchool = 2;
	APPLICATION.CONSTANTS.TYPE.hostFamily = 3;
	APPLICATION.CONSTANTS.TYPE.wat = 4;
	APPLICATION.CONSTANTS.TYPE.trainee = 5;
	APPLICATION.CONSTANTS.TYPE.hostFamilyLead = 6;
	APPLICATION.CONSTANTS.TYPE.EXITS = 7;


	/********************
		EXITS SPECIFIC
	********************/ 
	APPLICATION.PATH.companyLogo = APPLICATION.PATH.base & "pics/logos/"; 
	APPLICATION.PATH.uploadedFiles = APPLICATION.PATH.base & "uploadedfiles/";	
	
	// These are inside uploadedFiles folder
	APPLICATION.PATH.cbcXML = APPLICATION.PATH.uploadedFiles & "xml_files/gis/";
	APPLICATION.PATH.newsMessage = APPLICATION.PATH.uploadedFiles & "news/";
	APPLICATION.PATH.pdfDocs = APPLICATION.PATH.uploadedFiles & "pdf_docs/";	
	APPLICATION.PATH.sevis = APPLICATION.PATH.uploadedFiles & "sevis/";
	APPLICATION.PATH.temp = APPLICATION.PATH.uploadedFiles & "temp/";	
	APPLICATION.PATH.welcomePics = APPLICATION.PATH.uploadedFiles & "welcome_pics/";	
	APPLICATION.PATH.xmlFiles = APPLICATION.PATH.uploadedFiles & "xml_files/";	

	// These are used in the student online application
	APPLICATION.PATH.onlineApp = StructNew();
	
	// URL Used on Upload/Delete Files
	APPLICATION.PATH.onlineApp.URL = "https://ise.exitsapplication.com/nsmg/student_app/";		
	APPLICATION.PATH.onlineApp.reloadURL = "https://ise.exitsapplication.com/nsmg/student_app/querys/reload_window.cfm";
	
	APPLICATION.PATH.onlineApp.uploadURL = "http://new.upload.student-management.com/";
	APPLICATION.PATH.onlineApp.picture = APPLICATION.PATH.uploadedFiles & "web-students/";
	APPLICATION.PATH.onlineApp.letters = APPLICATION.PATH.uploadedFiles & "letters/";
	APPLICATION.PATH.onlineApp.studentLetter = APPLICATION.PATH.uploadedFiles & "letters/students/";
	APPLICATION.PATH.onlineApp.parentLetter = APPLICATION.PATH.uploadedFiles & "letters/parents/";		
	APPLICATION.PATH.onlineApp.familyAlbum = APPLICATION.PATH.uploadedFiles & "online_app/picture_album/";
	APPLICATION.PATH.onlineApp.inserts = APPLICATION.PATH.uploadedFiles & "online_app/";
	APPLICATION.PATH.onlineApp.virtualFolder = APPLICATION.PATH.uploadedFiles & "virtualfolder/";
	APPLICATION.PATH.onlineApp.xmlApp = APPLICATION.PATH.uploadedFiles & "xml_app/";
</cfscript>
