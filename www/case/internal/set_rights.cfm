<cfquery name="companies" datasource="caseusa">
	select distinct companyid from user_access_rights
	where userid = #client.userid#
</cfquery>

<cfset client.companies = ''>
<cfset client.companies = ValueList(companies.companyid)>
<!--- <cfloop query="companies">
	<cfset client.companies = #ListAppend(client.companies, #companyid#, ',')#>
</cfloop> --->
	
<cfset client.name = '#get_rep_info.firstname# #get_rep_info.lastname#'>
<cfset client.email = '#get_rep_info.email#'>

<cfset client.usertype = #get_rep_info.usertype#>

<cfif get_rep_info.usertype eq 8>
	<cfset client.parentcompany = #client.userid#>
<cfelseif get_rep_info.usertype gte 9>
	<cfset client.parentcompany = #get_rep_info.intrepid#>
</cfif>

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
<Cfset client.regions = ''>
<cfloop list="#get_rep_info.regions#" index=i >
<cfquery name="region_company" datasource="caseusa">
select regionid from smg_regions
where regionid = #i# and company=#client.companyid#
</cfquery>

<cfif region_company.recordcount is not 0>
<Cfoutput>
<Cfset client.regions = #ListAppend(client.regions, region_company.regionid)#>
</Cfoutput>
</cfif>

</cfloop>

---->

<!----Update Last Login---->
<cfquery name="update_last_login" datasource="caseusa">
update smg_users
	set lastlogin = #now()#
where userid = #client.userid#
</cfquery>

<cfquery name="update_info" datasource="caseusa">
select firstlogin 
from smg_users
where userid = #client.userid#
</cfquery>

<Cfif client.usertype is 8>
	<cfif update_info.firstlogin is 0>
	<cfoutput>
	<meta http-equiv="Refresh" content="1;url=index.cfm?curdoc=user_info&userid=#client.userid#&redirect=initial_welcome">
	</cfoutput>
	<cfelse>
	<meta http-equiv="Refresh" content="1;url=index.cfm?curdoc=initial_welcome">
	</cfif>

<cfelseif client.usertype EQ '11'>
	<meta http-equiv="Refresh" content="1;url=index.cfm?curdoc=initial_welcome">

<cfelseif isDefined('cookie.smglink')>
	<cfquery name="get_link" datasource="caseusa">
		select link
		from smg_links 
		where id = #cookie.smglink#
	</cfquery>
	<cfif get_link.recordcount eq 0>
	The link you followed is invalid.  Please contact sender.<br>
	You wil be redirected to the internal site shortly, if you are not redirected, click <a href="index.cfm?curdoc=initial_welcome">here.</a>
	<meta http-equiv="Refresh" content="1;url=index.cfm?curdoc=initial_welcome">
	<cfelse>
	<cfoutput>
		<meta http-equiv="Refresh" content="1;url=#get_link.link#">
	</cfoutput>
	</cfif>
<cfelse>

	<cfif update_info.firstlogin is 0>
	<cfoutput>
	
	<meta http-equiv="Refresh" content="1;url=index.cfm?curdoc=user_info&userid=#client.userid#&redirect=initial_welcome">
	</cfoutput>
	<cfelse>
	<meta http-equiv="Refresh" content="1;url=index.cfm?curdoc=initial_welcome">
	</cfif>
</cfif>