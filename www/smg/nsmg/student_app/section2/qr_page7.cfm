<cfif not IsDefined('form.studentid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<cftransaction action="begin" isolation="serializable">
<cftry>
	<cfquery name="update_student" datasource="MySql">
		UPDATE smg_students
		SET	app_school_name = <cfqueryparam value="#form.app_school_name#" cfsqltype="cf_sql_varchar">,
			app_school_add = <cfqueryparam value="#form.app_school_add#" cfsqltype="cf_sql_varchar">,
			app_school_phone = '#form.app_school_phone#',
			<cfif IsDefined('form.app_school_type')>app_school_type = '#form.app_school_type#',</cfif> 
			app_school_person = '#form.app_school_person#',
			app_grade_1 = <cfqueryparam value="#form.app_grade_1#" cfsqltype="cf_sql_varchar" maxlength="30">,
			app_grade_1_com = <cfqueryparam value="#form.app_grade_1_com#" cfsqltype="cf_sql_varchar" maxlength="100">,
			app_grade_2 = <cfqueryparam value="#form.app_grade_2#" cfsqltype="cf_sql_varchar" maxlength="30">,
			app_grade_2_com = <cfqueryparam value="#form.app_grade_2_com#" cfsqltype="cf_sql_varchar" maxlength="100">,
			app_grade_3 = <cfqueryparam value="#form.app_grade_3#" cfsqltype="cf_sql_varchar" maxlength="30">,
			app_grade_3_com = <cfqueryparam value="#form.app_grade_3_com#" cfsqltype="cf_sql_varchar" maxlength="100">,
			app_grade_4 = <cfqueryparam value="#form.app_grade_4#" cfsqltype="cf_sql_varchar" maxlength="30">,
			app_grade_4_com = <cfqueryparam value="#form.app_grade_4_com#" cfsqltype="cf_sql_varchar" maxlength="100">,
			app_grade_5 = <cfqueryparam value="#form.app_grade_5#" cfsqltype="cf_sql_varchar" maxlength="30">,
			app_grade_5_com = <cfqueryparam value="#form.app_grade_5_com#" cfsqltype="cf_sql_varchar" maxlength="100">,		
			app_grade_6 = <cfqueryparam value="#form.app_grade_6#" cfsqltype="cf_sql_varchar" maxlength="30">,
			app_grade_6_com = <cfqueryparam value="#form.app_grade_6_com#" cfsqltype="cf_sql_varchar" maxlength="100">,
			app_grade_7 = <cfqueryparam value="#form.app_grade_7#" cfsqltype="cf_sql_varchar" maxlength="30">,
			app_grade_7_com = <cfqueryparam value="#form.app_grade_7_com#" cfsqltype="cf_sql_varchar" maxlength="100">,
			app_grade_8 = <cfqueryparam value="#form.app_grade_8#" cfsqltype="cf_sql_varchar" maxlength="30">,
			app_grade_8_com = <cfqueryparam value="#form.app_grade_8_com#" cfsqltype="cf_sql_varchar" maxlength="100">,
			<cfif IsDefined('form.grades')>grades = '#form.grades#',</cfif>
			<cfif IsDefined('form.app_completed_school')>app_completed_school = '#form.app_completed_school#',</cfif>			
			<cfif IsDefined('form.convalidation_needed')>convalidation_needed = '#form.convalidation_needed#',</cfif>
			app_extra_courses = <cfqueryparam value="#form.app_extra_courses#" cfsqltype="cf_sql_varchar">
		WHERE studentid = '#form.studentid#'
		LIMIT 1
	</cfquery>

	<html>
	<head>
	<script language="JavaScript">
	<!-- 
	alert("You have successfully updated this page. Thank You.");
	<cfif NOT IsDefined('url.next')>
		location.replace("?curdoc=section2/page7&id=2&p=7");
	<cfelse>
		location.replace("?curdoc=section2/page8&id=2&p=8");
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