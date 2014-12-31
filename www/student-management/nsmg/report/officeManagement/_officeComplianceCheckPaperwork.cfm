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
		param name="FORM.placedDateFrom" default="";
		param name="FORM.placedDateTo" default="";
		param name="FORM.isRecordNoteIncluded" default=0;
		param name="FORM.outputType" default="flashPaper";

		// Set Report Title To Keep Consistency
		vReportTitle = "Office Management - Compliance Check Placement Paperwork";

		// PS: smg_hosthistory is already taken by the placement history so I set table name as smg_hosthistorycompliance
		vComplianceTableName = "smg_hosthistorycompliance";

		// Get Programs
		qGetPrograms = APPLICATION.CFC.PROGRAM.getPrograms(programIDList=FORM.programID);
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
        
            <cfquery name="qGetResults" datasource="#APPLICATION.DSN#">
                SELECT 
                	*,
                    (isFatherHome + isMotherHome + totalChildrenAtHome) AS totalFamilyMembers
                FROM 
                (
                    SELECT 
						s.studentID,
                        s.firstName,
                        s.familyLastName,
                        CAST(CONCAT(s.firstName, ' ', s.familyLastName,  ' ##', s.studentID) AS CHAR) AS studentName,
                        s.active,
                        s.cancelDate,
                        sh.historyID,
                        sh.areaRepID,
                        sh.placeRepID,
                        sh.isRelocation,
                        sh.isWelcomeFamily,
                        sh.isActive AS isActivePlacement,
                        sh.datePlaced,
                        sh.dateCreated,
                        <!--- Single Placement --->
                        sh.compliance_single_place_auth,
                        sh.compliance_single_ref_form_1,
                        sh.compliance_single_ref_check1,
                        sh.compliance_single_ref_form_2,
                        sh.compliance_single_ref_check2,              
                        sh.compliance_single_parents_sign_date,
                        sh.compliance_single_student_sign_date,
                        <!--- Page 1 --->
                        sh.compliance_host_app_page1_date,
                        <!--- Page 2 --->
                        sh.compliance_host_app_page2_date,
                        <!--- Page 3 - Letter --->
                        sh.compliance_letter_rec_date, 
                        <!--- Page 4,5,6 - Photos --->
                        sh.compliance_photos_rec_date,
                        sh.compliance_bedroom_photo,
                        sh.compliance_bathroom_photo,
                        sh.compliance_kitchen_photo,
                        sh.compliance_living_room_photo,
                        sh.compliance_outside_photo,
                        <!--- Page 7 - HF Rules --->
                        sh.compliance_rules_rec_date, 
                        sh.compliance_rules_sign_date,
                        <!--- Page 8 - School & Community Profile ---> 
                        sh.compliance_school_profile_rec,
                        <!--- Page 9 - Income Verification --->
                        sh.compliance_income_ver_date,
                        <!--- Page 10 - Confidential HF Visit ---> 
                        sh.compliance_conf_host_rec, 
                        sh.compliance_date_of_visit,                     
                        <!--- Page 11 - Reference 1 ---> 
                        sh.compliance_ref_form_1, 
                        sh.compliance_ref_check1,
                        <!--- Page 12 - Reference 2 ---> 
                        sh.compliance_ref_form_2, 
                        sh.compliance_ref_check2,
                        <!--- Arrival Compliance --->
                        sh.compliance_school_accept_date, 
                        sh.compliance_school_sign_date,
                        <!--- Arrival Orientation --->
                        sh.compliance_stu_arrival_orientation,
                        sh.compliance_host_arrival_orientation,
                 <!---       sh.compliance_class_schedule, --->
                        <!--- Second Visit Date Compliance --->
                        sva.dateCompliance,
                        <!--- CBC Compliance --->
                        
                        <!--- Double Placement Compliance --->
                        sht.fieldID AS doublePlacementID,
                        sht.doublePlacementParentsDateCompliance,
                        sht.doublePlacementStudentDateCompliance,
                        sht.doublePlacementHostFamilyDateCompliance,
                        <!--- Program --->
                        p.programName,
                        <!--- Host Family --->
                        h.hostID,             
                        h.familyLastName as hostFamilyLastName,
                        (
                            CASE 
                                WHEN 
                                    fatherFirstName != '' 
                                THEN 
                                    1
                                WHEN 	
                                    fatherFirstName = ''  
                                THEN 
                                    0
                            END
                        ) AS isFatherHome,
                        (
                            CASE 
                                WHEN 
                                    motherFirstName != '' 
                                THEN 
                                    1
                                WHEN 	
                                    motherFirstName = ''  
                                THEN 
                                    0                               
                            END
                        ) AS isMotherHome,
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
                        CONCAT(fac.firstName, ' ', fac.lastName) AS facilitatorName
                    FROM 
                        smg_students s
                    INNER JOIN
                        smg_hosthistory sh ON sh.studentID = s.studentID
						<!--- Date Placed --->
                        <cfif isDate(FORM.placedDateFrom) AND isDate(FORM.placedDateTo)>
                            AND 
                                sh.datePlaced
                                BETWEEN 
                                    <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.placedDateFrom#"> 	
                                AND
                                    <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d', 1, FORM.placedDateTo)#"> 	
                        </cfif>
                    <!--- Program --->
                    INNER JOIN
                        smg_programs p on p.programID = s.programID
                        AND
                            p.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> ) 
                    <!--- Host --->
                    INNER JOIN
                        smg_hosts h ON h.hostID = sh.hostID
                    <!--- Region --->
                    INNER JOIN
                        smg_regions r ON r.regionID = s.regionAssigned
                        AND
                            r.regionID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionID#" list="yes"> ) 
                    <!--- User - Facilitator --->
                    INNER JOIN 
                        smg_users fac ON r.regionFacilitator = fac.userID            
					<!--- Second Visit Report - Check the report itself and not the fields on placement paperwork --->
                    LEFT OUTER JOIN 
                        progress_reports secondVisitReport ON secondVisitReport.fk_student = s.studentID
                            AND
                                secondVisitReport.fk_host = sh.hostID
                            AND
                                secondVisitReport.fk_reporttype = <cfqueryparam cfsqltype="cf_sql_integer" value="2">
                    <!--- Second Visit Answer --->
                    LEFT OUTER JOIN
                        secondvisitanswers sva ON sva.fk_reportID = secondVisitReport.pr_ID
                    <!--- Double Placement Compliance --->
                    LEFT OUTER JOIN
                    	smg_hosthistorytracking sht ON sht.historyID = sh.historyID
                        AND
                        	fieldName = <cfqueryparam cfsqltype="cf_sql_varchar" value="doublePlacementID">
                        AND
                        	isDoublePlacementPaperworkRequired = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                    WHERE 
                        s.host_fam_approved IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4" list="yes"> )	
                        
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
                            s.cancelDate IS NOT NULL
					</cfif>

                    <!--- Only Include Records With Notes --->
                    <cfif VAL(FORM.isRecordNoteIncluded)>
						AND
                             sh.historyID IN (
                                SELECT
                                    foreignID
                                FROM
                                    applicationhistory
                                WHERE
                                    foreignTable = <cfqueryparam cfsqltype="cf_sql_varchar" value="smg_hosthistorycompliance">
                                AND
                                    foreignID = sh.historyID
                                AND
                                    isResolved = <cfqueryparam cfsqltype="cf_sql_bit" value="0">                         
                             )   
                    </cfif>
                    
				) AS tmpTable
            
                WHERE
					<!--- Page 1 --->
                        compliance_host_app_page1_date IS NULL 
                    <!--- Page 2 --->
                    OR
                        compliance_host_app_page2_date IS NULL 
                    <!--- Page 3 - Letter --->
                    OR
                        compliance_letter_rec_date IS NULL  
                    <!--- Page 4,5,6 - Photos --->
                    OR
                        compliance_photos_rec_date IS NULL 
                    OR
                        compliance_bedroom_photo IS NULL 
                    OR
                        compliance_bathroom_photo IS NULL 
                    OR
                        compliance_kitchen_photo IS NULL 
                    OR
                        compliance_living_room_photo IS NULL 
                    OR
                        compliance_outside_photo IS NULL 
					<!--- Page 7 - HF Rules --->
                    OR
                        compliance_rules_rec_date IS NULL 
                    OR
                        compliance_rules_sign_date IS NULL 
                    <!--- Page 8 - School & Community Profile ---> 
                    OR                    
                        compliance_school_profile_rec IS NULL 
                    <!--- Page 9 - Income Verification --->
                    OR
                        compliance_income_ver_date IS NULL 
                    <!--- Page 10 - Confidential HF Visit ---> 
                    OR
                        compliance_conf_host_rec IS NULL  
                    OR
                        compliance_date_of_visit IS NULL                      
                    <!--- Page 11 - Reference 1 ---> 
                    OR
                        compliance_ref_form_1 IS NULL 
                    OR
                        compliance_ref_check1 IS NULL 
                    <!--- Page 12 - Reference 2 ---> 
                    OR
                        compliance_ref_form_2 IS NULL  
                    OR
                        compliance_ref_check2 IS NULL 
                    <!--- Arrival Compliance --->
                    OR
                        compliance_school_accept_date IS NULL  
                    OR
                        compliance_school_sign_date IS NULL 
                    <!--- Arrival Orientation --->
                    OR
                        compliance_stu_arrival_orientation IS NULL 
                    OR
                        compliance_host_arrival_orientation IS NULL 
                    OR
