<!--- ------------------------------------------------------------------------- ----
	
	File:		logOff.cfc
	Author:		Marcus Melo
	Date:		June 14, 2010
	Desc:		Online Application LogOff Page

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- LogOff Student --->
	<cfscript>
		// Log Out Student
		APPLICATION.CFC.ONLINEAPP.doLogout();
		
		// Redirect to Login Page page
		location("#CGI.SCRIPT_NAME#", "no");
	</cfscript>    
    
</cfsilent>