<!--- ------------------------------------------------------------------------- ----
	
	File:		incentiveTripDetails.cfm
	Author:		James Griffiths
	Date:		05/15/2014
	Desc:		Details and allows updates of information for incentive trip guests.
					
----- ------------------------------------------------------------------------- --->

	<!--- Import CustomTag --->
    <cfimport taglib="extensions/customTags/gui/" prefix="gui" />	

    <cfparam name="FORM.submitted" default="0">
    
    <cfquery name="qGetIncentiveTrip" datasource="#APPLICATION.DSN#">
        SELECT *
        FROM smg_incentive_trip 
        WHERE active = 1
    </cfquery>
    
    <cfquery name="qGetAirports" datasource="#APPLICATION.DSN#">
    	SELECT airCode, CONCAT(airCode," - ", airportName) AS name
        FROM smg_airports
    </cfquery>
    
    <cfscript>
		vUserID = CLIENT.userID;
        vSeasonID = APPLICATION.CFC.LOOKUPTABLES.getCurrentPaperworkSeason().seasonID;
		
		vTotalPlacements = APPLICATION.CFC.USER.getPlacementsAndPointsCount(
			userID = vUserID,
			seasonID = vSeasonID);
		
		vPlacements = vTotalPlacements;
		vTotalTrips = APPLICATION.CFC.USER.getTripsEarned(numPlacements = vTotalPlacements);
		vTripsLeft = vTotalTrips;
		vTotalCost = 0;
		
        qGetIncentiveTripGuests = APPLICATION.CFC.USER.getIncentiveTripGuests(
            userID = vUserID,
            seasonID = vSeasonID);
		
		vTakingCheck = VAL(APPLICATION.CFC.USER.getTakingCheck(
			userID = vUserID,
            seasonID = vSeasonID).takingCheck);
		
    </cfscript>
    
    <cfif VAL(FORM.submitted)>
    
    	<!--- Update taking check record --->
        <cfparam name="FORM.takingCheck" default="0">
        <cfscript>
			APPLICATION.CFC.USER.updateTakingCheck(
				userID = vUserID,
				seasonID = vSeasonID,
				takingCheck = FORM.takingCheck);
		</cfscript>
        
        <!--- Update / delete old records --->
        <cfloop query="qGetIncentiveTripGuests">
        	<cfparam name="FORM['delete_' & ID]" default="0">
        	<cfscript>
				APPLICATION.CFC.USER.updateIncentiveTripGuests(
					ID = ID,
					name = FORM["name_" & ID],
					userType = FORM["userType_" & ID],
					dob = FORM["dob_" & ID],
					departureAirport = FORM["departureAirport_" & ID],
					comments = FORM["notes_" & ID]);
				if (VAL(FORM["delete_" & ID])) {
					APPLICATION.CFC.USER.removeIncentiveTripGuests(ID = ID);	
				}
			</cfscript>
        </cfloop>
        
        <!--- Add new records --->
        <cfloop from="1" to="#FORM.addGuests#" index="i">
        	<cfparam name="FORM['addName_' & i]" default="">
        	<cfscript>
			if (LEN(FORM['addName_' & i])) {
				APPLICATION.CFC.USER.addIncentiveTripGuests(
					userID = vUserID,
					seasonID = vSeasonID,
					name = FORM["addName_" & i],
					userType = FORM["addUserType_" & i],
					dob = FORM["addDob_" & i],
					departureAirport = FORM["addDepartureAirport_" & i],
					comments = FORM["addNotes_" & i]);
			}
			</cfscript>
        </cfloop>
        
        <!--- Reload page --->
        <cfset FORM.submitted = 0>
    	<cflocation url="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#">
    
    </cfif>

<style type="text/css">
	input:not([type="checkbox"]) {
		width:95%;
	}
	
	select {
		width: 95%;	
	}
	
	#incentiveDetailsTable {
		border-collapse: collapse;
		width: 850px;
		margin: auto;
	}
	
	#incentiveDetailsTable td {
		padding:2px;
	}
	
	.missingInfo {
		border: thin solid red;	
	}
</style>

<script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1/jquery-ui.min.js"></script>

