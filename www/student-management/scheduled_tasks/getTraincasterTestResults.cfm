<!--- ------------------------------------------------------------------------- ----
	
	File:		getTraincasterTestResults.cfm
	Author:		Marcus Melo
	Date:		April 18, 2012
	Desc:		Runs every 3 hours - Get results from traincaster and inserts them
				into EXITS

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
    <cfsetting requesttimeout="9999">
    
    <cfscript>
		// ISE
	    vTraincasterMessage = APPLICATION.CFC.USER.importTraincasterTestResults(companyID=1);
		
		// CASE
	    vTotalResults = APPLICATION.CFC.USER.importTraincasterTestResults(companyID=10);
	</cfscript>
    
</cfsilent>

<cfoutput>
	#vTraincasterMessage#
</cfoutput>