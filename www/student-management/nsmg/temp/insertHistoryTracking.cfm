<cfsetting requesttimeout="9999">

<cfquery name="qGetPlacedStudents" datasource="#APPLICATION.DSN#">
    SELECT 
        s.studentID, 
        s.companyID,
        s.hostID,  
        s.schoolID,
        s.placeRepID, 
        s.areaRepID,
        s.secondVisitRepID, 
        s.doublePlace,
        s.isWelcomeFamily
    FROM 
    	smg_students s
    WHERE 
    	s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
    AND
    	s.hostID != <cfqueryparam cfsqltype="cf_sql_bit" value="0">
    AND
    	s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,5,10,12" list="yes"> )
    ORDER BY
    	s.companyID,
        s.studentID
</cfquery>

<cfoutput>
	
    <p>Total of #qGetPlacedStudents.recordCount# of students</p>
    
    <cfloop query="qGetPlacedStudents">
    
        <cfquery name="qSearchHistory" datasource="#APPLICATION.DSN#">
            SELECT
                *
            FROM
                smg_hosthistory
            WHERE
                studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetPlacedStudents.studentID#">
            <!--- Do Not Include PHP --->
            AND
            	assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
            AND
                hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetPlacedStudents.hostID#">
            AND
                schoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetPlacedStudents.schoolID#">
            AND
                placeRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetPlacedStudents.placeRepID#">
            AND
                areaRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetPlacedStudents.areaRepID#">
            AND
                secondVisitRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetPlacedStudents.secondVisitRepID#">
            AND
                doublePlacementID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetPlacedStudents.doublePlace#">
        </cfquery>
        
        <cfif NOT VAL(qSearchHistory.recordCount)>
            
            <p>#qGetPlacedStudents.studentID# - #qGetPlacedStudents.companyID#</p>
        
        </cfif>
        
    </cfloop>

</cfoutput>

<p>complete</p>

<!---

<!--- Insert History Tracking --->
<cfquery name="qGetNewRecords" datasource="#APPLICATION.DSN#">
    SELECT 
        ah.actions,
        sh.historyID, 
        sh.studentID,       
        sh.hostID,
        sh.schoolID,
        sh.placeRepID,
        sh.areaRepID,
        sh.secondVisitRepID,
        sh.doublePlacementID,           
        sh.dateCreated
    FROM 
    	applicationhistory ah
    INNER JOIN
    	smg_hosthistory sh on sh.historyID = ah.foreignID and ah.foreignTable = 'smg_hosthistory' 
    WHERE 
    	ah.enteredByID = 510
    <!---
    AND 
    	sh.dateCreated >= '2011-11-16 15:30:00'
    AND 
    	sh.dateCreated <= '2011-11-21 16:35:00'
    AND 
    	sh.historyID < 53367
	--->
    ORDER BY
   		historyID
</cfquery>

