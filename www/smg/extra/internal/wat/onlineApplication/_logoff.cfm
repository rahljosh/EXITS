<!--- ------------------------------------------------------------------------- ----
	
	File:		index.cfc
	Author:		Marcus Melo
	Date:		September 09, 2010
	Desc:		Online Application Index Page

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- LogOff Student --->
	<cfscript>
		// Log Out Student
		APPLICATION.CFC.ONLINEAPP.doLogout();
		
		// Redirect to Login Page page
		location("../../../index.cfm", "no");
	</cfscript>    

</cfsilent>