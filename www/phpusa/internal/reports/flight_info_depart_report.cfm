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





<cfoutput>
<span class="application_section_header">Flight Departure Information</span><br>

<table width='100%' cellpadding=4 cellspacing="0" align="center" bgcolor="FFFFFF" frame="box">
	
		

	<tr><td class="style3"><b>Program(s) :</b> <cfloop query="get_program"><b>#programname# &nbsp; (#ProgramID#)</b><br></cfloop></td></tr>
</table><br>


	<cfquery name="get_students" datasource="MySql">
	SELECT 	s.studentid, s.firstname, s.familylastname, 
			pro.programname, p.programid
	FROM smg_students s 
	INNER JOIN php_students_in_program p ON s.studentid = p.studentid
    INNER JOIN smg_programs pro on pro.programid = p.programid
	INNER JOIN smg_flight_info f ON s.studentid = f.studentid
	WHERE s.active = 1 
		
		<cfif IsDefined('form.dates')>
		AND (f.dep_date between #CreateODBCDateTime(form.date1)# and #CreateODBCDateTime(form.date2)#) 
		</cfif>
		and f.flight_type = 'arrival'
		AND (<cfloop list=#form.programid# index='prog'>
			p.programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop> )
		
       	
	GROUP BY s.studentid
	ORDER BY s.firstname
	
	</cfquery>
	
	<cfif get_students.recordcount is '0'><cfelse>
		<table border="1" align="center" width='100%' bordercolor="C0C0C0" valign="top" cellpadding="3" cellspacing="1">
			<tr><td class="style3" colspan="2"> Total of #get_students.recordcount# student(s)</tr>
			<tr><th width="65%" align="left">Student</th></tr>
		</table><br>
		<cfloop query="get_students">
			<table border="1" align="center" width='100%' bordercolor="C0C0C0" valign="top" cellpadding="3" cellspacing="1">
					<tr>
					<td width="65%">#get_students.firstname# #get_students.familylastname# (#get_students.studentid#)</td>
					<td width="35%"></td></tr>
			</table>
						<table border="1" align="center" width='100%' bordercolor="C0C0C0" valign="top" cellpadding="3" cellspacing="1">
			<tr bgcolor="FDCEAC">
				<th>Date</th><th>Departure City</th><th>Airport Code</th><th>Arrival City</th><th>Airport Code</th>
				<th>Flight Number</th><th>Departure Time</th><th>Arrival Time</th><th>Overnight Flight</th></tr>
			<cfquery name="get_dep" datasource="MySql">
				SELECT flightid, studentid, dep_date, dep_city, dep_aircode, dep_time, flight_number, arrival_city, 
					arrival_aircode, arrival_time, overnight, flight_type
				FROM smg_flight_info
				WHERE studentid = '#get_students.studentid#' and flight_type = 'departure'
				ORDER BY dep_date, dep_time
			</cfquery>
			<cfloop query="get_dep">
				<tr bgcolor="FEE6D3">
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

</cfoutput>