<script type="text/javascript">

	var isDirty = 0;
	var vAirports = "";
	var vAirportCodes = "";
	
	$(document).ready(function() {
		
		// Check if anything has changed.
		$(':input').each(function() {
			$(this).data('oldVal', $(this));
			$(this).bind("propertychange keyup input cut paste", function(event) {
				if ($(this).data('oldVal') != $(this).val()) {
					$(this).data('oldVal', $(this).val());
					isDirty++;
				}
			});
		});
		
		// Display the option to take a check if there are no guests.
		if ($("#guestList").val() + $("#addGuests").val() == 0) {
			$("#noGuests").show();
		} 
		
		// Displays the option to add guests if they are not taking the check.
		if ($("#takingCheck").val() == 0) {
			$("#guests").show();	
		} else {
			$("#takingCheckBox").prop("checked", true);	
		}
		
		var vAirports = $("#airports").val().split(',');
		var vAirportCodes = $("#airportCodes").val().split(',');
		$(".airportClass").live('focus', function() {
			$(".airportClass").autocomplete({
				source: vAirports								   
			});
		});
		
		$(".airportClass").on("autocompleteselect", function (e, ui) {
    		e.preventDefault();
			this.value = ui.item.value.substring(0,3);
		});
		
	});
	
	window.onbeforeunload=function(){
	   if (isDirty) return "If you leave this page now your changes will not be saved.";
	}

	// To make picking a year easier in the default datepicker
	$(function() {
        $( "#datepicker" ).datepicker({
            changeMonth: true,
            changeYear: true,
			yearRange: '-100y:c+nn',
			maxDate: '-1d'
        });
    });

	var vNewGuestNumber = 0;
	
	function changeTakeCheck() {
		if ($("#takingCheckBox").is(":checked")) {
			$("#takingCheck").val(1);
			$("#guests").hide();
		} else {
			$("#takingCheck").val(0);
			$("#guests").show();
		}
	}
	
	function addGuest() {
		vNewGuestNumber++;
		$("#incentiveDetailsTable tr:last").after("<tr id='row"+vNewGuestNumber+"'>"
				+"<td><input type='text' name='addName_"+vNewGuestNumber+"' id='addName_"+vNewGuestNumber+"' /></td>"
				+"<td>"
				+"	<select name='addUserType_"+vNewGuestNumber+"' id='addUserType_"+vNewGuestNumber+"'>"
				+"		<option value='0'>Guest</option>"
				+"		<option value='7' selected='selected'>Area Representative</option>"
				+"		<option value='6'>Regional Advisor</option>"
				+"		<option value='5'>Regional Manager</option>"
				+"	</select>"
				+"</td>"
				+"<td><input type='text' name='addDob_"+vNewGuestNumber+"' id='addDob_"+vNewGuestNumber+"' /></td>"
				+"<td><input type='text' class='airportClass' name='addDepartureAirport_"+vNewGuestNumber+"' id='addDepartureAirport_"+vNewGuestNumber+"' /></td>"
				+"<td><input type='text' name='addNotes_"+vNewGuestNumber+"' id='addNotes_"+vNewGuestNumber+"' /></td>"
				+"<td></td>"
				+"<td><input type='button' value='Remove Traveler' onclick='removeGuest("+vNewGuestNumber+");' style='width: 120px; cursor:pointer;' /></td>"
        	+"</tr>");
		$('#addDob_'+vNewGuestNumber).datepicker({changeMonth: true, changeYear: true, yearRange: '-100y:c+nn', maxDate: '-1d'});
		$('#addName_'+vNewGuestNumber).addClass("checkField");
		$('#addDob_'+vNewGuestNumber).addClass("checkField");
		$('#addDepartureAirport_'+vNewGuestNumber).addClass("checkField");
		$("#noGuests").hide();
	}
	
	function removeGuest(ID) {
		if (vNewGuestNumber > 0) {
			document.getElementById('incentiveDetailsTable').deleteRow(document.getElementById('row'+ID).rowIndex);
		}
		if ($("#guestList").val() + $("#incentiveDetailsTable tr").length == 1) {
			$("#noGuests").show();
		} 
	}
	
	function saveChanges() {
		vErrors = 0;
		$(".missingInfo").removeClass("missingInfo");
		var items = document.getElementsByClassName('checkField');
		for (var i = 0; i < items.length; i++) {
			if (items[i].value == "") {
				vErrors++;
				items[i].className = items[i].className + " missingInfo";
			}
		}
		
		if (!vErrors) {
			$("#addGuests").val(vNewGuestNumber);
			$("#incentiveTripForm").submit();
		} else {
			alert("Please complete all fields highlighted in red.");	
		}
	}

</script>

