<link href="style.css" rel="stylesheet" type="text/css">
<BODY bgcolor="#B5B5BF">

<br><br><br>

<Table bgcolor="#FFFFFF" ALIGN="CENTER">
	<tr>
		<td width="181" height="136"><img src="images/logo.jpg" width="160" height="95"></td>
	  <td width="306"><H2 align="center">Welcome</H2>
	    <div align="center">Please wait while your login is verified.</div></td>
	</tr>
</Table>

<CFQUERY name="authenticate" datasource="#application.dsn#">
	SELECT *
	FROM smg_users 
	WHERE username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.username)#">
    AND password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.password)#">
    AND active = 1
</CFQUERY>

<cfif authenticate.recordcount EQ 1>

	<cfquery name="user_access" datasource="#application.dsn#">
		SELECT user_access_rights.usertype
		FROM user_access_rights
        INNER JOIN smg_companies ON user_access_rights.companyid = smg_companies.companyid
        WHERE smg_companies.website = 'PHP'
		AND user_access_rights.userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#authenticate.userid#">
	</cfquery>
	
	<cfset client.isLoggedIn = 'Yes'>
	<cfset client.userid = authenticate.userid>
	<cfset client.firstname = authenticate.firstname>
	<cfset client.lastname =  authenticate.lastname>
    <cfset client.email = authenticate.email>
	<cfset client.lastlogin = authenticate.lastlogin>
	<cfif authenticate.usertype EQ 8>
		<cfset client.usertype = 8>
	<cfelse>
		<cfset client.usertype = user_access.usertype>
	</cfif>
	<cfset client.companyid = 6>

	<!--- this is currently used only in the menu. --->
    <cfset client.invoice_access = authenticate.invoice_access>

	<cfquery name="lastlogin" datasource="#application.dsn#">
		UPDATE smg_users
        SET lastlogin = #now()#
		WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
	</cfquery>
	
	<!----Once more of site is complete, change this to an appropriate welcome page.--->
	<cflocation url="internal/index.cfm?curdoc=initial_welcome" addtoken="no">
    
<cfelseif authenticate.recordcount eq 0>

	<CFQUERY name="school" datasource="#application.dsn#">
		SELECT * 
		FROM php_schools
		WHERE email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.username)#"> 
        AND password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.password)#">
        AND active = 1
	</CFQUERY>

	<cfif school.recordcount neq 0>

		<cfset client.isLoggedIn = 'Yes'>
		<cfset client.userid = school.schoolid>
		<cfset client.firstname = school.contact>
		<cfset client.lastname = ''>
	    <cfset client.email = school.email>
		<cfset client.lastlogin = school.lastlogin>
		<cfset client.usertype = 12>
		<cfset client.companyid = 6>
	
        <cfquery name="lastlogin" datasource="#application.dsn#">
            UPDATE php_schools
            SET lastlogin = #now()#
            WHERE schoolid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
        </cfquery>
        
        <cflocation url="internal/index.cfm?curdoc=initial_welcome" addtoken="no">
        
	<cfelse>
		<cfset client.isLoggedIn = "No">
		<cflocation url = "contact.cfm" addtoken="no">
	</cfif>
    
<cfelse>

	<cfset client.isLoggedIn = "No">
	<cflocation url = "contact.cfm" addtoken="no">

</cfif>
