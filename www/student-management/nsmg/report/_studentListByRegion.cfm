<!--- ------------------------------------------------------------------------- ----
	
	File:		_studentsByRegion.cfm
	Author:		Marcus Melo
	Date:		April 19, 2012
	Desc:		Student By Region- Placed/Unplaced
				
				#CGI.SCRIPT_NAME#?curdoc=report/index?action=studentsByRegion
				
	Updated: 				
				
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
    <cfsetting requesttimeout="9999">
    
	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
	
    <cfscript>	
		// Param FORM Variables
		param name="FORM.programID" default=0;	
		param name="FORM.regionID" default=0;
		param name="FORM.studentStatus" default="Active";
		param name="FORM.placementStatus" default="Placed";
		param name="FORM.dateFrom" default="";
		param name="FORM.dateTo" default="";
		param name="FORM.reportBy" default="placeRepID";
		param name="FORM.outputType" default="onScreen";

		// Get Programs
		qGetPrograms = APPLICATION.CFC.PROGRAM.getPrograms(programIDList=FORM.programID);
	</cfscript>	

    <cfquery name="qGetResults" datasource="#APPLICATION.DSN#">
        SELECT 
            s.studentID,
            s.firstName,
            s.familyLastName,
            CAST(CONCAT(s.firstName, ' ', s.familyLastName,  ' ##', s.studentID) AS CHAR) AS studentName,
            s.sex,
            s.active,
            s.cancelDate,
            s.host_fam_approved,
            sh.hostID,
            sh.schoolID,
            sh.placeRepID,
            sh.areaRepID,
            sh.isRelocation,
            sh.isWelcomeFamily,
            sh.datePlaced,
            sh.isActive AS isActivePlacement,
            <!--- Program --->
            p.programName,
            <!--- Region --->
            r.regionID,
            r.regionName,
            <!--- Country --->
            c.countryName,
            <!--- Host Family --->            
            h.familyLastName as hostFamilyLastName,
            CONCAT(h.city, ' ', h.state) AS hostAddress,
            h.city AS hostCity,
            h.state AS hostState,
            h.phone AS hostPhone,
            <!--- School --->
            ss.schoolName,
            <!--- Facilitator --->
            CONCAT(fac.firstName, ' ', fac.lastName) AS facilitatorName,
			<!--- Placing / Supervising Representative --->
            u.userID repID,
            u.email as repEmail,
            CONCAT(u.firstName, ' ', u.lastName) AS repName
        FROM 
            smg_students s
        INNER JOIN
            smg_programs p on p.programID = s.programID
        INNER JOIN
            smg_regions r ON r.regionID = s.regionAssigned
                AND	
                    r.regionID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionID#" list="yes"> )
		INNER JOIN 
        	smg_countrylist c ON s.countryresident = countryid                
        LEFT OUTER JOIN	
        	smg_hostHistory sh ON sh.studentID = s.studentID
            	AND
                	isActive = <cfqueryparam cfsqltype="cf_sql_bit" value="1">   
        LEFT OUTER JOIN 
            smg_hosts h ON h.hostID = sh.hostID
        LEFT OUTER JOIN 
            smg_schools ss ON ss.schoolID = sh.schoolID
		LEFT OUTER JOIN 
        	smg_users fac ON r.regionFacilitator = fac.userID            
        LEFT OUTER JOIN 
            smg_users u ON sh.#FORM.reportBy# = u.userID
        WHERE 
            s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> ) 
        
        <!--- Student Status --->
        <cfswitch expression="#FORM.studentStatus#">
        	
        	<cfcase value="Active">
				AND
                	s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">                            
            </cfcase>
			
        	<cfcase value="Inactive">
				AND
                	s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="0"> 
				AND
                	s.cancelDate IS <cfqueryparam cfsqltype="cf_sql_date" null="yes">                                               
            </cfcase>

        	<cfcase value="Canceled">
				AND
                	s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="0"> 
				AND
                	s.cancelDate IS NOT <cfqueryparam cfsqltype="cf_sql_date" null="yes">                                               
            </cfcase>
        
        </cfswitch>
		
        <!--- Placement Status --->
        <cfswitch expression="#FORM.placementStatus#">
        	
        	<cfcase value="Placed">
				AND
                	s.hostID != <cfqueryparam cfsqltype="cf_sql_bit" value="0">                            
                AND 
                    s.host_fam_approved IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4" list="yes"> )	
            	
                <cfif isDate(FORM.dateFrom) AND isDate(FORM.dateTo)>
                	AND
                    	sh.datePlaced 
                    BETWEEN 
                    	<cfqueryparam cfsqltype="cf_sql_date" value="#FORM.dateFrom#">
                    AND
                    	<cfqueryparam cfsqltype="cf_sql_date" value="#FORM.dateTo#">
                </cfif>
                
            </cfcase>
			
        	<cfcase value="Unplaced">
				AND
                	s.hostID = <cfqueryparam cfsqltype="cf_sql_bit" value="0">                            
            </cfcase>

        	<cfcase value="Pending">
				AND
                	s.hostID != <cfqueryparam cfsqltype="cf_sql_bit" value="0">                            
                AND 
                    s.host_fam_approved IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="5,6,7" list="yes"> )	
            </cfcase>
        
        </cfswitch>
        
        ORDER BY   
		    repName,          
          	studentName
	</cfquery>
    
