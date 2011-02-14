<!--- Kill Extra Output --->
<cfsilent>
	
    <!--- Param FORM variables --->
	<cfparam name="FORM.programID" default="0">
    <cfparam name="FORM.regionID" default="">
    <cfparam name="FORM.facilitatorID" default="0">
	<cfparam name="FORM.reportBy" default="Placing"> <!--- Placing/Supervising representatives --->
    <cfparam name="FORM.sendEmail" default="0">

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
        <cfquery name="get_users_under_adv" datasource="MySql">
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
			listAdvisorUsers = ValueList(get_users_under_adv.userID);
			// include current user
        	listAdvisorUsers = ListAppend(listAdvisorUsers, CLIENT.userID);
		</cfscript>
    </cfif>

</cfsilent>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>EXITS - Missing Placement Documents</title>
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
				<span class="application_section_header">#companyshort.companyshort# - Missing Placement Documents Report</span> <br />
				Program(s) Included in this Report:<br />
				<cfloop query="qGetPrograms">
					<strong>#programname# &nbsp; (#programID#)</strong><br />
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
            s.#tableField#,
            s.date_pis_received, 
            s.doc_full_host_app_date,
            s.doc_letter_rec_date, 
            s.doc_rules_rec_date, 
            s.doc_photos_rec_date, 
            s.doc_school_accept_date, 
            s.doc_school_profile_rec,
            s.doc_conf_host_rec, 
            s.doc_date_of_visit, 
            s.doc_ref_form_1, 
            s.doc_ref_form_2, 
            s.stu_arrival_orientation, 
            s.host_arrival_orientation, 
            s.doc_class_schedule,
            <!--- Added 02/02/2011 --->
            <!--- Required starting Aug 11 --->
            s.doc_income_ver_date,
            s.doc_conf_host_rec2,
            <!--- Required for Single Parents in effect now --->
            s.doc_single_ref_check1,
            s.doc_single_ref_check2,
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
        LEFT JOIN 
            smg_users u ON s.#tableField# = userID
        LEFT JOIN
            smg_programs p on p.programid = s.programid
        INNER JOIN
            smg_hosts h ON h.hostID = s.hostID
        WHERE 
        <!--- Regular Students --->
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
            (
                s.doc_full_host_app_date IS NULL 
            OR 
                s.doc_letter_rec_date IS NULL 
            OR 
                s.doc_rules_rec_date IS NULL 
            OR
                s.doc_photos_rec_date IS NULL 
            OR 
                s.doc_school_accept_date IS NULL 
            OR 
                s.doc_school_profile_rec IS NULL 
            OR
                s.doc_conf_host_rec IS NULL 
            OR 
                s.doc_date_of_visit IS NULL 
            OR 
                s.doc_ref_form_1 IS NULL 
            OR 
                s.doc_ref_form_2 IS NULL
            OR 
                s.stu_arrival_orientation IS NULL 
            OR 
                s.host_arrival_orientation IS NULL 
            OR 
                s.doc_class_schedule IS NULL
            )
      
        <!--- Added 02/02/2011 / Required starting Aug 11 --->                                                               
        OR
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
        AND 
            (                   	
                s.doc_income_ver_date IS NULL
            OR
                s.doc_conf_host_rec2 IS NULL
            OR
                s.doc_single_ref_check1 IS NULL
            OR
                s.doc_single_ref_check2 IS NULL
            )                        
           
        ORDER BY
            repName,
            s.firstName            
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
                            <td width="8%" style="border-bottom:1px solid ##999;"><strong>Placement</strong></td>
                            <td width="70%" style="border-bottom:1px solid ##999;"><strong>Missing Documents</strong></td>
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
                                    // Date of S.P. Reference Check 1
                                    if ( NOT LEN(qGetStudentsByRep.doc_single_ref_check1) ) {
                                        missingDocumentsList = ListAppend(missingDocumentsList, "Ref Check (Single) &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                    }
                                    // Date of S.P. Reference Check 2
                                    if ( NOT LEN(qGetStudentsByRep.doc_single_ref_check2) ) {
                                        missingDocumentsList = ListAppend(missingDocumentsList, "2nd Ref Check (Single) &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                    }
                                }
                                // Placement Information Sheet
                                if ( NOT LEN(qGetStudentsByRep.date_pis_received) ) {
                                    missingDocumentsList = ListAppend(missingDocumentsList, "Placement Information Sheet &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                }
                                // Host Application Received
                                if ( NOT LEN(qGetStudentsByRep.doc_full_host_app_date) ) {
                                    missingDocumentsList = ListAppend(missingDocumentsList, "Host Family &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                }
                                // Host Family Letter Received
                                if ( NOT LEN(qGetStudentsByRep.doc_letter_rec_date) ) {
                                    missingDocumentsList = ListAppend(missingDocumentsList, "HF Letter &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                }
                                // Host Family Rules Form
                                if ( NOT LEN(qGetStudentsByRep.doc_rules_rec_date) ) {
                                    missingDocumentsList = ListAppend(missingDocumentsList, "HF Rules &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                }
                                // Host Family Photos
                                if ( NOT LEN(qGetStudentsByRep.doc_photos_rec_date) ) {
                                    missingDocumentsList = ListAppend(missingDocumentsList, "HF Photos &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                }
                                // School & Community Profile Form
                                if ( NOT LEN(qGetStudentsByRep.doc_school_profile_rec) ) {
                                    missingDocumentsList = ListAppend(missingDocumentsList, "School & Community Profile &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                }
                                // Confidential Host Family Visit Form
                                if ( NOT LEN(qGetStudentsByRep.doc_conf_host_rec) ) {
                                    missingDocumentsList = ListAppend(missingDocumentsList, "Visit Form &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                }
                                // Confidential Host Family Visit Form - Date of Visit
                                if ( NOT LEN(qGetStudentsByRep.doc_date_of_visit) ) {
                                    missingDocumentsList = ListAppend(missingDocumentsList, "Date of Visit &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                }
                                // Reference Form 1
                                if ( NOT LEN(qGetStudentsByRep.doc_ref_form_1) ) {
                                    missingDocumentsList = ListAppend(missingDocumentsList, "Ref. 1 &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                }
                                // Reference Form 2
                                if ( NOT LEN(qGetStudentsByRep.doc_ref_form_2) ) {
                                    missingDocumentsList = ListAppend(missingDocumentsList, "Ref. 2 &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                }
                                // School Acceptance Form
                                if ( NOT LEN(qGetStudentsByRep.doc_school_accept_date) ) {
                                    missingDocumentsList = ListAppend(missingDocumentsList, "School Acceptance &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                }								
                                
                                // Required starting Aug 11
                                if ( qGetStudentsByRep.seasonID GTE 8 ) {
                                    // Income Verification Form
                                    if ( NOT LEN(qGetStudentsByRep.doc_income_ver_date) ) {
                                        missingDocumentsList = ListAppend(missingDocumentsList, "Income Verification &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                    }
                                    // 2nd Confidential Host Family Visit Form
                                    if ( NOT LEN(qGetStudentsByRep.doc_conf_host_rec2) ) { 
                                        missingDocumentsList = ListAppend(missingDocumentsList, "2nd Conf. Host Visit &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                    }
                                    
                                }  
                                
                                // Student Orientation
                                if ( NOT LEN(qGetStudentsByRep.stu_arrival_orientation) ) {
                                    missingDocumentsList = ListAppend(missingDocumentsList, "Student Orientation &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                }
                                // HF Orientation
                                if ( NOT LEN(qGetStudentsByRep.host_arrival_orientation) ) {
                                    missingDocumentsList = ListAppend(missingDocumentsList, "HF Orientation &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                }
                                // Class Schedule
                                if ( NOT LEN(qGetStudentsByRep.doc_class_schedule) ) {
                                    missingDocumentsList = ListAppend(missingDocumentsList, "Class Schedule &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                }
                            </cfscript>
                            
                            <cfif LEN(missingDocumentsList)>
                                <tr bgcolor="###iif(qGetStudentsByRep.currentrow MOD 2 ,DE("EDEDED") ,DE("FFFFFF") )#">
                                    <td>#qGetStudentsByRep.studentID#</td>
                                    <td>#qGetStudentsByRep.firstname# #qGetStudentsByRep.familylastname#</td>
                                    <td>#DateFormat(qGetStudentsByRep.date_pis_received, 'mm/dd/yyyy')#</td>
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
            <cfinvokeargument name="email_subject" value="Missing Documents Report - #companyshort.companyshort# - #qGetRegions.regionName# Region">
            <cfinvokeargument name="email_message" value="#emailBody#">
        </cfinvoke>
            
    </cfif>   <!--- Email Regional Managers --->       
                
</cfloop> <!--- cfloop query="qGetRegions" --->

</cfoutput>

</body>
</html>