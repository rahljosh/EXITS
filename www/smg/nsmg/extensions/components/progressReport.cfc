<!--- ------------------------------------------------------------------------- ----
	
	File:		progressReport.cfc
	Author:		Marcus Melo
	Date:		December, 1 2009
	Desc:		This holds the functions needed for the progress report

----- ------------------------------------------------------------------------- --->

<cfcomponent 
	displayname="progressReport"
	output="false" 
	hint="A collection of functions for the company">


	<!--- Return the initialized Company object --->
	<cffunction name="Init" access="public" returntype="progressReport" output="false" hint="Returns the initialized User object">
		
		<cfscript>
			// There is nothing really to initiate, so just return this
			return(this);
		</cfscript>
        
	</cffunction>


	<cffunction name="getApprovedReports" access="public" returntype="query" output="false" hint="Gets a list of approved progress reports for batch printing">
    	<cfargument name="approvedFrom" type="date" hint="Approved from date">
        <cfargument name="approvedTo" type="date" hint="Approved to date">
        <cfargument name="regionIDs" type="string" default="" hint="List of Region IDs">
              
        <cfquery 
			name="qGetApprovedReports" 
			datasource="#APPLICATION.dsn#">
                SELECT 
					pr.pr_ID,
                    pr.fk_student,
                    pr.pr_uniqueID,
                   	pr.pr_month_of_report,
                    pr.pr_sr_approved_date,
                    pr.pr_ssr_approved_date,
                    pr.pr_ra_approved_date,
                    pr.pr_rd_approved_date,
                    pr.pr_ny_approved_date,
                    pr.pr_rejected_date,
                    pr.fk_rejected_by_user,
                    pr.pr_rejection_reason,
                    pr.fk_sr_user,
					pr.fk_ssr_user,
                    pr.fk_ra_user,
                    pr.fk_rd_user,
                    pr.fk_ny_user,
                    pr.fk_intrep_user,
                    pr.fk_host,
                    pr.fk_program,
                    s.studentID,
                    s.companyID,
                    s.regionAssigned,
                    s.firstName,  
                    s.familyLastName           
                FROM 
                	progress_reports pr
                INNER JOIN
                	smg_students s ON s.studentID = pr.fk_student
                WHERE 
                	pr.pr_ny_approved_date IS NOT NULL

				<cfif IsDate(ARGUMENTS.approvedFrom) AND IsDate(ARGUMENTS.approvedTo)>
                	AND 
                    (
                        pr.pr_ny_approved_date                                 
                        BETWEEN 
                        	<cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDateTime(ARGUMENTS.approvedFrom)#"> 
	                    AND 
    	                    <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDateTime(ARGUMENTS.approvedTo)#">
                    )                 	
                </cfif>    

                <cfif LEN(ARGUMENTS.regionIDs)>
                	AND
					(
                        <cfloop list="#ARGUMENTS.regionIDs#" index="rID">
                            s.regionAssigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#rID#">
                            <cfif rID NEQ ListLast(ARGUMENTS.regionIDs)>
                            OR
                            </cfif>
                        </cfloop>                            
					)             
				</cfif>

		</cfquery>
		   
		<cfreturn qGetApprovedReports>
	</cffunction>


	<cffunction name="getPRDates" access="public" returntype="query" output="false" hint="Gets progress report dates">
    	<cfargument name="prID" default="0" hint="Progress Report ID">
              
        <cfquery name="qGetPRDates" datasource="#application.dsn#">
            SELECT 
            	d.prdate_id,
                d.fk_progress_report,
                d.prdate_date,
                d.prdate_comments,
                d.fk_prdate_contact,
                d.fk_prdate_type,
                t.prdate_type_name, 
                c.prdate_contact_name                
            FROM 
            	progress_report_dates d
    		INNER JOIN 
            	prdate_types t ON d.fk_prdate_type = t.prdate_type_id
    		INNER JOIN 
            	prdate_contacts c ON d.fk_prdate_contact = c.prdate_contact_id
            WHERE 
            	d.fk_progress_report = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.prID#">
            ORDER BY 
            	d.prdate_date
        </cfquery>
		   
		<cfreturn qGetPRDates>
	</cffunction>


	<cffunction name="getPRQuestions" access="public" returntype="query" output="false" hint="Gets progress report questions">
    	<cfargument name="prID" default="0" hint="Progress Report ID">
              
        <cfquery name="qGetPRQuestions" datasource="#application.dsn#">
            SELECT 
            	x.x_pr_question_id,
                x.x_pr_question_response, 
                q.text
            FROM 
            	x_pr_questions x
            INNER JOIN 
            	smg_prquestions q ON x.fk_prquestion = q.id
            WHERE 
            	x.fk_progress_report = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.prID#">
            ORDER BY 
            	q.id
        </cfquery>
		   
		<cfreturn qGetPRQuestions>
	</cffunction>


	<cffunction name="getProgressReportByID" access="public" returntype="query" output="false" hint="Gets a progress report by ID">
    	<cfargument name="prID" default="0" hint="Progress Report ID">
              
        <cfquery 
			name="qGetProgressReportByID" 
			datasource="#APPLICATION.dsn#">
                SELECT 
					pr_ID,
					fk_student,
                    pr_uniqueID,
                    pr_month_of_report,
                    pr_sr_approved_date,
                    pr_ssr_approved_date,
                    pr_ra_approved_date,
                    pr_rd_approved_date,
                    pr_ny_approved_date,
                    pr_rejected_date,
                    fk_rejected_by_user,
                    pr_rejection_reason,
                    fk_sr_user,
					fk_ssr_user,
                    fk_ra_user,
                    fk_rd_user,
                    fk_ny_user,
                    fk_intrep_user,
                    fk_host,
                    fk_program
                FROM 
                	progress_reports
                WHERE 
                	pr_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.prID#">
		</cfquery>
		   
		<cfreturn qGetProgressReportByID>
	</cffunction>


</cfcomponent>