<!--- ------------------------------------------------------------------------- ----
	
	File:		inactivateRecords.cfm
	Author:		Marcus Melo
	Date:		July 26, 2011
	Desc:		Scheduled Task - Inactivate Records
				It should be run daily as program end date varies

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- WAT Candidates - Set them inactive --->
    <cfquery name="qSetExpiredCandidates" datasource="mysql">
        UPDATE 
            extra_candidates
        SET 
            status = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
        WHERE 
            companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
        AND    
            status = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND
            endDate < CURRENT_DATE()
    </cfquery>

</cfsilent>

<p>Done!</p>