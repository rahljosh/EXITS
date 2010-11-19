<cfif not IsDefined('form.studentid') AND not IsDefined('form.latest_status')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<cftransaction action="begin" isolation="serializable">
	<cftry>

	<!--- From Student to Intl. Rep. --->
	<cfif form.latest_status LTE '2'>
 		<cfquery name="add_new_status" datasource="MySQL">
			INSERT INTO smg_student_app_status
				(studentid, status, date)
			VALUES ('#form.studentid#', '3', #CreateODBCDateTime(now())# )
		</cfquery> 
		<html>
		<head>
		<script language="JavaScript">
		<!-- 
		alert("You have successfully submitted this application to your Intl. Representative.");
		location.replace("?curdoc=initial_welcome");
		-->
		</script>
		</head>
		</html> 		
	</cfif>

	<!--- From Intl. Rep. to SMG --->
	<cfif form.latest_status EQ '3'>
 		<cfquery name="add_new_status" datasource="MySQL">
			INSERT INTO smg_student_app_status
				(studentid, status, date)
			VALUES ('#form.studentid#', '5', #CreateODBCDateTime(now())# )
		</cfquery> 
		<html>
		<head>
		<script language="JavaScript">
		<!-- 
		alert("You have successfully submitted this application to your Intl. Representative.");
		location.replace("?curdoc=initial_welcome");
		-->
		</script>
		</head>
		</html> 		
	</cfif>		

	<cfcatch type="any">
		<cfinclude template="email_error.cfm">
	</cfcatch>
	</cftry>

</cftransaction>