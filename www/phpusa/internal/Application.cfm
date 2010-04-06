<cfapplication name="phpusa" clientmanagement="yes">

<cfparam name="application.dsn" default="MySQL">
<cfparam name="application.site_url" default="http://www.phpusa.com">

<cfscript>
	/***** Create APPLICATION.INVOICE structure *****/
	APPLICATION.INVOICE = StructNew();

	// Set a short name for the APPLICATION.INVOICE
	AppInvoice = APPLICATION.INVOICE;

	AppInvoice.companyName = 'KCK International Inc.';
	AppInvoice.bankName = 'Suffolk County National Bank';
	AppInvoice.bankAddress = '228 East Main Street';
	AppInvoice.bankCity = 'Port Jefferson';
	AppInvoice.bankState = 'NY';
	AppInvoice.bankZip = '11777';
	AppInvoice.bankRouting = '021405464';
	AppInvoice.bankAccount = '1110039771';
	
	
	/***** Create APPLICATION.EMAIL structure *****/
	APPLICATION.EMAIL = StructNew();

	// Set a short name for the APPLICATION.EMAIL
	AppEmail = APPLICATION.EMAIL;

	AppEmail.support = 'support@phpusa.com';
	AppEmail.finance = 'marcel@student-management.com';
	AppEmail.programManager = 'luke@phpusa.com';
	AppEmail.errors = 'errors@student-management.com';
	

	/***** Create APPLICATION.EMAIL structure *****/
	APPLICATION.EMAIL = StructNew();		

	// Set a short name for the APPLICATION.EMAIL
	AppEmail = APPLICATION.EMAIL;

	AppEmail.support = 'support@phpusa.com';
	AppEmail.finance = 'marcel@student-management.com';
	AppEmail.errors = 'errors@student-management.com';
	
	
	/***** Create APPLICATION.PATH structure *****/
	APPLICATION.PATH = StructNew();		
	
	// Set a short name for the APPLICATION.PATH
	AppPath = APPLICATION.PATH;
	
	// Getting error on querys/upload_logo.cfm. Getting full path including /query
	// AppPath.base = getDirectoryFromPath(getBaseTemplatePath());	'
	// Base Path eg. C:\websites\smg\nsmg\
	AppPath.base = 'C:/websites/student-management/nsmg/';
	
	AppPath.companyLogo = AppPath.base & "pics/logos/"; 
	AppPath.uploadedFiles = AppPath.base & 'uploadedfiles/';	
	
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
</cfscript>


