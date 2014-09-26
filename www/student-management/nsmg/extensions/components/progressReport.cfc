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
                    <!--- Student --->
                    s.studentID,
                    s.firstName,  
                    s.familyLastName,
                    <!--- Company --->
                    c.companyID,
                    <!--- Program --->
                    p.programID,
                    p.programName,
                    <!--- Host Family --->
                    h.hostID,
                    h.fatherfirstname as hostFatherName,
                    h.motherfirstname as hostMotherName,
                    h.familylastname as hostLastName,
                    <!--- Int Rep --->
                    intRep.userID as intRepUserID,
                    intRep.businessName as intRepBusinessName,                    
                    <!--- Facilitator --->
                    fac.userID as facUserID,
                    fac.firstName as facFirstName,
                    fac.lastName as facLastName,
                    <!--- Super Rep --->
                    super.userID as superUserID,
                    super.firstName as superFirstName,
                    super.lastName as superLastName,
                    <!--- Regional Advisor --->
                    adv.userID as advisorUserID,
                    adv.firstName as advisorFirstName,
                    adv.lastName as advisorLastName,
                    <!--- Regional Director --->
                    dir.userID as directorUserID,
                    dir.firstName as directorFirstName,
                    dir.lastName as directorLastName
                FROM 
                	progress_reports pr
                INNER JOIN
                	smg_students s ON s.studentID = pr.fk_student
                INNER JOIN
                	smg_companies c ON c.companyID = s.companyID                    
                INNER JOIN
                	smg_programs p ON p.programID = pr.fk_program
                INNER JOIN
                	smg_hosts h ON h.hostID = pr.fk_host                
				INNER JOIN
                	smg_users intRep ON intRep.userID = pr.fk_intrep_user
                INNER JOIN
                	smg_users fac ON fac.userID = pr.fk_ny_user
                LEFT OUTER JOIN
                	smg_users super ON super.userID = pr.fk_sr_user
                LEFT OUTER JOIN
                	smg_users adv ON adv.userID = pr.fk_ra_user
                LEFT OUTER JOIN
                	smg_users dir ON dir.userID = pr.fk_rd_user
                
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
    	<cfargument name="prID" default="" hint="Progress Report ID">
        <cfargument name="hostID" default="" hint="host ID">
        <cfargument name="reportType" default="" hint="Report Type">
              
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
                	1 = 1
                
                <cfif LEN(ARGUMENTS.prID)>
                    AND
                        pr_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.prID)#">
                </cfif>                       	

                <cfif LEN(ARGUMENTS.hostID)>
                    AND
                        fk_host = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">
                </cfif>                       	

                <cfif LEN(ARGUMENTS.reportType)>
                    AND
                        fk_reportType = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.reportType)#">
                </cfif>                       	

		</cfquery>
		   
		<cfreturn qGetProgressReportByID>
	</cffunction>


	<!--- ------------------------------------------------------------------------- ----
		
		Second Visit Report
	
	----- ------------------------------------------------------------------------- --->

	<cffunction name="getVisitInformation" access="public" returntype="query" output="false" hint="Gets the initial/second host family visit">
    	<cfargument name="prID" default="" hint="Progress Report ID">
        <cfargument name="hostID" default="" hint="host ID">
        <cfargument name="reportType" default="" hint="Report Type">
        <cfargument name="seasonID" default="" hint="seasonID is not required">
		
        <cfquery 
			name="qGetVisitInformation" 
			datasource="#APPLICATION.dsn#">
                SELECT 
					pr.pr_ID,
					pr.fk_student,
                    pr.fk_seasonID,
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
                    sva.ID,
                    sva.fk_reportID,                    
                    sva.fk_studentID,
                    sva.neighborhoodAppearance,
                    sva.avoid,
                    sva.homeAppearance,
                    sva.typeOfHome,
                    sva.numberBedrooms,
                    sva.numberBathrooms,
                    sva.livingRoom,
                    sva.diningRoom,
                    sva.kitchen,
                    sva.homeDetailsOther,
                    sva.ownBed,
                    sva.bathroom,
                    sva.outdoorsFromBedroom,
                    sva.storageSpace,
                    sva.privacy,
                    sva.studySpace,
                    sva.pets,
                    sva.other,
                    sva.dateOfVisit,
                    sva.dateCompliance,
                    sva.famImpression,
                    sva.famInterested,
                    sva.exchangeInterest,
                    sva.livingYear,
                    sva.famReservations,
                    sva.dueFromDate,
                    sva.dueToDate
                FROM 
                	progress_reports pr
                LEFT OUTER JOIN    
                    secondVisitAnswers sva ON sva.fk_reportID = pr.pr_ID
                WHERE 
                	1 = 1
                    
                <cfif LEN(ARGUMENTS.prID)>
                    AND
                        pr_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.prID)#">
                </cfif>                       	

                <cfif LEN(ARGUMENTS.hostID)>
                    AND
                        fk_host = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">
                </cfif>                       	

                <cfif LEN(ARGUMENTS.reportType)>
                    AND
                        fk_reportType = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.reportType)#">
                </cfif>
                
                <cfif LEN(ARGUMENTS.seasonID)>
                	AND
                    	pr.fk_seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.seasonID)#">
                </cfif>  
                
                ORDER BY pr_id DESC

		</cfquery>
        
		<cfreturn qGetVisitInformation>
	</cffunction>

    
	<cffunction name="getSecondHostFamilyVisitReport" access="public" returntype="query" output="false" hint="Gets the second host family visit">
    	<cfargument name="studentID" hint="studentID is required">
        <cfargument name="hostID" default="" hint="hostID is not required">
        <cfargument name="hasNYApproved" default="0" hint="Set to 1 to get only the approved record">
		
        <cfquery 
			name="qGetSecondHostFamilyVisitReport" 
			datasource="#APPLICATION.dsn#">
                SELECT         	
                    sva.ID,
                    sva.fk_reportID,                    
                    sva.fk_studentID,
                    sva.neighborhoodAppearance,
                    sva.avoid,
                    sva.homeAppearance,
                    sva.typeOfHome,
                    sva.numberBedrooms,
                    sva.numberBathrooms,
                    sva.livingRoom,
                    sva.diningRoom,
                    sva.homeDetailsOther,
                    sva.ownBed,
                    sva.bathroom,
                    sva.outdoorsFromBedroom,
                    sva.storageSpace,
                    sva.privacy,
                    sva.studySpace,
                    sva.pets,
                    sva.other,
                    sva.dateOfVisit,
                    sva.dateCompliance,
                    pReport.fk_host,
                    pReport.pr_sr_approved_date,
                    pReport.pr_ra_approved_date,
                    pReport.pr_rd_approved_date,
                    pReport.pr_ny_approved_date,
                    pReport.pr_rejected_date      
                FROM
                    secondVisitAnswers sva
                INNER JOIN        
                    progress_reports pReport ON pReport.pr_id = sva.fk_reportID
                        AND
                            pReport.fk_reporttype = <cfqueryparam cfsqltype="cf_sql_integer" value="2">
                        <cfif VAL(ARGUMENTS.hasNYApproved)>
                            AND
                                pReport.pr_ny_approved_date IS NOT <cfqueryparam cfsqltype="cf_sql_date" null="yes">                    
                        </cfif>
                        
						<cfif LEN(ARGUMENTS.hostID)>
                            AND 
                                pReport.fk_host = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.hostID#">   
                        </cfif> 
                WHERE
                    sva.fk_studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">   
		</cfquery>
        
		<cfreturn qGetSecondHostFamilyVisitReport>
	</cffunction>


	<cffunction name="setSecondVisitReportAsNotNeeded" access="public" returntype="void" output="false" hint="Set second visit report as not needed (hidden)">
    	<cfargument name="historyID" hint="historyID is required">
        <cfargument name="fk_student" hint="fk_student is required">
        <cfargument name="fk_host" hint="fk_host is not required">
        <cfargument name="fk_secondVisitRep" hint="fk_host is not required">
        <cfargument name="fk_userID" default="5" hint="fk_userID is not required - Default to EXITS System (userID 5)">
        
        <cfquery 
			datasource="#APPLICATION.dsn#">
				INSERT INTO
                	smg_hide_reports
                (
                	historyID,
                    fk_student,
	                fk_host,
                	fk_secondVisitRep,
                    fk_userID,
                    dateChanged
                )
                VALUES
                (
                	<cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.historyID)#">,
                	<cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.fk_student)#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.fk_host)#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.fk_secondVisitRep)#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.fk_userID)#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                )
		</cfquery>
        
	</cffunction>
    
    
	<cffunction name="updateSecondVisitDateCompliance" access="public" returntype="void" output="false" hint="Updates compliance check date for a record">
		<cfargument name="ID" required="yes" hint="ID is required">
        <cfargument name="dateCompliance" default="" hint="date of compliance check">
            
        <cfquery 
			datasource="#APPLICATION.DSN#">
                UPDATE 
                    secondVisitAnswers
                SET 
                    dateCompliance = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.dateCompliance#" null="#NOT IsDate(ARGUMENTS.dateCompliance)#">
                WHERE 
                    ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.ID#">
        </cfquery>	
        
	</cffunction>

	<!--- ------------------------------------------------------------------------- ----
		
		End of Second Visit Report
	
	----- ------------------------------------------------------------------------- --->

</cfcomponent>