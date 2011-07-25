<!--- ------------------------------------------------------------------------- ----
	
	File:		flight_information_report.cfm
	Author:		Marcus Melo
	Date:		July 25, 2011
	Desc:		Flight Information Arrival Report

	Updated:		

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
	
    <!--- Param FORM Variables --->
    <cfparam name="FORM.programID" default="0">
    <cfparam name="FORM.regionID" default="0">
    <cfparam name="FORM.flight_type" default="arrival">
    <cfparam name="FORM.date1" default="">
    <cfparam name="FORM.date2" default="">
    
    <cfscript>
		// Initialize variable that will hold list of users under an advisor
		vListOfAdvisorUsers = '';	
	</cfscript>
    
	<!--- Get Program --->
    <cfquery name="qGetProgram" datasource="MYSQL">
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
    <cfquery name="qGetRegion" datasource="MySQL">
        SELECT	
        	regionname, 
            regionid
        FROM 
        	smg_regions
        WHERE 
        	company = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
        <cfif VAL(FORM.regionid)>
            AND 
            	regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionid#">	
        </cfif>
        ORDER BY 
        	regionname
    </cfquery>
    
    <!--- advisors --->
    <cfif CLIENT.usertype EQ 6> 
        
        <cfquery name="qGetUserUnderAdv" datasource="MySql">
            SELECT 
            	userid
            FROM 
            	smg_users
            WHERE 
            	advisor_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
            AND 
            	companyID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#CLIENT.companyid#%">
        </cfquery>
    	
        <cfscript>
			// Store Users under Advisor on a list
			vListOfAdvisorUsers = ValueList(qGetUserUnderAdv.userid, ',');
			// Add advisor himself to the list
			vListOfAdvisorUsers = ListAppend(vListOfAdvisorUsers, CLIENT.userid);
		</cfscript>
        
    </cfif> 
    
</cfsilent>

<!--- Page Header --->
<gui:pageHeader
	headerType="applicationNoHeader"
/>	

	<cfoutput>
		
        
        
        <table width="90%" cellpadding="4" cellspacing="0" align="center" style="border:1px solid ##999; margin-bottom:15px;">
            <tr class="reportTitle">
            	<th>
                	<div class="application_section_header">#CLIENT.companyshort# - Flight Arrival Information</div> <br />
                
                	Program(s) : <cfloop query="qGetProgram">#programname# &nbsp; (#ProgramID#) <br /></cfloop>
                </th>
            </tr>
        </table>

	</cfoutput>
        
    <cfloop query="qGetRegion">
    
        <cfquery name="qGetStudentList" datasource="MySql">
            SELECT 	
                s.studentID, 
                s.programID,
                s.firstname, 
                s.familylastname, 
                s.arearepid,
                u.firstname as super_name, 
                u.lastname as super_lastname,
                p.programname,
                r.regionname,
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
                    AND       
                        f.flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.flight_type#">
                    <cfif isDate(FORM.date1) AND isDate(FORM.date2)>
                        AND 
                            f.dep_date 
                        BETWEEN 
                            <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.date1#"> 
                        AND 
                            <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.date2#">
                    </cfif>
                        
            INNER JOIN 
                smg_regions r ON s.regionassigned = r.regionid
            LEFT JOIN 
                smg_users u ON s.arearepid = u.userid
            WHERE 
                s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">             
            AND 
                s.regionassigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRegion.regionid#">
            AND 
                s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> )
            
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
                        s.placerepid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#vListOfAdvisorUsers#" list="yes"> )
                    OR
                        s.arearepid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#vListOfAdvisorUsers#" list="yes"> )
                    )
            </cfif>		
                
            ORDER BY 
                f.dep_date,
                u.lastname, 
                s.firstname
        </cfquery>
        
        <cfoutput>
            
            <table width="90%" cellpadding="4" cellspacing="0" align="center" style="border:1px solid ##999; margin-bottom:15px;">
                <tr>
                    <td width="65%" class="reportTitleLeft">
                        Region: #qGetRegion.regionname# 
                    </td>
                    <td width="35%" class="reportTitleRight">
                        Total of #qGetStudentList.recordcount# student(s)
                    </td>
                </tr>
            </table>

            <table width="90%" cellpadding="4" cellspacing="0" align="center" style="border:1px solid ##999; margin-bottom:15px;">
                <tr class="reportTitleLeft">
                    <td width="65%">Student</td>
                    <td width="35%">Supervising Representative</td>
                </tr>
            </table>

        </cfoutput>

		<cfoutput query="qGetStudentList" group="studentID">

            <table width="90%" cellpadding="4" cellspacing="0" align="center" style="border:1px solid ##999; font-weight:bold;">
                <tr>
                    <td width="65%">#qGetStudentList.firstname# #qGetStudentList.familylastname# (#qGetStudentList.studentid#)</td>
                    <td width="35%">#qGetStudentList.super_name# #qGetStudentList.super_lastname#</td>
                </tr>
            </table>
            
            <table width="90%" cellpadding="4" cellspacing="0" align="center" style="border:1px solid ##999; margin-bottom:15px;">                                            
                <tr style="background-color:##ACB9CD;">
                    <th>Date</th>
                    <th>Departure City</th>
                    <th>Airport Code</th>
                    <th>Arrival City</th>
                    <th>Airport Code</th>
                    <th>Flight Number</th>
                    <th>Departure Time</th>
                    <th>Arrival Time</th>
                    <th>Overnight Flight</th>
                </tr>
                <cfoutput>
                    <tr style="background-color:##D5DCE5;">
                        <td align="center">#DateFormat(qGetStudentList.dep_date , 'mm/dd/yyyy')# &nbsp;</td>
                        <td align="center">#qGetStudentList.dep_city# &nbsp;</td>
                        <td align="center">#qGetStudentList.dep_aircode# &nbsp;</td>
                        <td align="center">#qGetStudentList.arrival_city# &nbsp;</td>
                        <td align="center">#qGetStudentList.arrival_aircode# &nbsp;</td>
                        <td align="center">#qGetStudentList.flight_number# &nbsp;</td>
                        <td align="center">#TimeFormat(qGetStudentList.dep_time, 'hh:mm tt')# &nbsp;</td>
                        <td align="center">#TimeFormat(qGetStudentList.arrival_time, 'h:mm tt')# &nbsp;</td>
                        <td align="center">#YesNoFormat(VAL(qGetStudentList.overnight))# &nbsp;</td>
                    </tr>
                    <cfif VAL(qGetStudentList.overnight)>
                        <tr style="background-color:##D5DCE5;">
                            <td colspan="9" align="center">Please note arrival time is the next day due to an overnight flight.</td>
                        </tr>
                    </cfif>	
                </cfoutput>
            </table>
        
        </cfoutput> <!--- student --->
        
    </cfloop> <!--- region --->

<!--- Page Footer --->
<gui:pageFooter
	footerType="application"
/>
