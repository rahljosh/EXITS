<!--- ------------------------------------------------------------------------- ----
	
	File:		logOff.cfc
	Author:		Marcus Melo
	Date:		November 10, 2010
	Desc:		AdminTool LogOff Page

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- LogOff Student --->
	<cfscript>
		// Log Out Student
		APPLICATION.CFC.ADMINTOOL.doLogout();
		
		// Redirect to Login Page page
		location("#CGI.SCRIPT_NAME#", "no");
	</cfscript>    
    
</cfsilent>