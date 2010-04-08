<cfif not IsDefined('form.studentid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<cftransaction action="begin" isolation="serializable">
<cftry>
	<cfquery name="update_student" datasource="caseusa">
		UPDATE smg_students
		SET	<cfif IsDefined('form.app_social_skills1')>app_social_skills1 = '#form.app_social_skills1#',<cfelse>app_social_skills1 = null,</cfif> 
			<cfif IsDefined('form.app_social_skills2')>app_social_skills2 = '#form.app_social_skills2#',<cfelse>app_social_skills2 = null,</cfif>
			<cfif IsDefined('form.app_social_skills3')>app_social_skills3 = '#form.app_social_skills3#',<cfelse>app_social_skills3 = null,</cfif>
			<cfif IsDefined('form.app_social_skills4')>app_social_skills4 = '#form.app_social_skills4#',<cfelse>app_social_skills4 = null,</cfif>
			<cfif IsDefined('form.app_social_skills5')>app_social_skills5 = '#form.app_social_skills5#',<cfelse>app_social_skills5 = null,</cfif>
			<cfif IsDefined('form.app_social_skills6')>app_social_skills6 = '#form.app_social_skills6#',<cfelse>app_social_skills6 = null,</cfif>
			app_social_reason = <cfqueryparam value="#form.app_social_reason#" cfsqltype="cf_sql_char">,
			app_teacher_name = '#form.app_teacher_name#',
			app_teacher_school = '#form.app_teacher_school#',
			app_teacher_address = '#form.app_teacher_address#',
			app_teacher_phone = '#form.app_teacher_phone#',
			<cfif app_interview_date is ''>app_interview_date = null,<cfelse>app_interview_date = #CreateODBCDate(form.app_interview_date)#,</cfif>
			<cfif app_evaluation_date is ''>app_evaluation_date = null<cfelse>app_evaluation_date = #CreateODBCDate(form.app_evaluation_date)#</cfif>			
		WHERE studentid = '#form.studentid#'
		LIMIT 1
	</cfquery>
	
	<html>
	<head>
	<script language="JavaScript">
	<!-- 
	alert("You have successfully updated this page. Thank You.");
	<cfif NOT IsDefined('url.next')>
		location.replace("?curdoc=section2/page10&id=2&p=10");
	<cfelse>
		location.replace("?curdoc=section3&id=3");
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