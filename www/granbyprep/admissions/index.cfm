<!--- ------------------------------------------------------------------------- ----
	
	File:		index.cfc
	Author:		Marcus Melo
	Date:		June 14, 2010
	Desc:		Online Application Index Page

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>
	
	<!--- Param local variables --->
	<cfparam name="id" default="0" />
	<cfparam name="action" default="login">

    <!--- Param URL variables --->
    <cfparam name="URL.ID" default="">
	<cfparam name="URL.hashID" default="">

    <cfscript>
		// Check if Office is opening an application
		if ( LEN(URL.ID) AND LEN(URL.hashID) ) {
			
			// Get Candidate Information
			qAuthenticateCandidate = APPLICATION.CFC.STUDENT.getStudentByHashID(id=URL.ID,hashID=URL.hashID);
						
			// Check if we have a valid student
			if ( qAuthenticateCandidate.recordCount ) {
					
				// Login Candidat / Set SESSION variables / Update Last Logged in Date
				APPLICATION.CFC.ONLINEAPP.doLogin(
					studentID=qAuthenticateCandidate.ID,
					updateDateLastLoggedIn=0
				);
							
			}
		}
	
		// If user is not logged in, set action to the login page.
		if ( NOT APPLICATION.CFC.ONLINEAPP.isCurrentUserLoggedIn() ) {
			action = 'login';
		}
	</cfscript>

 	<!--- Force SSL --->
	<cfif NOT APPLICATION.IsServerLocal AND NOT CGI.SERVER_PORT_SECURE>
        <cflocation url="https://#CGI.SERVER_NAME##CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" addToken="no" />
    </cfif>
    
</cfsilent>
	
<!--- 
	Check to see which action we are taking. 
--->
<cfswitch expression="#action#">

	<cfcase value="login,logOff,home,initial,section1,section2,section3,section4,section5,documents,help,faq,myAccount,printApplication,download,checkList,privacy,applicationFee,submit" delimiters=",">

		<!--- Include template --->
		<cfinclude template="_#action#.cfm" />

	</cfcase>


	<!--- The default case is the login page --->
	<cfdefaultcase>
		
		<!--- Include template --->
		<cfinclude template="_login.cfm" />

	</cfdefaultcase>

</cfswitch>
