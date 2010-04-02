<cfsetting requesttimeout="20000" />
<table width=100%>
	<tr><td bgcolor="#e2efc7" colspan=2><span class="get_attention"><b>:: </b></span>XML Upload Results</td></tr>

	</table>

<cffile action="upload"
    destination="#AppPath.xmlFiles#flight_verification/"
    nameConflict="overwrite"
    fileField="form.flights"
	mode="777"
	accept="text/xml">


<cfset FlightXMLFile = XMLParse('#AppPath.xmlFiles#flight_verification/#file.serverfile#')>

<cfset numberofstudents = ArrayLen(#FlightXMLFile.FlightInfoCollection.FlightInfo#)>
<!----
<cfdump var='#FlightXMLFile#'>
---->
<cfoutput>
<cfset batchid = CreateUUID()>
Total Number of students flight info submitted: #numberofstudents#.<br><br>	<cfif not isDefined('form.display_results')> 
	Depending on the number of records you are inserting. This may take a few momments.  You will receive a message that says
	the process has completed. Please don't press reload or your browsers back button durring this time.<br>
	</cfif>
<cfloop from="1" to=#numberofstudents# index="i">


<cfquery name="get_studentid" datasource="mysql">
select studentid, firstname, familylastname, companyid, uniqueid
from smg_students
where soid = '#FlightXMLFile.flightinfocollection.flightinfo[i].XmlAttributes.studentid#'
</cfquery>
<cfif isDefined('form.display_results')>
#i# - <a class=nav_bar href="" onClick="javascript: win=window.open('intrep/int_flight_info.cfm?unqid=#get_studentid.uniqueid#', 'Settings', 'height=500, width=740, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">#FlightXMLFile.flightinfocollection.flightinfo[i].XmlAttributes.studentid#</a> 
</cfif><!----Put check for arrivals here---->

<cfif get_studentid.recordcount eq 0>
<cfif isDefined('form.display_results')>
<font color="##CC0000">Student is not currently in EXITS, no flight information updated/inserted.</font><br>
</cfif>
<cfelse>
<!----set number of segments of arrivals--->
			
			<cfif Len(FlightXMLFile.flightinfocollection.flightinfo[i].arrival) gt 200>
				<cfset numberflightsarrival = ArrayLen(#FlightXMLFile.flightinfocollection.flightinfo[i].arrival.flight#)>
				
			
				<cfquery name="check_for_current_arr" datasource="mysql">
				select studentid 
				from smg_flight_info
				where studentid = #get_studentid.studentid#
				and flight_type = 'arrival'
				</cfquery>
				<cfif check_for_current_arr.recordcount gt 0 and numberflightsarrival gt 0>
					<cfquery name="del_arr" datasource="mysql">
					delete from smg_flight_info
					where studentid = #check_for_current_arr.studentid#
					and flight_type="arrival"
					</cfquery>
				</cfif>
				<cfloop from=1 to=#numberflightsarrival# index="noflight">
						<cfset numbersegmentsarrival = ArrayLen(#FlightXMLFile.flightinfocollection.flightinfo[i].arrival.flight[noflight].segment#)>
					<cfloop from=1 to=#numbersegmentsarrival# index="noseg">
			
				<cfquery name="insert_arrival_info" datasource="mysql">
				insert into smg_flight_info (studentid, companyid, dep_date,dep_city,dep_aircode,dep_time,flight_number,
												arrival_city,arrival_aircode,arrival_time,overnight,flight_type,batchid,depdatetime)
							values(#get_studentid.studentid#, #get_studentid.companyid#, 
							'#FlightXMLFile.flightinfocollection.flightinfo[i].arrival.flight[noflight].segment[noseg].depart_date.xmltext#',
							'#FlightXMLFile.flightinfocollection.flightinfo[i].arrival.flight[noflight].segment[noseg].depart_airport.xmltext#',
							'#FlightXMLFile.flightinfocollection.flightinfo[i].arrival.flight[noflight].segment[noseg].depart_code.xmltext#',
							'#FlightXMLFile.flightinfocollection.flightinfo[i].arrival.flight[noflight].segment[noseg].depart_time.xmltext#',
							'#FlightXMLFile.flightinfocollection.flightinfo[i].arrival.flight[noflight].segment[noseg].flightnumber.xmltext#',
							'#FlightXMLFile.flightinfocollection.flightinfo[i].arrival.flight[noflight].segment[noseg].arrival_airport.xmltext#',
							'#FlightXMLFile.flightinfocollection.flightinfo[i].arrival.flight[noflight].segment[noseg].arrival_code.xmltext#',
							'#FlightXMLFile.flightinfocollection.flightinfo[i].arrival.flight[noflight].segment[noseg].arrival_time.xmltext#',
							<cfif #FlightXMLFile.flightinfocollection.flightinfo[i].arrival.flight[noflight].segment[noseg].overnight.xmltext# is 'false'>0<cfelse>1</cfif>,
							'arrival','#batchid#',
							'#FlightXMLFile.flightinfocollection.flightinfo[i].arrival.flight[noflight].segment[noseg].depart_date.xmltext# #FlightXMLFile.flightinfocollection.flightinfo[i].arrival.flight[noflight].segment[noseg].depart_time.xmltext#')
				</cfquery>
							
				</cfloop>
				</cfloop>
				<cfquery name="insert_remarks" datasource="mysql">
				update smg_students set flight_info_notes = '#FlightXMLFile.flightinfocollection.flightinfo[i].arrival.remarks.xmltext#'
				where studentid = #get_studentid.studentid#
				</cfquery>
				<cfif isDefined('form.display_results')>
				<font color="##009900">Arrival Information Received</font>
				</cfif>
				<cfelse>
				<cfif isDefined('form.display_results')>
				<font color="##FFCC33">No Arrival Information Submitted</font>
				</cfif>
			</cfif>
			

				<!----PUT CHECK FOR DEPARTURES HERE---->
			
			<cfif Len(FlightXMLFile.flightinfocollection.flightinfo[i].departure) gt 200>
				
				<cfset numberflightsdeparture = ArrayLen(#FlightXMLFile.flightinfocollection.flightinfo[i].departure.flight#)>
				
			
				<cfquery name="check_for_current_dep" datasource="mysql">
				select studentid 
				from smg_flight_info
				where studentid = #get_studentid.studentid#
				and flight_type = 'departure'
				</cfquery>
				<cfif check_for_current_dep.recordcount gt 0 and numberflightsdeparture gt 0>
					<cfquery name="del_arr" datasource="mysql">
					delete from smg_flight_info
					where studentid = #check_for_current_dep.studentid#
					and flight_type='departure'
					</cfquery>
				</cfif>
				<cfloop from=1 to=#numberflightsdeparture# index="nodepflight">
						<cfset numbersegmentsdeparture = ArrayLen(#FlightXMLFile.flightinfocollection.flightinfo[i].departure.flight[nodepflight].segment#)>
					<cfloop from=1 to=#numbersegmentsdeparture# index="nodepseg">
						
							<cfquery name="insert_departure_info" datasource="mysql">
							insert into smg_flight_info (studentid, companyid, dep_date,dep_city,dep_aircode,dep_time,flight_number,
															arrival_city,arrival_aircode,arrival_time,overnight,flight_type,batchid,depdatetime)
										values(#get_studentid.studentid#, #get_studentid.companyid#, 
										'#FlightXMLFile.flightinfocollection.flightinfo[i].departure.flight[nodepflight].segment[nodepseg].depart_date.xmltext#',
										'#FlightXMLFile.flightinfocollection.flightinfo[i].departure.flight[nodepflight].segment[nodepseg].depart_airport.xmltext#',
										'#FlightXMLFile.flightinfocollection.flightinfo[i].departure.flight[nodepflight].segment[nodepseg].depart_code.xmltext#',
										'#FlightXMLFile.flightinfocollection.flightinfo[i].departure.flight[nodepflight].segment[nodepseg].depart_time.xmltext#',
										'#FlightXMLFile.flightinfocollection.flightinfo[i].departure.flight[nodepflight].segment[nodepseg].flightnumber.xmltext#',
										'#FlightXMLFile.flightinfocollection.flightinfo[i].departure.flight[nodepflight].segment[nodepseg].arrival_airport.xmltext#',
										'#FlightXMLFile.flightinfocollection.flightinfo[i].departure.flight[nodepflight].segment[nodepseg].arrival_code.xmltext#',
										'#FlightXMLFile.flightinfocollection.flightinfo[i].departure.flight[nodepflight].segment[nodepseg].arrival_time.xmltext#',
										<cfif #FlightXMLFile.flightinfocollection.flightinfo[i].departure.flight[nodepflight].segment[nodepseg].overnight.xmltext# is 'false'>0<cfelse>1</cfif>,
										'departure','#batchid#',
										'#FlightXMLFile.flightinfocollection.flightinfo[i].departure.flight[nodepflight].segment[nodepseg].depart_datetime.xmltext#')
							</cfquery>
				
			
								
						</cfloop>
						
				</cfloop>
				<cfquery name="insert_remarks" datasource="mysql">
				update smg_students set flight_info_notes = '#FlightXMLFile.flightinfocollection.flightinfo[i].departure.remarks.xmltext#'
				where studentid = #get_studentid.studentid#
				</cfquery>
				<cfif isDefined('form.display_results')>
				<font color="##009900">Departure Information Received</font>
				</cfif>
				<cfelse>
				<cfif isDefined('form.display_results')>
				<font color="##FFCC33">No Departure Information Submitted</font>
				</cfif>
				</cfif>
	
			<cfif isDefined('form.display_results')><br></cfif><cfflush>
	</cfif>

</cfloop>

</cfoutput>
Script Ran and Finished Completely.
<cfif isDefined('form.receive_xml')>
<br>Generating XML results file as requested.  This may take a momment.  A link to the file will apear when the process is done.
Please don't press reload or your back button until the process is finished.<br>
	<cfinclude template="received_info_check_xml.cfm">
</cfif>
