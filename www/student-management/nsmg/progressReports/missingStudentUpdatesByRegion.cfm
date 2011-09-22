<!--- ------------------------------------------------------------------------- ----
	
	File:		missingStudentUpdatesByRegion.cfm
	Author:		Marcus Melo
	Date:		September 22, 2011
	Desc:		Missing Progress Reports by Region

	Updated:	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

    <cfsetting requesttimeout="9999">
    
    <!--- Param FORM Variables --->
    <cfparam name="FORM.programID" default="">
    <cfparam name="FORM.regionID" default="">
    <cfparam name="FORM.monthReport" default="">

	<cfscript>
		/*
			REPORTS PER PROGRAM
			10 MONTH - SEPT - NOV - JAN - MARCH - MAY - TYPE = 1
			12 MONTH - JAN - MARCH - JULY - SEPT - NOV - TYPE = 2
			1ST SEMESTER - SEPT - NOV - JAN - TYPE = 3
			2ND SEMESTER - JAN - MARCH - MAY - TYPE = 4
			
			10 MONTH PRIVATE - PROGRAM END DATE 06/31
			12 MONTH PRIVATE - PROGRAM END DATE 12/31
			1ST SEMESTER PRIVATE - PROGRAM END DATE 06/31
			2ND SEMESTER PRIVATE - PROGRAM END DATE 01/15
		*/
	
		// 10 month
		FORM.prtype1 = "9,11,1,3,5"; 
		// 12 month
		FORM.prtype2 = "1,3,7,9,11";
		// 1st semester
		FORM.prtype3 = "9,11,1";
		// 2nd semester
		FORM.prtype4 = "1,3,5";
		// J1 Private Program - Various in lenght (Deprecated)
		FORM.prtype5 = "";

		// Stores list of user IDs that are supervised by an Advisor
		vListOfAdvisorUsers = '';

		// Data Validation 
		
		// Program ID
		if ( NOT LEN(FORM.programID) ) {
			// Set Page Message
			SESSION.formErrors.Add("Select at least one program");
		}
	
		// Region ID
		if ( NOT LEN(FORM.regionID) ) {
			// Set Page Message
			SESSION.formErrors.Add("Select at least one region");
		}
		
		// Month Report
		if ( NOT LEN(FORM.monthReport) ) {
			// Set Page Message
			SESSION.formErrors.Add("Select at least one phase");
		}
	</cfscript>

	<!--- No Errors Found --->
	<cfif NOT SESSION.formErrors.length()>
    
		<!--- Get Programs --->
        <cfquery name="qGetSelectedPrograms" datasource="MYSQL">
            SELECT	
                p.programName
            FROM 	
                smg_programs p
            INNER JOIN 
                smg_companies c ON p.companyid = c.companyid
            LEFT JOIN 
                smg_program_type ON type = programtypeid
            WHERE 
                p.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> )
        </cfquery>
        
        <cfscript>
            vDisplayProgramList = ValueList(qGetSelectedPrograms.programName, " <br /> ");
        </cfscript>

        <!--- Get Regions --->
        <cfquery name="qGetSelectedRegion" datasource="MySQL">
            SELECT	
                regionname, 
                company, 
                regionid
            FROM 
                smg_regions
            WHERE 
                regionID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionID#" list="yes"> )
            ORDER BY 
                regionname
        </cfquery>

		<cfscript>
			// Get List of Users Under Advisor and the Advisor self
            if ( CLIENT.usertype EQ 6 ) {
        
                // Get Available Reps
                qGetUserUnderAdv = APPLICATION.CFC.USER.getSupervisedUsers(userType=CLIENT.userType, userID=CLIENT.userID, regionID=FORM.regionID);
            	
                // Store Users under Advisor on a list
                vListOfAdvisorUsers = ValueList(qGetUserUnderAdv.userid, ',');

            }
        </cfscript>
    
	</cfif>        

</cfsilent>

<!--- Page Header --->
<gui:pageHeader
	headerType="applicationNoHeader"
    filePath="../"
