<cfsetting requesttimeout="20000" />

<cfparam name="FORM.displayResults" default="0">
<cfparam name="FORM.receiveXML" default="0">

<script language="javascript">	
    // Document Ready!
    $(document).ready(function() {

		// JQuery Modal
		$(".jQueryModal").colorbox( {
			width:"60%", 
			height:"90%", 
			iframe:true,
			overlayClose:false,
			escKey:false 
		});		

	});
</script>  

<table width=100%>
	<tr><td bgcolor="#e2efc7" colspan=2><span class="get_attention"><b>:: </b></span>XML Upload Results</td></tr>
</table>

<cffile action="upload"
    destination="#APPLICATION.PATH.xmlFiles#flight_verification/"
    nameConflict="overwrite"
    fileField="FORM.flights"
	mode="777"
	accept="text/xml">

<cfscript>
	// Set to 1 to send email to facilitators
	setSendEmail = 0;

	setBatchID = CreateUUID();
	
	FlightXMLFile = XMLParse('#AppPath.xmlFiles#flight_verification/#file.serverfile#');

	setNumberOfStudents = ArrayLen(FlightXMLFile.FlightInfoCollection.FlightInfo);
	
	// writedump(FlightXMLFile); abort;
</cfscript>

<cfoutput>

    <p>Total Number of students flight info submitted: #setNumberOfStudents#.</p>
    
    <cfif VAL(FORM.displayResults)> 
        <p>
        	Depending on the number of records you are inserting. This may take a few momments.  You will receive a message that says
	        the process has completed. Please don't press reload or your browsers back button durring this time.
        </p>	
    </cfif>
    
    <cfloop from="1" to="#setNumberOfStudents#" index="i">
       
        <cfscript>
            // Get Student Information
            qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentByID(soID=FlightXMLFile.flightinfocollection.flightinfo[i].XmlAttributes.studentID);
			
			// Check if it's an Active PHP Student
			qGetPHPStudentInfo = APPLICATION.CFC.STUDENT.getPHPStudent(studentID=qGetStudentInfo.studentID);
			
			if ( qGetPHPStudentInfo.recordCount EQ 1 ) {
				// Use PHP Data Instead
				qGetStudentInfo = qGetPHPStudentInfo;
			}
        </cfscript>
                
        <cfif VAL(FORM.displayResults)>
            &nbsp; #i# 
            <a href="student/index.cfm?action=flightInformation&uniqueID=#qGetStudentInfo.uniqueID#" class="jQueryModal">
            	#FlightXMLFile.flightinfocollection.flightinfo[i].XmlAttributes.studentID#
            </a> 
            - #qGetStudentInfo.firstName# #qGetStudentInfo.familyLastName# ###qGetStudentInfo.studentID#
        </cfif>
        
        <!---- CHECK FOR FLIGHT ---->
        <cfif NOT VAL(qGetStudentInfo.recordcount)>
        
            <p style="color:##CC0000">Student is not currently in EXITS, no flight information updated/inserted.</p>
        
        <cfelseif qGetStudentInfo.intRep NEQ CLIENT.userID>

            <p style="color:##CC0000">Student is not assigned to the company you are currently logged in to. Flight information has not been updated.</p>

        <cfelse>
            
            <!---- FLIGHT ARRIVAL ---->
            <cfif Len(FlightXMLFile.flightinfocollection.flightinfo[i].arrival) GT 200>
                
                <cfscript>
                    // set number of segments of arrivals
                    setNumberFlightArrival = ArrayLen(FlightXMLFile.flightinfocollection.flightinfo[i].arrival.flight);
                    
                    // Delete current flight information
                    if ( VAL(setNumberFlightArrival) ) {
                        
                        APPLICATION.CFC.STUDENT.deleteCompleteFlightInformation(studentID=qGetStudentInfo.studentID, programID=qGetStudentInfo.programID, flightType='arrival', enteredByID=CLIENT.userID);
                        
                    }
                </cfscript>
                
                <!--- Loop Segments --->
                <cfloop from="1" to="#setNumberFlightArrival#" index="noflight">
                    
                    <cfscript>
                        setNumberSegmentArrival = ArrayLen(FlightXMLFile.flightinfocollection.flightinfo[i].arrival.flight[noflight].segment);
                        
                        setSendEmail = 1;
                    </cfscript>
                    
                    <!--- Loop Flight Legs --->
                    <cfloop from="1" to="#setNumberSegmentArrival#" index="noseg">
                        
                        <cfscript>
                            // Insert Flight
                            APPLICATION.CFC.STUDENT.insertFlightInfo(
                                studentID=qGetStudentInfo.studentID,
                                companyID=qGetStudentInfo.companyID,
                                programID=qGetStudentInfo.programID,
                                enteredByID=CLIENT.userID,
                                batchID=setBatchID,
                                flightNumber=FlightXMLFile.flightinfocollection.flightinfo[i].arrival.flight[noflight].segment[noseg].flightnumber.xmltext,
                                depCity=FlightXMLFile.flightinfocollection.flightinfo[i].arrival.flight[noflight].segment[noseg].depart_airport.xmltext,
                                depAirCode=FlightXMLFile.flightinfocollection.flightinfo[i].arrival.flight[noflight].segment[noseg].depart_code.xmltext,
                                depDate=FlightXMLFile.flightinfocollection.flightinfo[i].arrival.flight[noflight].segment[noseg].depart_date.xmltext,
                                depTime=FlightXMLFile.flightinfocollection.flightinfo[i].arrival.flight[noflight].segment[noseg].depart_time.xmltext,
                                arrivalCity=FlightXMLFile.flightinfocollection.flightinfo[i].arrival.flight[noflight].segment[noseg].arrival_airport.xmltext,
                                arrivalAirCode=FlightXMLFile.flightinfocollection.flightinfo[i].arrival.flight[noflight].segment[noseg].arrival_code.xmltext,
                                arrivalTime=FlightXMLFile.flightinfocollection.flightinfo[i].arrival.flight[noflight].segment[noseg].arrival_time.xmltext,
                                overNight=VAL(FlightXMLFile.flightinfocollection.flightinfo[i].arrival.flight[noflight].segment[noseg].overnight.xmltext),
                                flightType='arrival'
                            );
                        </cfscript>
                        
                    </cfloop>
                    
                </cfloop>
    
                <cfscript>
                    // Update Flight Notes
                    APPLICATION.CFC.STUDENT.updateFlightNotes(studentID=qGetStudentInfo.studentID, flightNotes=FlightXMLFile.flightinfocollection.flightinfo[i].arrival.remarks.xmltext);
                </cfscript>
                    
                <cfif VAL(FORM.displayResults)>
                    <font color="##009900"> &nbsp; | &nbsp;  Arrival Information Received</font>
                </cfif>
    
            <cfelse>
    
                <cfif VAL(FORM.displayResults)>
                    <font color="##FFCC33"> &nbsp; | &nbsp;  No Arrival Information Submitted</font>
                </cfif>
                    
            </cfif>
    
    
            <!---- FLIGHT DEPARTURE ---->
            <cfif Len(FlightXMLFile.flightinfocollection.flightinfo[i].departure) gt 200>
            
                <cfscript>
                    // set number of segments of departures
                    setNumberFlightDeparture = ArrayLen(FlightXMLFile.flightinfocollection.flightinfo[i].departure.flight);
                    
                    // Delete current flight information
                    if ( VAL(setNumberFlightDeparture) ) {
                        
                        APPLICATION.CFC.STUDENT.deleteCompleteFlightInformation(studentID=qGetStudentInfo.studentID, programID=qGetStudentInfo.programID, flightType='departure', enteredByID=CLIENT.userID);
                        
                    }
                </cfscript>
    
                <!--- Loop Segments --->
                <cfloop from="1" to="#setNumberFlightDeparture#" index="nodepflight">
                    
                    <cfscript>
                        setNumberSegmentDeparture = ArrayLen(FlightXMLFile.flightinfocollection.flightinfo[i].departure.flight[nodepflight].segment);
                        
                        setSendEmail = 1;
                    </cfscript>
                    
                    
                    <!--- Loop Flight Legs --->
                    <cfloop from="1" to="#setNumberSegmentDeparture#" index="nodepseg">
    
                        <cfscript>
                            // Insert Departure Flight
                            APPLICATION.CFC.STUDENT.insertFlightInfo(
                                studentID=qGetStudentInfo.studentID,
                                companyID=qGetStudentInfo.companyID,
                                programID=qGetStudentInfo.programID,
                                enteredByID=CLIENT.userID,
                                batchID=setBatchID,
                                flightNumber=FlightXMLFile.flightinfocollection.flightinfo[i].departure.flight[nodepflight].segment[nodepseg].flightnumber.xmltext,
                                depCity=FlightXMLFile.flightinfocollection.flightinfo[i].departure.flight[nodepflight].segment[nodepseg].depart_airport.xmltext,
                                depAirCode=FlightXMLFile.flightinfocollection.flightinfo[i].departure.flight[nodepflight].segment[nodepseg].depart_code.xmltext,
                                depDate=FlightXMLFile.flightinfocollection.flightinfo[i].departure.flight[nodepflight].segment[nodepseg].depart_date.xmltext,
                                depTime=FlightXMLFile.flightinfocollection.flightinfo[i].departure.flight[nodepflight].segment[nodepseg].depart_time.xmltext,
                                arrivalCity=FlightXMLFile.flightinfocollection.flightinfo[i].departure.flight[nodepflight].segment[nodepseg].arrival_airport.xmltext,
                                arrivalAirCode=FlightXMLFile.flightinfocollection.flightinfo[i].departure.flight[nodepflight].segment[nodepseg].arrival_code.xmltext,
                                arrivalTime=FlightXMLFile.flightinfocollection.flightinfo[i].departure.flight[nodepflight].segment[nodepseg].arrival_time.xmltext,
                                overNight=VAL(FlightXMLFile.flightinfocollection.flightinfo[i].departure.flight[nodepflight].segment[nodepseg].overnight.xmltext),
                                flightType='departure'
                            );
                        </cfscript>
            
                    </cfloop>
            
                </cfloop>
            
                <cfscript>
                    // Update Flight Notes
                    APPLICATION.CFC.STUDENT.updateFlightNotes(studentID=qGetStudentInfo.studentID, flightNotes=FlightXMLFile.flightinfocollection.flightinfo[i].departure.remarks.xmltext);
                </cfscript>
    
            
                <cfif VAL(FORM.displayResults)>
                    <font color="##009900"> &nbsp; | &nbsp; Departure Information Received</font> <br /><br />
                </cfif>
                
            <cfelse>
            
                <cfif VAL(FORM.displayResults)>
                    <font color="##FFCC33"> &nbsp; | &nbsp; No Departure Information Submitted</font> <br /><br />
                </cfif>
                
            </cfif> <!--- Len(FlightXMLFile.flightinfocollection.flightinfo[i].departure) gt 200 --->
            
            <cfflush>
            
        </cfif> <!--- NOT VAL(qGetStudentInfo.recordcount) --->
        
        
        <cfscript>
            // Send out email notification if flight information was entered by an International Representative / Branch
            if ( setSendEmail AND ListFind("8,11,13", CLIENT.userType) ) {
                APPLICATION.CFC.STUDENT.emailFlightInformation(studentID=qGetStudentInfo.studentID);
            }
        </cfscript>
    
    
    </cfloop> <!--- numberofstudents --->

