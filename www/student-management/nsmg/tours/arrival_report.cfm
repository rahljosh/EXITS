<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Departure Report</title>
</head>

<body>
<cfquery name="tour_info" datasource="#application.dsn#">
select tour_name
from smg_tours
where tour_id = #url.tripid#
</cfquery>

<cfquery name="flight_report" datasource="#application.dsn#">
select st.studentid, st.orig_airport, st.dest_flight, st.dest_airport, st.arrivaltime, st.connection1, st.conflight1, st.connection2, st.conflight2, st.connection3, st.conflight3, st.connection4, st.conflight4, s.firstname, s.familylastname
from student_tours st
left join smg_students s on s.studentid = st.studentid
where tripid = #url.tripid#
order by dest_airport, arrivaltime, dest_flight
</cfquery>

<cfcontent type="application/msexcel">

<!--- suggest default name for XLS file --->
<!--- "Content-Disposition" in cfheader also ensures 
relatively correct Internet Explorer behavior. --->
<cfheader name="Content-Disposition" value="attachment; filename=arrival_report.xls"> 
<cfoutput>

<Table>
	<tr>
    	<Th colspan=7>#tour_info.tour_name# - Arrivals as of #DateFormat(now(), 'mmm d, yyyy')#</Th>
    </tr>
	<tr>
    	<td>Room##</td><td>Last Name</td><td>First Name</td><td>City</td><td>Flight</td><td>Arrival Time</td><td>Conn</td><td>Airport</td>
    <tr>
    <cfset current_flight = ''>
    <cfloop query="flight_report">
        <Cfif dest_flight neq current_flight>
            <cfset skiprow = 1>
            <cfset current_flight = dest_flight>
        <cfelse>
            <cfset skiprow=0>
        </Cfif>
        <tr>
            <td></td><Td>#familylastname#</Td><Td>#firstname#</td><td>#orig_airport#</<td>#dest_flight#</td><td>#arrivaltime#</td><td>#dest_airport#</td>
        </tr>
        <cfif skiprow eq 1>
        <tr>
            <td></td><Td></Td><Td></td><td></td><td></td><td></td>
        </tr>
        </cfif>
    </cfloop>
 </table>
 </cfoutput>
</body>
</html>