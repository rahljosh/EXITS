<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" >
<html>
<head>
<title>Verification</title>
<link rel="stylesheet" href="login.css" type="text/css">

</head>
<br><Br><div align="Center"><strong>Welcome</strong><br><br><br> Verifying login credentials.<br>
<img src="pics/ticky-ticky.gif"></div>

<cfoutput>
<cfset form.username = #Replace(form.username, '"', "", "all")#>
<cfset form.password = #Replace(form.password, '"', "", "all")#>
<cfset form.username = #Replace(form.username, "'", "", "all")#>
<cfset form.password = #Replace(form.password, "'", "", "all")#>
</cfoutput>

<cflock timeout=20 scope="Session" type="Exclusive">
	<cfset tempvariable = StructDelete(session,"smgfail")>
	<cfset tempvariable = StructDelete(session,"smgtempuser")>
</cflock>

<cfquery name="student_login" datasource="caseusa">
	SELECT studentid, firstname, familylastname
	FROM smg_students
	WHERE email = "#form.username#" 
		and password="#form.password#" 
		and active = 1
</cfquery>

<cfif student_login.recordcount gt 0>
	<cfif cgi.HTTP_REFERER eq "http://www.case-usa.org/login.cfm" or cgi.HTTP_REFERER eq "http://www.case-usa.org/login.cfm">
		<cflocation url="http://www.case-usa.com/int_agent2.cfm" addtoken="no">
		<cfabort>
	</cfif>

	<cfset client.studentid = #student_login.studentid#>
	<cfset client.usertype = 10>
	<Cfset client.userid = #student_login.studentid#>
	<cfset client.name = '#student_login.firstname# #student_login.familylastname#'>
	<cflocation url="student_app/login.cfm">
	<cfabort>
</cfif>

<CFQUERY name="authenticate" datasource="caseusa">
	SELECT * FROM smg_users where username="#form.Username#" and password="#form.Password#" and active = 1
</CFQUERY>

<CFIF authenticate.recordcount gt 0>
	<cfif authenticate.usertype eq 8>
		<cfif cgi.HTTP_REFERER eq "http://www.case-usa.org/login.cfm" or cgi.HTTP_REFERER eq "http://www.case-usa.org/login.cfm">
		<cflocation url="http://www.case-usa.org/int_agent2.cfm" addtoken="no">
		<cfabort>
		</cfif>
	</cfif>
	<!----
	<!---check for IP address verification from Keara Hilton---->
	<cfif authenticate.userid eq 9401 and cgi.REMOTE_ADDR is not '68.74.107.151'>
	<CFLOCATION url="ip_restriction.cfm">
	<cfabort>
	</cfif>
	---->
	<!----end of IP verification---->
	<CFSET client.userid="#authenticate.userid#">
	<cfset client.companyid = #authenticate.defaultcompany#>
	<!----<cfif ListFind(authenticate.companyid, client.companyid , ",")>
	
	<cfelse>
	<cfset client.companyid = #authenticate.defaultcompany#> 
	</cfif>---->

	<meta http-equiv="Refresh" content="0;url=verifyaccount.cfm">
	
<CFELSE>
	<CFOUTPUT>
		<Cfset client.smgfail = 'yes'>
		<cfset client.smgtempuser = '#form.username#'>
		<meta http-equiv="Refresh" content="0;url=loginform.cfm">
	</CFOUTPUT>
	
</CFIF>


