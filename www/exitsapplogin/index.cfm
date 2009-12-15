<cfquery name="get_company" datasource="mysql">
select companyid, companyname
from smg_companies where url_ref = '#cgi.server_name#' 
</cfquery>

<cfif get_company.recordcount neq 0>
	<cfset client.companyid = #get_company.companyid#>
    <cfset client.companyname = '#get_company.companyname#'>
<cfelse>
	<cfset client.companyid = 0>
    <cfset client.companyname = 'EXIT Group'>
</cfif>

<cfoutput>
<cflocation url="/login.cfm" addtoken="yes">
</cfoutput>