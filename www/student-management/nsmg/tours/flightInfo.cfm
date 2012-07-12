<!--- ------------------------------------------------------------------------- ----
	
	File:		flightInfo.cfm
	Author:		James Griffiths
	Date:		June 27, 2012
	Desc:		Flight Info for Tours

----- ------------------------------------------------------------------------- --->

<cfparam name="URL.studentID" default="0">
<cfparam name="URL.tripID" default="0">
<cfparam name="URL.viewType" default="arrival">

<cfajaxproxy cfc="nsmg.extensions.components.tour" jsclassname="TOUR">

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />
        
</cfsilent>

<cfoutput>

	<!--- Page Header --->
    <gui:pageHeader headerType="applicationNoHeader" />
    
    <div id="newFlightDiv" style="display:none;">
		
        <br />
        
        <form>
        	<input type="hidden" id="flightID" class="newForm" value="0" />
        	<table width="50%" align="center" bordercolor="##C0C0C0" cellpadding="3" cellspacing="1" style="border:3px solid ##CCC">
            	<tr>
                	<th colspan="2" style="font-size:12px; font-weight:bold;"><u>Flight Information</u><br /><span style="font-size:9px">(all fields are required)</span><br />&nbsp;</th>
              	</tr>
                <tr>
                	<td width="40%" align="right">Type:</td>
                    <td width="60%">
                    	<select id="typeID" class="newForm">
                        	<option value="arrival">Arrival</option>
                            <option value="departure">Departure</option>
                      	</select>
                   	</td>
              	</tr>
				<tr>
                	<td align="right">Date:</td>
                    <td><input type="text" id="dateID" class="datePicker newForm" /></td>
              	</tr>
                <tr>
                	<td align="right">Departure City:</td>
                    <td><input type=text id="departureCityID" class="newForm" /></td>
               	</tr>
                <tr>
                 	<td align="right">Departure Airport Code:</td>
                    <td><input type=text id="departureAirportCodeID" class="newForm" /></td>
              	</tr>
                <tr>
                	<td align="right">Arrival City:</td>
                    <td><input type=text id="arrivalCityID" class="newForm" /></td>
               	</tr>
                <tr>
                	<td align="right">Arrival Airport Code:</td>
                    <td><input type=text id="arrivalAirportCodeID" class="newForm" /></td>
               	</tr>
                <tr>
                	<td align="right">Flight Number:</td>
                    <td><input type=text id="flightNumberID" class="newForm" /></td>
               	</tr>
                <tr>
                	<td align="right">Departure Time:</td>
                    <td><input type=text id="departureTimeID" class="timePicker newForm" /></td>
               	</tr>
                <tr>
                	<td align="right">Arrival Time:</td>
                    <td><input type=text id="arrivalTimeID" class="timePicker newForm" /></td>
               	</tr>
                <tr>
                	<td align="right">Overnight Flight:</td>
                    <td>
                    	<select id="overnightFlightID" class="newForm">
                        	<option value="0">No</option>
                            <option value="1">Yes</option>
                      	</select>
                  	</td>
               	</tr>
                <tr>
                	<td colspan=2 align="center"><br /><input type="button" value="Submit" onClick="submitNewFlight()" />&nbsp;<input type="button" value="Cancel" onclick="closeSection()" /></td>
                </tr>
          	</table>
     	</form>
   	</div>
    
    <br />
    
    <!--- Arrival Information --->
    <span id="arrivalSection"></span>
    
    <br />
    
    <!--- Departure Information --->
    <span id="departureSection"></span>
    
    <br />
    
    <!--- Page Footer --->
    <gui:pageFooter footerType="application" />
    
</cfoutput>

