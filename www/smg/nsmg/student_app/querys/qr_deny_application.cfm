<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Application Denial</title>
</head>

<body>

<cftransaction>
	<cfquery name="get_latest_date" datasource="MySQL">
		SELECT max(date) as date
		FROM smg_student_app_status
		WHERE studentID = <cfqueryparam value="#FORM.studentID#" cfsqltype="cf_sql_integer">
	</cfquery>
	<cfquery name="get_status" datasource="MySQL">
		SELECT * 
		FROM smg_student_app_status
		WHERE studentID = <cfqueryparam value="#FORM.studentID#" cfsqltype="cf_sql_integer">
		ORDER BY id DESC
	</cfquery>

	<cfif get_status.status EQ 3 OR get_status.status EQ 4> <!--- STATUS = 3 -> DENIED = 4 BRANCH --->
		<cfset newstatus = 4>
	<cfelseif get_status.status EQ 5 OR get_status.status EQ 9> <!--- STATUS = 5 -> DENIED = 6 AGENT --->
		<cfset newstatus = 6>
	<cfelseif get_status.status EQ 7 OR get_status.status EQ 8 OR get_status.status EQ 10> <!--- STATUS = 7 SUBMITTED / 8 RECEIVED / 10 ON HOLD --->
		<cfset newstatus = 9>
	<cfelseif get_status.status EQ 6> <!----being denied by branch---->
		<cfset newstatus = 4>
	</cfif>

	<cfquery name="deny_application_status" datasource="MySQL">
		INSERT INTO smg_student_app_status (studentID, status, reason, date, approvedby)
		VALUES (#FORM.studentID#, #newstatus#, '#FORM.reason#', #now()#, '#client.userid#')
	</cfquery>
	
	<cfif newstatus EQ '9'> <!--- DENIED BY SMG --->
		<cfquery name="deny_application" datasource="MySQL">
			UPDATE smg_students 
			SET app_current_status = '#newstatus#',
				companyid = '#FORM.companyid#',
				cancelreason = '#FORM.reason#',
				active = '0',
				canceldate = #CreateODBCDate(now())#
			WHERE studentID = '#FORM.studentID#'
			LIMIT 1
		</cfquery>
	<cfelse>
		<cfquery name="deny_application" datasource="MySQL">
			UPDATE smg_students 
			SET app_current_status = '#newstatus#',
				dateapplication = #CreateODBCDate(now())#
			WHERE studentID = '#FORM.studentID#'
		</cfquery>
	</cfif>
	
</cftransaction>

<cfif newstatus LT 9>
	<cfquery name="get_email" datasource="mysql">
		SELECT s.studentID, s.email, s.firstname, s.familylastname, s.password, 
			u.email as intrepemail, u.businessname,
			c.companyshort, c.companyname, c.admission_person, c.phone
		FROM smg_students s
		INNER JOIN smg_users u ON u.userid = s.branchid
		LEFT JOIN smg_companies c ON c.companyid = s.companyid
		WHERE studentID = '#FORM.studentID#'
	</cfquery>
</cfif>

<Cfif newstatus LT 9>
	<!----Check if student is assigned to a branch---->
	<cfquery name="check_branch" datasource="mysql">
	select branchid 
	from smg_students
	where studentID = #FORM.studentID#
	</cfquery>
	
<cfoutput>
	<cfif check_branch.branchid eq 0>
	<!----Studnet is filing out application directly with parent company, only send email to student saying app denied---->
	<cfquery name="student_email" datasource="mysql">
		Select s.studentID, s.email, s.firstname, s.familylastname, s.intrep,
		u.businessname, u.email as intrepemail, u.phone
		from smg_students s
		inner join smg_users u on u.userid = s.intrep 
		where studentID = #FORM.studentID#
	</cfquery>
		<!----Email CFC---->
        <cfsavecontent variable="email_message">
        #student_email.firstname#-
            <br><br>
            Your application has been denied by #student_email.businessname#.<br><br>
                                    
            Login to your account at #client.exits_url# to view the reason why, and if necessary, resubmit your application.<br>
            <br>
            Please contact 
            #student_email.businessname# at #student_email.phone# or by replying to this email if you have any questions.	
            <br><br>
            EXITS 						
            <br><br>
        </cfsavecontent>
        <cfinvoke component="nsmg.cfc.email" method="send_mail">
                <cfinvokeargument name="email_to" value="#student_email.email#">
                <cfinvokeargument name="email_subject" value="#client.companyshort# Application Denied">
                <cfinvokeargument name="email_message" value="#email_message#">
                <cfinvokeargument name="email_replyto" value="#student_email.intrepemail#">
                <cfinvokeargument name="email_from" value="#client.support_email#">
            </cfinvoke>
        <!----End Email CFC---->

	<cfelse>

	<cfquery name="student_email" datasource="mysql">
		SELECT s.studentID, s.email, s.firstname, s.familylastname, s.branchid,
			u.studentcontactemail as branchemail, u.businessname, s.intrep, s.branchid,
			u.email as intrepemail, u.phone
		FROM smg_students s
		INNER JOIN smg_users u ON u.userid = s.branchid
		WHERE studentID = #FORM.studentID#
	</cfquery>
		<!----Email CFC---->
        <cfsavecontent variable="email_message">
        #student_email.firstname#-
            <br><br>
            Your application has been denied by #student_email.businessname#.<br><br>
                                    
            Login to your account at #client.exits_url# to view the reason why, and if necessary, resubmit your application.<br>
            <br>
            Please contact 
            #student_email.businessname# at #student_email.phone# or by replying to this email if you have any questions.	
            <br><br>
            EXITS 						
            <br><br>
        </cfsavecontent>
        <cfinvoke component="nsmg.cfc.email" method="send_mail">
                <cfinvokeargument name="email_to" value="#student_email.branchemail#">
                <cfinvokeargument name="email_subject" value="#client.companyshort# Application Denied">
                <cfinvokeargument name="email_message" value="#email_message#">
                <cfinvokeargument name="email_replyto" value="#student_email.branchemail#">
                <cfinvokeargument name="email_from" value="#client.support_email#">
            </cfinvoke>
        <!----End Email CFC---->
        
	
	</cfif>
	</cfoutput>	
</Cfif>

<!--- SMG DENIES APPLICATION --->
<cfif newstatus EQ 9> 
	<cfquery name="get_email" datasource="mysql">
		SELECT s.studentID, s.email, s.firstname, s.familylastname, s.password, 
			u.email as intrepemail, u.businessname,
			c.companyshort, c.companyname, c.admission_person, c.phone
		FROM smg_students s
		INNER JOIN smg_users u ON u.userid = s.intrep
		LEFT JOIN smg_companies c ON c.companyid = s.companyid
		WHERE studentID = '#FORM.studentID#'
	</cfquery>
	
	<cfquery name="get_current_user" datasource="MySql">
		SELECT userid, firstname, lastname, email
		FROM smg_users
		WHERE userid = '#client.userid#'
	</cfquery>
	
	<cfif IsValid("email", get_email.intrepemail)>
	
	<cfoutput query="get_email">
 		<!----Email CFC---->
        <cfsavecontent variable="email_message">
                Dear #businessname#-
                <br><br>						
                The application for #firstname# #familylastname# (###studentID#) has been reviewed by our admissions staff and after a complete review
                of the application it has been determined that the application will not be accepted into the program. 
                The application has been rejected due to the following reason: 
                
                <br>
                <b>Reason: #FORM.reason#</b>
                <br>
                
                Due to Department of State Regulations, program requirements and  acceptance deadlines this application will not be re-considered for 
                acceptance during the current program cycle. Please contact me directly if you require the original application be returned to you at any time.
                
        <br><br>
        
        Sincerely,<br>
        #get_current_user.firstname# #get_current_user.lastname#<br>
        #companyname#							
        <br><br>
        </cfsavecontent>
        <cfinvoke component="nsmg.cfc.email" method="send_mail">
                <cfinvokeargument name="email_to" value="#get_email.intrepemail#">
                <cfinvokeargument name="email_subject" value="#client.companyshort# Application Denied">
                <cfinvokeargument name="email_message" value="#email_message#">
                <cfinvokeargument name="email_from" value="#client.support_email#">
            </cfinvoke>
        <!----End Email CFC---->
        
        
      
		</cfoutput>
	</cfif>
</cfif>

<meta http-equiv="refresh" content="3;url=close_window.cfm">
<body onload="opener.location.reload()"> 
<style type="text/css">
.thin-border{ border: 1px solid ##000000;}
</style>
<table width=550 class="thin-border" cellspacing="0" cellpadding=0 align="center">
	
	<tr><td>This application has been denied.  This window should close automatically.</td></tr>
</table>

</body>
</html>