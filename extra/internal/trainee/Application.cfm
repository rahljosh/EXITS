<cfapplication name="extra" clientmanagement="yes" sessionmanagement="yes" sessiontimeout="#CreateTimeSpan(0,10,40,1)#">
<CFQUERY name="selectdb" datasource="MySQL" >
	USE smg
</CFQUERY>

<link rel="SHORTCUT ICON" href="pics/favicon.ico">

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
	You must log in to view this page.
	<cfabort>
</cfif>