</cfoutput>

<p>Script Ran and Finished Completely.</p>

<!--- Display XML File --->
<cfif VAL(FORM.receiveXML)>

    <p>Generating XML results file as requested.  This may take a momment.  A link to the file will apear when the process is done.
    Please don't press reload or your back button until the process is finished.</p>
	
    <cfquery name="getFlightByBatchID" datasource="mysql">
        SELECT DISTINCT 
        	flight.studentid, 
            smg_students.soid
        FROM
	        smg_flight_info flight
        LEFT OUTER JOIN
        	smg_students on smg_students.studentid = flight.studentid
        WHERE
        	flight.batchid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#setBatchID#">
		AND 
        	isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">            
        limit 50
    </cfquery>
    
    <!---- Create an XML document object containing the data ---->
    <cfoutput>
    
    <cfxml variable="submitted_fight_info">
        <FlightInfoCollection>
            <cfloop query="getFlightByBatchID">
                <cfscript>
                    // Get Arrival Information
                    qGetFlightArrival = APPLICATION.CFC.STUDENT.getFlightInformation(studentID=getFlightByBatchID.studentID, flightType='arrival'); 
                
                    // Get Arrival Information
                    qGetFlightDeparture = APPLICATION.CFC.STUDENT.getFlightInformation(studentID=getFlightByBatchID.studentID, flightType='departure'); 
                </cfscript>
                <FlightInfo studentid="#getFlightByBatchID.soid#" so="INTO-DE" ro="SMG" soid="1" roid="1362">
                    <arrival>
                        <flight>
                            <cfloop query="qGetFlightArrival">
                                <segment>
                                    <depart_date>#DateFormat(dep_date,'yyyy-mm-dd')#</depart_date>
                                    <depart_time>#TimeFormat(dep_time, 'HH:mm')#</depart_time>
                                    <depart_datetime>#DateFormat(dep_date,'yyyy-mm-dd')# #TimeFormat(dep_time, 'HH:mm')#</depart_datetime>
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
                    <departure>
                        <flight>
                            <cfloop query="qGetFlightDeparture">
                                <segment>
                                    <depart_date>#DateFormat(dep_date,'yyyy-mm-dd')#</depart_date>
                                    <depart_time>#TimeFormat(dep_time, 'HH:mm')#</depart_time>
                                    <depart_datetime>#DateFormat(dep_date,'yyyy-mm-dd')# #TimeFormat(dep_time, 'HH:mm')#</depart_datetime>
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
    </cfxml>
    
    <cffile action="write" file="#AppPath.xmlFiles#flight_verification/#setBatchID#.xml" output="#toString(submitted_fight_info)#">
    
    <p><a href="#CLIENT.exits_url#/nsmg/uploadedfiles/xml_files/flight_verification/#setBatchID#.xml">Results in an XML File</a></p>
    
    </cfoutput>
    
</cfif>
