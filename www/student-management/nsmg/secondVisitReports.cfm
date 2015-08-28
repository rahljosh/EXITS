<!--- ------------------------------------------------------------------------- ----
	
	File:		secondVisitReports.cfm
	Author:		Marcus Melo
	Date:		February 15, 2012
	Desc:		Second Visit Report Matrix

	Updated:	10/26/2012 - Set arrival as the default window start date

----- ------------------------------------------------------------------------- --->

<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="extensions/customTags/gui/" prefix="gui" />	
	
    <!--- Param CLIENT Variables --->
    <cfparam name="CLIENT.pr_regionID" default="#CLIENT.regionID#">
    <cfparam name="CLIENT.reportType" default="2">
    <cfparam name="CLIENT.reportStatus" default="incomplete">

    <!--- Param FORM Variables --->
    <cfparam name="FORM.pr_action" default="">
    <cfparam name="FORM.pr_ID" default="">
    <cfparam name="FORM.reportType" default="2">
    <cfparam name="FORM.regionID" default="0">
    <cfparam name="FORM.reportStatus" default="0">
        
	<!--- Param Local Variables --->
    <Cfparam name="resetMonth" default="0">
    <cfparam name="startDate" default="">
    <cfparam name="endDate" default="">
    <cfparam name="repDueDate" default="">
    <Cfparam name="PreviousReportApproved" default="0">
    
    <cfscript>
		// Users allowed to add/hide reports
		vAllowedUsers = "8731,1,510,17427,12431,16718,12389,16652,8743,11364,13799,16552";
		
		// Get Regions
		qGetRegionList = APPLICATION.CFC.REGION.getUserRegions(companyID=CLIENT.companyID, userID=CLIENT.userID, usertype=CLIENT.usertype);
		
        // save the submitted values
        if ( FORM.pr_action EQ 'list' ) {
            // Set CLIENT Variable
            CLIENT.pr_regionID = FORM.regionID;
			CLIENT.reportStatus = FORM.reportStatus;
        } else if ( CLIENT.reportType EQ 1 ) {
            // Reset CLIENT Default Values 	
            CLIENT.pr_regionID = CLIENT.regionID;
			CLIENT.reportStatus = "incomplete";
        }
        
        // This page will always display second visit report
        CLIENT.reportType = 2;

		if ( isDefined('FORM.reportType') ) {
			if ( FORM.reportType neq CLIENT.ReportType ) {
				resetMonth = 1;
			}
			CLIENT.reportType = FORM.reportType;
		}
		
		if ( CLIENT.usertype EQ 15 ) {
			CLIENT.reportType = 2;
			enableReports = 'No';
		} else {
			enableReports = 'Yes';
		}		
	</cfscript>
    
    <cfquery name="qGetSeasonDateRange" datasource="#APPLICATION.DSN#">
        SELECT 
            startDate, 
            DATE_ADD(endDate, INTERVAL 31 DAY) AS endDate <!--- add 1 month to include July dates --->
        FROM 
            smg_seasons
        WHERE 
            startdate <= CURRENT_DATE
        AND 
            DATE_ADD(endDate, INTERVAL 31 DAY) >= CURRENT_DATE
    </cfquery>

    <!----All available Reports---->
    <cfquery name="qGetReporTypes" datasource="#APPLICATION.DSN#">
    	SELECT
        	reportTypeID,
            Description,
            isActive,
            showPhase,
            ESI
       	FROM
        	reporttrackingtype
      	WHERE
        	isActive = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
      	<cfif CLIENT.companyID EQ 14>
        	AND
            	ESI = <cfqueryparam cfsqltype="cf_sql_integer" value="14">
        </cfif>
    </cfquery>
    
    <!--- Actions --->
    <cfswitch expression="#FORM.pr_action#">
    	
        <!--- Hide Report --->
        <cfcase value="hideReport">
    
            <cfquery datasource="#APPLICATION.DSN#">
                INSERT INTO 
                    smg_hide_reports 
                    (
                        fk_student,
                        fk_host,
                        fk_secondVisitRep,
                        fk_userID,
                        dateChanged,
                        reason
                    )
                    VALUES 
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.fk_student)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.fk_host)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.fk_secondVisitRep)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.reason#">
                    )
            </cfquery>
        
        </cfcase>
        
        <!--- Unhide Report --->
        <cfcase value="unhideReport">

            <cfquery datasource="#APPLICATION.DSN#">
                DELETE FROM 
                    smg_hide_reports
                WHERE
                    id = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.pr_ID#">
            </cfquery>
        
        </cfcase>
        
        <!--- Delete 2nd Visit Report --->
        <cfcase value="deleteReport">
        
            <cfquery datasource="#APPLICATION.DSN#">
                DELETE FROM 
                	secondvisitanswers
                WHERE 
                	fk_reportID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.pr_ID)#">
            </cfquery>
            
            <cfquery datasource="#APPLICATION.DSN#">
                DELETE FROM 
                	progress_reports
                WHERE 
                	pr_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.pr_ID)#">
            </cfquery>
            
            <cflocation url="index.cfm?curdoc=secondVisitReports" addtoken="no">
        
        </cfcase>
        
    </cfswitch>

    <cfquery name="qGetResults" datasource="#APPLICATION.DSN#">
        SELECT 
            studentID,
            uniqueID,
            familyLastName,
            studentDisplayName,
            active,
            cancelDate,
            historyID,
            isActive,
            isRepCurrentAssigned,
            secondVisitRepID,
            isWelcomeFamily,
            isRelocation,
            datePlaced,
            datePlacedEnded,
            dateRelocated,
            dateArrived,
            complianceWindow,
            CASE 
            	WHEN isActive = 0 THEN DATEDIFF(datePlacedEnded, datePlaced)
              	WHEN isActive = 1 THEN DATEDIFF(datePlacedEnded, dateStartWindowCompliance)
                END AS totalAssignedPeriod,
            dateStartWindowCompliance,
            IFNULL(dueToDate, DATE_ADD(dateStartWindowCompliance, INTERVAL complianceWindow DAY) ) AS dateEndWindowCompliance,
            pr_ID,
            fk_sr_user,
            fk_ra_user,
            fk_rd_user,
            fk_ny_user,
            fk_secondVisitRep,            
            pr_sr_approved_date,
            pr_ra_approved_date,
            pr_rd_approved_date,
            pr_ny_approved_date,
            pr_rejected_date,
            dateOfVisit,
            dueFromDate,
            dueToDate,
            programName,
            hostID,
            hostFamilyDisplayName,
            secondVisitRepDisplayName,
            secondVisitRepLastName,
            advisorID,
            advisorDisplayName,
            advisorLastName,
            hideReportID,
            dateReportHidden,
            reasonReportHidden,
            hiddenByName,
            DATEDIFF( DATE_ADD(dateStartWindowCompliance, INTERVAL complianceWindow DAY), CURRENT_DATE ) AS remainingDays,
            advisorID,
            userID
        FROM (	
    		SELECT
                s.studentID,
                s.uniqueID,
                s.familyLastName,
                s.active,
                s.cancelDate,
                CAST(CONCAT(s.firstName, ' ', s.familyLastName,  ' ##', s.studentID) AS CHAR) AS studentDisplayName,
                ht.historyID,
                ht.isActive,
                1 AS isRepCurrentAssigned,
                ht.secondVisitRepID,
                ht.isWelcomeFamily, 
                ht.isRelocation, 
                ht.datePlaced,
                IFNULL(ht.datePlacedEnded, p.endDate) AS datePlacedEnded,
                ht.dateRelocated, 
              	CASE 
         			WHEN ht.isWelcomeFamily = 1 THEN 30
                  	WHEN ht.isWelcomeFamily = 0 THEN 60
                 	END AS complianceWindow,
                (
                    SELECT dep_date 
                    FROM smg_flight_info 
                    WHERE studentID = s.studentID 
                    AND flight_type = "arrival" 
                    AND assignedID = 0
                    AND isDeleted = 0
                    AND programID = s.programID
                    ORDER BY 
                        dep_date DESC,
                        dep_time ASC
                    LIMIT 1                            
                ) AS dateArrived, 
              	CASE 
                    WHEN dueFromDate IS NOT NULL THEN dueFromDate					
                    WHEN ht.dateRelocated IS NOT NULL THEN ht.dateRelocated
                    ELSE (
                        SELECT dep_date 
                        FROM smg_flight_info 
                        WHERE studentID = s.studentID 
                        AND flight_type = "arrival" 
                        AND assignedID = 0
                        AND isDeleted = 0
                        AND programID = s.programID
                        ORDER BY 
                            dep_date DESC,
                            dep_time ASC
                        LIMIT 1 )                                  
                	END AS dateStartWindowCompliance,                  
                pr.pr_ID,
                pr.fk_sr_user,
                pr.fk_ra_user,
                pr.fk_rd_user,
                pr.fk_ny_user,
                pr.fk_secondVisitRep,                   
                pr.pr_sr_approved_date,
                pr.pr_ra_approved_date,
                pr.pr_rd_approved_date,
                pr.pr_ny_approved_date,
                pr.pr_rejected_date,
                sva.dateOfVisit,
                sva.dueFromDate,
                sva.dueToDate,
                p.programName,
                h.hostID,
                CAST(CONCAT(h.familyLastName, ' ##', h.hostID) AS CHAR) AS hostFamilyDisplayName,
                CAST(CONCAT(u.firstName, ' ', u.lastName,  ' ##', u.userID) AS CHAR) AS secondVisitRepDisplayName,
                u.lastName AS secondVisitRepLastName,
                advisor.userID AS advisorID,
                CAST(CONCAT(advisor.firstName, ' ', advisor.lastName,  ' ##', advisor.userID) AS CHAR) AS advisorDisplayName,
                advisor.lastName AS advisorLastName,
                shr.ID AS hideReportID,
                shr.dateChanged AS dateReportHidden,
                shr.reason AS reasonReportHidden,
                CAST(CONCAT(hiddenBy.firstName, ' ', hiddenBy.lastName,  ' ##', hiddenBy.userID) AS CHAR) AS hiddenByName,
            	u.userID
        	FROM smg_students s
       		INNER JOIN smg_hosthistory ht ON ht.studentID = s.studentID
              	AND ht.assignedID = 0 
         	INNER JOIN user_access_rights uar ON uar.userID = ht.secondVisitRepID
				<cfif APPLICATION.CFC.USER.isOfficeUser()>
                    AND uar.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.pr_regionID#">
                <cfelse>
                    AND uar.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.regionID#">
                </cfif>
             	AND uar.userType IN ( 5,6,7,15 )
            INNER JOIN smg_programs p on p.programID = s.programID
                AND p.active = 1
            INNER JOIN smg_hosts h ON h.hostID = ht.hostID 
            INNER JOIN smg_users u ON u.userID = ht.secondVisitRepID
            LEFT OUTER JOIN progress_reports pr ON pr.fk_student = s.studentID            
                AND pr.fk_reportType = 2
                AND pr.fk_host = ht.hostID
            LEFT OUTER JOIN secondvisitanswers sva ON sva.fk_reportID = pr.pr_ID
            LEFT OUTER JOIN smg_users advisor ON advisor.userID = uar.advisorID  
            LEFT OUTER JOIN smg_hide_reports shr ON shr.fk_secondVisitRep = u.userID
                AND shr.fk_student = ht.studentID
                AND shr.fk_host = ht.hostID
            LEFT OUTER JOIN smg_users hiddenBy ON hiddenBy.userID = shr.fk_userID
                
      		UNION
                
        	SELECT
                s.studentID,
                s.uniqueID,
                s.familyLastName,
                s.active,
                s.cancelDate,
                CAST(CONCAT(s.firstName, ' ', s.familyLastName,  ' ##', s.studentID) AS CHAR) AS studentDisplayName,
                ht.historyID,
                ht.isActive,
                1 AS isRepCurrentAssigned,
                ht.secondVisitRepID,
                ht.isWelcomeFamily, 
                ht.isRelocation, 
                ht.datePlaced,
                IFNULL(ht.datePlacedEnded, p.endDate) AS datePlacedEnded,
                ht.dateRelocated, 
                30 AS complianceWindow,
                (
                    SELECT dep_date 
                    FROM smg_flight_info 
                    WHERE studentID = s.studentID 
                    AND flight_type = "arrival"
                    AND assignedID = 0
                    AND isDeleted = 0
                    AND programID = s.programID
                    ORDER BY 
                        dep_date DESC,
                        dep_time ASC
                    LIMIT 1                            
                ) AS dateArrived,
                (
                    SELECT sva2.dateOfVisit
                    FROM progress_reports pr2
                    INNER JOIN secondvisitanswers sva2 ON sva2.fk_reportID = pr2.pr_ID
                    WHERE pr2.fk_student = s.studentID             
                    AND pr2.fk_reportType = 2	
                    AND pr2.fk_host = ht.hostID
                    AND pr_ny_approved_date IS NOT NULL
                    ORDER BY sva2.dateOfVisit DESC
                    LIMIT 1                            
                ) AS dateStartWindowCompliance,
                pr.pr_ID,
                pr.fk_sr_user,
                pr.fk_ra_user,
                pr.fk_rd_user,
                pr.fk_ny_user,
                pr.fk_secondVisitRep,                   
                pr.pr_sr_approved_date,
                pr.pr_ra_approved_date,
                pr.pr_rd_approved_date,
                pr.pr_ny_approved_date,
                pr.pr_rejected_date,
                sva.dateOfVisit,
                sva.dueFromDate,
                sva.dueToDate,
                p.programName,
                h.hostID,
                CAST(CONCAT(h.familyLastName, ' ##', h.hostID) AS CHAR) AS hostFamilyDisplayName,
                CAST(CONCAT(u.firstName, ' ', u.lastName,  ' ##', u.userID) AS CHAR) AS secondVisitRepDisplayName,
                u.lastName AS secondVisitRepLastName,
                advisor.userID AS advisorID,
                CAST(CONCAT(advisor.firstName, ' ', advisor.lastName,  ' ##', advisor.userID) AS CHAR) AS advisorDisplayName,
                advisor.lastName AS advisorLastName,
                shr.ID AS hideReportID,
                shr.dateChanged AS dateReportHidden,
                shr.reason AS reasonReportHidden,
                CAST(CONCAT(hiddenBy.firstName, ' ', hiddenBy.lastName,  ' ##', hiddenBy.userID) AS CHAR) AS hiddenByName,
            	u.userID
          	FROM smg_students s
            INNER JOIN smg_hosthistory ht ON ht.studentID = s.studentID
                AND ht.assignedID = 0 
                AND ht.isWelcomeFamily = 1
                AND ht.datePlaced IS NOT NULL
            INNER JOIN user_access_rights uar ON uar.userID = ht.secondVisitRepID
				<cfif APPLICATION.CFC.USER.isOfficeUser()>
                    AND uar.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.pr_regionID#">
                <cfelse>
                    AND uar.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.regionID#">
                </cfif>
            	AND uar.userType IN ( 5,6,7,15 )
            INNER JOIN smg_programs p on p.programID = s.programID
                AND p.active = 1
            INNER JOIN smg_hosts h ON h.hostID = ht.hostID 
            INNER JOIN smg_users u ON u.userID = ht.secondVisitRepID
            LEFT OUTER JOIN progress_reports pr ON pr.fk_student = s.studentID            
                AND pr.fk_reportType = 2
                AND pr.fk_host = ht.hostID
            LEFT OUTER JOIN secondvisitanswers sva ON sva.fk_reportID = pr.pr_ID
            LEFT OUTER JOIN smg_users advisor ON advisor.userID = uar.advisorID  
            LEFT OUTER JOIN smg_hide_reports shr ON shr.fk_secondVisitRep = u.userID
                AND shr.fk_student = ht.studentID
                AND shr.fk_host = ht.hostID
            LEFT OUTER JOIN smg_users hiddenBy ON hiddenBy.userID = shr.fk_userID  
            WHERE s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
          	AND (
                SELECT COUNT(pr_ID)
                FROM progress_reports
                WHERE fk_student = s.studentID             
                AND fk_reportType = 2
                AND fk_host = ht.hostID
                AND pr_ny_approved_date IS NOT NULL ) >= 1  
                
        	UNION

            SELECT
                s.studentID,
                s.uniqueID,
                s.familyLastName,
                s.active,
                s.cancelDate,
                CAST(CONCAT(s.firstName, ' ', s.familyLastName,  ' ##', s.studentID) AS CHAR) AS studentDisplayName,
                ht.historyID,
                ht.isActive,
                0 AS isRepCurrentAssigned,
                CAST(sht.fieldID AS UNSIGNED) AS secondVisitRepID,
                ht.isWelcomeFamily, 
                ht.isRelocation, 
                ht.datePlaced,
                IFNULL(ht.datePlacedEnded, p.endDate) AS datePlacedEnded,
                ht.dateRelocated, 
               	CASE 
                    WHEN ht.isWelcomeFamily = 1 THEN 30
                    WHEN ht.isWelcomeFamily = 0 THEN 60
                 	END AS complianceWindow,
                (
                    SELECT dep_date 
                    FROM smg_flight_info 
                    WHERE studentID = s.studentID 
                    AND flight_type = "arrival"
                    AND assignedID = 0
                    AND isDeleted = 0
                    AND programID = s.programID
                    ORDER BY 
                        dep_date DESC,
                        dep_time ASC
                    LIMIT 1                            
                ) AS dateArrived, 
                CASE 
                    WHEN dueFromDate IS NOT NULL THEN dueFromDate
                    WHEN ht.dateRelocated IS NOT NULL THEN ht.dateRelocated
                    ELSE (
                        SELECT dep_date 
                        FROM smg_flight_info 
                        WHERE studentID = s.studentID 
                        AND flight_type = "arrival"
                        AND assignedID = 0
                        AND isDeleted = 0
                        AND programID = s.programID
                        ORDER BY 
                            dep_date DESC,
                            dep_time ASC
                        LIMIT 1 )                                  
                    END AS dateStartWindowCompliance,                  
                pr.pr_ID,
                pr.fk_sr_user,
                pr.fk_ra_user,
                pr.fk_rd_user,
                pr.fk_ny_user,
                pr.fk_secondVisitRep,                   
                pr.pr_sr_approved_date,
                pr.pr_ra_approved_date,
                pr.pr_rd_approved_date,
                pr.pr_ny_approved_date,
                pr.pr_rejected_date,
                sva.dateOfVisit,
                sva.dueFromDate,
                sva.dueToDate,
                p.programName,
                h.hostID,
                CAST(CONCAT(h.familyLastName, ' ##', h.hostID) AS CHAR) AS hostFamilyDisplayName,
                CAST(CONCAT(u.firstName, ' ', u.lastName,  ' ##', u.userID) AS CHAR) AS secondVisitRepDisplayName,
                u.lastName AS secondVisitRepLastName,
                advisor.userID AS advisorID,
                CAST(CONCAT(advisor.firstName, ' ', advisor.lastName,  ' ##', advisor.userID) AS CHAR) AS advisorDisplayName,
                advisor.lastName AS advisorLastName,
                shr.ID AS hideReportID,
                shr.dateChanged AS dateReportHidden,
                shr.reason AS reasonReportHidden,
                CAST(CONCAT(hiddenBy.firstName, ' ', hiddenBy.lastName,  ' ##', hiddenBy.userID) AS CHAR) AS hiddenByName,
            	u.userID
         	FROM smg_students s
            INNER JOIN smg_hosthistory ht ON ht.studentID = s.studentID
                AND ht.assignedID = 0
                AND ht.datePlaced IS NOT NULL
            INNER JOIN smg_hosthistorytracking sht ON sht.historyID = ht.historyID
                AND fieldName = "secondVisitRepID"
                AND sht.fieldID != ht.secondVisitRepID                        
            INNER JOIN user_access_rights uar ON uar.userID = sht.fieldID
				<cfif APPLICATION.CFC.USER.isOfficeUser()>
                    AND uar.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.pr_regionID#">
                <cfelse>
                    AND uar.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.regionID#">
                </cfif>
                AND uar.userType IN ( 5,6,7,15 )
            INNER JOIN smg_programs p on p.programID = s.programID
                AND p.active = 1
            INNER JOIN smg_hosts h ON h.hostID = ht.hostID 
            INNER JOIN smg_users u ON u.userID = sht.fieldID
            LEFT OUTER JOIN progress_reports pr ON pr.fk_student = s.studentID            
                AND pr.fk_reportType = 2	
                AND pr.fk_host = ht.hostID
            LEFT OUTER JOIN secondvisitanswers sva ON sva.fk_reportID = pr.pr_ID
            LEFT OUTER JOIN smg_users advisor ON advisor.userID = uar.advisorID  
            LEFT OUTER JOIN smg_hide_reports shr ON shr.fk_secondVisitRep = sht.fieldID
                AND shr.fk_student = ht.studentID
                AND shr.fk_host = ht.hostID
            LEFT OUTER JOIN smg_users hiddenBy ON hiddenBy.userID = shr.fk_userID  
            WHERE s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
			                               
    	) AS t
        WHERE ( active = 1 OR cancelDate >= dateArrived )
        <cfswitch expression="#CLIENT.userType#">
            <cfcase value="6">
                AND ( advisorID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userid)#"> OR userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userid)#"> )
            </cfcase>
            <cfcase value="7,15">
                AND userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userid)#">
            </cfcase>
        </cfswitch>        
		<cfswitch expression="#CLIENT.reportStatus#">
            <cfcase value="incomplete">
                AND pr_ny_approved_date IS NULL
                AND hideReportID IS NULL
            </cfcase>            
            <cfcase value="completed">
                AND pr_ny_approved_date IS NOT NULL
            </cfcase>            
            <cfcase value="notRequired">
                AND hideReportID > 0
            </cfcase>
            <cfcase value="rejected">
                AND pr_rejected_date IS NOT NULL
            </cfcase>            
            <cfcase value="missingApproval">            
                AND pr_ny_approved_date IS NULL
            	<cfswitch expression="#CLIENT.userType#">
                    <cfcase value="1,2,3,4">
                        AND
                            (
                                pr_rd_approved_date IS NOT NULL
                                OR pr_ra_approved_date IS NOT NULL
                                OR pr_sr_approved_date IS NOT NULL
                            )
                    </cfcase>
                    <cfcase value="5">
                        AND pr_rd_approved_date IS NULL
                        AND
                            (
                                pr_ra_approved_date IS NOT NULL
                                OR pr_sr_approved_date IS NOT NULL
                            )
                    </cfcase>
                    <cfcase value="6">
                        AND pr_ra_approved_date IS NULL
                        AND pr_sr_approved_date IS NOT NULL
                    </cfcase>
                    <cfdefaultcase>
                        AND pr_sr_approved_date IS NULL
                        AND pr_ID > 0
                    </cfdefaultcase>
                </cfswitch>
            </cfcase>
        </cfswitch>
        HAVING ( dateArrived IS NULL OR datePlacedEnded >= dateArrived )                      
		AND ( totalAssignedPeriod IS NULL OR totalAssignedPeriod >= complianceWindow OR datePlacedEnded IS NULL )
        
        ORDER BY 
            advisorLastName,
            advisorID, 
            secondVisitRepLastName,  
            secondVisitRepID,
            isActive DESC,
            dateStartWindowCompliance DESC,
            familyLastName 
    </cfquery> 

    
    <!--- Function to Print Current and Previous Student Information --->
    <cffunction name="displayReportBody" output="yes" returntype="string">
    	<cfargument name="setQuery" type="query" required="yes" hint="Query is required">
    	<cfargument name="isCurrentList" type="boolean" default="false" hint="isCurrentList is not required">

		<cfscript>
            var vLastStudentIDShowed = 0;
			var vCurrentRow = 0;
        </cfscript>

        <cfsavecontent variable="vReportBody">
        	
            <cfif NOT ARGUMENTS.setQuery.recordCount>
            	<tr bgcolor="##EEEEEE">
            		<td>&nbsp;</td>
                    <td colspan="11">No Students Found</td>
            	</tr>
            </cfif>
            
            <cfloop query="ARGUMENTS.setQuery">                	                               
                
                <cfscript>
					// Host Status - Current/Previous
                    if ( VAL(ARGUMENTS.setQuery.isActive) ) {
                        vSetHostStatus = "Current";
                    } else {
                        vSetHostStatus = "Previous";
                    }
                    // Host Status - Welcome/Permanent
                    if ( VAL(ARGUMENTS.setQuery.isWelcomeFamily) ) {
                        vSetHostStatus = vSetHostStatus & " - Welcome";
                    } else {
                        vSetHostStatus = vSetHostStatus & " - Permanent";
                    }
                    // Host Status - Relocation
                    if ( VAL(ARGUMENTS.setQuery.isRelocation) ) {
                        vSetHostStatus = vSetHostStatus & " - Relocation";
                    }
					
					// Color code to alert users of remaining days
					vSetRemainingDayCSS = '';
					
					// Set up Remaining Days Alert if report has not been set as hidden or has not been approved
					if ( NOT VAL(ARGUMENTS.setQuery.hideReportID) AND NOT IsDate(ARGUMENTS.setQuery.pr_ny_approved_date) ) {
					
						if ( IsNumeric(ARGUMENTS.setQuery.remainingDays) AND ARGUMENTS.setQuery.remainingDays LTE 0 ) {
							vSetRemainingDayCSS = ' class="overDue"';
						} else if ( IsNumeric(ARGUMENTS.setQuery.remainingDays) AND ARGUMENTS.setQuery.remainingDays LTE 14 ) {
							vSetRemainingDayCSS = ' class="dueSoon"';
						}
						
					}	
					
					// Only increament row if student is different from previous
					if ( ARGUMENTS.setQuery.studentID NEQ vLastStudentIDShowed ) {
						vCurrentRow ++;
					}
                </cfscript>
                
                <tr bgcolor="#iif(vCurrentRow MOD 2 ,DE("EEEEEE") ,DE("FFFFFF") )#">
                    <td style="height:20px;">&nbsp;</td>
                    <td>
                        <!--- Only Output Student's name once if we are showing more records for the same student --->
                        <cfif ARGUMENTS.setQuery.studentID NEQ vLastStudentIDShowed>
                        
                            <cfif ARGUMENTS.isCurrentList>
                            	<!--- Display Link for Current List --->
                            	<a href="javascript:OpenLetter('reports/placementInfoSheet.cfm?uniqueID=#ARGUMENTS.setQuery.uniqueID#');">#ARGUMENTS.setQuery.studentDisplayName#</a>
                            <cfelse>
                            	<!--- No Link to PIS for previously student list --->
                            	#ARGUMENTS.setQuery.studentDisplayName#
                            </cfif>
                            <br />    
                            <cfif VAL(ARGUMENTS.setQuery.active)>
                                <span class="note">(#ARGUMENTS.setQuery.programName# - Active)</span>
                            <cfelseif isDate(ARGUMENTS.setQuery.cancelDate)>
                                <span class="noteAlert">(#ARGUMENTS.setQuery.programName# - Cancelled)</span>
                            </cfif>
                        
                        </cfif>
                    </td>
                    <td>
                        #ARGUMENTS.setQuery.hostFamilyDisplayName# <br />
                        <span class="note">(#vSetHostStatus#)</span>
                    </td>
                    <td align="center" #vSetRemainingDayCSS#>
                        <cfif NOT isDate(ARGUMENTS.setQuery.dateArrived)>
                            Missing Flight Information
						<cfelseif ARGUMENTS.setQuery.dateArrived GT now()>
							Not In Country - Arrives on #DateFormat(ARGUMENTS.setQuery.dateArrived, 'mm/dd/yy')#
						<cfelseif isDate(ARGUMENTS.setQuery.dateStartWindowCompliance)>
                            From #DateFormat(ARGUMENTS.setQuery.dateStartWindowCompliance, 'mm/dd/yy')# To #DateFormat(ARGUMENTS.setQuery.dateEndWindowCompliance, 'mm/dd/yy')#
						</cfif>                       
                    </td>
                    <cfif isDate(ARGUMENTS.setQuery.pr_ny_approved_date)>
                        <td align="center">completed</td>
                    <cfelse>
                        <td align="center" #vSetRemainingDayCSS#>
                        	<cfif ARGUMENTS.setQuery.remainingDays GT 60>                        
                            	n/a
                            <cfelseif ARGUMENTS.setQuery.remainingDays GT 0>
                                #ARGUMENTS.setQuery.remainingDays#
                        	<cfelseif isDate(ARGUMENTS.setQuery.dateStartWindowCompliance)>
                            	0
                            </cfif>
                        </td>
                    </cfif>
                    <td valign="center">
                    
                        <!--- Check if have a report --->
                        <cfif VAL(ARGUMENTS.setQuery.pr_ID)>

							<cfscript>
								// Create a list to store users that are allowed to view the report
                                vAllowedUserIDList = '';
                                vAllowedUserIDList = ListAppend(vAllowedUserIDList, ARGUMENTS.setQuery.fk_secondVisitRep);
                                vAllowedUserIDList = ListAppend(vAllowedUserIDList, ARGUMENTS.setQuery.fk_sr_user);
                                vAllowedUserIDList = ListAppend(vAllowedUserIDList, ARGUMENTS.setQuery.fk_ra_user);
                                vAllowedUserIDList = ListAppend(vAllowedUserIDList, ARGUMENTS.setQuery.fk_rd_user);
                                vAllowedUserIDList = ListAppend(vAllowedUserIDList, ARGUMENTS.setQuery.fk_secondVisitRep);
                            </cfscript>
                
                            <!--- access is limited to: Office, second vist rep, supervising rep, regional advisor, regional director, and facilitator. --->
                            <cfif APPLICATION.CFC.USER.isOfficeUser() OR listFind(vAllowedUserIDList,CLIENT.userID)>
        
                                <!--- Display Pending / View Options --->
                                <a href="index.cfm?curdoc=forms/secondHomeVisitReport&reportID=#ARGUMENTS.setQuery.pr_ID#" title="Click to view report">
									<cfif NOT isDate(ARGUMENTS.setQuery.pr_sr_approved_date)>
                                        <img src="pics/buttons/pending.png" border="0" />
                                    <cfelse>
                                        <img src="pics/buttons/greyedView.png" border="0" />
                                    </cfif>
                                </a>
                    
                            <cfelse>
                                n/a 
                            </cfif>
                    
                        <!--- No Report, display add button --->
                        <cfelse>
                            
                            <cfif VAL(ARGUMENTS.setQuery.hideReportID) AND listFind(vAllowedUsers, CLIENT.userID)>
                            
                                <!--- Unhide Report --->
                                <form action="index.cfm?curdoc=secondVisitReports" method="post">
                                	<input type="hidden" name="pr_action" value="unhideReport">
                                    <input type="hidden" name="pr_ID" value="#ARGUMENTS.setQuery.hideReportID#" />
                                    <input name="Submit" type="image" src="pics/plus.png" height="20" alt="Add New Report" border="0">
                                </form>
                                
                            <cfelseif 
								NOT VAL(ARGUMENTS.setQuery.hideReportID) 
								AND isDate(ARGUMENTS.setQuery.dateStartWindowCompliance)
								AND ARGUMENTS.setQuery.dateStartWindowCompliance LT now()>
                            
                                <!--- Add Report --->
                                <form action="index.cfm?curdoc=forms/pr_add" method="post" style="display:inline;margin-right:10px;">
                                    <input type="hidden" name="studentID" value="#ARGUMENTS.setQuery.studentID#">
                                    <input type="hidden" name="type_of_report" value="2">
                                    <input type="hidden" name="fk_host" value="#ARGUMENTS.setQuery.hostID#">
                                    <input type="hidden" name="month_of_report" value="#Month(now())#">
                                    <input type="hidden" name="dueFromDate" value="#DateFormat(ARGUMENTS.setQuery.dateStartWindowCompliance, 'mm/dd/yy')#">
                                    <input type="hidden" name="dueToDate" value="#DateFormat(ARGUMENTS.setQuery.dateEndWindowCompliance, 'mm/dd/yy')#">
                                    <input name="Submit" type="image" src="pics/buttons/greenNew.png" alt="Add New Report" height="20"  border="0">
                                </form>
                                
                                <!--- Display Hide Report --->
                                <cfif listFind(vAllowedUsers, CLIENT.userID)>
                                
                                    <form id="submitHide_#studentID#_#hostID#" action="index.cfm?curdoc=secondVisitReports" method="post" style="display:inline;">
                                    	<input type="hidden" name="pr_action" value="hideReport">
                                        <input type="hidden" name="fk_student" value="#ARGUMENTS.setQuery.studentID#">
                                        <input type="hidden" name="fk_host" value="#ARGUMENTS.setQuery.hostID#">
                                        <input type="hidden" name="fk_secondVisitRep" value="#ARGUMENTS.setQuery.secondVisitRepID#">
                                        <input type="hidden" name="reason" id="reason_#ARGUMENTS.setQuery.studentID#_#ARGUMENTS.setQuery.hostID#" value="" />
                                        <a href="" onclick="addInputReason('#ARGUMENTS.setQuery.studentDisplayName#',#ARGUMENTS.setQuery.studentID#,'#ARGUMENTS.setQuery.hostFamilyDisplayName#',#ARGUMENTS.setQuery.hostID#);return false;"><img src="pics/smallDelete.png" height="20" alt="Set report as not needed" border="0" /></a>
                                    </form>
                                    
                                </cfif>
                            
                            </cfif>
                            
                        </cfif>
                    </td>

                    <cfif VAL(ARGUMENTS.setQuery.hideReportID)>
                        <td colspan="6">
                            <em>
                                #ARGUMENTS.setQuery.hiddenByName# determined that this report was not required on #dateFormat(ARGUMENTS.setQuery.dateReportHidden, 'mm/dd/yy')#
                                <cfif LEN(ARGUMENTS.setQuery.reasonReportHidden)>
                                    - Reason: #ARGUMENTS.setQuery.reasonReportHidden#
                                </cfif>
                            </em>
                        </td>
                    <cfelse>
                    	<td align="center">#dateFormat(ARGUMENTS.setQuery.dateOfVisit, 'mm/dd/yy')#</td>
                        <td align="center">#dateFormat(ARGUMENTS.setQuery.pr_sr_approved_date, 'mm/dd/yy')#</td>
                        <td align="center">
                            <cfif NOT VAL(ARGUMENTS.setQuery.advisorID)>
                                n/a
                            <cfelse>
                                #dateFormat(ARGUMENTS.setQuery.pr_ra_approved_date, 'mm/dd/yy')#
                            </cfif>
                        </td>
                        <td align="center">#dateFormat(ARGUMENTS.setQuery.pr_rd_approved_date, 'mm/dd/yy')#</td>
                        <td align="center">#dateFormat(ARGUMENTS.setQuery.pr_ny_approved_date, 'mm/dd/yy')#</td>
                        <td align="center">#dateFormat(ARGUMENTS.setQuery.pr_rejected_date, 'mm/dd/yy')#</td>
                    </cfif>
                </tr>
        
                <cfscript>
					// Update Student ID Showed
                    vLastStudentIDShowed = ARGUMENTS.setQuery.studentID;
				</cfscript>
           
            </cfloop>  
              
        </cfsavecontent>

    	<cfscript>
			return vReportBody;
		</cfscript>
        
    </cffunction>
    
</cfsilent>    

<script type="text/javascript">
	// If second visit report is selected, load the 2nd visit page
	var checkSelectedReport = function() { 
	
		if ( $("#reportType").val() == 1 ) {	
			// Disable submit button
			$("#submit").attr("disabled", "disabled");
			// Go to second visit page
			window.location.replace('index.cfm?curdoc=progress_reports');			
		}		
	
	}
	
	// opens letters in a defined format
	function OpenLetter(url) {
		newwindow=window.open(url, 'Application', 'height=700, width=850, location=no, scrollbars=yes, menubar=yes, toolbars=no, resizable=yes'); 
		if (window.focus) {newwindow.focus()}
	}
	
	// Opens the modal dialog to ask for a reason for hidding the report.
	var addInputReason = function(studentDisplayName,studentID,hostFamilyDisplayName,hostID) {
		$("#dialog:ui-dialog").dialog( "destroy" );
		$("#dialog_reason").val("");
		$("#reasonModal").empty();
		$("#reasonModal").append(
			'Student: ' + studentDisplayName + '<br />' +
			'Host Family: ' + hostFamilyDisplayName + '<br />' +
			'<textarea name="dialog_reason" id="dialog_reason" maxlength="255" rows="5" cols="35" val="" />');
		$( "#reasonModal").dialog({
			resizable: false,
			height:230,
			width:400,
			modal: true,
			buttons: {
				"Submit": function() {
					$("#reason_"+studentID+"_"+hostID).val($("#dialog_reason").val());
					$( this ).dialog( "close" );
					$("#submitHide_"+studentID+"_"+hostID).submit();
				},
				"Cancel": function() {
					$( this ).dialog( "close" );
				}
			}
		});
	}	
</script>

<cfif NOT listFind("1,2,3,4,5,6,7,15", CLIENT.userType)>
    You do not have access to this page.
    <cfabort>
</cfif>

<style type="text/css">
	.advisor {
		font-weight: bold;
		background-color: #FFDDBB;
		padding:5px;
		line-height: 20px;
	}
	.rep {
		font-weight: bold;
		background-color: #085dad;
		color:#FFF;
		padding:5px;
		line-height: 20px;
	}
	.dueSoon {
		background-color:#fafa8d; 
		color:#000; 
		font-weight:bold;
	}
	.overDue {
		background-color:#fc8d8d; 
		color:#000; 
		font-weight:bold;
	}
</style>

<cfoutput>

	<!--- Modal Dialog --->
    <div id="reasonModal" title="Please enter a reason for hidding this report" class="displayNone"> 
        <p><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span></p>
    </div>

	<!--- Table Header --->
    <gui:tableHeader
        imageName="current_items.gif"
        tableTitle="Second Visit Reports"
        width="100%"
    />    

    <form action="index.cfm?curdoc=secondVisitReports" method="post">
        <input name="pr_action" type="hidden" value="list">
        <table border="0" cellpadding="4" cellspacing=0 class="section" width="100%">
      		<tr>
                <td valign="top">
                	<label for="reportType">Report Type</label> <br />
                	<cfif CLIENT.usertype NEQ 15>
						<select name="reportType" id="reportType" class="largeField" onchange="checkSelectedReport();">
                        	<cfloop query="qGetReporTypes">
                            	<option value="#qGetReporTypes.reportTypeID#" <cfif qGetReporTypes.reportTypeID EQ CLIENT.reportType> selected="selected" </cfif> >#qGetReporTypes.description#</option>
                            </cfloop>                        
                        </select>
                	<cfelse>
                		Second Host Family Visit    
                	</cfif>
                </td>
            	<cfif APPLICATION.CFC.USER.isOfficeUser()>
               		<td valign="top">
                    	<label for="regionID">Region</label> <br />
						<select name="regionID" id="regionID" class="largeField">
                        	<cfloop query="qGetRegionList">
                            	<option value="#qGetRegionList.regionID#" <cfif qGetRegionList.regionID EQ CLIENT.pr_regionID> selected="selected" </cfif> >#qGetRegionList.regionname#</option>
                            </cfloop>                        
                        </select>
                	</td>
            	</cfif>
                <td valign="top">
                	<label for="reportStatus">Report Status</label> <br />
                    <select name="reportStatus" id="reportStatus" class="largeField">
                    	<option value="all" <cfif CLIENT.reportStatus EQ 'all'> selected="selected" </cfif> >All</option>
                    	<option value="incomplete" <cfif CLIENT.reportStatus EQ 'incomplete'> selected="selected" </cfif> >Incomplete Report *</option>
                        <option value="missingApproval" <cfif CLIENT.reportStatus EQ 'missingApproval'> selected="selected" </cfif> >Missing My Approval</option>
                        <option value="notRequired" <cfif CLIENT.reportStatus EQ 'notRequired'> selected="selected" </cfif> >Set as Not Required</option>
                        <option value="completed" <cfif CLIENT.reportStatus EQ 'completed'> selected="selected" </cfif> >Completed</option>
                        <option value="rejected" <cfif CLIENT.reportStatus EQ 'rejected'> selected="selected" </cfif> >Rejected</option>
                        <cfif APPLICATION.CFC.USER.isOfficeUser()>
                        	<option value="hidden" <cfif CLIENT.reportStatus EQ 'hidden'> selected="selected" </cfif> >Show Hidden Reports</option>
                        </cfif>
                    </select>
                    <br />
					<span class="note">* Reports are not completed until approved by headquarters</span>
                </td>
          		<td valign="top">
                	<input name="submit" id="submit" type="submit" value="Submit" />
              	</td>
            </tr>
 		</table>
 	</form>

</cfoutput>

<!--- Display Results --->
<cfif VAL(qGetResults.recordCount)>

    <table width="100%" class="section" cellpadding="4" cellspacing="1" border="0">
  		
        <!--- Advisor Group --->
		<cfoutput query="qGetResults" group="advisorID">
        
            <cfif qGetResults.currentRow NEQ 1>
         		<tr>
               		<td colspan="13" height="25">&nbsp;</td>
                </tr>
            </cfif>
            
            <tr>
     			<td colspan="13" class="advisor">
               		<cfif NOT LEN(qGetResults.advisorID)>
                        Reports Directly to Regional Director
                    <cfelse>
                        Reports to: #qGetResults.advisorDisplayName#
                  	</cfif>
                </td>
            </tr>
            
            <!--- Second Visit Group --->
        	<cfoutput group="secondVisitRepID">

				<!--- Get Current Assigned Students --->
                <cfquery name="qGetCurrentStudents" dbtype="query">
                    SELECT 
                        *
                    FROM
                        qGetResults
                    WHERE
                        secondVisitRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetResults.secondVisitRepID#"> 
                    AND
                    	isRepCurrentAssigned = <cfqueryparam cfsqltype="cf_sql_numeric" value="1">	          
                    <cfif FORM.reportStatus EQ 'hidden'>
                        AND
                            isActive = <cfqueryparam cfsqltype="cf_sql_bit" value="0">  
					<cfelse>
                    	<!--- Get Previous Placement Approved and Current Pending/Approved --->
                    	AND
                        (
                            isActive = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                        OR
                        	pr_ID IS NOT NULL
                        )
					</cfif>
                    ORDER BY
                    	familyLastName
                </cfquery>
                

                <!--- Get Previous Assigned Students --->
                <cfquery name="qGetPreviousStudents" dbtype="query">
                    SELECT 
                        *
                    FROM
                        qGetResults
                    WHERE
                        secondVisitRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetResults.secondVisitRepID#"> 
                    AND
                    	isRepCurrentAssigned = <cfqueryparam cfsqltype="cf_sql_numeric" value="0">	
                    ORDER BY
                    	familyLastName
                </cfquery>
                
				<tr>
                	<td colspan="13" class="rep">
                    	#qGetResults.secondVisitRepDisplayName#
                    	<span style="float:right;padding-right:5px;">#VAL(qGetCurrentStudents.recordCount) + VAL(qGetPreviousStudents.recordCount)# record(s)</span>
                    </td>
              	<tr>
               	<tr>
                    <th width="10">&nbsp;</th>
                    <th align="left">Student</th>
                    <th align="left">Host</th>
                    <th>Due</th>
                    <th>Days Left</th>
                    <th>Actions</th>
                    <th>Date of Visit</th>
                    <th>SR Approved</th>
                    <th>RA Approved</th>
                    <th>RD Approved</th>
                    <th>Facilitator Approved</th>
                    <th>Rejected</th>
            	</tr>

                <!--- Display Current Students Report Information --->
                #displayReportBody(setQuery=qGetCurrentStudents,isCurrentList=true)#
                
                <!--- Display Previously Assigned Students Information  --->
                <cfif qGetPreviousStudents.recordCount>
                    <tr>
                        <th align="left" colspan="12">Previously Assigned Students</th>
                    </tr>
                    
                    #displayReportBody(setQuery=qGetPreviousStudents)#
                </cfif>
                
			</cfoutput> <!--- Second Visit Group --->
			
		</cfoutput> <!--- Advisor Group --->
            
	</table>

	<!----end of page---->
    <table width="100%" class="section">
        <tr>
            <th width="25%" class="advisor">Regional Advisor</th>
            <th width="25%" class="rep" style="padding:5px 10px 5px 10px;">Supervising Representative</th>
            <th width="25%" class="dueSoon" style="padding:5px 10px 5px 10px;">Report Due Soon</th>
            <th width="25%" class="overDue" style="padding:5px 10px 5px 10px;">Report Overdue</th>
        </tr>
    </table>
    
<cfelse>

    <table border="0" cellpadding="4" cellspacing="0" class="section" width="100%">
        <tr>
            <td align="center">No second visit reports matched your criteria.</td>
        </tr>
    </table>
    
</cfif> <!--- Display Results --->

<!--- Table Footer --->
<gui:tableFooter 
	width="100%"
/>