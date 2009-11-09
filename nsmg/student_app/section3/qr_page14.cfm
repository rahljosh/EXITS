<cfif not IsDefined('form.studentid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<cftransaction action="begin" isolation="serializable">
	<cftry>

		<cfquery name="update_student" datasource="MySql">
			UPDATE smg_students
			SET	app_med_restrictions = <cfqueryparam value="#form.app_med_restrictions#" cfsqltype="cf_sql_char">,
				other_allergies = <cfqueryparam value="#form.other_allergies#" cfsqltype="cf_sql_char">,
				app_med_take_medication = <cfqueryparam value="#form.app_med_take_medication#" cfsqltype="cf_sql_char">,
				app_med_special_medication = <cfqueryparam value="#form.app_med_special_medication#" cfsqltype="cf_sql_char">,
				app_med_tetanus_shot = <cfif form.app_med_tetanus_shot is ''>NULL<cfelse>#CreateODBCDate(form.app_med_tetanus_shot)#</cfif>
			WHERE studentid = '#form.studentid#'
			LIMIT 1
		</cfquery>

		<html>
		<head>
		<script language="JavaScript">
		<!-- 
		alert("You have successfully updated this page. Thank You.");
		<cfif NOT IsDefined('url.next')>
			location.replace("?curdoc=section3/page14&id=3&p=14");
		<cfelse>
			location.replace("?curdoc=section4&id=4");
		</cfif>
		-->
		</script>
		</head>
		</html>

	<cfcatch type="any">
		<cfinclude template="../email_error.cfm">
	</cfcatch>
	</cftry>
</cftransaction>