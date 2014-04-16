<!--- ------------------------------------------------------------------------- ----
	
	File:		vTotalStudentsdents_per_agent.cfm
	Author:		James Grifitths
	Date:		April 2, 2012
	Desc:		Total Students Per Intl. Rep.

	Updated: 	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
	<cfimport taglib="../extensions/customTags/gui/" prefix="gui" />
	
    <!--- Param FORM Variables --->
    <cfparam name="FORM.seasonID" default="">
    <cfparam name="FORM.startMonth" default="August">
    <cfparam name="FORM.countryID" default="0">   

    <cfscript>
		// Set Program Types
		if ( FORM.startMonth EQ 'january' ) {
			vProgramTypeList = '2,4'; // 12 Month - 2nd Semester
		} else {
			vProgramTypeList = '1,3'; // 10 Month - 1st Semester
		}
		
		// Application Status | Submitted | Received | On Hold | Approved
		vApplicationStatusList = "7,8,10,11";
	</cfscript>
    
    <cfquery name="qGetStudentsReps" datasource="#APPLICATION.DSN#">
    	SELECT s.intRep 
        FROM smg_students s
        INNER JOIN smg_programs ON s.programID = smg_programs.programID
            AND smg_programs.type IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#vProgramTypeList#" list="yes"> )
        INNER JOIN smg_seasons ON smg_programs.seasonID = smg_seasons.seasonID
            AND smg_seasons.seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.seasonID#">  
        WHERE s.active = 1
        AND s.app_current_status IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#vApplicationStatusList#" list="yes"> )
        <cfif VAL(FORM.countryID)>
            AND s.countryresident = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.countryID#">
        </cfif>
        <cfif CLIENT.companyID EQ 5>
            AND s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="0,#APPLICATION.SETTINGS.COMPANYLIST.ISE#" list="yes"> )        
        <cfelse>
            AND s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">        
        </cfif>
    </cfquery>
    
	<!--- Get total students grouped by Agent --->
	<cfquery name="qGetIntlReps" datasource="#APPLICATION.DSN#">
		SELECT DISTINCT
			u.businessname,      
            u.userID,      
            alloc.seasonID AS season,      
            alloc.januaryAllocation,      
            alloc.augustAllocation,
            country.countryName
      	FROM smg_users u
        INNER JOIN user_access_rights uar ON u.userID = uar.userID
              AND uar.userType = 8      
        LEFT OUTER JOIN smg_users_allocation alloc ON alloc.userID = u.userID
             AND alloc.seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.seasonID#">
      	LEFT JOIN smg_countrylist country ON u.country = country.countryID   
        WHERE ( u.userID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#ValueList(qGetStudentsReps.intRep)#">)
      		OR (alloc.januaryAllocation > 0 OR alloc.augustAllocation > 0) )
        GROUP BY u.businessname
		ORDER BY u.businessname
	</cfquery>

    <cfscript>
		// Default Values for Information Heading
		vTotalStudents = 0;
		vTotalRemaining = 0;
		vTotalAllotment = 0;
		vTotalSubmitted = 0;
		vTotalReceived = 0;
		vTotalOnHold = 0;
		vTotalAccepted = 0;
	</cfscript>
    
</cfsilent>

<!--- Page Header --->
<gui:pageHeader
	headerType="applicationNoHeader"
/>

