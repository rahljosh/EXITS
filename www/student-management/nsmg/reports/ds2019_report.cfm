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

<cfsetting requestTimeOut = "400">

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<!--- get Students  --->
<Cfquery name="get_students" datasource="MySQL">
	SELECT 
		s.studentid, s.firstname, s.familylastname, s.programid, s.ds2019_no, s.regionassigned, s.dateplaced, s.intrep, s.companyid,
		s.placerepid, s.arearepid, s.hostid, s.schoolid, s.programid,
		p.programname,
		h.familylastname as hostfamily, h.address as hostaddress, h.address2 as hostaddress2, 
		h.city as hostcity, h.state as hoststate, h.zip as hostzip,
		sch.schoolname, sch.address as schooladdress, sch.address2 as schooladdress2,
		sch.city as schoolcity, sch.state as schoolstate, sch.zip as schoolzip,
		place.firstname as place_firstname, place.lastname as place_lastname,
		area.firstname as area_firstname, area.lastname as area_lastname
	FROM smg_students s 
	INNER JOIN smg_programs p ON s.programid = p.programid
	LEFT JOIN smg_hosts h ON s.hostid = h.hostid		
	LEFT JOIN smg_schools sch ON s.schoolid = sch.schoolid
	LEFT JOIN smg_users place ON s.placerepid = place.userid
	LEFT JOIN smg_users area ON s.arearepid = area.userid
	WHERE 
    	s.active = '1' 
	AND 
    	s.ds2019_no LIKE 'N%'
    AND	
        s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> )
    <cfif CLIENT.companyID EQ 5>
        AND	
            s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="$APPLICATION.SETTINGS.COMPANYLIST.ISE$" list="yes"> )
    <cfelse>
        AND	
            s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
    </cfif>
	ORDER BY 
    	s.familylastname
</cfquery>

<div style="section1">

<cfoutput>
<table width="650" align="center" border=0 bgcolor="FFFFFF">
	<tr>
		<td width="50">&nbsp;</td>
		<td><img src="../pics/logos/#client.companyid#.gif"  alt="" border="0" align="left"></td>
		<td valign="middle" align="left"><font size="+3"><b>DS 2019 Placement Report</b></font></td>		
	</tr>
	<tr><td colspan="3"><hr width=100% align="center"></td></tr>
</table>

<cfif get_students.recordcount mod 6 is 0>
	<cfset totalpages = get_students.recordcount \ 6>
<cfelse>	
	<cfset totalpages = get_students.recordcount \ 6>
	<cfset totalpages = totalpages + 1>
</cfif>

<cfset pagenumber = 0>

<cfquery name="check_history" datasource="MySql">
	SELECT DISTINCT companyid, datecreated
	FROM smg_csiet_history
	WHERE companyid = '#client.companyid#'
	ORDER BY datecreated DESC
</cfquery>

<!--- HISTORY FILE ---->
<cfset todaydate = #now()#>
<cfif check_history.datecreated EQ DateFormat(todaydate, 'yyyy-mm-dd')>
	<!--- DELETE HISTORY FROM THE SAME DAY --->
	<cfquery name="delete" datasource="MySql">
		DELETE
		FROM smg_csiet_history
		WHERE companyid = '#client.companyid#'
			AND datecreated = '#DateFormat(todaydate, 'yyyy-mm-dd')#'
	</cfquery>
</cfif>

