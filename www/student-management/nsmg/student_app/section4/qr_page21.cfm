<cfif not IsDefined('form.studentid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<cfquery name="check_state" datasource="MySql">
	SELECT statechoiceid, studentid, state1, state2, state3
	FROM smg_student_app_state_requested
	WHERE studentid = '#form.studentid#'
</cfquery>

<cftransaction action="begin" isolation="serializable">
<cftry>

	<cfif IsDefined('form.state_select')>
		<cfif check_state.recordcount EQ '0'>
			<!--- INSERT CHOICES ---->
			<cfquery name="insert_state" datasource="MySql">
				INSERT INTO smg_student_app_state_requested
					(studentid, state1, state2, state3)
				VALUES ('#form.studentid#', '#form.state1#', '#form.state2#', '#form.state3#')
			</cfquery>
		<cfelse>
			<!--- UPDATE CHOICES --->
			<cfquery name="update_state" datasource="MySql">
				UPDATE smg_student_app_state_requested
				SET	<cfif form.state_select EQ 'NO'>
						state1 = '0',
						state2 = '0',
						state3 = '0'
					<cfelse>
						state1 = '#form.state1#',
						state2 = '#form.state2#',
						state3 = '#form.state3#'
					</cfif>
				WHERE statechoiceid = '#check_state.statechoiceid#'
				LIMIT 1
			</cfquery>
		</cfif>
	<!--- <cfif IsDefined('form.region_choice')>app_region_guarantee = '#form.region_choice#'<cfelse>app_region_guarantee = 0</cfif> --->	
	</cfif>
	<html>
	<head>
	<script language="JavaScript">
	<!-- 
	alert("You have successfully updated this page. Thank You.");
	<cfif NOT IsDefined('url.next')>
		location.replace("?curdoc=section4/page21&id=4&p=21");
	<cfelse>
		location.replace("?curdoc=section4/page22&id=4&p=22");
	</cfif>
	//-->
	</script>
	</head>
	</html>	

	<cfcatch type="any">
		<cfinclude template="../email_error.cfm">
	</cfcatch>
</cftry>
	
</cftransaction>