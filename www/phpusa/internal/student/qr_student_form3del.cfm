<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Student Information - Page 3</title>
</head>

<body>

<cftry>

<cfif NOT IsDefined('url.childid') OR NOT IsDefined('url.unqid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<!--- Get Student Info by UniqueID --->
<cfinclude template="../querys/get_student_unqid.cfm">

	<cfquery name="delete_sibling" datasource="mysql">
		DELETE 
		FROM smg_student_siblings
		WHERE childid = <cfqueryparam value="#url.childid#" cfsqltype="cf_sql_integer">
			AND studentid = <cfqueryparam value="#get_student_unqid.studentid#" cfsqltype="cf_sql_integer">
		LIMIT 1
	</cfquery>
		
<cflocation url="?curdoc=student/student_form3&unqid=#get_student_unqid.uniqueid#" addtoken="no">

<cfcatch type="any">
	<cfinclude template="../email_error.cfm">
</cfcatch>
</cftry>

</body>
</html>