<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Student Information</title>
</head>

<body>

<!--- <cftry> --->

<cfquery name="get_candidate_unqid" datasource="mysql">
	SELECT *
	FROM extra_candidates
	WHERE uniqueid = <cfqueryparam value="#URL.uniqueid#" cfsqltype="cf_sql_char">
</cfquery>

<!---
<cfquery name="get_student_unqid" datasource="mysql">
	SELECT *
	FROM smg_students
	WHERE uniqueid = <cfqueryparam value="#URL.unqid#" cfsqltype="cf_sql_char">
</cfquery>
--->

<!---<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch> 

</cftry> --->
</body>
</html>