</cfsilent>

<!--- Page Header --->
<gui:pageHeader
	headerType="applicationNoHeader"
/>	

<cfoutput>

	<!--- Report Header Information --->
    <cfsavecontent variable="reportHeader">
    
        <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
            <tr>
                <th>Student Management - Student List By Region</th>            
            </tr>
            <tr>
                <td class="center">
                    <strong>Program(s) included in this report: </strong> <br />
                    <cfloop query="qGetPrograms">
                        #qGetPrograms.programName# <br />
                    </cfloop>
                    
                    <strong>Student Status:</strong> #FORM.studentStatus# <br />
                    <strong>Placement Status:</strong> #FORM.placementStatus# <br />
                    
                    <cfif FORM.placementStatus EQ 'Placed' AND ( isDate(FORM.dateFrom) OR isDate(FORM.dateTo) )>
                        <strong>Placed from</strong> #FORM.dateFrom# <strong>to</strong> #FORM.dateTo#
                    </cfif>
                </td>
            </tr>
        </table>
    
    </cfsavecontent>
    
    <cfif NOT LEN(FORM.programID) OR NOT LEN(FORM.regionID)>
        
        <!--- Include Report Header --->
        #reportHeader#
        
        <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
            <tr class="on">
                <td class="subTitleCenter">
                    <p>You must select Program and Region information. Please close this window and try again.</p>
                    <p><a href="javascript:window.close();" title="Close Window"><img src="../pics/close.gif" /></a></p>
                </td>
            </tr>      
        </table>
        <cfabort>
    </cfif>

</cfoutput>

