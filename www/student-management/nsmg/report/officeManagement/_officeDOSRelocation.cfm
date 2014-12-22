<!--- ------------------------------------------------------------------------- ----
	
	File:		_officeDOSRelocation.cfm
	Author:		Marcus Melo
	Date:		July 16, 2012
	Desc:		DOS Relocation Report
				
				#CGI.SCRIPT_NAME#?curdoc=report/index?action=officeDOSRelocation
				
	Updated: 			
				
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../../extensions/customTags/gui/" prefix="gui" />	
	
    <cfsetting requesttimeout="9999">
    
    <cfscript>	
		// Param FORM Variables
		param name="FORM.submitted" default=0;
		param name="FORM.programID" default=0;	
		param name="FORM.studentStatus" default="All";
		param name="FORM.outputType" default="excel";

		// Set Report Title To Keep Consistency
		vReportTitle = "Office Management - DOS Relocation";

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
        	
            <!--- Get Students that have relocated --->
            <cfquery name="qGetStudentIDList" datasource="#APPLICATION.DSN#">
                SELECT 
                    s.studentID
                FROM 
                    smg_hosthistory h
                INNER JOIN 
                    smg_students s ON s.studentID = h.studentID
                    AND 
                        s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> )
                  	AND
                    	s.regionAssigned IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionID#" list="yes"> )  
                        
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
    
                    <cfif CLIENT.companyID EQ 5>
                        AND
                            s.companyid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
                    <cfelse>        	
                        AND
                            s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
                    </cfif>
                WHERE 
                    h.isRelocation = <cfqueryparam cfsqltype="cf_sql_bit" value="1">                    
                AND
                    h.assignedID = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
				AND
                	h.datePlaced IS NOT <cfqueryparam cfsqltype="cf_sql_date" null="yes">                    
                GROUP BY
                    s.studentID              
 			</cfquery>          

            <!--- Get all placement history for students that have relocated --->
            <cfquery name="qGetResults" datasource="#APPLICATION.DSN#">
                SELECT 
                    s.studentID,
                    s.firstname AS studentFirstName, 
                    s.familylastname AS studentLastName, 
                    s.ds2019_no,
                    s.aypEnglish,
                    <!--- Host History --->
                    hist.changePlacementExplanation,
                    hist.datePlaced,
                    hist.datePlacedEnded,
                    hist.dateRelocated,
                    hist.isRelocation,
                    hist.isWelcomeFamily,
                    hist.dateCreated,
                    <!--- Change Placement Reason --->
                    alup.name AS changePlacementReason,
                    alup.description AS changeOfHomeCode,
                    <!--- Company Info --->
                    c.companyName,
                    c.iap_auth,
                    <!--- Region Info --->
                    r.regionName,
                    <!--- Country of Citizenship --->
                    cl.countryName,
                    <!--- Host Family --->
                    h.hostID,
                    h.fatherLastName,
                    h.fatherFirstName,
                    h.motherLastName,
                    h.motherFirstName,
                    h.address AS hostAddress,
                    h.city AS hostCity,
                    h.state AS hostState,
                    h.zip AS hostZipCode,
                    <!--- School --->
                    sch.schoolID,
                    sch.schoolName,
                    sch.address AS schoolAddress,
                    sch.city AS schoolCity,
                    sch.state AS schoolState,
                    sch.zip AS schoolZipCode,
                    <!--- Supervising Representative --->
                    u.userID,
                    u.lastName AS supervisingLastName,
                    u.firstName AS supervisingFirstName,
                    u.zip AS supervisingZipCode,
                    (
                        SELECT 
                            dep_date 
                        FROM 
                            smg_flight_info 
                        WHERE 
                            studentID = s.studentID 
                        AND 
                            flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="preAypArrival"> 
                        AND
                            assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                        AND 
                            isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                        ORDER BY 
                            dep_date ASC,
                            dep_time ASC
                        LIMIT 1                            
                    ) AS preAYPdateArrived,                    
                    (
                        SELECT 
                            dep_date 
                        FROM 
                            smg_flight_info 
                        WHERE 
                            studentID = s.studentID 
                        AND 
                            flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="arrival"> 
                        AND
                            assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                        AND 
                            isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                        ORDER BY 
                            dep_date ASC,
                            dep_time ASC
                        LIMIT 1                            
                    ) AS dateArrived
                FROM 
                    smg_hosthistory hist
                INNER JOIN 
                    smg_students s ON s.studentID = hist.studentID
                INNER JOIN 
                    smg_companies c ON c.companyID = s.companyID
               	INNER JOIN
                	smg_regions r ON r.regionID = s.regionAssigned
                INNER JOIN 
                    smg_countrylist cl on cl.countryID = s.countryResident
                INNER JOIN 
                    smg_hosts h ON h.hostID = hist.hostID
                INNER JOIN  
                    smg_schools sch on sch.schoolID = hist.schoolID
                INNER JOIN  
                    smg_users u ON u.userID = hist.areaRepID
                LEFT OUTER JOIN
                    applicationlookup alup ON alup.fieldID = hist.changePlacementReasonID
                    AND
                        fieldKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="changePlacementReason">                             
                WHERE
                	hist.datePlaced IS NOT <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                AND
                	hist.assignedID = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
              	AND 
             		<cfif VAL(qGetStudentIDList.recordCount)>
                        hist.studentID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ValueList(qGetStudentIDList.studentID)#" list="yes"> )
              		<cfelse>
                		hist.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
             		</cfif>
                           
                GROUP BY
                	hist.studentID,
                    hist.hostID,
                    hist.schoolID,
                    hist.areaRepID
                ORDER BY
                	s.familyLastName,
                    s.firstName,
                    hist.historyID
            </cfquery>
	
		</cfif> <!--- NOT SESSION.formErrors.length() ---->

	</cfif> <!--- FORM Submitted --->
    