<cfoutput>

	<!--- Table Header --->
    <gui:tableHeader
        imageName="plane.png"
        tableTitle="Incentive Trip Travelers - #qGetIncentiveTrip.trip_place# #YEAR(qGetIncentiveTrip.trip_year)#"
        tableRightTitle=''
    />
    
    <table class="section" width="100%">
		<tr>
        	<td>
                <form name="incentiveTripForm" id="incentiveTripForm" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
                    <input type="hidden" name="submitted" value="1" />
                    <input type="hidden" name="addGuests" id="addGuests" value="0" />
                    <input type="hidden" name="guestList" id="guestList" value="#ValueList(qGetIncentiveTripGuests.ID)#" />
                    <input type="hidden" name="takingCheck" id="takingCheck" value="#vTakingCheck#" />
                    <input type="hidden" id="airports" value="#ValueList(qGetAirports.name)#" />
                    <input type="hidden" id="airportCodes" value="#ValueList(qGetAirports.airCode)#" />
                    <table id="incentiveDetailsTable">
                        <tr>
                            <td width="180px"><u><b>Name</b></u></td>
                            <td width="160px"><u><b>Type</b></u></td>
                            <td width="100px"><u><b>DOB</b></u></td>
                            <td width="120px"><u><b>Departure Airport</b></u></td>
                            <td width="180px"><u><b>Notes</b></u></td>
                            <td width="50px"><u><b>Cost</b></u></td>
                            <td width="60px"><u><b></b></u></td>
                        </tr>
                        <cfloop query="qGetIncentiveTripGuests">
                            <cfscript>
                                vRequirement = 7;
                                if (qGetIncentiveTripGuests.currentRow GTE 3) {
                                    vRequirement = 6;
                                }
                            </cfscript>
                            <tr>
                                <td><input type="text" name="name_#ID#" id="name_#ID#" value="#name#" class="checkField" /></td>
                                <td>
                                    <select name="userType_#ID#" id="userType_#ID#">
                                        <option value="0" <cfif userType EQ 0>selected="selected"</cfif>>Guest</option>
                                        <option value="7" <cfif userType EQ 7>selected="selected"</cfif>>Area Representative</option>
                                        <option value="6" <cfif userType EQ 6>selected="selected"</cfif>>Regional Advisor</option>
                                        <option value="5" <cfif userType EQ 5>selected="selected"</cfif>>Regional Manager</option>
                                    </select>
                                </td>
                                <td><input type="text" class="datePicker checkField" name="dob_#ID#" id="dob_#ID#" value="#DateFormat(dob,'mm/dd/yyyy')#" /></td>
                                <td><input type="text" class="airportClass checkField" name="departureAirport_#ID#" id="departureAirport_#ID#" value="#departureAirport#" /></td>
                                <td><input type="text" name="notes_#ID#" id="notes_#ID#" value="#comments#" /></td>
                                <td>
                                    <cfif vPlacements GTE vRequirement>
                                        Free
                                    <cfelse>
                                        <cfscript>
                                            if (vPlacements GTE 0) {
                                                vCost = APPLICATION.CFC.USER.getAdditionalTripCost(numEarnedTrips=vTotalTrips,numPlacements=vTotalPlacements);
                                            } else{
                                                vCost = 1800;	
                                            }
                                            vTotalCost = vTotalCost + vCost;
                                        </cfscript>
                                        $#vCost#
                                    </cfif>
                                    <cfscript>
                                        vPlacements = vPlacements - vRequirement;
                                        vTripsLeft = vTripsLeft - 1;
                                    </cfscript>
                                </td>
                                <td><input type="checkbox" name="delete_#ID#" value="1" />Delete</td>
                            </tr>
                        </cfloop>
                   	</table>
                </form>
        	</td>
       	</tr>
        <tr>
        	<td>
            	<table style="width:100%; margin:auto;">
                    <tr><td><hr /></td></tr>
                  	<tr>
                  		<td align="center">
                      		<span id="noGuests" style="display:none;">
                        		<input type="checkbox" id="takingCheckBox" onclick="changeTakeCheck()" />Take a check for $#vTotalTrips*500#
                          	</span>
                     	</td>
                	</tr>
                    <tr>
                        <td align="center">
                        	<span id="guests" style="display:none;">
                                <input type="button" value="Add Traveler" onclick="addGuest();" style="width: 100px; cursor:pointer;" />
                            </span>
                            <input type="button" value="Save Changes" onclick="saveChanges();" style="width: 100px; cursor:pointer;" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            You have made <b>#vTotalPlacements#</b> placements and have earned a total of <b>#vTotalTrips#</b> trip(s).
                            <br />
                            You are using <b>#vTotalTrips - vTripsLeft#</b> trip(s) and will 
                            <cfif vTripsLeft GT 0>
                                receive a <b>$#vTripsLeft * 500#</b> compensation for the unused trip(s).
                            <cfelse>
                                owe <b>$#vTotalCost#</b> for additional trips.
                            </cfif>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    
    <cfinclude template="table_footer.cfm">
    
</cfoutput>