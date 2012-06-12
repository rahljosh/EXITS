<!--- ------------------------------------------------------------------------- ----
	
	File:		logout.cfm
	Author:		Marcus Melo
	Date:		June 12, 2012
	Desc:		Logout users - delete CLIENT and SESSION variables

	Updated:														
	
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<cfscript>
		// Get CLIENT variable list
		vClientVarList = GetClientVariablesList();
		
		// Loop Through CLIENT Variables
		for ( i=1; i LTE ListLen(vClientVarList); i=i+1 ) {
			// Delete CLIENT Variable
			DeleteClientVariable(ListGetAt(vClientVarList, i));
		}
		
		// Delete SESSION Roles
		structDelete(SESSION, "roles");

		// Location
		location("http://#cgi.http_host#/", "no");
	</cfscript>

</cfsilent>