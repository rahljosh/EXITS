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

    <cfscript>
		// If user is not logged in, set action to the login page.
		if ( NOT VAL(APPLICATION.CFC.student.getStudentID()) ) {
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
