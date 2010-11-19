<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>DOS - DS 2019 Report - EXCEL SPREADSHEET</title>
<link rel="stylesheet" href="reports.css" type="text/css">
</head>

<body>

<!--- use cfsetting to block output of HTML outside of cfoutput tags --->
<cfsetting enablecfoutputonly="Yes">

<cfsetting requestTimeOut = "400">

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<!--- get Students  --->
<Cfquery name="get_students" datasource="MySQL">
	SELECT 
		s.studentid, s.firstname, s.familylastname, s.programid, s.ds2019_no, s.regionassigned, s.dateplaced, s.intrep, s.companyid,
		s.placerepid, s.arearepid, s.hostid, s.schoolid, s.programid, s.welcome_family, s.sevis_activated,
		p.programname,
		h.familylastname as hostfamily, h.fatherfirstname, h.fatherlastname, h.motherfirstname, h.motherlastname, 
		h.address as hostaddress, h.address2 as hostaddress2, h.city as hostcity, h.state as hoststate, h.zip as hostzip,
		sch.schoolname, sch.address as schooladdress, sch.address2 as schooladdress2,
		sch.city as schoolcity, sch.state as schoolstate, sch.zip as schoolzip,
		place.firstname as place_firstname, place.lastname as place_lastname,
		area.firstname as area_firstname, area.lastname as area_lastname,
		comp.iap_auth,
		country.countryname
	FROM smg_students s 
	INNER JOIN smg_programs p ON s.programid = p.programid
	INNER JOIN smg_companies comp ON s.companyid = comp.companyid
	INNER JOIN smg_countrylist country ON s.countryresident = country.countryid
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
            s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,12" list="yes"> )
    <cfelse>
        AND	
            s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
    </cfif>
	ORDER BY 
    	s.familylastname
</cfquery>

<cfoutput>

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

<!--- set content type --->
<cfcontent type="application/msexcel">

<!--- suggest default name for XLS file --->
<!--- "Content-Disposition" in cfheader also ensures relatively correct Internet Explorer behavior. --->
<cfheader name="Content-Disposition" value="attachment; filename=DOS-Placement-Report.xls"> 

<table border="1" cellpadding="3" cellspacing="0">
	<tr><td colspan="23"><b>DEPARTMENT OF STATE BIANNUAL PLACEMENT REPORT</b></td></tr>
	<tr>
		<th>Program Number</th>
		<th>Program Name</th>
		<th>Participant's <br /> Last Name</th>
		<th>Participant's <br /> First Name</th>
		<th>Home Country</th>
		<th>SEVIS ID##</th>
		<th>SEVIS Status <br /> (if not Active)</th>
		<th>Host Father <br /> Last Name</th>
		<th>Host Father <br /> First Name</th>
		<th>Host Mother <br /> Last Name (if different)</th>
		<th>Host Mother <br /> First Name</th>
		<th>Welcome or Permanent <br /> Family?</th>
		<th>Street Address</th>
		<th>City</th>
		<th>State</th>
		<th>ZIP</th>
		<th>School Name</th>
		<th>Street Address</th>
		<th>City</th>
		<th>State</th>
		<th>ZIP</th>
		<th>Name of Local <br /> Coordinator</th>
		<th>Remarks</th>
	</tr>
	<cfloop query="get_students">
		<tr>
			<td align="center">#iap_auth#</td>
			<td>#companyshort.companyname#</td>
			<td>#familylastname#</td>
			<td>#firstname#</td>
			<td>#countryname#</td>
			<td align="center">#ds2019_no#</td>
			<td><cfif sevis_activated EQ 0>Initial<cfelse>&nbsp;</cfif></td>
			<td>#fatherlastname#</td>
			<td>#fatherfirstname#</td>
			<td><cfif motherlastname NEQ fatherlastname>#motherlastname#</cfif></td>
			<td>#motherfirstname#</td>
			<td align="center"><cfif welcome_family EQ 1>Welcome<cfelse>Permanent</cfif></td>
			<td><cfif hostaddress EQ ''>#hostaddress2#<cfelse>#hostaddress#</cfif></td>
			<td>#hostcity#</td>
			<td align="center">#hoststate#</td>
			<td>#hostzip#</td>
			<td>#schoolname#</td>
			<td><cfif schooladdress EQ ''>#schooladdress2#<cfelse>#schooladdress#</cfif></td>
			<td>#schoolcity#</td>
			<td align="center">#schoolstate#</td>
			<td>#schoolzip#</td>
			<td>#area_firstname# #area_lastname#</td>
			<td>&nbsp;</td>
		</tr>		
		<!--- CREATE NEW HISTORY --->
		<cfquery name="create_history" datasource="MySql">
			INSERT INTO smg_csiet_history
				(companyid, datecreated, timecreated, csietid, studentid, hostid, welcome_family, host_lastname, host_address, host_city, host_state, host_zip, 
				schoolid, school_name, school_address, school_city, school_state, school_zip, programid, regionid, placement_date,
				placerepid,  place_firstname, place_lastname, arearepid, area_firstname, area_lastname, sevis_initial)
			VALUES
				('#companyid#', #CreateODBCDateTime(todaydate)#, #CreateODBCTime(todaydate)#, '#currentrow#', '#studentid#', '#hostid#', 
				'#welcome_family#', '#hostfamily#', '<cfif hostaddress EQ ''>#hostaddress2#<cfelse>#hostaddress#</cfif>', '#hostcity#', 
				'#hoststate#', '#hostzip#', '#schoolid#', '#schoolname#', '<cfif schooladdress EQ ''>#schooladdress2#<cfelse>#schooladdress#</cfif>',
				'#schoolcity#', '#schoolstate#', '#schoolzip#', '#programid#', '#regionassigned#', 
				<cfif dateplaced EQ ''>NULL<cfelse>#CreateODBCDate(dateplaced)#</cfif>, '#placerepid#', '#place_firstname#', '#place_lastname#',
				'#arearepid#', '#area_firstname#', '#area_lastname#', <cfif sevis_activated NEQ 0>1<cfelse>0</cfif>)
		</cfquery>
	</cfloop>
</table>

</cfoutput>

</body>
</html>