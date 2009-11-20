<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<title>Student Information - Page 2</title>
</head>
<body>

<cftry>

<cfif NOT IsDefined('form.studentid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

	<cfquery name="update_student" datasource="mysql">
		UPDATE smg_students
		SET fathersname = <cfqueryparam value="#form.fathersname#" cfsqltype="cf_sql_char">,
			fatheraddress = <cfqueryparam value="#form.fatheraddress#" cfsqltype="cf_sql_char">,
			fatheraddress2 = <cfqueryparam value="#form.fatheraddress2#" cfsqltype="cf_sql_char">,
			fathercity = '#form.fathercity#',
			fathercountry = '#form.fathercountry#',
			fatherzip = '#form.fatherzip#',
			fatherenglish = <cfif IsDefined('form.fatherenglish')>'#form.fatherenglish#'<cfelse>''</cfif>,
			fatherbirth = <cfif form.fatherbirth NEQ ''>'#form.fatherbirth#'<cfelse>0</cfif>,
			fatherworkposition = '#form.fatherworkposition#',
			fathercompany = '#form.fathercompany#',
			fatherworkphone = '#form.fatherworkphone#',
			mothersname = <cfqueryparam value="#form.mothersname#" cfsqltype="cf_sql_char">,
			motheraddress = <cfqueryparam value="#form.motheraddress#" cfsqltype="cf_sql_char">,
			motheraddress2 = <cfqueryparam value="#form.motheraddress2#" cfsqltype="cf_sql_char">,
			mothercity = '#form.mothercity#',
			mothercountry = '#form.mothercountry#',
			motherzip = '#form.motherzip#',
			emergency_name = '#form.emergency_name#',
			emergency_phone = '#form.emergency_phone#',
			motherenglish = <cfif IsDefined('form.motherenglish')>'#form.motherenglish#'<cfelse>''</cfif>,
			motherbirth = <cfif form.motherbirth NEQ ''>'#form.motherbirth#'<cfelse>0</cfif>,
			motherworkposition = '#form.motherworkposition#',
			mothercompany = '#form.mothercompany#',
			motherworkphone = '#form.motherworkphone#'
		WHERE studentid = <cfqueryparam value="#form.studentid#" cfsqltype="cf_sql_integer">
		LIMIT 1
	</cfquery>

<cfquery name="get_uniqueid" datasource="mysql">
	SELECT uniqueid
	FROM smg_students
	WHERE studentid = <cfqueryparam value="#form.studentid#" cfsqltype="cf_sql_integer">
</cfquery>

<cflocation url="?curdoc=student/student_form3&unqid=#get_uniqueid.uniqueid#" addtoken="no">

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>

</body>
</html>