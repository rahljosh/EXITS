<!--- ------------------------------------------------------------------------- ----
	
	File:		index.cfc
	Author:		Marcus Melo
	Date:		August 26, 2010
	Desc:		Online Application Index Page

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>
	
	<!--- Param local variables --->
	<cfparam name="action" default="home">

    <cfscript>
		// If user is not logged in, set action to the login page.
		if ( CLIENT.loginType EQ 'candidate' AND NOT APPLICATION.CFC.ONLINEAPP.isCurrentUserLoggedIn() ) {
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

    <cfcase value="list,createApplication,home,section1,section2,section3,logOff" delimiters=",">

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

            
