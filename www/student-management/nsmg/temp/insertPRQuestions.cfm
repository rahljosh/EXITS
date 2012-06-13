
<!--- Insert Progress Reports Questions --->
<cfquery name="qGetPrMissingQuestions" datasource="#APPLICATION.DSN#">
SELECT
	pr.pr_ID,
    pr.pr_month_of_report,
    s.studentID,
    s.companyID
FROM
	progress_reports pr
INNER JOIN
	smg_students s ON s.studentID = pr.fk_student
LEFT OUTER JOIN
	x_pr_questions xprq ON xprq.fk_progress_report = pr.pr_ID  	
WHERE
	pr.fk_reportType = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
AND
   xprq.x_pr_question_id IS NULL
ORDER BY
	s.companyID   
</cfquery>

<cfloop query="qGetPrMissingQuestions">

    <cfquery name="qGetQuestions" datasource="#APPLICATION.DSN#">
        SELECT 
            * 
        FROM 
            smg_prquestions
        WHERE 
			month = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetPrMissingQuestions.pr_month_of_report#">             
		AND
        	active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            
		<cfif listFind("1,2,3,4,5", qGetPrMissingQuestions.companyID)>
            AND
                companygroup = <cfqueryparam cfsqltype="cf_sql_varchar" value="ISE">
        <cfelseif qGetPrMissingQuestions.companyID EQ 10>
            AND
                companygroup = <cfqueryparam cfsqltype="cf_sql_varchar" value="CASE">
        </cfif>
    </cfquery>
    
    <cfloop query="qGetQuestions">
    
        <cfquery datasource="#APPLICATION.DSN#">
            INSERT INTO 
            	x_pr_questions
            (
                fk_progress_report, 
                fk_prquestion
            )
            VALUES (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetPrMissingQuestions.pr_id#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetQuestions.id#">
            )
        </cfquery>
        
    </cfloop>
    
</cfloop>

<cfoutput>
	#qGetPrMissingQuestions.recordCount# total records.    
    <cfdump var="#qGetPrMissingQuestions#">
</cfoutput>