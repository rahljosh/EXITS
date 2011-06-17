<cfscript>
	// Mutually Exclusive Bonus
	mutuallyExclusiveBonus = "9,15,17";
</cfscript>

<cfsetting requesttimeout="99999">

<cfquery name="qGetFastTrack" datasource="MySQL">
    SELECT
        studentID,
        paymentType,
        amount,
        date
	FROM
    	smg_rep_payments
	WHERE
		paymentType = <cfqueryparam cfsqltype="cf_sql_integer" value="17">
	AND
    	amount = <cfqueryparam cfsqltype="cf_sql_decimal" value="100">
	AND 
    	date >= <cfqueryparam cfsqltype="cf_sql_date" value="2011-01-01">   
	GROUP BY
    	studentID
    ORDER BY
    	studentID,
        paymentType                   
</cfquery>

<cfdump var="#qGetFastTrack#">

<cfloop query="qGetFastTrack">

    <cfquery name="qGetRecords" datasource="MySQL">
        SELECT
            id,
            agentID,
            studentID,
            programID,
            old_ProgramID,            
            paymentType,
            transtype,
            amount,
            comment,
            date,
            inputBy,
            companyID
        FROM
            smg_rep_payments
        WHERE
        	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetFastTrack.studentID#">              
		AND	
            paymentType IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#mutuallyExclusiveBonus#" list="yes"> ) 
        AND
            amount = <cfqueryparam cfsqltype="cf_sql_decimal" value="100">
        AND 
            date >= <cfqueryparam cfsqltype="cf_sql_date" value="2011-01-01"> 
    </cfquery>
	
    <cfif qGetRecords.recordCount EQ 3>
    
		<cfscript>
            // insert IDs into a list
         	listID = ValueList(qGetRecords.ID);			
        </cfscript>
		
        <!--- Delete Records --->
        <cfquery datasource="MySQL" result="newRecord">
            DELETE FROM
                smg_rep_payments
			WHERE
            	id IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#listID#" list="yes"> ) 
			AND	
            	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRecords.studentID#">              
        </cfquery>
        
        
        <!--- Insert One Record --->
        <cfquery datasource="MySQL" result="newRecord">
            INSERT INTO 
                smg_rep_payments
            (
                agentid, 
                studentID, 
                programID,
                old_ProgramID,
                paymenttype, 
                date, 
                transtype, 
                inputby, 
                amount, 
                companyID, 
                comment
            )
            VALUES 
            (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRecords.agentid#">, 
                <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRecords.studentID#">, 
                <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRecords.programID#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRecords.old_ProgramID#">, 
                <cfqueryparam cfsqltype="cf_sql_integer" value="17">, 
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#qGetRecords.date#">, 
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetRecords.transtype#">, 
                <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRecords.inputby#">, 
                <cfqueryparam cfsqltype="cf_sql_decimal" value="300.00">, 
                <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRecords.companyID#">, 
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetRecords.comment#">
            )
        </cfquery>
        
    <cfelse>
    
    	<p>Check This</p>	
        <cfdump var="#qGetRecords#"> <br><br>
        
	</cfif>
            
</cfloop>