<br><Br><div align="Center"><strong>Welcome</strong><br><br><br> Please wait while we gather your information.</div>

<cfoutput>
<cfset form.username = #Replace(form.username, '"', "", "all")#>
<cfset form.password = #Replace(form.password, '"', "", "all")#>
<cfset form.username = #Replace(form.username, "'", "", "all")#>
<cfset form.password = #Replace(form.password, "'", "", "all")#>

</cfoutput>
<cflock timeout=20 scope="Session" type="Exclusive">
<cfset tempvariable = StructDelete(session,"session.auth")>

</cflock>
<CFQUERY name="authenticate" datasource="MySQL">
	SELECT * FROM smg_users where username="#form.Username#" and password="#form.Password#"
</CFQUERY>
<CFIF authenticate.recordcount gt 0>
	<CFSET session.auth.userid="#authenticate.userid#">
	<cfset session.auth.companyid = #authenticate.defaultcompany#>
	<!----<cfif ListFind(authenticate.companyid, session.companyid , ",")>
	
	<cfelse>
	<cfset session.companyid = #authenticate.defaultcompany#> 
	</cfif>
	<meta http-equiv="Refresh" content="0;url=verifyaccount.cfm">
	---->
	1
<CFELSE>
	2
	<!----
	<CFOUTPUT>
		<Cfset session.auth.egomfail = 'yes'>
		<cfset session.auth.egomtempuser = '#form.username#'>
		<cfset session.auth.isLoggedin = 'no'>
		<meta http-equiv="Refresh" content="0;url=index.cfm">
	</CFOUTPUT>
	---->
</CFIF>
