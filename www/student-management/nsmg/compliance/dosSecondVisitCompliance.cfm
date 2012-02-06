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
		param name="FORM.reportType" default="onScreen";
		
		// Get Programs
		qGetPrograms = APPLICATION.CFC.PROGRAM.getPrograms(programIDList=FORM.programID);
		
		// Get Regions
		qGetRegions = APPLICATION.CFC.REGION.getRegions(regionIDList=FORM.regionID);
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
            isWelcomeFamily,
            isRelocation,
            datePlaced,
            complianceWindow,
            dateRelocated,
            dateArrived,
            (
                CASE 
                    <!--- Welcome Family - 30 Days --->
                    WHEN 
                        isRelocation = 1 
                    THEN 
                        dateRelocated
                    <!--- Permanent Family - 60 Days --->
                    WHEN 	
                        isRelocation = 0 
                    THEN 
                        dateArrived
                END
            ) AS dateStartWindowCompliance,
            (
                CASE 
                    <!--- Relocation - dateRelocated --->
                    WHEN 
                        isRelocation = 1 
                    THEN 
                        DATE_ADD(dateRelocated, INTERVAL complianceWindow DAY)
                    <!--- Relocation - dateArrived --->
                    WHEN 	
                        isRelocation = 0 
                    THEN 
                        DATE_ADD(dateArrived, INTERVAL complianceWindow DAY)
                END
            ) AS dateEndWindowCompliance,
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
            hostFamilyName
        FROM
            (		
                <!--- Query to Get Approved Reports --->
                SELECT
                    s.studentID,
                    s.familyLastName,
                    s.active,
                    s.cancelDate,
                    CAST(CONCAT(s.firstName, ' ', s.familyLastName,  ' ##', s.studentID) AS CHAR) AS studentName,
                    ht.isWelcomeFamily, 
                    ht.isRelocation, 
                    ht.datePlaced,
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
                    	CASE
                        	<!--- Relocation --->
                        	WHEN
                            	ht.isRelocation = 1
                            THEN
                            	ht.datePlaced
                            <!--- Not a Relocation --->
                        	WHEN
                            	ht.isRelocation = 0
                            THEN
                            	CAST('' AS DATE)
						END                       
                    ) AS dateRelocated,
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
                            programID = s.programID
                        AND 
                            isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                        ORDER BY 
                            dep_date ASC,
                            dep_time ASC
                        LIMIT 1                            
                    ) AS dateArrived, 
                    p.programName,
                    r.regionID,
                    r.regionName,
                    pr.pr_ny_approved_date,
                    sva.dateOfVisit,
                    h.hostID,
                    CAST(CONCAT(h.familyLastName, ' ##', h.hostID) AS CHAR) AS hostFamilyName                    
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
                	secondVisitAnswers sva ON sva.fk_reportID = pr.pr_ID
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
        
				<!--- Query to Get Welcome Family Expired Reports --->   
                
                UNION 
   				
                <!--- Query to Get Missing Reports --->
                SELECT
                    s.studentID,
                    s.familyLastName,
                    s.active,
                    s.cancelDate,
                    CAST(CONCAT(s.firstName, ' ', s.familyLastName,  ' ##', s.studentID) AS CHAR) AS studentName,
                    ht.isWelcomeFamily, 
                    ht.isRelocation, 
                    ht.datePlaced,
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
                    	CASE
                        	<!--- Relocation --->
                        	WHEN
                            	ht.isRelocation = 1
                            THEN
                            	ht.datePlaced
                            <!--- Not a Relocation --->
                        	WHEN
                            	ht.isRelocation = 0
                            THEN
                            	CAST('' AS DATE)
						END                       
                    ) AS dateRelocated,
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
                            programID = s.programID
                        AND 
                            isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                        ORDER BY 
                            dep_date ASC,
                            dep_time ASC
                        LIMIT 1                            
                    ) AS dateArrived,
                    p.programName, 
                    r.regionID,
                    r.regionName,
                    CAST('' AS DATE) AS pr_ny_approved_date,
                    CAST('' AS DATE) AS dateOfVisit,
                    h.hostID,
                    CAST(CONCAT(h.familyLastName, ' ##', h.hostID) AS CHAR) AS hostFamilyName                    
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
            studentID,
            hostID
            
        ORDER BY
            regionName,
            familyLastName,
            studentID
    </cfquery>

</cfsilent>    

<!--- Page Header --->
<gui:pageHeader
	headerType="applicationNoHeader"
/>	

<!--- Output in Excel --->
<cfif FORM.reportType EQ 'excel'>
	
	<!--- set content type --->
	<cfcontent type="application/msexcel">
	
	<!--- suggest default name for XLS file --->
	<cfheader name="Content-Disposition" value="attachment; filename=DOS-Second-Visit-Compliance.xls"> 

