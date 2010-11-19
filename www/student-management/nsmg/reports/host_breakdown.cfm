Host Family Check Up<br><br>
<cfoutput>
<cfif isDefined('url.hostid')>
<Cfelse>
Sort: #form.orderby#<br>
Region: #form.region#
</cfif>
</cfoutput>
<cfquery name="hosts" datasource="MySQL">
select * from smg_hosts
<cfif isDefined('url.hostid')>
where hostid = #url.hostid#
<Cfelse>
where companyid = #form.companyid#
<cfif form.region is 0>
<cfelse>
and regionid = #form.region#
</cfif>
order by #form.orderby#
</cfif>
</cfquery>

<cfoutput query="hosts">
	
	<cfquery name="region" datasource="mysql">
	select regionname, company
	from smg_regions 
	where regionid = #regionid#
	</cfquery>
	<cfif region.company is '' or region.company is 0>
	<cfset region_company.companyshort = 'None'>
	<cfelse>
	<Cfquery name="region_company" datasource="MySQL">
	select companyshort
	from smg_companies
	where companyid = #region.company#	
	</Cfquery>
	</cfif>
		<cfif hosts.companyid is '' or hosts.companyid is 0>
	<cfset host_company.companyshort = 'None'>
	<cfelse>
	<Cfquery name="host_company" datasource="mysql">
	select companyshort
	from smg_companies
	where companyid = #hosts.companyid#
	</Cfquery>
	</cfif>
	
	<cfquery name="hosting" datasource="MySQL">
	select smg_students.studentid, smg_students.active, smg_students.arearepid, smg_students.placerepid, smg_students.firstname, smg_students.familylastname, smg_students.regionassigned, smg_students.companyid, smg_companies.companyshort 
	from smg_students, smg_companies
	where hostid = #hostid#
	</cfquery>
	<cfif hosting.regionassigned is '' or hosting.regionassigned is 0>
	
	<cfelse>
	<cfquery name="student_region" datasource="MySQL">
	select smg_regions.regionname, smg_regions.company, smg_companies.companyshort
	from smg_regions, smg_companies
	where smg_regions.regionid = #hosting.regionassigned#
	</cfquery>
	</cfif>
	<cfif hosting.arearepid is 0 or hosting.arearepid is ''>
	<cfset sup_rep_info.recordcount =0>
	<cfelse>
		<cfquery name="sup_Rep_info" datasource="MySQL">
		select smg_users.firstname, smg_users.lastname, smg_users.userid, smg_users.active, smg_users.regions, smg_users.companyid
		from smg_users
		where userid = #hosting.arearepid#
		</cfquery>
	</cfif>
	<cfif hosting.placerepid is 0 or hosting.placerepid is ''>
	<cfset place_rep_info.recordcount =0>
	<cfelse>
		<cfquery name="place_Rep_info" datasource="MySQL">
		select smg_users.firstname, smg_users.lastname, smg_users.userid, smg_users.active, smg_users.regions, smg_users.companyid
		from smg_users
		where userid = #hosting.placerepid#
		</cfquery>
	</cfif>

	<table width=100% border=1>
	<th colspan=5 align="left">#familylastname# -- #fatherfirstname# <Cfif #motherfirstname# is '' or #fatherfirstname# is ''><cfelse>&</Cfif>  #motherfirstname#  (#hostid#)</th>
		<tr bgcolor="FBFDD7"><td rowspan="2">H<br>O<BR>S<BR>T</td>
			<Td>Active</Td><td>Region Assigned To</td><td>Region Company</td><td>Host Company</td><td>Problems</td>
		</tr>
		<tr bgcolor="FBFDD7">
			<td align="Center"><Cfif #hosts.active# is 1>Yes<cfelse>No</Cfif> </td><td align="Center"><cfif region.regionname is ''>None</cfif>#region.regionname#</td><td align="Center">#region_company.companyshort#</td><td align="Center">#host_company.companyshort#</td><td>
			<font color="red"><cfif #hosts.regionid# is 0>Host not assigned to region<br><cfelse>
			<cfif #hosts.companyid# is not #region.company#>Host Company  and Region Company do not match.<br></cfif>
			</cfif>
			<cfif #hosts.regionid# is not 0 and #region.company# is 0>Region is a master region, reassign to a company region.</cfif>
			 </td>
		</tr>
				<!----student info for this host---->
		
				<tr bgcolor="CCCCCC"><td rowspan="2">S<br>T<BR>U</td>
			<Td>Active</Td><td>Region Assigned </td><td>Region Company</td><td>Student Company</td><td>Problems</td>
		</tr>
		<tr bgcolor="CCCCCC">
		<cfif hosting.recordcount is 0 >
			<td colspan=4><div align="center"><font color="red">No student assigned to Host.</div></td><td><cfif hosting.recordcount gt 0><font color="Red">Host has Student assigned.  Reps need to be assigned for both host and student.</cfif></td>
		<cfelse>
		<tr bgcolor="CCCCCC">
			<td align="Center"><Cfif #hosting.active# is 1>Yes<cfelse>No</Cfif> </td><td align="Center"><cfif hosting.regionassigned is ''>None</cfif>#student_region.regionname#</td><td align="Center">#student_region.companyshort#</td><td align="Center">#hosting.companyshort#</td><td>
			<font color="red">
			 </td>
		</tr>
		</cfif>
		<!---- Supervising Rep info for this host---->
		<tr bgcolor="FBFDD7"><td rowspan="2">S.<br>R<br>E<BR>P</td>
			<Td>Active</Td><td>Region Assigned </td><td>Region</td><td>Company</td><td>Problems</td>
		</tr>
		<tr bgcolor="FBFDD7">
		
			<Cfif sup_rep_info.recordcount is 0>
				<td colspan=4><div align="center"><font color="red">No supervising rep assigned to Host.</div></td><td><cfif hosting.recordcount gt 0><font color="Red">Host has Student assigned.  Reps need to be assigned for both host and student.</cfif></td>
			<cfelse>
				<td align="Center"><Cfif #sup_rep_info.active# is 1>Yes<cfelse>No</Cfif> </td>
				<td align="Center"><cfif ListFindNoCase(sup_rep_info.regions, '#hosts.regionid#') gt 0>Sup. Rep Covers Host Region<cfelse><font color="red">Rep DOES NOT cover Host Region</cfif><br>
									</td>
				<td align="Center"><cfif ListFindNoCase(sup_rep_info.regions, '#hosting.regionassigned#') gt 0>Sup. Rep Region & Student Region Match<cfelse><font color="red">Sup. Rep Region & Student Region DO NOT Match</font></cfif></td>
				<td align="Center"><cfif ListFindNoCase(sup_rep_info.regions, '#hosts.regionid#') gt 0>Sup. Rep Co. & Host Co. Match<cfelse><font color="red">Sup. Rep Co. & Host Co. DO NOT Match</font></cfif><br>
									<cfif ListFindNoCase(sup_rep_info.regions, '#hosting.regionassigned#') gt 0>Sup. Rep Co. & Student Co. Match<cfelse><font color="red">Sup. Rep Co. & Host Co. DO NOT Match</font></cfif></td><td>
				 </td>
			</cfif>
		</tr>
		
		<!----Placing Rep info for this host---->
		<tr bgcolor="CCCCCC"><td rowspan="2">P.<br>R<br>E<BR>P</td>
			<Td>Active</Td><td>Region Assigned </td><td></td><td>Rep Company</td><td>Problems</td>
		</tr>
		<tr bgcolor="CCCCCC">
		<Cfif place_rep_info.recordcount is 0>
			<td colspan=4><div align="center"><font color="red">No supervising rep assigned to Host.</div></td><td><cfif hosting.recordcount gt 0><font color="Red">Host has Student assigned.  Reps need to be assigned for both host and student.</cfif></td>
		<cfelse>
			<td align="Center"><Cfif #place_rep_info.active# is 1>Yes<cfelse>No</Cfif> </td>
			<td align="Center"><cfif ListFindNoCase(place_rep_info.regions, '#hosts.regionid#') gt 0>Place Rep Covers Host Region<cfelse><font color="red">Place Rep DOES NOT cover Host Region</cfif><br>
								</td>
			<td align="Center"><cfif ListFindNoCase(place_rep_info.regions, '#hosting.regionassigned#') gt 0>Place Rep Region & Student Region Match<cfelse><font color="red">Place Rep Region & Student Region DO NOT Match</font></cfif></td>
			<td align="Center"><cfif ListFindNoCase(place_rep_info.regions, '#hosts.regionid#') gt 0>Place Rep Co. & Host Co. Match<cfelse><font color="red">Place Rep Co. & Host Co. DO NOT Match</font></cfif><br>
								<cfif ListFindNoCase(place_rep_info.regions, '#hosting.regionassigned#') gt 0>Place Rep Co. & Student Co. Match<cfelse><font color="red">Place Rep Co. & Host Co. DO NOT Match</font></cfif></td><td>
			 </td>
			</cfif>
		</tr>
	</table>
	
<br>
<cfflush>
</cfoutput>