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
        
        // Set Up Report Colors
        if ( FORM.reportOption EQ 'missingDeparture' ) {
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
                u.businessName
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
            WHERE
                s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            AND 
                p.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> )
                
			<!--- Missing Arrival/Departure --->
            <cfswitch expression="#FORM.reportOption#">
                
                <cfcase value="missingArrival">
                    AND 
                        s.studentid NOT IN (
                                                SELECT 
                                                    studentid 
                                                FROM 
                                                    smg_flight_info 
                                                WHERE 
                                                    flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="arrival"> 
                                                AND 
                                                    isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0"> 
                                                AND 
                                                    isCompleted = <cfqueryparam cfsqltype="cf_sql_bit" value="1"> 
                                                AND
                                                    programID = php.programID                                        
                                            )	
                </cfcase>

                <cfcase value="missingDeparture">
                    AND 
                        s.studentid NOT IN (
                                                SELECT 
                                                    studentid 
                                                FROM 
                                                    smg_flight_info 
                                                WHERE 
                                                    flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="departure"> 
                                                AND 
                                                    isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0"> 
                                                AND 
                                                    isCompleted = <cfqueryparam cfsqltype="cf_sql_bit" value="1"> 
                                                AND
                                                    programID = php.programID                                        
                                            )	
                </cfcase>

            </cfswitch>
        
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
                        p.schoolName,
                        s.familyLastName
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
                <td width="200px">International Representative</td>
                <td width="200px">School</td>
                <td width="100px">Flight Missing</td>
            </tr>
            <cfloop query="qGetResults">
                <tr bgcolor="###vColorRow#">
                    <td>#qGetResults.firstName# #qGetResults.familyLastName# (###qGetResults.studentID#)</td>
                    <td>#qGetResults.businessName# (###qGetResults.userID#)</td>                
                    <td>#qGetResults.schoolName# (###qGetResults.schoolID#)</td>  
                    <td>
                    	<cfif FORM.reportOption EQ 'missingArrival'>
                        	Arrival Information
                        <cfelse>
                        	Departure Information
                        </cfif>
                    </td>  
                </tr>
            </cfloop>
        </table>
        <br />
    
    </cfoutput>
    
</cfif>    
        