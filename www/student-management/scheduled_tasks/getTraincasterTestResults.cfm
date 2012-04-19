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
		// Param FORM Variables
		param name="URL.date" default="";	
		
		// Make sure we have a valid date
		if ( NOT isDate(URL.date) ) {
			URL.date = DateFormat(now(), 'yyyy-mm-dd');
		}
	
		// ISE
	    vTraincasterISEMessage = APPLICATION.CFC.USER.importTraincasterTestResults(companyID=1,date=URL.date);
		
		// CASE
	    vTraincasterCaseMessage = APPLICATION.CFC.USER.importTraincasterTestResults(companyID=10,date=URL.date);
	</cfscript>
    
</cfsilent>

<cfoutput>
	#vTraincasterISEMessage#
    
    #vTraincasterCaseMessage#
</cfoutput>