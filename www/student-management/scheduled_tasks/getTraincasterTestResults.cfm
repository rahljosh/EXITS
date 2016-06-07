<!--- ------------------------------------------------------------------------- ----
	
	File:		getTraincasterTestResults.cfm
	Author:		Marcus Melo
	Date:		April 18, 2012
	Desc:		Runs every 3 hours - Get results from traincaster and inserts them
				into EXITS

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->

	
    <cfsetting requesttimeout="9999">
    
    <cfscript>
	
		// ISE
	    vTraincasterISEMessage = APPLICATION.CFC.USER.importTraincasterTestResults(companyID=1);
		
		// CASE
	   vTraincasterCaseMessage = APPLICATION.CFC.USER.importGyrusAimTestResults(companyID=10);
	</cfscript>
    


