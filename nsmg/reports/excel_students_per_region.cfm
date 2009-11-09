<!--- use cfsetting to block output of HTML outside of cfoutput tags --->
<cfsetting enablecfoutputonly="Yes">

<cfquery name="students" datasource="MySQL">
	SELECT
		smg_students.studentid, smg_students.hostid, smg_students.familylastname,
		smg_students.firstname, smg_students.sex, smg_students.regionguar, smg_students.state_guarantee, 
		smg_students.regionassigned, smg_students.programid,
		smg_regions.regionfacilitator, smg_regions.regionname,
		smg_countrylist.countryname,
		smg_hosts.familylastname as hostlastname,
		smg_schools.schoolname,
		smg_programs.programname, 
		smg_g.regionname as r_guarantee,
		smg_companies.companyshort,
		smg_states.state	
	FROM smg_students 
	INNER JOIN smg_companies on smg_students.companyid = smg_companies.companyid
	INNER JOIN smg_countrylist ON smg_students.countryresident = smg_countrylist.countryid
	LEFT JOIN smg_hosts ON smg_students.hostid = smg_hosts.hostid
	LEFT JOIN smg_schools ON smg_students.schoolid = smg_schools.schoolid
	LEFT JOIN smg_programs ON smg_students.programid = smg_programs.programid
	LEFT JOIN smg_regions on smg_students.regionassigned = smg_regions.regionid
	LEFT JOIN smg_regions smg_g on smg_students.regionalguarantee = smg_g.regionid
	LEFT JOIN smg_states ON state_guarantee = smg_states.id
	WHERE 1 = 1
	<!--- ACTIVE --->
	<cfif form.active is '1'>
		AND smg_students.active = 1 
	</cfif>
	<cfif form.active is '0'>
		AND smg_students.active = 0
	</cfif>
	<!--- PLACEMENT STATUS --->
	<cfif form.status is '0'><cfelse>
		<cfif form.status is 'placed'>
			AND (smg_students.hostid != 0)
		</cfif>
		<cfif form.status is 'unplaced'>
			AND (smg_students.hostid = 0)
		</cfif>
	</cfif>
	<!--- REGION --->
	<cfif form.regionid is '0'><cfelse>
		AND regionassigned = '#form.regionid#'
	</cfif>
	<!--- PROGRAM --->
	<cfif form.programid is '0'><cfelse>
		AND (
	  <cfloop list=#form.programid# index='prog'>
	 	    smg_students.programid = #prog# 
		   <cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
	   </cfloop> )
	</cfif>
	<!--- show all students under the SMG Comnpany --->
	<cfif #client.companyid# is 5><cfelse>
		and smg_students.companyid = #client.companyid# 
	</cfif>
 	order by familylastname 
</cfquery>

<!--- set content type --->
<cfcontent type="application/msexcel">

<!--- suggest default name for XLS file --->
<!--- "Content-Disposition" in cfheader also ensures relatively correct Internet Explorer behavior. --->
<cfheader name="Content-Disposition" value="attachment; filename=smg_students.xls"> 

<cfoutput>
<table border=1 cellpadding=2 cellspacing=0 class="section" width=100%>
	<tr>
		<td>ID</td>
		<td>Last Name</td>
		<td>First Name</td>
		<td>Sex</td>
		<td>Country</td>
		<td>Region</td>
		<td>Program</td>
		<cfif form.status is "unplaced"><cfelse>
		<Td>Family</td>
		</cfif>
		<td>School</td>
		<cfif client.companyid is 5> <!--- show company name if you are logged in the SMG --->
		<td>Company</td>
		</cfif>
	</tr>
	<cfloop query="students">
		<tr bgcolor="#iif(students.currentrow MOD 2 ,DE("ffffe6") ,DE("white") )#">
			<td>#Studentid#</td>
			<td>#familylastname#</td>
			<td>#firstname#</td>
			<td>#sex#</td>
			<td>#Left(countryname,13)#</td>
			<td> #regionname# 
				<cfif students.regionguar is 'yes'>
				<font color="CC0000">
					<cfif r_guarantee is '' and state_guarantee EQ 0>* Missing</cfif>
					<cfif r_guarantee is not ''>* #r_guarantee#
						<cfelseif students.state_guarantee NEQ 0>* #students.state#</cfif>
				</cfif>	
			</td>
			<td> #programname#</td>
			<cfif #form.status# is "unplaced"><cfelse>
			<td>#hostlastname#</td>
			</cfif>
			<td>#schoolname#</td>
			<cfif client.companyid is 5> <!--- show company name if you are logged in the SMG --->
			<td>#companyshort#</td>
			</cfif>
		</tr> 
	</cfloop>
	<tr><td colspan="9">Total of #students.recordcount# students.</td></tr>
</cfoutput>
</table>