/>	

	<cfoutput>
    
    	<!--- Display Errors --->
        <cfif SESSION.formErrors.length()>
        
			<!--- Table Header --->
            <gui:tableHeader
                imageName="user.gif"
                tableTitle="Missing Progress Report by Region (Active Students)"
                width="98%"
                imagePath="../"
            />
        
                <!--- Page Messages --->
                <gui:displayPageMessages 
                    pageMessages="#SESSION.pageMessages.GetCollection()#"
                    messageType="tableSection"
                    width="98%"
                    />
            
                <!--- Form Errors --->
                <gui:displayFormErrors 
                    formErrors="#SESSION.formErrors.GetCollection()#"
                    messageType="tableSection"
                    width="98%"
                    />	
    
            <!--- Table Footer --->
            <gui:tableFooter 
                width="98%"
                imagePath="../"
            />
        
        <!--- Run Report --->
        <cfelse>
        	
            <table width="90%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                <tr>
                    <th>Missing Progress Reports</th>
                </tr>
                <tr>
                    <td class="center">
                        Programs Included: <br /> #vDisplayProgramList#
                    </td>
                </tr>
            </table>
        
            <cfloop query="qGetSelectedRegion">
                
                <cfscript>
                    vGetCurrentRegion = qGetSelectedRegion.regionid;
                </cfscript>
                
                <cfquery name="qGetStudentList" datasource="MySql">
                    SELECT 
                        s.studentid, 
                        s.firstname, 
                        s.familylastname, 
                        p.type, 
                        p.programname, 
                        p.startdate, 
                        p.enddate,
                        u.userID,
                        u.firstname AS userFirstName, 
                        u.lastname AS userLastName
                    FROM 
                        smg_students s
                    INNER JOIN 
                        smg_programs p ON p.programid = s.programid
                    INNER JOIN 
                        smg_users u ON u.userid = s.arearepid
                    WHERE 
                        s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                    AND 
                        s.hostid != <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                    AND 
                        s.regionassigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#vGetCurrentRegion#">
                    AND 
                        s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> )

                    <!--- Regional Advisors --->
                    <cfif LEN(vListOfAdvisorUsers)>
                        AND 
                            s.arearepid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#vListOfAdvisorUsers#" list="yes"> )
                    </cfif>		

					<!--- Area Reps --->                 
                    <cfif CLIENT.usertype EQ 7>
                        AND 
                            s.arearepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#"> 
                    </cfif>
                        
                    ORDER BY 
                        u.lastname, 
                        s.familylastname
                </cfquery>
            
                <cfif qGetStudentList.recordcount>
                    
                    <table width="90%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                        <tr>
                            <th class="left" colspan="4">Region: #qGetSelectedRegion.regionname#</th>
                        </tr>
                        <tr>
                            <td class="subTitleLeft" width="25%">Supervising Representative</td>
                            <td class="subTitleLeft" width="25%">Student</td>
                            <td class="subTitleLeft" width="20%">Program</td>
                            <td class="subTitleLeft" width="30%">Missing Report(s)</td>
                        </tr>       
                        
                        <cfloop query="qGetStudentList">		

							<cfscript>
								// This will store a list of missing reports
                            	vMissingReportsList = '';

								// J1 Private Program - select which reports are required
                                if ( qGetStudentList.type EQ 5 ) {
                                    
                                    if ( Month(qGetStudentList.enddate) EQ 6 AND DateDiff("m", qGetStudentList.startdate, qGetStudentList.enddate) EQ 10 ) {
                                        // 10 Month Program
                                        FORM.prtype5 = FORM.prtype1;
                                    } else if ( Month(qGetStudentList.enddate) EQ 6 AND DateDiff("m", qGetStudentList.startdate, qGetStudentList.enddate) EQ 5) {
                                        // 2nd Semester Program
                                        FORM.prtype5 = FORM.prtype4;
                                    } else if ( Month(qGetStudentList.enddate) EQ 12 ) {
                                        // 12 Month Program
                                        FORM.prtype5 = FORM.prtype2; 
                                    } else if ( Month(qGetStudentList.enddate) EQ 1 ) {
                                        // 1st Semester Program
                                        FORM.prtype5 = FORM.prtype3;
                                    }
                                    
                                }
                            </cfscript>
                        
                            <cfloop list="#FORM.monthReport#" index="i">
                                
                                <cfquery name="qGetMonthReport" datasource="MySql">
                                    SELECT DISTINCT 
                                        fk_student 
                                    FROM
                                        progress_reports 
                                    WHERE 
                                        fk_student = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentList.studentid#">
                                    AND 
                                        pr_month_of_report = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
                                </cfquery>
								
                                <cfscript>
									if ( NOT VAL(qGetMonthReport.recordCount) ) {
										vMissingReportsList = vMissingReportsList & MonthAsString(i);	
									}	
									
									if ( ListLast(FORM.monthReport) NEQ i ) {
										vMissingReportsList = vMissingReportsList & ", &nbsp;";	
									}
								</cfscript>
                                
                            </cfloop>

                            <!--- Report is Missing --->
                            <cfif LEN(vMissingReportsList)>  
                            
                                <tr class="#iif(qGetStudentList.currentRow MOD 2 ,DE("off") ,DE("on") )#">
                                    <td>#qGetStudentList.userFirstName# #qGetStudentList.userLastName# (###qGetStudentList.userID#)</td>
                                    <td>#qGetStudentList.firstname# #qGetStudentList.familylastname# (###qGetStudentList.studentID#)</td>
                                    <td>#qGetStudentList.programname#</td>
                                    <td>#vMissingReportsList#</td>
                                </tr>
                                
                            </cfif>
                            
                        </cfloop>
                    
                    </table>
                
                </cfif>
                
            </cfloop>
        
            <table width="90%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">            
                <th colspan="2">Reports Per Program</th>
                <tr class="off">
                    <td width="50%">
                        10 Month -> September - November - January - March - May  <br />
                    </td>
                    <td width="50%">
                        1st Semester -> September - November - January <br />
                    </td>
                </tr>
                <tr class="on">
                    <td width="50%">
                        12 Month -> January - March - July - September - November
                    </td>
                    <td width="50%">
                        2nd Semester -> January - March - May
                    </td>
                </tr>
            </table>

		</cfif>

	</cfoutput>

<!--- Page Footer --->
<gui:pageFooter
	footerType="application"
    filePath="../"
/>
