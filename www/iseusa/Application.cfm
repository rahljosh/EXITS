<cfapplication 
	name="ise-external" 
    clientmanagement="yes">
	<cferror type="EXCEPTION" template="AlertForm.cfm">
<cferror type="REQUEST" template="AlertForm.cfm">  
    <cfparam name="APPLICATION.DSN" default="MySQL">

	<!--- Param Client Variables --->
	<cfparam name="CLIENT.hostID" default="0">
	<cfparam name="CLIENT.name" default="">
    <cfparam name="CLIENT.email" default="">  

	<cfscript>
		// Site URL
		APPLICATION.siteURL = 'http://' & CGI.HTTP_HOST & '/';
		
		/***** Create APPLICATION.EMAIL structure *****/
		APPLICATION.EMAIL = StructNew();		
	
		// Set a short name for the APPLICATION.EMAIL
		AppEmail = APPLICATION.EMAIL;

		AppEmail.support = 'support@iseusa.com';
		AppEmail.finance = 'marcel@iseusa.com';
		AppEmail.errors = 'errors@student-management.com';
		AppEmail.hostLead = 'bob@iseusa.com';


		APPLICATION.Constants = StructNew();
		
		// Set the reference to the struct
		Constants = APPLICATION.Constants;
		
		// Set up constant for project help statuses
		Constants.hearAboutUs = ArrayNew(1);		
		Constants.hearAboutUs[1] = "Google Search";
		Constants.hearAboutUs[2] = "Printed Material";
		Constants.hearAboutUs[3] = "Friend / Acquaintance";
		Constants.hearAboutUs[4] = "ISE Representative";
		Constants.hearAboutUs[5] = "Church Group";
		Constants.hearAboutUs[6] = "Other";
		// ArrayAppend(Constants.hearAboutUs, "Other");
	</cfscript>