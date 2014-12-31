<!--- ------------------------------------------------------------------------- ----
	
	File:		doublePlacementPaperworkByIntlRep.cfm
	Author:		Marcus Melo
	Date:		February 27, 2012
	Desc:		Double Placement Paperwork by Intl. Rep.

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
		param name="FORM.outputType" default="onScreen";
		param name="FORM.sendEmail" default=0;	

		// Get Programs
		qGetPrograms = APPLICATION.CFC.PROGRAM.getPrograms(programIDList=FORM.programID);
	</cfscript>	

    <cfquery name="qGetResults" datasource="MySQL">
        SELECT 
            s.studentID,
            s.firstName,
            s.familyLastName,
            CAST(CONCAT(s.firstName, ' ', s.familyLastName,  ' ##', s.studentID) AS CHAR) AS studentName,
            s.active,
            s.cancelDate,
            sh.isWelcomeFamily,
            sh.datePlaced,
            sh.isActive AS isActivePlacement,
            IF ( sh.doublePlacementID = sht.fieldID, 1, 0 ) AS isActiveDoublePlacement,
            sht.doublePlacementParentsDateSigned,
            sht.doublePlacementStudentDateSigned,
            sht.doublePlacementHostFamilyDateSigned,
            intRep.userID,
            intRep.businessName,
            intRep.email AS intRepEmail,
            p.programName,
            r.regionName,
            h.hostID, 
            h.familyLastName as hostFamilyLastName,
            CAST(CONCAT(dp.firstName, ' ', dp.familyLastName,  ' ##', dp.studentID) AS CHAR) AS doublePlacementStudentName,
            CONCAT(fac.firstName, ' ',fac.LastName) AS facilitatorName,
            fac.email AS facilitatorEmail
        FROM 
            smg_students s
        INNER JOIN
            smg_hosthistory sh ON sh.studentID = s.studentID
        INNER JOIN
            smg_hosthistoryTracking sht ON sht.historyID = sh.historyID
                AND
                    sht.fieldName = <cfqueryparam cfsqltype="cf_sql_varchar" value="doublePlacementID"> 
                AND
                    (
                    	sht.isDoublePlacementPaperworkRequired IS <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                  	OR
                    	sht.isDoublePlacementPaperworkRequired = <cfqueryparam cfsqltype="cf_sql_bit" value="1"> 
                    )
                <!--- Get Missing --->
                <cfif FORM.compliantOption EQ 'missing'>
                    AND 
                        (
                            sht.doublePlacementParentsDateSigned IS <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                        OR
                            sht.doublePlacementStudentDateSigned IS <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                        )
                <!--- Get Non-compliant --->
				<cfelseif FORM.compliantOption EQ 'non-compliant'>
                    AND 
                        (
                        
                            (
                                sht.doublePlacementParentsDateSigned IS <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                            OR
                                sht.doublePlacementStudentDateSigned IS <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                            )
						OR
                        
                            (
                                sht.doublePlacementParentsDateSigned > sh.datePlaced
                            OR
                                sht.doublePlacementStudentDateSigned > sh.datePlaced
                            )
						)                            
				</cfif>                    
		INNER JOIN
			smg_students dp ON dp.studentID = sht.fieldID
        INNER JOIN
            smg_programs p on p.programid = s.programid
        INNER JOIN
            smg_users intRep ON intRep.userID = s.intRep
        INNER JOIN
            smg_hosts h ON h.hostID = sh.hostID
        INNER JOIN
            smg_regions r ON r.regionID = s.regionAssigned
        LEFT OUTER JOIN
        	smg_users fac ON fac.userID = r.regionFacilitator
        WHERE 
            s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> ) 
        AND 
            s.host_fam_approved <= <cfqueryparam cfsqltype="cf_sql_integer" value="4">	
        AND
            s.regionassigned IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionID#" list="yes"> )
      	<cfif 

        ORDER BY         
          businessName,
          regionName,          
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
            <th colspan="12">Placement Reports - Double Placement Paperwork by International Representative</th>            
        </tr>
        <tr style="font-weight:bold;">
            <td>International Representative</td>
            <td>Student ID</td>
            <td>Student First Name</td>
            <td>Student Last Name</td>
            <td>Student Status</td>
            <td>Program</td>
            <td>Region</td>
            <td>Facilitator</td>
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
				
					// Natural Family Date Signed
					if ( NOT isDate(qGetResults.doublePlacementParentsDateSigned) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Missing Natural Family Date Signed <br />", " <br />");
					} 
					
					// Student Date Signed
					if ( NOT isDate(qGetResults.doublePlacementStudentDateSigned) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Missing Student Date Signed <br />", " <br />");
					} 
				
				// Display Both
				} else { 
				
					// Natural Family Date Signed
					if ( NOT isDate(qGetResults.doublePlacementParentsDateSigned) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Missing Natural Family Date Signed <br />", " <br />");
					} else if ( isDate(qGetResults.doublePlacementStudentDateSigned) AND qGetResults.doublePlacementParentsDateSigned GT qGetResults.datePlaced ) {
						vOutOfComplianceDocuments = ListAppend(vOutOfComplianceDocuments, "Natural Family Date Signed is Non-compliant <br />", " <br />");
					}
					
					// Student Date Signed
					if ( NOT isDate(qGetResults.doublePlacementStudentDateSigned) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Missing Student Date Signed <br />", " <br />");
					} else if ( isDate(qGetResults.doublePlacementStudentDateSigned) AND qGetResults.doublePlacementStudentDateSigned GT qGetResults.datePlaced ) {
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
                <td #vRowColor#>#qGetResults.businessName#</td>
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
                <td #vRowColor#>#qGetResults.regionName#</td>
                <td #vRowColor#>#qGetResults.facilitatorName#</td>
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
                    <th>Placement Reports - Double Placement Paperwork by International Representative</th>            
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

	<cfoutput query="qGetResults" group="userID">
        
        <!--- Save Report in a Variable --->
        <cfsavecontent variable="reportBody">
    
            <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                <tr>
                    <th class="left" colspan="8">#qGetResults.businessName#</th>
                </tr>      
                <tr class="on">
                    <td class="subTitleLeft" width="15%">Student</td>
                    <td class="subTitleLeft" width="8%">Program</td>
                    <td class="subTitleLeft" width="8%">Region</td>
                    <td class="subTitleLeft" width="10%">Facilitator</td>
                    <td class="subTitleLeft" width="12%">Host Family</td>
                    <td class="subTitleLeft" width="15%">Double Placement</td>
                    <td class="subTitleCenter" width="7%">Date Placed</td>
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
						
							// Natural Family Date Signed
							if ( NOT isDate(qGetResults.doublePlacementParentsDateSigned) ) {
								vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Missing Natural Family Date Signed <br />", " <br />");
							} 
							
							// Student Date Signed
							if ( NOT isDate(qGetResults.doublePlacementStudentDateSigned) ) {
								vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Missing Student Date Signed <br />", " <br />");
							} 

						// Display Both
						} else { 
						
							// Natural Family Date Signed
							if ( NOT isDate(qGetResults.doublePlacementParentsDateSigned) ) {
								vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Missing Natural Family Date Signed <br />", " <br />");
							} else if ( isDate(qGetResults.doublePlacementStudentDateSigned) AND qGetResults.doublePlacementParentsDateSigned GT qGetResults.datePlaced ) {
								vOutOfComplianceDocuments = ListAppend(vOutOfComplianceDocuments, "Natural Family Date Signed is Non-compliant <br />", " <br />");
							}
							
							// Student Date Signed
							if ( NOT isDate(qGetResults.doublePlacementStudentDateSigned) ) {
								vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Missing Student Date Signed <br />", " <br />");
							} else if ( isDate(qGetResults.doublePlacementStudentDateSigned) AND qGetResults.doublePlacementStudentDateSigned GT qGetResults.datePlaced ) {
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
                            #qGetResults.studentName#
                            <cfif VAL(qGetResults.active)>
                                <span class="note">(Active)</span>
                            <cfelseif isDate(qGetResults.cancelDate)>
                                <span class="noteAlert">(Cancelled)</span>
                            </cfif>
                        </td>
                        <td>#qGetResults.programName#</td>
                        <td>#qGetResults.regionName#</td>
                        <td><a href="mailto:#qGetResults.facilitatorEmail#" title="Email #qGetResults.facilitatorName#">#qGetResults.facilitatorName#</a></td>
                        <td>
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
                                )
                            </span>                            
                            
                        </td>
                        <td>
                            #qGetResults.doublePlacementStudentName#
                            <cfif VAL(qGetResults.isActivePlacement) AND VAL(qGetResults.isActiveDoublePlacement)>
                                <span class="note">(Current)</span>
                            <cfelse>
                                <span class="note">(Previous)</span>
                            </cfif>
                        </td>
                        <td class="center">#DateFormat(qGetResults.datePlaced, 'mm/dd/yy')#</td>
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
    
        </cfsavecontent>
    
        <!--- Display Report --->
        #reportBody#

		<!--- Email Intl. Representatives --->        
        <cfif VAL(FORM.sendEmail) AND qGetResults.recordcount AND IsValid("email", qGetResults.intRepEmail) AND IsValid("email", CLIENT.email)>
            
             <cfsavecontent variable="emailBody">
				<html>
					<head>
						<title>#qGetResults.businessName# - Missing Double Placement Paperwork Report</title>
					</head>
					<body>
                    	
                        <!--- Include CSS on the body of email --->
						<style type="text/css">
							<cfinclude template="../linked/css/baseStyle.css">
                        </style>                    
			
                        <p>	
                            Dear #qGetResults.businessName#,
                        </p>
                        
                        <p>            	
                            Please find a list of missing documents for the corresponding students below.   	
                            These documents have not been received by our office at this current time. Please send them to the appropriate facilitator ASAP. 
                            If you are missing any of the requested documents or have any questions regarding these students, please contact the appropriate facilitator.
                        </p>                 
                        
						<!--- Display Report Header --->
                        #reportHeader#	
                                          
                        <!--- Display Report --->
                        #reportBody#

                   </body>
                </html>
            </cfsavecontent>
    
            <cfinvoke component="nsmg.cfc.email" method="send_mail">
                <cfinvokeargument name="email_to" value="#qGetResults.intRepEmail#">
                <cfinvokeargument name="email_cc" value="#CLIENT.email#">
                <cfinvokeargument name="email_from" value="#CLIENT.support_email#">
                <cfinvokeargument name="email_subject" value="#CLIENT.companyshort# - Missing Double Placement Paperwork Report">
                <cfinvokeargument name="email_message" value="#emailBody#">
            </cfinvoke>
            
			<table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                <tr>
                    <th class="left">*** Report emailed to #qGetResults.intRepEmail# ***</th>
                </tr>              
            </table>
                
        </cfif>   
		<!--- Email Intl. Representatives --->              
    
    </cfoutput>

</cfif>

<!--- Page Header --->
<gui:pageFooter />	