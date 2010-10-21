<!--- ------------------------------------------------------------------------- ----
	
	File:		_flightInformation.cfm
	Author:		Marcus Melo
	Date:		August 9, 2010
	Desc:		Frequently Asked Questions

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../../../extensions/customtags/gui/" prefix="gui" />	
	
    <cfscript>
		// Get Current Candidate Information
		qGetCandidateInfo = APPLICATION.CFC.CANDIDATE.getCandidateByID(candidateID=APPLICATION.CFC.CANDIDATE.getCandidateID());
	</cfscript>
    
    <!--- Candidate Details --->
    <cfparam name="FORM.candidateID" default="#qGetCandidateInfo.candidateID#">
    <cfparam name="FORM.programID" default="#VAL(qGetCandidateInfo.programID)#">

	<!--- Ajax Call to the Component --->
    <cfajaxproxy cfc="extra.extensions.components.flightInformation" jsclassname="flightInformation">
    
</cfsilent>

<cfoutput>

<!--- Page Header --->
<gui:pageHeader
	headerType="application"
/>

	<script language="javascript">
        // Function to find the index in an array of the first entry with a specific value. 
        // It is used to get the index of a column in the column list. 
		Array.prototype.findIdx = function(value){ 
            for (var i=0; i < this.length; i++) { 
                if (this[i] == value) { 
                    return i; 
                } 
            } 
        } 

		// Create an instance of the proxy that will be used in multiple functions. 
		var fi = new flightInformation();
		
		// This is used to refresh both lists
        var refreshLists = function() { 
			getFlightInformation('arrival');
			getFlightInformation('departure');
		}

		// This is used to display add/edit form
        var displayForm = function() { 
			// Fade IN form field div
			if ($("##insertUpdateFlight").css("display") == "none") {
				$("##insertUpdateFlight").fadeIn("fast");			
			}
		}

        // Load the list when page is ready
        $(document).ready(function() {
			refreshLists();
			$('##arriveTime').timepicker();
			$('##departTime').timepicker();
			$('##departDate').datepicker();
        });
		
		
		// --- START OF ARRIVAL/DEPARTURE LIST --- //
		/* 
			This function gets both arrival and departure information
		   	Use an asynchronous call to get the flight information
		*/   
        var getFlightInformation = function(setFlightType) { 
            
			// Get candidateID
            var candidateID = $("##candidateID").val();
			
            // Setting a callback handler for the proxy automatically makes the proxy's calls asynchronous. 
            fi.setCallbackHandler(populateFlightList); 
            fi.setErrorHandler(myErrorHandler); 
            // Pass the candidateID and flightType to the getFlightInformation function. 
            fi.getFlightInformation(candidateID,setFlightType);
			
		}
		
        // Callback function to handle the results returned by the getArrivalInformation function and populate the table. 
        var populateFlightList = function(resultList) { 

			// Get Flight Type from CFC
			getFlightType = resultList.FLIGHTTYPE;
			
			// Clear current result
            $("##" + getFlightType + "List").empty();
    		
			// Check if it return no data
            if( resultList.QUERY.DATA.length == 0) {
    
                // Create Table Header
                var divRow = '';		
                divRow += "<div class='trCenter'>";
                    divRow += "<div class='td100'>There are no flights recorded. Please click on the button below to enter arrival information.</div>";
                    divRow += "<div class='clearBoth'></div>";
                divRow += "</div>";
                
                // No data returned, display message
                $("##" + getFlightType + "List").append(divRow);
    
            }
    
            // Loop over results and build the grid
            for(i=0;i<resultList.QUERY.DATA.length;i++) { 
                
                var ID = resultList.QUERY.DATA[i][resultList.QUERY.COLUMNS.findIdx('ID')];
                var candidateID = resultList.QUERY.DATA[i][resultList.QUERY.COLUMNS.findIdx('CANDIDATEID')];		
                var programID = resultList.QUERY.DATA[i][resultList.QUERY.COLUMNS.findIdx('PROGRAMID')];
                var flightType = resultList.QUERY.DATA[i][resultList.QUERY.COLUMNS.findIdx('FLIGHTTYPE')];
                var departDate = resultList.QUERY.DATA[i][resultList.QUERY.COLUMNS.findIdx('DEPARTDATE')];
                var departCity = resultList.QUERY.DATA[i][resultList.QUERY.COLUMNS.findIdx('DEPARTCITY')];
                var departAirportCode = resultList.QUERY.DATA[i][resultList.QUERY.COLUMNS.findIdx('DEPARTAIRPORTCODE')];
                var arriveCity = resultList.QUERY.DATA[i][resultList.QUERY.COLUMNS.findIdx('ARRIVECITY')];
                var arriveAirportCode = resultList.QUERY.DATA[i][resultList.QUERY.COLUMNS.findIdx('ARRIVEAIRPORTCODE')];
                var flightNumber = resultList.QUERY.DATA[i][resultList.QUERY.COLUMNS.findIdx('FLIGHTNUMBER')];
                var departTime = resultList.QUERY.DATA[i][resultList.QUERY.COLUMNS.findIdx('DEPARTTIME')];
                var arriveTime = resultList.QUERY.DATA[i][resultList.QUERY.COLUMNS.findIdx('ARRIVETIME')];
                var isOvernightFlight = resultList.QUERY.DATA[i][resultList.QUERY.COLUMNS.findIdx('ISOVERNIGHTFLIGHT')];
    			
                // Create Div Rows
                var divRow = '';	
                    if (i % 2 == 0) {
                        divRow += "<div id='flightID" + ID + "'class='trCenter'>";
                    } else {
                        divRow += "<div id='flightID" + ID + "'class='trCenterOdd'>";
                    }
                    divRow += "<div class='tdSmall'>" + departDate + "</div>"
                    divRow += "<div class='tdLarge'>" + departCity + "</div>"
                    divRow += "<div class='tdSmall'>" + departAirportCode + "</div>"
                    divRow += "<div class='tdLarge'>" + arriveCity + "</div>"
                    divRow += "<div class='tdSmall'>" + arriveAirportCode + "</div>"
                    divRow += "<div class='tdSmall'>" + flightNumber + "</div>"
                    divRow += "<div class='tdSmall'>" + departTime + "</div>" 
                    divRow += "<div class='tdSmall'>" + arriveTime + "</div>"
                    divRow += "<div class='tdSmall'>" + isOvernightFlight + "</div>"
                    divRow += "<div class='tdSmall'><a href='javascript:getFlightDetails(" + ID + ");'>[Edit]</a> <a href='javascript:deleteFlightDetail(" + ID + "," + candidateID + ");'>[Delete]</a></div>"
                    divRow += "<div class='clearBoth'></div>";
                divRow += "</div>";
                // Append table rows
                $("##" + getFlightType + "List").append(divRow);
				
            } 
            
        }
        // --- END OF ARRIVAL LIST --- //


		// --- START OF POPULATE FLIGHT DETAILS --- //
		var getFlightDetails = function(ID) { 
			
			// Setting a callback handler for the proxy automatically makes the proxy's calls asynchronous. 
			fi.setCallbackHandler(populateFlightDetails); 
			fi.setErrorHandler(myErrorHandler); 
			// Pass the ID to the getFlightInformationByID function. 
			fi.getFlightInformationByID(ID);
			
		} 
		
		// Callback function to handle the results returned by the getVerificationList function and populate the form fields. 
		var populateFlightDetails = function(resFlightDetails) { 
			
			var ID = resFlightDetails.DATA[0][resFlightDetails.COLUMNS.findIdx('ID')];
			var candidateID = resFlightDetails.DATA[0][resFlightDetails.COLUMNS.findIdx('CANDIDATEID')];		
			var programID = resFlightDetails.DATA[0][resFlightDetails.COLUMNS.findIdx('PROGRAMID')];
			var flightType = resFlightDetails.DATA[0][resFlightDetails.COLUMNS.findIdx('FLIGHTTYPE')];
			var departDate = resFlightDetails.DATA[0][resFlightDetails.COLUMNS.findIdx('DEPARTDATE')];
			var departCity = resFlightDetails.DATA[0][resFlightDetails.COLUMNS.findIdx('DEPARTCITY')];
			var departAirportCode = resFlightDetails.DATA[0][resFlightDetails.COLUMNS.findIdx('DEPARTAIRPORTCODE')];
			var arriveCity = resFlightDetails.DATA[0][resFlightDetails.COLUMNS.findIdx('ARRIVECITY')];
			var arriveAirportCode = resFlightDetails.DATA[0][resFlightDetails.COLUMNS.findIdx('ARRIVEAIRPORTCODE')];
			var flightNumber = resFlightDetails.DATA[0][resFlightDetails.COLUMNS.findIdx('FLIGHTNUMBER')];
			var departTime = resFlightDetails.DATA[0][resFlightDetails.COLUMNS.findIdx('DEPARTTIME')];
			var arriveTime = resFlightDetails.DATA[0][resFlightDetails.COLUMNS.findIdx('ARRIVETIME')];
			var isOvernightFlight = resFlightDetails.DATA[0][resFlightDetails.COLUMNS.findIdx('ISOVERNIGHTFLIGHT')];

			// Populate fields
			$("##ID").val(ID);
			$("##flightType").val(flightType);
			$("##departDate").val(departDate);
			$("##departCity").val(departCity);
			$("##departAirportCode").val(departAirportCode);
			$("##arriveCity").val(arriveCity);
			$("##arriveAirportCode").val(arriveAirportCode);
			$("##flightNumber").val(flightNumber);
			$("##departTime").val(departTime);
			$("##arriveTime").val(arriveTime);
			$("##isOvernightFlight").val(isOvernightFlight);
			
			// Display Add/Edit Form
			displayForm();
	
		}
		// --- END OF POPULATE FLIGHT DETAILS --- //


		// --- START OF ADD/UPDATE FLIGHT DETAIL --- //
		var insertUpdateFlightDetail = function() { 
			
			// Store a list of errors used in the validation 
			var divRow = '';		
			var isThereError = 0;
			
			divRow += "<p><em>Oops... the following errors were encountered:</em></p>";

			// Flight Type			
			if($("##flightType").val() == ''){
				isThereError=1;
				divRow += "<ul><li>Please select a flight type</li></ul>";
			}
			// Depart Date
			if($("##departDate").val() == ''){
				isThereError=1;
				divRow += "<ul><li>Please provide a depart date (mm/dd/yyyy)</li></ul>";
			}
			// Depart City			
			if($("##departCity").val() == ''){
				isThereError=1;
				divRow += "<ul><li>Please provide a depart city</li></ul>";
			}
			// Airport Code			
			if($("##departAirportCode").val() == ''){
				isThereError=1;
				divRow += "<ul><li>Please provide a depart airport code</li></ul>";
			}
			// Arrive City			
			if($("##arriveCity").val() == ''){
				isThereError=1;
				divRow += "<ul><li>Please provide an arrive city</li></ul>";
			}
			// Arrive Airport Code			
			if($("##arriveAirportCode").val() == ''){
				isThereError=1;
				divRow += "<ul><li>Please provide an arrive airport code</li></ul>";
			}
			// Flight Number			
			if($("##flightNumber").val() == ''){
				isThereError=1;
				divRow += "<ul><li>Please provide a flight number</li></ul>";
			}
			// Depart Time			
			if($("##departTime").val() == ''){
				isThereError=1;
				divRow += "<ul><li>Please provide a depart time (hh:mm tt)</li></ul>";
			}
			// Arrive Time			
			if($("##arriveTime").val() == ''){
				isThereError=1;
				divRow += "<ul><li>Please provide an arrive time (hh:mm tt)</li></ul>";
			}
			// Overnight Flight		
			if($("##isOvernightFlight").val() == ''){
				isThereError=1;
				divRow += "<ul><li>Please select if this is an overnight flight</li></ul>";
			}
			
			divRow += "<p>Data has <strong>not</strong> been saved.</p>";
			
			// check if there are errors
			if (isThereError == 1) {
				$(".errors").html(divRow).fadeIn();		
				return false;
			}
			
			// No errors, submit the data
			submitInsertUpdateDetail();
			// do not remove - firefox needs it in order to work properly
			return false; 
		}				
		
		var submitInsertUpdateDetail = function() { 
			
			// Setting a callback handler for the proxy automatically makes the proxy's calls asynchronous. 
			fi.setCallbackHandler(resetFormFields);
			fi.setErrorHandler(myErrorHandler);
			// This time, pass the candidate data to the updateRemoteCandidateByID CFC function. Get values from the fields 
			fi.insertUpdateFlightInformation( 
				$("##ID").val(),
				$("##candidateID").val(),
				$("##programID").val(),
				$("##flightType").val(),
				$("##departDate").val(),
				$("##departCity").val(),
				$("##departAirportCode").val(),
				$("##arriveCity").val(),
				$("##arriveAirportCode").val(),
				$("##flightNumber").val(),
				$("##departTime").val(),
				$("##arriveTime").val(),
				$("##isOvernightFlight").val()
			);
			
		}
	
		var resetFormFields = function() {
			
			// Fade out form DIV
			$('##insertUpdateFlight').fadeOut("fast", function() {
				// Animation complete.
				
				getID = $("##ID").val();
				
				// Set up page message, fade in and fade out after 5 seconds
				if ( getID == 0 ) {
					// Insert
					$(".pageMessages").html("<p><em>Flight detail has successfully been added</em></p>").fadeIn().fadeOut(5000);
				} else {
					// Update
					$(".pageMessages").html("<p><em>Flight detail has successfully been updated</em></p>").fadeIn().fadeOut(5000);				
				}
				
				// Reset Errors Div
				$(".errors").html("").fadeOut("fast");
				
				// Reset form fields
				$("##ID").val(0),
				$("##programID").val(0);
				$("##flightType").val("");
				$("##departDate").val("");
				$("##departCity").val("");
				$("##departAirportCode").val("");
				$("##arriveCity").val("");
				$("##arriveAirportCode").val("");
				$("##flightNumber").val("");
				$("##departTime").val("");
				$("##arriveTime").val("");
				$("##isOvernightFlight").val("");
				
			});
			
			// Refresh Lists
			refreshLists();
		}
		// --- END OF ADD/UPDATE FLIGHT DETAIL --- //
	

		// --- START OF DELETE FLIGHT --- //
		var deleteFlightDetail = function(ID,candidateID) {
					
			// Setting a callback handler for the proxy automatically makes the proxy's calls asynchronous. 
			fi.setCallbackHandler(deleteFlightConfirmation(ID)); 
			fi.setErrorHandler(myErrorHandler); 
			fi.deleteFlightInformationByID(ID,candidateID);
			
		}
		
		var deleteFlightConfirmation = function(ID) {
			
			// Set up page message, fade in and fade out after 2 seconds
			$(".pageMessages").html("<p><em>Flight detail successfully deleted</em></p>").fadeIn().fadeOut(5000);
	
			// Fade out record from search list
			$("##flightID" + ID).fadeOut("slow");

		}
		// --- END OF DELETE FLIGHT --- //


		// Error handler for the asynchronous functions. 
		var myErrorHandler = function(statusCode, statusMsg) { 
			alert('Status: ' + statusCode + ', ' + statusMsg); 
		} 
    </script>

    <!--- Side Bar --->
    <div class="rightSideContent ui-corner-all">

        <div class="insideBar">
			
            <!--- Page Messages --->
            <div class="pageMessages"></div>
            
            <!--- FORM Errors --->
            <div class="errors hiddenField"></div>
            
            <!--- Application Body --->
			<div class="form-container-noBorder">
            	
                <!--- Flight Information Detail --->
				<fieldset id="insertUpdateFlight" class="hiddenField">

                    <legend>Flight Information Detail</legend>            

					<form name="flightDetail" onsubmit="return insertUpdateFlightDetail();">
                    <input type="hidden" name="ID" id="ID" value="0" />
                    <input type="hidden" name="candidateID" id="candidateID" value="#FORM.candidateID#" />
                    <input type="hidden" name="programID" id="programID" value="#FORM.programID#" />                   
                    
                    <div class="field">
                        <label for="flightType">Type <em>*</em></label> 
                        <select name="flightType" id="flightType" class="smallField">
                            <option value=""></option>
                            <option value="Arrival">Arrival</option>
                            <option value="Departure">Departure</option>
                        </select>
                    </div>
                
                    <div class="field">
                        <label for="departDate">Date <em>*</em></label> 
                        <input type="text" name="departDate" id="departDate" value="" class="mediumField date-pick" maxlength="10" />
                        <p class="note">(mm/dd/yyyy)</p>
                    </div>
					
                    <div class="clearBoth"></div>
                    
                    <div class="field">
                        <label for="departCity">Depart City <em>*</em></label> 
                        <input type="text" name="departCity" id="departCity" value="" class="mediumField" maxlength="100" />
                    </div>

                    <div class="field">
                        <label for="departAirportCode">Depart Airport Code <em>*</em></label> 
                        <input type="text" name="departAirportCode" id="departAirportCode" value="" class="smallField" maxlength="10" />
                    </div>

                    <div class="field">
                        <label for="arriveCity">Arrive City <em>*</em></label> 
                        <input type="text" name="arriveCity" id="arriveCity" value="" class="mediumField" maxlength="100" />
                    </div>
                    
                    <div class="field">
                        <label for="arriveAirportCode">Arrive Airport Code <em>*</em></label> 
                        <input type="text" name="arriveAirportCode" id="arriveAirportCode" value="" class="smallField" maxlength="10" />
                    </div>

                    <div class="field">
                        <label for="flightNumber">Flight Number <em>*</em></label> 
                        <input type="text" name="flightNumber" id="flightNumber" value="" class="smallField" maxlength="10" />
                    </div>

                    <div class="field">
                        <label for="departTime">Depart Time <em>*</em></label> 
                        <input type="text" name="departTime" id="departTime" value="" class="smallField" maxlength="8" />
                        <p class="note">(hh:mm 24hs)</p>
                    </div>
                    
                    <div class="field">
                        <label for="arriveTime">Arrive Time <em>*</em></label> 
                        <input type="text" name="arriveTime" id="arriveTime" value="" class="smallField" maxlength="8" />
                        <p class="note">(hh:mm 24hs)</p>
                    </div>

                    <div class="field">
                        <label for="isOvernightFlight">Overnight Flight <em>*</em></label> 
                        <select name="isOvernightFlight" id="isOvernightFlight" class="smallField">
                            <option value=""></option>
                            <option value="0">No</option>
                            <option value="1">Yes</option>
                        </select>
                    </div>

                    <div class="buttonrow">
                        <input type="submit" value="Save" class="button ui-corner-top" />
                    </div>
					
                    </form>
                                        
				</fieldset>                    
            
            	<!--- Arrival Information --->
                <fieldset>
					
                    <legend>Arrival to USA Information</legend>

                    <div class="table">
                        <div class="thCenter">
                            <div class="tdSmall">Date</div>
                            <div class="tdLarge">Depart <br /> City</div>
                            <div class="tdSmall">Depart <br /> Airport Code</div>
                            <div class="tdLarge">Arrive <br /> City</div>
                            <div class="tdSmall">Arrive <br /> Airport Code</div>
                            <div class="tdSmall">Flight <br /> Number</div>
                            <div class="tdSmall">Depart <br /> Time</div>
                            <div class="tdSmall">Arrive <br /> Time</div>
                            <div class="tdSmall">Overnight <br /> Flight</div>
                            <div class="tdSmall">Actions</div>
                            <div class="clearBoth"></div>
						</div>                            
                        <!--- Arrival is populated here --->
                        <div id="arrivalList"></div>
					</div>
					
                </fieldset>
				
                <!--- Departure Information --->
                <fieldset>
                   
                    <legend>Departure from USA Information</legend>

                    <div class="table">
                        
                        <div class="thCenter">
                            <div class="tdSmall">Date</div>
                            <div class="tdLarge">Depart <br /> City</div>
                            <div class="tdSmall">Depart <br /> Airport Code</div>
                            <div class="tdLarge">Arrive <br /> City</div>
                            <div class="tdSmall">Arrive <br /> Airport Code</div>
                            <div class="tdSmall">Flight <br /> Number</div>
                            <div class="tdSmall">Depart <br /> Time</div>
                            <div class="tdSmall">Arrive <br /> Time</div>
                            <div class="tdSmall">Overnight <br /> Flight</div>
                            <div class="tdSmall">Actions</div>
                            <div class="clearBoth"></div>
						</div>                            
                        <!--- Departure is populated here --->
                        <div id="departureList"></div>
					</div>

                </fieldset>

                <div class="buttonrow">
                    <input type="submit" value="Add Flight" onclick="javascript:displayForm();" class="button ui-corner-top" />
                </div>
                    
            </div>
            
        </div>
        
    </div>

<!--- Page Footer --->
<gui:pageFooter
	footerType="application"
/>

</cfoutput>
