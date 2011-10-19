<!--- ------------------------------------------------------------------------- ----
	
	File:		_app.cfm
	Author:		Marcus Melo
	Date:		March, 30 2010
	Desc:		Sets App-related  variables such as web address, webmaster 
				email, company name, etc.

	Updated:  	

----- ------------------------------------------------------------------------- --->

<cfquery name="qCompanyInfo" datasource="mysql">
	SELECT
    	companyID,
        support_email,
        projectManager,
        url_ref
	FROM
    	smg_companies
	WHERE
    	url_ref = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.http_host#">
</cfquery>

<cfscript>
	APPLICATION.DSN = 'MySQL';
	

	/***** Create APPLICATION.SETTINGS structure *****/
	APPLICATION.SETTINGS = StructNew();		
	
	// This will store a company lists 
	APPLICATION.SETTINGS.COMPANYLIST = StructNew();		
	// Stores a list with public program companies (Except PHP-6, CSB-7,8,9 and Wep-11)
	// PS: CFCASE does not accept a variable so they are still hard coded.
	APPLICATION.SETTINGS.COMPANYLIST.ISE = "1,2,3,4,12";
	APPLICATION.SETTINGS.COMPANYLIST.ISESMG = "1,2,3,4,5,12";
	// PHP 6, Case 10, WEP 11, Canada 13, ESI 14
	APPLICATION.SETTINGS.COMPANYLIST.NonISE = "10,11,13,14";
	APPLICATION.SETTINGS.COMPANYLIST.PHP = 6;
	APPLICATION.SETTINGS.COMPANYLIST.CASExchange = 10;
	APPLICATION.SETTINGS.COMPANYLIST.Canada = 13;
	APPLICATION.SETTINGS.COMPANYLIST.ESI = 14;
	APPLICATION.SETTINGS.COMPANYLIST.All = "1,2,3,4,5,6,10,12,13,14";
	
	/* 
		this enables the address lookup. 
		0=off, 
		1=simple (lookup required but user can enter any value), 
		2=auto (lookup required and auto fill in readonly value). 
		used on: forms/school_form.cfm, host_fam_form.cfm, user_form.cfm 
	*/
	APPLICATION.address_lookup = 0; 
	
	
	/***** Create APPLICATION.SITE structure *****/
	APPLICATION.SITE = StructNew();		
	// Create new structure to store site information
	APPLICATION.SITE = APPLICATION.SITE.URL = StructNew();	
	// Set Site URL
	APPLICATION.SITE.URL.main = 'http://' & CGI.SERVER_NAME;
	APPLICATION.SITE.URL.pics = APPLICATION.SITE.URL.main & '/nsmg/pics/';


	/***** Create APPLICATION.EMAIL structure *****/
	APPLICATION.EMAIL = StructNew();		

	// Set a short name for the APPLICATION.EMAIL
	AppEmail = APPLICATION.EMAIL;
	APPLICATION.EMAIL.errors = 'errors@student-management.com';
	APPLICATION.EMAIL.finance = 'marcel@iseusa.com';	
	APPLICATION.EMAIL.cbcNotifications = 'support@student-management.com;bill@iseusa.com;gary@iseusa.com';
	APPLICATION.EMAIL.cbcCaseNotifications = 'support@student-management.com;jana@case-usa.org';
	APPLICATION.EMAIL.hostLeadNotifications = 'lamonica@iseusa.com';
	APPLICATION.EMAIL.PHPContact = 'luke@phpusa.com';
	
	if ( VAL(qCompanyInfo.recordCount) ) {
		
		APPLICATION.EMAIL.support = qCompanyInfo.support_email;
		// Phase Out this variable
		APPLICATION.support_email = qCompanyInfo.support_email;
		
	} else {

		APPLICATION.EMAIL.support = 'support@student-management.com';
		// Phase Out this variable
		APPLICATION.support_email =  'support@student-management.com';
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
		// APPLICATION.PATH.base = getDirectoryFromPath(getBaseTemplatePath());	'
		// Base Path eg. C:\websites\smg\nsmg\
		APPLICATION.PATH.base = 'C:/websites/www/student-management/nsmg/';

	} else {
		// PRODUCTION Server Settings

		// Getting error on querys/upload_logo.cfm. Getting full path including /query
		// APPLICATION.PATH.base = getDirectoryFromPath(getBaseTemplatePath());	'
		// Base Path eg. C:\websites\smg\nsmg\
		APPLICATION.PATH.base = 'C:/websites/student-management/nsmg/';

	}

	/* jQuery Latest Version 
	http://code.jquery.com/jquery-latest.min.js  /  http://code.jquery.com/jquery.js */		
	APPLICATION.PATH.jQuery = 'https://ajax.googleapis.com/ajax/libs/jquery/1.5.1/jquery.min.js';	
	APPLICATION.PATH.jQueryUI = 'https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.6/jquery-ui.min.js';
	APPLICATION.PATH.jQueryTheme = 'https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.6/themes/excite-bike/jquery-ui.css';
	// 	APPLICATION.PATH.jQueryTheme = 'https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.6/themes/redmond/jquery-ui.css';


	APPLICATION.PATH.companyLogo = APPLICATION.PATH.base & "pics/logos/"; 
	APPLICATION.PATH.uploadedFiles = APPLICATION.PATH.base & "uploadedfiles/";	
	
	// These are inside uploadedFiles folder
	APPLICATION.PATH.cbcXML = APPLICATION.PATH.uploadedFiles & "xml_files/gis/";
	APPLICATION.PATH.newsMessage = APPLICATION.PATH.uploadedFiles & "news/";
	APPLICATION.PATH.pdfDocs = APPLICATION.PATH.uploadedFiles & 'pdf_docs/';	
	APPLICATION.PATH.sevis = APPLICATION.PATH.uploadedFiles & "sevis/";
	APPLICATION.PATH.temp = APPLICATION.PATH.uploadedFiles & "temp/";	
	APPLICATION.PATH.welcomePics = APPLICATION.PATH.uploadedFiles & "welcome_pics/";	
	APPLICATION.PATH.xmlFiles = APPLICATION.PATH.uploadedFiles & "xml_files/";
	APPLICATION.PATH.tours = APPLICATION.PATH.uploadedFiles & "tours/";
	APPLICATION.PATH.profileFactPics = APPLICATION.PATH.uploadedFiles & "profileFactPics/";

	// These are used in the student online application
	APPLICATION.PATH.onlineApp = StructNew();
	
	// URL Used on Upload/Delete Files
	APPLICATION.PATH.onlineApp.URL = '#CGI.http_host#/nsmg/student_app/';		
	APPLICATION.PATH.onlineApp.reloadURL = '#CGI.http_host#/nsmg/student_app/querys/reload_window.cfm';
	APPLICATION.PATH.onlineApp.uploadURL = 'http://new.upload.student-management.com/';
	
	APPLICATION.PATH.onlineApp.picture = APPLICATION.PATH.uploadedFiles & "web-students/";
	APPLICATION.PATH.onlineApp.letters = APPLICATION.PATH.uploadedFiles & "letters/";
	APPLICATION.PATH.onlineApp.studentLetter = APPLICATION.PATH.uploadedFiles & "letters/students/";
	APPLICATION.PATH.onlineApp.parentLetter = APPLICATION.PATH.uploadedFiles & "letters/parents/";		
	APPLICATION.PATH.onlineApp.familyAlbum = APPLICATION.PATH.uploadedFiles & "online_app/picture_album/";
	APPLICATION.PATH.onlineApp.inserts = APPLICATION.PATH.uploadedFiles & "online_app/";
	APPLICATION.PATH.onlineApp.virtualFolder = APPLICATION.PATH.uploadedFiles & "virtualfolder/";
	APPLICATION.PATH.onlineApp.xmlApp = APPLICATION.PATH.uploadedFiles & "xml_app/";


	/* 
		Create the constant object in the application scope - can be used to store states, countries and statuses 
		that are often used in the system so we do not need to call the database to get them
	*/
	APPLICATION.CONSTANTS = StructNew();
	
	// Set the reference to the struct
	CONSTANTS = APPLICATION.CONSTANTS;
	
	// These store the states to assign students to a AYP camp
	APPLICATION.CONSTANTS.aypStateList = StructNew();	
	APPLICATION.CONSTANTS.aypStateList.mcDuffie = 'ND,SD,NE,KS,OK,TX,MN,IA,MO,AR,LA,WI,IL,MI,IN,OH,KY,TN,MS,AL,GA,FL,ME,VT,NH,MA,RI,CT,NY,NJ,PA,DE,DC,MD,WV,VA,NC,SC';
	APPLICATION.CONSTANTS.aypStateList.northRidge = 'WA,OR,CA,NV,MT,ID,UT,AZ,WY,CO,NM';
	
	
	// These are the values stored on application table
	APPLICATION.CONSTANTS.type = StructNew();	
	APPLICATION.CONSTANTS.type.publicHighSchool = 1;
	APPLICATION.CONSTANTS.type.privateHighSchool = 2;
	APPLICATION.CONSTANTS.type.hostFamily = 3;
	APPLICATION.CONSTANTS.type.wat = 4;
	APPLICATION.CONSTANTS.type.trainee = 5;
	APPLICATION.CONSTANTS.type.hostFamilyLead = 6;
	APPLICATION.CONSTANTS.type.EXITS = 7;

	
	// Set up constant for project help statuses
	APPLICATION.CONSTANTS.projectHelpStatus = ArrayNew(1);		
	APPLICATION.CONSTANTS.projectHelpStatus[1] = "created";
	APPLICATION.CONSTANTS.projectHelpStatus[2] = "sr_approved";
	APPLICATION.CONSTANTS.projectHelpStatus[3] = "ra_approved";
	APPLICATION.CONSTANTS.projectHelpStatus[4] = "ra_rejected";
	APPLICATION.CONSTANTS.projectHelpStatus[5] = "rd_approved";
	APPLICATION.CONSTANTS.projectHelpStatus[6] = "rd_rejected";
	APPLICATION.CONSTANTS.projectHelpStatus[7] = "ny_approved";
	APPLICATION.CONSTANTS.projectHelpStatus[8] = "ny_rejected";
	// ArrayAppend(APPLICATION.CONSTANTS.projectHelpStatus, "sr_approved");
	
	
	// Used in the Online Application
	APPLICATION.CONSTANTS.canadaAreas = ArrayNew(1);	
	APPLICATION.CONSTANTS.canadaAreas[1] = "Calgary";
	APPLICATION.CONSTANTS.canadaAreas[2] = "Comox";
	APPLICATION.CONSTANTS.canadaAreas[3] = "Edmonton";
	APPLICATION.CONSTANTS.canadaAreas[4] = "Golden Hills";
	APPLICATION.CONSTANTS.canadaAreas[5] = "Nova Scotia";
	APPLICATION.CONSTANTS.canadaAreas[6] = "Ottawa, Ontario";
	APPLICATION.CONSTANTS.canadaAreas[7] = "Richmond";
	APPLICATION.CONSTANTS.canadaAreas[8] = "Saskatoon";
	APPLICATION.CONSTANTS.canadaAreas[9] = "Southeast Kootenay";
	APPLICATION.CONSTANTS.canadaAreas[10] = "Winnipeg";
	
	
	// This stores list of Users IDs that have access to certain areas of the system
	APPLICATION.AllowedIDs = StructNew();
	
	// List of User IDs allowed to access ISE USA Leads
	APPLICATION.AllowedIDs.hostLeads = "8743,314,12431"; // 8743 - Robert Keegan / 314 - Budge Lamonica / 12431 - Gary Lubrat
	
	// This stores list of Users IDs that DO NOT have access to certain areas of the system
	APPLICATION.NotAllowedIDs = StructNew();	
	
	// Apex Fundation / WIZANTIANA as per Brian Hause 02/02/11
	APPLICATION.NotAllowedIDs.submitApplication = "8217,12172";
</cfscript>
