<link rel="stylesheet" href="reports.css" type="text/css">

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<table width='650' cellpadding=6 cellspacing="0" align="center">
<span class="application_section_header"><cfoutput>#companyshort.companyshort# - Total of Active Students Per Country</cfoutput></span>
</table>
<br>

	<!--- Get countries according to the program --->
	<cfquery name="get_country" datasource="MySQL">
	SELECT 
			count(studentid) as total_students, countryresident, countryname
	FROM 	smg_students
	INNER JOIN smg_countrylist ON countryid = countryresident
	WHERE 	active = '1' 
	<cfif form.countryid is 0><cfelse>
			AND countryresident = '#form.countryid#'
	</cfif>
	<cfif form.status is 1>
		AND hostid <> '0'
	</cfif>
	<cfif form.status is 2>
		AND hostid = '0'
	</cfif>
	GROUP BY countryname
	ORDER BY countryname
	</cfquery>

	<!--- 0 students will skip the table --->
	<cfif get_country.recordcount is 0><cfelse> 	
		<table width='650' cellpadding=6 cellspacing="0" align="center" frame="box">	
			<tr><th width="75%">Country</th> <th width="25%">Total</th></tr>
			<!--- Country Loop --->
			<cfoutput query="get_country">
				<tr bgcolor="#iif(get_country.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
					<td width="75%">#countryname#</td>
					<td width="25%" align="center">#total_students#</td>
				</tr>
			</cfoutput>
		</table>
		<br><br>	
	</cfif>