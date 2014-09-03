<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>DOS - #CLIENT.DSFormName# Report - EXCEL SPREADSHEET</title>
<link rel="stylesheet" href="reports.css" type="text/css">
</head>

<body>

<!--- use cfsetting to block output of HTML outside of cfoutput tags --->
<cfsetting enablecfoutputonly="Yes">

<cfsetting requestTimeOut = "400">

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">



<!--- get Students  --->
<Cfquery name="qGetStudentList" datasource="MySQL">
	SELECT 
		s.studentid, s.firstname, s.familylastname, s.programid, s.ds2019_no, s.regionassigned, s.dateplaced, s.intrep, s.companyid,
		s.placerepid, s.arearepid, s.hostid, s.schoolid, s.programid, s.isWelcomeFamily, s.sevis_activated,
		p.programname, p.type as programType,
		h.familylastname as hostfamily, h.fatherfirstname, h.fatherlastname, h.motherfirstname, h.motherlastname, 
		h.address as hostaddress, h.address2 as hostaddress2, h.city as hostcity, h.state as hoststate, h.zip as hostzip,
		sch.schoolname, sch.address as schooladdress, sch.address2 as schooladdress2,
		sch.city as schoolcity, sch.state as schoolstate, sch.zip as schoolzip,
		place.firstname as place_firstname, place.lastname as place_lastname,
		area.firstname as area_firstname, area.lastname as area_lastname, area.zip as area_zip,
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
            s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISE#" list="yes"> )
    <cfelse>
        AND	
            s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
    </cfif>
	ORDER BY 
    	s.familylastname
</cfquery>

<cfoutput>

<!--- DELETE HISTORY FROM THE SAME DAY --->
<cfquery name="delete" datasource="MySql">
	DELETE FROM 
    	smg_csiet_history
	WHERE 
    	date(datecreated) = <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(now(), 'yyyy-mm-dd')#">
    <cfif CLIENT.companyID EQ 5>
        AND	
            companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISE#" list="yes"> )
    <cfelse>
        AND	
            companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
    </cfif>
	
</cfquery>   

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
        <th>Length of Program</th>
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
		<th>First Name of Local <br /> Coordinator</th>
        <th>Last Name of Local <br /> Coordinator</th>
        <th>Local Coordinator Zip</th>
		<th>Remarks</th>
      
	</tr>
	<cfloop query="qGetStudentList">
		<tr>
			<td align="center">#qGetStudentList.iap_auth#</td>
			<td>#companyshort.companyname#</td>
			<td>#qGetStudentList.familylastname#</td>
			<td>#qGetStudentList.firstname#</td>
			<td>#qGetStudentList.countryname#</td>
			<td align="center">#qGetStudentList.ds2019_no#</td>
			<td><cfif qGetStudentList.sevis_activated EQ 0>Initial<cfelse>&nbsp;</cfif></td>
            <td><cfif qGetStudentList.programType eq 1>Academic Year<cfelse>Semester</cfif></td>
			<td>#qGetStudentList.fatherlastname#</td>
			<td>#qGetStudentList.fatherfirstname#</td>
			<td><cfif qGetStudentList.motherlastname NEQ qGetStudentList.fatherlastname>#qGetStudentList.motherlastname#</cfif></td>
			<td>#qGetStudentList.motherfirstname#</td>
			<td align="center"><cfif qGetStudentList.isWelcomeFamily EQ 1>Welcome<cfelse>Permanent</cfif></td>
			<td><cfif qGetStudentList.hostaddress EQ ''>#qGetStudentList.hostaddress2#<cfelse>#qGetStudentList.hostaddress#</cfif></td>
			<td>#qGetStudentList.hostcity#</td>
			<td align="center">#qGetStudentList.hoststate#</td>
			<td>#qGetStudentList.hostzip#</td>
			<td>#qGetStudentList.schoolname#</td>
			<td><cfif qGetStudentList.schooladdress EQ ''>#qGetStudentList.schooladdress2#<cfelse>#qGetStudentList.schooladdress#</cfif></td>
			<td>#qGetStudentList.schoolcity#</td>
			<td align="center">#qGetStudentList.schoolstate#</td>
			<td>#qGetStudentList.schoolzip#</td>
			<td>#qGetStudentList.area_firstname#</td>
            <td>#qGetStudentList.area_lastname#</td>
            <td>#qGetStudentList.area_zip#</td>
			<td>&nbsp;</td>
            
		</tr>	
        
        <cfset vGetTimeStamp = now()>
        	
		<!--- CREATE NEW HISTORY --->
		<cfquery name="create_history" datasource="MySql">
			INSERT INTO smg_csiet_history
				(companyid, datecreated, csietid, studentid, hostid, isWelcomeFamily, host_lastname, host_address, host_city, host_state, host_zip, 
				schoolid, school_name, school_address, school_city, school_state, school_zip, programid, regionid, placement_date,
				placerepid,  place_firstname, place_lastname, arearepid, area_firstname, area_lastname, sevis_initial)
			VALUES
				('#companyid#', <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vGetTimeStamp#">, '#currentrow#', '#studentid#', '#hostid#', 
				'#isWelcomeFamily#', '#hostfamily#', '<cfif hostaddress EQ ''>#hostaddress2#<cfelse>#hostaddress#</cfif>', '#hostcity#', 
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