<cfquery name="qGetReports" datasource="#APPLICATION.DSN#">
	SELECT
    	pr.pr_ID,
        pr.fk_sr_user,
        s.regionAssigned
	FROM
    	progress_reports pr
	INNER JOIN
    	smg_students s ON s.studentID = pr.fk_student
        	AND s.active = 1
            AND s.companyID IN (1,2,3,5,10,12)        
	WHERE
    	fk_ra_user IS NULL
	AND
    	 pr_ny_approved_date IS NULL 
</cfquery>

<cfloop query="qGetReports">

    <cfquery name="qGetRegionalAdvisorID" datasource="#APPLICATION.DSN#">
        SELECT 
        	advisorID
        FROM 
        	user_access_rights
        WHERE 
        	userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetReports.fk_sr_user#">
        AND 
        	regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetReports.regionAssigned#">
    </cfquery>
    
    <cfif VAL(qGetRegionalAdvisorID.advisorID)>
    
    	<cfquery datasource="#APPLICATION.DSN#">
        	UPDATE
            	progress_reports
            SET
            	fk_ra_user = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRegionalAdvisorID.advisorID#"> 
            WHERE
            	pr_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetReports.pr_ID#">           
        </cfquery>
    
    
    </cfif>
    
</cfloop>