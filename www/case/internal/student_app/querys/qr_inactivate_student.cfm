<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Inactivate Student</title>
</head>

<body>

<cftry>

	<cfoutput>

	<cfif NOT IsDefined('form.studentid') OR NOT IsDefined('form.status')>
		<cfinclude template="../error_message.cfm">
		<cfabort>
	</cfif>

	<cfif form.status LTE 5 OR form.status EQ 6 OR form.status EQ 9>
		<cftransaction>
			<cfquery name="inactivate" datasource="caseusa">
				UPDATE smg_students
				SET active = '0',
					canceldate = #CreateODBCDate(now())#,
					cancelreason = 'EXITS Online canceled by Intl. Agent'
				WHERE studentid = '#form.studentid#'
				LIMIT 1
			</cfquery>
		</cftransaction>

		<html>
		<head>
		<script language="JavaScript">
		<!-- 
		alert("You have successfully inactivate this student. If you wish to activate this student in the feature please contact SMG support@student-management.com");
			location.replace("?curdoc=student_app/student_app_list&status=#form.status#");
		-->
		</script>
		</head>
		</html> 	

	<cfelse>
	
		<html>
		<head>
		<script language="JavaScript">
		<!-- 
		alert("This student could not be inactivated because this application have been submitted to SMG.");
			location.replace("?curdoc=student_app/student_app_list&status=#form.status#");
		-->
		</script>
		</head>
		</html> 	
		
	</cfif>

	</cfoutput>
	
<cfcatch type="any">
	<cfinclude template="../email_error.cfm">
</cfcatch>
</cftry>	

</body>
</html>
