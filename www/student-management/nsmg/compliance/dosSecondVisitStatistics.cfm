<!--- ------------------------------------------------------------------------- ----
	
	File:		dosSecondVisitStatistics.cfm
	Author:		Marcus Melo
	Date:		January 10, 2012
	Desc:		2nd Visit Compliance Report

	Updated:	

	Rules: 		Permanent Family 
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
		param name="FORM.outputType" default="onScreen";
		
		// Set Current Row used to display light blue color on the table
		vCurrentRow = 0;
		
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
            active,
            cancelDate,
            <!--- Host History --->
            hostID,
            datePlaced,
            complianceWindow,
            dateStartWindowCompliance,
            DATE_ADD(dateStartWindowCompliance, INTERVAL complianceWindow DAY) AS dateEndWindowCompliance,
            <!--- Region --->
            regionID,
            regionName,
            <!--- 2nd Visit Report --->
            pr_ny_approved_date,
            dateOfVisit
        FROM
            (		
                <!--- Query to Get Approved Reports --->
                SELECT
                    s.studentID,
                    s.active,
                    s.cancelDate,
                    ht.hostID,
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
                            <!--- Relocation - Placement Date --->
                            WHEN 
                                ht.isRelocation = 1 
                            THEN 
                                ht.dateRelocated
                            <!--- Not a relocation - Arrival Date --->
                            WHEN 
                                ht.isRelocation = 0 
                            THEN 
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
                                )                            
                        END
                    ) AS dateStartWindowCompliance,
                    r.regionID,
                    r.regionName,
                    pr.pr_ny_approved_date,
                    sva.dateOfVisit
                FROM 	
                    smg_students s
                INNER JOIN
                    smg_hosthistory ht ON ht.studentID = s.studentID
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
                    smg_regions r ON r.regionID = s.regionAssigned     
                    AND
                        r.regionID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionID#" list="yes"> )
                WHERE 
                    s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> )
        
                UNION 
                
                <!--- Query to Get Missing Reports --->
                SELECT
                    s.studentID,
                    s.active,
                    s.cancelDate,
					ht.hostID,
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
                            <!--- Relocation - Placement Date --->
                            WHEN 
                                ht.isRelocation = 1 
                            THEN 
                                ht.dateRelocated
                            <!--- Not a relocation - Arrival Date --->
                            WHEN 
                                ht.isRelocation = 0 
                            THEN 
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
                                )                            
                        END
                    ) AS dateStartWindowCompliance,
                    r.regionID,
                    r.regionName,
                    CAST('' AS DATE) AS pr_ny_approved_date,
                    CAST('' AS DATE) AS dateOfVisit
                FROM 	
                    smg_students s
                INNER JOIN
                    smg_hosthistory ht ON ht.studentID = s.studentID
                        AND
                            ht.assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">    
                        AND
                            ht.hostID != <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                INNER JOIN
                    smg_regions r ON r.regionID = s.regionAssigned     
                    AND
                        r.regionID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionID#" list="yes"> )
                WHERE 
                    s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> )
                
				<!--- Do not include records with an approved date --->
                AND
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
                    cancelDate >= dateStartWindowCompliance                  
                )
        
        GROUP BY
            studentID,
            hostID
            
        ORDER BY
            regionName,
            studentID
    </cfquery>
    
</cfsilent>    

<!--- Page Header --->
<gui:pageHeader
	headerType="applicationNoHeader"
/>	

<!--- Output in Excel --->
<cfif FORM.outputType EQ 'excel'>
	
	<!--- set content type --->
	<cfcontent type="application/msexcel">
	
	<!--- suggest default name for XLS file --->
	<cfheader name="Content-Disposition" value="attachment; filename=DOS-Second-Visit-Statistics.xls"> 

</cfif>

<!--- Run Report --->
<cfoutput>

    <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable" <cfif FORM.outputType EQ 'excel'> border="1" </cfif> >
        <tr>
            <th>2<sup>nd</sup> Visit Representative Statistics By Region</th>
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
    
    <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable" <cfif FORM.outputType EQ 'excel'> border="1" </cfif> >
        <tr>
            <th class="left" width="20%">Region</th>
            <th class="center" width="10%">Total Students</th>
            <th class="center" width="10%">Total Reports</th>
            <th class="center" width="10%">Total Compliant</th>
            <th class="center" width="10%">Compliant %</th>
            <th class="center" width="10%">Total Late</th>
            <th class="center" width="10%">Total Missing</th>
            <th class="center" width="10%">Total Non-Compliant</th>
            <th class="center" width="10%">Non-Compliant %</th>			
        </tr>      
	
        <cfloop query="qGetRegions">
        
            <cfquery name="qFilterResultsByRegion" dbtype="query">
                SELECT
                    *
                FROM
                    qGetResults
                WHERE	
                    regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRegions.regionID#">
            </cfquery>
    		
            <cfif qFilterResultsByRegion.recordCount>
            
                <cfquery name="qTotalStudents" dbtype="query">
                    SELECT
                        studentID
                    FROM
                        qFilterResultsByRegion
                    GROUP BY
                        studentID
                </cfquery>

                <cfquery name="qTotalCompliant" dbtype="query">
                    SELECT
                        studentID
                    FROM
                        qFilterResultsByRegion
                    WHERE
                        dateOfVisit IS NOT <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                    AND
                        dateOfVisit <= dateEndWindowCompliance 
                </cfquery>
                
                <cfquery name="qTotalMissing" dbtype="query">
                    SELECT
                        studentID
                    FROM
                        qFilterResultsByRegion
                    WHERE	
                        dateOfVisit IS <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                </cfquery>

                <cfquery name="qTotalLate" dbtype="query">
                    SELECT
                        studentID
                    FROM
                        qFilterResultsByRegion
                    WHERE
                        dateOfVisit IS NOT <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                    AND
                        dateOfVisit > dateEndWindowCompliance 
                </cfquery>
                
                <cfscript>
					vCurrentRow++;
					
					vTotalCompliantPercentage = round(qTotalCompliant.recordCount / qFilterResultsByRegion.recordCount * 100);   
					
                    vTotalOutOfCompliance = VAL(qTotalMissing.recordCount) + VAL(qTotalLate.recordCount);
                    
                    vTotalOutCompliancePercentage = round(vTotalOutOfCompliance / qFilterResultsByRegion.recordCount * 100);
                </cfscript>
        
                <tr class="#iif(vCurrentRow MOD 2 ,DE("off") ,DE("on") )#">
                    <td>
                    	<cfif CLIENT.companyID EQ 5>
                        	#qGetRegions.companyShort# - 
                    	</cfif>
                        #qGetRegions.regionName#
                    </td>
                    <td class="center">#qTotalStudents.recordCount#</td>
                    <td class="center">#qFilterResultsByRegion.recordCount#</td>
                    <td class="center">#qTotalCompliant.recordCount#</td>
                    <td class="center">#vTotalCompliantPercentage#%</td>
                    <td class="center">#qTotalLate.recordCount#</td>
                    <td class="center">#qTotalMissing.recordCount#</td>
                    <td class="center">#vTotalOutOfCompliance#</td>
                    <td class="center">#vTotalOutCompliancePercentage#%</td>
                </tr>
            
            </cfif>
            
        </cfloop>

	</table>

</cfoutput>

<!--- Page Header --->
<gui:pageFooter />	