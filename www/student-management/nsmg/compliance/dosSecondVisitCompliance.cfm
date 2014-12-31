<!--- ------------------------------------------------------------------------- ----
	
	File:		dosSecondVisitCompliance.cfm
	Author:		Marcus Melo
	Date:		January 5, 2012
	Desc:		2nd Visit Compliance Report

	Updated:
			
	Rules: 		Adding filter to display records due within 14 days	
		
				Permanent Family 
					- 2nd Visit Report within 60 days
				Temporary Family 
					- 2nd Visit Report within 30 days
					- Then every 30 days from the date of the previous visit (NEED TO BE ADDED)
				
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

    <cfscript>	
		// Param FORM Variables
		param name="FORM.programID" default=0;	
		param name="FORM.regionID" default=0;
		param name="FORM.isDueSoon" default=0;
		param name="FORM.outputType" default="onScreen";
		param name="FORM.sendEmail" default=0;
		
		// Get Programs
		qGetPrograms = APPLICATION.CFC.PROGRAM.getPrograms(programIDList=FORM.programID);
	</cfscript>	
    
	<!--- Get Reports --->
    <cfquery name="qGetResults" datasource="#APPLICATION.DSN#">
        SELECT 
            <!--- Student --->
            studentID,
            familyLastName,
            studentName,
            active,
            cancelDate,
            <!--- Host History --->
            historyID,
            secondVisitRepID,
            isWelcomeFamily,
            isRelocation,
            datePlaced,
            datePlacedEnded,
            dateRelocated,
            dateArrived,
            complianceWindow,
            (
                CASE 
                    <!--- Placement Not Active | Use Date Placed --->
                    WHEN 
                        isActive = 0 
                    THEN 
                        DATEDIFF(datePlacedEnded, datePlaced)
                    <!--- Placement Active | dateStartWindowCompliance ( relocated or arrival ) --->
                    WHEN 	
                        isActive = 1  
                    THEN 
                        DATEDIFF(datePlacedEnded, dateStartWindowCompliance)
                END
            ) AS totalAssignedPeriod,
            (
                CASE 
                    <!--- Placement Not Active | Use Date Placed --->
                    WHEN 
                        isActive = 0 
                    THEN 
                        datePlaced
                    <!--- Placement Active | dateStartWindowCompliance ( relocated or arrival ) --->
                    WHEN 	
                        isActive = 1  
                    THEN 
                        dateStartWindowCompliance
                END
            ) AS dateStartWindowCompliance,
            DATE_ADD(dateStartWindowCompliance, INTERVAL complianceWindow DAY) AS dateEndWindowCompliance,
            dateCreated,
            <!--- Program --->
            programName,
            <!--- Region --->
            regionID,
            regionName,
            <!--- 2nd Visit Report --->
            pr_ny_approved_date,
            dateOfVisit,
            <!--- Host Family --->
            hostID,
            hostFamilyName,
            <!--- Facilitator --->
            facilitatorName,
            (
                CASE 
                    <!--- Days Remaining --->
                    WHEN 
                        dateofVisit IS NOT NULL 
                    THEN 
                        DATEDIFF( DATE_ADD(dateStartWindowCompliance, INTERVAL complianceWindow DAY), dateofVisit )
                    <!--- Days Remaining --->
                    WHEN 	
                        dateofVisit IS NULL 
                    THEN 
                        DATEDIFF( DATE_ADD(dateStartWindowCompliance, INTERVAL complianceWindow DAY), CURRENT_DATE )
                END
            ) AS remainingDays
        FROM
            (		
                <!--- Query to Get Approved Reports --->
                SELECT
                    s.studentID,
                    s.familyLastName,
                    s.active,
                    s.cancelDate,
                    CAST(CONCAT(s.firstName, ' ', s.familyLastName,  ' ##', s.studentID) AS CHAR) AS studentName,
                    ht.historyID,
                    ht.isActive,
                    ht.secondVisitRepID,
                    ht.isWelcomeFamily, 
                    ht.isRelocation, 
                    ht.datePlaced,
                    ht.datePlacedEnded,
					ht.dateRelocated, 
                    (
                        CASE 
                            <!--- Welcome Family - 30 Days --->
                            WHEN 
                                ht.isWelcomeFamily = 1 
                            THEN 
                                30
                            <!--- Permanent Family - 60 Days --->
                            WHEN 	
                                ht.isWelcomeFamily = 0 
                            THEN 
                                60
                        END
                    ) AS complianceWindow,
                    (
                        SELECT 
                            dep_date 
                        FROM 
                            smg_flight_info 
                        WHERE 
                            studentID = s.studentID 
                        AND 
                            flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="arrival"> 
                        AND
                        	assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                        AND 
                            isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                        <!--- 
						AND
							programID = s.programID
						--->
                        ORDER BY 
                            dep_date ASC,
                            dep_time ASC
                        LIMIT 1                            
                    ) AS dateArrived, 
                    IFNULL(ht.dateRelocated, 
                        (
                            SELECT 
                                dep_date 
                            FROM 
                                smg_flight_info 
                            WHERE 
                                studentID = s.studentID 
                            AND 
                                flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="arrival"> 
                            AND
                                assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
							AND 
                                isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                       	 	<!--- 
							AND
								programID = s.programID
							--->
                            ORDER BY 
                                dep_date ASC,
                                dep_time ASC
                            LIMIT 1                            
                        )                    
                    ) AS dateStartWindowCompliance,
                    ht.dateCreated,
                    p.programName,
                    r.regionID,
                    r.regionName,
                    pr.pr_ny_approved_date,
                    sva.dateOfVisit,
                    h.hostID,
                    CAST(CONCAT(h.familyLastName, ' ##', h.hostID) AS CHAR) AS hostFamilyName,
                    CONCAT(fac.firstName, ' ', fac.lastName) AS facilitatorName                   
                FROM 	
                    smg_students s
                INNER JOIN
                    smg_hostHistory ht ON ht.studentID = s.studentID
                        AND
                            ht.assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">    
                INNER JOIN
                    progress_reports pr ON pr.fk_student = s.studentID            
                    AND
                        pr.fk_reportType = <cfqueryparam cfsqltype="cf_sql_integer" value="2">	
                    AND
                        pr.fk_host = ht.hostID 
                    AND
                        pr.pr_ny_approved_date IS NOT <cfqueryparam cfsqltype="cf_sql_date" null="yes">   
                INNER JOIN	
                	secondvisitanswers sva ON sva.fk_reportID = pr.pr_ID
                INNER JOIN	
                    smg_programs p ON p.programID = s.programID
                    AND
                        p.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> )
                INNER JOIN
                    smg_regions r ON r.regionID = s.regionAssigned     
                    AND
                        r.regionID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionID#" list="yes"> )
                INNER JOIN
                    smg_hosts h ON h.hostID = ht.hostID
                LEFT OUTER JOIN
                    smg_users fac ON fac.userID = r.regionFacilitator
        
				<!--- Query to Get Welcome Family Expired Reports --->   
                
                UNION 
   				
                <!--- Query to Get Missing Reports --->
                SELECT
                    s.studentID,
                    s.familyLastName,
                    s.active,
                    s.cancelDate,
                    CAST(CONCAT(s.firstName, ' ', s.familyLastName,  ' ##', s.studentID) AS CHAR) AS studentName,
                    ht.historyID,
                    ht.isActive,
                    ht.secondVisitRepID,
                    ht.isWelcomeFamily, 
                    ht.isRelocation, 
                    ht.datePlaced,
                    ht.datePlacedEnded,
                    ht.dateRelocated,
                    (
                        CASE 
                            <!--- Welcome Family - 30 Days --->
                            WHEN 
                                ht.isWelcomeFamily = 1 
                            THEN 
                                30
                            <!--- Permanent Family - 60 Days --->
                            WHEN 	
                                ht.isWelcomeFamily = 0 
                            THEN 
                                60
                        END
                    ) AS complianceWindow,
                    (
                        SELECT 
                            dep_date 
                        FROM 
                            smg_flight_info 
                        WHERE 
                            studentID = s.studentID 
                        AND 
                            flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="arrival"> 
                        AND
                        	assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
						AND 
                            isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                        <!--- 
						AND
							programID = s.programID
						--->
                        ORDER BY 
                            dep_date ASC,
                            dep_time ASC
                        LIMIT 1                            
                    ) AS dateArrived,
                    IFNULL(ht.dateRelocated, 
                        (
                            SELECT 
                                dep_date 
                            FROM 
                                smg_flight_info 
                            WHERE 
                                studentID = s.studentID 
                            AND 
                                flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="arrival"> 
                            AND
                                assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
							AND 
                                isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
	                        <!--- 
							AND
								programID = s.programID
							--->
                            ORDER BY 
                                dep_date ASC,
                                dep_time ASC
                            LIMIT 1                            
                        )                    
                    ) AS dateStartWindowCompliance,
                    ht.dateCreated,
                    p.programName, 
                    r.regionID,
                    r.regionName,
                    CAST('' AS DATE) AS pr_ny_approved_date,
                    CAST('' AS DATE) AS dateOfVisit,
                    h.hostID,
                    CAST(CONCAT(h.familyLastName, ' ##', h.hostID) AS CHAR) AS hostFamilyName,
                    CONCAT(fac.firstName, ' ', fac.lastName) AS facilitatorName
                FROM 	
                    smg_students s
                INNER JOIN
                    smg_hostHistory ht ON ht.studentID = s.studentID
                        AND
                            ht.assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">    
                        AND
                            ht.hostID != <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                INNER JOIN	
                    smg_programs p ON p.programID = s.programID
                    AND
                        p.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> )
                INNER JOIN
                    smg_regions r ON r.regionID = s.regionAssigned     
                    AND
                        r.regionID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionID#" list="yes"> )
                INNER JOIN
                    smg_hosts h ON h.hostID = ht.hostID
                LEFT OUTER JOIN
                    smg_users fac ON fac.userID = r.regionFacilitator
                    
                WHERE 
                     
					<!--- Do not include records with an approved date --->
                    s.studentID NOT IN (
                        SELECT
                            pr.fk_student
                        FROM
                            progress_reports pr
                        WHERE
                            pr.fk_reportType = <cfqueryparam cfsqltype="cf_sql_integer" value="2">	
                        AND
                            pr.fk_host = ht.hostID 
                        AND
                            pr.pr_ny_approved_date IS NOT <cfqueryparam cfsqltype="cf_sql_date" null="yes">          
                    )
                    
            ) AS t
        WHERE
        	<!--- Only Approved Placement has a datePlaced --->
            datePlaced IS NOT <cfqueryparam cfsqltype="cf_sql_date" null="yes">
			
			<!--- Do not include records that are set as not required / hidden --->
            AND
            	studentID NOT IN ( 
                    SELECT 
                        shr.fk_student 
                    FROM 
                        smg_hide_reports shr 
                    WHERE 
                        shr.fk_host = hostID 
            	) 
            
            <!--- Include Active and students that canceled after arrival date --->
			AND
            	(
					active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">               	 
                 OR
                    cancelDate >= dateArrived                  
                )
        	            
        GROUP BY
        	<!--- historyID, ---> <!--- Will get duplicate records but will avoid not displaying students if they have more than one record for the same host family --->
            studentID,
            hostID
		
        <!--- Display present records (current placements) or records with a days diff > 0 --->
        HAVING
        
        (
        	totalAssignedPeriod IS <cfqueryparam cfsqltype="cf_sql_date" null="yes">
        OR
        	totalAssignedPeriod > <cfqueryparam cfsqltype="cf_sql_bit" value="0"> 
		)
        
		<cfif VAL(FORM.isDueSoon)>
            AND
            	(
                    remainingDays <= <cfqueryparam cfsqltype="cf_sql_integer" value="14">
                OR
                    remainingDays IS NULL
            	)       
        </cfif>
            
        ORDER BY
            regionName,
            familyLastName,
            studentID,
            dateCreated DESC,
            studentID
    </cfquery>

