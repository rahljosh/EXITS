<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<title>Student Information - Page 1</title>
</head>
<body>

<cftry>

<cfif NOT IsDefined('form.studentid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<cfoutput>
<cfif form.email NEQ ''>
	<cfquery name="check_username" datasource="MySql">
		SELECT email
		FROM smg_students
		WHERE email = '#form.email#' AND studentid != '#form.studentid#'
	</cfquery>
	<cfif check_username.recordcount NEQ '0'><br>
		<table border=0 cellpadding=4 cellspacing=0 class="section" align="center" width=90%>
			<tr><th background="images/back_menu2.gif">AXIS - Error Message</th></tr>
			<tr><td>Sorry, the e-mail address <b>#form.email#</b> is being in use by another account.</td></tr>
			<tr><td>Please click on the "back" button below and enter a new e-mail address.</td></tr>
			<tr><td align="center"><input name="back" type="image" src="../pics/back.gif" align="middle" border=0 onClick="history.back()"></div><br></td></tr>
		</table>
		<cfabort>
	</cfif>
</cfif>
</cfoutput>

<cfquery name="update_student" datasource="mysql">
	UPDATE smg_students
	SET familylastname = <cfqueryparam value="#form.familylastname#" cfsqltype="cf_sql_char">,
		firstname = <cfqueryparam value="#form.firstname#" cfsqltype="cf_sql_char">,
		middlename = <cfqueryparam value="#form.middlename#" cfsqltype="cf_sql_char">,
		address = '#form.address#',
		address2 = '#form.address2#',
		city = '#form.city#',
		country = '#form.country#',
		zip = '#form.zip#',
		phone = '#form.phone#', 
		fax = '#form.fax#',
		email = '#form.email#',
		cell_phone = '#form.cell_phone#',
		additional_phone = '#form.additional_phone#',
		sex = <cfif IsDefined('form.sex')>'#form.sex#'<cfelse>''</cfif>,
		dob = <cfif form.dob NEQ ''>#CreateODBCDate(form.dob)#<cfelse>NULL</cfif>,
		citybirth = '#form.citybirth#',
		countrybirth = '#form.countrybirth#',
		countryresident = '#form.countryresident#',
		countrycitizen = '#form.countrycitizen#',
		passportnumber = '#form.passportnumber#',
		height = '#form.height#',
		weight = '#form.weight#',
		haircolor = '#form.haircolor#',
		eyecolor = '#form.eyecolor#'
	WHERE studentid = <cfqueryparam value="#form.studentid#" cfsqltype="cf_sql_integer">
	LIMIT 1
</cfquery>

<cflocation url="?curdoc=student/student_form2&unqid=#form.unqid#" addtoken="no">
	
<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>

</cftry>
</body>
</html>