<cfloop query="qGetNewRecords">
	
    <!--- HostID --->
    <cfif VAL(qGetNewRecords.hostID)>
    	
        <cfquery name="qSearchRecord" datasource="#APPLICATION.DSN#">
            SELECT 
                ID
            FROM 
                smg_hosthistorytracking
            WHERE 
                historyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetNewRecords.historyID)#">
            AND
            	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetNewRecords.studentID)#">
            AND 
            	fieldName = <cfqueryparam cfsqltype="cf_sql_varchar" value="hostID">
            AND
            	fieldID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetNewRecords.hostID)#">
        </cfquery>
        
        <cfif NOT VAL(qSearchRecord.recordCount)>

            <cfquery datasource="#APPLICATION.DSN#">
                INSERT
                    smg_hosthistorytracking
                (
                	historyID,
                    studentID,
                    fieldName,
                    fieldID,
                    dateCreated
                )
                VALUES
                (
                	<cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetNewRecords.historyID)#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetNewRecords.studentID)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="hostID">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetNewRecords.hostID)#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                ) 
            </cfquery>
        
        </cfif>
        
    </cfif>
    

    <!--- schoolID --->
    <cfif VAL(qGetNewRecords.schoolID)>
    	
        <cfquery name="qSearchRecord" datasource="#APPLICATION.DSN#">
            SELECT 
                ID
            FROM 
                smg_hosthistorytracking
            WHERE 
                historyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetNewRecords.historyID)#">
            AND
            	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetNewRecords.studentID)#">
            AND 
            	fieldName = <cfqueryparam cfsqltype="cf_sql_varchar" value="schoolID">
            AND
            	fieldID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetNewRecords.schoolID)#">
        </cfquery>
        
        <cfif NOT VAL(qSearchRecord.recordCount)>

            <cfquery datasource="#APPLICATION.DSN#">
                INSERT
                    smg_hosthistorytracking
                (
                	historyID,
                    studentID,
                    fieldName,
                    fieldID,
                    dateCreated
                )
                VALUES
                (
                	<cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetNewRecords.historyID)#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetNewRecords.studentID)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="schoolID">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetNewRecords.schoolID)#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                ) 
            </cfquery>
        
        </cfif>
        
    </cfif>
    
    
    <!--- placeRepID --->
    <cfif VAL(qGetNewRecords.placeRepID)>
    	
        <cfquery name="qSearchRecord" datasource="#APPLICATION.DSN#">
            SELECT 
                ID
            FROM 
                smg_hosthistorytracking
            WHERE 
                historyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetNewRecords.historyID)#">
            AND
            	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetNewRecords.studentID)#">
            AND 
            	fieldName = <cfqueryparam cfsqltype="cf_sql_varchar" value="placeRepID">
            AND
            	fieldID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetNewRecords.placeRepID)#">
        </cfquery>
        
        <cfif NOT VAL(qSearchRecord.recordCount)>

            <cfquery datasource="#APPLICATION.DSN#">
                INSERT
                    smg_hosthistorytracking
                (
                	historyID,
                    studentID,
                    fieldName,
                    fieldID,
                    dateCreated
                )
                VALUES
                (
                	<cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetNewRecords.historyID)#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetNewRecords.studentID)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="placeRepID">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetNewRecords.placeRepID)#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                ) 
            </cfquery>
        
        </cfif>
        
    </cfif>
    

    <!--- areaRepID --->
    <cfif VAL(qGetNewRecords.areaRepID)>
    	
        <cfquery name="qSearchRecord" datasource="#APPLICATION.DSN#">
            SELECT 
                ID
            FROM 
                smg_hostHistoryTracking
            WHERE 
                historyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetNewRecords.historyID)#">
            AND
            	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetNewRecords.studentID)#">
            AND 
            	fieldName = <cfqueryparam cfsqltype="cf_sql_varchar" value="areaRepID">
            AND
            	fieldID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetNewRecords.areaRepID)#">
        </cfquery>
        
        <cfif NOT VAL(qSearchRecord.recordCount)>

            <cfquery datasource="#APPLICATION.DSN#">
                INSERT
                    smg_hostHistoryTracking
                (
                	historyID,
                    studentID,
                    fieldName,
                    fieldID,
                    dateCreated
                )
                VALUES
                (
                	<cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetNewRecords.historyID)#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetNewRecords.studentID)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="areaRepID">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetNewRecords.areaRepID)#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                ) 
            </cfquery>
        
        </cfif>
        
    </cfif>
    
    
    <!--- secondVisitRepID --->
    <cfif VAL(qGetNewRecords.secondVisitRepID)>
    	
        <cfquery name="qSearchRecord" datasource="#APPLICATION.DSN#">
            SELECT 
                ID
            FROM 
                smg_hostHistoryTracking
            WHERE 
                historyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetNewRecords.historyID)#">
            AND
            	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetNewRecords.studentID)#">
            AND 
            	fieldName = <cfqueryparam cfsqltype="cf_sql_varchar" value="secondVisitRepID">
            AND
            	fieldID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetNewRecords.secondVisitRepID)#">
        </cfquery>
        
        <cfif NOT VAL(qSearchRecord.recordCount)>

            <cfquery datasource="#APPLICATION.DSN#">
                INSERT
                    smg_hostHistoryTracking
                (
                	historyID,
                    studentID,
                    fieldName,
                    fieldID,
                    dateCreated
                )
                VALUES
                (
                	<cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetNewRecords.historyID)#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetNewRecords.studentID)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="secondVisitRepID">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetNewRecords.secondVisitRepID)#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                ) 
            </cfquery>
        
        </cfif>
        
    </cfif>
    
    
    <!--- doublePlacementID --->
    <cfif VAL(qGetNewRecords.doublePlacementID)>
    	
        <cfquery name="qSearchRecord" datasource="#APPLICATION.DSN#">
            SELECT 
                ID
            FROM 
                smg_hostHistoryTracking
            WHERE 
                historyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetNewRecords.historyID)#">
            AND
            	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetNewRecords.studentID)#">
            AND 
            	fieldName = <cfqueryparam cfsqltype="cf_sql_varchar" value="doublePlacementID">
            AND
            	fieldID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetNewRecords.doublePlacementID)#">
        </cfquery>
        
        <cfif NOT VAL(qSearchRecord.recordCount)>

            <cfquery datasource="#APPLICATION.DSN#">
                INSERT
                    smg_hostHistoryTracking
                (
                	historyID,
                    studentID,
                    fieldName,
                    fieldID,
                    dateCreated
                )
                VALUES
                (
                	<cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetNewRecords.historyID)#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetNewRecords.studentID)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="doublePlacementID">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetNewRecords.doublePlacementID)#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                ) 
            </cfquery>
        
        </cfif>
        
    </cfif>
        
</cfloop>

--->