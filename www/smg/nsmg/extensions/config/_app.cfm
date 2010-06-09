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

	/* 
		this enables the address lookup. 
		0=off, 
		1=simple (lookup required but user can enter any value), 
		2=auto (lookup required and auto fill in readonly value). 
		used on: forms/school_form.cfm, host_fam_form.cfm, user_form.cfm 
	*/
	APPLICATION.address_lookup = 0; 


	/***** Create APPLICATION.EMAIL structure *****/
	APPLICATION.EMAIL = StructNew();		

	// Set a short name for the APPLICATION.EMAIL
	AppEmail = APPLICATION.EMAIL;

	AppEmail.support = 'support@student-management.com';
	AppEmail.errors = 'errors@student-management.com';
	AppEmail.admissions = 'bhause@iseusa.com';
	AppEmail.finance = 'marcel@iseusa.com';	
	AppEmail.cbcNotifications = 'support@student-management.com;bill@iseusa.com;margarita@iseusa.com;diana@iseusa.com;gary@iseusa.com';

	// Phase Out these variables
	if ( cgi.http_host EQ 'jan.case-usa.org' OR cgi.http_host EQ 'www.case-usa.org' ) {
		
		APPLICATION.support_email = 'support@case-usa.org';
		APPLICATION.site_url = 'http://www.case-usa.org';
		
	} else {

		APPLICATION.support_email = 'support@student-management.com';
		APPLICATION.site_url = 'http://www.student-management.com';

	}


	/***** Create APPLICATION.PATH structure *****/
	APPLICATION.PATH = StructNew();		
	
	// Set a short name for the APPLICATION.PATH
	AppPath = APPLICATION.PATH;


	/***** Set Settings based on Live or Dev Servers *****/
	
	// Check if this is Dev or Live 
	if ( APPLICATION.isServerLocal ) {
		// DEVELOPMENT Server Settings	

		// Getting error on querys/upload_logo.cfm. Getting full path including /query
		// AppPath.base = getDirectoryFromPath(getBaseTemplatePath());	'
		// Base Path eg. C:\websites\smg\nsmg\
		AppPath.base = 'C:/websites/www/smg/nsmg/';

		// Set Site URL
		APPLICATION.site_url = 'http://dev.student-management.com';
		
	} else {
		// PRODUCTION Server Settings

		// Getting error on querys/upload_logo.cfm. Getting full path including /query
		// AppPath.base = getDirectoryFromPath(getBaseTemplatePath());	'
		// Base Path eg. C:\websites\smg\nsmg\
		AppPath.base = 'C:/websites/student-management/nsmg/';

		// Set Site URL
		APPLICATION.site_url = 'http://www.student-management.com';
		
	}

	/* jQuery Latest Version 
	http://code.jquery.com/jquery-latest.min.js
	http://code.jquery.com/jquery.js */		
	AppPath.jQuery = 'http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js';	
	
	AppPath.companyLogo = AppPath.base & "pics/logos/"; 
	AppPath.uploadedFiles = AppPath.base & "uploadedfiles/";	
	
	// These are inside uploadedFiles folder
	AppPath.cbcXML = AppPath.uploadedFiles & "xml_files/gis/";
	AppPath.newsMessage = AppPath.uploadedFiles & "news/";
	AppPath.pdfDocs = AppPath.uploadedFiles & 'pdf_docs/';	
	AppPath.sevis = AppPath.uploadedFiles & "sevis/";
	AppPath.temp = AppPath.uploadedFiles & "temp/";	
	AppPath.welcomePics = AppPath.uploadedFiles & "welcome_pics/";	
	AppPath.xmlFiles = AppPath.uploadedFiles & "xml_files/";	

	// These are used in the student online application
	AppPath.onlineApp = StructNew();
	
	// URL Used on Upload/Delete Files
	AppPath.onlineApp.URL = 'https://www.student-management.com/nsmg/student_app/';		
	AppPath.onlineApp.reloadURL = 'https://www.student-management.com/nsmg/student_app/querys/reload_window.cfm';
	AppPath.onlineApp.uploadURL = 'http://new.upload.student-management.com/';
	
	AppPath.onlineApp.picture = AppPath.uploadedFiles & "web-students/";
	AppPath.onlineApp.letters = AppPath.uploadedFiles & "letters/";
	AppPath.onlineApp.studentLetter = AppPath.uploadedFiles & "letters/students/";
	AppPath.onlineApp.parentLetter = AppPath.uploadedFiles & "letters/parents/";		
	AppPath.onlineApp.familyAlbum = AppPath.uploadedFiles & "online_app/picture_album/";
	AppPath.onlineApp.inserts = AppPath.uploadedFiles & "online_app/";
	AppPath.onlineApp.virtualFolder = AppPath.uploadedFiles & "virtualfolder/";
	AppPath.onlineApp.xmlApp = AppPath.uploadedFiles & "xml_app/";


	/* 
		Create the constant object in the application scope - can be used to store states, countries and statuses 
		that are often used in the system so we do not need to call the database to get them
	*/
	APPLICATION.Constants = StructNew();
	
	// Set the reference to the struct
	Constants = APPLICATION.Constants;
	
	// Set up constant for project help statuses
	Constants.projectHelpStatus = ArrayNew(1);		
	Constants.projectHelpStatus[1] = "created";
	Constants.projectHelpStatus[2] = "sr_approved";
	Constants.projectHelpStatus[3] = "ra_approved";
	Constants.projectHelpStatus[4] = "ra_rejected";
	Constants.projectHelpStatus[5] = "rd_approved";
	Constants.projectHelpStatus[6] = "rd_rejected";
	Constants.projectHelpStatus[7] = "ny_approved";
	Constants.projectHelpStatus[8] = "ny_rejected";
	// ArrayAppend(Constants.projectHelpStatus, "sr_approved");
	
	
	// Used in the Online Application
	Constants.canadaAreas = ArrayNew(1);	
	Constants.canadaAreas[1] = "Calgary";
	Constants.canadaAreas[2] = "Comox";
	Constants.canadaAreas[3] = "Edmonton";
	Constants.canadaAreas[4] = "Golden Hills";
	Constants.canadaAreas[5] = "Nova Scotia";
	Constants.canadaAreas[6] = "Ottawa, Ontario";
	Constants.canadaAreas[7] = "Richmond";
	Constants.canadaAreas[8] = "Saskatoon";
	Constants.canadaAreas[9] = "Southeast Kootenay";
	Constants.canadaAreas[10] = "Winnipeg";
	
	
	// This stores list of Users IDs that have access to certain areas of the system
	APPLICATION.AllowedIDs = StructNew();
	
	// List of User IDs allowed to access ISE USA Leads
	APPLICATION.AllowedIDs.hostLeads = "8743,314,12431"; // 8743 - Robert Keegan / 314 - Budge Lamonica / 12431 - Gary Lubrat
</cfscript>
