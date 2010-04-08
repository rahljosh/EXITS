<cfif not IsDefined('url.childid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<cftransaction action="begin" isolation="serializable">
	<cftry>
	
		<cfquery name="delete_sibling" datasource="caseusa">
			DELETE 
			FROM smg_student_siblings
			WHERE childid = <cfqueryparam value="#url.childid#" cfsqltype="cf_sql_integer">
			AND studentid = <cfqueryparam value="#url.studentid#" cfsqltype="cf_sql_integer">
			LIMIT 1
		</cfquery>
		
		<html>
		<head>
		<script language="JavaScript">
		<!-- 
		alert("You have successfully updated this page. Thank You.");
		location.replace("?curdoc=section1/page2&id=1&p=2");
		-->
		</script>
		</head>
		</html>

	<cfcatch type="any">
		<cfinclude template="../email_error.cfm">
	</cfcatch>
	</cftry>

</cftransaction>

<!--- <cflocation url="?curdoc=section1/page1&id=1&p=1" addtoken="no"> --->