<!---                        compliance_class_schedule IS NULL ---> 
                    <!--- Second Visit Date Compliance --->
                        dateCompliance IS NULL 
                        
                    <!--- Get Pending Notes --->    
                    <cfif NOT VAL(FORM.isRecordNoteIncluded)>
                    OR
                    	 historyID IN (
                         	SELECT
                            	foreignID
                            FROM
                            	applicationhistory
                            WHERE
                            	foreignTable = <cfqueryparam cfsqltype="cf_sql_varchar" value="smg_hosthistorycompliance">
                            AND
                            	foreignID = historyID
							AND
                            	isResolved = <cfqueryparam cfsqltype="cf_sql_bit" value="0">                         
                         )   
                    </cfif>
                    
					<!--- Single Placement --->
                    OR 
                    	(
                    		(isFatherHome + isMotherHome + totalChildrenAtHome) = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                         AND	
                         	(
                                compliance_single_place_auth IS NULL  
                             OR   
                                compliance_single_ref_form_1 IS NULL  
                             OR   
                                compliance_single_ref_check1 IS NULL  
                             OR   
                                compliance_single_ref_form_2 IS NULL  
                             OR   
                                compliance_single_ref_check2 IS NULL  
                             OR   
                                compliance_single_parents_sign_date IS NULL  
                             OR   
                                compliance_single_student_sign_date IS NULL  
                        	)
                    	)
                    
                    <!--- CBC Compliance --->
                        
					<!--- Double Placement --->
                    OR 
                    	(
                    		doublePlacementID != <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                         AND	
                         	(
                                doublePlacementParentsDateCompliance IS NULL  
                             OR   
                                doublePlacementStudentDateCompliance IS NULL  
                             OR   
                                doublePlacementHostFamilyDateCompliance IS NULL  
                        	)
                    	)

                ORDER BY   
                    studentName,
                    dateCreated DESC            
            </cfquery>
            
		</cfif> <!--- NOT SESSION.formErrors.length() ---->

	</cfif> <!--- FORM Submitted --->
    
