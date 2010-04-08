<link rel="stylesheet" href="reports.css" type="text/css">

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">
<!--- COUNTRY LIST --->
<cfinclude template="../querys/get_countries.cfm">

<!--- get international rep countries --->
<cfquery name="get_intl_rep_country" datasource="caseusa">
	SELECT	country, c.countryname
	FROM smg_users
	INNER JOIN smg_countrylist c ON c.countryid = smg_users.country
	WHERE usertype = '8'
	<cfif form.intrep is 0><cfelse>AND userid = '#form.intrep#'</cfif>
	<cfif form.insurance NEQ '0'>AND insurance_typeid = '#form.insurance#'</cfif>
	<cfif form.status is 0>AND active = '1'</cfif>
	<cfif form.status is 1>AND active = '0'</cfif>
	<cfif form.countryid is 0><cfelse>
	AND	( <cfloop list="#form.countryid#" index='fcountry'>
		country = '#fcountry#' 
		<cfif fcountry is #ListLast(form.countryid)#><Cfelse>or</cfif>
		</cfloop> )
	</cfif>
	GROUP BY countryname
	ORDER BY Countryname
</cfquery>

<!--- 	AND (country = '13' OR country = '20' OR country = '38' OR country = '59' OR country = '49' OR country = '154' OR country = '112' OR country = '141'
	OR country = '172' OR country = '174' OR country = '215' OR country = '224' OR country = '234')
 --->	

<table width=100% align="center">
<span class="application_section_header"><cfoutput>#companyshort.companyshort# - 
<cfif form.status is 0>Active </cfif> 
<cfif form.status is 1>Inactive </cfif>
<cfif form.status is 2>All </cfif>International Representatives</cfoutput></span>
</table>
<br>

<!--- Country Loop --->
<cfloop query="get_intl_rep_country"> 
	
	<!--- get international reps --->
	<cfquery name="get_intl_rep" datasource="caseusa">
		SELECT	smg_users.*, c.countryname, smg_insurance_type.type
		FROM smg_users
		INNER JOIN smg_countrylist c ON c.countryid = smg_users.country
		LEFT JOIN smg_insurance_type ON smg_insurance_type.insutypeid = insurance_typeid
		WHERE usertype = '8'
			AND country = '#get_intl_rep_country.country#'
			<cfif form.intrep is 0><cfelse>AND userid = '#form.intrep#'</cfif>
			<cfif form.insurance NEQ '0'>AND insurance_typeid = '#form.insurance#'</cfif>
			<cfif form.status is 0>AND active = '1'</cfif>
			<cfif form.status is 1>AND active = '0'</cfif>
		ORDER BY businessname
	</cfquery>
		
		<table width=100% align="center" cellpadding=6 cellspacing="0" frame="border">	
			<tr><th colspan="6"><cfoutput><b><font color="5E748C">#get_intl_rep_country.countryname#</font></b></cfoutput></th></tr>
		</table>
		
		<table width=100% align="center" cellpadding=6 cellspacing="0" frame="below">	
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
			<td width="20%"><cfif address is ''>#address2#<cfelse>#address#</cfif>, #city# &nbsp; #zip#</td>
			<td width="11%"><cfif businessphone is ''>#phone#<cfelse>#businessphone#</cfif></td>						
			<td width="11%">#fax#</td>
			<td width="18%"><cfif email is ''><a href="mailto:#email2#">#email2#</a><cfelse><a href="mailto:#email#">#email#</a></cfif></td>
			<td width="10%">#type#</td>
		</tr>
		</cfoutput>
		</table>
	<br>	
</cfloop>