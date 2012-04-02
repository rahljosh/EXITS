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
	</cfscript>
    
	<!--- Get total students grouped by Agent --->
	<cfquery name="qGetIntlReps" datasource="#APPLICATION.DSN#">
		SELECT DISTINCT
			count(s.studentid) AS get_vTotalStudentsdents,
			c.countryname,
			u.businessname,
			u.userID,
			sea.season,
            p.programName,
			country.countryName,
            sua.januaryAllocation,
            sua.augustAllocation
		FROM 	
			smg_students s
		INNER JOIN 
			smg_countrylist c ON s.countryresident = c.countryID
		INNER JOIN 
			smg_users u ON u.userid = s.intrep
		INNER JOIN 
			smg_programs p ON s.programID = p.programID
           		AND
                	p.type IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#vProgramTypeList#" list="yes"> )
		INNER JOIN 
			smg_seasons sea ON p.seasonID = sea.seasonID
				AND
					sea.seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.seasonID#">            
		LEFT JOIN 
			smg_countrylist country ON u.country = country.countryID   
        LEFT OUTER JOIN
        	smg_users_allocation sua ON sua.userID = u.userID
            	AND
                	sua.seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.seasonID#">
		WHERE
            s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
			
		<cfif VAL(FORM.countryID)>
			AND 
				s.countryresident = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.countryID#">
		</cfif>
		
		<!--- Filter for Case, WEP, Canada and ESI --->
        <cfif ListFind(APPLICATION.SETTINGS.COMPANYLIST.NonISE, CLIENT.companyID)>
            AND 
                s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        <cfelse>
            AND
                s.companyID NOT IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.NonISE#" list="yes"> )
        </cfif>	
		  
		GROUP BY 
			u.businessname
		ORDER BY 
			u.businessname
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
            	<cfset vTotalApps=0>
                
                <tr class="#iif(currentrow MOD 2 ,DE("off") ,DE("on") )#">
                	<td>#qGetIntlReps.businessname#</td>
                    <td>#qGetIntlReps.countryName#</td>
                    
                    <!--- Inner Loop for Submitted, Received, On Hold, and Accepted --->
                    <cfloop list = '7,8,10,11' index="i">
                    
                        <cfquery name="qGetTotalApps" datasource="#APPLICATION.DSN#">
                            SELECT
                                COUNT(s.studentID) AS count
                            FROM 
                                smg_students s
                            INNER JOIN 
                                smg_programs p ON s.programID = p.programID
                                    AND
                                        p.type IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#vProgramTypeList#" list="yes"> )
                                    AND
                                        p.seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.seasonID#">
                            WHERE 
                                <!--- RANDID = TO IDENTIFY ONLINE APPS --->
                                s.randid != <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                            AND 
                                s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                            AND
                                s.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetIntlReps.userid#">
                            AND 
                                s.app_current_status = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
                                                
                            <!--- Filter for Case, WEP, Canada and ESI --->
                            <cfif ListFind(APPLICATION.SETTINGS.COMPANYLIST.NonISE, CLIENT.companyID)>
                                AND 
                                    s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
                            <cfelse>
                                AND
                                    s.companyID NOT IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.NonISE#" list="yes"> )
                            </cfif>	
                            
                            <cfif VAL(FORM.countryID)>
                                AND 
                                    s.countryresident = ( <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.countryID#" list="yes"> )
                            </cfif>
                            
                        </cfquery>
                        
                        <cfset vTotalApps += qGetTotalApps.count>
                        
                        <cfif i EQ 7>
                        	<cfset vTotalSubmitted += qGetTotalApps.count>
                        <cfelseif i EQ 8>
                        	<cfset vTotalReceived += qGetTotalApps.count>
                        <cfelseif i EQ 10>
                        	<cfset vTotalOnHold += qGetTotalApps.count>
                        <cfelseif i EQ 11>
                        	<cfset vTotalAccepted += qGetTotalApps.count>
                        </cfif>
                        
                        <td class="center">#qGetTotalApps.count#</td>
                    </cfloop>
                    
                    <cfset vTotalStudents += qGetTotalApps.count>
                    
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
							
							vSetRemaining = vSetAllotment - vTotalStudents;
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