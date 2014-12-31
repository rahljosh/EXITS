<!--- ------------------------------------------------------------------------- ----
	
	File:		doublePlacementPaperworkByRegion.cfm
	Author:		Marcus Melo
	Date:		March 12, 2012
	Desc:		Double Placement Paperwork by Region

	Updated: 	03/12/2012 - Adding email to Intl. Rep. option

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
	
    <cfscript>	
		// Param FORM Variables
		param name="FORM.programID" default=0;	
		param name="FORM.regionID" default="";
		param name="FORM.compliantOption" default="";
		param name="FORM.reportBy" default="placeRepID";
		param name="FORM.outputType" default="onScreen";
		param name="FORM.sendEmail" default=0;	

		// Get Programs
		qGetPrograms = APPLICATION.CFC.PROGRAM.getPrograms(programIDList=FORM.programID);
	</cfscript>	

    <cfquery name="qGetResults" datasource="#APPLICATION.DSN#">
        SELECT 
            s.studentID,
            s.firstName,
            s.familyLastName,
            CAST(CONCAT(s.firstName, ' ', s.familyLastName,  ' ##', s.studentID) AS CHAR) AS studentName,
            s.active,
            s.cancelDate,
            sh.placeRepID,
            sh.areaRepID,
            sh.isRelocation,
            sh.isWelcomeFamily,
            sh.datePlaced,
            sh.isActive AS isActivePlacement,
            IF ( sh.doublePlacementID = sht.fieldID, 1, 0 ) AS isActiveDoublePlacement,
            sht.doublePlacementHostFamilyDateSigned,
            sht.doublePlacementStudentDateSigned,
            sht.doublePlacementHostFamilyDateSigned,
            <!--- Double Placement --->
            CAST(CONCAT(dp.firstName, ' ', dp.familyLastName,  ' ##', dp.studentID) AS CHAR) AS doublePlacementStudentName,
            <!--- Program --->
            p.programName,
            <!--- Host Family --->
            h.hostID,             
            h.familyLastName as hostFamilyLastName,
            <!--- Region --->
            r.regionID,
            r.regionName,
            <!--- Facilitator --->
            CONCAT(fac.firstName, ' ', fac.lastName) AS facilitatorName,
			<!--- Placing / Supervising --->
            u.userID repID,
            u.email as repEmail,
            CONCAT(u.firstName, ' ', u.lastName) AS repName
        FROM 
            smg_students s
        INNER JOIN
            smg_hosthistory sh ON sh.studentID = s.studentID
        INNER JOIN
            smg_hosthistorytracking sht ON sht.historyID = sh.historyID
                AND
                    sht.fieldName = <cfqueryparam cfsqltype="cf_sql_varchar" value="doublePlacementID"> 
                AND
                    sht.isDoublePlacementPaperworkRequired IN ( <cfqueryparam cfsqltype="cf_sql_date" null="yes">, <cfqueryparam cfsqltype="cf_sql_bit" value="1"> )
                <!--- Get Missing --->
                <cfif FORM.compliantOption EQ 'missing'>
                    AND 
                        (
                        	sht.doublePlacementHostFamilyDateSigned IS <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                        OR
                            (
                                sh.isRelocation = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                            AND
                                sht.doublePlacementStudentDateSigned IS <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                            )
						)                            
                <!--- Get Non-compliant --->
				<cfelseif FORM.compliantOption EQ 'non-compliant'>
                    AND 
                        (
                            
                            (
                            	sht.doublePlacementHostFamilyDateSigned IS <cfqueryparam cfsqltype="cf_sql_date" null="yes">
							OR
                            	sht.doublePlacementHostFamilyDateSigned > sh.datePlaced
                            )
                            
						OR                            
                            (
                                sh.isRelocation = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                            AND
                                (
                                	sht.doublePlacementStudentDateSigned IS <cfqueryparam cfsqltype="cf_sql_date" null="yes">
								OR
                                    sht.doublePlacementStudentDateSigned > sh.datePlaced
								)
                            )
                            
						)                            
				</cfif>                    
		INNER JOIN
			smg_students dp ON dp.studentID = sht.fieldID
        INNER JOIN
            smg_programs p on p.programid = s.programid
        INNER JOIN
            smg_hosts h ON h.hostID = sh.hostID
        INNER JOIN
            smg_regions r ON r.regionID = s.regionAssigned
		LEFT OUTER JOIN 
        	smg_users fac ON r.regionFacilitator = fac.userID            
        LEFT OUTER JOIN 
            smg_users u ON sh.#FORM.reportBy# = u.userID
        WHERE 
            s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> ) 
        AND 
            s.host_fam_approved <= <cfqueryparam cfsqltype="cf_sql_integer" value="4">	
        AND
            s.regionAssigned IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionID#" list="yes"> ) 
        ORDER BY   
		    repName,          
          	studentName,
          	sht.dateCreated DESC            
    </cfquery>
    
