
<cfquery name="get_id_for_flight" datasource="mysql">
select distinct flight.studentid, smg_students.soid
from smg_flight_info flight
left join smg_students on smg_students.studentid = flight.studentid
where flight.batchid = '#batchid#'
limit 50
</cfquery>
<!---- Create an XML document object containing the data ---->
<cfxml variable="submitted_fight_info">
<cfoutput>
<FlightInfoCollection>
<cfloop query=get_id_for_flight>
<FlightInfo studentid="#get_id_for_flight.soid#" so="INTO-DE" ro="SMG" soid="1" roid="1362">
		<!----get arrival informaiton for student---->
		<cfquery name="arrival_info" datasource="mysql">
		select * 
		from smg_flight_info
		where studentid =#studentid#
		and flight_type = 'arrival'
		order by depdatetime
		</cfquery>
	<arrival>
		<flight>
		<cfloop query="arrival_info">
			<segment>
				<depart_date>#DateFormat(dep_date,'yyyy-mm-dd')#</depart_date>
				<depart_time>#TimeFormat(dep_time, 'HH:mm')#</depart_time>
				<depart_datetime>#depdatetime#</depart_datetime>
				<depart_airport>#dep_city#</depart_airport>
				<depart_code>#dep_aircode#</depart_code>
				<arrival_time>#TimeFormat(arrival_time, 'HH:mm')#</arrival_time>
				<arrival_airport>#arrival_city#</arrival_airport>
				<arrival_code>#arrival_aircode#</arrival_code>
				<flightnumber>#flight_number#</flightnumber>
				<overnight><cfif overnight is 0>false<cfelse>true</cfif></overnight>
			</segment>
		</cfloop>
		</flight>
	</arrival>
	<!----Get Departure Info for student---->
		<cfquery name="departure_info" datasource="mysql">
		select * 
		from smg_flight_info
		where studentid =#studentid#
		and flight_type = 'departure'
		order by depdatetime
		</cfquery>
	<departure>
		<flight>
	<cfloop query="departure_info">
			<segment>
				<depart_date>#DateFormat(dep_date,'yyyy-mm-dd')#</depart_date>
				<depart_time>#TimeFormat(dep_time, 'HH:mm')#</depart_time>
				<depart_datetime>#TimeFormat(depdatetime, 'HH:mm')# #TimeFormat(dep_time, 'HH:mm')#</depart_datetime>
				<depart_airport>#dep_city#</depart_airport>
				<depart_code>#dep_aircode#</depart_code>
				<arrival_time>#TimeFormat(arrival_time, 'HH:mm')#</arrival_time>
				<arrival_airport>#arrival_city#</arrival_airport>
				<arrival_code>#arrival_aircode#</arrival_code>
				<flightnumber>#flight_number#</flightnumber>
				<overnight><cfif overnight is 0>false<cfelse>true</cfif></overnight>
			</segment>
		</cfloop>
		</flight>
	</departure>
	</FlightInfo>
</cfloop>
</FlightInfoCollection>
</cfoutput>
</cfxml>


<cfoutput>
<cffile action="write" file="#AppPath.xmlFiles#flight_verification/#batchid#.xml" output="#toString(submitted_fight_info)#">
<br>
<a href="http://www.student-management.com/nsmg/uploadedfiles/xml_files/flight_verification/#batchid#.xml">Results in an XML File</a>
</cfoutput>