<!--- Output in Excel - Do not use GroupBy --->
<cfif FORM.outputType EQ 'excel'>
	
	<!--- set content type --->
	<cfcontent type="application/msexcel">
	
	<!--- suggest default name for XLS file --->
	<cfheader name="Content-Disposition" value="attachment; filename=studentListByRegion.xls"> 
    
    <table width="98%" cellpadding="4" cellspacing="0" align="center" border="1">
        <tr>
            <th colspan="16">Student Management - Student List By Region</th>            
        </tr>
        <tr style="font-weight:bold;">
            <td>Region</td>
            <td>Facilitator</td>
            <td>
				<cfif FORM.reportBy EQ 'placeRepID'>
                    Placing Representative
                <cfelseif FORM.reportBy EQ 'areaRepID'>
                    Supervising Representative
                </cfif>
            </td>
            <td>Student ID</td>
            <td>Student First Name</td>
            <td>Student Last Name</td>
            <td>Student Status</td>
            <td>Gender</td>
            <td>Country</td>
            <td>Program</td>
            <td>Host Family</td>
            <td>Host Phone</td>
            <td>Host City</td>
            <td>Host State</td>
            <td>School</td>
            <td>Date Placed</td>
        </tr>      
		
		<cfoutput query="qGetResults">
			
            <cfscript>
				// Set Row Color
				if ( qGetResults.currentRow MOD 2 ) {
					vRowColor = 'bgcolor="##E6E6E6"';
				} else {
					vRowColor = 'bgcolor="##FFFFFF"';
				}
            </cfscript>
        
            <tr>
                <td #vRowColor#>#qGetResults.regionName#</td>
                <td #vRowColor#>#qGetResults.facilitatorName#</td>
                <td #vRowColor#>#qGetResults.repName#</td>
                <td #vRowColor#>#qGetResults.studentID#</td>
                <td #vRowColor#>#qGetResults.firstName#</td>
                <td #vRowColor#>#qGetResults.familyLastName#</td>
                <td #vRowColor#>
                    <cfif VAL(qGetResults.active)>
                        <span class="note">Active</span>
                    <cfelseif isDate(qGetResults.cancelDate)>
                        <span class="noteAlert">Cancelled</span>
					<cfelse>
                        <span class="noteAlert">Inactive</span>
                    </cfif>
                </td>
                <td #vRowColor#>#qGetResults.sex#</td>
                <td #vRowColor#>#qGetResults.countryName#</td>
                <td #vRowColor#>#qGetResults.programName#</td>
                <td #vRowColor#>
                	<cfif VAL(qGetResults.hostID)>
                        #qGetResults.hostFamilyLastName#
    
                        <span class="note">
                            (
                                <cfif VAL(qGetResults.isWelcomeFamily)>
                                    Welcome
                                <cfelse>
                                    Permanent
                                </cfif>
                                -
                                <cfif VAL(qGetResults.isActivePlacement)>
                                    Current
                                <cfelse>
                                    Previous
                                </cfif>
    
                                <cfif VAL(qGetResults.isRelocation)>
                                    - Relocation
                                </cfif>
                            )
                        </span>         
					</cfif>                                         
                </td>
                <td #vRowColor#>#qGetResults.hostPhone#</td>
                <td #vRowColor#>#qGetResults.hostCity#</td>
                <td #vRowColor#>#qGetResults.hostState#</td>
                <td #vRowColor#>
                    <cfif VAL(qGetResults.schoolID)>
                        #qGetResults.schoolName# ###qGetResults.schoolID#
                    </cfif>
                </td>
                <td #vRowColor#>
                    <cfif listFind("1,2,3,4", qGetResults.host_fam_approved)>
                        #DateFormat(qGetResults.datePlaced, 'mm/dd/yy')#
                    <cfelseif VAL(qGetResults.hostID) AND listFind("5,6,7", qGetResults.host_fam_approved) >
                        Pending
                    <cfelse>
                        n/a
                    </cfif>
                </td>
            </tr>
    	</cfoutput>

	</table>

