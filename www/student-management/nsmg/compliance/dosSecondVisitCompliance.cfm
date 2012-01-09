<!--- ------------------------------------------------------------------------- ----
	
	File:		dosSecondVisitCompliance.cfm
	Author:		Marcus Melo
	Date:		December 6, 2011
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
    
	<!--- Get Students --->
    <cfquery name="qGetResults" datasource="#APPLICATION.DSN#">
		<!--- Get History --->
        SELECT
        	<!--- Student --->
            s.studentID,
            s.firstName,
            s.familyLastName,
            CAST(CONCAT(s.firstName, ' ', s.familyLastName,  ' ##', s.studentID) AS CHAR) AS studentName,
            <!--- Host History --->
            ht.datePlaced,
            ht.isRelocation,
            ht.isWelcomeFamily,                
            <!--- Program --->
            p.programID,
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
        <!--- Do not include records that are set as not eligible --->
		AND	
        	s.studentID NOT IN ( 
            	SELECT 
                	shr.fk_student 
                FROM 
                	smg_hide_reports shr 
                WHERE 
                	shr.fk_host = ht.hostID 
                AND
                	shr.fk_secondVisitRep = ht.secondVisitRepID
			) 
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
                	pr.fk_secondVisitRep = ht.secondVisitRepID                    
                AND
                	pr.pr_ny_approved_date IS NOT <cfqueryparam cfsqltype="cf_sql_date" null="yes">          
            )
		GROUP BY
        	ht.studentID,
            ht.hostID
        ORDER BY
        	r.regionName,
            s.familyLastName,
            ht.datePlaced DESC
    </cfquery>

</cfsilent>    

<!--- Run Report --->

<table width="90%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
    <tr>
        <th>2<sup>nd</sup> Visit Representative - Relocation Compliance</th>
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
            <th class="left" width="10%">Program</th>
            <th class="left" width="15%">Host Family</th>
            <th class="center" width="11%">Date of Arrival</th>
            <th class="center" width="11%">Date of Relocation</th>
            <th class="center" width="16%">Window of Compliance</th>
            <th class="center" width="11%">Due Date</th>
            <th class="center" width="11%">Days Remaining</th>
        </tr>      
    
        <cfoutput>
    
            <cfscript>
                vDueDate = '';
                vDateOfArrival = '';
                vDateRelocation = '';	
                vSetStartComplianceDate = '';
                vRemainingDays = '';
            
                // Get Arrival to Host Family Flight Information
                vDateOfArrival = APPLICATION.CFC.STUDENT.getFlightInformation(studentID=qGetResults.studentID,flightType="arrival", programID=qGetResults.programID, flightLegOption="firstLeg").dep_date;
                
                if ( VAL(qGetResults.isRelocation) ) {
                    // Relocation - Use relocation date to calculate due date
                    vSetStartComplianceDate = qGetResults.datePlaced;
                    vDateRelocation = qGetResults.datePlaced;
                } else {
                    // Not a relocation - Use arrival date
                    vSetStartComplianceDate = vDateOfArrival;
                }
    
                // Calculate Due Date
                if ( VAL(qGetResults.isWelcomeFamily) AND isDate(vSetStartComplianceDate) ) {
                    // Welcome Family - 30 Days
                    vDueDate = DateAdd('d', 30, vSetStartComplianceDate);
                } else if ( isDate(vSetStartComplianceDate) ) {
                    // Permanent Family - 60 Days
                    vDueDate = DateAdd('d', 60, vSetStartComplianceDate);
                }
    
                if ( isDate(vDueDate) ) {
                    vRemainingDays = DateDiff('d', now(), vDueDate);
                }
            </cfscript>		
                            
            <tr class="#iif(qGetResults.currentRow MOD 2 ,DE("off") ,DE("on") )#">
                <td>#qGetResults.studentName#</td>
                <td>#qGetResults.programName#</td>
                <td>#qGetResults.hostFamilyName# <span style="font-size:9px">(<cfif VAL(qGetResults.isWelcomeFamily)>Welcome<cfelse>Permanent</cfif>)</span></td>
                <td align="center">#DateFormat(vDateOfArrival, 'mm/dd/yy')#</td>
                <td align="center">#DateFormat(vDateRelocation, 'mm/dd/yy')#</td>
                <td align="center">#DateFormat(vSetStartComplianceDate, 'mm/dd/yy')# - #DateFormat(vDueDate, 'mm/dd/yy')#</td>
                <td align="center">#DateFormat(vDueDate, 'mm/dd/yy')#</td>
                <td align="center" <cfif vRemainingDays LT 0> class="alert" </cfif> >#vRemainingDays#</td>
            </tr>
            
        </cfoutput>
    
    </table>

</cfoutput>