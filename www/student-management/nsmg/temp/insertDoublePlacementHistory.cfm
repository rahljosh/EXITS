<cfsetting requesttimeout="9999">

<cfquery name="qGetCurrentDoublePlacementDocs" datasource="#APPLICATION.DSN#">
    SELECT 
        s.studentID,
        s.doublePlace,
        s.dblplace_doc_host,
        s.dblplace_doc_stu,
        s.dblplace_doc_fam,
        s.dblplace_doc_school,
        s.dblplace_doc_dpt,
        h.historyID,
        sht.ID AS smgHostHistoryTrackingID,
        sht.fieldName       
    FROM
        smg_students s
    INNER JOIN
        smg_hostHistory h ON h.studentID = s.studentID
            AND
                h.assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
            AND
                h.hostID = s.hostID 
            AND
                h.isActive = <cfqueryparam cfsqltype="cf_sql_integer" value="1">  
    INNER JOIN
    	smg_hostHistoryTracking sht ON sht.historyID = h.historyID
        AND
        	fieldName = <cfqueryparam cfsqltype="cf_sql_varchar" value="doublePlacementID">
    	AND
        	fieldID = s.doublePlace
    WHERE 
        s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,5,10,12" list="yes"> )
    <!---
	AND
        s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1"> 
	--->		 
    AND
    	s.doublePlace != <cfqueryparam cfsqltype="cf_sql_bit" value="0">   
    ORDER BY
    	s.studentID
</cfquery>

<cfoutput>
	
    <cfloop query="qGetCurrentDoublePlacementDocs">
    
        <cfquery datasource="#APPLICATION.DSN#">
            UPDATE
                smg_hostHistoryTracking
            SET
                isDoublePlacementPaperworkRequired = <cfqueryparam cfsqltype="cf_sql_integer" value="1">,
                doublePlacementParentsDateSigned = <cfqueryparam cfsqltype="cf_sql_date" value="#qGetCurrentDoublePlacementDocs.dblplace_doc_fam#">,
                doublePlacementStudentDateSigned = <cfqueryparam cfsqltype="cf_sql_date" value="#qGetCurrentDoublePlacementDocs.dblplace_doc_stu#">,
                doublePlacementHostFamilyDateSigned = <cfqueryparam cfsqltype="cf_sql_date" value="#qGetCurrentDoublePlacementDocs.dblplace_doc_host#">
            WHERE	
                ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCurrentDoublePlacementDocs.smgHostHistoryTrackingID#">
        </cfquery>
    
    </cfloop>

	<p>#qGetCurrentDoublePlacementDocs.recordCount# records</p>
	
</cfoutput>

<!---
<!--- Double Place History Table --->
<cfquery name="qGetPreviousDoublePlacementDocs" datasource="#APPLICATION.DSN#">
    SELECT 
		dh.double_historyID,
        dh.studentID,
        dh.doublePlaceID,
        dh.userID,
        dh.reason,
        dh.date_change,
        dh.doc_student,
        dh.doc_naturalFamily,
        dh.doc_hostFamily,
        h.historyID,
        sht.ID AS smgHostHistoryTrackingID,
        sht.fieldName       
	FROM
    	smg_doublePlace_history dh 
    INNER JOIN
    	smg_hostHistory h ON h.studentID = dh.studentID
    INNER JOIN
    	smg_hostHistoryTracking sht ON sht.historyID = h.historyID
        AND
        	fieldName = <cfqueryparam cfsqltype="cf_sql_varchar" value="doublePlacementID">
    	AND
        	fieldID = dh.doublePlaceID  
    WHERE
    	dh.doc_student IS NOT NULL
    OR
        dh.doc_naturalFamily IS NOT NULL
    OR
        dh.doc_hostFamily IS NOT NULL   
</cfquery>

<cfoutput>
	
    <cfloop query="qGetPreviousDoublePlacementDocs">
    	
        <cfquery datasource="#APPLICATION.DSN#">
            UPDATE
                smg_hostHistoryTracking
            SET
                isDoublePlacementPaperworkRequired = <cfqueryparam cfsqltype="cf_sql_integer" value="1">,
                doublePlacementParentsDateSigned = <cfqueryparam cfsqltype="cf_sql_date" value="#qGetPreviousDoublePlacementDocs.doc_naturalFamily#">,
                doublePlacementStudentDateSigned = <cfqueryparam cfsqltype="cf_sql_date" value="#qGetPreviousDoublePlacementDocs.doc_student#">,
                doublePlacementHostFamilyDateSigned = <cfqueryparam cfsqltype="cf_sql_date" value="#qGetPreviousDoublePlacementDocs.doc_hostFamily#">
            WHERE	
                ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetPreviousDoublePlacementDocs.smgHostHistoryTrackingID#">
        </cfquery>
        
    </cfloop>

	<p>#qGetPreviousDoublePlacementDocs.recordCount# records</p>
	
</cfoutput>
--->


