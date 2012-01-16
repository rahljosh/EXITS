<cfsetting requesttimeout="9999">

<cfquery name="qGetPlacedStudents" datasource="mySQL">
    SELECT 
        s.studentID, 
		<!--- FROM THE PHP_STUDENTS_IN_PROGRAM TABLE --->		
        php.assignedID, 
        php.studentID,
        php.companyID,
        php.programID,
        php.hostID,
        php.isWelcomeFamily,
        php.schoolID,
        php.areaRepID,
        php.placeRepID,
        php.doublePlace,
        php.placementNotes,
        php.datePlaced,
        php.dateApproved,        
        php.datePISEmailed,
        php.doc_evaluation2, 
        php.doc_evaluation4, 
        php.doc_evaluation6,
        php.doc_evaluation9,
        php.doc_evaluation12, 
        php.doc_grade1, 
        php.doc_grade2,
        php.doc_grade3, 
        php.doc_grade4, 
        php.doc_grade5, 
        php.doc_grade6,
        php.doc_grade7,
        php.doc_grade8,
        php.active,
        php.welcome_letter_printed,
        php.school_acceptance, 
        php.sevis_fee_paid, 
        php.i20no, 
        php.i20received, 
        php.i20note,
        php.i20sent, 
        php.hf_placement, 
        php.hf_application, 
        php.doc_letter_rec_date,
        php.doc_rules_rec_date,
        php.doc_photos_rec_date,
        php.doc_school_profile_rec,
        php.doc_conf_host_rec,
        php.doc_ref_form_1,
        php.doc_ref_form_2,
        php.inputBy               
    FROM 
        smg_students s
    INNER JOIN 
        php_students_in_program php ON php.studentID = s.studentID
    WHERE 
    	php.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
    AND
    	php.schoolID != <cfqueryparam cfsqltype="cf_sql_bit" value="0">
    ORDER BY
        s.programID DESC,
        s.studentID
</cfquery>


<!---

<cfoutput>
	
    <p>Total of #qGetPlacedStudents.recordCount# of students</p>
    
    <cfloop query="qGetPlacedStudents">
		
        <cfquery datasource="mySQL">
			UPDATE
            	smg_hostHistory
            SET	
            	assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetPlacedStudents.assignedID#">
            WHERE
            	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetPlacedStudents.studentID#">
			AND
            	schoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetPlacedStudents.schoolID#">
        </cfquery>
	
    </cfloop>
    
</cfoutput>	 

--->   


<cfoutput>
	
    <p>Total of #qGetPlacedStudents.recordCount# of students</p>
    
    <cfloop query="qGetPlacedStudents">
    
        <cfquery name="qSearchHistory" datasource="mySQL">
            SELECT
                *
            FROM
                smg_hostHistory
            WHERE
                studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetPlacedStudents.studentID#">
            AND
                hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetPlacedStudents.hostID#">
            AND
                schoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetPlacedStudents.schoolID#">
            AND
                placeRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetPlacedStudents.placeRepID#">
            AND
                areaRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetPlacedStudents.areaRepID#">
            AND
                doublePlacementID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetPlacedStudents.doublePlace#">
        </cfquery>
        
        <cfif NOT VAL(qSearchHistory.recordCount)>
            
            <p>#qGetPlacedStudents.studentID#</p>
        
        </cfif>
        
    </cfloop>

</cfoutput>

<p>complete</p>


<!---

<!--- Insert History Tracking --->
<cfquery name="qGetNewRecords" datasource="mySQL">
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
    	applicationHistory ah
    INNER JOIN
    	smg_hostHistory sh on sh.historyID = ah.foreignID and ah.foreignTable = 'smg_hostHistory' 
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
    	
        <cfquery name="qSearchRecord" datasource="mySQL">
            SELECT 
                ID
            FROM 
                smg_hostHistoryTracking
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

            <cfquery datasource="mySQL">
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
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="hostID">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetNewRecords.hostID)#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                ) 
            </cfquery>
        
        </cfif>
        
    </cfif>
    

    <!--- schoolID --->
    <cfif VAL(qGetNewRecords.schoolID)>
    	
        <cfquery name="qSearchRecord" datasource="mySQL">
            SELECT 
                ID
            FROM 
                smg_hostHistoryTracking
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

            <cfquery datasource="mySQL">
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
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="schoolID">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetNewRecords.schoolID)#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                ) 
            </cfquery>
        
        </cfif>
        
    </cfif>
    
    
    <!--- placeRepID --->
    <cfif VAL(qGetNewRecords.placeRepID)>
    	
        <cfquery name="qSearchRecord" datasource="mySQL">
            SELECT 
                ID
            FROM 
                smg_hostHistoryTracking
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

            <cfquery datasource="mySQL">
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
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="placeRepID">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetNewRecords.placeRepID)#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                ) 
            </cfquery>
        
        </cfif>
        
    </cfif>
    

    <!--- areaRepID --->
    <cfif VAL(qGetNewRecords.areaRepID)>
    	
        <cfquery name="qSearchRecord" datasource="mySQL">
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

            <cfquery datasource="mySQL">
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
    	
        <cfquery name="qSearchRecord" datasource="mySQL">
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

            <cfquery datasource="mySQL">
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
    	
        <cfquery name="qSearchRecord" datasource="mySQL">
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

            <cfquery datasource="mySQL">
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