<script type="text/javascript">

	$(document).ready(function() {
		loadFlights();
	});
	
	var loadFlights = function() {
		var t = new TOUR();
		if ('<cfoutput>#URL.viewType#</cfoutput>' == 'arrival') {
			var arrivals = t.getFlights(<cfoutput>#URL.studentID#</cfoutput>,<cfoutput>#URL.tripID#</cfoutput>, 'arrival');
			var arrivalList = "<table align='center' width='99%' bordercolor='#C0C0C0' valign='top' cellpadding='3' cellspacing='1' style='border:1px solid #3b5998'>";
			arrivalList += "<tr><th colspan='10' bgcolor='#3b5998' style='color:#FFF;'> A R R I V A L &nbsp;&nbsp; I N F O R M A T I O N </th></tr>";
			arrivalList += "<tr bgcolor='#3b5998' style='color:white;'><th width='8%'>Date</th><th width='14%'>Departure City</th><th width='12%'>Departure Airport Code</th>";
			arrivalList += "<th width='14%'>Arrival City</th><th width='12%'>Arrival Airport Code</th><th width='10%'>Flight Number</th><th width='8%'>Departure Time</th>";
			arrivalList += "<th width='8%'>Arrival Time</th><th width='5%'>Overnight Flight</th><th width='9%'>Actions</th></tr>";
			for (var i=0; i<arrivals.ROWCOUNT; i++) {
				var dateIn = new Date(arrivals.DATA.DEPARTDATE[i]);
				var date = dateIn.getMonth()+1 + "/" + dateIn.getDate() + "/" + dateIn.getFullYear();
				var arrivalTime = retrieveTime(arrivals.DATA.ARRIVALTIME[i]);
				var departureTime = retrieveTime(arrivals.DATA.DEPARTTIME[i]);
				var overnight = arrivals.DATA.ISOVERNIGHTFLIGHT[i];
				if (overnight)
					overnight = 'Yes';
				else
					overnight = 'No';
				
				if (i%2) {
					arrivalList += "<tr align='center' bgcolor='#ffffff'>";
				} else {
					arrivalList += "<tr align='center' bgcolor='#ffffe6'>";
				}
				arrivalList += "<td>" + date + "</td>";
				arrivalList += "<td>" + arrivals.DATA.DEPARTCITY[i] + "</td>";
				arrivalList += "<td>" + arrivals.DATA.DEPARTAIRPORTCODE[i] + "</td>";
				arrivalList += "<td>" + arrivals.DATA.ARRIVALCITY[i] + "</td>";
				arrivalList += "<td>" + arrivals.DATA.ARRIVALAIRPORTCODE[i] + "</td>";
				arrivalList += "<td>" + arrivals.DATA.FLIGHTNUMBER[i] + "</td>";
				arrivalList += "<td>" + departureTime + "</td>";
				arrivalList += "<td>" + arrivalTime + "</td>";
				arrivalList += "<td>" + overnight + "</td>";
				arrivalList += "<td>";
				arrivalList += "<input type='image' src='../pics/edit.gif' onclick='updateFlight(" + arrivals.DATA.ID[i] + ")' style='font-size:11px' />";
				arrivalList += "<input type='image' src='../pics/delete.gif' onclick='deleteFlight(" + arrivals.DATA.ID[i] + ")' style='font-size:11px' />";
				arrivalList += "</td>";
			}
			arrivalList += "<tr bgcolor='#3b5998'><th colspan='10'><input type='image' src='../pics/new.gif' style='font-size:12px;' onClick='addFlightArrival()' /></th></tr></table>";
			$("#arrivalSection").html(arrivalList);
		} else {
			var departures = t.getFlights(<cfoutput>#URL.studentID#</cfoutput>,<cfoutput>#URL.tripID#</cfoutput>, 'departure');
			var departureList = "<table align='center' width='99%' bordercolor='#C0C0C0' valign='top' cellpadding='3' cellspacing='1' style='border:1px solid #3b5998'>";
			departureList += "<tr><th colspan='10' bgcolor='#3b5998' style='color:white;'> D E P A R T U R E &nbsp;&nbsp; I N F O R M A T I O N </th></tr>";
			departureList += "<tr bgcolor='#3b5998' style='color:white;'><th width='8%'>Date</th><th width='14%'>Departure City</th><th width='12%'>Departure Airport Code</th>";
			departureList += "<th width='14%'>Arrival City</th><th width='12%'>Arrival Airport Code</th><th width='10%'>Flight Number</th><th width='8%'>Departure Time</th>";
			departureList += "<th width='8%'>Arrival Time</th><th width='5%'>Overnight Flight</th><th width='9%'>Actions</th></tr>";
			for (var i=0; i<departures.ROWCOUNT; i++) {
				var dateIn = new Date(departures.DATA.DEPARTDATE[i]);
				var date = dateIn.getMonth()+1 + "/" + dateIn.getDate() + "/" + dateIn.getFullYear();
				var arrivalTime = retrieveTime(departures.DATA.ARRIVALTIME[i]);
				var departureTime = retrieveTime(departures.DATA.DEPARTTIME[i]);
				var overnight = departures.DATA.ISOVERNIGHTFLIGHT[i];
				if (overnight)
					overnight = 'Yes';
				else
					overnight = 'No';
				
				if (i%2) {
					departureList += "<tr align='center' bgcolor='#ffffff'>";
				} else {
					departureList += "<tr align='center' bgcolor='#ffffe6'>";
				}
				departureList += "<td>" + date + "</td>";
				departureList += "<td>" + departures.DATA.DEPARTCITY[i] + "</td>";
				departureList += "<td>" + departures.DATA.DEPARTAIRPORTCODE[i] + "</td>";
				departureList += "<td>" + departures.DATA.ARRIVALCITY[i] + "</td>";
				departureList += "<td>" + departures.DATA.ARRIVALAIRPORTCODE[i] + "</td>";
				departureList += "<td>" + departures.DATA.FLIGHTNUMBER[i] + "</td>";
				departureList += "<td>" + departureTime + "</td>";
				departureList += "<td>" + arrivalTime + "</td>";
				departureList += "<td>" + overnight + "</td>";
				departureList += "<td>";
				departureList += "<input type='image' src='../pics/edit.gif' onclick='updateFlight(" + departures.DATA.ID[i] + ")' style='font-size:11px' />";
				departureList += "<input type='image' src='../pics/delete.gif' onclick='deleteFlight(" + departures.DATA.ID[i] + ")' style='font-size:11px' />";
				departureList += "</td>";
			}
			departureList += "<tr bgcolor='#3b5998'><th colspan='10'><input type='image' src='../pics/new.gif' style='font-size:12px;' onClick='addFlightDeparture()' /></th></tr></table>";
			$("#departureSection").html(departureList);
		}
	}
	
	var closeSection = function() {
		$("#newFlightDiv").attr("style", "display:none");
	}
	
	var retrieveTime = function(inTime) {
		var timeIn = new Date(inTime);
		var hours = timeIn.getHours();
		var mins = timeIn.getMinutes();
		var newHours = hours;
		var newMins = mins;
		if (hours < 10)
			newHours = "0" + hours;
		if (mins < 10)
			newMins = "0" + mins;
		return newHours + ":" + newMins;
	}
	
	var showNewFlightField = function(type) {
		$("#newFlightDiv").removeAttr("style");
		$(".newForm").val("");
		$("#typeID").val(type);
		$("#overnightFlightID").val('0');
		window.scrollTo(0,0);
	}
	
	var addFlightArrival = function() {
		showNewFlightField('arrival');
	}
	
	var addFlightDeparture = function() {
		showNewFlightField('departure');
	}
	
	var updateFlight = function(flightID) {
		showNewFlightField();
		$("#flightID").val(flightID);
		
		var t = new TOUR();
		var result = t.getFlightInformationByID(flightID);
		var dateIn = new Date(result.DATA.DEPARTDATE);
		var date = dateIn.getMonth()+1 + "/" + dateIn.getDate() + "/" + dateIn.getFullYear();
		var arrivalTime = retrieveTime(result.DATA.ARRIVALTIME);
		var departureTime = retrieveTime(result.DATA.DEPARTTIME);
		var overnightFlight = result.DATA.ISOVERNIGHTFLIGHT;
		if (overnightFlight == 'true')
			overnightFlight = 1;
		else
			overnightFlight = 0;
		
		$("#typeID").val(result.DATA.FLIGHTTYPE);
		$("#dateID").val(date);
		$("#departureCityID").val(result.DATA.DEPARTCITY);
		$("#departureAirportCodeID").val(result.DATA.DEPARTAIRPORTCODE);
		$("#arrivalCityID").val(result.DATA.ARRIVALCITY);
		$("#arrivalAirportCodeID").val(result.DATA.ARRIVALAIRPORTCODE);
		$("#flightNumberID").val(result.DATA.FLIGHTNUMBER);
		$("#departureTimeID").val(departureTime);
		$("#arrivalTimeID").val(arrivalTime);
		$("#overnightFlightID").val(overnightFlight);
	}
	
	var deleteFlight = function(flightID) {
		var t = new TOUR();
		t.deleteFlightInformation(flightID);
		loadFlights();
	}
	
	var submitNewFlight = function() {
		var flightID = $("#flightID").val();
		var studentID = <cfoutput>#URL.studentID#</cfoutput>;
		var tripID = <cfoutput>#URL.tripID#</cfoutput>;
		var type = $("#typeID").val();
		var date = $("#dateID").val();
		var departureCity = $("#departureCityID").val();
		var departureAirportCode = $("#departureAirportCodeID").val();
		var arrivalCity = $("#arrivalCityID").val();
		var arrivalAirportCode = $("#arrivalAirportCodeID").val();
		var flightNumber = $("#flightNumberID").val();
		var departureTime = $("#departureTimeID").val();
		var arrivalTime = $("#arrivalTimeID").val();
		var overnightFlight = $("#overnightFlightID").val();
		
		var t = new TOUR();
		var result = 0;
		
		// New Flight
		if (flightID == 0) {
			result = t.addFlightInformation(
				studentID,
				tripID,
				type,
				date,
				departureCity,
				departureAirportCode,
				arrivalCity,
				arrivalAirportCode,
				flightNumber,
				departureTime,
				arrivalTime,
				overnightFlight
			);
		} 
		// Update Flight
		else {
			result = t.updateFlightInformation(
				flightID,
				studentID,
				tripID,
				type,
				date,
				departureCity,
				departureAirportCode,
				arrivalCity,
				arrivalAirportCode,
				flightNumber,
				departureTime,
				arrivalTime,
				overnightFlight
			);
		}
		
		if (result) {
			$("#newFlightDiv").attr("style", "display:none");
		} else if (flightID != 0) {
			alert("This flight could not be updated - please check the fields and try again.");
		} else {
			alert("This flight could not be added - please check the fields and try again.");
		}
		loadFlights();
	}
</script>