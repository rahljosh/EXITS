<!--- ------------------------------------------------------------------------- ----
	
	File:		document_tracking_previous_host.cfm
	Author:		Marcus Melo
	Date:		October 06, 2009
	Desc:		Missing previous placement paperwork

	Updated: 	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
    <!--- Param FORM variables --->
	<cfparam name="FORM.programID" default="0">
    <cfparam name="FORM.regionID" default="">
    <cfparam name="FORM.facilitatorID" default="0">
	<cfparam name="FORM.reportBy" default="Placing"> <!--- Placing/Supervising representatives --->
    <cfparam name="FORM.sendEmail" default="0">
    <cfparam name="FORM.dateFrom" default="">
    <cfparam name="FORM.dateTo" default="">

    <!-----Company Information----->
    <cfinclude template="../querys/get_company_short.cfm">
	
    <cfscript>
		// Declare variables
		listAdvisorUsers = '';
		
		// Define if we are getting students by supervising or placing rep
		if ( reportBy EQ 'Placing' ) {
			tableField = 'placeRepID';	
		} else {
			tableField = 'areaRepID';
		}
	</cfscript>
    	
	<!--- Get Program --->
    <cfquery name="qGetPrograms" datasource="MYSQL">
        SELECT	
            programID,
            programName
        FROM 	
            smg_programs 
        LEFT JOIN 
            smg_program_type ON type = programtypeid
        WHERE
            programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> ) 
    </cfquery> 
    
	<!--- get company region --->
    <cfquery name="qGetRegions" datasource="MySQL">
        SELECT 
        	r.regionID, 
            r.regionname,
            u.firstName,
            u.lastName
        FROM 
        	smg_regions r
		LEFT OUTER JOIN 
        	smg_users u ON r.regionFacilitator = u.userID            
        WHERE 
        	r.company = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
		
        <cfif LEN(FORM.regionID)>
            AND
                r.regionID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionID#" list="yes"> ) 
        </cfif>
            
		<cfif VAL(FORM.facilitatorID)>
			AND 
            	r.regionFacilitator = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.facilitatorID#">
		</cfif>            
        
        ORDER BY 
        	r.regionname
    </cfquery> 

	<!--- Advisors --->
	<cfif CLIENT.usertype EQ 6> 
    
        <cfquery name="qGetUsersUnderAdvisor" datasource="MySql">
            SELECT DISTINCT
            	userID
            FROM 
            	user_access_rights
            WHERE 
                advisorID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
            AND 
            	companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
			GROUP BY
            	userID                
        </cfquery>
        
        <cfscript>
			// populate list of users under advisor
			listAdvisorUsers = ValueList(qGetUsersUnderAdvisor.userID);
			// include current user
        	listAdvisorUsers = ListAppend(listAdvisorUsers, CLIENT.userID);
		</cfscript>
        
    </cfif>

</cfsilent>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>EXITS - Missing Previous Placement Documents</title>
<link rel="stylesheet" href="reports.css" type="text/css">
</head>

<body>

<cfif NOT VAL(FORM.programID)>
	Please select at least one program.
    <cfabort>
</cfif>

<cfif LEN(FORM.regionID) AND VAL(FORM.facilitatorID)>
	Please select either a region or a facilitator.
    <cfabort>
</cfif>

<cfoutput>

<!--- Store Report Header in a Variable --->
<cfsavecontent variable="reportHeader">

	<table width="100%" cellpadding="4" cellspacing="0" align="center" style="border:1px solid ##000;">
		<tr>
			<td align="center">
				<span class="application_section_header">#companyshort.companyshort# - Missing Previous Placement Documents Report</span> <br />
				Program(s) Included in this Report:<br />
				<cfloop query="qGetPrograms">
					<strong>#qGetPrograms.programname# &nbsp; (###qGetPrograms.programID#)</strong><br />
				</cfloop>
			</td>
		</tr>
        <tr>
       		<td align="center">
				Region(s) Included in this Report:<br />
				<cfloop query="qGetRegions">
					<strong>#qGetRegions.regionName# &nbsp; (###qGetRegions.regionID#)</strong><br />
				</cfloop>
            </td>
		</tr>            
	</table>
	
	<br />

</cfsavecontent>

<!--- Display Report Header --->
#reportHeader#

