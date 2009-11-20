<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<title>Student Information - Page 5</title>
</head>
<body>

<cftry>

<cfif NOT IsDefined('form.studentid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

	<cfquery name="update_student" datasource="mysql">
		UPDATE smg_students
		SET religious_participation = '#form.religious_participation#',
			religiousaffiliation = '#religiousaffiliation#',
			<cfif IsDefined('form.churchfam')>churchfam = '#form.churchfam#',</cfif>
			churchgroup = '#churchgroup#'
		WHERE studentid = <cfqueryparam value="#form.studentid#" cfsqltype="cf_sql_integer">
		LIMIT 1
	</cfquery>
	
	<cfquery name="get_uniqueid" datasource="mysql">
		SELECT uniqueid
		FROM smg_students
		WHERE studentid = <cfqueryparam value="#form.studentid#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<cfoutput>
	
	<cflocation url="?curdoc=student/student_form6&unqid=#get_uniqueid.uniqueid#" addtoken="no">
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
		
<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>

</body>
</html>