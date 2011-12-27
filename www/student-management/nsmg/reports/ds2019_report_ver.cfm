<link rel="stylesheet" href="reports.css" type="text/css">

<style>
	@page Section1 {
		size:8.5in 11.0in;
		margin:0.3in 0.3in 0.46in;
	}
	div.Section1 {		
		page:Section1;
	}
</style>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<!--- get company region --->
<cfquery name="get_region" datasource="MySQL">
	SELECT	regionname, company, regionid
	FROM smg_regions
	WHERE company = '#client.companyid#'
		<cfif form.regionid is 0><cfelse>AND regionid = '#form.regionid#'</cfif>
	ORDER BY regionname
</cfquery>

<!--- get Students  --->
<Cfquery name="get_total" datasource="MySQL">
	SELECT s.studentid
	FROM smg_students s 
	INNER JOIN smg_programs p ON s.programid = p.programid
	LEFT JOIN smg_hosts h ON s.hostid = h.hostid		
	LEFT JOIN smg_schools sch ON s.schoolid = sch.schoolid
	WHERE 
    	s.active = '1' 
	<cfif VAL(form.regionid)>
    	AND regionassigned = '#form.regionid#'
	</cfif> 
    AND	
        s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> )
    <cfif CLIENT.companyID EQ 5>
        AND	
            s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISE#" list="yes"> )
    <cfelse>
        AND	
            s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
    </cfif>
</cfquery>

<div class="Section1">

<cfoutput>
<table width="650" align="center" border=0 bgcolor="FFFFFF">
	<tr>
		<td width="50">&nbsp;</td>
		<td><img src="../pics/logos/#client.companyid#.gif"  alt="" border="0" align="left"></td>
		<td valign="middle" align="left"><font size="+3"><b>#CLIENT.DSFormName# Verification Report</b></font></td>		
	</tr>
	<tr><td colspan="3"><hr width=100% align="center"></td></tr>
</table>

<cfif get_total.recordcount mod 6 is 0>
	<cfset totalpages = get_total.recordcount \ 6>
<cfelse>	
	<cfset totalpages = get_total.recordcount \ 6>
	<cfset totalpages = totalpages + 1>
</cfif>

<cfset pagenumber = 0>

<cfset current_record_count = '0'>

</cfoutput>

<cfloop query="get_region">

	<!--- get Students  --->
	<Cfquery name="get_students" datasource="MySQL">
		SELECT 
			s.studentid, s.firstname, s.familylastname, s.programid, s.ds2019_no,
			p.programname,
			h.familylastname as hostfamily, h.address as hostaddress, h.address2 as hostaddress2, 
			h.city as hostcity, h.state as hoststate, h.zip as hostzip,
			sch.schoolname, sch.address as schooladdress, sch.address2 as schooladdress2,
			sch.city as schoolcity, sch.state as schoolstate, sch.zip as schoolzip
		FROM smg_students s 
		INNER JOIN smg_programs p		ON 	s.programid = p.programid
		LEFT OUTER JOIN smg_hosts h 	ON 	s.hostid = h.hostid		
		LEFT OUTER JOIN smg_schools sch ON 	s.schoolid = sch.schoolid
		WHERE s.active = '1' 
			AND s.companyid = '#client.companyid#' 
			AND s.ds2019_no LIKE 'N%'
			AND regionassigned = '#get_region.regionid#'
			AND	( <cfloop list=#form.programid# index='prog'>
			s.programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop> )
		ORDER BY s.familylastname
	</cfquery>
	
	<cfif get_students.recordcount is '0'><cfelse>
	
		<table width='650' cellpadding=2 cellspacing="0" align="center" frame="below" border="1">
		<tr><th>Region : &nbsp; <cfoutput>#get_region.regionname#</cfoutput> </th></tr>
		</table><br>
	
		<cfoutput query="get_students">
		<cfset current_record_count = #current_record_count# + '1'>
		<table width='650' cellpadding=6 cellspacing="0" align="center" frame="below" border="1">
		<tr><td>
				<table>
				<tr>
					<td align="left" width="30">#get_students.currentrow#</td>
					<td align="right" width="110"><b>First Name :</b></td><td width="180">#firstname#</td>
					<td align="right" width="110"><b>School Name :</b></td><td width="220">#schoolname#</td>
				</tr>
				<tr>
					<td align="left">&nbsp;</td>
					<td align="right"><b>Last Name :</b></td><td>#familylastname#</td>
					<td align="right"><b>Address :</b></td><td><cfif schooladdress is ''>#schooladdress2#<cfelse>#schooladdress#</cfif></td>			
				</tr>
				<tr>
					<td align="left">&nbsp;</td>
					<td align="right"><b>Host Family :</b></td><td>#hostfamily#</td>
					<td align="right"><b>City :</b></td><td>#schoolcity#</td>			
				</tr>
				<tr>
					<td align="left">&nbsp;</td>
					<td align="right"><b>Address :</b></b></td><td><cfif hostaddress is ''>#hostaddress2#<cfelse>#hostaddress#</cfif></td>
					<td align="right"><b>State :</b></td><td>#schoolstate#</td>
				</tr>
				<tr>			
					<td align="left">&nbsp;</td>
					<td align="right"><b>City : </b></td><td>#hostcity#</td>
					<td align="right"><b>Zip :</b></td><td>#schoolzip#</td>			
				</tr>
				<tr>
					<td align="left">&nbsp;</td>			
					<td align="right"><b>State :</b></b></td><td>#hoststate#</td>
					<td align="right"><b>Program :</b></td><td>#programname#</td>						
				</tr>										
				<tr>			
					<td align="left">&nbsp;</td>			
					<td align="right"><b>ZIP Code :</b></b></td><td>#hostzip#</td>
					<td align="right">&nbsp;</td><td>&nbsp;</td>										 				
				</tr>	
				</table>
		</td></tr>
		</table>
		
		<cfif (recordcount is 1) or (current_record_count mod 6 is 0)>  <!--- last page --->
			<cfset pagenumber = #pagenumber#+1>
			<table width='650' align="center">
				<tr>
				<td align="left" width="200">#DateFormat(now(), 'mm/dd/yyyy')#</td>
				<td align="center">#CLIENT.DSFormName# Placement Report</td>
				<td align="right" width="200">Page #pagenumber#  of  #totalpages#</td></tr>
			</table>
			<div style="page-break-after:always;"></div>
			<br><br><br>
		</cfif>
		
		<cfif (current_record_count mod 6 is not 0) and (recordcount is current_record_count)>
			<cfset pagenumber = #pagenumber#+1>
			<table width='650' align="center">
				<tr>
				<td align="left" width="200">#DateFormat(now(), 'mm/dd/yyyy')#</td>
				<td align="center">#CLIENT.DSFormName# Placement Report</td>
				<td align="right" width="200">Page #pagenumber# of  #totalpages#</td></tr>
			</table>	
		</cfif>
	
	</cfoutput>
	</cfif>
	
</cfloop>
</div>