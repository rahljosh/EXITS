<cfsetting requesttimeout="9999">

<cfquery name="qGetPlacedStudents" datasource="#APPLICATION.DSN#">
    SELECT 
        s.studentID, 
        s.companyID,
        COUNT(s.studentID) AS totalHistoryRecords
    FROM 
    	smg_students s
	INNER JOIN
    	smg_hosthistory sh ON sh.studentID = s.studentID
        	AND
            	sh.assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
			AND
            	sh.hostID != <cfqueryparam cfsqltype="cf_sql_integer" value="0">                
    WHERE 
    	s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
    AND
    	s.hostID != <cfqueryparam cfsqltype="cf_sql_bit" value="0">
    AND
    	s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,5,10,12" list="yes"> )
	<!---
	AND
    	datePlacedEnded IS NULL   
    --->
	GROUP BY
    	s.studentID
	HAVING 
      	totalHistoryRecords >= 2    
    ORDER BY
    	totalHistoryRecords DESC,
    	s.companyID,
        s.studentID
</cfquery>

<cfoutput>
	
    <p>Total of #qGetPlacedStudents.recordCount# of students</p>
    
    <cfloop query="qGetPlacedStudents">
    	
        <cfquery name="qSearchHistory" datasource="#APPLICATION.DSN#">
            SELECT
                historyID,
                studentID,
                datePlaced,
                datePlacedEnded,
                dateOfChange,                
                dateCreated
            FROM
                smg_hosthistory
            WHERE
                studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetPlacedStudents.studentID#">
			<!--- Do Not Include PHP --->
            AND
                assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
			AND
            	hostID != <cfqueryparam cfsqltype="cf_sql_integer" value="0">                
            ORDER BY
                historyID DESC                
        </cfquery>
        
        <cfscript>
			vPreviousDatePlaced = '';
		</cfscript>
        
        <cfloop query="qSearchHistory">
			
            <cfif isDate(vPreviousDatePlaced)>
            
            	<p>HistoryID = #qSearchHistory.historyID# - vPreviousDatePlaced = #vPreviousDatePlaced#</p>
                
                <cfquery datasource="#APPLICATION.DSN#">
                	UPDATE
                    	smg_hosthistory
                    SET
                    	datePlacedEnded = <cfqueryparam cfsqltype="cf_sql_date" value="#vPreviousDatePlaced#">,
                        updatedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">
                    WHERE	
                    	historyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qSearchHistory.historyID#">
                </cfquery>
                
            </cfif>
            
			<cfscript>
				vPreviousDatePlaced = qSearchHistory.datePlaced;
			</cfscript>

        </cfloop>
        
    </cfloop>

</cfoutput>

<p>complete</p>


<!--- Copied to scheduled tasks --->
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
    WHERE 
    	s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,5,10,12" list="yes"> )
    ORDER BY
        s.studentID
</cfquery>

<cfloop query="qGetRelocations">

    <cfquery datasource="#APPLICATION.DSN#">
        UPDATE
            smg_hosthistory
        SET
            dateRelocated = <cfqueryparam cfsqltype="cf_sql_date" value="#datePlaced#">,
            updatedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">
        WHERE	
            historyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRelocations.historyID#">
    </cfquery>

</cfloop>

<p>Relocation Date Updated</p>
