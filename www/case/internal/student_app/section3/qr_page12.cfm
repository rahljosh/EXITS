<cfif not IsDefined('form.studentid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<cftransaction action="begin" isolation="serializable">
	<cftry>

	<!--- UPDATE --->
	<cfif IsDefined('form.healthid')>
		<cfquery name="update_questions" datasource="caseusa">
		UPDATE smg_student_app_health
		SET clinical_head = <cfif IsDefined('form.clinical_head')>'#form.clinical_head#'<cfelse>NULL</cfif>,
			clinical_nose = <cfif IsDefined('form.clinical_nose')>'#form.clinical_nose#'<cfelse>NULL</cfif>,
			clinical_sinuses = <cfif IsDefined('form.clinical_sinuses')>'#form.clinical_sinuses#'<cfelse>NULL</cfif>,
			clinical_mouth = <cfif IsDefined('form.clinical_mouth')>'#form.clinical_mouth#'<cfelse>NULL</cfif>,
			clinical_ears = <cfif IsDefined('form.clinical_ears')>'#form.clinical_ears#'<cfelse>NULL</cfif>,
			clinical_drums = <cfif IsDefined('form.clinical_drums')>'#form.clinical_drums#'<cfelse>NULL</cfif>,
			clinical_eyes = <cfif IsDefined('form.clinical_eyes')>'#form.clinical_eyes#'<cfelse>NULL</cfif>,
			clinical_ophthal = <cfif IsDefined('form.clinical_ophthal')>'#form.clinical_ophthal#'<cfelse>NULL</cfif>,
			clinical_pupils = <cfif IsDefined('form.clinical_pupils')>'#form.clinical_pupils#'<cfelse>NULL</cfif>,
			clinical_ocular = <cfif IsDefined('form.clinical_ocular')>'#form.clinical_ocular#'<cfelse>NULL</cfif>,
			clinical_lungs = <cfif IsDefined('form.clinical_lungs')>'#form.clinical_lungs#'<cfelse>NULL</cfif>,
			clinical_heart = <cfif IsDefined('form.clinical_heart')>'#form.clinical_heart#'<cfelse>NULL</cfif>,
			clinical_vascular = <cfif IsDefined('form.clinical_vascular')>'#form.clinical_vascular#'<cfelse>NULL</cfif>,
			clinical_abdomen = <cfif IsDefined('form.clinical_abdomen')>'#form.clinical_abdomen#'<cfelse>NULL</cfif>,
			clinical_anus = <cfif IsDefined('form.clinical_anus')>'#form.clinical_anus#'<cfelse>NULL</cfif>,
			clinical_endocrine = <cfif IsDefined('form.clinical_endocrine')>'#form.clinical_endocrine#'<cfelse>NULL</cfif>,
			clinical_gusystem = <cfif IsDefined('form.clinical_gusystem')>'#form.clinical_gusystem#'<cfelse>NULL</cfif>,
			clinical_upper = <cfif IsDefined('form.clinical_upper')>'#form.clinical_upper#'<cfelse>NULL</cfif>,
			clinical_feet = <cfif IsDefined('form.clinical_feet')>'#form.clinical_feet#'<cfelse>NULL</cfif>,
			clinical_lower = <cfif IsDefined('form.clinical_lower')>'#form.clinical_lower#'<cfelse>NULL</cfif>,
			clinical_spine = <cfif IsDefined('form.clinical_spine')>'#form.clinical_spine#'<cfelse>NULL</cfif>,
			clinical_body = <cfif IsDefined('form.clinical_body')>'#form.clinical_body#'<cfelse>NULL</cfif>,
			clinical_skin = <cfif IsDefined('form.clinical_skin')>'#form.clinical_skin#'<cfelse>NULL</cfif>,
			clinical_neurology = <cfif IsDefined('form.clinical_neurology')>'#form.clinical_neurology#'<cfelse>NULL</cfif>,
			clinical_psychiatric = <cfif IsDefined('form.clinical_psychiatric')>'#form.clinical_psychiatric#'<cfelse>NULL</cfif>,
			clinical_pelvic = <cfif IsDefined('form.clinical_pelvic')>'#form.clinical_pelvic#'<cfelse>NULL</cfif>,
			clinical_pelvic_type = <cfif IsDefined('form.clinical_pelvic_type')>'#form.clinical_pelvic_type#'<cfelse>NULL</cfif>,
			<cfif form.clinical_build EQ '0'>
				clinical_build = NULL,
			<cfelse>
				clinical_build = <cfqueryparam value="#form.clinical_build#" cfsqltype="cf_sql_char">,
			</cfif>
			clinical_blood_sitting = <cfqueryparam value="#form.clinical_blood_sitting#" cfsqltype="cf_sql_char">,
			clinical_blood_recumbent = <cfqueryparam value="#form.clinical_blood_recumbent#" cfsqltype="cf_sql_char">,
			clinical_blood_standing = <cfqueryparam value="#form.clinical_blood_standing#" cfsqltype="cf_sql_char">,
			clinical_pulse_sitting = <cfqueryparam value="#form.clinical_pulse_sitting#" cfsqltype="cf_sql_char">,
			clinical_pulse_exercise = <cfqueryparam value="#form.clinical_pulse_exercise#" cfsqltype="cf_sql_char">,
			clinical_pulse_2min = <cfqueryparam value="#form.clinical_pulse_2min#" cfsqltype="cf_sql_char">,
			clinical_pulse_recumbent = <cfqueryparam value="#form.clinical_pulse_recumbent#" cfsqltype="cf_sql_char">,
			clinical_pulse_3min = <cfqueryparam value="#form.clinical_pulse_3min#" cfsqltype="cf_sql_char">,
			clinical_lab_albumin = <cfqueryparam value="#form.clinical_lab_albumin#" cfsqltype="cf_sql_char">,
			clinical_lab_sugar = <cfqueryparam value="#form.clinical_lab_sugar#" cfsqltype="cf_sql_char">,
			clinical_lab_serology = <cfqueryparam value="#form.clinical_lab_serology#" cfsqltype="cf_sql_char">,
			clinical_lab_blood = <cfqueryparam value="#form.clinical_lab_blood#" cfsqltype="cf_sql_char">,
			clinical_lab_bcg= <cfif clinical_lab_bcg is not ''>#CreateODBCDate(form.clinical_lab_bcg)#<cfelse>NULL</cfif>,
			clinical_lab_skin_test = <cfif clinical_lab_skin_test is not ''>#CreateODBCDate(form.clinical_lab_skin_test)#<cfelse>NULL</cfif>,
			clinical_lab_skin_result =  <cfif IsDefined('form.clinical_lab_skin_result')>'#form.clinical_lab_skin_result#'<cfelse>NULL</cfif>,
			clinical_lab_xray = <cfif clinical_lab_xray is not ''>#CreateODBCDate(form.clinical_lab_xray)#<cfelse>NULL</cfif>,
			clinical_lab_xray_result = <cfif IsDefined('form.clinical_lab_xray_result')>'#form.clinical_lab_xray_result#'<cfelse>NULL</cfif>
		WHERE healthid = <cfqueryparam value="#form.healthid#" cfsqltype="cf_sql_integer">
		LIMIT 1 
		</cfquery>
	</cfif>
	
	<cfquery name="Update_Student" datasource="caseusa">
	UPDATE smg_students
	SET	height = '#form.height#',
		weight = '#form.weight#',
		haircolor = '#form.haircolor#',
		eyecolor = '#form.eyecolor#'
	WHERE studentid = <cfqueryparam value="#form.studentid#" cfsqltype="cf_sql_integer">
	LIMIT 1	
	</cfquery>
	
	<html>
	<head>
	<script language="JavaScript">
	<!-- 
	alert("You have successfully updated this page. Thank You.");
	<cfif NOT IsDefined('url.next')>
		location.replace("?curdoc=section3/page12&id=3&p=12");
	<cfelse>
		location.replace("?curdoc=section3/page13&id=3&p=13");
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