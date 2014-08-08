<!--- ------------------------------------------------------------------------- ----
	
	File:		_studentFlightInformation.cfm
	Author:		James Griffiths
	Date:		May 4, 2012
	Desc:		Student Flight Information
				
				#CGI.SCRIPT_NAME#?curdoc=report/index?action=studentFlightInformation
				
	Updated: 				
				
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
    <cfsetting requesttimeout="9999">
    
	<!--- Import CustomTag --->
    <cfimport taglib="../../extensions/customTags/gui/" prefix="gui" />	
	
    <cfscript>	
		// Param FORM Variables
		param name="FORM.submitted" default=0;
		param name="FORM.programID" default=0;	
		param name="FORM.regionID" default=0;
		param name="FORM.flightType" default=0;
		param name="FORM.dateFrom" default="";
		param name="FORM.dateTo" default="";	
		param name="FORM.outputType" default="flashPaper";

		// Set Report Title To Keep Consistency
		vReportTitle = "Student Management - Flight Information";

		// set to 1 if this is a report of missing flight information
		vMissingReport = 1;

		// Get Programs
		qGetPrograms = APPLICATION.CFC.PROGRAM.getPrograms(programIDList=FORM.programID);
		
		// Get Regions
		qGetRegions = APPLICATION.CFC.REGION.getRegions(regionIDList=FORM.regionID);
		
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

            <cfquery name="qGetResults" datasource="#APPLICATION.DSN#">
                SELECT
                    s.studentID,
                    s.programID,
                    s.firstName,
                    s.familyLastName,
                    s.arearepid,
                    u.firstName AS super_firstName,
                    u.lastName AS super_lastName,
                    u.userID AS super_ID,
                    p.programName,
                    r.regionName,
                    r.regionID,
                    f.dep_date, 
                    f.dep_city, 
                    f.dep_aircode, 
                    f.dep_time, 
                    f.flight_number, 
                    f.arrival_city, 
                    f.arrival_aircode, 
                    f.arrival_time, 
                    f.overnight 
                FROM
                    smg_students s 
                INNER JOIN 
                    smg_programs p ON s.programid = p.programid
                LEFT OUTER JOIN 
                    smg_flight_info f ON s.studentid = f.studentid 
                        AND 
                            f.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                       
                        <cfif FORM.flightType EQ 'mArrival'>
                        	<cfset vMissingReport=0>
                            
                            AND NOT EXISTS	
                            (
                                SELECT 
                                    flight.studentID
                                FROM
                                    smg_flight_info flight
                                WHERE
                                    flight.studentID = s.studentID	
                                AND
                                    flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="arrival">
                                AND 
                                    flight.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">	 
                                AND
                                    flight.isCompleted = <cfqueryparam cfsqltype="cf_sql_bit" value="1">	                                               
                            )
                            AND
                                s.aypEnglish = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                                
                        <cfelseif FORM.flightType EQ 'mPreAypArrival'>
                        	<cfset vMissingReport=0>
                            
                            AND NOT EXISTS	
                                (
                                    SELECT 
                                        flight.studentID
                                    FROM
                                        smg_flight_info flight
                                    WHERE
                                        flight.studentID = s.studentID	
                                    AND
                                        flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="preAypArrival">
                                    AND 
                                        flight.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">	 
                                    AND
                                        flight.isCompleted = <cfqueryparam cfsqltype="cf_sql_bit" value="1">	                                               
                                )
                                AND
                                    s.aypEnglish != <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                                    
                        <cfelseif FORM.flightType EQ 'mDeparture'>
                           	<cfset vMissingReport=0>
                            AND NOT EXISTS	
                                (
                                    SELECT 
                                        flight.studentID
                                    FROM
                                        smg_flight_info flight
                                    WHERE
                                        flight.studentID = s.studentID	
                                    AND
                                        flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="departure">
                                    AND 
                                        flight.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">	 
                                    AND
                                        flight.isCompleted = <cfqueryparam cfsqltype="cf_sql_bit" value="1">	                                               
                                )
                                <!---AND s.aypEnglish != <cfqueryparam cfsqltype="cf_sql_integer" value="0">--->
                                    
                        <cfelse>
                        
                            AND       
                                f.flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.flightType#">
                                
                        </cfif>
                        
                        <cfif isDate(FORM.dateFrom) AND isDate(FORM.dateTo) AND NOT ListFind("mArrival,mPreAypArrival,mDeparture",FORM.flightType)>
                            AND 
                                f.dep_date 
                                BETWEEN 
                                	<cfqueryparam cfsqltype="cf_sql_date" value="#FORM.dateFrom#"> 
                                AND 
                                	<cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d',1,FORM.dateTo)#">
                        </cfif> 
                                 
                INNER JOIN 
                    smg_regions r ON s.regionassigned = r.regionid
                LEFT JOIN 
                    smg_users u ON s.arearepid = u.userid
                WHERE 
                    s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">             
                    AND 
                        s.regionassigned IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionID#" list="yes"> )
                    AND 
                        s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> )
                    AND
                        s.app_current_status = <cfqueryparam cfsqltype="cf_sql_integer" value="11">
                    
                    <!--- Area Reps --->                 
                    <cfif CLIENT.usertype EQ 7>
                        AND 
                            (
                                s.placerepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#"> 
                            OR 
                                s.arearepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#"> 
                            )
                    </cfif>	
                    
                    <!--- Regional Advisors --->
					<cfif LEN(vListOfAdvisorUsers)>
                        AND
                            (
                                s.areaRepID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#vListOfAdvisorUsers#" list="yes"> )
                            OR
                                s.placeRepID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#vListOfAdvisorUsers#" list="yes"> )
                            )
                    </cfif>
                        
                ORDER BY 
                    s.familyLastName
            </cfquery>

		</cfif> <!--- NOT SESSION.formErrors.length() ---->

	</cfif> <!--- FORM Submitted --->
    