</cfsilent>

<!--- Page Header --->
<gui:pageHeader
	headerType="applicationNoHeader"
/>	

<!--- Run Report --->

<cfif NOT VAL(FORM.programid) OR NOT LEN(FORM.regionID)>
	<table width="100%" cellpadding="4" cellspacing="0" align="center" frame="box">
		<tr><td align="center">
				<h1>Sorry, It was not possible to proccess you request at this time due the program information was not found.<br>
				Please close this window and be sure you select at least one program from the programs list before you run the report.</h1>
				<center><input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()"></center>
			</td>
		</tr>
	</table>
	<cfabort>
</cfif>

<!--- Output in Excel - Do not use GroupBy --->
<cfif FORM.outputType EQ 'excel'>
	
	<!--- set content type --->
	<cfcontent type="application/msexcel">
	
	<!--- suggest default name for XLS file --->
	<cfheader name="Content-Disposition" value="attachment; filename=DOS-Double-Placement-Paperwork-By-Intl-Rep.xls"> 
    
    <table width="98%" cellpadding="4" cellspacing="0" align="center" border="1">
        <tr>
            <th colspan="12">Placement Reports - Double Placement Paperwork by Region</th>            
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
            <td>Program</td>
            <td>Host Family</td>
            <td>Double Placement</td>
            <td>Date Placed</td>
            <td>Missing Documents</td>
        </tr>      
		
		<cfoutput query="qGetResults">
        
			<cfscript>
                // Set Variable to Handle Missing Documents
                vMissingDocumentsMessage = '';
                vOutOfComplianceDocuments = '';
                vIsCompliant = 0;
                
				// Display Missing
				if ( FORM.compliantOption EQ 'missing' ) {
				
					// Host Family Date Signed
					if ( NOT isDate(qGetResults.doublePlacementHostFamilyDateSigned) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Missing Host Family Date Signed <br />", " <br />");
					} 
					
					// Student Date Signed
					if ( VAL(qGetResults.isRelocation) AND NOT isDate(qGetResults.doublePlacementStudentDateSigned) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Missing Student Date Signed <br />", " <br />");
					} 
					
				// Display Both
				} else { 
				
					// Host Family Date Signed
					if ( NOT isDate(qGetResults.doublePlacementHostFamilyDateSigned) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Missing Host Family Date Signed <br />", " <br />");
					} else if ( isDate(qGetResults.doublePlacementHostFamilyDateSigned) AND qGetResults.doublePlacementHostFamilyDateSigned GT qGetResults.datePlaced ) {
						vOutOfComplianceDocuments = ListAppend(vOutOfComplianceDocuments, "Host Family Date Signed is Non-compliant <br />", " <br />");
					}
					
					// Student Date Signed
					if ( VAL(qGetResults.isRelocation) AND NOT isDate(qGetResults.doublePlacementStudentDateSigned) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Missing Student Date Signed <br />", " <br />");
					} else if ( VAL(qGetResults.isRelocation) AND isDate(qGetResults.doublePlacementStudentDateSigned) AND qGetResults.doublePlacementStudentDateSigned GT qGetResults.datePlaced ) {
						vOutOfComplianceDocuments = ListAppend(vOutOfComplianceDocuments, "Student Date Signed is Non-compliant <br />", " <br />");
					}
					
				}
		
                // Check if is compliant
                if ( NOT LEN(vMissingDocumentsMessage) AND NOT LEN(vOutOfComplianceDocuments) ) {
                    vIsCompliant = 1;
                }
				
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
                    </cfif>
                </td>
                <td #vRowColor#>#qGetResults.programName#</td>
                <td #vRowColor#>
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
                </td>
                <td #vRowColor#>
                    #qGetResults.doublePlacementStudentName#
                    <cfif VAL(qGetResults.isActivePlacement) AND VAL(qGetResults.isActiveDoublePlacement)>
                        <span class="note">(Current)</span>
                    <cfelse>
                        <span class="note">(Previous)</span>
                    </cfif>
                </td>
                <td #vRowColor#>#DateFormat(qGetResults.datePlaced, 'mm/dd/yy')#</td>
                <td #vRowColor#>
                    <cfif VAL(vIsCompliant)>
                        compliant
                    <cfelse>
                        #vMissingDocumentsMessage#
                        
                        #vOutOfComplianceDocuments#
                    </cfif>
                </td>
            </tr>
       
    	</cfoutput>

	</table>

