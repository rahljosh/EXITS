<!--- ------------------------------------------------------------------------- ----
	
	File:		_app.cfm
	Author:		Marcus Melo
	Date:		June, 14 2010
	Desc:		Sets App-related  variables such as web address, webmaster 
				email, company name, etc.

	Updated:  	

----- ------------------------------------------------------------------------- --->

<cfscript>
	/*******************************************
		Set up DSN information
	*******************************************/
	APPLICATION.DSN = StructNew();
	APPLICATION.DSN.Source = "mySQL";
	APPLICATION.DSN.Username = "";
	APPLICATION.DSN.Password = "";


	/*******************************************
		Set up Document Type ID 
	*******************************************/
	APPLICATION.DOCUMENT.hostFatherCBCAuthorization = 16;
	APPLICATION.DOCUMENT.hostMotherCBCAuthorization = 17;
	APPLICATION.DOCUMENT.hostMemberCBCAuthorization = 18;
	APPLICATION.DOCUMENT.disclaimer = 19;
	
	
	/*******************************************
		Set Up Left Menu
		We could eventually move this to a 
		SESSION variable and create the menu 
		according to user/status
	*******************************************/
	APPLICATION.leftMenu = APPLICATION.CFC.UDF.buildLeftMenu();


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

	// Path for CSS, JS and Images
	APPLICATION.PATH.css = "extensions/css/"; 
	APPLICATION.PATH.js = "extensions/js/"; 
	APPLICATION.PATH.Images = "images/";


	// Local Enviroment
	if ( APPLICATION.isServerLocal ) {
		
		// Local Enviroment
		APPLICATION.PATH.hostApp = "C:/websites/www/student-management/nsmg/uploadedfiles/hostApp/";
		APPLICATION.PATH.relativeHostApp = "http://smg.local/nsmg/uploadedfiles/hostApp/";
		APPLICATION.PATH.TEMP = 'C:/websites/www/student-management/nsmg/uploadedfiles/temp/';
		APPLICATION.siteURL = 'http://' & CGI.HTTP_HOST & '/';
		
	
	} else {
		
		// Production
		APPLICATION.PATH.uploadFolder = "C:/websites/uploads/hostApp/";
		APPLICATION.PATH.hostApp = "C:/websites/student-management/nsmg/uploadedfiles/hostApp/";
		APPLICATION.PATH.relativeHostApp = "https://ise.exitsapplication.com/nsmg/uploadedfiles/hostApp/";
		APPLICATION.PATH.TEMP = 'C:/websites/student-management/nsmg/uploadedfiles/temp/';
		APPLICATION.siteURL = 'https://' & CGI.HTTP_HOST & '/';
		
	}
</cfscript>
