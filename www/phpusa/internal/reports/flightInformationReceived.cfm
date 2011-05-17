<!--- ------------------------------------------------------------------------- ----
	
	File:		flightInformationReceived.cfm
	Author:		Marcus Melo
	Date:		May 12, 2010
	Desc:		Flight Information Received

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

	<!--- Param FORM Variables --->
    <cfparam name="FORM.programID" default="">
    <cfparam name="FORM.reportOption" default="">
    <cfparam name="FORM.date1" default="">
    <cfparam name="FORM.date2" default="">
    <cfparam name="FORM.orderBy" default="familyLastName">
    
	<cfscript>
        // Data Validation
        // Program ID
        if ( NOT LEN(FORM.programID) ) {
            SESSION.formErrors.Add("Please select at least one program");
        }
        // Flight Option
        if ( NOT LEN(FORM.reportOption) ) {
            SESSION.formErrors.Add("Please select a report option");
        }
        // Date 1
        if ( LEN(FORM.date1) AND NOT IsDate(FORM.date1) ) {
            SESSION.formErrors.Add("Please enter a valid from date");
        }
        // Date 2
        if ( LEN(FORM.date2) AND NOT IsDate(FORM.date2) ) {
            SESSION.formErrors.Add("Please enter a valid to date");
        }
        
        // Set Up Report Colors
        if ( FORM.reportOption EQ 'receivedDeparture' ) {
            vColorTitle = 'FDCEAC';
            vColorRow = 'FEE6D3';
        } else {
            vColorTitle = 'ACB9CD';
            vColorRow = 'D5DCE5';
        }
    </cfscript>
    
    <!--- No Errors - Run Report --->
    <cfif NOT SESSION.formErrors.length()>
        
        <!--- Run Query --->
        <cfquery name="qGetResults" datasource="mysql">
            SELECT DISTINCT 
                s.studentid, 
                s.uniqueid, 
                s.firstname, 
                s.familylastname, 
                p.programname, 
                php.assignedID,
                php.programID,
                sc.schoolID,
                sc.schoolName,
                u.userID,
                u.businessName,
                fInfo.dep_date,
                fInfo.dep_city,
                fInfo.dep_airCode,
                fInfo.dep_city,
                fInfo.dep_airCode,
                fInfo.dep_time,
                fInfo.depDateTime,
                fInfo.flight_number,
                fInfo.arrival_city,
                fInfo.arrival_airCode,
                fInfo.arrival_time,
                fInfo.overnight                    
            FROM 
                smg_students s
            INNER JOIN 
                php_students_in_program php on php.studentid = s.studentid
            INNER JOIN 
                smg_programs p ON php.programid = p.programid
            INNER JOIN
                smg_users u ON u.userID = s.intRep
            LEFT OUTER JOIN
                php_schools sc ON sc.schoolID = php.schoolID                   
            
            <!--- Received Arrival / Departure --->
            <cfswitch expression="#FORM.reportOption#">

                <cfcase value="receivedArrival">
                    INNER JOIN
                        smg_flight_info fInfo ON fInfo.studentID = s.studentID
                            AND	
                                fInfo.flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="arrival"> 
                            AND 
                                fInfo.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0"> 
                            AND
                                fInfo.programID = php.programID 
                                        
                            <cfif IsDate(FORM.date1)>
                                AND
                                    dep_date >= <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.date1#">
                            </cfif>
                            
                            <cfif IsDate(FORM.date2)>
                                AND
                                    dep_date <= <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.date2#">
                            </cfif>
                </cfcase>

                <cfcase value="receivedDeparture">
                    INNER JOIN
                        smg_flight_info fInfo ON fInfo.studentID = s.studentID
                            AND	
                                fInfo.flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="departure"> 
                            AND 
                                fInfo.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0"> 
                            AND
                                fInfo.programID = php.programID 
                                 
                            <cfif IsDate(FORM.date1)>
                                AND
                                    dep_date >= <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.date1#">
                            </cfif>
                            
                            <cfif IsDate(FORM.date2)>
                                AND
                                    dep_date <= <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.date2#">
                            </cfif>
                </cfcase>

            </cfswitch>

            WHERE
                s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            AND 
                p.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> )
            
            ORDER BY 
            
                <cfswitch expression="#FORM.orderBy#">
                
                    <cfcase value="businessName">
                        u.businessName,
                        s.familyLastName,
                        s.firstName
                    </cfcase>

                    <cfcase value="programName">
                        p.programName,
                        s.familyLastName
                    </cfcase>

                    <cfcase value="schoolName">
                        sc.schoolName,
                        s.familyLastName
                    </cfcase>

                    <cfcase value="flightDate">
                        fInfo.dep_date,
                        s.familyLastName,
                        s.firstName
                    </cfcase>

                    <cfdefaultcase>
                        u.businessName,
                        s.familyLastName,
                        s.firstName
                    </cfdefaultcase>
                    
                </cfswitch>
                
        </cfquery>        
    
    </cfif>
                
