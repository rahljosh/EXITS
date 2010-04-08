<cfif not IsDefined('form.studentid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<cftransaction action="begin" isolation="serializable">
<cftry>
	<cfquery name="update_student" datasource="caseusa">
		UPDATE smg_students
		SET	<cfif IsDefined('form.app_reading_skills')>app_reading_skills = '#form.app_reading_skills#',<cfelse>app_reading_skills = null,</cfif> 
			<cfif IsDefined('form.app_writing_skills')>app_writing_skills = '#form.app_writing_skills#',<cfelse>app_writing_skills = null,</cfif> 
			<cfif IsDefined('form.app_verbal_skills')>app_verbal_skills = '#form.app_verbal_skills#'<cfelse>app_verbal_skills = null</cfif> 
		WHERE studentid = '#form.studentid#'
		LIMIT 1
	</cfquery>

	<html>
	<head>
	<script language="JavaScript">
	<!-- 
	alert("You have successfully updated this page. Thank You.");
	<cfif NOT IsDefined('url.next')>
		location.replace("?curdoc=section2/page9&id=2&p=9");
	<cfelse>
		location.replace("?curdoc=section2/page10&id=2&p=10");
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

