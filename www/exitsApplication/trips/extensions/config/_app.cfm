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
	APPLICATION.DSN.Source = "mySql";
	APPLICATION.DSN.Username = "";
	APPLICATION.DSN.Password = "";


	/*******************************************
		Set up MPD Information
	*******************************************/
	APPLICATION.MPD = StructNew();		
	APPLICATION.MPD.name = 'MPD Tour America, Inc.';
	APPLICATION.MPD.address = '9101 SHORE ROAD, ##203';
	APPLICATION.MPD.city = 'BROOKLYN';
	APPLICATION.MPD.state = 'NY';
	APPLICATION.MPD.zipCode = '11209';
	APPLICATION.MPD.tollFree = '1-800-983-7780';
	APPLICATION.MPD.phone = '1-718-439-8480';
	APPLICATION.MPD.fax = '1-718-439-8565';


	/*******************************************
		Create APPLICATION.EMAIL structure
	*******************************************/
	APPLICATION.EMAIL = StructNew();		
	APPLICATION.EMAIL.support = 'support@iseusa.com';
	APPLICATION.EMAIL.errors = 'errors@student-management.com';
	APPLICATION.EMAIL.trips = 'trips@iseusa.com';


	/*******************************************
		Site URL
	*******************************************/
	APPLICATION.siteURL = 'http://' & CGI.HTTP_HOST & '/';


	/***** Create APPLICATION.METADATA structure / Stores Default Metadata Information *****/
	APPLICATION.METADATA = StructNew();		
	
	// Set up a short name for APPLICATION.METADATA
	APPLICATION.METADATA = APPLICATION.METADATA;
	APPLICATION.METADATA.pageTitle = 'MPD Tour America - Student Trips';
	APPLICATION.METADATA.pageDescription = '';
	APPLICATION.METADATA.pageKeywords = '';


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
		APPLICATION.PATH.TEMP = 'C:/websites/www/student-management/nsmg/uploadedfiles/temp/';
		APPLICATION.PATH.tour = 'C:/websites/www/student-management/nsmg/uploadedfiles/tours/';
	} else {
		// Production
		APPLICATION.PATH.TEMP = 'C:/websites/student-management/nsmg/uploadedfiles/temp/';
		APPLICATION.PATH.tour = 'C:/websites/student-management/nsmg/uploadedfiles/tours/';
	}

	// APPLICATION.QUERY should persist in the application scope. 
	if ( NOT StructKeyExists(APPLICATION, 'QUERY') OR VAL(URL.init) ) {
		
		/***** Create APPLICATION.QUERY structure - This will hold queries that are used in the database and do not change frequently *****/
		APPLICATION.Query = StructNew();
		// Set the reference to the struct
		Query = APPLICATION.Query;
		
		// Store metadata in the application scope since we call on every request
		Query.qMetadata = APPLICATION.CFC.metadata.getMetadataBySite();
		
		// Store the initialized session Library object in the Application scope
		APPLICATION.CFC.SESSION = CreateCFC("session").Init();
		
	}

		  
	/*******************************************
		Constants
	*******************************************/
	APPLICATION.Constants = StructNew();
	
	//Set up constant for payment methods
	APPLICATION.Constants.paymentMethod = ArrayNew(1);		
	APPLICATION.Constants.paymentMethod[1] = "Credit Card";	
	// APPLICATION.Constants.paymentMethod[2] = "Personal Check";
	// APPLICATION.Constants.paymentMethod[3] = "Wire Transfer";
	// APPLICATION.Constants.paymentMethod[4] = "Money Order";
	
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
	qGetMetadata = APPLICATION.CFC.metadata.getPageMetadata(URL=CGI.SCRIPT_NAME); 
	
	// Set up the Application Meta Data
	APPLICATION.MetaData.pageTitle = qGetMetadata.pageTitle;
	APPLICATION.MetaData.pageDescription = qGetMetadata.pageDescription;
	APPLICATION.MetaData.pageKeywords = qGetMetadata.pageKeywords;
</cfscript>
