<!--- ------------------------------------------------------------------------- ----
	
	File:		dosSecondVisitCompliance.cfm
	Author:		Marcus Melo
	Date:		January 5, 2012
	Desc:		2nd Visit Compliance Report

	Updated:	
				
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

    <cfscript>	
		// Param FORM Variables
		param name="FORM.programID" default=0;	
		param name="FORM.regionID" default=0;	
	</cfscript>	
    
	<!--- Get Missing Reports --->
    <cfquery name="qGetResults" datasource="#APPLICATION.DSN#">
        SELECT
        	studentID,
            familyLastName,
            studentName,
            datePlaced,
            isRelocation,
            isWelcomeFamily,
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
            programName,
            regionID,
            regionName,
            hostID,
            hostFamilyName
        FROM
        	(
                
                SELECT
                    <!--- Student --->
                    s.studentID,
                    s.familyLastName,
                    CAST(CONCAT(s.firstName, ' ', s.familyLastName,  ' ##', s.studentID) AS CHAR) AS studentName,
                    <!--- Host History --->
                    ht.datePlaced,
                    ht.isRelocation,
                    ht.isWelcomeFamily,     
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
                    <!--- Program --->
                    p.programName,
                    <!--- Region --->
                    r.regionID,
                    r.regionName,
                    <!--- Host Family --->
                    h.hostID,
                    CAST(CONCAT(h.familyLastName, ' ##', h.hostID) AS CHAR) AS hostFamilyName
                FROM 	
                    smg_students s
                INNER JOIN
                    smg_hostHistory ht ON ht.studentID = s.studentID
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
                    s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">        
                AND
                    s.host_fam_approved <= <cfqueryparam cfsqltype="cf_sql_integer" value="4">
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
            familyLastName,
            datePlaced DESC
    </cfquery>

</cfsilent>    

<!--- Run Report --->

<table width="90%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
    <tr>
        <th>2<sup>nd</sup> Visit Representative Compliance By Region</th>
    </tr>
</table>

<cfoutput query="qGetResults" group="regionID">

    <table width="90%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
        <tr>
            <th class="left">- #qGetResults.regionName# Region</th>
        </tr>      
    </table>   

    <table width="90%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
        <tr>
            <th class="left" width="20%">Student</th>
            <th class="left" width="14%">Program</th>
            <th class="left" width="15%">Host Family</th>
            <th class="center" width="10%">Date of Arrival</th>
            <th class="center" width="10%">Date of Relocation</th>
            <th class="center" width="16%">Window of Compliance</th>
            <th class="center" width="10%">Due Date</th>
            <th class="center" width="10%">Days Remaining</th>
        </tr>      
    
        <cfoutput>
    
            <cfscript>
                vRemainingDays = '';
                if ( isDate(qGetResults.dateEndWindowCompliance) ) {
                    vRemainingDays = DateDiff('d', now(), qGetResults.dateEndWindowCompliance);
                }
            </cfscript>		
                            
            <tr class="#iif(qGetResults.currentRow MOD 2 ,DE("off") ,DE("on") )#">
                <td>#qGetResults.studentName#</td>
                <td>#qGetResults.programName#</td>
                <td>#qGetResults.hostFamilyName# <span style="font-size:9px">(<cfif VAL(qGetResults.isWelcomeFamily)>Welcome<cfelse>Permanent</cfif>)</span></td>
                <td align="center">#DateFormat(qGetResults.dateArrived, 'mm/dd/yy')#</td>
                <td align="center">#DateFormat(qGetResults.dateRelocated, 'mm/dd/yy')#</td>
                <td align="center">#DateFormat(qGetResults.dateStartWindowCompliance, 'mm/dd/yy')# - #DateFormat(qGetResults.dateEndWindowCompliance, 'mm/dd/yy')#</td>
                <td align="center">#DateFormat(qGetResults.dateEndWindowCompliance, 'mm/dd/yy')#</td>
                <td align="center" <cfif VAL(vRemainingDays) LT 0> class="alert" </cfif> >#vRemainingDays#</td>
            </tr>
            
        </cfoutput>
    
    </table>

</cfoutput>