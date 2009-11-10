<cftry>

<cftransaction>	

	<cfif IsDefined('url.studentid')>
		<cfset client.studentid = url.studentid>
	</cfif>

	<cfquery name="get_student" datasource="MySql">
		SELECT s.studentid, s.firstname, s.familylastname, s.programid, s.companyid, s.cancelreason, s.email, s.app_indicated_program,
			u.userid, u.businessname, u.email as intrepemail, u.congrats_email
		FROM smg_students s
		INNER JOIN smg_users u ON u.userid = s.intrep
		WHERE s.studentid = <cfqueryparam value="#client.studentid#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfquery name="get_program" datasource="MySQL">
		SELECT app_programid, app_program 
		FROM smg_student_app_programs
		WHERE app_programid = '#get_student.app_indicated_program#'
	</cfquery>

	<cfquery name="get_latest_date" datasource="MySQL">
		SELECT max(date) as date
		FROM smg_student_app_status
		WHERE studentid = <cfqueryparam value="#client.studentid#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<cfquery name="get_status" datasource="MySQL">
		SELECT * 
		FROM smg_student_app_status
		WHERE date = '#get_latest_date.date#' 
			AND studentid = <cfqueryparam value="#client.studentid#" cfsqltype="cf_sql_integer">
	</cfquery>

	<!--- APPROVE FEATURE -> BRANCHES/AGENTS/OFFICE --->
	<cfif get_status.status EQ 2> <!--- ACTIVE --->
		<cfset newstatus = 3>
	<cfelseif get_status.status EQ 3 OR get_status.status EQ 4> <!--- SUBMITTED TO BRANCH / DENIED BY BRANCH --->
		<cfset newstatus = 5>
	<cfelseif get_status.status EQ 5 OR get_status.status EQ 6>	<!--- SUBMITTED TO AGENT / DENIED BY AGENT --->
		<cfset newstatus = 7>
	<cfelseif get_status.status GTE 7> <!--- SUBMITTED TO SMG = 7 / RECEIVED = 8 / DENIED = 9 / ON HOLD = 10 --->
		<cfset newstatus = 11>
	</cfif>
	
	<!--- INSERT PROGRAM HISTORY TO KEEP TRACK OF WHAT PROGRAM THE STUDENT WAS ASSIGNED. --->
	<cfif get_student.programid NEQ 0>
		<cfquery name="program_history" datasource="MySql">
			INSERT INTO smg_programhistory
				(studentid, programid, reason, changedby,  date)
			VALUES
				('#client.studentid#', '#get_student.programid#', 'ONLINE APP RE-APPROVED - #get_student.cancelreason#', '#client.userid#', #CreateODBCDateTime(now())# )
		</cfquery>
	</cfif>
	
	<!---- APPLICATION STATUS HISTORY ---->
	<cfquery name="approve_application" datasource="MySQL">
		INSERT INTO smg_student_app_status (studentid, status, approvedby)
		VALUES (#client.studentid#, #newstatus#, '#client.userid#')
	</cfquery>
	
	<cfquery name="application" datasource="MySQL">
		UPDATE smg_students 
		SET active = '1',
			canceldate = NULL,
			cancelreason = '', 
			app_current_status = '#newstatus#',
			programid = '0',
			companyid = '0',
  	        dateapplication = #CreateODBCDate(now())#
		WHERE studentid = <cfqueryparam value="#client.studentid#" cfsqltype="cf_sql_integer"> 
	</cfquery>

	<!--- APPLICATION APPROVED --->
	<cfif newstatus EQ 11>
		<!----set company variables---->
		<cfquery name="set_company_region" datasource="MySQL">
			UPDATE smg_students 
			SET dateapplication = #CreateODBCDate(now())#,
				companyid = '#form.companyid#',
				entered_by = '#client.userid#'
			WHERE studentid = <cfqueryparam value="#client.studentid#" cfsqltype="cf_sql_integer">
		</cfquery>
		
		<!--- PHP STUDENTS --->
		<cfif form.companyid EQ '6'>
			<cfquery name="add_student" datasource="MySql">
				INSERT INTO php_students_in_program 
					(studentid, companyid, inputby, active, datecreated) 
				VALUES ('#client.studentid#', '#form.companyid#', '#client.userid#', '1', #CreateODBCDate(now())#)		
			</cfquery>
		</cfif>
		
		<cfquery name="get_email" datasource="mysql">
			SELECT s.email, s.firstname, s.familylastname, s.password,
				u.email as intrepemail, u.congrats_email
			FROM smg_students s
			INNER JOIN smg_users u ON u.userid = s.intrep
			WHERE studentid = <cfqueryparam value="#client.studentid#" cfsqltype="cf_sql_integer">
		</cfquery>
		
		<cfif get_email.email NEQ '' OR get_email.intrepemail NEQ ''>
			<cfif get_email.email EQ ''><cfset get_email.email = '#get_email.intrepemail#'></cfif>
			<cfif get_email.intrepemail EQ ''><cfset get_email.intrepemail = '#get_email.email#'></cfif>
		
			<cfoutput query="get_email">
				<!--- STUDENT APPROVED --->
				<cfif congrats_email EQ 0>
					<cfset cc_email = ''>
				<cfelse>
					<cfset cc_email = '#get_email.email#'>
				</cfif>
					<cfmail to='#get_email.intrepemail#' cc="#cc_email#" from='support@student-management.com' subject='Exchange Application Information' type="html">
					<style type="text/css">
					.thin-border{ border: 1px solid ##000000;}
					</style>
					<table width=550 class="thin-border" cellspacing="0" cellpadding=0>
						<tr><td bgcolor="b5d66e"><img src="http://www.student-management.com/nsmg/student_app/pics/top-email.gif" width=550 heignt=75></td></tr>
						<tr>
							<td>
								<h2>Congratulations!</h2>
								#firstname# #familylastname#-
								<br><br>
								This email is to inform you that your application has been accepted and approved by Student Management Group in New York. <br><br>
								<em>What does this mean to you and what are the next steps?</em><br>
								Your are now listed as available for placement in the United States and the region or state you chose if applicable.  Students are placed on a 
								daily basis all over the county.  All you have to do is wait to hear from us.  You will receive an email and acceptance letter once you have been placed with a host family. 
								You will also be able to see your host family profile when you log into www.student-management.com after you have been placed.
								<br><br>
							</td>
						</tr>
						<tr>
							<Td align="center">
							<font color="##CCCCCC" size=-1>Please add support@student-management.com to your whitelist to ensure it isn't marked as spam. SMG will
							not sell your address or use it for unsolicited emails.  This email was sent on behalf of Student Management Group from an International Agent, listed above.  
							If you received this email as an unsolicited contact about SMG or SMG subsidiaries, please contact support@student-management.com  </font>
							</Td>
						</tr>				
					</table>
					</cfmail>
			</cfoutput>
		</cfif>
	</cfif>

	<meta http-equiv="refresh" content="3;url=close_window.cfm">
	<body onLoad="opener.location.reload()"> 
	<table align="center">
		<tr><td><img src="../pics/top-email.gif"></td></tr>
		<tr><td>This application has been approved. This window should close automatically.</td></tr>
	</table>
</cftransaction>

<cfcatch type="">
	<cfinclude template="../email_message.cfm">
</cfcatch>
</cftry>  