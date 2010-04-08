<cfif not IsDefined('form.studentid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<cftransaction action="begin" isolation="serializable">
<cftry>
	<cfquery name="update_student" datasource="caseusa">
		UPDATE smg_students
		SET	<cfif IsDefined('form.app_interview_english_level')>app_interview_english_level = '#form.app_interview_english_level#',<cfelse>app_interview_english_level = null,</cfif> 
			app_interview_strengths = <cfqueryparam value="#form.app_interview_strengths#" cfsqltype="cf_sql_char">,
			app_interview_other = <cfqueryparam value="#form.app_interview_other#" cfsqltype="cf_sql_char">
		WHERE studentid = '#form.studentid#'
		LIMIT 1
	</cfquery>
	
	<html>
	<head>
	<script language="JavaScript">
	<!-- 
	alert("You have successfully updated this page. Thank You.");
	<cfif NOT IsDefined('url.next')>
		location.replace("?curdoc=section4/page19&id=4&p=19");
	<cfelse>
		location.replace("?curdoc=section4/page20&id=4&p=20");
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