<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Flight Details</title>
</head>

<body>
<cfif isDefined('form.insert')>
	<cfquery datasource="#application.dsn#">
    update student_tours
    	set orig_airport = '#form.orig_airport#',
        	orig_flight = '#form.orig_flight#',
            dest_airport = '#form.dest_airport#',
            dest_flight = '#form.dest_flight#',
            arrivaltime = '#form.arrivaltime#',
            connection1 = '#form.connection1#',
            conflight1 = '#form.conflight1#',
            connection2 = '#form.connection2#',
            conflight2 = '#form.conflight2#',
            connection3 = '#form.connection3#',
            conflight3 = '#form.conflight3#',
            connection4 = '#form.connection4#',
            conflight4 = '#form.conflight4#',
            resCode = '#form.rescode#',
            flightInfo = #now()#
        where id = #url.id#
   </cfquery>
   <div align="center"><h3><font color="#085dad">Record Succesfully Updated!</font></div>
</cfif>
<cfform method="post" action="flights.cfm?id=#url.id#">
<cfquery name="flightDetails" datasource="#application.dsn#">
select *
from student_tours
where id = #url.id#
</cfquery>
<Cfoutput>
<table>
	<Tr>
    	<th colspan=4 align="left">Origination and Arrival Information - All Required</th>
    </Tr>
	<tr>
    	<Td>Origination Airport</Td><Td><cfinput type="text" name="orig_airport" message="Origination Airport is required.  " required="yes" size=10 value="#flightDetails.orig_airport#"/></Td><td>&nbsp;&nbsp;&nbsp;</td>
        <Td>Airline & Flight ( ie: DL1809 )</Td><td><cfinput type="text" name="orig_flight" message="Origination Airline &amp; Flight is required."  value="#flightDetails.orig_flight#" required="yes" /></td>
    </tr>
    <tr>
    	<Td>Destination Airport</Td><Td><cfinput type="text" name="dest_airport" message="Destination airport is required." value="#flightDetails.dest_airport#" required="yes" size=10/></Td><td>&nbsp;&nbsp;&nbsp;</td>
        <Td>Airline & Flight ( ie: DL1809 )</Td><td><cfinput type="text" name="dest_flight" value="#flightDetails.dest_flight#" message="Destination Airline &amp; Flight is required"  required="yes" /></td>
    </tr>
    <tr>    
        <td>Arrival Time</td><td><cfinput type="text" name="arrivaltime"  value="#flightDetails.arrivaltime#" message="Arrival Time is required" required="yes" size="10"/></td><td>&nbsp;&nbsp;&nbsp;</td>
        <td>Booking Ref</td><td><cfinput type="text" name="resCode" value="#flightDetails.resCode#" size="10"/>
    </tr>
    <tr>
    	<td colspan=5> <hr width=70% align="center" /></td>
    </tr>
	<Tr>
    	<th colspan=4 align="left">Connections - in order as they occur - All Optional</th>
	</tr>
    	<tr>
    	<Td>Connection Airport</Td><Td><input type="text" name="connection1" value="#flightDetails.connection1#" size=10/></Td><td>&nbsp;&nbsp;&nbsp;</td>
        <Td>Airline & Flight ( ie: DL1809 )</Td><td><input type="text" name="conflight1" value="#flightDetails.conflight1#" /></td>
    </tr>

    <tr>
    	<Td>Connection Airport</Td><Td><cfinput type="text" name="connection2" value="#flightDetails.connection2#" size=10/></Td><td>&nbsp;&nbsp;&nbsp;</td>
        <Td>Airline & Flight ( ie: DL1809 )</Td><td><input type="text" name="conflight2" value="#flightDetails.conflight2#" /></td>
    </tr>
    	<tr>
    	<Td>Connection Airport</Td><Td><cfinput type="text" name="connection3" value="#flightDetails.connection3#" size=10/></Td><td>&nbsp;&nbsp;&nbsp;</td>
        <Td>Airline & Flight ( ie: DL1809 )</Td><td><input type="text" name="conflight3" value="#flightDetails.conflight3#" /></td>
    </tr>
    <tr>
    	<Td>Connection Airport</Td><Td><cfinput type="text" name="connection4" value="#flightDetails.connection4#" size=10/></Td><td>&nbsp;&nbsp;&nbsp;</td>
        <Td>Airline & Flight ( ie: DL1809 )</Td><td><input type="text" name="conflight4" value="#flightDetails.conflight4#"/></td>
    </tr>

    <Tr>
    	<td colspan=5 align="Center"><br /><input type="image" src="../pics/submitBlue.png" /><input type="hidden" name="insert" /></td>
    </Tr>
    <Tr>
    	<Td colspan=5><font size=-1>Record Last Updated: <Cfif flightdetails.flightInfo is not ''>#dateformat(flightdetails.flightInfo,'mm/dd/yyyy')#<cfelse>Never</Cfif>
    </Tr>    
  </table>
  </cfoutput>
</cfform>
  
</body>
</html>