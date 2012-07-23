<meta http-equiv="refresh" content="3;url=close_window.cfm">
<body onLoad="opener.location.reload()"> 
<cfquery name="approve_appliation" datasource="MySQL">
	INSERT INTO
    	smg_student_app_status
        (
        	studentID,
            status,
            reason,
            date
        )
  	VALUES
    	(
        	<cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.studentID#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="5">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="Application Approved by International Rep">,
            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">
        )
</cfquery>
	
	<table align="center">
		<tr>
			<td><img src="../pics/top-email.gif"></td>
		</tr>
		<tr>
			<td>This application has been approved.  This window should close automatically.</td>
		</tr>
	</table>