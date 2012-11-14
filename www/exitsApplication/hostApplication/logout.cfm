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
		Location("http://#cgi.http_host#/", "no");
	</cfscript>

</cfsilent>