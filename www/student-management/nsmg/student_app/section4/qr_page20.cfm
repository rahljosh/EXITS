<cfif not IsDefined('form.studentid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<cftransaction action="begin" isolation="serializable">
<cftry>
	
	<cfif IsDefined('form.region_select')>
		<cfquery name="update_student" datasource="MySql">
			UPDATE smg_students
			SET	<cfif form.region_select EQ 'NO'>
					app_region_guarantee = 0
				<cfelse>
					<cfif IsDefined('form.region_choice')>app_region_guarantee = '#form.region_choice#'<cfelse>app_region_guarantee = 0</cfif> 
				</cfif>
			WHERE studentid = '#form.studentid#'
			LIMIT 1
		</cfquery>
	</cfif>
	
	<html>
	<head>
	<script language="JavaScript">
	<!-- 
	alert("You have successfully updated this page. Thank You.");
	<cfif NOT IsDefined('url.next')>
		location.replace("?curdoc=section4/page20&id=4&p=20");
	<cfelse>
		location.replace("?curdoc=section4/page21&id=4&p=21");
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