</cfif>

<!--- Run Report --->
<cfoutput>

    <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable" <cfif FORM.reportType EQ 'excel'> border="1" </cfif> >
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
    
    <cfloop query="qGetRegions">
        
        <cfquery name="qGetResultsByRegion" dbtype="query">
            SELECT
                *        		
            FROM            
                qGetResults
            WHERE
                regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRegions.regionID#">
        </cfquery>
        
        <cfif qGetResultsByRegion.recordCount>
                    
            <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable" <cfif FORM.reportType EQ 'excel'> border="1" </cfif> >
                <tr>
                    <th class="left" colspan="10">
                    	<cfif CLIENT.companyID EQ 5>
                        	- #qGetRegions.companyShort#
                        </cfif>
                    	- #qGetRegions.regionName# Region &nbsp; - &nbsp; Total of #qGetResultsByRegion.recordCount# report(s)
                    </th>
                </tr>      
                <tr>
                    <td class="subTitleLeft" width="15%">Student</td>
                    <td class="subTitleLeft" width="12%">Program</td>
                    <td class="subTitleLeft" width="14%">Host Family</td>
                    <td class="subTitleCenter" width="8%">Date Placed</td>
                    <td class="subTitleCenter" width="8%">Date of Arrival</td>
                    <td class="subTitleCenter" width="8%">Date of Relocation</td>
                    <td class="subTitleCenter" width="16%">Window of Compliance</td>
                    <td class="subTitleCenter" width="8%">Due Date</td>
                    <td class="subTitleCenter" width="8%">Date Of Visit</td>
                    <td class="subTitleCenter" width="8%">Days Remaining</td>
                </tr>      
            
                <cfloop query="qGetResultsByRegion">
                    
                    <!--- Display records out of compliance or students placed in welcome family missing following report --->
                    <cfif NOT IsDate(qGetResultsByRegion.dateOfVisit) OR qGetResultsByRegion.dateOfVisit GT qGetResultsByRegion.dateEndWindowCompliance>
                    
                        <cfscript>
                            vRemainingDays = '';
                            vSetColorCode = '';
                            vSetRelocationColorCode = '';
                            
                            // Calculate remaining days
                            if ( isDate(qGetResultsByRegion.dateOfVisit) AND isDate(qGetResultsByRegion.dateEndWindowCompliance)  ) {
                                vRemainingDays = DateDiff('d', qGetResultsByRegion.dateOfVisit, qGetResultsByRegion.dateEndWindowCompliance);
                            } else if ( isDate(qGetResultsByRegion.dateEndWindowCompliance) ) {
                                vRemainingDays = DateDiff('d', now(), qGetResultsByRegion.dateEndWindowCompliance);
                            }
                            
                            // Set up Remaining Days Alert
                            if ( IsNumeric(vRemainingDays) AND vRemainingDays LTE 0 ) {
                                vSetColorCode = 'alert';
                            } else if ( IsNumeric(vRemainingDays) AND vRemainingDays LTE 14 ) {
                                vSetColorCode = 'attention';
                            }
                            
                            // Set up Relocation Date Prior to Arrival Date alert
                            if ( isDate(qGetResultsByRegion.dateArrived) AND isDate(qGetResultsByRegion.dateRelocated) AND qGetResultsByRegion.dateArrived GT qGetResultsByRegion.dateRelocated ) {
                                vSetRelocationColorCode = 'attention';
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
                                <cfif VAL(qGetResultsByRegion.isWelcomeFamily)>
                                    <span class="note">(Welcome)</span>
                                <cfelse>
                                    <span class="note">(Permanent)</span>
                                </cfif>
                            </td>
                            <td class="center">#DateFormat(qGetResultsByRegion.datePlaced, 'mm/dd/yy')#</td>
                            <td class="center">#DateFormat(qGetResultsByRegion.dateArrived, 'mm/dd/yy')#</td>
                            <td class="center #vSetRelocationColorCode#">#DateFormat(qGetResultsByRegion.dateRelocated, 'mm/dd/yy')#</td>
                            <td class="center">#DateFormat(qGetResultsByRegion.dateStartWindowCompliance, 'mm/dd/yy')# - #DateFormat(qGetResultsByRegion.dateEndWindowCompliance, 'mm/dd/yy')#</td>
                            <td class="center">#DateFormat(qGetResultsByRegion.dateEndWindowCompliance, 'mm/dd/yy')#</td>
                            <td class="center">#DateFormat(qGetResultsByRegion.dateOfVisit, 'mm/dd/yy')#</td>
                            <td class="center #vSetColorCode#">#vRemainingDays#</td>
                        </tr>
                    
                    </cfif>
                    
                </cfloop>
            
            </table>
    		
        </cfif>
    
    </cfloop>    

</cfoutput>

<!--- Page Header --->
<gui:pageFooter />