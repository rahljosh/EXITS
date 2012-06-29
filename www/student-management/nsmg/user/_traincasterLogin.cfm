<!--- ------------------------------------------------------------------------- ----
	
	File:		_traincasterLogin.cfm
	Author:		Marcus Melo
	Date:		April 17, 2012
	Desc:		Traincaster Login	
				
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

	<cfscript>
		// Generate URL Login
		vGenerateLogin = APPLICATION.CFC.USER.generateTraincasterLoginLink(uniqueID=URL.uniqueID);		
		
		//vGenerateLogin = 'http://doslocalcoordinatortraining.traincaster.com/app/clients/doslocalcoordinatortraining/Login.pm?timestamp=1341002642&person_id=510&first_name=Marcus&last_name=Melo&email=marcus@iseusa.com&program_sponsor=International Student Exchange&digest=b573c89bb3f4815df3477e43418c2e5eb026c3a0';
		
		/* create new http service */ 
		vHTTPService = new http(); 			

		/* set attributes using implicit setters */ 
		vHTTPService.setMethod("get"); 
		vHTTPService.setCharset("utf-8"); 
		vHTTPService.setUrl(vGenerateLogin); 

		/* make the http call to the URL using send() */ 
		vResult = vHTTPService.send().getPrefix(); 

		// Check if we can login successfully
		if ( LEN(vResult.fileContent) ) {
			
			// Login
			location(vGenerateLogin, "no");
			
		} else {

			// ISE
			if ( ListFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID) ) {
				// Add Error Message
				SESSION.formErrors.Add("EXITS could not process your Traincaster DOS Certification login at this time. Please contact Megan Perlleshi at megan@iseusa.com");
			// CASE
			} else {
				// Add Error Message
				SESSION.formErrors.Add("EXITS could not process your Traincaster DOS Certification login at this time. Please contact Stacy Brewer at stacy@case-usa.org");
			}
		
		}
    </cfscript> 
    
</cfsilent>

<cfoutput>

	<!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="divOnly"
        width="90%"
        displayDataNotSavedMessage=0
        />
    
</cfoutput>
