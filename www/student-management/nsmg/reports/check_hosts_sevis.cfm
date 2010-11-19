<!--- http://web/newsmg/index.cfm?curdoc=marcus_countries --->
<!--- http://web/newsmg/marcus_countries.cfm --->
<cfquery name="company_short" datasource="MySQL">
select companyshort
from smg_companies
where companyid = #client.companyid#
</cfquery>

<cfquery name="check_host_address" datasource="MySql">
	SELECT h.hostid, h.familylastname, h.city, h.address, h.city, h.state, h.zip,
	smg_regions.regionname, smg_programs.programname
	FROM smg_hosts h
	INNER JOIN smg_students ON smg_students.hostid = h.hostid
	INNER JOIN smg_programs ON smg_programs.programid = smg_students.programid
	LEFT JOIN smg_regions ON smg_regions.regionid = h.regionid
	WHERE h.companyid = #client.companyid# AND smg_students.active = '1'
	AND smg_programs.programname like '%06%'
	ORDER BY regionname
</cfquery>

<table width="100%" align="center">
<th colspan="6"><cfoutput query="company_short">#companyshort# Host Families Hosting Students</cfoutput></th>
<tr><td>Region</td><td>Program</td><td>Host ID</td><td>City</td><td>Address</td><td>State</td><td>ZIP</td></tr>
<cfoutput query="check_host_address">
<tr bgcolor="#iif(check_host_address.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
	<td><cfif regionname is ''><font color="FF0000"><b>REGION IS MISSING</b></font><cfelse>#regionname#</cfif></td>
	<td>#programname#</td>
	<td>#hostid#</td>
	<td><cfif city is ''><font color="FF0000"><b>CITY IS MISSING</b></font><cfelse>#city#</cfif></td>
	<td><cfif address is ''><font color="FF0000"><b>ADDRESS IS MISSING</b></font><cfelse>#address#</cfif></td>
	<td><cfif state is ''><font color="FF0000"><b>STATE IS MISSING</b></font><cfelse>#state#</cfif></td>
	<td><cfif len(#zip#) gt 5 or zip is ''><font color="FF0000"><b>#zip# CHECK</b></font><cfelse>#zip#</cfif></td>
</tr>
</cfoutput>
</table>