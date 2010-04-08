
<cfset client.companyid = #url.id#>


<cfquery name="get_rep_info" datasource="caseusa">
select * 
from smg_users 
where userid = #client.userid#
</cfquery>

<cfquery name="get_usertype" datasource="caseusa">
select usertype 
from user_access_rights
where userid = #client.userid# and companyid = #client.companyid#
</cfquery>
<cfif get_usertype.recordcount eq 1>
<cfset client.usertype = #get_usertype.usertype#>
<cfelse>
<cfset client.usertype = #get_rep_info.usertype#>
</cfif>
<cfset client.name = '#get_rep_info.firstname# #get_rep_info.lastname#'>
<cfset client.email = '#get_rep_info.email#'>
<!----
<cfset client.companies = '#get_rep_info.companyid#'>
---->
<Cfset client.lastlogin = '#get_rep_info.lastlogin#'>
<!----Set Regions: loop thorough region list and assign only regions for this company---->
<cfquery name="regions" datasource="caseusa">
	select regionid from user_access_rights
	where userid = #client.userid# and companyid = #client.companyid#
</cfquery>
<cfif regions.recordcount eq 1>
	<cfset client.regions = #regions.regionid#>
<cfelse>
	<cfset client.regions = -1>
</cfif>
<!----
<cfif isDefined('url.curdoc')>
	<cfif url.curdoc is 'loginform'>
	<cflocation url="loginform.cfm">
	</cfif>
</cfif>
---->


<cflocation url="#cookie.prev_view#" addtoken="no">