</cfsilent>

<!--- FORM NOT submitted --->
<cfif NOT VAL(FORM.Submitted)>

    <!--- Call the basescript again so it works when ajax loads this page --->
    <script type="text/javascript" src="linked/js/basescript.js "></script> <!-- BaseScript -->

	<cfoutput>

        <form action="report/index.cfm?action=officeComplianceCheckPaperwork" name="officeComplianceCheckPaperwork" id="officeComplianceCheckPaperwork" method="post" target="blank">
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
                    <td class="subTitleRightNoBorder">Placed From:</td>
                    <td><input type="text" name="placedDateFrom" id="placedDateFrom" value="" size="7" maxlength="10" class="datePicker"> <span class="note">mm-dd-yyyy</span></td>
                </tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Placed To: </td>
                    <td><input type="text" name="placedDateTo" id="placedDateTo" value="" size="7" maxlength="10" class="datePicker"> <span class="note">mm-dd-yyyy</span></td>
                </tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Options:</td>
                    <td>
                    	<input type="checkbox" name="isRecordNoteIncluded" id="isRecordNoteIncluded" value="1" checked="checked" /> 
                    	<label for="isRecordNoteIncluded">Include Only Records with Notes</label> 
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
                <td>Student ID</td>
                <td>Student First Name</td>
                <td>Student Last Name</td>
                <td>Program</td>
                <td>Placement Date</td>
                <td>Missing Documents Review</td>
                <td>Notes</td>
            </tr>      
            
            <cfoutput query="qGetResults">
            
                <cfscript>
					// Get Compliance Log
					qGetComplianceHistory = APPLICATION.CFC.LOOKUPTABLES.getApplicationHistory(
						applicationID=APPLICATION.CONSTANTS.TYPE.EXITS,																				   
						foreignTable=vComplianceTableName,
						foreignID=qGetResults.historyID,
						isResolved=0
					);
				
					// Set Variable to Handle Missing Documents Review
					vMissingDocumentsMessage = '';

					// Required for Single Parents 
					if ( qGetResults.totalFamilyMembers EQ 1 ) {  
						
						// Single Person Placement Verification
						if ( NOT isDate(qGetResults.compliance_single_place_auth) ) {
							vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Single Person Placement Verification <br />", " <br />");
						}
	
						// Natural Family Date Signed
						if ( NOT isDate(qGetResults.compliance_single_parents_sign_date) ) {
							vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Natural Family Date Signed <br />", " <br />");
						}
	
						// Student Date Signed
						if ( NOT isDate(qGetResults.compliance_single_student_sign_date) ) {
							vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Student Date Signed <br />", " <br />");
						}
						
						// Single Person Placement Ref. 1
						if ( NOT isDate(qGetResults.compliance_single_ref_form_1) ) {
							vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Single Person Placement Ref. 1 <br />", " <br />");
						}
	
						// Date of Single Placement Ref. Check 1
						if ( NOT isDate(qGetResults.compliance_single_ref_check1) ) {
							vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Date of Single Placement Ref. Check 1 <br />", " <br />");
						}
	
						// Single Person Placement Ref. 1
						if ( NOT isDate(qGetResults.compliance_single_ref_form_2) ) {
							vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Single Person Placement Ref. 2 <br />", " <br />");
						}
	
						// Date of Single Placement Ref. Check 1
						if ( NOT isDate(qGetResults.compliance_single_ref_check2) ) {
							vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Date of Single Placement Ref. Check 2 <br />", " <br />");
						}
						
					}

					// Page 1 - Host Family App p.1
					if ( NOT isDate(qGetResults.compliance_host_app_page1_date) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Host Family App p.1 <br />", " <br />");
					}

					// Page 2 - Host Family App p.2
					if ( NOT isDate(qGetResults.compliance_host_app_page2_date) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Host Family App p.2 <br />", " <br />");
					}

					// Page 3 - Host Family Letter p.3
					if ( NOT isDate(qGetResults.compliance_letter_rec_date) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Host Family Letter p.3 <br />", " <br />");
					}

					// Page 4,5,6 - Family Photo
					if ( NOT isDate(qGetResults.compliance_photos_rec_date) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Family Photo <br />", " <br />");
					}
	
					// Page 4,5,6 - Student Bedroom Photo
					if ( NOT isDate(qGetResults.compliance_bedroom_photo) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Student Bedroom Photo <br />", " <br />");
					}

					// Page 4,5,6 - Student Bathroom Photo
					if ( NOT isDate(qGetResults.compliance_bathroom_photo) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Student Bathroom Photo <br />", " <br />");
					}

					// Page 4,5,6 - Kitchen Photo
					if ( NOT isDate(qGetResults.compliance_kitchen_photo) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Kitchen Photo <br />", " <br />");
					}

					// Page 4,5,6 - Living Room Photo
					if ( NOT isDate(qGetResults.compliance_living_room_photo) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Living Room Photo <br />", " <br />");
					}
					
					// Page 4,5,6 - Outside Photo
					if ( NOT isDate(qGetResults.compliance_outside_photo) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Outside Photo <br />", " <br />");
					}

					// Page 7 - Host Family Rules Form
					if ( NOT isDate(qGetResults.compliance_rules_rec_date) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "HF Rules <br />", " <br />");
					}
					
					// Page 7 - Host Family Rules Date Signed
					if ( NOT isDate(qGetResults.compliance_rules_sign_date) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "HF Rules Date Signed <br />", " <br />");
					}		
					
					// Page 8 - School & Community Profile Form
					if ( NOT isDate(qGetResults.compliance_school_profile_rec) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "School & Community Profile <br />", " <br />");
					}
					
					// Page 9 - Income Verification Form
					if ( NOT isDate(qGetResults.compliance_income_ver_date) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Income Verification <br />", " <br />");
					}
					
					// Page 10 - Confidential Host Family Visit Form
					if ( NOT isDate(qGetResults.compliance_conf_host_rec) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Visit Form <br />", " <br />");
					}
					
					// Page 10 - Confidential Host Family Visit Form - Date of Visit
					if ( NOT isDate(qGetResults.compliance_date_of_visit) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Date of Visit <br />", " <br />");
					}
					
					// Page 11 - Ref. Form 1
					if ( NOT isDate(qGetResults.compliance_ref_form_1) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Ref. 1 <br />", " <br />");
					}
					
					// Page 11 - Ref. Check 1
					if ( NOT isDate(qGetResults.compliance_ref_check1) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Ref. Check 1 <br />", " <br />");
					}

					// Page 12 - Ref. Form 2
					if ( NOT isDate(qGetResults.compliance_ref_form_2) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Ref. 2 <br />", " <br />");
					}
					
					// Page 12 - Ref. Check 2
					if ( NOT isDate(qGetResults.compliance_ref_check2) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Ref. Check 2 <br />", " <br />");
					}
					
					// Arrival Compliance - School Acceptance Form
					if ( NOT isDate(qGetResults.compliance_school_accept_date) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "School Acceptance <br />", " <br />");
					}								

					// Arrival Compliance - School Acceptance Date of Signature
					if ( NOT isDate(qGetResults.compliance_school_sign_date) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "School Acceptance Signature <br />", " <br />");
					}								

					// Arrival Orientation - Student Orientation
					if ( NOT isDate(qGetResults.compliance_stu_arrival_orientation) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Student Orientation <br />", " <br />");
					}
					
					// Arrival Orientation - HF Orientation
					if ( NOT isDate(qGetResults.compliance_host_arrival_orientation) ) {
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "HF Orientation <br />", " <br />");
					}
					
					// Arrival Orientation - Class Schedule
					//if ( NOT isDate(qGetResults.compliance_class_schedule) ) {
						//vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Class Schedule <br />", " <br />");
					//} 

					// 2nd Confidential Host Family Visit Form
					if ( NOT isDate(qGetResults.dateCompliance) ) { 
						vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "2nd Conf. Host Visit <br />", " <br />");
					}
					
					// CBC Compliance
					
					// Double Placement Compliance
					if ( VAL(qGetResults.doublePlacementID) ) {
						
						// DP Natural Family Date Signed
						if ( NOT isDate(qGetResults.doublePlacementParentsDateCompliance) ) { 
							vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "DP Natural Family Date Signed <br />", " <br />");
						}

						// DP Natural Family Date Signed
						if ( NOT isDate(qGetResults.doublePlacementStudentDateCompliance) ) { 
							vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "DP Student Date Signed <br />", " <br />");
						}

						// DP Natural Family Date Signed
						if ( NOT isDate(qGetResults.doublePlacementHostFamilyDateCompliance) ) { 
							vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "DP Host Family Date Signed <br />", " <br />");
						}

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
                    <td #vRowColor#>#qGetResults.studentID#</td>
                    <td #vRowColor#>#qGetResults.firstName#</td>
                    <td #vRowColor#>#qGetResults.familyLastName#</td>  
                    <td #vRowColor#>#qGetResults.programName#</td>
                    <td #vRowColor#>#DateFormat(qGetResults.datePlaced, 'mm/dd/yy')#</td> 
                    <td #vRowColor#>#vMissingDocumentsMessage#</td>
                    <td #vRowColor#>
                        <cfloop query="qGetComplianceHistory">
                            <p>#qGetComplianceHistory.actions#</p>			                                    
                        </cfloop>
                    </td>
                </tr>
           
            </cfoutput>
    
        </table>
    
    <!--- On Screen Report --->
    <cfelse>
    
    	<cfsavecontent variable="report">
    
			<cfoutput>
            
                <!--- Store Report Header in a Variable --->
                <cfsavecontent variable="reportHeader">
                    
                    <!--- Run Report --->
                    <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
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
    
                                <cfif isDate(FORM.placedDateFrom) AND isDate(FORM.placedDateTo)>
                                    Placed From #FORM.placedDateFrom# to #FORM.placedDateTo# <br />
                                </cfif>
                            </td>
                        </tr>
                    </table><br />
                
                </cfsavecontent>
            
                <!--- Display Report Header --->
                #reportHeader#
            
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
        
                    <!--- Save Report in a Variable --->
                    <cfsavecontent variable="reportBody">
            
                        <cfoutput>
                            
                            <cfscript>
                                if ( ListFirst(FORM.regionID) EQ currentRegionID ) {
                                    vTableClass = 'blueThemeReportTable';
                                } else {						
                                    vTableClass = 'blueThemeReportTableNewSection';
                                }
                            </cfscript>
                            
                            <table width="98%" cellpadding="4" cellspacing="0" align="center" class="#vTableClass#">
                                <tr>
                                    <th class="left">
                                        #qGetStudentsInRegion.regionName#
                                        &nbsp; - &nbsp; 
                                        Facilitator - #qGetStudentsInRegion.facilitatorName#
                                    </th>
                                </tr>      
                            </table>
                        
                        </cfoutput>
                        
                        <cfoutput query="qGetStudentsInRegion" group="regionID">
            
                            <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                                <tr class="on">
                                    <td class="subTitleLeft" width="12%" style="font-size:9px">Student</td>
                                    <td class="subTitleLeft" width="8%" style="font-size:9px">Program</td>
                                    <td class="subTitleLeft" width="8%" style="font-size:9px">Date Placement</td>
                                    <td class="subTitleLeft" width="12%" style="font-size:9px">Host Family</td>
                                    <td class="subTitleLeft" width="35%" style="font-size:9px">Missing Documents Review</td>
                                    <td class="subTitleLeft" width="25%" style="font-size:9px">Notes</td>
                                </tr>      
                                
                                <cfscript>
                                    // Set Current Row
                                    vCurrentRow = 0;			
                                </cfscript>
                                
                                <!--- Loop Through Query --->
                                <cfoutput>
                                    
                                    <cfscript>
                                        // Get Compliance Log
                                        qGetComplianceHistory = APPLICATION.CFC.LOOKUPTABLES.getApplicationHistory(
                                            applicationID=APPLICATION.CONSTANTS.TYPE.EXITS,																				   
                                            foreignTable=vComplianceTableName,
                                            foreignID=qGetStudentsInRegion.historyID,
                                            isResolved=0
                                        );
                                    
                                        // Increase Current Row
                                        vCurrentRow ++;
                                        
                                        // Set Variable to Handle Missing Documents Review
                                        vMissingDocumentsMessage = '';
        
                                        // Required for Single Parents 
                                        if ( qGetStudentsInRegion.totalFamilyMembers EQ 1 ) {  
                                            
                                            // Single Person Placement Verification
                                            if ( NOT isDate(qGetStudentsInRegion.compliance_single_place_auth) ) {
                                                vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Single Person Placement Verification &nbsp; - &nbsp;", " &nbsp; - &nbsp;");
                                            }
        
                                            // Natural Family Date Signed
                                            if ( NOT isDate(qGetStudentsInRegion.compliance_single_parents_sign_date) ) {
                                                vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Natural Family Date Signed &nbsp; - &nbsp;", " &nbsp; - &nbsp;");
                                            }
        
                                            // Student Date Signed
                                            if ( NOT isDate(qGetStudentsInRegion.compliance_single_student_sign_date) ) {
                                                vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Student Date Signed &nbsp; - &nbsp;", " &nbsp; - &nbsp;");
                                            }
                                            
                                            // Single Person Placement Ref. 1
                                            if ( NOT isDate(qGetStudentsInRegion.compliance_single_ref_form_1) ) {
                                                vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Single Person Placement Ref. 1 &nbsp; - &nbsp;", " &nbsp; - &nbsp;");
                                            }
        
                                            // Date of Single Placement Ref. Check 1
                                            if ( NOT isDate(qGetStudentsInRegion.compliance_single_ref_check1) ) {
                                                vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Date of Single Placement Ref. Check 1 &nbsp; - &nbsp;", " &nbsp; - &nbsp;");
                                            }
        
                                            // Single Person Placement Ref. 1
                                            if ( NOT isDate(qGetStudentsInRegion.compliance_single_ref_form_2) ) {
                                                vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Single Person Placement Ref. 2 &nbsp; - &nbsp;", " &nbsp; - &nbsp;");
                                            }
        
                                            // Date of Single Placement Ref. Check 1
                                            if ( NOT isDate(qGetStudentsInRegion.compliance_single_ref_check2) ) {
                                                vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Date of Single Placement Ref. Check 2 &nbsp; - &nbsp;", " &nbsp; - &nbsp;");
                                            }
                                            
                                        }
        
                                        // Page 1 - Host Family App p.1
                                        if ( NOT isDate(qGetStudentsInRegion.compliance_host_app_page1_date) ) {
                                            vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Host Family App p.1 &nbsp; - &nbsp;", " &nbsp; - &nbsp;");
                                        }
                                        
                                        // Page 2 - Host Family App p.2
                                        if ( NOT isDate(qGetStudentsInRegion.compliance_host_app_page2_date) ) {
                                            vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Host Family App p.2 &nbsp; - &nbsp;", " &nbsp; - &nbsp;");
                                        }
                    
                                        // Page 3 - Host Family Letter p.3
                                        if ( NOT isDate(qGetStudentsInRegion.compliance_letter_rec_date) ) {
                                            vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Host Family Letter p.3 &nbsp; - &nbsp;", " &nbsp; - &nbsp;");
                                        }
                    
                                        // Page 4,5,6 - Family Photo
                                        if ( NOT isDate(qGetStudentsInRegion.compliance_photos_rec_date) ) {
                                            vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Family Photo &nbsp; - &nbsp;", " &nbsp; - &nbsp;");
                                        }
                        
                                        // Page 4,5,6 - Student Bedroom Photo
                                        if ( NOT isDate(qGetStudentsInRegion.compliance_bedroom_photo) ) {
                                            vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Student Bedroom Photo &nbsp; - &nbsp;", " &nbsp; - &nbsp;");
                                        }
                    
                                        // Page 4,5,6 - Student Bathroom Photo
                                        if ( NOT isDate(qGetStudentsInRegion.compliance_bathroom_photo) ) {
                                            vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Student Bathroom Photo &nbsp; - &nbsp;", " &nbsp; - &nbsp;");
                                        }
                    
                                        // Page 4,5,6 - Kitchen Photo
                                        if ( NOT isDate(qGetStudentsInRegion.compliance_kitchen_photo) ) {
                                            vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Kitchen Photo &nbsp; - &nbsp;", " &nbsp; - &nbsp;");
                                        }
                    
                                        // Page 4,5,6 - Living Room Photo
                                        if ( NOT isDate(qGetStudentsInRegion.compliance_living_room_photo) ) {
                                            vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Living Room Photo &nbsp; - &nbsp;", " &nbsp; - &nbsp;");
                                        }
                                        
                                        // Page 4,5,6 - Outside Photo
                                        if ( NOT isDate(qGetStudentsInRegion.compliance_outside_photo) ) {
                                            vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Outside Photo &nbsp; - &nbsp;", " &nbsp; - &nbsp;");
                                        }
                    
                                        // Page 7 - Host Family Rules Form
                                        if ( NOT isDate(qGetStudentsInRegion.compliance_rules_rec_date) ) {
                                            vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "HF Rules &nbsp; - &nbsp;", " &nbsp; - &nbsp;");
                                        }
                                        
                                        // Page 7 - Host Family Rules Date Signed
                                        if ( NOT isDate(qGetStudentsInRegion.compliance_rules_sign_date) ) {
                                            vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "HF Rules Date Signed &nbsp; - &nbsp;", " &nbsp; - &nbsp;");
                                        }		
                                        
                                        // Page 8 - School & Community Profile Form
                                        if ( NOT isDate(qGetStudentsInRegion.compliance_school_profile_rec) ) {
                                            vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "School & Community Profile &nbsp; - &nbsp;", " &nbsp; - &nbsp;");
                                        }
                                        
                                        // Page 9 - Income Verification Form
                                        if ( NOT isDate(qGetStudentsInRegion.compliance_income_ver_date) ) {
                                            vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Income Verification &nbsp; - &nbsp;", " &nbsp; - &nbsp;");
                                        }
                                        
                                        // Page 10 - Confidential Host Family Visit Form
                                        if ( NOT isDate(qGetStudentsInRegion.compliance_conf_host_rec) ) {
                                            vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Visit Form &nbsp; - &nbsp;", " &nbsp; - &nbsp;");
                                        }
                                        
                                        // Page 10 - Confidential Host Family Visit Form - Date of Visit
                                        if ( NOT isDate(qGetStudentsInRegion.compliance_date_of_visit) ) {
                                            vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Date of Visit &nbsp; - &nbsp;", " &nbsp; - &nbsp;");
                                        }
                                        
                                        // Page 11 - Ref. Form 1
                                        if ( NOT isDate(qGetStudentsInRegion.compliance_ref_form_1) ) {
                                            vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Ref. 1 &nbsp; - &nbsp;", " &nbsp; - &nbsp;");
                                        }
                                        
                                        // Page 11 - Ref. Check 1
                                        if ( NOT isDate(qGetStudentsInRegion.compliance_ref_check1) ) {
                                            vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Ref. Check 1 &nbsp; - &nbsp;", " &nbsp; - &nbsp;");
                                        }
                    
                                        // Page 12 - Ref. Form 2
                                        if ( NOT isDate(qGetStudentsInRegion.compliance_ref_form_2) ) {
                                            vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Ref. 2 &nbsp; - &nbsp;", " &nbsp; - &nbsp;");
                                        }
                                        
                                        // Page 12 - Ref. Check 2
                                        if ( NOT isDate(qGetStudentsInRegion.compliance_ref_check2) ) {
                                            vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Ref. Check 2 &nbsp; - &nbsp;", " &nbsp; - &nbsp;");
                                        }
                                        
                                        // Arrival Compliance - School Acceptance Form
                                        if ( NOT isDate(qGetStudentsInRegion.compliance_school_accept_date) ) {
                                            vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "School Acceptance &nbsp; - &nbsp;", " &nbsp; - &nbsp;");
                                        }								
                    
                                        // Arrival Compliance - School Acceptance Date of Signature
                                        if ( NOT isDate(qGetStudentsInRegion.compliance_school_sign_date) ) {
                                            vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "School Acceptance Signature &nbsp; - &nbsp;", " &nbsp; - &nbsp;");
                                        }								
                    
                                        // Arrival Orientation - Student Orientation
                                        if ( NOT isDate(qGetStudentsInRegion.compliance_stu_arrival_orientation) ) {
                                            vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Student Orientation &nbsp; - &nbsp;", " &nbsp; - &nbsp;");
                                        }
                                        
                                        // Arrival Orientation - HF Orientation
                                        if ( NOT isDate(qGetStudentsInRegion.compliance_host_arrival_orientation) ) {
                                            vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "HF Orientation &nbsp; - &nbsp;", " &nbsp; - &nbsp;");
                                        }
                                        
                                       /* // Arrival Orientation - Class Schedule
                                        if ( NOT isDate(qGetStudentsInRegion.compliance_class_schedule) ) {
                                            vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "Class Schedule &nbsp; - &nbsp;", " &nbsp; - &nbsp;");
                                        } */
                    
                                        // 2nd Confidential Host Family Visit Form
                                        if ( NOT isDate(qGetStudentsInRegion.dateCompliance) ) { 
                                            vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "2nd Conf. Host Visit &nbsp; - &nbsp;", " &nbsp; - &nbsp;");
                                        }
                                        
                                        // CBC Compliance
                                        
                                        // Double Placement Compliance
                                        if ( VAL(qGetStudentsInRegion.doublePlacementID) ) {
                                            
                                            // DP Natural Family Date Signed
                                            if ( NOT isDate(qGetStudentsInRegion.doublePlacementParentsDateCompliance) ) { 
                                                vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "DP Natural Family Date Signed &nbsp; - &nbsp;", " &nbsp; - &nbsp;");
                                            }
                    
                                            // DP Natural Family Date Signed
                                            if ( NOT isDate(qGetStudentsInRegion.doublePlacementStudentDateCompliance) ) { 
                                                vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "DP Student Date Signed Signed &nbsp; - &nbsp;", " &nbsp; - &nbsp;");
                                            }
                    
                                            // DP Natural Family Date Signed
                                            if ( NOT isDate(qGetStudentsInRegion.doublePlacementHostFamilyDateCompliance) ) { 
                                                vMissingDocumentsMessage = ListAppend(vMissingDocumentsMessage, "DP Host Family Date Signed &nbsp; - &nbsp;", " &nbsp; - &nbsp;");
                                            }
                    
                                        }
                                        
                                        
                                        // Host Family Status
                                        vHostFamilyStatus = '';
                                        
                                        if ( VAL(qGetStudentsInRegion.isWelcomeFamily) ) {
                                            vHostFamilyStatus = listAppend(vHostFamilyStatus, "Welcome");
                                        } else {
                                            vHostFamilyStatus = listAppend(vHostFamilyStatus, "Permanent");
                                        }
                                        
                                        if ( VAL(qGetStudentsInRegion.isActivePlacement) ) {
                                            vHostFamilyStatus = listAppend(vHostFamilyStatus, "Current");
                                        } else {
                                            vHostFamilyStatus = listAppend(vHostFamilyStatus, "Previous");
                                        }
                                                   
                                        if ( VAL(qGetStudentsInRegion.isRelocation) ) {
                                            vHostFamilyStatus = listAppend(vHostFamilyStatus, "Relocation");
                                        }
                                        
                                        vHostFamilyStatus = ReplaceNoCase(vHostFamilyStatus, ",", " - ", "All");
                                    </cfscript>
                                    
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
                                        <td style="font-size:9px">#DateFormat(qGetStudentsInRegion.datePlaced, 'mm/dd/yyyy')#</td>
                                        <td style="font-size:9px">
                                            #qGetStudentsInRegion.hostFamilyLastName# ###qGetStudentsInRegion.hostID# 
                                            <span class="note">
                                                (#vHostFamilyStatus#)
                                            </span>                            
                                        </td>
                                        <td style="font-size:9px">#vMissingDocumentsMessage#</td>
                                        <td style="font-size:9px">
                                            <cfloop query="qGetComplianceHistory">
                                                <p>#qGetComplianceHistory.actions#</p>			                                    
                                            </cfloop>
                                        </td>
                                    </tr>
                    
                                </cfoutput>
                            
                            </table>
                
                        </cfoutput>
                
                    </cfsavecontent>
    
                    <cfoutput>                    
						<!--- Display Report --->
                        #reportBody#
                    </cfoutput>
                
                </cfif>
        
            </cfloop>
            
      	</cfsavecontent>
        
        <cfif FORM.outputType EQ "flashPaper">
    
   			<cfdocument format="flashpaper" orientation="landscape" backgroundvisible="yes" overwrite="yes" fontembed="yes" margintop="0.3" marginright="0.2" marginbottom="0.3" marginleft="0.2">
    
				<!--- Page Header --->
                <gui:pageHeader
                    headerType="applicationNoHeader"
                    filePath="../"
                />
                
                <cfoutput>#report#</cfoutput>
                
          	</cfdocument>
            
       	<cfelse>
        
        	<cfoutput>#report#</cfoutput>
            
        </cfif>
    
    </cfif>
    
    <!--- Page Header --->
    <gui:pageFooter />	
    
</cfif>    