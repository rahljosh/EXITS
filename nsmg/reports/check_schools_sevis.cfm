<!--- http://web/newsmg/index.cfm?curdoc=marcus_countries --->
<!--- http://web/newsmg/marcus_countries.cfm --->
<cfquery name="company_short" datasource="MySQL">
select companyshort
from smg_companies
where companyid = #client.companyid#
</cfquery>

<cfquery name="check_school_address" datasource="MySql">
	SELECT sc.schoolid, sc.schoolname, sc.address, sc.city, sc.state, sc.zip,
	smg_regions.regionname, smg_programs.programname
	FROM smg_schools sc
	INNER JOIN smg_students ON smg_students.schoolid = sc.schoolid
	INNER JOIN smg_programs ON smg_programs.programid = smg_students.programid
	LEFT JOIN smg_regions ON smg_regions.regionid = smg_students.regionassigned
	WHERE smg_students.companyid = #client.companyid# AND smg_students.active = '1'
	AND smg_programs.programname like '%06%'
	ORDER BY regionname
</cfquery>

<table width="100%" align="center">
<th colspan="6"><cfoutput query="company_short">#companyshort# SCHOOLS</cfoutput></th>
<tr><td>Region</td><td>Program</td><td>School ID</td><td>City</td><td>Address</td><td>State</td><td>ZIP</td></tr>
<cfoutput query="check_school_address">
<tr bgcolor="#iif(check_school_address.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
	<td><cfif regionname is ''><font color="FF0000"><b>REGION IS MISSING</b></font><cfelse>#regionname#</cfif></td>
	<td>#programname#</td>
	<td>#schoolid#</td>
	<td><cfif city is ''><font color="FF0000"><b>CITY IS MISSING</b></font><cfelse>#city#</cfif></td>
	<td><cfif address is ''><font color="FF0000"><b>ADDRESS IS MISSING</b></font><cfelse>#address#</cfif></td>
	<td><cfif state is ''><font color="FF0000"><b>STATE IS MISSING</b></font><cfelse>#state#</cfif></td>
	<td><cfif len(#zip#) gt 5 or zip is ''><font color="FF0000"><b>#zip#</b></font><cfelse>#zip#</cfif></td>
</tr>
</cfoutput>
</table>