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
		
		// Set Current Row used to display light blue color on the table
		vCurrentRow = 0;
		
		// Get Programs
		qGetPrograms = APPLICATION.CFC.PROGRAM.getPrograms(programIDList=FORM.programID);
	</cfscript>	
    
	<!--- Get Reports --->
    <cfquery name="qGetResults" datasource="#APPLICATION.DSN#">
        SELECT 
            <!--- Student --->
            studentID,
            <!--- Host History --->
            hostID,
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
                                ht.datePlaced
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
                    smg_hostHistory ht ON ht.studentID = s.studentID
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
                    smg_regions r ON r.regionID = s.regionAssigned     
                    AND
                        r.regionID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionID#" list="yes"> )
                WHERE 
                    s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">        
                AND
                    s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> )
        
                UNION 
                
                <!--- Query to Get Missing Reports --->
                SELECT
                    s.studentID,
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
                                ht.datePlaced
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
                    smg_hostHistory ht ON ht.studentID = s.studentID
                        AND
                            ht.hostID != <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                INNER JOIN
                    smg_regions r ON r.regionID = s.regionAssigned     
                    AND
                        r.regionID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionID#" list="yes"> )
                WHERE 
                    s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">   
                AND
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
        	<!--- Do not include records that are set as not required / hidden --->
            studentID NOT IN ( 
                SELECT 
                    shr.fk_student 
                FROM 
                    smg_hide_reports shr 
                WHERE 
                    shr.fk_host = hostID 
            ) 
        
        GROUP BY
            studentID,
            hostID
            
        ORDER BY
            regionName,
            studentID
    </cfquery>
            
</cfsilent>    

<cfoutput>

    <table width="90%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
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
    
    <table width="90%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
        <tr>
            <th class="left" width="22%">Region</th>
            <th class="center" width="13%">Total Students</th>
            <th class="center" width="13%">Total Reports</th>
            <th class="center" width="13%">Total Late</th>
            <th class="center" width="13%">Total Missing</th>
            <th class="center" width="13%">Total Non-Compliant</th>
            <th class="center" width="13%">Non-Compliant %</th>
        </tr>      
	
        <cfloop list="#FORM.regionID#" index="vRegionID">
        
            <cfquery name="qFilterResultsByRegion" dbtype="query">
                SELECT
                    *
                FROM
                    qGetResults
                WHERE	
                    regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#vRegionID#">
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
        
                <cfquery name="qTotalMissing" dbtype="query">
                    SELECT
                        *
                    FROM
                        qFilterResultsByRegion
                    WHERE	
                        pr_ny_approved_date IS <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                </cfquery>
                
                <cfquery name="qTotalLate" dbtype="query">
                    SELECT
                        *              
                    FROM
                        qFilterResultsByRegion
                    WHERE
                        dateOfVisit > dateEndWindowCompliance 
                </cfquery>
                
                <cfscript>
					vCurrentRow++;
				
                    vTotalOutOfCompliance = VAL(qTotalMissing.recordCount) + VAL(qTotalLate.recordCount);
                    
                    vTotalOutCompliancePercentage = round(vTotalOutOfCompliance / qFilterResultsByRegion.recordCount * 100);
                </cfscript>
        
                <tr class="#iif(vCurrentRow MOD 2 ,DE("off") ,DE("on") )#">
                    <td>#qFilterResultsByRegion.regionName#</td>
                    <td class="center">#qTotalStudents.recordCount#</td>
                    <td class="center">#qFilterResultsByRegion.recordCount#</td>
                    <td class="center">#qTotalLate.recordCount#</td>
                    <td class="center">#qTotalMissing.recordCount#</td>
                    <td class="center">#vTotalOutOfCompliance#</td>
                    <td class="center">#vTotalOutCompliancePercentage#%</td>
                </tr>
            
            </cfif>
            
        </cfloop>

	</table>

</cfoutput>