<cfapplication name="phpusa" clientmanagement="yes">

<cfparam name="application.dsn" default="MySQL">
<cfparam name="application.site_url" default="http://www.phpusa.com">

<cfscript>
	/***** Create APPLICATION.INVOICE structure *****/
	APPLICATION.INVOICE = StructNew();
	APPLICATION.INVOICE.companyName = 'KCK International Inc.';
	APPLICATION.INVOICE.bankName = 'Suffolk County National Bank';
	APPLICATION.INVOICE.bankAddress = '228 East Main Street';
	APPLICATION.INVOICE.bankCity = 'Port Jefferson';
	APPLICATION.INVOICE.bankState = 'NY';
	APPLICATION.INVOICE.bankZip = '11777';
	APPLICATION.INVOICE.bankRouting = '021405464';
	APPLICATION.INVOICE.bankAccount = '111003977';
	// Set a short name for the APPLICATION.INVOICE
	AppInvoice = APPLICATION.INVOICE;
	
	/***** Create APPLICATION.EMAIL structure *****/
	APPLICATION.EMAIL = StructNew();
	APPLICATION.EMAIL.support = 'support@phpusa.com';
	APPLICATION.EMAIL.finance = 'marcel@student-management.com';
	APPLICATION.EMAIL.programManager = 'luke@phpusa.com';
	APPLICATION.EMAIL.errors = 'errors@student-management.com';
	// Set a short name for the APPLICATION.EMAIL
	AppEmail = APPLICATION.EMAIL;
</cfscript>