</cfsilent>

<!--- FORM NOT submitted --->
<cfif NOT VAL(FORM.Submitted)>

    <!--- Call the basescript again so it works when ajax loads this page --->
    <script type="text/javascript" src="linked/js/basescript.js "></script> <!-- BaseScript -->

	<cfoutput>

		<!--- Flight Information Report --->
        <form action="report/index.cfm?action=studentFlightInformation" name="flightInformation" id="flightInformation" method="post" target="blank">
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
                    <td class="subTitleRightNoBorder">Flight Type: <span class="required">*</span></td>
                    <td>
                        <select name="flightType" id="flightType" class="xLargeField" required>
                            <option value="arrival">Arrival to Host Family</option>
                            <option value="preAypArrival">Arrival to Pre-Ayp</option>
                            <option value="departure">Departure</option>
                            <option value="mArrival">Missing Arrival to Host Family</option>
                            <option value="mPreAypArrival">Missing Arrival to Pre-Ayp</option>
                            <option value="mDeparture">Missing Departure</option>
                        </select>
                    </td>		
                </tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">From: </td>
                    <td>
                        <input type="text" name="dateFrom" id="dateFrom" class="datePicker" />
                    </td>		
                </tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">To: </td>
                    <td>
                        <input type="text" type="text" name="dateTo" id="dateTo" class="datePicker" />
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
                        This report will provide you with a comprehensive list of students and their arrival/departure flight information. 
                        You can sort this by place or super rep so that a list of students' flight info can be sent to your reps. 
                        Missing flight info can also be generated so that you know who still needs to submit it. Flights are listed in date order.  
                    </td>		
                </tr>
                <tr>
                    <th colspan="2" align="center"><input type="image" src="pics/view.gif" align="center" border="0"></th>
                </tr>
            </table>
        </form>          

	</cfoutput>