<!--- On Screen Report --->
<cfelse>

	<cfoutput>
        
        <!--- Include Report Header --->   
		#reportHeader#
        
        <!--- No Records Found --->
        <cfif NOT VAL(qGetResults.recordCount)>
            <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                <tr class="on">
                	<td class="subTitleCenter">No records found</td>
                </tr>      
            </table>
        	<cfabort>
        </cfif>
        
    </cfoutput>
	
    <!--- Loop Regions ---> 
    <cfloop list="#FORM.regionID#" index="currentRegionID">

		<cfscript>
            // Get Regional Manager
            qGetRegionalManager = APPLICATION.CFC.USER.getRegionalManager(regionID=currentRegionID);
        </cfscript>

        <cfquery name="qGetStudentsInRegion" dbtype="query">
            SELECT
                *
            FROM
                qGetResults
            WHERE
                regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#currentRegionID#">               
        </cfquery>
        
        <cfif qGetStudentsInRegion.recordCount>
        
			<cfoutput>
                
                <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable" <cfif ListGetAt(FORM.regionID, 1) NEQ currentRegionID>style="margin-top:30px;"</cfif>>
                    <tr>
                        <th class="left">
                            #qGetStudentsInRegion.regionName#
                            &nbsp; - &nbsp; 
                            Facilitator - #qGetStudentsInRegion.facilitatorName#
                        </th>
                        <th class="right note">
                        	Total of #qGetStudentsInRegion.recordCount# records
                        </th>
                    </tr>      
                </table>
            
            </cfoutput>
        
        </cfif>
        
        <cfoutput query="qGetStudentsInRegion" group="#FORM.reportBy#">

            <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                <tr>
                    <th class="left" colspan="9">
                        <cfif FORM.reportBy EQ 'placeRepID'>
                            Placing
                        <cfelseif FORM.reportBy EQ 'areaRepID'>
                            Supervising
                        </cfif>
                        Representative #qGetStudentsInRegion.repName#
                    </th>
                </tr>      
                <tr class="on">
                    <td class="subTitleLeft" width="15%">Student</td>
                    <td class="subTitleLeft" width="6%">Gender</td>
                    <td class="subTitleLeft" width="8%">Country</td>
                    <td class="subTitleLeft" width="10%">Program</td>
                    <td class="subTitleLeft" width="15%">Host Family</td>
                    <td class="subTitleLeft" width="8%">HF Phone</td>
                    <td class="subTitleLeft" width="15%">HF City / State</td>
                    <td class="subTitleLeft" width="15%">School</td>
                    <td class="subTitleCenter" width="8%">Date Placed</td>
                </tr>      
                
                <cfscript>
                    // Set Current Row
                    vCurrentRow = 0;			
                </cfscript>
                
                <!--- Loop Through Query --->
                <cfoutput>

					<cfscript>
                        // Set Current Row
                        vCurrentRow ++;			
                    </cfscript>
                    
                    <tr class="#iif(vCurrentRow MOD 2 ,DE("off") ,DE("on") )#">
                        <td>
                            #qGetStudentsInRegion.studentName#
                            <cfif VAL(qGetStudentsInRegion.active)>
                                <span class="note">(Active)</span>
                            <cfelseif isDate(qGetStudentsInRegion.cancelDate)>
                                <span class="noteAlert">(Cancelled)</span>
                            <cfelse>
								<span class="noteAlert">Inactive</span>
							</cfif>
                        </td>
                        <td>#qGetStudentsInRegion.sex#</td>
                        <td>#qGetStudentsInRegion.countryName#</td>
                        <td>#qGetStudentsInRegion.programName#</td>
                        <td>
                        	<cfif VAL(qGetStudentsInRegion.hostID)>
                                #qGetStudentsInRegion.hostFamilyLastName# ###qGetStudentsInRegion.hostID#
                                
                                <span class="note">
                                    (
                                        <cfif VAL(qGetStudentsInRegion.isWelcomeFamily)>
                                            Welcome
                                        <cfelse>
                                            Permanent
                                        </cfif>
                                        -
                                        <cfif VAL(qGetStudentsInRegion.isActivePlacement)>
                                            Current
                                        <cfelse>
                                            Previous
                                        </cfif>
    
                                        <cfif VAL(qGetStudentsInRegion.isRelocation)>
                                            - Relocation
                                        </cfif>
                                        
                                    )
                                </span> 
							</cfif>                                                         
                        </td>
                        <td>#qGetStudentsInRegion.hostPhone#</td>
                        <td>#qGetStudentsInRegion.hostAddress#</td>
                        <td>
                        	<cfif VAL(qGetStudentsInRegion.schoolID)>
	                            #qGetStudentsInRegion.schoolName# ###qGetStudentsInRegion.schoolID#
                            </cfif>
                        </td>
                        <td class="center">
                        	<cfif listFind("1,2,3,4", qGetStudentsInRegion.host_fam_approved)>
                            	#DateFormat(qGetStudentsInRegion.datePlaced, 'mm/dd/yy')#
                            <cfelseif VAL(qGetStudentsInRegion.hostID) AND listFind("5,6,7", qGetStudentsInRegion.host_fam_approved) >
                            	Pending
                            <cfelse>
                            	n/a
                            </cfif>
                        </td>
                    </tr>
    
                </cfoutput>
            
            </table>
    
        </cfoutput>

	</cfloop>

</cfif>

<!--- Page Header --->
<gui:pageFooter />	