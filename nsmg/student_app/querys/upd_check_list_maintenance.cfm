<cfif not IsDefined('form.count') AND not IsDefined('url.page')>
	Include error message.
	<cfabort>
</cfif>

<cftransaction action="begin" isolation="serializable">
 	<cftry> 

		<cfloop From = "1" To = "#form.count#" Index = "x">
			<cfquery name="update_checklist" datasource="MySQL">
				UPDATE smg_student_app_field
				SET	field_label = <cfqueryparam value="#form["field_label" & x]#" cfsqltype="cf_sql_char">,
					section = <cfqueryparam value="#form["section" & x]#" cfsqltype="cf_sql_char">,
					page = <cfqueryparam value="#form["page" & x]#" cfsqltype="cf_sql_char">,
					field_order = <cfqueryparam value="#form["field_order" & x]#" cfsqltype="cf_sql_integer">,
					field_name = <cfqueryparam value="#form["field_name" & x]#" cfsqltype="cf_sql_char">,
					table_located = <cfqueryparam value="#form["table_located" & x]#" cfsqltype="cf_sql_char">,
					required = <cfqueryparam value="#form["required" & x]#" cfsqltype="cf_sql_integer">
				WHERE fieldid = <cfqueryparam value="#form["fieldid" & x]#" cfsqltype="cf_sql_integer">
				LIMIT 1
			</cfquery>
		</cfloop>

		<html>
		<head>
		<cfoutput>
			<script language="JavaScript">
			<!-- 
			alert("You have successfully updated this page. Thank You.");
			location.replace("?curdoc=check_list_maintenance&page=#url.page#");
			-->
			</script>
		</cfoutput>
		</head>
		</html> 		
		
	<cfcatch type="any">
		<cfinclude template="../email_error.cfm">
	</cfcatch>
	</cftry>

</cftransaction>