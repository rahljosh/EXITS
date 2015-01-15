<!--- ------------------------------------------------------------------------- ----
	
	File:		index.cfc
	Author:		Marcus Melo
	Date:		August 26, 2010
	Desc:		Online Application Index Page

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Allow AJAX --->
	<cfajaximport csssrc="/CFIDE/scripts/ajax/" scriptsrc="/CFIDE/scripts/">
	
	<!--- Param local variables --->
	<cfparam name="action" default="home">
    <!--- Param URL variables --->
	<cfparam name="URL.uniqueID" default="">
    
    <cfscript>
		// Check if Office or Intl. Rep are opening an application
		if ( LEN(URL.uniqueID) ) {
			
			// Get Candidate Information
			qAuthenticateCandidate = APPLICATION.CFC.CANDIDATE.getCandidateByID(uniqueID=URL.uniqueID);
						
			// Check if we have a valid student
			if ( qAuthenticateCandidate.recordCount ) {
					
				// Login Candidat / Set SESSION variables / Update Last Logged in Date
				APPLICATION.CFC.ONLINEAPP.doLogin(
					candidateID=qAuthenticateCandidate.candidateID,
					updateDateLastLoggedIn=0
				);
								
				// SET LINKS        
				getLink = APPLICATION.CFC.onlineApp.setLoginLinks(
					companyID=qAuthenticateCandidate.companyID,
					loginType='candidate'
				);	
							
			}
		}
		
		// If user is not logged in, set action to the login page.
		if ( CLIENT.loginType NEQ 'user' AND NOT APPLICATION.CFC.ONLINEAPP.isCurrentUserLoggedIn() ) {
			action = 'login';
		}
		
		// Force SSL
		if ( NOT APPLICATION.IsServerLocal AND NOT CGI.SERVER_PORT_SECURE ) {
			location("https://#CGI.SERVER_NAME##CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#", "no");
		}
	</cfscript>
    	
</cfsilent>

<!--- 
	Check to see which action we are taking. 
--->
<cfswitch expression="#action#">

    <cfcase value="list,createApplication,initial,home,section1,section2,section3,checkList,submit,download,documents,materials,faq,myAccount,printApplication,flightInfo,displayLogin,help,delete,logOff" delimiters=",">

		<!--- Include template --->
		<cfinclude template="_#action#.cfm" />

	</cfcase>


	<cfcase value="login" delimiters=",">

		<!--- Redirect to Login Page --->
		<cflocation url="#APPLICATION.SITE.URL.main#" addtoken="no">

	</cfcase>


	<!--- The default case is the login page --->
	<cfdefaultcase>
		
		<!--- Redirect to Login Page --->
		<cflocation url="#APPLICATION.SITE.URL.main#" addtoken="no">

	</cfdefaultcase>

</cfswitch>

            
