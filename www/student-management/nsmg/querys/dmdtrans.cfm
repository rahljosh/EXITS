<br><Br><div align="Center"><strong>Welcome</strong><br><br><br> Please wait while we re-authenticate you.</div>

<cfset form.username = "#form.u#">
<cfset form.password = "#form.p#">
<cfset client.companyid = 4>

<cflock timeout=20 scope="Session" type="Exclusive">
<cfset tempvariable = StructDelete(session,"smgfail")>
<cfset tempvariable = StructDelete(session,"smgtempuser")>
</cflock>
<CFQUERY name="authenticate" datasource="MySQL">
	SELECT * FROM smg_users where username="#form.username#" and password="#form.password#"
</CFQUERY>

<CFIF authenticate.recordcount gt 0>
	<CFSET client.userid="#authenticate.userid#">
	<cfif ListFind(authenticate.companyid, client.companyid , ",")>
	
	<cfelse>
	<cfset client.companyid = #authenticate.defaultcompany#> 
	</cfif>
	<meta http-equiv="Refresh" content="0;url=verifyaccount.cfm">
	
	
<CFELSE>
	<CFOUTPUT>
		<Cfset client.smgfail = 'yes'>
		<cfset client.smgtempuser = '#form.username#'>
		<meta http-equiv="Refresh" content="0;url=loginform.cfm">
	</CFOUTPUT>
</CFIF>

