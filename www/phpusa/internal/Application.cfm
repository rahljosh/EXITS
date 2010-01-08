<cfapplication name="phpusa" clientmanagement="yes">

<cfparam name="application.dsn" default="MySQL">
<cfparam name="application.site_url" default="http://www.phpusa.com">

<cfscript>
	/***** Create APPLICATION.EMAIL structure *****/
	APPLICATION.EMAIL = StructNew();
	APPLICATION.EMAIL.support = 'support@phpusa.com';
	APPLICATION.EMAIL.finance = 'marcel@student-management.com';
	APPLICATION.EMAIL.programManager = 'luke@phpusa.com';
	APPLICATION.EMAIL.errors = 'errors@student-management.com';
	// Set a short name for the CFCs
	AppEmail = APPLICATION.EMAIL;
</cfscript>