<cfloop query="get_students">
	<table width='650' cellpadding=6 cellspacing="0" align="center" frame="below" border="1">
	<tr><td>
			<table>
			<tr>
				<td align="left" width="30">#currentrow#</td>
				<td align="right" width="110"><b>First Name :</b></td><td width="180">#firstname#</td>
				<td align="right" width="110"><b>Host Family :</b></td><td width="220">#hostfamily#</td>
			</tr>
			<tr>
				<td align="left">&nbsp;</td>
				<td align="right"><b>Last Name :</b></td><td>#familylastname#</td>
				<td align="right"><b>School Name :</b></td><td>#schoolname#</td>			
			</tr>
			<tr>
				<td align="left">&nbsp;</td>
				<td align="right"><b>DS 2019 Number :</b></td><td>#ds2019_no#</td>
				<td align="right"><b>Address :</b></td><td><cfif schooladdress EQ ''>#schooladdress2#<cfelse>#schooladdress#</cfif></td>			
			</tr>
			<tr>
				<td align="left">&nbsp;</td>
				<td align="right"><b>Address :</b></b></td><td><cfif hostaddress EQ ''>#hostaddress2#<cfelse>#hostaddress#</cfif></td>
				<td align="right"><b>City :</b></td><td>#schoolcity#</td>
			</tr>
			<tr>			
				<td align="left">&nbsp;</td>
				<td align="right"><b>City : </b></td><td>#hostcity#</td>
				<td align="right"><b>State :</b></td><td>#schoolstate#</td>			
			</tr>
			<tr>
				<td align="left">&nbsp;</td>			
				<td align="right"><b>State :</b></b></td><td>#hoststate#</td>
				<td align="right"><b>Zip :</b></td><td>#schoolzip#</td>						
			</tr>										
			<tr>			
				<td align="left">&nbsp;</td>			
				<td align="right"><b>ZIP Code :</b></b></td><td>#hostzip#</td>
				<td align="right"><b>Program :</b></td><td>#programname#</td>										 				
			</tr>	
			</table>
	</td></tr>
	</table>
	
	<cfif (recordcount is 1) or (currentrow mod 6 is 0)> 
		<cfset pagenumber = #pagenumber#+1>
		<table width='650' align="center">
			<tr>
			<td align="left" width="200"><!--- #DateFormat(now(), 'mm/dd/yyyy')# --->01/15/2007</td>
			<td align="center">DS 2019 Placement Report</td>
			<td align="right" width="200">Page #pagenumber#  of  #totalpages#</td></tr>
		</table>
		<div style="page-break-after:always;"></div>
		<br><br><br>
	</cfif>
	
	<cfif (recordcount mod 6 is not 0) and (recordcount is currentrow)>
		<cfset pagenumber = #pagenumber#+1>
		<table width='650' align="center">
			<tr>
			<td align="left" width="200"><!--- #DateFormat(now(), 'mm/dd/yyyy')# --->01/15/2007</td>
			<td align="center">DS 2019 Placement Report</td>
			<td align="right" width="200">Page #pagenumber# of  #totalpages#</td></tr>
		</table>	
	</cfif>

	<!--- CREATE NEW HISTORY --->
	<cfquery name="create_history" datasource="MySql">
		INSERT INTO smg_csiet_history
			(companyid, datecreated, timecreated, csietid, studentid,	hostid, host_lastname, host_address, host_city, host_state, host_zip, 
			schoolid, school_name, school_address, school_city, school_state, school_zip, programid, regionid, placement_date,
			placerepid,  place_firstname, place_lastname, arearepid, area_firstname, area_lastname)
		VALUES
			('#companyid#', #CreateODBCDateTime(todaydate)#, #CreateODBCTime(todaydate)#, '#currentrow#', '#studentid#', '#hostid#', '#hostfamily#', 
			'<cfif hostaddress EQ ''>#hostaddress2#<cfelse>#hostaddress#</cfif>', '#hostcity#', '#hoststate#', '#hostzip#', '#schoolid#', 
			'#schoolname#', '<cfif schooladdress EQ ''>#schooladdress2#<cfelse>#schooladdress#</cfif>',
			'#schoolcity#', '#schoolstate#', '#schoolzip#', '#programid#', '#regionassigned#', 
			<cfif dateplaced EQ ''>NULL<cfelse>#CreateODBCDate(dateplaced)#</cfif>, '#placerepid#', '#place_firstname#', '#place_lastname#',
			'#arearepid#', '#area_firstname#', '#area_lastname#')
	</cfquery>

</cfloop>

</cfoutput>
</div>