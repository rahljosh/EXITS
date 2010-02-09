<!---
	01/29/2010
	Merge Programs
--->

<cfsetting requesttimeout="99999">

<cfoutput>

<!--- Set old_programID --->

<!--- PROGRESS REPORTS  --->
<cfquery name="qProgressReport" datasource="MySQL">
    SELECT 
    	r.pr_id,
        r.fk_student,
        r.fk_program
    FROM 
    	progress_reports r
    INNER JOIN 
    	smg_programs p ON p.programID = r.fk_program <!--- AND p.companyID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="2,3,4,5,10" list="yes">) ---> 
    WHERE 
    	r.old_programID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
	LIMIT
    	5000        
</cfquery>

<cfloop query="qProgressReport">

    <cfquery datasource="MySQL">
        UPDATE 
            progress_reports
		SET
        	old_programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qProgressReport.fk_program#">
        WHERE 
            pr_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#qProgressReport.pr_id#">
    </cfquery>
    
</cfloop>

#qProgressReport.recordCount # - PROGRESS REPORTS COMPLETED <br><br>


<!--- SMG CHARGES --->
<cfquery name="qCharges" datasource="MySQL">
    SELECT 
    	c.chargeID,
        c.programID
    FROM 
    	smg_charges c
    INNER JOIN 
    	smg_programs p ON p.programID = c.programID <!--- AND p.companyID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="2,3,4,5,10" list="yes">) --->
    WHERE 
    	c.old_programID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
	LIMIT
    	5000                
</cfquery>

<cfloop query="qCharges">

    <cfquery datasource="MySQL">
        UPDATE 
            smg_charges
		SET
        	old_programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qCharges.programID#">
        WHERE 
            chargeID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qCharges.chargeID#">
    </cfquery>
    
</cfloop>

#qCharges.recordCount # - SMG CHARGES COMPLETED <br><br>


<!--- SMG CSIET HISTORY --->
<cfquery name="qCSIET" datasource="MySQL">
    SELECT 
    	c.historyID,
        c.programID
    FROM 
    	smg_csiet_history c
    INNER JOIN 
    	smg_programs p ON p.programID = c.programID <!--- AND p.companyID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="2,3,4,5,10" list="yes">) --->
    WHERE 
    	c.old_programID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
	LIMIT
    	5000                
</cfquery>

<cfloop query="qCSIET">

    <cfquery datasource="MySQL">
        UPDATE 
            smg_csiet_history
		SET
        	old_programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qCSIET.programID#">
        WHERE 
            historyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qCSIET.historyID#">
    </cfquery>
    
</cfloop>

#qCSIET.recordCount # - SMG CSIET HISTORY  COMPLETED <br><br>


<!--- SMG REP PAYMENTS --->
<cfquery name="qRepPayments" datasource="MySQL">
    SELECT 
    	r.id,
        r.programID
    FROM 
    	smg_rep_payments r
    INNER JOIN 
    	smg_programs p ON p.programID = r.programID <!--- AND p.companyID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="2,3,4,5,10" list="yes">) --->
    WHERE 
    	r.old_programID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
	LIMIT
    	5000                
</cfquery>

<cfloop query="qRepPayments">

    <cfquery datasource="MySQL">
        UPDATE 
            smg_rep_payments
		SET
        	old_programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qRepPayments.programID#">
        WHERE 
            id = <cfqueryparam cfsqltype="cf_sql_integer" value="#qRepPayments.id#">
    </cfquery>
    
</cfloop>

#qRepPayments.recordCount # - SMG REP PAYMENTS COMPLETED <br><br>


<!--- SMG STUDENTS --->
<cfquery name="qStudents" datasource="MySQL">
    SELECT 
    	s.studentID,
        s.programID
    FROM 
    	smg_students s
    INNER JOIN 
    	smg_programs p ON p.programID = s.programID <!--- AND p.companyID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="2,3,4,5,10" list="yes">) --->
    WHERE 
    	s.old_programID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
	LIMIT
    	5000        
</cfquery>

<cfloop query="qStudents">

    <cfquery datasource="MySQL">
        UPDATE 
            smg_students
		SET
        	old_programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qStudents.programID#">
        WHERE 
            studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qStudents.studentID#">
    </cfquery>
    
</cfloop>

#qStudents.recordCount # - SMG STUDENTS COMPLETED <br><br>

</cfoutput>


<!--- End of Set old_programID --->
---------------------------------------------- <br /><br />


<cfquery name="getISEProg" datasource="MySQL">
    SELECT 
    	programID, 
        programname, 
        companyID,
        startdate, 
        enddate, 
        type
    FROM 
    	smg_programs
    WHERE 
    	companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
	ORDER BY
    	programName        
</cfquery>

<cfloop query="getISEProg">

	<cfquery name="getSimilarProg" datasource="MySQL">
        SELECT 
        	programID, 
            programname
        FROM 
        	smg_programs
        WHERE 
        	companyid != <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND 
        	programname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#getISEProg.programname#">	            
	</cfquery>

	<cfdump var="#getSimilarProg#"> <br />

	<cfset programList = ValueList(getSimilarProg.programID)>
	
	<cfif getSimilarProg.recordCount>
		
		<!--- Progress Reports --->
        <cfquery datasource="MySQL">
            UPDATE 
                progress_reports
            SET
                fk_program = <cfqueryparam cfsqltype="cf_sql_integer" value="#getISEProg.programID#">
            WHERE 
            	fk_program IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#programList#" list="yes">)
			AND	
            	old_programID != <cfqueryparam cfsqltype="cf_sql_integer" value="0">                
        </cfquery>
		
        Progress Reports OK <br /><br />
		
        
		<!--- SMG Charges --->
        <cfquery datasource="MySQL">
            UPDATE 
                smg_charges
            SET
                programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getISEProg.programID#">
            WHERE 
            	programID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#programList#" list="yes">)
			AND	
            	old_programID != <cfqueryparam cfsqltype="cf_sql_integer" value="0">                
        </cfquery>

		SMG Charges OK <br /><br />


		<!--- SMG CSIET HISTORY --->
        <cfquery datasource="MySQL">
            UPDATE 
                smg_csiet_history
            SET
                programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getISEProg.programID#">
            WHERE 
            	programID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#programList#" list="yes">)
			AND	
            	old_programID != <cfqueryparam cfsqltype="cf_sql_integer" value="0">                
        </cfquery>

		SMG CSIET HISTORY OK <br /><br />
        
        
		<!--- SMG REP PAYMENTS --->
        <cfquery datasource="MySQL">
            UPDATE 
                smg_rep_payments
            SET
                programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getISEProg.programID#">
            WHERE 
            	programID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#programList#" list="yes">)
			AND	
            	old_programID != <cfqueryparam cfsqltype="cf_sql_integer" value="0">                
        </cfquery>

		SMG REP PAYMENTS OK <br /><br />

        <!--- SMG Students --->
		<cfquery datasource="MySQL">
            UPDATE 
            	smg_students
            SET 
            	programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getISEProg.programID#">
            WHERE 
            	programID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#programList#" list="yes">)
			AND	
            	old_programID != <cfqueryparam cfsqltype="cf_sql_integer" value="0">                
		</cfquery>
		
        SMG Students OK <br /><br />
        
		<!--- Inactivate Program --->
		<cfquery datasource="MySQL">
            UPDATE 
            	smg_programs
            SET 
                new_programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getISEProg.programID#">,
				active = <cfqueryparam cfsqltype="cf_sql_integer" value="0">,
				is_deleted = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            WHERE 
            	programID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#programList#" list="yes">)
		</cfquery>
	
	</cfif>

</cfloop>

Done!