<cfloop query="qGetRegions">
    
    <cfscript>
        // Get Regional Manager
        qGetRegionalManager = APPLICATION.CFC.USER.getRegionalManager(regionID=qGetRegions.regionID);
    </cfscript>
    
    <cfquery name="qGetAllStudentsInRegion" datasource="MySQL">
        SELECT 
            s.studentID, 
            s.countryresident, 
            s.firstname, 
            s.familylastname, 
            s.sex, 
            s.programID, 
            s.areaRepID,
            s.placeRepID,
            hist.datePlaced,
            hist.doc_full_host_app_date,
            hist.doc_letter_rec_date, 
            hist.doc_rules_rec_date,
            hist.doc_rules_sign_date, 
            hist.doc_photos_rec_date, 
            hist.doc_school_accept_date, 
            hist.doc_school_profile_rec,
            hist.doc_conf_host_rec, 
            hist.doc_date_of_visit, 
            hist.doc_ref_form_1, 
            hist.doc_ref_form_2, 
            hist.doc_single_place_auth,
            hist.stu_arrival_orientation, 
            hist.host_arrival_orientation, 
            hist.doc_class_schedule,
            <!--- Added 02/02/2011 --->
            <!--- Required starting Aug 11 --->
            hist.doc_income_ver_date,
            <!--- Required for Single Parents in effect now --->
            hist.doc_single_ref_check1,
            hist.doc_single_ref_check2,
            <!--- hist.doc_conf_host_rec2, Progress Report --->
            secondVisitReport.pr_ny_approved_date,
            <!--- End of Added 02/02/2011 --->
            p.seasonID,
            u.userID,
            u.email as repEmail,
            CONCAT(u.firstName, ' ', u.lastName) AS repName,
            h.hostID, 
            h.motherFirstName, 
            h.fatherFirstName, 
            h.familyLastName as hostLastName 
        FROM 
            smg_students s
        INNER JOIN
        	smg_hosthistory hist ON hist.studentID = s.studentID
            	AND 
                	hist.hostID != s.hostID
        INNER JOIN
            smg_programs p on p.programid = s.programid
        INNER JOIN
            smg_hosts h ON h.hostID = hist.hostID
        LEFT OUTER JOIN 
            smg_users u ON s.#tableField# = u.userID
        <!--- Second Visit Report - Check the report itself and not the fields on placement paperwork --->
        LEFT OUTER JOIN 
            progress_reports secondVisitReport ON secondVisitReport.fk_student = s.studentID
                AND
                	secondVisitReport.fk_host = hist.hostID
                AND
                    secondVisitReport.fk_reporttype = <cfqueryparam cfsqltype="cf_sql_integer" value="2">
                AND
                    secondVisitReport.pr_ny_approved_date IS NOT <cfqueryparam cfsqltype="cf_sql_date" null="yes">                    
        WHERE 
        <!--- Regular Students --->
            s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND 
            s.regionassigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRegions.regionID#"> 
        AND 
            s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
        AND 
            s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> ) 
        <!--- From / To Dates --->
        <cfif LEN(FORM.dateFrom) AND LEN(FORM.dateTo)> 
        	AND
            	hist.datePlaced >= <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDateTime(FORM.dateFrom)#">
        	AND
            	hist.datePlaced <= <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDateTime(FORM.dateTo)#">
        </cfif>       
        AND 
            (
                hist.doc_full_host_app_date IS NULL 
            OR 
                hist.doc_letter_rec_date IS NULL 
            OR 
                hist.doc_rules_rec_date IS NULL 
            OR
            	hist.doc_rules_sign_date IS NULL
            OR
                hist.doc_photos_rec_date IS NULL 
            OR 
                hist.doc_school_accept_date IS NULL 
            OR 
                hist.doc_school_profile_rec IS NULL 
            OR
                hist.doc_conf_host_rec IS NULL 
            OR 
                hist.doc_date_of_visit IS NULL 
            OR 
                hist.doc_ref_form_1 IS NULL 
            OR 
                hist.doc_ref_form_2 IS NULL
            OR 
                hist.stu_arrival_orientation IS NULL 
            OR 
                hist.host_arrival_orientation IS NULL 
            OR 
                hist.doc_class_schedule IS NULL
            )
      
        <!--- Added 02/02/2011 / Required starting Aug 11 --->                                                               
        OR
        	(
                    s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                AND 
                    s.regionassigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRegions.regionID#"> 
                AND 
                    s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
                AND 
                    s.onhold_approved <= <cfqueryparam cfsqltype="cf_sql_integer" value="4">
                AND 
                    s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> ) 
                AND
                    p.seasonID >= <cfqueryparam cfsqltype="cf_sql_integer" value="8">
				<!--- From / To Dates --->
                <cfif LEN(FORM.dateFrom) AND LEN(FORM.dateTo)> 
                    AND
                        hist.datePlaced >= <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDateTime(FORM.dateFrom)#">
                    AND
                        hist.datePlaced <= <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDateTime(FORM.dateTo)#">
                </cfif>       
                AND 
                    (                   	
                        hist.doc_income_ver_date IS NULL
                    OR
                        hist.doc_single_ref_check1 IS NULL
                    OR
                        hist.doc_single_ref_check2 IS NULL            
                    <!--- 
                        Second Visit Report - Check the report itself - OR hist.doc_conf_host_rec2 IS NULL
                    --->
                    OR
                        secondVisitReport.pr_ny_approved_date IS NULL 
                    )                        
        	)
        ORDER BY            
            repName,
            s.firstName,
            hist.datePlaced DESC
    </cfquery> 

    <cfquery name="qGetRepsInRegion" dbtype="query">
        SELECT DISTINCT	
            userID,
            repName,
            repEmail
        FROM 
            qGetAllStudentsInRegion
        ORDER BY
            repName            
    </cfquery> 
    
	<!--- Save Report in a Variable --->
    <cfsavecontent variable="documentTrackingReport">

        <table width="100%" cellpadding="4" cellspacing="0" align="center" style="border:1px solid ##000;">	
            <tr bgcolor="##CCCCCC">	
                <th width="85%">Facitator:  #qGetRegions.firstName# #qGetRegions.lastName# &nbsp; - &nbsp; #qGetRegions.regionname#</th>
                <td width="15%" align="center"><strong>#qGetAllStudentsInRegion.recordcount# student(s)</strong></td>
            </tr>
        </table>

		<cfif qGetAllStudentsInRegion.recordcount>

            <cfloop query="qGetRepsInRegion">
           
            	<cfquery name="checkRepAssign" dbtype="query">
                    SELECT 
                    	studentid, 
                        familylastname, 
                        firstname
                    FROM 
                    	qGetAllStudentsInRegion
                    WHERE
                    	placerepid = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                </cfquery>
                
				<cfif checkRepAssign.recordcount neq 0>
                    <table bgcolor="##FFFF99" width=100%>
                        <Tr>
                            <Td>
                                There is a problem with a student in this report:<br />
                                <A href="../index.cfm?curdoc=student_info&studentid=#checkRepAssign.studentid#" target="_blank">#checkRepAssign.studentid#</a> does not have a rep assigned to them but has a host family assinged to them. <br /><BR />
                                Please assign a rep to them and re-run this report.  <br />
                                You can click on the students name, a new window will open, assign a rep and then just refresh this window.
                            </Td>
                         </Tr>
                      </table>
                      <br /><br /><br />
                    <cfabort>  
                </cfif>
             
                <cfquery name="qGetStudentsByRep" dbtype="query">
                    SELECT 	
                        *
                    FROM 
                        qGetAllStudentsInRegion
                    WHERE 
                        #tableField# = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRepsInRegion.userID#">
                    ORDER BY
                        firstName,
                        familyLastName                    
                </cfquery> 
            	
                <cfif qGetStudentsByRep.recordcount> 
            
                    <br />				
            
                    <table width="100%" cellpadding="4" cellspacing="0" align="center" style="border:1px solid ##999;">
                        <tr bgcolor="##ededed">
                            <td width="85%" align="left">
                                <strong>
                                    #FORM.reportBy# Representative: 
                                    <cfif LEN(qGetRepsInRegion.repName)>
                                        #qGetRepsInRegion.repName# (###qGetRepsInRegion.userID#)
                                    <cfelse>
                                        <font color="red">Missing or Unknown</font>
                                    </cfif>
                                </strong>                                    
                            </td>
                            <td width="15%" align="center">#qGetStudentsByRep.recordcount# student(s)</td>
                        </tr>
                    </table>
                                        
                    <table width="100%" cellpadding="4" cellspacing="0" align="center" style="border:1px solid ##999;">
                        <tr>
                            <td width="4%" style="border-bottom:1px solid ##999;"><strong>ID</strong></td>
                            <td width="18%" style="border-bottom:1px solid ##999;"><strong>Student</strong></td>
                            <td width="15%" style="border-bottom:1px solid ##999;"><strong>Host Family</strong></td>
                            <td width="8%" style="border-bottom:1px solid ##999;"><strong>Date Placed</strong></td>
                            <td width="55%" style="border-bottom:1px solid ##999;"><strong>Missing Documents</strong></td>
                        </tr>	
                        <cfloop query="qGetStudentsByRep">		
                        
                            <!--- Get number of host kids at home ---->
                            <cfquery name="qHostFamKids" datasource="#application.dsn#">
                                SELECT 
                                    childID
                                FROM 
                                    smg_host_children
                                WHERE
                                    liveathome = <cfqueryparam cfsqltype="cf_sql_varchar" value="yes">
                                AND
                                    hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentsByRep.hostID#">
                                AND	
                                	isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                            </cfquery>
                            
                            <cfscript>
                                isFatherHome = 0;
                                isMotherHome = 0;
                                
                                // Father is Home
                                if ( LEN(qGetStudentsByRep.fatherFirstName) ) {
                                    isFatherHome = 1;
                                }
                                
                                if ( LEN(qGetStudentsByRep.motherFirstName) ) {
                                    isMotherHome = 1;
                                }
                                
                                totalFamilyMembers = isFatherHome + isMotherHome + qHostFamKids.recordCount;

                                // Set Variable to Handle Missing Documents
                                missingDocumentsList = '';
							
                                // Required for Single Parents 
                                if ( qGetStudentsByRep.seasonID GTE 8 AND totalFamilyMembers EQ 1 ) { // 
                                     if ( NOT isDate(qGetStudentsByRep.doc_single_place_auth) ) {
                                    missingDocumentsList = ListAppend(missingDocumentsList, "Single Person Placement Verification &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                }
									
									// Date of S.P. Reference Check 1
                                    if ( NOT isDate(qGetStudentsByRep.doc_single_ref_check1) ) {
                                        missingDocumentsList = ListAppend(missingDocumentsList, "Ref Check (Single) &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                    }
                                    // Date of S.P. Reference Check 2
                                    if ( NOT isDate(qGetStudentsByRep.doc_single_ref_check2) ) {
                                        missingDocumentsList = ListAppend(missingDocumentsList, "2nd Ref Check (Single) &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                    }
                                }
								
                                // Host Application Received
                                if ( NOT isDate(qGetStudentsByRep.doc_full_host_app_date) ) {
                                    missingDocumentsList = ListAppend(missingDocumentsList, "Host Family &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                }
                                // Host Family Letter Received
                                if ( NOT isDate(qGetStudentsByRep.doc_letter_rec_date) ) {
                                    missingDocumentsList = ListAppend(missingDocumentsList, "HF Letter &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                }
                                // Host Family Rules Form
                                if ( NOT isDate(qGetStudentsByRep.doc_rules_rec_date) ) {
                                    missingDocumentsList = ListAppend(missingDocumentsList, "HF Rules &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                }
                                // Host Family Rules Date Signed
                                if ( NOT isDate(qGetStudentsByRep.doc_rules_sign_date) ) {
                                    missingDocumentsList = ListAppend(missingDocumentsList, "HF Rules Date Signed &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                }
                                // Host Family Photos
                                if ( NOT isDate(qGetStudentsByRep.doc_photos_rec_date) ) {
                                    missingDocumentsList = ListAppend(missingDocumentsList, "HF Photos &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                }
                                // School & Community Profile Form
                                if ( NOT isDate(qGetStudentsByRep.doc_school_profile_rec) ) {
                                    missingDocumentsList = ListAppend(missingDocumentsList, "School & Community Profile &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                }
                                // Confidential Host Family Visit Form
                                if ( NOT isDate(qGetStudentsByRep.doc_conf_host_rec) ) {
                                    missingDocumentsList = ListAppend(missingDocumentsList, "Visit Form &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                }
                                // Confidential Host Family Visit Form - Date of Visit
                                if ( NOT isDate(qGetStudentsByRep.doc_date_of_visit) ) {
                                    missingDocumentsList = ListAppend(missingDocumentsList, "Date of Visit &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                }
                                // Reference Form 1
                                if ( NOT isDate(qGetStudentsByRep.doc_ref_form_1) ) {
                                    missingDocumentsList = ListAppend(missingDocumentsList, "Ref. 1 &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                }
                                // Reference Form 2
                                if ( NOT isDate(qGetStudentsByRep.doc_ref_form_2) ) {
                                    missingDocumentsList = ListAppend(missingDocumentsList, "Ref. 2 &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                }
                                // School Acceptance Form
                                if ( NOT isDate(qGetStudentsByRep.doc_school_accept_date) ) {
                                    missingDocumentsList = ListAppend(missingDocumentsList, "School Acceptance &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                }								
                                
                                // Required starting Aug 11
                                if ( qGetStudentsByRep.seasonID GTE 8 ) {
                                    // Income Verification Form
                                    if ( NOT isDate(qGetStudentsByRep.doc_income_ver_date) ) {
                                        missingDocumentsList = ListAppend(missingDocumentsList, "Income Verification &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                    }
                                    // 2nd Confidential Host Family Visit Form
                                    if ( NOT isDate(qGetStudentsByRep.pr_ny_approved_date) ) { 
                                        missingDocumentsList = ListAppend(missingDocumentsList, "2nd Conf. Host Visit &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                    }
                                    
                                }  
                                
                                // Student Orientation
                                if ( NOT isDate(qGetStudentsByRep.stu_arrival_orientation) ) {
                                    missingDocumentsList = ListAppend(missingDocumentsList, "Student Orientation &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                }
                                // HF Orientation
                                if ( NOT isDate(qGetStudentsByRep.host_arrival_orientation) ) {
                                    missingDocumentsList = ListAppend(missingDocumentsList, "HF Orientation &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                }
                                // Class Schedule
                                if ( NOT isDate(qGetStudentsByRep.doc_class_schedule) ) {
                                    missingDocumentsList = ListAppend(missingDocumentsList, "Class Schedule &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                }
                            </cfscript>
                            
                            <cfif LEN(missingDocumentsList)>
                                <tr bgcolor="###iif(qGetStudentsByRep.currentrow MOD 2 ,DE("EDEDED") ,DE("FFFFFF") )#">
                                    <td>#qGetStudentsByRep.studentID#</td>
                                    <td>#qGetStudentsByRep.firstname# #qGetStudentsByRep.familylastname#</td>
                                    <td>#qGetStudentsByRep.hostLastName# (###qGetStudentsByRep.hostID#)</td>
                                    <td>#DateFormat(qGetStudentsByRep.datePlaced, 'mm/dd/yyyy')#</td>
                                    <td align="left"><i><font size="-2">#missingDocumentsList#</font></i></td>		
                                </tr>	
                            </cfif>
                                                                                        
                        </cfloop>	
                      
                    </table>
                                    
                </cfif>  <!--- qGetStudentsByRep.recordcount ---> 
        
            </cfloop> <!--- cfloop query="qGetRepsInRegion" --->
        
        <cfelse> <!---  qGetAllStudentsInRegion.recordcount --->
            
            <table width="100%" cellpadding="4" cellspacing="0" align="center" style="border:1px solid ##999;">
                <tr>
                    <td width="85%" align="center">There are no students missing documents for the selected programs.</td>
                    <td width="15%">&nbsp;</td>
                </tr>
            </table>
                        
        </cfif> <!---  qGetAllStudentsInRegion.recordcount --->
    
        <br />

	</cfsavecontent>

	<!--- Display Report --->
    #documentTrackingReport#

	<!--- Email Regional Managers --->        
    <cfif VAL(FORM.sendEmail) AND qGetAllStudentsInRegion.recordcount AND IsValid("email", qGetRegionalManager.email) AND IsValid("email", CLIENT.email)>
    	
        <cfsavecontent variable="emailBody">
            <!--- Display Report Header --->
            #reportHeader#	
                                
            <!--- Display Report --->
            #documentTrackingReport#
        </cfsavecontent>

        <cfinvoke component="nsmg.cfc.email" method="send_mail">
            <cfinvokeargument name="email_to" value="#qGetRegionalManager.email#">
            <cfinvokeargument name="email_cc" value="#CLIENT.email#">
            <cfinvokeargument name="email_from" value="#CLIENT.support_email#">
            <cfinvokeargument name="email_subject" value="MISSING PREVIOUS PLACEMENT DOCUMENTS REPORT - #companyshort.companyshort# - #qGetRegions.regionName# Region">
            <cfinvokeargument name="email_message" value="#emailBody#">
        </cfinvoke>
            
    </cfif>   <!--- Email Regional Managers --->       
                
</cfloop> <!--- cfloop query="qGetRegions" --->

</cfoutput>

</body>
</html>