</cfsilent>
 
<!--- Display Errors --->
<cfif SESSION.formErrors.length()>

	<!--- Table Header --->
    <gui:tableHeader
        width="98%"
        tableTitle="Flight Information Reports"
        imageName="students.gif"
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
	/>

<!--- Report --->
<cfelse>
 
	<cfoutput>
    
        <table width="98%" align="center" cellpadding="3" cellspacing="1" style="border:1px solid ##021157; margin-top:10px;">
            <tr bgcolor="###vColorTitle#" style="font-weight:bold;">
                <td width="300px">Student</td>
                <td width="250px">International Representative</td>
                <td width="250px">School</td>
            </tr>
        </table>
        <br />    
        
    </cfoutput>
    
    <cfoutput query="qGetResults" group="studentID">
    
        <table width="98%" align="center" cellpadding="3" cellspacing="1" style="border-top:1px solid ##021157; border-right:1px solid ##021157; border-left:1px solid ##021157;">
            <tr bgcolor="###vColorTitle#" style="font-weight:bold;">
                <td width="300px">#qGetResults.firstName# #qGetResults.familyLastName# (###qGetResults.studentID#)</td>
                <td width="250px">#qGetResults.businessName# (###qGetResults.userID#)</td>                
                <td width="250px">#qGetResults.schoolName# (###qGetResults.schoolID#)</td>                
            </tr>
        </table>
    
        <table width="98%" align="center" cellpadding="3" cellspacing="1" style="border:1px solid ##021157">
            <tr bgcolor="###vColorTitle#">
               <th width="50px">Date</th>
               <th width="150px">Departure City</th>
               <th width="50px">Airport Code</th>
               <th width="150px">Arrival City</th>
               <th width="50px">Airport Code</th>
               <th width="75px">Flight Number</th>
               <th width="100px">Departure Time</th>
               <th width="100px">Arrival Time</th>
               <th width="75px">Overnight Flight</th>
            </tr>
            <cfoutput>
            <tr bgcolor="###vColorRow#">
                <td align="center">#DateFormat(qGetResults.dep_date , 'mm/dd/yyyy')#&nbsp;</td>
                <td align="center">#qGetResults.dep_city#&nbsp;</td>
                <td align="center">#qGetResults.dep_aircode#&nbsp;</td>
                <td align="center">#qGetResults.arrival_city#&nbsp;</td>
                <td align="center">#qGetResults.arrival_aircode#&nbsp;</td>
                <td align="center">#qGetResults.flight_number#&nbsp;</td>
                <td align="center">#TimeFormat(qGetResults.dep_time, 'hh:mm tt')#&nbsp;</td>
                <td align="center">#TimeFormat(qGetResults.arrival_time, 'h:mm tt')#&nbsp;</td>
                <td align="center">#YesNoFormat(qGetResults.overnight)#</td>
            </tr>
            </cfoutput>
        </table>		
        <br />
                
    </cfoutput>
    
</cfif>    
        