<!--- On Screen Report --->
<cfelse>

	<cfoutput>
    
        <!--- Store Report Header in a Variable --->
        <cfsavecontent variable="reportHeader">
            
            <!--- Run Report --->
            <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                <tr>
                    <th>Placement Reports - Double Placement Paperwork by Region</th>            
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
    
    </cfoutput>
	
    <!--- Loop Regions ---> 
    <cfloop list="#FORM.regionID#" index="currentRegionID">

       	<!--- Save Report in a Variable --->
        <cfsavecontent variable="reportBody">
    
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
			
            <cfoutput>
                     
                <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                    <tr>
                        <th class="left">
                            #qGetStudentsInRegion.regionName#
                            &nbsp; - &nbsp; 
                            Facilitator - #qGetStudentsInRegion.facilitatorName#
                        </th>
                    </tr>      
                </table>
            
            </cfoutput>
            
        	<cfoutput query="qGetStudentsInRegion" group="#FORM.reportBy#">

                <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                    <tr>
                        <th class="left" colspan="7">
                            <cfif FORM.reportBy EQ 'placeRepID'>
                            	Placing
                            <cfelseif FORM.reportBy EQ 'areaRepID'>
                            	Supervising
                            </cfif>
                            Representative #qGetStudentsInRegion.repName#
                        </th>
                    </tr>      
                    <tr class="on">
                        <td class="subTitleLeft" width="20%">Student</td>
                        <td class="subTitleLeft" width="10%">Program</td>
                        <td class="subTitleLeft" width="15%">Host Family</td>
                        <td class="subTitleLeft" width="20%">Double Placement</td>
                        <td class="subTitleCenter" width="10%">Date Placed</td>
                        <td class="subTitleLeft" width="25%">Missing Documents</td>
                    </tr>      
                    
                    <cfscript>
                        // Set Current Row
                        vCurrentRow = 0;			
                    </cfscript>
                    
                    <!--- Loop Through Query --->
                    <cfoutput>
                        
                        <cfscript>
                            // Increase Current Row
                            vCurrentRow ++;
                            
                            // Set Variable to Handle Missing Documents
                            vMissingDocumentsMessage = '';
                            vOutOfComplianceDocuments = '';
                            vIsCompliant = 0;
    
							// Display Missing
							if ( FORM.compliantOption EQ 'missing' ) {
							
								// Host Family Date Signed
								if ( NOT isDate(qGetStudentsInRegion.doublePlacementHostFamilyDateSigned) ) {
									vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Missing Host Family Date Signed <br />", " <br />");
								} 
								
								// Student Date Signed
								if ( VAL(qGetStudentsInRegion.isRelocation) AND NOT isDate(qGetStudentsInRegion.doublePlacementStudentDateSigned) ) {
									vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Missing Student Date Signed <br />", " <br />");
								} 
								
							// Display Both
							} else { 
							
								// Host Family Date Signed
								if ( NOT isDate(qGetStudentsInRegion.doublePlacementHostFamilyDateSigned) ) {
									vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Missing Host Family Date Signed <br />", " <br />");
								} else if ( isDate(qGetStudentsInRegion.doublePlacementHostFamilyDateSigned) AND qGetStudentsInRegion.doublePlacementHostFamilyDateSigned GT qGetStudentsInRegion.datePlaced ) {
									vOutOfComplianceDocuments = ListAppend(vOutOfComplianceDocuments, "Host Family Date Signed is Non-compliant <br />", " <br />");
								}
								
								// Student Date Signed
								if ( VAL(qGetStudentsInRegion.isRelocation) AND NOT isDate(qGetStudentsInRegion.doublePlacementStudentDateSigned) ) {
									vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Missing Student Date Signed <br />", " <br />");
								} else if ( VAL(qGetStudentsInRegion.isRelocation) AND isDate(qGetStudentsInRegion.doublePlacementStudentDateSigned) AND qGetStudentsInRegion.doublePlacementStudentDateSigned GT qGetStudentsInRegion.datePlaced ) {
									vOutOfComplianceDocuments = ListAppend(vOutOfComplianceDocuments, "Student Date Signed is Non-compliant <br />", " <br />");
								}
								
							}
    
                            // Check if is compliant
                            if ( NOT LEN(vMissingDocumentsMessage) AND NOT LEN(vOutOfComplianceDocuments) ) {
                                vIsCompliant = 1;
                            }
                        </cfscript>
                        
                        <tr class="#iif(vCurrentRow MOD 2 ,DE("off") ,DE("on") )#">
                            <td>
                                #qGetStudentsInRegion.studentName#
                                <cfif VAL(qGetStudentsInRegion.active)>
                                    <span class="note">(Active)</span>
                                <cfelseif isDate(qGetStudentsInRegion.cancelDate)>
                                    <span class="noteAlert">(Cancelled)</span>
                                </cfif>
                            </td>
                            <td>#qGetStudentsInRegion.programName#</td>
                            <td>
                                #qGetStudentsInRegion.hostFamilyLastName#
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
                            </td>
                            <td>
                                #qGetStudentsInRegion.doublePlacementStudentName#
                                <cfif VAL(qGetStudentsInRegion.isActivePlacement) AND VAL(qGetStudentsInRegion.isActiveDoublePlacement)>
                                    <span class="note">(Current)</span>
                                <cfelse>
                                    <span class="note">(Previous)</span>
                                </cfif>
                            </td>
                            <td class="center">#DateFormat(qGetStudentsInRegion.datePlaced, 'mm/dd/yy')#</td>
                            <td>
                                <cfif VAL(vIsCompliant)>
                                    compliant
                                <cfelse>
                                    #vMissingDocumentsMessage#
                                    
                                    #vOutOfComplianceDocuments#
                                </cfif>
                            </td>
                        </tr>
        
                    </cfoutput>
                
                </table>
    	
        	</cfoutput>
        
        </cfsavecontent>
    	
        <cfoutput>
        
			<!--- Display Report --->
            #reportBody#
    
            <!--- Email Regional Manager --->        
            <cfif VAL(FORM.sendEmail) AND qGetStudentsInRegion.recordcount AND IsValid("email", qGetRegionalManager.email) AND IsValid("email", CLIENT.email)>
                
                 <cfsavecontent variable="emailBody">
                    <html>
                        <head>
                            <title>#qGetStudentsInRegion.regionName# - Missing Double Placement Paperwork Report</title>
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
                    <cfinvokeargument name="email_subject" value="#CLIENT.companyshort# - Missing Double Placement Paperwork Report">
                    <cfinvokeargument name="email_message" value="#emailBody#">
                </cfinvoke>
                
                <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                    <tr>
                        <th class="left">*** Report emailed to #qGetRegionalManager.firstName# #qGetRegionalManager.lastName# at #qGetRegionalManager.email# ***</th>
                    </tr>              
                </table>
                
			</cfif>   
            <!--- Email Regional Manager --->              

		</cfoutput>

	</cfloop>

</cfif>

<!--- Page Header --->
<gui:pageFooter />	