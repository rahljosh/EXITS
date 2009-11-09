<cfinclude template="../querys/get_company_short.cfm">

<link rel="stylesheet" href="../profile.css" type="text/css">
<link rel="stylesheet" href="../reports.css" type="text/css">

<style type="text/css">
table.nav_bar { font-size: 10px; background-color: #ffffff; border: 1px solid #999999; }
.style3 {font-size: 13px}
</style>

<!--- Get Program --->
<cfquery name="get_program" datasource="MYSQL">
SELECT	*
FROM 	smg_programs 
LEFT JOIN smg_program_type ON type = programtypeid
WHERE 	(<cfloop list=#form.programid# index='prog'>
		programid = #prog# 
		<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
		</cfloop> )
</cfquery>

<!--- get company region --->
<cfquery name="get_region" datasource="MySQL">
	SELECT	regionname, company, regionid
	FROM smg_regions
	WHERE company = '#client.companyid#'
	<cfif form.regionid is 0><cfelse>
		AND regionid = '#form.regionid#'	
	</cfif>
	ORDER BY regionname
</cfquery>

<cfif client.usertype is '6'> <!--- advisors --->
	<cfquery name="get_users_under_adv" datasource="MySql">
	SELECT userid
	FROM smg_users
	WHERE advisor_id = '#client.userid#' and companyid like '%#client.companyid#%'
	</cfquery>

	<cfset ad_users = ValueList(get_users_under_adv.userid, ',')>
	<cfset ad_users = ListAppend(ad_users, #client.userid#)>
</cfif> <!--- advisors --->
<cfoutput>
<span class="application_section_header">#companyshort.companyshort# - Flight Arrival Information</span><br>

<table width='100%' cellpadding=4 cellspacing="0" align="center" bgcolor="FFFFFF" frame="box">
	
		

	<tr><td class="style3"><b>Program(s) :</b> <cfloop query="get_program"><b>#programname# &nbsp; (#ProgramID#)</b><br></cfloop></td></tr>
</table><br>

<cfloop query="get_region">
	<cfquery name="get_students" datasource="MySql">
	SELECT 	s.studentid, s.firstname, s.familylastname, s.arearepid,
			u.firstname as super_name, u.lastname as super_lastname,
			p.programname,
			r.regionname
	FROM smg_students s 
	INNER JOIN smg_programs p ON s.programid = p.programid
	INNER JOIN smg_flight_info f ON s.studentid = f.studentid
	INNER JOIN smg_regions r ON s.regionassigned = r.regionid
	LEFT JOIN smg_users u ON s.arearepid = u.userid
	WHERE s.active = 1 
		AND s.regionassigned = #get_region.regionid# 
		<cfif IsDefined('form.dates')>
		AND (f.dep_date between #CreateODBCDateTime(form.date1)# and #CreateODBCDateTime(form.date2)#) 
		</cfif>
		and f.flight_type = 'arrival'
		AND (<cfloop list=#form.programid# index='prog'>
			s.programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop> )
		<cfif client.usertype is '7'>
			AND (s.placerepid = '#client.userid#' or s.arearepid = '#client.userid#' )
		</cfif>
		<cfif client.usertype is '6'>
			AND ( s.placerepid = 
			<cfloop list="#ad_users#" index='i' delimiters = ",">
				'#i#' <cfif #ListLast(ad_users)# is #i#><cfelse> or s.placerepid = </cfif> </Cfloop>)
			AND ( s.arearepid = 
				<cfloop list="#ad_users#" index='i' delimiters = ",">
				'#i#' <cfif #ListLast(ad_users)# is #i#><cfelse> or s.arearepid = </cfif> </Cfloop>)	
		</cfif>				
	GROUP BY s.studentid
	ORDER BY r.regionname, u.lastname, s.firstname
	</cfquery>
	
	<cfif get_students.recordcount is '0'><cfelse>
		<table border="1" align="center" width='100%' bordercolor="C0C0C0" valign="top" cellpadding="3" cellspacing="1">
			<tr><td class="style3" colspan="2"><b>Region :</b> &nbsp; <i>#get_region.regionname#</i> &nbsp; &nbsp; &nbsp; &nbsp; Total of #get_students.recordcount# student(s)</tr>
			<tr><th width="65%" align="left">Student</th><th width="35%" align="left">Supervising Rep</th></tr>
		</table><br>
		<cfloop query="get_students">
			<table border="1" align="center" width='100%' bordercolor="C0C0C0" valign="top" cellpadding="3" cellspacing="1">
					<tr>
					<td width="65%">#get_students.firstname# #get_students.familylastname# (#get_students.studentid#)</td>
					<td width="35%">#get_students.super_name# #get_students.super_lastname# &nbsp;</td></tr>
			</table>
			<table border="1" align="center" width='100%' bordercolor="C0C0C0" valign="top" cellpadding="3" cellspacing="1">
			<tr bgcolor="ACB9CD">
				<th>Date</th><th>Departure City</th><th>Airport Code</th><th>Arrival City</th><th>Airport Code</th>
				<th>Flight Number</th><th>Departure Time</th><th>Arrival Time</th><th>Overnight Flight</th></tr>
			<cfquery name="get_arrival" datasource="MySql">
				SELECT flightid, studentid, dep_date, dep_city, dep_aircode, dep_time, flight_number, arrival_city, 
						arrival_aircode, arrival_time, overnight, flight_type
				FROM smg_flight_info
				WHERE studentid = '#get_students.studentid#' and flight_type = 'arrival'
				ORDER BY dep_date, dep_time
			</cfquery>
			<cfloop query="get_arrival">
				<tr bgcolor="D5DCE5">
				<td align="center">#DateFormat(dep_date , 'mm/dd/yyyy')#&nbsp;</td>
				<td align="center">#dep_city#&nbsp;</td>
				<td align="center">#dep_aircode#&nbsp;</td>
				<td align="center">#arrival_city#&nbsp;</td>
				<td align="center">#arrival_aircode#&nbsp;</td>
				<td align="center">#flight_number#&nbsp;</td>
				<td align="center">#TimeFormat(dep_time, 'hh:mm tt')#&nbsp;</td>
				<td align="center">#TimeFormat(arrival_time, 'h:mm tt')#&nbsp;</td>
				<td align="center">
					 <cfif overnight is 0><cfset chk =''><cfelse><cfset chk ='checked'></cfif>
					<input type="checkbox" name="ar_overnight#get_arrival.currentrow#" value="#overnight#" #chk# readonly="yes"></input></td>
				</tr>
				<cfif overnight is 1>
				<tr bgcolor="D5DCE5"><td colspan="9" align="center">Please note arrival time is the next day due to an overnight flight.</td></tr>
				</cfif>	
			</cfloop> <!--- arrival --->
			</table><br>
		</cfloop> <!--- student --->
	</cfif>
</cfloop> <!--- region --->
</cfoutput>