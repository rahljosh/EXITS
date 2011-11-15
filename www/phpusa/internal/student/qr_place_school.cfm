<!--- Kill Extra Output --->
<cfsilent>

	<!--- Param Form Variables --->
	<cfparam name="FORM.studentID" default="0">
	<cfparam name="FORM.assignedID" default="0">
	<cfparam name="FORM.updateSchool" default="0">
	<cfparam name="FORM.schoolID" default="0">
    <cfparam name="FORM.reason" default="0">

	<!--- Used to Send Emails  --->
    <cfquery name="qGetCurrentUser" datasource="MySql">
        SELECT 
        	userid, 
            firstname, 
            lastname, 
            email
        FROM 
        	smg_users
        WHERE 
        	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
    </cfquery>
    
    <cfquery name="qGetProgramInfo" datasource="mysql">
        SELECT DISTINCT 
        	s.studentID,
            s.uniqueID,
            s.firstName,
            s.familyLastName,
            s.intRep,
            php.assignedID, 
            php.programid,
            php.arearepid, 
            php.placerepid, 
            php.schoolID, 
            php.hostid,
            smg_programs.programname,
            ps.schoolName,
            intRep.businessName
        FROM 
        	php_students_in_program php
        INNER JOIN
        	smg_students s ON s.studentID = php.studentID
        INNER JOIN
        	smg_programs ON smg_programs.programid = php.programid
        LEFT OUTER JOIN
        	php_schools ps ON ps.schoolID = php.schoolID    
        LEFT OUTER JOIN
        	smg_users intRep ON intRep.userID = s.intRep
        WHERE 
        	php.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.studentID#">
        AND 
        	php.assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.assignedID#"> 
        AND 
        	php.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
    </cfquery>	
    
</cfsilent>
    
<!---  SELECT NEW SCHOOL --->
<cfif NOT VAL(FORM.updateSchool)>

    <Cfquery name="place_school" datasource="mysql">
        UPDATE 
        	php_students_in_program
        SET 
        	schoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.schoolID#">,
            dateplaced = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(now())#">
        WHERE 
        	assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetProgramInfo.assignedID#">
        LIMIT 1
    </cfquery>

<!--- UPDATE/CHANGE CURRENT SCHOOL --->
<cfelse>

    <Cfquery name="place_school" datasource="mysql">
        UPDATE 
        	php_students_in_program
        SET 
        	schoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.schoolID#">,
            <cfif NOT VAL(FORM.schoolID)>
            	dateplaced = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,
            <cfelse>
            	dateplaced = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(now())#">,
            </cfif>
            school_acceptance = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,
            i20received = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,
            hf_placement = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,
            hf_application = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,
            doubleplace = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
        WHERE 
        	assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetProgramInfo.assignedID#">
        LIMIT 1
    </cfquery>

	<!--- Make sure there is a new school assigned and not set to unplaced --->
	<cfif VAL(FORM.schoolID)>

        <cfquery name="qGetNewSchool" datasource="mysql">
            SELECT 
            	schoolID,
                schoolName
            FROM 
            	php_schools 
			WHERE	                
                schoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.schoolID#">
        </cfquery>	

		<!--- Email Finance Department --->
        <cfmail to="#AppEmail.finance#" 
            from="#AppEmail.support#" 
            subject="PHP School Change Notification - #qGetProgramInfo.firstname# #qGetProgramInfo.familylastname# (###qGetProgramInfo.studentID#)" 
            type="html" 
            failto="support@phpusa.com">
            <table align="center">
                <tr><td><img src="http://www.phpusa.com/images/dmd_banner.gif" align="Center"></td></tr>
                <tr><td align="center"><h1>School Notification</h1></td></tr>
            </table>
            
            <table align="center">
                <tr><td>This email is to let you know that a student changed school in the database.</td></tr>
                <tr><td>Intl. Rep.: #qGetProgramInfo.businessname# (###qGetProgramInfo.intRep#) </td></tr>
                <tr><td>Student: #qGetProgramInfo.firstname# #qGetProgramInfo.familylastname# (###qGetProgramInfo.studentID# - Assigned ID ###qGetProgramInfo.assignedID#)</td></tr>
                <tr><td>Program: #qGetProgramInfo.programname# (###qGetProgramInfo.programID#) </td></tr>
                <tr><td>Change Date: #DateFormat(now(), 'mm/dd/yyyy')#</td></tr>
                <tr><td>Previous School: #qGetProgramInfo.schoolName# (###qGetProgramInfo.schoolID#) </td></tr>
                <tr><td>New School: #qGetNewSchool.schoolName# (###qGetNewSchool.schoolID#)</td></tr>
                <tr><td>Reason: #FORM.reason#</td></tr>
                <tr><td>Changed by: #qGetCurrentUser.firstname# #qGetCurrentUser.lastname#</td></tr>		
            </table><br>
        </cfmail>

	</cfif>

</cfif>

<cflocation url="place_menu.cfm?unqid=#qGetProgramInfo.uniqueID#&assignedID=#qGetProgramInfo.assignedID#" addtoken="no">	

</body>
</html>