<!--- ------------------------------------------------------------------------- ----
	
	File:		_studentPlacementPaperworkByRegion.cfm
	Author:		Marcus Melo
	Date:		April 20, 2012
	Desc:		Missing Placement Paperwork By Region
	
				#CGI.SCRIPT_NAME#?curdoc=report/index?action=studentPlacementPaperworkByRegion

	Updated: 	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../../extensions/customTags/gui/" prefix="gui" />	
	
    <cfscript>	
		// Param FORM Variables
		param name="FORM.submitted" default=0;
		param name="FORM.programID" default=0;	
		param name="FORM.regionID" default="";
		param name="FORM.studentStatus" default="Active";
		param name="FORM.placementStatus" default="Placed";
		param name="FORM.placedDateFrom" default="";
		param name="FORM.placedDateTo" default="";
		param name="FORM.compliantOption" default="";
		param name="FORM.reportBy" default="placeRepID";
		param name="FORM.outputType" default="flashPaper";
		param name="FORM.sendEmail" default=0;	

		// Set Report Title To Keep Consistency
		vReportTitle = "Student Management - Compliance Paperwork by Region";

		// Get Programs
		qGetPrograms = APPLICATION.CFC.PROGRAM.getPrograms(programIDList=FORM.programID);
		
		// Get List of Users Under Advisor and the Advisor self
		vListOfAdvisorUsers = "";
		if ( CLIENT.usertype EQ 6 ) {
   			
			
			// Get Available Reps
			qGetUserUnderAdv = APPLICATION.CFC.USER.getSupervisedUsers(userType=CLIENT.userType, userID=CLIENT.userID, regionIDList=FORM.regionID);
		   
			// Store Users under Advisor on a list
			vListOfAdvisorUsers = ValueList(qGetUserUnderAdv.userID);

		}
	</cfscript>	

    <!--- FORM Submitted --->
    <cfif VAL(FORM.submitted)>

        <cfscript>
			// Data Validation
			
            // Program
            if ( NOT VAL(FORM.programID) ) {
                // Set Page Message
                SESSION.formErrors.Add("You must select at least one program");
            }

            // Region
            if ( NOT VAL(FORM.regionID) ) {
                // Set Page Message
                SESSION.formErrors.Add("You must select at least one region");
            }
		</cfscript>

        <!--- No Errors Found --->
        <cfif NOT SESSION.formErrors.length()>

            <!--- Get a list of host families that were included in the DOS Report and Sevis Updates --->
            <cfquery name="qGetHostList" datasource="#APPLICATION.DSN#">
            	SELECT
                	hostID
                FROM
                	(
				
						<!--- GET CSIET HOSTS --->
                        SELECT
                            ch.hostID
                        FROM
                            smg_csiet_history ch                    
                        INNER JOIN
                            smg_students s ON s.studentID = ch.studentID
                            AND
                                s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> ) 
                                <!--- Student Status --->
                                <cfif FORM.studentStatus EQ 'Active'>
                                    AND
                                        s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                                <cfelseif FORM.studentStatus EQ 'Inactive'>
                                    AND
                                        s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                                <cfelseif FORM.studentStatus EQ 'Canceled'>
                                    AND
                                        s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                                    AND
                                        s.cancelDate IS NOT <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                                </cfif>
                            
                        UNION
                        
                        <!--- GET SEVIS UPDATES --->
                        SELECT
                            ssh.hostID
                        FROM
                            smg_sevis_history ssh                    
                        INNER JOIN
                            smg_students s ON s.studentID = ssh.studentID
                            AND
                                s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> ) 
                                <!--- Student Status --->
                                <cfif FORM.studentStatus EQ 'Active'>
                                    AND
                                        s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                                <cfelseif FORM.studentStatus EQ 'Inactive'>
                                    AND
                                        s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                                <cfelseif FORM.studentStatus EQ 'Canceled'>
                                    AND
                                        s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                                    AND
                                        s.cancelDate IS NOT <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                                </cfif>
                            
					) AS t 
                    
                    GROUP BY
                        hostID  
            </cfquery>
            
            <cfquery name="qGetResults" datasource="#APPLICATION.DSN#">
                SELECT
                	*
                FROM
                	( 
                        SELECT 
                            s.studentID,
                            s.firstName,
                            s.familyLastName,
                            CAST(CONCAT(s.firstName, ' ', s.familyLastName,  ' ##', s.studentID) AS CHAR) AS studentName,
                            s.active,
                            s.cancelDate,
                            sh.areaRepID,
                            sh.placeRepID,
                            sh.isRelocation,
                            sh.isWelcomeFamily,
                            sh.isActive AS isActivePlacement,
                            sh.datePlaced,
                            sh.compliance_host_app_page1_date,
                            sh.compliance_host_app_page2_date,
                            sh.compliance_letter_rec_date, 
                            sh.compliance_rules_rec_date, 
                            sh.compliance_rules_sign_date,
                            sh.compliance_photos_rec_date, 
                            <!--- Added 02/27/2012 - Required for August 12 Students --->
                            sh.compliance_bedroom_photo,
                            sh.compliance_bathroom_photo,
                            sh.compliance_kitchen_photo,
                            sh.compliance_living_room_photo,
                            sh.compliance_outside_photo,
                            <!--- End of Added 02/27/2012 - Required for August 12 Students --->
                            sh.compliance_school_accept_date, 
                            sh.compliance_school_profile_rec,
                            sh.compliance_conf_host_rec, 
                            sh.compliance_date_of_visit, 
                            sh.compliance_ref_form_1, 
                            sh.compliance_ref_form_2, 
                            sh.compliance_single_place_auth,
                            sh.compliance_stu_arrival_orientation, 
                            sh.compliance_host_arrival_orientation, 
                            sh.compliance_income_ver_date,
                            sh.compliance_single_ref_check1,
                            sh.compliance_single_ref_check2,
                            <!--- Second Visit Report --->
                            secondVisitReport.pr_ny_approved_date,
                            <!--- Program --->
                            p.programName,
                            p.seasonID,
                            <!--- Host Family --->
                            h.hostID,             
                            h.familyLastName as hostFamilyLastName,
                            h.fatherFirstName,
                            h.motherFirstName,
                            <!--- Get Total of Children at home --->
                            (
                                SELECT 
                                    COUNT(shc.childID) 
                                FROM 
                                    smg_host_children shc
                                WHERE
                                    shc.hostID = h.hostID
                                AND
                                    shc.liveathome = <cfqueryparam cfsqltype="cf_sql_varchar" value="yes">
                                AND	
                                    shc.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                            ) AS totalChildrenAtHome,
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
                            smg_hostHistory sh ON sh.studentID = s.studentID
                            <!--- Date Placed --->
                            <cfif isDate(FORM.placedDateFrom) AND isDate(FORM.placedDateTo)>
                                AND 
                                    sh.datePlaced
                                    BETWEEN 
                                        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.placedDateFrom#"> 	
                                    AND
                                        <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d', 1, FORM.placedDateTo)#"> 	
                            </cfif>
                        INNER JOIN
                            smg_programs p on p.programID = s.programID
                            <!--- Program --->
                            AND
                                p.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> ) 
                        INNER JOIN
                            smg_hosts h ON h.hostID = sh.hostID
                        INNER JOIN
                            smg_regions r ON r.regionID = s.regionAssigned
                            <!--- Region --->
                            AND
                                r.regionID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionID#" list="yes"> ) 
                        <!--- Second Visit Report - Check the report itself and not the fields on placement paperwork --->
                        LEFT OUTER JOIN 
                            progress_reports secondVisitReport ON secondVisitReport.fk_student = s.studentID
                                AND
                                    secondVisitReport.fk_host = sh.hostID
                                AND
                                    secondVisitReport.fk_reporttype = <cfqueryparam cfsqltype="cf_sql_integer" value="2">
                                AND
                                    secondVisitReport.pr_ny_approved_date IS NOT <cfqueryparam cfsqltype="cf_sql_date" null="yes">                    
                        LEFT OUTER JOIN 
                            smg_users fac ON r.regionFacilitator = fac.userID            
                        INNER JOIN
                            <!--- Report By ---->
                            smg_users u ON sh.#FORM.reportBy# = u.userID
                        WHERE 
                            1 = 1
                         
                        <!--- Regional Advisors --->
                        <cfif LEN(vListOfAdvisorUsers)>
                            AND
                                (
                                    s.areaRepID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#vListOfAdvisorUsers#" list="yes"> )
                                OR
                                    s.placeRepID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#vListOfAdvisorUsers#" list="yes"> )
                                )
                        </cfif>    
                        
                        <!--- Student Status --->
                        <cfif FORM.studentStatus EQ 'Active'>
                            AND
                                s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                        <cfelseif FORM.studentStatus EQ 'Inactive'>
                            AND
                                s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                        <cfelseif FORM.studentStatus EQ 'Canceled'>
                            AND
                                s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                            AND
                                s.cancelDate IS NOT <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                        </cfif>
        
                        <!--- Placement Status --->
                        <cfif FORM.placementStatus EQ 'Placed'>
                            AND 
                                s.host_fam_approved IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4" list="yes"> )	
							<!---
                            AND
                                sh.datePlaced IS NOT NULL <!--- Approved Placements Only --->	
                            --->
                        <cfelseif FORM.placementStatus EQ 'Pending'>
                            AND 
                                s.host_fam_approved IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="5,6,7" list="yes"> )	
                        <cfelseif FORM.placementStatus EQ 'Rejected'>
                            AND 
                                s.host_fam_approved = <cfqueryparam cfsqltype="cf_sql_integer" value="99"> 	
                        <cfelse>
                            AND 
                                s.host_fam_approved IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,5,6,7,99" list="yes"> )	
                        </cfif>
                        
                        <!--- Paperwork Option --->
                        <cfif FORM.compliantOption EQ 'Missing'>
                            AND
                            	sh.isActive = 1
                            AND 
                                (
                                    sh.compliance_host_app_page1_date IS NULL 
                                OR 
                                    sh.compliance_host_app_page2_date IS NULL 
                                OR 
                                    sh.compliance_letter_rec_date IS NULL 
                                OR 
                                    sh.compliance_rules_rec_date IS NULL 
                                OR
                                    sh.compliance_rules_sign_date IS NULL
                                OR
                                    sh.compliance_photos_rec_date IS NULL 
                                OR 
                                    sh.compliance_school_accept_date IS NULL 
                                OR 
                                    sh.compliance_school_profile_rec IS NULL 
                                OR
                                    sh.compliance_conf_host_rec IS NULL 
                                OR 
                                    sh.compliance_date_of_visit IS NULL 
                                OR 
                                    sh.compliance_ref_form_1 IS NULL 
                                OR 
                                    sh.compliance_ref_form_2 IS NULL
                                OR 
                                    sh.stu_arrival_orientation IS NULL 
                                OR 
                                    sh.host_arrival_orientation IS NULL 
                                OR
                                    sh.compliance_income_ver_date IS NULL
                                OR
                                    sh.compliance_single_ref_check1 IS NULL
                                OR
                                    sh.compliance_single_ref_check2 IS NULL            
                                <!---  Second Visit Report - Check the report itself - OR s.doc_conf_host_rec2 IS NULL --->
                                OR
                                    secondVisitReport.pr_ny_approved_date IS NULL 
                                <!--- Added 02/27/2012 / Required starting Aug 12 --->     
                                OR
                                    sh.compliance_bedroom_photo IS NULL   
                                OR
                                    sh.compliance_bathroom_photo IS NULL   
                                OR
                                    sh.compliance_kitchen_photo IS NULL   
                                OR
                                    sh.compliance_living_room_photo IS NULL   
                                OR
                                    sh.compliance_outside_photo IS NULL   
                                )
                        </cfif>
                        
                        ORDER BY   
                            repName,          
                            studentName,
                            sh.dateCreated DESC  
                    ) AS T  
                    
                    WHERE
                        isActivePlacement = <cfqueryparam cfsqltype="cf_sql_bit" value="1"> 
                    OR
                        hostID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ValueList(qGetHostList.hostID)#" list="yes"> ) 
            </cfquery>

		</cfif> <!--- NOT SESSION.formErrors.length() ---->

	</cfif> <!--- FORM Submitted --->
    