<!--- FORM Submitted --->
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
        <cfheader name="Content-Disposition" value="attachment; filename=studentFlightInformation.xls">
        
        <table width="98%" cellpadding="4" cellspacing="0" align="center" border="1">
            <tr>
                <th colspan="10">#vReportTitle#</th>            
            </tr>
            <tr style="font-weight:bold;">
                <td>Region</td>
                <td>Student</td>
                <td>Supervising Representative</td>
                <td>Date</td>
                <td>Departure City (Code)</td>
                <td>Arrival City (Code)</td>
                <td>Flight Number</td>
                <td>Departure Time</td>
                <td>Arrival Time</td>
                <td>Overnight Flight</td>
            </tr>
            
            <cfif vMissingReport>
            
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
                        <td #vRowColor#>#qGetResults.firstName# #qGetResults.familyLastName# ###qGetResults.studentID#</td>
                        <td #vRowColor#>#qGetResults.super_firstName# #qGetResults.super_lastName# ###qGetResults.super_ID#</td>
                        <td #vRowColor#>#DateFormat(qGetResults.dep_date, "mm/dd/yyyy")#</td>
                        <td #vRowColor#>#qGetResults.dep_city# <cfif LEN(qGetResults.dep_aircode)>(#qGetResults.dep_aircode#)</cfif></td>
                        <td #vRowColor#>#qGetResults.arrival_city# <cfif LEN(qGetResults.arrival_aircode)>(#qGetResults.arrival_aircode#)</cfif></td>
                        <td #vRowColor#>#qGetResults.flight_number#</td>
                        <td #vRowColor#>#TimeFormat(qGetResults.dep_time, 'hh:mm tt')#</td>
                        <td #vRowColor#>#TimeFormat(qGetResults.arrival_time, 'h:mm tt')#</td>
                        <td #vRowColor#>#YesNoFormat(VAL(qGetResults.overnight))#</td>
                    </tr>
                    
                </cfoutput>
                
            <cfelse>
                   
                <cfscript>
                    vRowNumber = 0;
                </cfscript>
                                                   
                <cfoutput query="qGetResults" group="studentID">
                    
                    <cfscript>
                        // Set Row Color
                        if ( vRowNumber MOD 2 ) {
                            vRowColor = 'bgcolor="##E6E6E6"';
                        } else {
                            vRowColor = 'bgcolor="##FFFFFF"';
                        }
                    </cfscript>
                    
                    <tr>
                        <td #vRowColor#>#qGetResults.regionName#</td>
                        <td #vRowColor#>#qGetResults.firstName# #qGetResults.familyLastName# ###qGetResults.studentID#</td>
                        <td #vRowColor#>#qGetResults.super_firstName# #qGetResults.super_lastName# ###qGetResults.super_ID#</td>
                        <td #vRowColor#>&nbsp;</td>
                        <td #vRowColor#>&nbsp;</td>
                        <td #vRowColor#>&nbsp;</td>
                        <td #vRowColor#>&nbsp;</td>
                        <td #vRowColor#>&nbsp;</td>
                        <td #vRowColor#>&nbsp;</td>
                        <td #vRowColor#>&nbsp;</td>
                    </tr>

                    <cfscript>
                        vRowNumber++;
                    </cfscript>
                    
                </cfoutput>
                                    
            </cfif>
    
        </table>
    
    <!--- On Screen Report --->
    <cfelse>
    
    	<cfsavecontent variable="report">
    
			<cfoutput>
                 
                <!--- Get the total number of students (because there are usually several records for each student) --->
                <cfquery name="qGetTotalStudents" dbtype="query">
                    SELECT DISTINCT
                        studentID
                    FROM
                        qGetResults
                </cfquery>
                
                <!--- Include Report Header --->    
                <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                    <tr>
                        <th>#vReportTitle#</th>            
                    </tr>
                    <tr>
                        <td class="center">
                            <strong>Program(s) included in this report: </strong> <br />
                            <cfloop query="qGetPrograms">
                                #qGetPrograms.programName# <br />
                            </cfloop>
                        </td>
                    </tr>
                    <tr>
                        <td class="center"><strong>Total of #qGetTotalStudents.recordCount# students in this report</strong></td>
                    </tr>
                </table>
                
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
        
                <cfquery name="qGetStudentsInRegion" dbtype="query">
                    SELECT
                        *
                    FROM
                        qGetResults
                    WHERE
                        regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#currentRegionID#">            
                </cfquery>
                
                <!--- Get the total number of students in this region --->
                <cfquery name="qGetTotalStudentsInRegion" dbtype="query">
                    SELECT DISTINCT
                        studentID
                    FROM
                        qGetStudentsInRegion
                </cfquery>
                        
                <cfif qGetStudentsInRegion.recordCount>
                
                    <cfoutput>
                        
                        <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable" <cfif ListGetAt(FORM.regionID, 1) NEQ currentRegionID>style="margin-top:30px;"</cfif>>
                            <tr>
                                <th class="left">#qGetStudentsInRegion.regionName# Region</th>
                                <th class="right note">Total of #qGetTotalStudentsInRegion.recordCount# students in this region</th>
                            </tr>      
                        </table>
                        
                        <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                    
                    </cfoutput>
                
                </cfif>
                
                    <cfoutput query="qGetStudentsInRegion" group="familyLastName">
                    
                        <cfscript>
                            vCurrentRow = 0;			
                        </cfscript>
    
                        <tr class="on">     
                   
                            <td class="subTitleLeft" width="25%">Student: #qGetStudentsInRegion.firstName# #qGetStudentsInRegion.familyLastName# ###qGetStudentsInRegion.studentID#</td>
                            <td class="subTitleLeft" width="25%">Supervising Representative: #qGetStudentsInRegion.super_firstName# #qGetStudentsInRegion.super_lastName# ###qGetStudentsInRegion.super_ID#</td>
                            <td class="subTitleLeft" width="80%"></td>
                        </tr>
    
                        <tr>
                            <td colspan="3" width="100%">
                                <table width="98%" cellpadding="4" cellspacing="0" align="center">
                                    <tr style="font-weight:bold;text-decoration:underline;">
                                        <td width="14%" style="font-size:9px">Date</td>
                                        <td width="14%" style="font-size:9px">Departure City (Code)</td>
                                        <td width="14%" style="font-size:9px">Arrival City (Code)</td>
                                        <td width="14%" style="font-size:9px">Flight Number</td>
                                        <td width="14%" style="font-size:9px">Departure Time</td>
                                        <td width="14%" style="font-size:9px">Arrival Time</td>
                                        <td width="16%" style="font-size:9px">Overnight Flight</td>
                                    </tr>
                                
                                    <cfif vMissingReport>
                                    
                                        <cfoutput>
                                            <tr class="#iif(vCurrentRow MOD 2 ,DE("off") ,DE("on") )#">
                                                <td style="font-size:9px">#DateFormat(qGetStudentsInRegion.dep_date, "mm/dd/yyyy")#</td>
                                                <td style="font-size:9px">#qGetStudentsInRegion.dep_city# <cfif LEN(qGetStudentsInRegion.dep_aircode)>(#qGetStudentsInRegion.dep_aircode#)</cfif></td>
                                                <td style="font-size:9px">#qGetStudentsInRegion.arrival_city# <cfif LEN(qGetStudentsInRegion.arrival_aircode)>(#qGetStudentsInRegion.arrival_aircode#)</cfif></td>
                                                <td style="font-size:9px">#qGetStudentsInRegion.flight_number#</td>
                                                <td style="font-size:9px">#TimeFormat(qGetStudentsInRegion.dep_time, 'hh:mm tt')#</td>
                                                <td style="font-size:9px">#TimeFormat(qGetStudentsInRegion.arrival_time, 'h:mm tt')#</td>
                                                <td style="font-size:9px">#YesNoFormat(VAL(qGetStudentsInRegion.overnight))#</td>
                                            </tr>
                                            
                                            <cfscript>
                                                // Set Current Row
                                                vCurrentRow ++;			
                                            </cfscript>
                                            
                                        </cfoutput>
                                        
                                    </cfif>
                                    
                                </table>
                                
                            </td>
                            
                        </tr>
                    
                    </cfoutput>
                    
                </table>
        
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

</cfif>

<!--- Page Header --->
<gui:pageFooter />	