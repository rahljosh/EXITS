
<cfinclude template="../../../../smg/newsmg/querys/all_rep_info.cfm">

<style type="text/css">
<!--
/* region table */

table.region { font-size: 12px; border: 1px solid #202020; }
tr.region {  font-size: 12px; border: 1px solid }
td.region {  font-size: 12px; border: 1px solid }
-->
</style> 

<div class="form_section_title"><h3>New User</h3></div>
<cfoutput query="all_rep_info">
#firstname# #lastname# (#userid#)<br>

<table>
	<Tr>
		<td>
			Login: #username# <br>
			Password: #password#
		</td>

</table>
</cfoutput>
<cfform action="querys/add_user_details.cfm?menu=#url.menu#&submenu=#url.submenu#&userid=#userid#" method="post">

<!--- 
<Cfquery name="regions" datasource="MySQL">
select regionname, regionid
from smg_regions 
where (subofregion <> 0) or regionid = 25 and company = '%#client.companyid#%'
order by regionname
</Cfquery> --->


<div class="form_section_title"><h3>Company Assignment (check all that apply)</h3></div>


User will only have access to the company/companies checked here. If selecting more<br> then one company, select which one will be the default.  
<Table border=0>
		<tr>
		<cfloop list=#client.companies# index=x>
		<cfquery name="company_names" datasource="MySQL">
			select companyid, companyname, companyshort
			from smg_companies
			where companyid = #x#
		</cfquery>
		<cfoutput>
		<td valign="middle" width=80><img src="pics/logos/#company_names.companyshort#_logo.gif" align="center"></td><td width=180>#company_names.companyshort#<br>#company_names.companyname#<br><cfif client.companyid is #company_names.companyid#><input type="checkbox" name="companyid" value=#company_names.companyid# checked>Access <input type="radio" name="default" value=#company_names.companyid# checked>Default<cfelse><input type="checkbox" name="companyid" value=#company_names.companyid#>Access <input type="radio" name="default" value=#company_names.companyid#>Default</cfif></td>
		<cfif (#x# mod 2) is 0></tr><tr></cfif>
		</cfoutput>
		</cfloop>
		
	
</table><br><br>

<cfif #all_rep_info.usertype# is 8>


<cfelse>

		
	
	<cfif client.usertype lt 4>
	
<Cfquery name="regions" datasource="MySQL">
select companyshort, regionname, regionid
from smg_regions INNER JOIN smg_companies 
where (subofregion = 0) and company = companyid
order by companyshort, regionname
</Cfquery>


		<div class="form_section_title"><h3>Region Assignment (check all that apply)</h3></div>
		User will only be able to deal with issues in a region that they have access to.
		<table width=80%>
	<tr>
<cfoutput query="regions">

<Td valign="top" width=220 class="region" border=0>

<!---	<input type="checkbox" name="regions" value="#regions.regionid#" <cfif #regions.regionid# is 25>checked</cfif>>#regionname#<cfif #regions.regionid# is 25> (All users have access)</cfif><BR> --->

	<input type="checkbox" name="regions" value="#regions.regionid#">#companyshort# - #regionname#<cfif #regions.regionname# is 'office'> (All users have access)</cfif><BR>
		
	</td>
	<cfif (regions.currentrow mod 2) is 0></tr><tr></cfif>
</cfoutput>
</table>

<cfelse>
<cfquery name="user_regions" datasource="MySQL">
select regions from smg_users
where userid = #client.userid#
</cfquery>
<Cfoutput>
<cfloop list=#user_regions.regions# index=x>
<Cfquery name="regions" datasource="MySQL">
select companyshort, regionname, regionid
from smg_regions INNER JOIN smg_companies 
where (subofregion = 0) and company = companyid
and regionid = #x#
order by companyshort, regionname
</Cfquery>


<Td valign="top" width=220 class="region" border=0>

<!---	<input type="checkbox" name="regions" value="#regions.regionid#" <cfif #regions.regionid# is 25>checked</cfif>>#regionname#<cfif #regions.regionid# is 25> (All users have access)</cfif><BR> --->

	<input type="checkbox" name="regions" value="#regions.regionid#" <cfif #listlen(user_regions.regions)# is 1>checked</cfif>>#regions.companyshort# - #regions.regionname#<cfif #regions.regionname# is 'office'> (All users have access)</cfif><BR>
		
	</td>

	<cfif (#x# mod 2) is 0>
		</tr><tr></cfif>
	

</cfloop>

</Cfoutput>
</table>

</cfif>
</cfif>










<!----
<table>
	<tr>

		<td>
<div class="tab">Region</div>
<div class=box>
<cfoutput query="all_regions_name_id">
<cfinput type="checkbox" name=regionname value=#regionid#> #regionname#<br>
</cfoutput>
</div>
			
</table>
---->
<div class="button" align="right"><input type="submit" name="next" value="    submit    "></div>
</cfform>


