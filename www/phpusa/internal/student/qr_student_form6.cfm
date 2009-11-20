<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<title>Student Information - Page 6</title>
</head>
<body>
<!----
<cftry>
---->
<cfif NOT IsDefined('form.studentid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>


	<cfquery name="update_student" datasource="mysql">
		UPDATE smg_students
		SET <cfif IsDefined('form.smoke')>smoke = '#form.smoke#',</cfif>
			<cfif IsDefined('form.animal_allergies')>animal_allergies = '#form.animal_allergies#',</cfif>
			<cfif IsDefined('form.med_allergies')>med_allergies = '#form.med_allergies#',</cfif>
			other_allergies = '#form.other_allergies#',
			<cfif IsDefined('form.chores')>chores = '#form.chores#',</cfif>
			chores_list = '#form.chores_list#',
			weekday_curfew = <cfif form.weekday_curfew EQ ''>NULL<cfelse>#CreateODBCTime(weekday_curfew)#</cfif>,
			weekend_curfew = <cfif form.weekend_curfew EQ ''>NULL<cfelse>#CreateODBCTime(weekend_curfew)#</cfif>
		WHERE studentid = <cfqueryparam value="#form.studentid#" cfsqltype="cf_sql_integer">
		LIMIT 1
	</cfquery>
	
	<cfquery name="get_uniqueid" datasource="mysql">
		SELECT uniqueid
		FROM smg_students
		WHERE studentid = <cfqueryparam value="#form.studentid#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<cfoutput>
	
	<cflocation url="?curdoc=student/student_form7&unqid=#get_uniqueid.uniqueid#" addtoken="no">
	<!---
	<html>
	<head>
	<script language="JavaScript">
	<!-- 
	alert("You have successfully updated this student information. Thank You.");
		location.replace("?curdoc=student/student_form2&unqid=#get_uniqueid.uniqueid#");
	-->
	</script>
	</head>
	</html>
	---> 		
	</cfoutput>
<!----		
<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>
---->
</body>
</html>