</cfsilent>

<!--- FORM NOT submitted --->
<cfif NOT VAL(FORM.Submitted)>

    <!--- Call the basescript again so it works when ajax loads this page --->
    <script type="text/javascript" src="linked/js/basescript.js "></script> <!-- BaseScript -->

	<cfoutput>

        <form action="report/index.cfm?action=studentCompliancePaperwork" name="CompliancePaperwork" id="CompliancePaperwork" method="post" target="blank">
            <input type="hidden" name="submitted" value="1" />
            <table width="50%" cellpadding="4" cellspacing="0" class="blueThemeReportTable" align="center">
                <tr><th colspan="2">#vReportTitle#</th></tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Program: <span class="required">*</span></td>
                    <td>
                        <select name="programID" id="programID" class="xLargeField" multiple size="6" required>
                            <cfloop query="qGetProgramList"><option value="#qGetProgramList.programID#">#qGetProgramList.programName#</option></cfloop>
                        </select>
                    </td>
                </tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Region: <span class="required">*</span></td>
                    <td>
                        <select name="regionID" id="regionID" class="xLargeField" multiple size="6" required>
                            <cfloop query="qGetRegionList">
                            	<option value="#qGetRegionList.regionID#">
                                	<cfif CLIENT.companyID EQ 5>#qGetRegionList.companyShort# -</cfif>
                                    #qGetRegionList.regionname#
                                </option>
                            </cfloop>
                        </select>
                    </td>		
                </tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Student Status: <span class="required">*</span></td>
                    <td>
                        <select name="studentStatus" id="studentStatus" class="xLargeField" required>
                            <option value="Active">Active</option>
                            <option value="Inactive">Inactive</option>
                            <option value="Canceled">Canceled</option>
                            <option value="All">All</option>
                        </select>
                    </td>		
                </tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Placement Status: <span class="required">*</span></td>
                    <td>
                        <select name="placementStatus" id="placementStatus" class="xLargeField" onChange="showHidePlacementDates('PlacementPaperworkByRegion');" required>
                            <option value="Placed">Placed</option>
                            <option value="Pending">Pending</option>
                            <option value="Rejected">Rejected</option>
                            <option value="All">All</option>
                        </select>
                    </td>		
                </tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Placed From:</td>
                    <td><input type="text" name="placedDateFrom" id="placedDateFrom" value="" size="7" maxlength="10" class="datePicker"> <span class="note">mm-dd-yyyy</span></td>
                </tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Placed To: </td>
                    <td><input type="text" name="placedDateTo" id="placedDateTo" value="" size="7" maxlength="10" class="datePicker"> <span class="note">mm-dd-yyyy</span></td>
                </tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Paperwork Option: <span class="required">*</span></td>
                    <td>
                        <select name="compliantOption" id="compliantOption" class="xLargeField">
                            <!--- <option value="Comprehensive">Comprehensive Report</option> --->
                            <option value="Missing">Missing Paperwork</option>
                            <!---  <option value="Non-compliant">Non-compliant Paperwork</option> --->
                        </select>
                    </td>		
                </tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Report By: <span class="required">*</span></td>
                    <td>
                        <select name="reportBy" id="reportBy" class="xLargeField">
                            <option value="placeRepID">Placing Representative</option>
                            <option value="areaRepID">Supervising Representative</option>
                        </select>
                    </td>		
                </tr>                                    
                <tr class="on">
                    <td class="subTitleRightNoBorder">Output Type: <span class="required">*</span></td>
                    <td>
                        <select name="outputType" id="outputType" class="xLargeField">
                        	<option value="flashPaper">FlashPaper</option>
                            <option value="onScreen">On Screen</option>
                            <option value="Excel">Excel Spreadsheet</option>
                        </select>
                    </td>		
                </tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Email Regional Manager: <span class="required">*</span></td>
                    <td>
                        <input type="radio" name="sendEmail" id="sendEmailNo" value="0" checked="checked"> <label for="sendEmailNo">No</label>  
                        <input type="radio" name="sendEmail" id="sendEmailYes" value="1"> <label for="sendEmailYes">Yes</label>
                        <br /><font size="-2">Available only on screen option</font>
                    </td>
                </tr>
                <tr class="on">
                    <td>&nbsp;</td>
                    <td class="required noteAlert">* Required Fields</td>
                </tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Description:</td>
                    <td>
                        This report will provide you with a list, by student and HF, of any paperwork that has still not been received by your facilitator. 
                        This will include both current and previous placements. 
                    </td>		
                </tr>
                <tr>
                    <th colspan="2" align="center"><input type="image" src="pics/view.gif" align="center" border="0"> </th>
                </tr>
            </table>
        </form>            

	</cfoutput>

