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
<!----------------------------------------------------------
	Insert assignedID to existing smg_hostHistory
----------------------------------------------------------->
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


<!----------------------------------------------------------
	Insert current history
----------------------------------------------------------->
<!---
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
        	
            <cfquery datasource="mySQL" result="newRecord">
                INSERT
                    smg_hostHistory
                (
                    studentID,
                    assignedID,                     
                    hostID,
                    schoolID,
                    placeRepID,
                    areaRepID,
                    doublePlacementID,
                    changedBy,
                    isWelcomeFamily,
                    datePlaced,
                    doc_letter_rec_date,
                    doc_rules_rec_date,
                    doc_photos_rec_date,
                    doc_school_profile_rec,
                    doc_conf_host_rec,
                    doc_ref_form_1,
                    doc_ref_form_2,
                    isActive,
                    dateCreated                    
                )
                VALUES
                (
                	<cfqueryparam cfsqltype="cf_sql_integer" value="#qGetPlacedStudents.studentID#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetPlacedStudents.assignedID#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetPlacedStudents.hostID#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetPlacedStudents.schoolID#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetPlacedStudents.placeRepID#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetPlacedStudents.areaRepID#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetPlacedStudents.doublePlace#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="510">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetPlacedStudents.isWelcomeFamily#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#qGetPlacedStudents.datePlaced#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#qGetPlacedStudents.doc_letter_rec_date#" null="#NOT IsDate(qGetPlacedStudents.doc_letter_rec_date)#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#qGetPlacedStudents.doc_rules_rec_date#" null="#NOT IsDate(qGetPlacedStudents.doc_rules_rec_date)#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#qGetPlacedStudents.doc_photos_rec_date#" null="#NOT IsDate(qGetPlacedStudents.doc_photos_rec_date)#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#qGetPlacedStudents.doc_school_profile_rec#" null="#NOT IsDate(qGetPlacedStudents.doc_school_profile_rec)#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#qGetPlacedStudents.doc_conf_host_rec#" null="#NOT IsDate(qGetPlacedStudents.doc_conf_host_rec)#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#qGetPlacedStudents.doc_ref_form_1#" null="#NOT IsDate(qGetPlacedStudents.doc_ref_form_1)#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#qGetPlacedStudents.doc_ref_form_2#" null="#NOT IsDate(qGetPlacedStudents.doc_ref_form_2)#">,
                    <cfqueryparam cfsqltype="cf_sql_bit" value="1">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                )	
            </cfquery>
            
            <!--- Insert History --->
            <cfscript>
				vActions = "<p><strong>New Placement Information</strong> <br /> #CHR(13)# Updated by: EXITS <br /> #CHR(13)# </p>";
				
				// Insert Actions Into Separate Table
				APPLICATION.CFC.LOOKUPTABLES.insertApplicationHistory(
					applicationID=APPLICATION.CONSTANTS.TYPE.EXITS,
					foreignTable='smg_hostHistory',
					foreignID=newRecord.GENERATED_KEY,
					enteredByID=510,
					actions=vActions
				);			
            </cfscript>

        </cfif>
        
    </cfloop>

</cfoutput>

<p>complete</p>
--->