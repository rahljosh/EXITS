<!--- Kill Extra Output --->
<cfsilent>

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
    
    <cfquery name="qGetStudentInfo" datasource="MySql">
        SELECT 
            s.studentID, 
            s.uniqueid, 
            s.jan_app, 
            s.firstname, 
            s.familylastname, 
            s.intRep,
            stu_prog.assignedID, 
            stu_prog.hostid, 
            stu_prog.schoolID, 
            stu_prog.programID, 
            stu_prog.school_acceptance,
            stu_prog.i20no,
            stu_prog.i20received,
            stu_prog.canceldate,
            smg_programs.programname,
            u.businessname,
            sc.schoolname
        FROM 
        	smg_students s
        INNER JOIN 
        	php_students_in_program stu_prog ON stu_prog.studentID = s.studentID
        LEFT OUTER JOIN
        	smg_programs ON smg_programs.programid = stu_prog.programID
        LEFT JOIN 
        	smg_users u ON u.userid = s.intrep
        LEFT JOIN 
        	php_schools sc ON sc.schoolID = stu_prog.schoolID
        WHERE 
        	s.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.studentID#">
		AND 
        	stu_prog.assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.assignedID#">
        <!--- 
			AND stu_prog.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1"> 
		--->
    </cfquery>
	
</cfsilent>

<cfif NOT IsDefined('FORM.studentID')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<cfquery name="get_non_transfer_student" datasource="MySql">
	SELECT 
    	studentID, 
        companyid
	FROM 
    	smg_students
	WHERE 
    	smg_students.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.studentID#">
</cfquery>


<!--- UPDATE STUDENT INFORMATION - STUDENT TABLE --->
<cfquery datasource="MySql">
	UPDATE 
		smg_students
	SET 
		intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.intrep#">
	WHERE 
		studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.studentID#">
	LIMIT 1
</cfquery>


<!--- UPDATE STUDENT IN COMPANY INFORMATION --->
<cfquery datasource="MySql">
	UPDATE 
		php_students_in_program
	SET 
		<cfif IsDefined('FORM.active')>
			active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">,
			canceldate = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">, 
			cancelreason = <cfqueryparam cfsqltype="cf_sql_varchar" value="">, 	
		<cfelse>
			active = <cfqueryparam cfsqltype="cf_sql_integer" value="0">,	
		</cfif>
		programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.program#">,
		i20no = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.i20no#">,
		<cfif FORM.i20received EQ ''>
			i20received =  <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,
		<cfelse>
			i20received = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(FORM.i20received)#">,
		</cfif>
		<cfif FORM.i20sent EQ ''>
			i20sent = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,
		<cfelse>
			i20sent = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(FORM.i20sent)#">,
		</cfif>
		i20note = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.i20note#">,
		return_student = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.return_student#">		
	WHERE 
		assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.assignedID#">
</cfquery>


<!--- PROGRAM HISTORY --->
<cfif qGetStudentInfo.programID NEQ FORM.program>
	
    <cfquery datasource="MySql">
		INSERT INTO 
       		smg_programhistory
		(
        	studentID, 
            programID,
            reason, 
            changedby,  
            date
        )
		VALUES
		(
        	<cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.studentID#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.program#">, 
			<cfif VAL(qGetStudentInfo.programID)>
            	<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.program_reason#">,
            <cfelse> 
            	<cfqueryparam cfsqltype="cf_sql_varchar" value="Student was unassigned">,
            </cfif>
			<cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">,
            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#">
		)
	</cfquery>
    
</cfif>


<!---  CANCELLING A STUDENT --->
<cfif IsDefined("FORM.student_cancel")>
	
	<cfif qGetStudentInfo.hostid NEQ 0 AND qGetStudentInfo.canceldate EQ ''>
		
        <cfquery datasource="MySql">		
			INSERT INTO 
            	smg_hosthistory	
            (
            	hostid, 
                studentID, 
                schoolID, 
                dateofchange, 
                changedby, 
                reason
            )
			VALUES
            (
            	<cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.hostid#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.studentID#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.schoolID#">, 
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="Student Canceled Program for the following reason: #FORM.Reason_canceled#">
            )
		</cfquery>
        
	</cfif> 
    
	<cfquery datasource="MySql">
		UPDATE
        	php_students_in_program
		SET 
        	canceldate = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(FORM.date_canceled)#">, 
			cancelreason = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.Reason_canceled#">, 
			active = <cfqueryparam cfsqltype="cf_sql_integer" value="0">,
			canceledby = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
		WHERE 
        	assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.assignedID#">
	</cfquery>
	
	<!--- CANCEL STUDENT IN THE F1 STUDENTS TABLE --->
	<cfif get_non_transfer_student.companyid EQ 6>
		
        <cfquery datasource="MySql">
			UPDATE 
            	php_students_in_program
			SET 
            	canceldate = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(FORM.date_canceled)#">, 
				cancelreason = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.Reason_canceled#">, 
				active = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
			WHERE 
            	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.studentID#">	
			LIMIT 1
		</cfquery>
        
	</cfif>

    
    <!--- Email Finance Department --->
	<cfmail to="#APPLICATION.EMAIL.cancellation#" 
    	from="#APPLICATION.EMAIL.support#" 
        subject="PHP Cancelation - #qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# (###qGetStudentInfo.studentID#) - #qGetStudentInfo.programname# (###qGetStudentInfo.programID#)" 
        type="html" 
        failto="support@phpusa.com">
		<table align="center">
			<tr><td><img src="http://www.phpusa.com/images/dmd_banner.gif" align="Center"></td></tr>
			<tr><td align="center"><h1>Cancelation Notice</h1></td></tr>
		</table>
		
        <table align="center">
			<tr><td>This email is to let you know that a student was canceled in the database.</td></tr>
			<tr><td>Intl. Rep.: #qGetStudentInfo.businessname# (###qGetStudentInfo.intRep#) </td></tr>
			<tr><td>Student: #qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# (###qGetStudentInfo.studentID# - Assigned ID ###qGetStudentInfo.assignedID#)</td></tr>
            <tr><td>Program: #qGetStudentInfo.programname# (###qGetStudentInfo.programID#) </td></tr>
            <tr><td>Cancel Date: #DateFormat(FORM.date_canceled, 'mm/dd/yyyy')#</td></tr>
			<tr><td>Cancel Reason: #FORM.Reason_canceled#</td></tr>
            <tr><td>Applying School: <cfif LEN(qGetStudentInfo.schoolname)> #qGetStudentInfo.schoolname# <cfelse> n/a </cfif> </td></tr>
			<tr><td>Status: <cfif LEN(qGetStudentInfo.school_acceptance)> Accepted <cfelse> Not Accepted/Pending </cfif> </td></tr>
            <tr><td>I-20: <cfif LEN(qGetStudentInfo.i20received) OR LEN(qGetStudentInfo.i20no)> Received n: #qGetStudentInfo.i20no# <cfelse> Not Received </cfif> </td></tr>
            <tr><td>Canceled by: #qGetCurrentUser.firstname# #qGetCurrentUser.lastname#</td></tr>		
		</table><br>
	</cfmail>

    <cflocation url="?curdoc=student/student_info&unqid=#qGetStudentInfo.uniqueid#" addtoken="no">
	<cfabort>

</cfif>

<cflocation url="?curdoc=student/student_info&unqid=#qGetStudentInfo.uniqueid#" addtoken="no">

</body>
</html>