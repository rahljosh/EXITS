<cfapplication name="caseusa_external" clientmanagement="yes" sessionmanagement="yes" setclientcookies="yes" setdomaincookies="yes" sessiontimeout="#CreateTimeSpan(0,10,40,1)#">
<cfquery name="selectdb" datasource="caseusa">
	USE caseusa
</cfquery>

<cfif IsDefined('url.client.usertype')>
	You do not have rights to see this page.
	<cfabort>
</cfif>

<cfif IsDefined('url.client.userid')>
	You do not have rights to see this page.
	<cfabort>
</cfif>

<cfif IsDefined('url.client.companyid')>
	You do not have rights to see this page.
	<cfabort>
</cfif>

<cfif NOT IsDefined('client.usertype')>
	<cfset client.usertype = 100>
</cfif>

<!---
<cfif NOT IsDefined('client.usertype')>
	You must log in to view this page.
	<cfabort>
</cfif>
--->
