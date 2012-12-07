<!--- ------------------------------------------------------------------------- ----
	
	File:		logout.cfm
	Author:		Marcus Melo
	Date:		November 6, 2012
	Desc:		Host Family App - Index

	Updated:	

----- ------------------------------------------------------------------------- --->

<cfsilent>
	
    <cfscript>
		// Logout
		APPLICATION.CFC.SESSION.doLogout();
		
		// Reload Page to display left menu
		Location("/", "no");
	</cfscript>

</cfsilent>