</cfsilent>

<!--- FORM NOT submitted --->
<cfif NOT VAL(FORM.Submitted)>

    <!--- Call the basescript again so it works when ajax loads this page --->
    <script type="text/javascript" src="linked/js/basescript.js "></script> <!-- BaseScript -->

	<cfoutput>

        <form action="report/index.cfm?action=officeDOSRelocation" name="officeDOSRelocation" id="officeDOSRelocation" method="post" target="blank">
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
                            <option value="All" selected="selected">All</option>
                        </select>
                    </td>		
                </tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Output Type: <span class="required">*</span></td>
                    <td>
                        <select name="outputType" id="outputType" class="xLargeField">
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
                    <td>This report generates the Deparment of State Annual Change of Placement Report</td>		
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
    
    <!--- set content type --->
    <cfcontent type="application/msexcel">
    
    <!--- suggest default name for XLS file --->
    <cfheader name="Content-Disposition" value="attachment; filename=DOS-Relocation-Report.xls">
    
    <table width="98%" cellpadding="4" cellspacing="0" align="center" border="1">
        <tr>
            <th colspan="29">DEPARTMENT OF STATE ANNUAL CHANGE OF PLACEMENT REPORT</th>            
        </tr>
        <tr style="font-weight:bold;">
            <td>Program Number</td>
            <td>Program Name</td>
            <td>Region</td>
            <td>Participant's Last Name</td>
            <td>Participant's First Name</td>
            <td>Home Country</td>
            <td>SEVIS ID#</td>
            <td>SEVIS Status</td>
            <td>Host Family Number</td>
            <td>Date Student Joined Host family</td>
            <td>Host Father Last Name</td>
            <td>Host Father First Name</td>
            <td>Host Mother Last Name</td>
            <td>Host Mother First Name</td>            
            <td>Welcome, Permanent, or Temporarily Host Family?</td>
            <td>Street Address</td>
            <td>City</td>
            <td>State</td>
            <td>ZIP</td>
            <td>School Number</td>
            <td>School Name</td>
            <td>Street Address</td>
            <td>City</td>
            <td>State</td>
            <td>ZIP</td>
            <td>Local Coordinator First Name</td>
            <td>Local Coordinator Last Name</td>
            <td>Local Coordinator Zip</td>
            <td>Change of Home Code</td>
            <td>Brief Narrative Description Explaining Reason for Change in Home or School or Where Student was Between Entry and Placement in First Home</td>
        </tr>

        <cfscript>
			vPreviousStudentID = 0;
			vRowNumber = 1;
			// Set local variables
			vHostCount = 0;
			vHostNumber = "";
			vPreviousHostID = "";
			
			vSchoolCount = 0;
			vSchoolNumber = "";
			vPreviousSchoolID = "";
			
			vRecordNumber = 0;
        </cfscript>
        
        <!--- Loop Results ---> 
        <cfoutput query="qGetResults">

            <cfscript>
                if ( #qGetResults.currentRow# MOD 2 ) {
                    vRowColor = 'bgcolor="##E6E6E6"';
                } else {
                    vRowColor = 'bgcolor="##FFFFFF"';
                }

				if ( vPreviousStudentID NEQ qGetResults.studentID ) {
					// Reset Variables for each student
					vHostCount = 0;
					vHostNumber = "";
					vPreviousHostID = "";
					
					vSchoolCount = 0;
					vSchoolNumber = "";
					vPreviousSchoolID = "";
					
					vRecordNumber = 0;
				}
                
                // Pre-AYP Student
                if ( VAL(qGetResults.aypEnglish) ) {
                    vSetArrivalDate = qGetResults.preAYPdateArrived;
                // Not Pre-AYP
                } else {
                    vSetArrivalDate = qGetResults.dateArrived;
                }
                
                // Placement period before arrival - set host number to 0
                if ( isDate(qGetResults.datePlacedEnded) AND qGetResults.datePlacedEnded LT vSetArrivalDate) {
                
                    vHostNumber = 0;
                
                // Placement period after arrival - count hosts
                } else {
                
                    // Count Hosts
                    if ( vPreviousHostID NEQ qGetResults.hostID ) {
                          vHostCount ++;
                    }
                    vHostNumber = vHostCount;

                }
                
                // Count Schools
                if ( vPreviousSchoolID NEQ qGetResults.schoolID ) {
                    vSchoolCount ++;
                }
                
				// Set Previous Data
				vPreviousStudentID = qGetResults.studentID;
				vPreviousHostID = qGetResults.hostID;
                vPreviousSchoolID = qGetResults.schoolID;
            </cfscript>
            
            <!--- Display all except the original placement. --->
            <tr>
                <td #vRowColor#>#qGetResults.iap_auth#</td>
                <td #vRowColor#>#qGetResults.companyName#</td>
                <td #vRowColor#>#qGetResults.regionName#</td>
                <td #vRowColor#>#qGetResults.studentLastName#</td>
                <td #vRowColor#>#qGetResults.studentFirstName#</td>
                <td #vRowColor#>#qGetResults.countryName#</td>
                <td #vRowColor#>#qGetResults.ds2019_no#</td>
                <td #vRowColor#>Active</td>
                <td #vRowColor#>#vHostNumber#</td>
                <td #vRowColor#>
                    <!--- Date Relocation --->
                    <cfif isDate(qGetResults.dateRelocated)>
                        #DateFormat(qGetResults.dateRelocated, 'mm/dd/yyyy')#
                    <!--- Arrival to HF --->
                    <cfelse>
                        #DateFormat(qGetResults.dateArrived, 'mm/dd/yyyy')#
                    </cfif>
                </td>
                <td #vRowColor#>#qGetResults.fatherLastName#</td>
                <td #vRowColor#>#qGetResults.fatherFirstName#</td>
                <td #vRowColor#>#qGetResults.motherLastName#</td>
                <td #vRowColor#>#qGetResults.motherFirstName#</td>            
                <td #vRowColor#>
                    <cfif VAL(qGetResults.isWelcomeFamily)>
                        Welcome
                    <cfelse>
                        Permanent
                    </cfif>
                </td>
                <td #vRowColor#>#qGetResults.hostAddress#</td>
                <td #vRowColor#>#qGetResults.hostCity#</td>
                <td #vRowColor#>#qGetResults.hostState#</td>
                <td #vRowColor#>#qGetResults.hostZipCode#</td>
                <td #vRowColor#>#vSchoolCount#</td>
                <td #vRowColor#>#qGetResults.schoolName#</td>
                <td #vRowColor#>#qGetResults.schoolAddress#</td>
                <td #vRowColor#>#qGetResults.schoolCity#</td>
                <td #vRowColor#>#qGetResults.schoolState#</td>
                <td #vRowColor#>#qGetResults.schoolZipCode#</td>
                <td #vRowColor#>#qGetResults.supervisingLastName#</td>
                <td #vRowColor#>#qGetResults.supervisingFirstName#</td>
                <td #vRowColor#>#qGetResults.supervisingZipCode#</td>
                <td #vRowColor#>#qGetResults.changeOfHomeCode#</td>
                <td #vRowColor#>
                	<cfif vRecordNumber EQ 0>
                    	<i>Original Placement</i>
                    </cfif>
                    <b>#qGetResults.changePlacementReason#</b> <cfif LEN(qGetResults.changePlacementReason) AND LEN(qGetResults.changePlacementExplanation)>-</cfif> 
                    #qGetResults.changePlacementExplanation#
                    <cfif VAL(qGetResults.aypEnglish) AND NOT isDate(qGetResults.dateRelocated)>
                        Student was attending an English/Orientation camp approved by ISE
                    </cfif>
                </td>
            </tr>
            
            <cfscript>
				vRecordNumber++;
			</cfscript>

        </cfoutput>                
        
    </table>
    
    <!--- Page Header --->
    <gui:pageFooter />	
    
</cfif>