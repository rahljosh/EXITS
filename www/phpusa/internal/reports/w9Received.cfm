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
        //if ( NOT LEN(FORM.reportOption) ) {
        //    SESSION.formErrors.Add("Please select a report option");
        //}
        // Date 1
        //if ( LEN(FORM.date1) AND NOT IsDate(FORM.date1) ) {
        //    SESSION.formErrors.Add("Please enter a valid from date");
        //}
        // Date 2
        //if ( LEN(FORM.date2) AND NOT IsDate(FORM.date2) ) {
        //    SESSION.formErrors.Add("Please enter a valid to date");
        //}
		
        // Set Up Report Colors
        if ( FORM.reportOption EQ 'receivedW(' ) {
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
            s.sex, 
            s.country, 
            u.userid, 
            u.businessname,
            sc.schoolid, 
            sc.schoolname,
            smg_countrylist.countryname, 
            smg_programs.programname,
            stu_prog.programid, 
            stu_prog.assignedid, 
            h.familylastname as hostlastname, 
            h.fatherfirstname,
            h.motherfirstname,
            h.father_w9, 
            h.mother_w9,
            h.hostid,
            IFNULL(alp.name, 'n/a') AS PHPReturnOption
        FROM smg_students s
        INNER JOIN php_students_in_program stu_prog ON stu_prog.studentid = s.studentid
        LEFT JOIN smg_countrylist ON smg_countrylist.countryid = s.country  
        LEFT JOIN smg_programs ON smg_programs.programid = stu_prog.programid 
        LEFT JOIN smg_users u on u.userid = s.intrep 
        LEFT JOIN php_schools sc ON sc.schoolid = stu_prog.schoolid
        LEFT JOIN smg_hosts h ON h.hostid = stu_prog.hostID
        LEFT OUTER JOIN applicationlookup alp ON alp.fieldID = stu_prog.return_student
       	AND fieldKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="PHPReturnOptions">
		
        WHERE stu_prog.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
        and stu_prog.programid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> )
   		 and stu_prog.hostid != 0 
            
       
           
        
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
    
     
    
        <table width="98%" align="center" cellpadding="3" cellspacing="1" style="border:1px solid ##021157">
            <tr bgcolor="##FDCEAC">
               <th width=250px>Student</th>
               <th width=80px>Program</th>
               <th width=50px>Host ID</th>
               <th width=250px>Family Name</th>
               <th width=150px>Father Name</th>
               <th width=80px>Father W9 Date</th>
               <th width=150px>Mother Name</th>
               <th width=80px>Mother W9 Date</th>
               

            </tr>
            <cfloop  query="qGetResults" group="studentID">
                <tr bgcolor="##FEE6D3">
                	<td>#qGetResults.familylastname# #qGetResults.firstname#</td>
                    <Td>#qGetResults.programname#</Td>
                	<td><a href="curdoc=host_fam_info&hostid=#qGetResults.hostid#">#qGetResults.hostid#&nbsp;</a></td>
                    <td>#qGetResults.familylastname#&nbsp;</td>
                    <td>#qGetResults.fatherfirstname#&nbsp;</td>
                    <td <cfif fatherfirstname is not '' and father_w9 is ''>bgcolor="##CC99CC"</cfif>>#qGetResults.father_w9#&nbsp;</td>
                    <td>#qGetResults.motherfirstname#&nbsp;</td>
                    <td <cfif motherfirstname is not '' and mother_w9 is ''>bgcolor="##CC99CC"</cfif>>#qGetResults.mother_w9#&nbsp;</td>
                  
                    

                </tr>
            </cfloop>
     
                
    </cfoutput>
       </table>		
        <br />
</cfif>    
        