<cfoutput>

	<table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
        <tr>
            <th>#CLIENT.companyshort# - Total of Active Students Per International Representatives</th>            
        </tr>
        <tr>
            <td class="center">
                Total of #qGetIntlReps.recordcount# International Representatives
            </td>
        </tr>
        <tr>
        	<td class="center">
                Season: #qGetIntlReps.season# - #FORM.startMonth# Start
            </td>
        </tr>
    </table>
    
    <!--- 0 students will skip the table --->
    <cfif qGetIntlReps.recordcount>
        
        <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
            <tr>
                <th class="left" width="25%">International Representative</th>
                <th class="left" width="19%">Country</td>
                <th class="center" width="8%">Submitted</th>
                <th class="center" width="8%">Received</th>
                <th class="center" width="8%">On Hold</th>
                <th class="center" width="8%">Approved</th>
                <th class="center" width="8%">Total Apps</th>
                <th class="center" width="8%">Allotment</th>
                <th class="center" width="8%">Remaining Spots</th>
            </tr>
            
            <!--- Representative Loop --->
        	<cfloop query="qGetIntlReps">
            	
                <cfscript>
					vTotalApps = 0;
				</cfscript>
                
                <tr class="#iif(currentrow MOD 2 ,DE("off") ,DE("on") )#">
                	<td>#qGetIntlReps.businessname#</td>
                    <td>#qGetIntlReps.countryName#</td>
                    
                    <!--- Inner Loop for Submitted, Received, On Hold, and Accepted --->
                    <cfloop list='#vApplicationStatusList#' index="i">
                    
                        <cfquery name="qGetTotalApps" datasource="#APPLICATION.DSN#">
                            SELECT
                                COUNT(s.studentID) AS totalStudents,
                                studentID                                
                            FROM 
                                smg_students s
                            INNER JOIN 
                                smg_programs p ON s.programID = p.programID
                                    AND
                                        p.type IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#vProgramTypeList#" list="yes"> )
                                    AND
                                        p.seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.seasonID#">
                            WHERE 
                                s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                            AND
                                s.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetIntlReps.userid#">
                            AND 
                                s.app_current_status = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
                           	
                            <!--- Apps that are not approved have no companyID ( = 0 ) --->                  
							<cfif CLIENT.companyID EQ 5>
                                AND
                                    s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="0,5,#APPLICATION.SETTINGS.COMPANYLIST.ISE#" list="yes"> )        
                            <cfelse>
                                AND
                                    s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">        
                            </cfif>        
                            
                            <cfif VAL(FORM.countryID)>
                                AND 
                                    s.countryresident = ( <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.countryID#" list="yes"> )
                            </cfif>
                            
                        </cfquery>
                        
                        <cfset vTotalApps += qGetTotalApps.totalStudents>
                        
                        <cfif i EQ 7>
                        	<cfset vTotalSubmitted += qGetTotalApps.totalStudents>
                        <cfelseif i EQ 8>
                        	<cfset vTotalReceived += qGetTotalApps.totalStudents>
                        <cfelseif i EQ 10>
                        	<cfset vTotalOnHold += qGetTotalApps.totalStudents>
                        <cfelseif i EQ 11>
                        	<cfset vTotalAccepted += qGetTotalApps.totalStudents>
                        </cfif>
                        
                        <td class="center">#qGetTotalApps.totalStudents#</td>
                    </cfloop>
                    
                    <cfset vTotalStudents += vTotalApps>
                    
                    <td class="center">#vTotalApps#</td>
                    
					<cfscript>
						// Default Value for Remaining
						vSetRemaining = "-";
						
                        // Display appropriate allotment and calculate remaining
                        if ( FORM.startMonth EQ "january" ) {
                            // January
                            vSetAllotment = qGetIntlReps.januaryAllocation;
                        } else { 
                            // August
                            vSetAllotment = qGetIntlReps.augustAllocation;
                        }
                    </cfscript>
                    
					<cfif VAL(vSetAllotment)>

						<cfscript>
							vSetColorCode = '';
							
							vSetRemaining = vSetAllotment - vTotalApps;
							vTotalRemaining += vSetRemaining;
                            vTotalAllotment += vSetAllotment;
							
                            // Set up Remaining Days Alert
                            if ( IsNumeric(vSetRemaining) AND vSetRemaining LTE 0 ) {
                                vSetColorCode = '##FF0000';
                            } else if ( IsNumeric(vSetRemaining) AND vSetRemaining LTE 10 ) {
                                vSetColorCode = '##FFFF00';
                            }
                        </cfscript>

                        <td class="center">#vSetAllotment#</td>
                        <td class="center" bgcolor="#vSetColorCode#">#vSetRemaining#</td>
                         
                    <cfelse>
                    
                        <td class="center">-</td>
                        <td class="center">-</td>
                        
                    </cfif>

                </tr>
        	</cfloop>
            
			<!--- Display Report Total --->            
            <tr>
            	<th class="left">Total Students</th>
                <th>&nbsp;</th>
                <th class="center">#vTotalSubmitted#</th>
                <th class="center">#vTotalReceived#</th>
                <th class="center">#vTotalOnHold#</th>
                <th class="center">#vTotalAccepted#</th>
                <th class="center">#vTotalStudents#</th>
                <th class="center">#vTotalAllotment#</th>
                <th class="center">#vTotalRemaining#</th>
          	</tr>
     	</table>
    </cfif>

</cfoutput>