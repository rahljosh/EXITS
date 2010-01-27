<link href="internal/style.css" rel="stylesheet" type="text/css">
<BODY bgcolor="#B5B5BF">

<br><br><br>
<Table ALIGN="CENTER" bordercolor="#FFFFFF" bgcolor="#FFFFFF">
	<tr>
		<td width="181" height="136"><div align="center"><img src="images/extra-logo.jpg" width="160" height="219"></div></td>
	  	<td width="306"><H2 align="center" class="style1">Welcome</H2>
	    	<div align="center" class="style1">Please wait while your login is verified.</div>
		</td>
	</tr>
</Table>

<cfoutput>
<cfset form.username = #Replace(form.username, '"', "", "all")#>
<cfset form.password = #Replace(form.password, '"', "", "all")#>
<cfset form.username = #Replace(form.username, "'", "", "all")#>
<cfset form.password = #Replace(form.password, "'", "", "all")#>

<cflock timeout=20 scope="Session" type="Exclusive">
	<cfset tempvariable = StructDelete(session,"phpfail")>
	<cfset tempvariable = StructDelete(session,"phptempuser")>
</cflock>

<CFQUERY name="authenticate" datasource="mysql">
	SELECT * 
	FROM smg_users 
	WHERE username = "#form.username#" 
		AND password = "#form.password#"
		AND active = '1'
</CFQUERY>

<cfif authenticate.recordcount EQ 1>
	<cfset session.auth = structNew()>
	<cfset client.isLoggedIn = 'Yes'>
	<cfset client.userid = '#authenticate.userid#'>
	<cfset client.firstname = '#authenticate.firstname#'>
	<cfset client.lastname =  '#authenticate.lastname#'>
	<cfset client.lastlogin = '#authenticate.lastlogin#'>
	<cfset client.usertype =  '#authenticate.usertype#'>
	<cfset client.email = '#authenticate.email#'>
	
	<!--- GET DEFAULT COMPANY USER HAS ACCESS TO --->
	<cfquery name="get_default_company" datasource="MySql">
		SELECT uar.id, uar.companyid
		FROM user_access_rights uar
		INNER JOIN smg_companies c ON c.companyid = uar.companyid
		WHERE userid = '#client.userid#'
			AND c.system_id = '4'
		ORDER BY default_region DESC
	</cfquery>	
	
	<!--- USER DOES NOT HAVE ACCESS TO EXTRA --->
	<cfif get_default_company.recordcount EQ 0>
		<cfset client.isLoggedIn = "No">
		<cflocation url = "index.cfm" addtoken="no">
	</cfif>
	
	<!--- SET client.COMPANYID --->
	<cfset client.companyid = #get_default_company.companyid#>
	
	<cfquery name="lastlogin" datasource="mysql">
		UPDATE smg_users SET lastlogin = #now()#
		WHERE userid = '#client.userid#'
	</cfquery>
	
	<!----If user is following a link and they are already logged in, bypas login info---->
	<cfif isDefined('cookie.smglink')>
		<cfif client.companyid NEQ 99>
			<cflocation url="redirect_link.cfm" addtoken="no">
		</cfif>
	</cfif>	
	
	<!--- SET LINKS --->
	<cfset link7 = 'https:/www.student-management.com/extra/internal/trainee/index.cfm'>
	<cfset link8 = 'https:/www.student-management.com/extra/internal/wat/index.cfm'>
	<cfset link9 = 'https:/www.student-management.com/extra/internal/h2b/index.cfm'>
	
	<cflocation url="#Evaluate("link" & get_default_company.companyid)#" addtoken="no">
	
	<!----Once more of site is complete, change this to an appropriate welcome page.--->
	<!----<cflocation url="internal/index.cfm?curdoc=initial_welcome" addtoken="no">--->
	
<cfelse>
	<cfset client.isLoggedIn = "No">
	<cflocation url = "index.cfm" addtoken="no">
</cfif>

</cfoutput>