</cfsilent>    

<!--- Page Header --->
<gui:pageHeader
	headerType="applicationNoHeader"
/>	

<cfoutput>

	<!--- Output in Excel - Do not use GroupBy --->
    <cfif FORM.outputType EQ 'excel'>
        
        <!--- set content type --->
        <cfcontent type="application/msexcel">
        
        <!--- suggest default name for XLS file --->
        <cfheader name="Content-Disposition" value="attachment; filename=DOS-Second-Visit-Compliance.xls"> 
        
    	<table width="98%" cellpadding="4" cellspacing="0" align="center" border="1">
            <tr>
                <th colspan="14">2<sup>nd</sup> Visit Representative Compliance By Region</th>            
            </tr>
            <tr style="font-weight:bold;">
                <td>Division</td>
                <td>Region</td>
                <td>Facilitator</td>
                <td>Student</td>
                <td>Program</td>
                <td>Host Family</td>
                <td>Date Placed</td>
                <td>Date of Arrival</td>
                <td>Date of Relocation</td>
                <td>Assigned Period</td>
                <td>Window of Compliance</td>
                <td>Due Date</td>
                <td>Date Of Visit</td>
                <td>Days Remaining</td>
            </tr>      
            
            <cfloop query="qGetResults">
                
                <cfscript>
                    vSetColorCode = '';
                    vSetRelocationColorCode = '';
                    
                    // Set up Remaining Days Alert
                    if ( IsNumeric(qGetResults.remainingDays) AND qGetResults.remainingDays LTE 0 ) {
                        vSetColorCode = '##FF0000';
                    } else if ( IsNumeric(qGetResults.remainingDays) AND qGetResults.remainingDays LTE 14 ) {
                        vSetColorCode = '##FFFF00';
                    }
                    
                    // Set up Relocation Date Prior to Arrival Date alert
                    if ( isDate(qGetResults.dateArrived) AND isDate(qGetResults.dateRelocated) AND qGetResults.dateArrived GT qGetResults.dateRelocated ) {
                        vSetRelocationColorCode = 'attention';
                    }
					
					// Set Row Color
					if ( qGetResults.currentRow MOD 2 ) {
						vRowColor = '##E6E6E6';
					} else {
						vRowColor = '##FFFFFF';
					}
                </cfscript>		
                
                <tr>
                    <td bgcolor="#vRowColor#">#CLIENT.companyShort#</td>
                    <td bgcolor="#vRowColor#">#qGetResults.regionName#</td>
                    <td bgcolor="#vRowColor#">#qGetResults.facilitatorName#</td>
                    <td bgcolor="#vRowColor#">
                        #qGetResults.studentName#
                        <cfif VAL(qGetResults.active)>
                            <span class="note">(Active)</span>
                        <cfelseif isDate(qGetResults.cancelDate)>
                            <span class="noteAlert">(Cancelled)</span>
                        </cfif>
                    </td>
                    <td bgcolor="#vRowColor#">#qGetResults.programName#</td>
                    <td bgcolor="#vRowColor#">
                        #qGetResults.hostFamilyName# 
                        <span class="note">
                            (
                                <cfif VAL(qGetResults.isWelcomeFamily)>
                                    Welcome
                                <cfelse>
                                    Permanent
                                </cfif>
                                
                                <cfif VAL(qGetResults.isRelocation)>
                                    - Relocation
                                </cfif>
                            )
                        </span>
                    </td>
                    <td bgcolor="#vRowColor#">#DateFormat(qGetResults.datePlaced, 'mm/dd/yy')#</td>
                    <td bgcolor="#vRowColor#">#DateFormat(qGetResults.dateArrived, 'mm/dd/yy')#</td>
                    <td bgcolor="#vRowColor#">#DateFormat(qGetResults.dateRelocated, 'mm/dd/yy')#</td>
                    <td bgcolor="#vRowColor#">
                        <cfif isDate(qGetResults.dateStartWindowCompliance)>
                        
                            #DateFormat(qGetResults.dateStartWindowCompliance, 'mm/dd/yy')# - 
                            
                            <cfif isDate(qGetResults.datePlacedEnded)>
                                #DateFormat(qGetResults.datePlacedEnded, 'mm/dd/yy')# (#totalAssignedPeriod# days)
                            <cfelse>
                                present
                            </cfif>
                            
                        </cfif>
                    </td>
                    <td bgcolor="#vRowColor#">#DateFormat(qGetResults.dateStartWindowCompliance, 'mm/dd/yy')# - #DateFormat(qGetResults.dateEndWindowCompliance, 'mm/dd/yy')#</td>
                    <td bgcolor="#vRowColor#">#DateFormat(qGetResults.dateEndWindowCompliance, 'mm/dd/yy')#</td>
                    <td bgcolor="#vRowColor#">#DateFormat(qGetResults.dateOfVisit, 'mm/dd/yy')#</td>
                    <cfif LEN(vSetColorCode)>
                        <td bgcolor="#vSetColorCode#">#qGetResults.remainingDays#</td>
                    <cfelse>
                        <td bgcolor="#vRowColor#">#qGetResults.remainingDays#</td>
                    </cfif>
                </tr>
                
            </cfloop>
        
        </table>    
    
    <!--- On Screen Report --->
    <cfelse>
    
        <!--- Store Report Header in a Variable --->
        <cfsavecontent variable="reportHeader">
            
            <!--- Run Report --->
            <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                <tr>
                    <th>2<sup>nd</sup> Visit Representative Compliance By Region</th>
                </tr>
                <tr>
                    <td class="center">
                        Program(s) included in this report: <br />
                        <cfloop query="qGetPrograms">
                            #qGetPrograms.programName# <br />
                        </cfloop>
                    </td>
                </tr>
            </table>
            
            <br />
        
        </cfsavecontent>
        
        <!--- Display Report Header --->
        #reportHeader#
        
		<!--- Loop Regions ---> 
        <cfloop list="#FORM.regionID#" index="currentRegionID">

			<!--- Save Report in a Variable --->
            <cfsavecontent variable="reportBody">

				<cfscript>
                    // Get Regional Manager
                    qGetRegionalManager = APPLICATION.CFC.USER.getRegionalManager(regionID=currentRegionID);
                </cfscript>
            
                <cfquery name="qGetResultsByRegion" dbtype="query">
                    SELECT
                        *        		
                    FROM            
                        qGetResults
                    WHERE
                        regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#currentRegionID#">
                    <!--- Display records out of compliance or students placed in welcome family missing following report --->
                    AND
                        (
                            dateOfVisit IS <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                        OR
                            dateOfVisit > dateEndWindowCompliance
                        )
                </cfquery>
                
                <cfif qGetResultsByRegion.recordCount>
                            
                    <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                        <tr>
                            <th class="left" colspan="7">
                                <cfif CLIENT.companyID EQ 5>
                                    - #CLIENT.companyShort#
                                </cfif>
                                
                                - #qGetResultsByRegion.regionName# Region 
                                &nbsp; - &nbsp; 
                                
                                #qGetResultsByRegion.facilitatorName# 
                            </th>
                            <th class="right" colspan="4">
                                Total of #qGetResultsByRegion.recordCount# non-compliant report(s)
                            </th>
                        </tr>      
                        <tr>
                            <td class="subTitleLeft" width="14%">Student</td>
                            <td class="subTitleLeft" width="12%">Program</td>
                            <td class="subTitleLeft" width="13%">Host Family</td>
                            <td class="subTitleCenter" width="7%">Date Placed</td>
                            <td class="subTitleCenter" width="7%">Date of Arrival</td>
                            <td class="subTitleCenter" width="7%">Date of Relocation</td>
                            <td class="subTitleCenter" width="12%">Assigned Period</td>
                            <td class="subTitleCenter" width="12%">Window of Compliance</td>
                            <td class="subTitleCenter" width="7%">Due Date</td>
                            <td class="subTitleCenter" width="7%">Date Of Visit</td>
                            <td class="subTitleCenter" width="7%">Days Remaining</td>
                        </tr>      
                    
                        <cfloop query="qGetResultsByRegion">
                            
                            <cfscript>
                                vSetColorCode = '';
                                vSetRelocationColorCode = '';
                                
                                // Set up Remaining Days Alert
                                if ( IsNumeric(qGetResultsByRegion.remainingDays) AND qGetResultsByRegion.remainingDays LTE 0 ) {
                                    vSetColorCode = 'alertCenter';
                                } else if ( IsNumeric(qGetResultsByRegion.remainingDays) AND qGetResultsByRegion.remainingDays LTE 14 ) {
                                    vSetColorCode = 'attentionCenter';
                                }
                                
                                // Set up Relocation Date Prior to Arrival Date alert
                                if ( isDate(qGetResultsByRegion.dateArrived) AND isDate(qGetResultsByRegion.dateRelocated) AND qGetResultsByRegion.dateArrived GT qGetResultsByRegion.dateRelocated ) {
                                    vSetRelocationColorCode = 'attention';
                                }
                                
                                vSetAsNotNeeded = 0;
                                
                                // Set Report as Not Needed - EXITS System --> userID = 5
                                if ( isNumeric(qGetResultsByRegion.totalAssignedPeriod) AND qGetResultsByRegion.totalAssignedPeriod LT qGetResultsByRegion.complianceWindow AND NOT isDate(qGetResultsByRegion.dateOfVisit) ) {
                                    vSetAsNotNeeded = 1;
                                    /*
                                    APPLICATION.CFC.progressReport.setSecondVisitReportAsNotNeeded(
                                        historyID = qGetResultsByRegion.historyID,
                                        fk_student = qGetResultsByRegion.studentID,
                                        fk_host = qGetResultsByRegion.hostID,
                                        fk_secondVisitRep = qGetResultsByRegion.secondVisitRepID
                                    );
                                    */
                                }
                            </cfscript>		
                            
                            <tr class="#iif(qGetResultsByRegion.currentRow MOD 2 ,DE("off") ,DE("on") )#">
                                <td>
                                    #qGetResultsByRegion.studentName#
                                    <cfif VAL(qGetResultsByRegion.active)>
                                        <span class="note">(Active)</span>
                                    <cfelseif isDate(qGetResultsByRegion.cancelDate)>
                                        <span class="noteAlert">(Cancelled)</span>
                                    </cfif>
                                </td>
                                <td>#qGetResultsByRegion.programName#</td>
                                <td>
                                    #qGetResultsByRegion.hostFamilyName# 
                                    <span class="note">
                                        (
											<cfif VAL(qGetResultsByRegion.isWelcomeFamily)>
                                                Welcome
                                            <cfelse>
                                                Permanent
                                            </cfif>
                                            
                                            <cfif VAL(qGetResultsByRegion.isRelocation)>
                                                - Relocation
                                            </cfif>
                                        )
                                    </span>
                                </td>
                                <td class="center">#DateFormat(qGetResultsByRegion.datePlaced, 'mm/dd/yy')#</td>
                                <td class="center">#DateFormat(qGetResultsByRegion.dateArrived, 'mm/dd/yy')#</td>
                                <td class="center #vSetRelocationColorCode#">#DateFormat(qGetResultsByRegion.dateRelocated, 'mm/dd/yy')#</td>
                                <td class="center">
                                    <cfif isDate(qGetResultsByRegion.dateStartWindowCompliance)>
                                    
                                        #DateFormat(qGetResultsByRegion.dateStartWindowCompliance, 'mm/dd/yy')# - 
                                        
                                        <cfif isDate(qGetResultsByRegion.datePlacedEnded)>
                                            #DateFormat(qGetResultsByRegion.datePlacedEnded, 'mm/dd/yy')# (#totalAssignedPeriod# days)
                                        <cfelse>
                                            present
                                        </cfif>
                                        
                                        <!---
										<cfif VAL(vSetAsNotNeeded)>
											<div class="attention">Report NOT required</div> <!--- Report set as NOT needed --->
										</cfif>
										--->
                                        
                                    </cfif>
                                </td>
                                <td class="center">#DateFormat(qGetResultsByRegion.dateStartWindowCompliance, 'mm/dd/yy')# - #DateFormat(qGetResultsByRegion.dateEndWindowCompliance, 'mm/dd/yy')#</td>
                                <td class="center">#DateFormat(qGetResultsByRegion.dateEndWindowCompliance, 'mm/dd/yy')#</td>
                                <td class="center">#DateFormat(qGetResultsByRegion.dateOfVisit, 'mm/dd/yy')#</td>
                                <td class="#vSetColorCode# center">#qGetResultsByRegion.remainingDays#</td>
                            </tr>
                            
                        </cfloop>
                    
                    </table>
                    
                </cfif>
        
        	</cfsavecontent>
            
			<!--- Display Report --->
            #reportBody#
    
            <!--- Email Regional Manager --->        
            <cfif VAL(FORM.sendEmail) AND qGetResultsByRegion.recordcount AND IsValid("email", qGetRegionalManager.email) AND IsValid("email", CLIENT.email)>
                
                 <cfsavecontent variable="emailBody">
                    <html>
                        <head>
                            <title>#qGetResultsByRegion.regionName# - 2nd Visit Representative Compliance By Region</title>
                        </head>
                        <body>
                            
                            <!--- Include CSS on the body of email --->
                            <style type="text/css">
                                <cfinclude template="../linked/css/baseStyle.css">
                            </style>                    
                            
                            <!--- Display Report Header --->
                            #reportHeader#	
                                              
                            <!--- Display Report --->
                            #reportBody#
    
                       </body>
                    </html>
                </cfsavecontent>
        
                <cfinvoke component="nsmg.cfc.email" method="send_mail">
                    <cfinvokeargument name="email_to" value="#qGetRegionalManager.email#">
                    <cfinvokeargument name="email_cc" value="#CLIENT.email#">
                    <cfinvokeargument name="email_from" value="#CLIENT.support_email#">
                    <cfinvokeargument name="email_subject" value="#CLIENT.companyshort# - 2nd Visit Representative Compliance By Region">
                    <cfinvokeargument name="email_message" value="#emailBody#">
                </cfinvoke>
                
                <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                    <tr>
                        <th class="left">*** Report emailed to #qGetRegionalManager.firstName# #qGetRegionalManager.lastName# at #qGetRegionalManager.email# ***</th>
                    </tr>              
                </table>
                
			</cfif>   
            <!--- Email Regional Manager --->                
        
        </cfloop>    
        
    </cfif>

</cfoutput> 

<!--- Page Header --->
<gui:pageFooter />