<cfelse>    

	<!--- Page Header --->
    <gui:pageHeader
        headerType="applicationNoHeader"
    />	

    <!--- FORM Submitted with errors --->
    <cfif SESSION.formErrors.length()> 
       
        <!--- Form Errors --->
        <gui:displayFormErrors 
            formErrors="#SESSION.formErrors.GetCollection()#"
            messageType="tableSection"
            width="100%"
            />	
            
		<cfabort>            
	</cfif>
    
    <!--- Output in Excel - Do not use GroupBy --->
    <cfif FORM.outputType EQ 'excel'>
        
        <!--- set content type --->
        <cfcontent type="application/msexcel">
        
        <!--- suggest default name for XLS file --->
        <cfheader name="Content-Disposition" value="attachment; filename=DOS-Placement-Paperwork-By-Region.xls"> 
        
        <table width="98%" cellpadding="4" cellspacing="0" align="center" border="1">
            <tr>
                <th colspan="12">#vReportTitle#</th>            
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
                <td>Host Family ID</td>
                <td>Host Family</td>
                <td>Date Placed</td>
                <td>Missing Documents</td>
            </tr>      
            
            <cfoutput query="qGetResults">
            
                <cfscript>
					// Set Variable to Handle Missing Documents
					vIsCompliant = 0;
					vMissingDocumentsMessage = '';
					vOutOfComplianceDocuments = '';
					
					// Treat all docs assoc with host app as one missing item.
                    vMissingDocumentsMessage = '';	
					
					vIsFatherHome = 0;
					vIsMotherHome = 0;
					vTotalFamilyMembers = 0;
					
					// Father is Home
					if ( LEN(qGetResults.fatherFirstName) ) {
						vIsFatherHome = 1;
					}
					
					if ( LEN(qGetResults.motherFirstName) ) {
						vIsMotherHome = 1;
					}
					
					vTotalFamilyMembers = vIsFatherHome + vIsMotherHome + qGetResults.totalChildrenAtHome;
	
					// Required for Single Parents 
					if ( vTotalFamilyMembers EQ 1 ) {  
						
						// Single Person Placement Verification
						if ( NOT isDate(qGetResults.compliance_single_place_auth) ) {
							vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Single Person Placement Verification <br />", " <br />");
						}
						
						// Date of S.P. Reference Check 1
						if ( NOT isDate(qGetResults.compliance_single_ref_check1) ) {
							vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Ref Check (Single) <br />", " <br />");
						}
	
						// Date of S.P. Reference Check 2
						if ( NOT isDate(qGetResults.compliance_single_ref_check2) ) {
							vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "2nd Ref Check (Single) <br />", " <br />");
						}
						
					}
	
					// Host Family Application p.1
					if ( NOT isDate(qGetResults.compliance_host_app_page1_date) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Host Family Application p.1 <br />", " <br />");
					}

					// Host Family Application p.2
					if ( NOT isDate(qGetResults.compliance_host_app_page2_date) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Host Family Application p.2 <br />", " <br />");
					}

					// Host Family Letter p.3
					if ( NOT isDate(qGetResults.compliance_letter_rec_date) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Host Family Letter p.3 <br />", " <br />");
					}
					
					// Host Family Rules Form
					if ( NOT isDate(qGetResults.compliance_rules_rec_date) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "HF Rules <br />", " <br />");
					}
					
					// Host Family Rules Date Signed
					if ( NOT isDate(qGetResults.compliance_rules_sign_date) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "HF Rules Date Signed <br />", " <br />");
					}		
					
					// Family Photo
					if ( NOT isDate(qGetResults.compliance_photos_rec_date) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Family Photo <br />", " <br />");
					}
	
					// Student Bedroom Photo
					if ( NOT isDate(qGetResults.compliance_bedroom_photo) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Student Bedroom Photo <br />", " <br />");
					}

					// Student Bathroom Photo
					if ( NOT isDate(qGetResults.compliance_bathroom_photo) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Student Bathroom Photo <br />", " <br />");
					}

					// Kitchen Photo
					if ( NOT isDate(qGetResults.compliance_kitchen_photo) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Kitchen Photo <br />", " <br />");
					}

					// Living Room Photo
					if ( NOT isDate(qGetResults.compliance_living_room_photo) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Living Room Photo <br />", " <br />");
					}
					
					// Outside Photo
					if ( NOT isDate(qGetResults.compliance_outside_photo) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Outside Photo <br />", " <br />");
					}
	
					// School & Community Profile Form
					if ( NOT isDate(qGetResults.compliance_school_profile_rec) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "School & Community Profile <br />", " <br />");
					}
					
					// Confidential Host Family Visit Form
					if ( NOT isDate(qGetResults.compliance_conf_host_rec) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Visit Form <br />", " <br />");
					}
					
					// Confidential Host Family Visit Form - Date of Visit
					if ( NOT isDate(qGetResults.compliance_date_of_visit) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Date of Visit <br />", " <br />");
					}
					
					// Reference Form 1
					if ( NOT isDate(qGetResults.compliance_ref_form_1) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Ref. 1 <br />", " <br />");
					}
					
					// Reference Form 2
					if ( NOT isDate(qGetResults.compliance_ref_form_2) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Ref. 2 <br />", " <br />");
					}
					
					// School Acceptance Form
					if ( NOT isDate(qGetResults.compliance_school_accept_date) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "School Acceptance <br />", " <br />");
					}								
	
					// Income Verification Form
					if ( NOT isDate(qGetResults.compliance_income_ver_date) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Income Verification <br />", " <br />");
					}
					
					// 2nd Confidential Host Family Visit Form
					if ( NOT isDate(qGetResults.pr_ny_approved_date) ) { 
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "2nd Conf. Host Visit <br />", " <br />");
					}
	
					// Student Orientation
					if ( NOT isDate(qGetResults.compliance_stu_arrival_orientation) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Student Orientation <br />", " <br />");
					}
					
					// HF Orientation
					if ( NOT isDate(qGetResults.compliance_host_arrival_orientation) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "HF Orientation <br />", " <br />");
					}
					
					
					// Check if is compliant
					/*
					if ( NOT LEN(vMissingDocumentsMessage) AND NOT LEN(vOutOfComplianceDocuments)  AND NOT LEN(vMissingDocumentsMessage)  ) {
						vIsCompliant = 1;
					}
					*/
					
					// Set Row Color
					if ( qGetResults.currentRow MOD 2 ) {
						vRowColor = 'bgcolor="##E6E6E6"';
					} else {
						vRowColor = 'bgcolor="##FFFFFF"';
					}
                </cfscript>
                
                <cfif LEN(vMissingDocumentsMessage)>
                
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
                        <td #vRowColor#>#qGetResults.hostID#</td>
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
                        <td #vRowColor#>#DateFormat(qGetResults.datePlaced, 'mm/dd/yy')#</td>
                        <td #vRowColor#>
                            <cfif VAL(vIsCompliant)>
                                compliant
                            <cfelse>
                            <Cfif len(vMissingDocumentsMessage)> Host Application &nbsp;&nbsp;&nbsp;&nbsp; </Cfif>
                                #vMissingDocumentsMessage#
                                
                                #vOutOfComplianceDocuments#
                            </cfif>
                        </td>
                    </tr>
           	
            	</cfif>
            
            </cfoutput>
    
        </table>
    
    <!--- On Screen Report --->
    <cfelse>
    
        <cfoutput>
        
            <!--- Store Report Header in a Variable --->
            <cfsavecontent variable="reportHeader">
                
                <!--- Run Report --->
                <table width="95%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                    <tr>
                        <th>#vReportTitle#</th>            
                    </tr>
                    <tr>
                        <td class="center">
                            Program(s) included in this report: <br />
                            <cfloop query="qGetPrograms">
                                #qGetPrograms.programName# <br />
                            </cfloop>
                            
                            Student Status: #FORM.studentStatus# <br />
                            
                            Placement Status: #FORM.placementStatus# <br />
                            
                            <cfif isDate(FORM.placedDateFrom) AND isDate(FORM.placedDateTo)>
	                            Placed From #FORM.placedDateFrom# to #FORM.placedDateTo# <br />
							</cfif>
                            
                            Paperwork Option: #FORM.compliantOption# <br />
                        </td>
                    </tr>
                </table><br />
            
            </cfsavecontent>
        
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
                    
                    <cfscript>
						if ( ListFirst(FORM.regionID) EQ currentRegionID ) {
							vTableClass = 'blueThemeReportTable';
						} else {						
							vTableClass = 'blueThemeReportTableNewSection';
						}
					</cfscript>
                    
                    <table width="95%" cellpadding="4" cellspacing="0" align="center" class="#vTableClass#">
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
    
                    <table width="95%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
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
                            <td class="subTitleLeft" width="20%" style="font-size:9px">Student</td>
                            <td class="subTitleLeft" width="10%" style="font-size:9px">Program</td>
                            <td class="subTitleLeft" width="15%" style="font-size:9px">Host Family</td>
                            <td class="subTitleCenter" width="10%" style="font-size:9px">Date Placed</td>
                            <td class="subTitleLeft" width="45%" style="font-size:9px">Missing Documents</td>
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
                                vIsCompliant = 0;
								vMissingDocumentsMessage = '';
                                vOutOfComplianceDocuments = '';

								// Treat all docs assoc with host app as one missing item.
                    			vMissingDocumentsMessage = '';	
					
                                vIsFatherHome = 0;
                                vIsMotherHome = 0;
                                vTotalFamilyMembers = 0;
								
                                // Father is Home
                                if ( LEN(qGetStudentsInRegion.fatherFirstName) ) {
                                    vIsFatherHome = 1;
                                }
                                
                                if ( LEN(qGetStudentsInRegion.motherFirstName) ) {
                                    vIsMotherHome = 1;
                                }
                                
                                vTotalFamilyMembers = vIsFatherHome + vIsMotherHome + qGetStudentsInRegion.totalChildrenAtHome;

                                // Required for Single Parents 
                                if ( vTotalFamilyMembers EQ 1 ) {  
                                    
									// Single Person Placement Verification
									if ( NOT isDate(qGetStudentsInRegion.compliance_single_place_auth) ) {
                                    	vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Single Person Placement Verification &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                	}
									
									// Date of S.P. Reference Check 1
									if ( NOT isDate(qGetStudentsInRegion.compliance_single_ref_check1) ) {
										vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Ref Check (Single) &nbsp; &nbsp;", " &nbsp; &nbsp;");
									}

									// Date of S.P. Reference Check 2
                                    if ( NOT isDate(qGetStudentsInRegion.compliance_single_ref_check2) ) {
                                        vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "2nd Ref Check (Single) &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                    }
									
                                }

                                // Host App Page 1
                                if ( NOT isDate(qGetStudentsInRegion.compliance_host_app_page1_date) ) {
                                    vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Host App Page 1 &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                }

                                // Host App Page 2
                                if ( NOT isDate(qGetStudentsInRegion.compliance_host_app_page2_date) ) {
                                    vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Host App Page 2 &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                }
								
                                // Host Family Letter
                                if ( NOT isDate(qGetStudentsInRegion.compliance_letter_rec_date) ) {
                                    vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "HF Letter &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                }
								
                                // Host Family Rules Form
                                if ( NOT isDate(qGetStudentsInRegion.compliance_rules_rec_date) ) {
                                    vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "HF Rules &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                }
								
                                // Host Family Rules Date Signed
                                if ( NOT isDate(qGetStudentsInRegion.compliance_rules_sign_date) ) {
                                    vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "HF Rules Date Signed &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                }		
								
                                // Family Photo
                                if ( NOT isDate(qGetStudentsInRegion.compliance_photos_rec_date) ) {
                                    vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Family Photo &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                }

								// Student Bedroom Photo
								if ( NOT isDate(qGetStudentsInRegion.compliance_bedroom_photo) ) {
									vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Student Bedroom Photo &nbsp; &nbsp;", " &nbsp; &nbsp;");
								}

								// Student Bathroom Photo
								if ( NOT isDate(qGetStudentsInRegion.compliance_bathroom_photo) ) {
									vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Student Bathroom Photo &nbsp; &nbsp;", " &nbsp; &nbsp;");
								}

								// Kitchen Photo
								if ( NOT isDate(qGetStudentsInRegion.compliance_kitchen_photo) ) {
									vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Kitchen Photo &nbsp; &nbsp;", " &nbsp; &nbsp;");
								}

								// Living Room Photo
								if ( NOT isDate(qGetStudentsInRegion.compliance_living_room_photo) ) {
									vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Living Room Photo &nbsp; &nbsp;", " &nbsp; &nbsp;");
								}
								
								// Outside Photo
								if ( NOT isDate(qGetStudentsInRegion.compliance_outside_photo) ) {
									vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Outside Photo &nbsp; &nbsp;", " &nbsp; &nbsp;");
								}

                                // School & Community Profile Form
                                if ( NOT isDate(qGetStudentsInRegion.compliance_school_profile_rec) ) {
                                    vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "School & Community Profile &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                }
								
                                // Confidential Host Family Visit Form
                                if ( NOT isDate(qGetStudentsInRegion.compliance_conf_host_rec) ) {
                                    vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Visit Form &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                }
								
                                // Confidential Host Family Visit Form - Date of Visit
                                if ( NOT isDate(qGetStudentsInRegion.compliance_date_of_visit) ) {
                                    vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Date of Visit &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                }
								
                                // Reference Form 1
                                if ( NOT isDate(qGetStudentsInRegion.compliance_ref_form_1) ) {
                                    vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Ref. 1 &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                }
								
                                // Reference Form 2
                                if ( NOT isDate(qGetStudentsInRegion.compliance_ref_form_2) ) {
                                    vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Ref. 2 &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                }
								
                                // School Acceptance Form
                                if ( NOT isDate(qGetStudentsInRegion.compliance_school_accept_date) ) {
                                    vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "School Acceptance &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                }								

								// Income Verification Form
								if ( NOT isDate(qGetStudentsInRegion.compliance_income_ver_date) ) {
									vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Income Verification &nbsp; &nbsp;", " &nbsp; &nbsp;");
								}
								
								// 2nd Confidential Host Family Visit Form
								if ( NOT isDate(qGetStudentsInRegion.pr_ny_approved_date) ) { 
									vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "2nd Conf. Host Visit &nbsp; &nbsp;", " &nbsp; &nbsp;");
								}

                                // Student Orientation
                                if ( NOT isDate(qGetStudentsInRegion.compliance_stu_arrival_orientation) ) {
                                    vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Student Orientation &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                }
								
                                // HF Orientation
                                if ( NOT isDate(qGetStudentsInRegion.compliance_host_arrival_orientation) ) {
                                    vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "HF Orientation &nbsp; &nbsp;", " &nbsp; &nbsp;");
                                }
								
                                // Check if is compliant
                                /*
								if ( NOT LEN(vMissingDocumentsMessage) AND NOT LEN(vOutOfComplianceDocuments) AND NOT LEN(vMissingDocumentsMessage) ) {
                                    vIsCompliant = 1;
                                }
								*/
                            </cfscript>
                            
                            <cfif LEN(vMissingDocumentsMessage)>
                            
                                <tr class="#iif(vCurrentRow MOD 2 ,DE("off") ,DE("on") )#">
                                    <td style="font-size:9px">
                                        #qGetStudentsInRegion.studentName#
                                        <cfif VAL(qGetStudentsInRegion.active)>
                                            <span class="note">(Active)</span>
                                        <cfelseif isDate(qGetStudentsInRegion.cancelDate)>
                                            <span class="noteAlert">(Cancelled)</span>
                                        <cfelseif NOT VAL(qGetStudentsInRegion.active)>
                                            <span class="note">(Inactive)</span>
                                        </cfif>
                                    </td>
                                    <td style="font-size:9px">#qGetStudentsInRegion.programName#</td>
                                    <td style="font-size:9px">
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
                                    </td>
                                    <td class="center" style="font-size:9px">#DateFormat(qGetStudentsInRegion.datePlaced, 'mm/dd/yy')#</td>
                                    <td style="font-size:9px">
                                        <cfif VAL(vIsCompliant)>
                                            compliant
                                        <cfelse>
                                       	
                                            #vMissingDocumentsMessage#
                                            
                                            #vOutOfComplianceDocuments#
                                        </cfif>
                                    </td>
                                </tr>
            			
                        	</cfif>
                        
                        </cfoutput>
                    
                    </table>
            
                </cfoutput>
            
            </cfsavecontent>
            
            <cfoutput>
            
            	<cfif FORM.outputType EQ "flashPaper">
    
                    <cfdocument format="flashpaper" orientation="landscape" backgroundvisible="yes" overwrite="yes" fontembed="yes" margintop="0.3" marginright="0.2" marginbottom="0.3" marginleft="0.2">
            
                        <!--- Page Header --->
                        <gui:pageHeader
                            headerType="applicationNoHeader"
                            filePath="../"
                        />
                        
                        <cfoutput>
                    		#reportBody#
						</cfoutput>
                        
                    </cfdocument>
                    
                <cfelse>
                
                    <cfoutput>
                    	#reportBody# 
					</cfoutput>
                    
                </cfif>
        
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
                                    <cfinclude template="../../linked/css/baseStyle.css">
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
                        <cfinvokeargument name="email_subject" value="#CLIENT.companyshort# - Missing Placement Paperwork Report">
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
    
</cfif>    