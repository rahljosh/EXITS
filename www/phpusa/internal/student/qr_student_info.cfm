<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../upi.css" type="text/css">
<title>Update Student Info</title>
</head>

<body>

<!----
<cftry>
---->
<cfif NOT IsDefined('form.studentid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<cfquery name="get_student_info" datasource="mysql">
	SELECT 
    	s.studentid, 
        s.uniqueid, 
        s.jan_app, 
        s.firstname, 
        s.familylastname, 
        s.intRep,
		stu_prog.assignedid, 
        stu_prog.hostid, stu_prog.schoolid, 
        stu_prog.programid, 
        stu_prog.school_acceptance,
        stu_prog.i20no,
        stu_prog.i20received,
        stu_prog.canceldate,
		u.businessname,
		sc.schoolname
	FROM smg_students s
	INNER JOIN php_students_in_program stu_prog ON stu_prog.studentid = s.studentid
	LEFT JOIN smg_users u ON u.userid = s.intrep
	LEFT JOIN php_schools sc ON sc.schoolid = stu_prog.schoolid
	WHERE s.studentid = '#form.studentid#'
		AND stu_prog.assignedid = '#form.assignedid#'
		<!--- AND stu_prog.active = '1' --->
</cfquery>

<cfquery name="get_non_transfer_student" datasource="MySql">
	SELECT studentid, companyid
	FROM smg_students
	WHERE smg_students.studentid = '#form.studentid#'
</cfquery>

<!--- PROGRAM HISTORY --->
<cfif get_student_info.programid NEQ form.program>
	<cfquery name="program_history" datasource="mysql">
		INSERT INTO smg_programhistory
			(studentid, programid, reason, changedby,  date)
		VALUES
			('#get_student_info.studentid#', '#form.program#', 
			<cfif get_student_info.programid NEQ '0'>'#form.program_reason#', <cfelse> 'Student was unassigned',</cfif>
			'#client.userid#', #CreateODBCDateTime(now())# )
	</cfquery>
</cfif>

<!---  CANCELLING A STUDENT --->
<cfif IsDefined("form.student_cancel")>
	
	<cfif get_student_info.hostid NEQ 0 AND get_student_info.canceldate EQ ''>
		
        <cfquery name="hostchangereason" datasource="mysql">		
			INSERT INTO smg_hosthistory	(hostid, studentid, schoolid, dateofchange, changedby, reason)
			VALUES('#get_student_info.hostid#', '#get_student_info.studentid#', '#get_student_info.schoolid#', 
				#CreateODBCDateTime(now())#, 
				'#client.userid#','Student Canceled Program for the following reason: #form.Reason_canceled#')
		</cfquery>
        
	</cfif> 
    
	<cfquery name="cancel_student" datasource="mysql">
		UPDATE php_students_in_program
		SET canceldate = #CreateODBCDate(form.date_canceled)#, 
			cancelreason = '#form.Reason_canceled#', 
			active = '0',
			canceledby = '#client.userid#'
		WHERE assignedid = '#get_student_info.assignedid#'
	</cfquery>
	
	<!--- CANCEL STUDENT IN THE F1 STUDENTS TABLE --->
	<cfif get_non_transfer_student.companyid EQ '6'>
		
        <cfquery name="cancel_student_table" datasource="MySql">
			UPDATE php_students_in_program
			SET canceldate = #CreateODBCDate(form.date_canceled)#, 
				cancelreason = '#form.Reason_canceled#', 
				active = '0'
			WHERE studentid = '#form.studentid#'	
			LIMIT 1
		</cfquery>
        
	</cfif>
	
	<!--- let student be active and canceled for invoicing reasons ---->
	
	<cfif isDefined('form.active')>
		<cfquery name="set_student_active_status" datasource="mysql">
		update php_students_in_program
		set active = 1
		where studentid = '#form.studentid#'
		</cfquery>
	<cfelse>
		<cfquery name="set_student_active_status" datasource="mysql">
		update php_students_in_program
		set active = 0
		where studentid = '#form.studentid#'
		</cfquery>
	</cfif>
	
 	<!--- SEND EMAIL TO CRAIG --->
	<cfquery name="get_sender" datasource="MySql">
		SELECT userid, firstname, lastname, email
		FROM smg_users
		WHERE userid = '#client.userid#'
	</cfquery>
    
	<cfmail to="#AppEmail.finance#" from="#AppEmail.support#" subject='PHP Cancelation - #get_student_info.firstname# #get_student_info.familylastname# (###get_student_info.studentid#)' type="html" failto="support@phpusa.com">
		<table align="center">
			<tr><td><img src="http://www.phpusa.com/images/dmd_banner.gif" align="Center"></td></tr>
			<tr><td align="center"><h1>Cancelation Notice</h1></td></tr>
		</table>
		
        <table align="center">
			<tr><td>This email is to let you know that a student was canceled in the database.</td></tr>
			<tr><td>Intl. Rep.: #get_student_info.businessname# (###get_student_info.intRep#) </td></tr>
			<tr><td>Student: #get_student_info.firstname# #get_student_info.familylastname# (###get_student_info.studentid# - Assigned ID ###get_student_info.assignedid#)</td></tr>
            <tr><td>Cancel Date: #DateFormat(form.date_canceled, 'mm/dd/yyyy')#</td></tr>
			<tr><td>Cancel Reason: #form.Reason_canceled#</td></tr>
            <tr><td>Applying School: <cfif LEN(get_student_info.schoolname)> #get_student_info.schoolname# <cfelse> n/a </cfif> </td></tr>
			<tr><td>Status: <cfif LEN(get_student_info.school_acceptance)> Accepted <cfelse> Not Accepted/Pending </cfif> </td></tr>
            <tr><td>I-20: <cfif LEN(get_student_info.i20received) OR LEN(get_student_info.i20no)> Received n: #get_student_info.i20no# <cfelse> Not Received </cfif> </td></tr>
            <tr><td>Canceled by: #get_sender.firstname# #get_sender.lastname#</td></tr>		
		</table><br>
	</cfmail>

    <cflocation url="?curdoc=student/student_info&unqid=#get_student_info.uniqueid#" addtoken="no">
	<cfabort>

</cfif>


<cftransaction>

	<!--- UPDATE STUDENT INFORMATION - STUDENT TABLE --->
    <cfquery name="Update_Student" datasource="mysql">
        UPDATE smg_students
        SET intrep = #form.intrep#
        WHERE studentid = '#get_student_info.studentid#'
        LIMIT 1
    </cfquery>
    
    <!--- UPDATE STUDENT IN COMPANY INFORMATION --->
    <cfquery name="Update_Student" datasource="mysql">
        UPDATE php_students_in_program
        SET <cfif IsDefined('form.active')>
                active = '1',
                canceldate = NULL, 
                cancelreason = '', 	
            <cfelse>
                active = '0',	
            </cfif>
            programid = '#form.program#',
            i20no ='#form.i20no#',
            i20received = <cfif form.i20received EQ ''>null<cfelse>#CreateODBCDate(form.i20received)#</cfif>,
            i20sent = <cfif form.i20sent EQ ''>null<cfelse>#CreateODBCDate(form.i20sent)#</cfif>,
            i20note = '#form.i20note#',
            return_student = #form.return_student#		
        WHERE assignedid = '#get_student_info.assignedid#'
    </cfquery>

</cftransaction> 

<cflocation url="?curdoc=student/student_info&unqid=#get_student_info.uniqueid#" addtoken="no">

<!----
<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>

</cftry>
---->
</body>
</html>