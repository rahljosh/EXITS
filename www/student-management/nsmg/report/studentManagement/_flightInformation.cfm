<!--- ------------------------------------------------------------------------- ----
	
	File:		_flightInformation.cfm
	Author:		James Griffiths
	Date:		May 4, 2012
	Desc:		Student Flight Information
				
				#CGI.SCRIPT_NAME#?curdoc=report/index?action=flightInformation
				
	Updated: 				
				
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
    <cfsetting requesttimeout="9999">
    
	<!--- Import CustomTag --->
    <cfimport taglib="../../extensions/customTags/gui/" prefix="gui" />	
	
    <cfscript>	
		// Param FORM Variables
		param name="FORM.programID" default=0;	
		param name="FORM.regionID" default=0;
		param name="FORM.flightType" default=0;
		param name="FORM.dateFrom" default="";
		param name="FORM.dateTo" default="";	
		param name="FORM.outputType" default="onScreen";
		
		// set to 1 if this is a report of missing flight information
		vMissingReport = 1;

		// Get Programs
		qGetPrograms = APPLICATION.CFC.PROGRAM.getPrograms(programIDList=FORM.programID);
		
		// Get Regions
		qGetRegions = APPLICATION.CFC.REGION.getRegions(regionIDList=FORM.regionID);
	</cfscript>
    
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
        INNER JOIN 
            smg_flight_info f ON s.studentid = f.studentid 
                AND 
                    f.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
               
				<cfif FORM.flightType EQ 'mArrival'>
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
                    <cfset vMissingReport=0>
                    AND
                    	s.aypEnglish != <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                <cfelseif FORM.flightType EQ 'mPreAypArrival'>
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
                        <cfset vMissingReport=0>
                        AND
                       		s.aypEnglish != <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                <cfelseif FORM.flightType EQ 'mDeparture'>
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
                        <cfset vMissingReport=0>
                        AND
                        	s.aypEnglish != <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                <cfelse>
                    AND       
                        f.flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.flightType#">
                </cfif>
                <cfif isDate(FORM.dateFrom) AND isDate(FORM.dateTo) AND NOT ListFind("mArrival,mPreAypArrival,mDeparture",FORM.flightType)>
                    AND 
                        f.dep_date BETWEEN <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.dateFrom#"> AND <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.dateTo#">
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
                
        ORDER BY 
            s.familyLastName
    </cfquery>
        
</cfsilent>

<!--- Page Header --->
<gui:pageHeader
	headerType="applicationNoHeader"
/>	

<cfoutput>

	<!--- Report Header Information --->
    <cfsavecontent variable="reportHeader">
    
    	<!--- Get the total number of students (because there are usually several records for each student) --->
    	<cfquery name="qGetTotalStudents" dbtype="query">
        	SELECT DISTINCT
            	studentID
           	FROM
            	qGetResults
        </cfquery>
            
        <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
            <tr>
                <th>Student Management - Flight Information</th>            
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
	<cfheader name="Content-Disposition" value="attachment; filename=studentFlightInformation.xls">
    
    <table width="98%" cellpadding="4" cellspacing="0" align="center" border="1">
        <tr>
            <th colspan="10">Student Management - Student Flight Information</th>            
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
                    <td #vRowColor#></td>
                    <td #vRowColor#></td>
                    <td #vRowColor#></td>
                    <td #vRowColor#></td>
                    <td #vRowColor#></td>
                    <td #vRowColor#></td>
                    <td #vRowColor#></td>
                </tr>
                
                <cfscript>
					vRowNumber++;
				</cfscript>
                
			</cfoutput>
                                
        </cfif>

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
                    <td class="subTitleLeft" width="25%">Student: #qGetStudentsInRegion.firstName# #qGetStudentsInRegion.familyLastName# ###qGetStudentsInRegion.studentID#</strong></td>
                    <td class="subTitleLeft" width="25%">Supervising Representative: #qGetStudentsInRegion.super_firstName# #qGetStudentsInRegion.super_lastName# ###qGetStudentsInRegion.super_ID#</strong></td>
                    <td class="subTitleLeft" width="80%"></td>
              	</tr>
                
                <tr>
                    <td colspan="3" width="100%">
                        <table width="98%" cellpadding="4" cellspacing="0" align="center">
                            <tr>
                                <td width="14%"><u><strong>Date</strong></u></td>
                                <td width="14%"><u><strong>Departure City (Code)</strong></u></td>
                                <td width="14%"><u><strong>Arrival City (Code)</strong></u></td>
                                <td width="14%"><u><strong>Flight Number</strong></u></td>
                                <td width="14%"><u><strong>Departure Time</strong></u></td>
                                <td width="14%"><u><strong>Arrival Time</strong></u></td>
                                <td width="16%"><u><strong>Overnight Flight</strong></u></td>
                            </tr>
                        
                            <cfif vMissingReport>
                            
                                <cfoutput>
                                    <tr class="#iif(vCurrentRow MOD 2 ,DE("off") ,DE("on") )#">
                                        <td>#DateFormat(qGetStudentsInRegion.dep_date, "mm/dd/yyyy")#</td>
                                        <td>#qGetStudentsInRegion.dep_city# <cfif LEN(qGetStudentsInRegion.dep_aircode)>(#qGetStudentsInRegion.dep_aircode#)</cfif></td>
                                        <td>#qGetStudentsInRegion.arrival_city# <cfif LEN(qGetStudentsInRegion.arrival_aircode)>(#qGetStudentsInRegion.arrival_aircode#)</cfif></td>
                                        <td>#qGetStudentsInRegion.flight_number#</td>
                                        <td>#TimeFormat(qGetStudentsInRegion.dep_time, 'hh:mm tt')#</td>
                                        <td>#TimeFormat(qGetStudentsInRegion.arrival_time, 'h:mm tt')#</td>
                                        <td>#YesNoFormat(VAL(qGetStudentsInRegion.overnight))#</td>
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

</cfif>

<!--- Page Header --->
<gui:pageFooter />	