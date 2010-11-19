<link rel="stylesheet" href="reports.css" type="text/css">

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">
<!--- COUNTRY LIST --->
<cfinclude template="../querys/get_countries.cfm">

<table width=100% align="center">
<span class="application_section_header"><cfoutput>#companyshort.companyshort# - 
<cfif form.status is 0>Active </cfif> 
<cfif form.status is 1>Inactive </cfif>
<cfif form.status is 2>All </cfif>International Representatives</cfoutput></span>
</table><br>

<!--- get international reps --->
<cfquery name="get_intl_rep" datasource="MYSQL">
	SELECT	smg_users.*, c.countryname, smg_insurance_type.type
	FROM smg_users
	INNER JOIN smg_countrylist c ON c.countryid = smg_users.country
	LEFT JOIN smg_insurance_type ON smg_insurance_type.insutypeid = insurance_typeid
	WHERE usertype = '8'
	<cfif form.intrep neq 0>AND userid = #form.intrep#</cfif>
	<cfif form.insurance NEQ '0'>AND insurance_typeid = '#form.insurance#'</cfif>
	AND smg_users.active = <cfif form.status is 0>'1'<cfelse>'0'</cfif>
	<cfif form.continent is not 0 and form.continent is not 'non-asia'>AND c.continent = '#form.continent#'</cfif>
	<cfif form.continent is not 0 and form.continent is 'non-asia'>AND c.continent != 'asia'</cfif>
	<cfif form.countryid NEQ '0'>
		AND	( <cfloop list="#form.countryid#" index='fcountry'>
			country = '#fcountry#' 
			<cfif fcountry is #ListLast(form.countryid)#><Cfelse>or</cfif>
			</cfloop> )
	</cfif>
	ORDER BY businessname
</cfquery>
		
<table width="95%" align="center" cellpadding=6 cellspacing="0" frame="below">
<tr><th colspan="7"><cfoutput>Total of #get_intl_rep.recordcount# agent(s).</cfoutput></th></tr>	
<tr>
	<th width="18%" align="left"><b>Business</b></th> 
	<th width="12%" align="left">Contact Name</th>
	<th width="20%" align="left">Address</th>
	<th width="11%" align="left">Phone No.</th>
	<th width="11%" align="left">Fax No.</th>
	<th width="18%" align="left">E-mail</th>
	<th width="10%" align="left">Insurance</th>
</tr>
<!--- Intl. Rep Loop --->
<cfoutput query="get_intl_rep">
<tr bgcolor="#iif(get_intl_rep.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
	<td width="18%">#businessname#</td>
	<td width="12%">#firstname# #lastname#</td>
	<td width="20%"><cfif address is ''>#address2#<cfelse>#address#</cfif>, #city# &nbsp; &nbsp; #zip# &nbsp; &nbsp; #countryname#</td>
	<td width="11%"><cfif businessphone is ''>#phone#<cfelse>#businessphone#</cfif></td>						
	<td width="11%">#fax#</td>
	<td width="18%"><cfif email is ''><a href="mailto:#email2#">#email2#</a><cfelse><a href="mailto:#email#">#email#</a></cfif></td>
	<td width="10%"><cfif type is ''>missing<cfelse>#type#</cfif></td>
</tr>
</cfoutput>
</table><br>	