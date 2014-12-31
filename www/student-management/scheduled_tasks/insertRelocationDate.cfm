<!--- ------------------------------------------------------------------------- ----
	
	File:		insertRelocationDate.cfm
	Author:		Marcus Melo
	Date:		April 3, 2012
	Desc:		Insert relocation date

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
    
    <cfquery name="qGetRelocations" datasource="#APPLICATION.DSN#">
        SELECT 
            s.studentID, 
            sh.historyID,
            sh.datePlaced,
            sh.dateRelocated
        FROM 
            smg_students s
        INNER JOIN
            smg_hosthistory sh ON sh.studentID = s.studentID
                AND
                    sh.assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                AND
                    sh.hostID != <cfqueryparam cfsqltype="cf_sql_integer" value="0">    
                AND
                    sh.isRelocation = <cfqueryparam cfsqltype="cf_sql_bit" value="1">            
                AND
                    sh.dateRelocated IS NULL
				AND
                	sh.datePlaced IS NOT NULL                    
        WHERE 
            s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,5,10,12" list="yes"> )
        ORDER BY
            s.studentID
    </cfquery>

</cfsilent>
    
<cfloop query="qGetRelocations">

    <cfquery datasource="#APPLICATION.DSN#">
        UPDATE
            smg_hosthistory
        SET
            dateRelocated = <cfqueryparam cfsqltype="cf_sql_date" value="#qGetRelocations.datePlaced#">,
            updatedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">
        WHERE	
            historyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRelocations.historyID#">
    </cfquery>

</cfloop>

<p>Relocation Date Updated</p>
