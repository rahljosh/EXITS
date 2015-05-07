<!--- ------------------------------------------------------------------------- ----
	
	File:		_flightInfo.cfm
	Author:		Marcus Melo
	Date:		January 12, 2010
	Desc:		Inserts/Updates Students flight information

	Updated:  	03/09/2012 - Added date input
				04/27/2011 - Combining flight information files (form/intrep)
				04/26/2011 - Added pre-ayp arrival section / Jquery Modal
				01/14/2010 - Reorganized - Marcus Melo
				01/14/2010 - Added datePicker - Marcus Melo
				09/29/2005 - revised by Josh Rahl

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />
    
    <!--- Ajax Call to the Component --->
    <cfajaxproxy cfc="nsmg.extensions.components.student" jsclassname="StudentComponent">

    <!--- Delete Flight Information --->
    <cfparam name="URL.uniqueID" type="string" default="">
    <cfparam name="URL.flightID" default="0">
    <cfparam name="URL.programID" default="0">
    <cfparam name="URL.subAction" default="">
		        
	<!--- Param GLOBAL FORM Variables --->
    <cfparam name="FORM.subAction" type="string"  default="">
    <cfparam name="FORM.uniqueID" type="string" default="">
    <cfparam name="FORM.programID" type="string" default="0">
    <cfparam name="FORM.flightNotes" type="string" default="">
    <cfparam name="FORM.preAYPArrivalCount" default="0">
    <cfparam name="FORM.arrivalCount" default="0">
    <cfparam name="FORM.departureCount" default="0">
    <cfparam name="FORM.dateCreated" default="">
	
    <cfif LEN(URL.subAction)>
    	<cfset FORM.subAction = URL.subAction>
    </cfif>    
    
    <cfscript>
		// Check if there is a valid URL variable
		if ( LEN(URL.uniqueID) AND NOT LEN(FORM.uniqueID) ) {
			FORM.uniqueID = URL.uniqueID;	
		}
		
		if ( VAL(URL.programID) ) {
			FORM.programID = URL.programID;
		}
		
		// Get Student Information
		qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentFullInformationByID(uniqueID=FORM.uniqueID);
		
		// Check if it's an Active PHP Student
		qGetPHPStudentInfo = APPLICATION.CFC.STUDENT.getPHPStudent(studentID=qGetStudentInfo.studentID,programID=FORM.programID);
		
		if ( qGetPHPStudentInfo.recordCount EQ 1 ) {
			// Use PHP Data Instead
			qGetStudentInfo = qGetPHPStudentInfo;
		}
		
		// Get School Dates
		qGetSchoolDates = APPLICATION.CFC.SCHOOL.getSchoolDates(schoolID=qGetStudentInfo.schoolID, programID=qGetStudentInfo.programID);
		vSchoolEndDate = qGetSchoolDates.endDate;
		if (IsDate(qGetSchoolDates.endDate)) {
			vSchoolEndDate = DateFormat(qGetSchoolDates.endDate,'mm/dd/yyyy');	
		}
		
		// Check if the user is an office user
		vOfficeUser = APPLICATION.CFC.USER.isOfficeUser(CLIENT.usertype);
	
		// Could Not find Student
		if ( NOT VAL(qGetStudentInfo.recordCount) ) {
			// Set Page Message
			SESSION.formErrors.Add("Student could not be found. Please try again.");
		}
		
		// Delete Flight Information
        if ( VAL(URL.flightID) AND VAL(qGetStudentInfo.studentID) ) {

			APPLICATION.CFC.STUDENT.deleteFlightInformation(
				flightID=URL.flightID,
				studentID=qGetStudentInfo.studentID,
				enteredByID=CLIENT.userID
			);

			// Set Page Message
			SESSION.pageMessages.Add("Flight Successfully Deleted.");
		
		}		
    </cfscript>
    
    
    <!--- Unblock all flights as per Paul - 5/7/2015 --->
    <cfset qGetStudentInfo.unblockFlight = 1>


	<!--- FORM SUBMITTED | Insert / Update --->
	<cfif FORM.subAction EQ 'update'>
		
		<cfscript>
            // Update Flight Notes
            APPLICATION.CFC.STUDENT.updateFlightNotes(studentID=qGetStudentInfo.studentID, flightNotes=FORM.flightNotes);
        </cfscript>

        <!-------------------------------------
			START OF PRE-AYP FLIGHT INFORMATION
		-------------------------------------->
		
		<!--- New Flight Information --->
        <cfloop From="1" to="4" Index="i">
            
            <!--- Param specific FORM Variables --->
            <cfparam name="FORM.incomingNewPreAYPFlightNumber#i#" default="">
            <cfparam name="FORM.incomingNewPreAYPDepartureCity#i#" default="">
            <cfparam name="FORM.incomingNewPreAYPDepartureAirCode#i#" default="">
            <cfparam name="FORM.incomingNewPreAYPDepartureDate#i#" default="">
            <cfparam name="FORM.incomingNewPreAYPDepartureTime#i#" default="">
            <cfparam name="FORM.incomingNewPreAYPArrivalCity#i#" default="">
            <cfparam name="FORM.incomingNewPreAYPArrivalAirCode#i#" default="">
            <cfparam name="FORM.incomingNewPreAYPArrivalTime#i#" default="">
            <cfparam name="FORM.incomingNewPreAYPOvernight#i#" default="0">
            <cfparam name="FORM.incomingNewPreAYPDateCreated#i#" default="">
            
            <cfscript>
                if ( LEN(FORM["incomingNewPreAYPDepartureDate" & i]) ) {
                    
                    APPLICATION.CFC.STUDENT.insertFlightInfo(
                        studentID=qGetStudentInfo.studentID,
						companyID=qGetStudentInfo.companyID,
						programID=FORM.programID,
						enteredByID=CLIENT.userID,
                        flightNumber=FORM["incomingNewPreAYPFlightNumber" & i],
                        depCity=FORM["incomingNewPreAYPDepartureCity" & i],
                        depAirCode=FORM["incomingNewPreAYPDepartureAirCode" & i],
                        depDate=FORM["incomingNewPreAYPDepartureDate" & i],
                        depTime=FORM["incomingNewPreAYPDepartureTime" & i],
                        arrivalCity=FORM["incomingNewPreAYPArrivalCity" & i],
                        arrivalAirCode=FORM["incomingNewPreAYPArrivalAirCode" & i],
                        arrivalTime=FORM["incomingNewPreAYPArrivalTime" & i],
                        overNight=FORM["incomingNewPreAYPOvernight" & i],
                        flightType='preAYPArrival'
                    );
                    
                }
            </cfscript>
            
        </cfloop>
            
        <!--- Update Flight Information --->
        <cfloop From="1" To="#FORM.preAYPArrivalCount#" Index="i">
            
            <!--- Param specific FORM Variables --->
            <cfparam name="FORM.incomingPreAYPflightID#i#" default="">
            <cfparam name="FORM.incomingPreAYPFlightNumber#i#" default="">
            <cfparam name="FORM.incomingPreAYPDepartureCity#i#" default="">
            <cfparam name="FORM.incomingPreAYPDepartureAirCode#i#" default="">
            <cfparam name="FORM.incomingPreAYPDepartureDate#i#" default="">
            <cfparam name="FORM.incomingPreAYPDepartureTime#i#" default="">
            <cfparam name="FORM.incomingPreAYPArrivalCity#i#" default="">
            <cfparam name="FORM.incomingPreAYPArrivalAirCode#i#" default="">
            <cfparam name="FORM.incomingPreAYPArrivalTime#i#" default="">
            <cfparam name="FORM.incomingPreAYPOvernight#i#" default="0">
            
            <cfscript>
                APPLICATION.CFC.STUDENT.updateFlightInfo(
                    flightID=FORM["incomingPreAYPflightID" & i],
					studentID=qGetStudentInfo.studentID,
					companyID=qGetStudentInfo.companyID,
					programID=FORM.programID,
					enteredByID=CLIENT.userID,
                    flightNumber=FORM["incomingPreAYPFlightNumber" & i],
                    depCity=FORM["incomingPreAYPDepartureCity" & i],
                    depAirCode=FORM["incomingPreAYPDepartureAirCode" & i],
                    depDate=FORM["incomingPreAYPDepartureDate" & i],
                    depTime=FORM["incomingPreAYPDepartureTime" & i],
                    arrivalCity=FORM["incomingPreAYPArrivalCity" & i],
                    arrivalAirCode=FORM["incomingPreAYPArrivalAirCode" & i],
                    arrivalTime=FORM["incomingPreAYPArrivalTime" & i],
                    overNight=FORM["incomingPreAYPOvernight" & i],
                    flightType='preAYPArrival'
                );
            </cfscript>
            
        </cfloop>
        <!-------------------------------------
			END OF PRE-AYP FLIGHT INFORMATION
		-------------------------------------->
        
        
        <!-------------------------------------
			START OF ARRIVAL FLIGHT INFORMATION
		-------------------------------------->
        
		<!--- New Flight Information --->
        <cfloop From="1" to="4" Index="i">
            
            <!--- Param specific FORM Variables --->
            <cfparam name="FORM.incomingNewFlightNumber#i#" default="">
            <cfparam name="FORM.incomingNewDepartureCity#i#" default="">
            <cfparam name="FORM.incomingNewDepartureAirCode#i#" default="">
            <cfparam name="FORM.incomingNewDepartureDate#i#" default="">
            <cfparam name="FORM.incomingNewDepartureTime#i#" default="">
            <cfparam name="FORM.incomingNewArrivalCity#i#" default="">
            <cfparam name="FORM.incomingNewArrivalAirCode#i#" default="">
            <cfparam name="FORM.incomingNewArrivalTime#i#" default="">
            <cfparam name="FORM.incomingNewOvernight#i#" default="0">
            
            <cfscript>
                if ( LEN(FORM["incomingNewDepartureDate" & i]) ) {
                    
                    APPLICATION.CFC.STUDENT.insertFlightInfo(
                        studentID=qGetStudentInfo.studentID,
						companyID=qGetStudentInfo.companyID,
						programID=FORM.programID,
						enteredByID=CLIENT.userID,
                        flightNumber=FORM["incomingNewFlightNumber" & i],
                        depCity=FORM["incomingNewDepartureCity" & i],
                        depAirCode=FORM["incomingNewDepartureAirCode" & i],
                        depDate=FORM["incomingNewDepartureDate" & i],
                        depTime=FORM["incomingNewDepartureTime" & i],
                        arrivalCity=FORM["incomingNewArrivalCity" & i],
                        arrivalAirCode=FORM["incomingNewArrivalAirCode" & i],
                        arrivalTime=FORM["incomingNewArrivalTime" & i],
                        overNight=FORM["incomingNewOvernight" & i],
                        flightType='arrival'
                    );
                    
                }
            </cfscript>
            
        </cfloop>
        
        <!--- Update Flight Information --->    
        <cfloop From="1" To="#FORM.arrivalCount#" Index="i">
            
            <!--- Param specific FORM Variables --->
            <cfparam name="FORM.incomingflightID#i#" default="">
            <cfparam name="FORM.incomingFlightNumber#i#" default="">
            <cfparam name="FORM.incomingDepartureCity#i#" default="">
            <cfparam name="FORM.incomingDepartureAirCode#i#" default="">
            <cfparam name="FORM.incomingDepartureDate#i#" default="">
            <cfparam name="FORM.incomingDepartureTime#i#" default="">
            <cfparam name="FORM.incomingArrivalCity#i#" default="">
            <cfparam name="FORM.incomingArrivalAirCode#i#" default="">
            <cfparam name="FORM.incomingArrivalTime#i#" default="">
            <cfparam name="FORM.incomingOvernight#i#" default="0">
            
            <cfscript>
                APPLICATION.CFC.STUDENT.updateFlightInfo(
                    flightID=FORM["incomingflightID" & i],
					studentID=qGetStudentInfo.studentID,
					companyID=qGetStudentInfo.companyID,
					programID=FORM.programID,
					enteredByID=CLIENT.userID,
                    flightNumber=FORM["incomingFlightNumber" & i],
                    depCity=FORM["incomingDepartureCity" & i],
                    depAirCode=FORM["incomingDepartureAirCode" & i],
                    depDate=FORM["incomingDepartureDate" & i],
                    depTime=FORM["incomingDepartureTime" & i],
                    arrivalCity=FORM["incomingArrivalCity" & i],
                    arrivalAirCode=FORM["incomingArrivalAirCode" & i],
                    arrivalTime=FORM["incomingArrivalTime" & i],
                    overNight=FORM["incomingOvernight" & i]
                );
            </cfscript>
            
        </cfloop>
            
        <!-------------------------------------
			END OF ARRIVAL FLIGHT INFORMATION
		-------------------------------------->
        
        
        <!---------------------------------------
			START OF DEPARTURE FLIGHT INFORMATION
		---------------------------------------->
        
		<!--- New Flight Information --->    
        <cfloop From="1" to="4" Index="i">
            
            <!--- Param specific FORM Variables --->
            <cfparam name="FORM.outgoingNewFlightNumber#i#" default="">
            <cfparam name="FORM.outgoingNewDepartureCity#i#" default="">
            <cfparam name="FORM.outgoingNewDepartureAirCode#i#" default="">
            <cfparam name="FORM.outgoingNewDepartureDate#i#" default="">
            <cfparam name="FORM.outgoingNewDepartureTime#i#" default="">
            <cfparam name="FORM.outgoingNewArrivalCity#i#" default="">
            <cfparam name="FORM.outgoingNewArrivalAirCode#i#" default="">
            <cfparam name="FORM.outgoingNewArrivalTime#i#" default="">
            <cfparam name="FORM.outgoingNewOvernight#i#" default="0">
            
            <cfscript>
                if ( LEN(FORM["outgoingNewDepartureDate" & i]) ) {
                    
                    APPLICATION.CFC.STUDENT.insertFlightInfo(
                        studentID=qGetStudentInfo.studentID,
						companyID=qGetStudentInfo.companyID,
						programID=FORM.programID,
						enteredByID=CLIENT.userID,
                        flightNumber=FORM["outgoingNewFlightNumber" & i],
                        depCity=FORM["outgoingNewDepartureCity" & i],
                        depAirCode=FORM["outgoingNewDepartureAirCode" & i],
                        depDate=FORM["outgoingNewDepartureDate" & i],
                        depTime=FORM["outgoingNewDepartureTime" & i],
                        arrivalCity=FORM["outgoingNewArrivalCity" & i],
                        arrivalAirCode=FORM["outgoingNewArrivalAirCode" & i],
                        arrivalTime=FORM["outgoingNewArrivalTime" & i],
                        overNight=FORM["outgoingNewOvernight" & i],
                        flightType='departure'
                    );
                    
                }
            </cfscript>

        </cfloop>
            
        <!--- Update Flight Information --->
        <cfloop From="1" To="#FORM.departureCount#" Index="i">

            <!--- Param specific FORM Variables --->
            <cfparam name="FORM.outgoingflightID#i#" default="0">
            <cfparam name="FORM.outgoingFlightNumber#i#" default="">
            <cfparam name="FORM.outgoingDepartureCity#i#" default="">
            <cfparam name="FORM.outgoingDepartureAirCode#i#" default="">
            <cfparam name="FORM.outgoingDepartureDate#i#" default="">
            <cfparam name="FORM.outgoingDepartureTime#i#" default="">
            <cfparam name="FORM.outgoingArrivalCity#i#" default="">
            <cfparam name="FORM.outgoingArrivalAirCode#i#" default="">
            <cfparam name="FORM.outgoingArrivalTime#i#" default="">
            <cfparam name="FORM.outgoingOvernight#i#" default="0">
            
            <cfscript>
                APPLICATION.CFC.STUDENT.updateFlightInfo(
                    flightID=FORM["outgoingflightID" & i],
					studentID=qGetStudentInfo.studentID,
					companyID=qGetStudentInfo.companyID,
					programID=FORM.programID,
					enteredByID=CLIENT.userID,
                    flightNumber=FORM["outgoingFlightNumber" & i],
                    depCity=FORM["outgoingDepartureCity" & i],
                    depAirCode=FORM["outgoingDepartureAirCode" & i],
                    depDate=FORM["outgoingDepartureDate" & i],
                    depTime=FORM["outgoingDepartureTime" & i],
                    arrivalCity=FORM["outgoingArrivalCity" & i],
                    arrivalAirCode=FORM["outgoingArrivalAirCode" & i],
                    arrivalTime=FORM["outgoingArrivalTime" & i],
                    overNight=FORM["outgoingOvernight" & i]
                );
            </cfscript>
            
        </cfloop>
        <!---------------------------------------
			END OF DEPARTURE FLIGHT INFORMATION
		---------------------------------------->

        <cfscript>
			// Send out email notification if flight information was entered by an International Representative / Branch
			if ( ListFind("8,11,13", CLIENT.userType) ) {	 
				APPLICATION.CFC.STUDENT.emailFlightInformation(studentID=qGetStudentInfo.studentID,isPHPStudent=VAL(qGetPHPStudentInfo.recordCount) );
			}
			
			// Set Page Message
			SESSION.pageMessages.Add("Flight Information Updated");
		</cfscript>


	<cfelseif FORM.subAction EQ 'emailRegionalManager'>
    
        <cfscript>
			// Send out email notification to the regional manager
			APPLICATION.CFC.STUDENT.emailFlightInformation(studentID=qGetStudentInfo.studentID, sendEmailTo='regionalManager', isPHPStudent=VAL(qGetPHPStudentInfo.recordCount) );
			
			// Set Page Message
			SESSION.pageMessages.Add("Flight Information emailed to the Regional Manager");
		</cfscript>
            
    <cfelseif FORM.subAction EQ 'emailCurrentUser'>

        <cfscript>
			// Send out email notification to the current user
			APPLICATION.CFC.STUDENT.emailFlightInformation(studentID=qGetStudentInfo.studentID, sendEmailTo='currentUser', isPHPStudent=VAL(qGetPHPStudentInfo.recordCount) );

			// Set Page Message
			SESSION.pageMessages.Add("Flight Information emailed to you");
		</cfscript>
            
    </cfif> 
	<!--- END OF FORM.subAction --->

    <cfscript>
		// Get Flight According to Program
		
		// Get Pre-AYP Arrival
		qGetPreAYPArrival = APPLICATION.CFC.STUDENT.getFlightInformation(studentID=VAL(qGetStudentInfo.studentID), programID=qGetStudentInfo.programID, flightType="preAYPArrival");

		// Get Arrival
		qGetArrival = APPLICATION.CFC.STUDENT.getFlightInformation(studentID=VAL(qGetStudentInfo.studentID), programID=qGetStudentInfo.programID, flightType="arrival");

		// Get Departure
		qGetDeparture = APPLICATION.CFC.STUDENT.getFlightInformation(studentID=VAL(qGetStudentInfo.studentID), programID=qGetStudentInfo.programID, flightType="departure");
		
	</cfscript>

</cfsilent>

<cfoutput>

	<!--- Page Header --->
    <gui:pageHeader
        headerType="applicationNoHeader"
    />	

		<script type="text/javascript" language="javascript">
            <!--
			
			// Function to make sure the departure date is after the school end date.
			function checkSchoolDate(enteredDate,schoolEndDate,fieldID) {
				if (schoolEndDate != "n/a") {
					var jsEnteredDate = new Date(enteredDate.substring(6),enteredDate.substring(0,2),enteredDate.substring(3,5));
					var jsSchoolDate = new Date(schoolEndDate.substring(6),schoolEndDate.substring(0,2),schoolEndDate.substring(3,5));
					jsSchoolDate.setDate(jsSchoolDate.getDate()+1);
					if (jsEnteredDate-jsSchoolDate < 0) {
						var actualSchoolDate = jsSchoolDate.getDate() - 1;
						alert("You must enter a date after the school end date: " + jsSchoolDate.getMonth() + "/" + actualSchoolDate + "/" + jsSchoolDate.getFullYear());
						$("##"+fieldID).val("");
					}
				} else {
					alert("There must be a school end date before you can assign a departure date.");	
				}
			}
			
            function areYouSure() { 
               if(confirm("You are about to delete this flight information. \n Click OK to continue")) { 
                    return true; 
               } else { 
                    return false; 
               } 
            } 
            
            /* Script to show certain fields */
            function changeDiv(the_div,the_change)
            {
              var the_style = getStyleObject(the_div);
              if (the_style != false) {
                the_style.display = the_change;
              }
            }
            
            function getStyleObject(objectId) {
                if (document.getElementById && document.getElementById(objectId)) {
                return document.getElementById(objectId).style;
                } else if (document.all && document.all(objectId)) {
                return document.all(objectId).style;
                } else {
                return false;
                }
            }
            
            function extensiondate(startdate,enddate) {
            if (document.flightInformation.insu_dp_trans_type.value == 'extension') {
                    document.flightInformation.insu_dp_new_date.value = (startdate);
                } else {
                    document.flightInformation.insu_dp_new_date.value = "";
                }
            if (document.flightInformation.insu_dp_trans_type.value == 'early return') {
                    document.flightInformation.insu_dp_end_date.value = (enddate);
                } else {
                    document.flightInformation.insu_dp_end_date.value = ""
                }
            }
			
			function checkForm() {
				
				removeRedBorders();
				var missing = "";
				
				// Get the form elements
				var elem = document.getElementById('flightInformation').elements;
				
				// Loop through the form elements
				for (var i=0; i<elem.length; i++) {
					// Check for form elements with values
					if ( (elem[i].value != '') && ( !isNaN(elem[i].name[elem[i].name.length-1]) && (elem[i].name.indexOf('Overnight') == -1) ) ) {
						
						// Get the form elements again
						var tempElem = document.getElementById('flightInformation').elements;
						
						// Loop through the form elements
						for (var j=0; j<tempElem.length; j++) {
							if ( (getLegNumber(tempElem[j].name) == getLegNumber(elem[i].name)) && (getFlightType(tempElem[j].name) == getFlightType(elem[i].name)) ) {
								if ( (tempElem[j].name.indexOf('Overnight') == -1) && (tempElem[j].value == '') ) {
									missing = missing + tempElem[j].name + ',';
								}
							}
						}
					}
				}
				
				if (missing != "") {
					alert("You are missing 1 or more required fields, please correct the form and try again.");
					showRedBorders(missing);
				} else {
					$("##flightInformation").submit();
				}
				
			}
			
			// This function gets the type of flight from a given string
			function getFlightType(inputString) {
				var type = "";
				
				// Incoming Flight
				if (inputString.indexOf("incoming") !== -1) {
					if (inputString.indexOf("New") !== -1) {
						if (inputString.indexOf("PreAYP") !== -1) {
							type = "incomingNewPreAYP";
						} else {
							type = "incomingNew";
						}
					} else {
						if (inputString.indexOf("PreAYP") !== -1) {
							type = "incomingPreAYP";
						} else {
							type = "incoming";
						}
					}
				}
				// Outgoing Flight
				else if (inputString.indexOf("outgoing") !== -1) {
					if (inputString.indexOf("New") !== -1) {
						type = "outgoingNew";	
					} else {
						type = "outgoing";	
					}
				}
				
				return type;
			}
			
			// This function gets the number at the end of a given string
			function getLegNumber(inputString) {
				// This finds the leg number.
				var index = inputString.length-1;
				var num = true;
				while (num) {
					if (!isNaN(inputString[index])) {
						index = index - 1;
					} else {
						num = false;	
					}
				}
				return inputString.substring(index+1);
			}
			
			// This function shows red borders around the missing input fields
			function showRedBorders(missing) {
				while (missing.length > 1) {
					if (missing.indexOf(',') == -1) {
						field = missing;
						missing = "";
					} else {
						field = missing.substring(0, missing.indexOf(','));
						missing = missing.substring(missing.indexOf(',')+1);
					}
					$("input[name='" + field + "']").css("border", "1px solid red");
				}
			}
			
			// This function removes any borders from the input fields
			function removeRedBorders() {
				var elem = document.getElementById('flightInformation').elements;
				for (var i=0; i<elem.length; i++) {
					$("input[name='" + elem[i].name + "']").css("border", "1px solid ##999999");	
				}
			}
			
			var Student = new StudentComponent();
			
			function changeBlockedFlight() {
				newValue = 0;
				if ($("##unblockFlight").is(":checked")) {
					newValue = 1;
				} else {
					newValue = 0;
				}
				Student.unblockFlights(#qGetStudentInfo.studentID#,newValue);
				window.location.reload();
			}
			
            // -->
        </script>

		<cfif LEN(FORM.subAction) AND NOT SESSION.formErrors.length()>
        
            <script language="javascript">
                // Close Window After 2 Seconds
                setTimeout(function() { parent.$.fn.colorbox.close(); }, 3000);
            </script>
        
        </cfif>

		<!--- Table Header --->
        <gui:tableHeader
            imageName="students.gif"
            tableTitle="Flight Information"
            tableRightTitle="#qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# (###qGetStudentInfo.studentID#)"
            width="98%"
            imagePath="../"
        />    
        
		<!--- Page Messages --->
        <gui:displayPageMessages 
            pageMessages="#SESSION.pageMessages.GetCollection()#"
            messageType="tableSection"
            width="98%"
            />

        <!--- Form Errors --->
        <gui:displayFormErrors 
            formErrors="#SESSION.formErrors.GetCollection()#"
            messageType="tableSection"
            width="98%"
            />
            
     	<cfsavecontent variable="flightInformation">

            <table width="98%" border="0" cellpadding="4" cellspacing="0" class="section" align="center">
                <tr>
                    <td>
    
                        <!--- EMAIL FLIGHT INFORMATION / Only Office Users --->
                        <cfif ListFind("1,2,3,4", CLIENT.userType) AND ( qGetPreAYPArrival.recordCount OR qGetArrival.recordCount OR qGetDeparture.recordCount )>
                            <table align="center" width="99%" bordercolor="##C0C0C0" valign="top" cellpadding="3" cellspacing="1" style="border:1px solid ##CCC">
                                <tr bgcolor="##D5DCE5">
                                    <td align="center" width="50%">REGIONAL DIRECTOR</td>
                                    <td align="center" width="50%">YOURSELF</td>
                                </tr>
                                <tr bgcolor="##D5DCE5">
                                    <td align="center" width="50%">
                                        <form name="emailRegionalManager" action="#CGI.SCRIPT_NAME#" method="post">
                                            <input type="hidden" name="subAction" value="emailRegionalManager" />
                                            <input type="hidden" name="uniqueID" value="#qGetStudentInfo.uniqueID#" />
                                            <input type="hidden" name="programID" value="#qGetStudentInfo.programID#" />
                                            <input type="image" src="../pics/sendemail.gif" value="send email">
                                        </form>
                                        <font size="-2" color="##CC6600"><b>Be sure you have updated the flight information before sending the e-mail to the Regional Director.</b></font>
                                    </td>
                                    <td align="center" width="50%">
                                        <form name="emailCurrentUser" action="#CGI.SCRIPT_NAME#" method="post">
                                            <input type="hidden" name="subAction" value="emailCurrentUser" />
                                            <input type="hidden" name="uniqueID" value="#qGetStudentInfo.uniqueID#" />
                                            <input type="hidden" name="programID" value="#qGetStudentInfo.programID#" />
                                            <input type="image" src="../pics/sendemail.gif" value="send email">
                                        </form>
                                        <font size="-2" color="##CC6600"><b>Be sure you have updated the flight information before sending the e-mail to yourself.</b></font>
                                    </td>
                                </tr>
                            </table>
                            
                            <br />
                        </cfif>
                        
                        <!--- Message to International Representative --->
                        <cfif ListFind("8,11,13", CLIENT.userType) AND qGetStudentInfo.insurance_typeid GT 1>
                            <p align="center" style="color:##F00">
                                * Please be aware that flight information provided by you will affect the student's insurance start or end date.<br />
                                Please submit only confirmed arrivals/departures.
                            </p>
                            <p align="center" style="color:##F00; font-weight:bold;">
                                PS: Date, Depart Airport Code, Arrival Airport Code and Flight Number are required for a complete flight information.
                            </p>
                        </cfif>
            
                        <form name="flightInformation" id="flightInformation" action="#CGI.SCRIPT_NAME#" method="post">
                        <input type="hidden" name="subAction" value="update" />
                        <input type="hidden" name="uniqueID" value="#qGetStudentInfo.uniqueID#" />
                        <input type="hidden" name="programID" value="#qGetStudentInfo.programID#" />
                        
                        <!--- PRE-AYP ARRIVAL INFORMATION --->
                        <cfif VAL(qGetStudentInfo.AYPEnglish) OR VAL(qGetStudentInfo.AYPOrientation)>
                            
                            <table align="center" width="99%" bordercolor="##C0C0C0" valign="top" cellpadding="3" cellspacing="1" style="border:1px solid ##CCC">
                                <th colspan="12" bgcolor="##A0D69A"> P R E - A Y P &nbsp;&nbsp; A R R I V A L &nbsp; &nbsp; I N F O R M A T I O N </th>
                                <tr bgcolor="##A0D69A">
                                    <!--- Delete Option --->    
                                    <cfif ListFind("1,2,3,4,8,11,13", CLIENT.userType)>                            
                                        <th><font size="-2">Delete</font></th>
                                    </cfif>                                    
                                    <th>Date <br /> (mm/dd/yyyy)</th>
                                    <th>Depart <br /> City</th>
                                    <th>Depart <br /> Airport Code</th>
                                    <th>Arrive <br /> City</th>
                                    <th>Arrive <br /> Airport Code</th>
                                    <th>Flight <br /> Number</th>
                                    <th>Depart Time <br /> (12:00 AM)</th>
                                    <th>Arrive Time <br /> (12:00 AM)</th>
                                    <th>Overnight <br /> Flight</th>
                                    <th>Date Input</th>
                                    <th><font size="-2">Status</font></th>
                                </tr>
                                
                                <!--- EDIT FLIGHT INFORMATION --->
                                <input type="hidden" name="preAYPArrivalCount" value='#qGetPreAypArrival.recordcount#'>
                                <cfloop query="qGetPreAypArrival">
                                    <input type="hidden" name="incomingPreAYPflightID#qGetPreAypArrival.currentrow#" value="#qGetPreAypArrival.flightID#">
                                    <tr bgcolor="##DDF0DD" align="center">  
                                        <!--- Delete Option --->                      
                                        <cfif ListFind("1,2,3,4,8,11,13", CLIENT.userType)>
                                            <td align="center">
                                                <a href="#CGI.SCRIPT_NAME#?uniqueID=#qGetStudentInfo.uniqueID#&flightID=#flightID#" onClick="return areYouSure(this);"><img src="../pics/deletex.gif" border="0"></img></a>
                                            </td>
                                        </cfif>
                                        <td><input type="text" name="incomingPreAYPDepartureDate#qGetPreAypArrival.currentrow#" value="#DateFormat(dep_date , 'mm/dd/yyyy')#" class="datePicker" maxlength="10"></td>
                                        <td><input type="text" name="incomingPreAYPDepartureCity#qGetPreAypArrival.currentrow#" class="fieldSize100" maxlength="40" value="#dep_city#" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                                        <td><input type="text" name="incomingPreAYPDepartureAirCode#qGetPreAypArrival.currentrow#" class="fieldSize40" maxlength="3" value="#dep_aircode#" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                                        <td><input type="text" name="incomingPreAYPArrivalCity#qGetPreAypArrival.currentrow#" class="fieldSize100" maxlength="40" value="#arrival_city#" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                                        <td><input type="text" name="incomingPreAYPArrivalAirCode#qGetPreAypArrival.currentrow#" class="fieldSize40" maxlength="3" value="#arrival_aircode#" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                                        <td><input type="text" name="incomingPreAYPFlightNumber#qGetPreAypArrival.currentrow#" class="fieldSize60" maxlength="8" value="#flight_number#" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                                        <td><input type="text" name="incomingPreAYPDepartureTime#qGetPreAypArrival.currentrow#" class="fieldSize70 timePicker" maxlength="8" value="#TimeFormat(dep_time, 'hh:mm tt')#"></td>
                                        <td><input type="text" name="incomingPreAYPArrivalTime#qGetPreAypArrival.currentrow#" class="fieldSize70 timePicker" maxlength="8" value="#TimeFormat(arrival_time, 'h:mm tt')#"></td>
                                        <td align="center"><input type="checkbox" name="incomingPreAYPOvernight#qGetPreAypArrival.currentrow#" value="1" <cfif VAL(qGetPreAypArrival.overnight)> checked="checked" </cfif> ></td>
                                        <td>#DateFormat(qGetPreAypArrival.dateCreated, 'mm/dd/yyyy')#</td> 
                                        <td align="center">
                                            <cfif LEN(qGetPreAypArrival.flight_number)>
                                                <a href="http://dps1.travelocity.com/dparflifo.ctl?aln_name=#left(qGetPreAypArrival.flight_number,2)#&flt_num=#RemoveChars(qGetPreAypArrival.flight_number,1,2)#" target="blank"><img src="../pics/arrow.gif" border="0"></img></a>
                                            <cfelse>
                                                n/a
                                            </cfif>
                                        </td>
                                    </tr>	
                                </cfloop>
    
                                <!--- NEW FLIGHT INFORMATION --->
                                <cfif ListFind("1,2,3,4,8,11,13", CLIENT.userType)>
                                    
                                    <cfloop from="1" to="4" index="i"> 
                                        <tr bgcolor="##DDF0DD" align="center" class="trNewPreAYPArrival <cfif qGetPreAypArrival.recordCount> displayNone </cfif>">
                                            <td>&nbsp;</td>
                                            <td><input type="text" name="incomingNewPreAYPDepartureDate#i#" class="datePicker" maxlength="10"></td>
                                            <td><input type="text" name="incomingNewPreAYPDepartureCity#i#" class="fieldSize100" maxlength="40" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                                            <td><input type="text" name="incomingNewPreAYPDepartureAirCode#i#" class="fieldSize40" maxlength="3" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                                            <td><input type="text" name="incomingNewPreAYPArrivalCity#i#" class="fieldSize100" maxlength="40" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                                            <td><input type="text" name="incomingNewPreAYPArrivalAirCode#i#" class="fieldSize40" maxlength="3" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                                            <td><input type="text" name="incomingNewPreAYPFlightNumber#i#" class="fieldSize60" maxlength="8" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                                            <td><input type="text" name="incomingNewPreAYPDepartureTime#i#" class="fieldSize70 timePicker" class="timePicker" maxlength="8"></td>
                                            <td><input type="text" name="incomingNewPreAYPArrivalTime#i#" class="fieldSize70 timePicker" maxlength="8"></td>
                                            <td align="center"><input type="checkbox" name="incomingNewPreAYPOvernight#i#" value="1"></td>
                                            <td>&nbsp;</td> 
                                            <td align="center">&nbsp;</td>
                                        </tr>
                                    </cfloop>
                                    
                                    <cfif qGetPreAypArrival.recordCount>
                                        <tr bgcolor="##DDF0DD"><td colspan="12" align="center"><a href="javascript:displayClass('trNewPreAYPArrival');">Click here to add more legs</a></td></tr>
                                    </cfif>
                                    
                                </cfif>
                                
                                <cfif qGetPreAypArrival.recordCount>
                                    <tr bgcolor="##DDF0DD">
                                        <td colspan="12" align="center"><font size=-1>*Flight tracking information by Travelocity, not all flights will be available. #CLIENT.companyShort# is not responsible for information on or gathered from travelocity.com.</font></td>
                                    </tr>
                                </cfif>
                                              
                            </table> 
                            <br />
            
                        </cfif>            
                        
                        
                        <!--- A R R I V A L    I N F O R M A T I O N --->
                        <table align="center" width="99%" bordercolor="##C0C0C0" valign="top" cellpadding="3" cellspacing="1" style="border:1px solid ##CCC">
                            <th colspan="12" bgcolor="##ACB9CD"> A R R I V A L &nbsp;&nbsp; T O &nbsp; &nbsp; H O S T &nbsp; &nbsp; F A M I L Y &nbsp; &nbsp; I N F O R M A T I O N </th>
    
                            <tr bgcolor="##ACB9CD">
                                <td colspan="12">
                                    Arrival/Departure Airport: <cfif LEN(qGetStudentInfo.airport_city)>#qGetStudentInfo.airport_city# <cfelse> n/a </cfif>
                                    - Airport Code: <cfif LEN(qGetStudentInfo.major_air_code)>#qGetStudentInfo.major_air_code# <cfelse> n/a </cfif>
                                </td>
                            </tr> 
                            
                            <tr bgcolor="##ACB9CD">
                                <td colspan="12">
                                    School Start Date: <cfif LEN(qGetSchoolDates.startDate)>#qGetSchoolDates.startDate# <cfelse> n/a </cfif>
                                </td>
                            </tr> 
                            
                            <tr bgcolor="##ACB9CD">
                                <!--- Delete Option --->    
                                <cfif ListFind("1,2,3,4,8,11,13", CLIENT.userType)>                            
                                    <th><font size="-2">Delete</font></th>
                                </cfif>                                    
                                <th>Date <br /> (mm/dd/yyyy)</th>
                                <th>Depart <br /> City</th>
                                <th>Depart <br /> Airport Code</th>
                                <th>Arrive <br /> City</th>
                                <th>Arrive <br /> Airport Code</th>
                                <th>Flight <br /> Number</th>
                                <th>Depart Time <br /> (12:00 AM)</th>
                                <th>Arrive Time <br /> (12:00 AM)</th>
                                <th>Overnight <br /> Flight</th>
                                <th>Date Input</th>
                                <th><font size="-2">Status</font></th>
                            </tr>
                            
                            <!--- EDIT FLIGHT INFORMATION --->                
                            <input type="hidden" name="arrivalCount" value='#qGetArrival.recordcount#'>
                            <cfloop query="qGetArrival">
                                <input type="hidden" name="incomingflightID#qGetArrival.currentrow#" value="#flightID#">
                                <tr bgcolor="##D5DCE5" align="center">                        
                                    <cfif ListFind("1,2,3,4,8,11,13", CLIENT.userType)>
                                        <td align="center">
                                            <a href="#CGI.SCRIPT_NAME#?uniqueID=#qGetStudentInfo.uniqueID#&flightID=#flightID#" onClick="return areYouSure(this);"><img src="../pics/deletex.gif" border="0"></img></a>
                                        </td>
                                    </cfif>                                
                                    <td><input type="text" name="incomingDepartureDate#qGetArrival.currentrow#" value="#DateFormat(dep_date , 'mm/dd/yyyy')#" class="datePicker" maxlength="10"></td>
                                    <td><input type="text" name="incomingDepartureCity#qGetArrival.currentrow#" class="fieldSize100" maxlength="40" value="#dep_city#" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                                    <td><input type="text" name="incomingDepartureAirCode#qGetArrival.currentrow#" class="fieldSize40" maxlength="3" value="#dep_aircode#" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                                    <td><input type="text" name="incomingArrivalCity#qGetArrival.currentrow#" class="fieldSize100" maxlength="40" value="#arrival_city#" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                                    <td><input type="text" name="incomingArrivalAirCode#qGetArrival.currentrow#" class="fieldSize40" maxlength="3" value="#arrival_aircode#" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                                    <td><input type="text" name="incomingFlightNumber#qGetArrival.currentrow#" class="fieldSize60" maxlength="8" value="#flight_number#" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                                    <td><input type="text" name="incomingDepartureTime#qGetArrival.currentrow#" class="fieldSize70 timePicker" maxlength="8" value="#TimeFormat(dep_time, 'hh:mm tt')#"></td>
                                    <td><input type="text" name="incomingArrivalTime#qGetArrival.currentrow#" class="fieldSize70 timePicker" maxlength="8" value="#TimeFormat(arrival_time, 'h:mm tt')#"></td>
                                    <td align="center"><input type="checkbox" name="incomingOvernight#qGetArrival.currentrow#" value="1" <cfif VAL(qGetArrival.overnight)> checked="checked" </cfif> ></td>
                                    <td> #DateFormat(qGetArrival.dateCreated, 'mm/dd/yyyy')#</td> 
                                    <td align="center">
                                        <cfif LEN(qGetArrival.flight_number)>
                                            <a href="http://dps1.travelocity.com/dparflifo.ctl?aln_name=#left(qGetArrival.flight_number,2)#&flt_num=#RemoveChars(qGetArrival.flight_number,1,2)#" target="blank"><img src="../pics/arrow.gif" border="0"></img></a>
                                        <cfelse>
                                            n/a
                                        </cfif>
                                    </td>
                                </tr>	
                            </cfloop>
                            
                            <!--- NEW FLIGHT INFORMATION --->
                            <cfif ListFind("1,2,3,4,8,11,13", CLIENT.userType)>
                                
                                <cfloop from="1" to="4" index="i"> 
                                    <tr bgcolor="##D5DCE5" align="center" class="trNewAYPArrival <cfif qGetArrival.recordCount> displayNone </cfif>">
                                        <td>&nbsp;</td>
                                        <td><input type="text" name="incomingNewDepartureDate#i#" class="datePicker" maxlength="10"></td>
                                        <td><input type="text" name="incomingNewDepartureCity#i#" class="fieldSize100" maxlength="40" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                                        <td><input type="text" name="incomingNewDepartureAirCode#i#" class="fieldSize40" maxlength="3" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                                        <td><input type="text" name="incomingNewArrivalCity#i#" class="fieldSize100" maxlength="40" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                                        <td><input type="text" name="incomingNewArrivalAirCode#i#" class="fieldSize40" maxlength="3" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                                        <td><input type="text" name="incomingNewFlightNumber#i#" class="fieldSize60" maxlength="8" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                                        <td><input type="text" name="incomingNewDepartureTime#i#" class="fieldSize70 timePicker" maxlength="8"></td>
                                        <td><input type="text" name="incomingNewArrivalTime#i#" class="fieldSize70 timePicker" maxlength="8"></td>
                                        <td align="center"><input type="checkbox" name="incomingNewOvernight#i#" value="1"></td>
                                        <td>&nbsp;</td> 
                                        <td align="center">&nbsp;</td>
                                    </tr>
                                </cfloop>
    
                                <cfif qGetArrival.recordCount>
                                    <tr bgcolor="##D5DCE5"><td colspan="12" align="center"><a href="javascript:displayClass('trNewAYPArrival');">Click here to add more legs</a></td></tr>
                                </cfif>
                                
                            </cfif>
                            
                            <cfif qGetArrival.recordCount>
                                <tr bgcolor="##D5DCE5">
                                    <td colspan="12" align="center"><font size=-1>*Flight tracking information by Travelocity, not all flights will be available. #CLIENT.companyShort# is not responsible for information on or gathered from travelocity.com.</font></td>
                                </tr>
                            </cfif>
                            
                        </table>
                        <br />
                        
                        
                        <!--- N O T E S --->            
                        <table align="center" width="99%" bordercolor="##C0C0C0" valign="top" cellpadding="3" cellspacing="1" style="border:1px solid ##CCC">
                            <th bgcolor="##ACB9CD"> N O T E S &nbsp; O N &nbsp; T H I S &nbsp; F L I G H T &nbsp; I N F O R M A T I O N </th>
                            <tr bgcolor="##D5DCE5">
                                <td align="center">
                                	<!--- textarea was not displaying in the pdf --->
									<cfif FORM.subAction NEQ "update">
                                    	<textarea cols="75" rows="3" name="flightNotes" wrap="VIRTUAL">#qGetStudentInfo.flight_info_notes#</textarea>
                                 	<cfelse>
                                    	#qGetStudentInfo.flight_info_notes#
                                    </cfif>
                             	</td>
                            </tr>
                        </table>
                        <br />
                    
                    
                        <!--- D E P A R T U R E      I N F O R M A T I O N    --->
                        <table align="center" width="99%" bordercolor="##C0C0C0" valign="top" cellpadding="3" cellspacing="1" style="border:1px solid ##CCC">
                            <th colspan="12" bgcolor="##FDCEAC">D E P A R T U R E &nbsp;&nbsp; F R O M &nbsp; &nbsp; U S A  &nbsp; &nbsp; I N F O R M A T I O N</th>
    
                            <tr bgcolor="##FDCEAC">
                                <td colspan="12">
                                    School End Date: <cfif LEN(qGetSchoolDates.endDate)>#qGetSchoolDates.endDate# <cfelse> n/a </cfif>
                                </td>
                            </tr> 
                            
                            <tr bgcolor="##FDCEAC">
                                <!--- Delete Option --->    
                                <cfif ListFind("1,2,3,4,8,11,13", CLIENT.userType)>                            
                                    <th><font size="-2">Delete</font></th>
                                </cfif>                                    
                                <th>Date <br /> (mm/dd/yyyy)</th>
                                <th>Depart <br /> City</th>
                                <th>Depart <br /> Airport Code</th>
                                <th>Arrive <br /> City</th>
                                <th>Arrive <br /> Airport Code</th>
                                <th>Flight <br /> Number</th>
                                <th>Depart Time <br /> (12:00 AM)</th>
                                <th>Arrive Time <br /> (12:00 AM)</th>
                                <th>Overnight <br /> Flight</th>
                                <th>Date Input</th>
                                <th><font size="-2">Status</font></th>
                            </tr>
    
                            <!--- EDIT FLIGHT INFORMATION --->
                            <input type="hidden" name="departureCount" value='#qGetDeparture.recordcount#'>
                        
                            <cfloop query="qGetDeparture">	
                                <input type="hidden" name="outgoingflightID#qGetDeparture.currentrow#" value="#flightID#">
                                <tr bgcolor="##FEE6D3" align="center">                        
                                    <cfif ListFind("1,2,3,4,8,11,13", CLIENT.userType)>
                                        <td align="center">
                                            <a href="#CGI.SCRIPT_NAME#?uniqueID=#qGetStudentInfo.uniqueID#&flightID=#flightID#" onClick="return areYouSure(this);"><img src="../pics/deletex.gif" border="0"></img></a>
                                        </td>
                                    </cfif>
                                    <td>
                                    	<input 
                                        	type="text"
                                            name="outgoingDepartureDate#qGetDeparture.currentrow#"
                                            id="outgoingDepartureDate#qGetDeparture.currentrow#"
                                            value="#DateFormat(dep_date , 'mm/dd/yyyy')#" 
                                            class="datePicker" 
                                            maxlength="10" 
                                            <cfif NOT qGetStudentInfo.unblockFlight AND NOT vOfficeUser>onchange="checkSchoolDate(this.value,'#vSchoolEndDate#','outgoingDepartureDate#qGetDeparture.currentrow#');"</cfif>>
                                  	</td>
                                    <td><input type="text" name="outgoingDepartureCity#qGetDeparture.currentrow#" class="fieldSize100" maxlength="40" value="#dep_city#" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                                    <td><input type="text" name="outgoingDepartureAirCode#qGetDeparture.currentrow#" class="fieldSize40" maxlength="3" value="#dep_aircode#" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                                    <td><input type="text" name="outgoingArrivalCity#qGetDeparture.currentrow#" class="fieldSize100" maxlength="40" value="#arrival_city#" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                                    <td><input type="text" name="outgoingArrivalAirCode#qGetDeparture.currentrow#" class="fieldSize40" maxlength="3" value="#arrival_aircode#" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                                    <td><input type="text" name="outgoingFlightNumber#qGetDeparture.currentrow#" class="fieldSize60" maxlength="8" value="#flight_number#" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                                    <td><input type="text" name="outgoingDepartureTime#qGetDeparture.currentrow#" class="fieldSize70 timePicker" maxlength="8" value="#TimeFormat(dep_time, 'hh:mm tt')#"></td>
                                    <td><input type="text" name="outgoingArrivalTime#qGetDeparture.currentrow#" class="fieldSize70 timePicker" maxlength="8" value="#TimeFormat(arrival_time, 'h:mm tt')#"></td>
                                    <td align="center"><input type="checkbox" name="outgoingOvernight#qGetDeparture.currentrow#" value="1" <cfif VAL(qGetDeparture.overnight)> checked="checked" </cfif> ></td>
                                    <td>#DateFormat(qGetDeparture.dateCreated, 'mm/dd/yyyy')#</td> 
                                    <td align="center">
                                        <cfif LEN(qGetDeparture.flight_number)>
                                            <a href="http://dps1.travelocity.com/dparflifo.ctl?aln_name=#left(qGetDeparture.flight_number,2)#&flt_num=#RemoveChars(qGetDeparture.flight_number,1,2)#" target="blank"><img src="../pics/arrow.gif" border="0"></img></a>
                                        <cfelse>
                                            n/a
                                        </cfif>
                                    </td>
                                </tr>	
                            </cfloop>
    
                            <!--- NEW FLIGHT INFORMATION --->
                            <cfif ListFind("1,2,3,4,8,11,13", CLIENT.userType)>
                            
                                <cfif LEN(qGetStudentInfo.programName)>
                                
                                    <cfloop from="1" to="4" index="i"> 
                                        <tr bgcolor="##FEE6D3" align="center" class="trNewAYPDeparture <cfif qGetDeparture.recordCount> displayNone </cfif>">                        
                                            <td>&nbsp;</td>
                                            <td>
                                                <input 
                                                    type="text" 
                                                    name="outgoingNewDepartureDate#i#" 
                                                    id="outgoingNewDepartureDate#i#" 
                                                    class="datePicker" 
                                                    maxlength="10" 
                                                    <cfif NOT qGetStudentInfo.unblockFlight AND NOT vOfficeUser>onchange="checkSchoolDate(this.value,'#vSchoolEndDate#','outgoingNewDepartureDate#i#');"</cfif> >
                                            </td>
                                            <td><input type="text" name="outgoingNewDepartureCity#i#" class="fieldSize100" maxlength="40" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                                            <td><input type="text" name="outgoingNewDepartureAirCode#i#" class="fieldSize40" maxlength="3" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                                            <td><input type="text" name="outgoingNewArrivalCity#i#" class="fieldSize100" maxlength="40" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                                            <td><input type="text" name="outgoingNewArrivalAirCode#i#" class="fieldSize40" maxlength="3" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                                            <td><input type="text" name="outgoingNewFlightNumber#i#" class="fieldSize60" maxlength="8" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                                            <td><input type="text" name="outgoingNewDepartureTime#i#" class="fieldSize70 timePicker" maxlength="8"></td>
                                            <td><input type="text" name="outgoingNewArrivalTime#i#" class="fieldSize70 timePicker" maxlength="8"></td>
                                            <td align="center"><input type="checkbox" name="outgoingNewOvernight#i#" value="1"></td>
                                            <td>&nbsp;</td> 
                                            <td>&nbsp;</td>
                                        </tr>
                                    </cfloop>
                                    <cfif qGetDeparture.recordCount>
                                        <tr bgcolor="##FEE6D3"><td colspan="12" align="center"><a href="javascript:displayClass('trNewAYPDeparture');">Click here to add more legs</a></td></tr>
                                    </cfif>
                                    
                                    <!--- Unblock flights from reps to allow them to enter departure dates before the school end date --->
                                    <cfif vOfficeUser>
                                    	<tr bgcolor="##FEE6D3">
                                        	<td colspan="12" align="center">
                                            	Unblock Departure Flights: 
                                                <input type="checkbox" value="1" id="unblockFlight" onclick="changeBlockedFlight()" <cfif qGetStudentInfo.unblockFlight>checked="checked"</cfif> />
                                                <br/>
                                                <font size="-2">- allow reps to enter departure flight dates before the school end date.</font>
                                            </td>
                                        </tr>
                                    </cfif>
                                
                                <cfelse>
                                
                                    <tr bgcolor="##FEE6D3" align="center">
                                        <td colspan="12" align="center">
                                            Please assign this student to a program before adding departure flight information.
                                        </td>
                                    </tr>
                                    
                                </cfif>
                                
                            </cfif>
                            
                            <cfif qGetDeparture.recordCount>
                                <tr bgcolor="##FEE6D3">
                                    <td colspan="12" align="center"><font size=-1>*Flight tracking information by Travelocity, not all flights will be available. #CLIENT.companyShort# is not responsible for information on or gathered from travelocity.com.</font></td>
                                </tr>
                            </cfif>
                           
                        </table>
    
                        <cfif ListFind("1,2,3,4,8,11,13", CLIENT.userType) AND VAL(qGetStudentInfo.recordCount)>
                            <table align="center" width="99%" valign="top" cellpadding="3" cellspacing="1" style="margin-top:10px;">
                                <tr>
                                    <td align="center"><input name="Submit" type="image" src="../pics/update.gif" border="0" alt=" update " onclick="checkForm(); return false;">&nbsp;</td>
                                </tr>
                            </table>
                        </cfif>
    
                        </form>
    
                    </td>
                </tr>
            </table> <!--- end of main table --->
        
    	</cfsavecontent>
        
        <!--- Show Flight Information --->
        #flightInformation#
        
        <!--- Send pdf to the internal virtual folder if the flight information was updated --->
        <cfif FORM.subAction EQ 'update'>
            <cfset fileName="flight_information_#qGetStudentInfo.studentID#_#DateFormat(NOW(),'mm-dd-yyyy')#-#TimeFormat(NOW(),'hh-mm')#">
            <cfdocument format="pdf" filename="#fileName#.pdf" overwrite="yes" orientation="landscape" name="uploadFile">
            	#flightInformation#
           	</cfdocument>
            <cfscript>
				fullPath=GetDirectoryFromPath(GetCurrentTemplatePath()) & fileName & '.pdf';
				APPLICATION.CFC.UDF.insertInternalFile(filePath=fullPath,fieldID=1,studentID=qGetStudentInfo.studentID);
				APPLICATION.CFC.UDF.insertIntoVirtualFolder(
					categoryID=1,
					documentType=4,
					studentID=qGetStudentInfo.studentID,
					fileDescription="Flight Itinerary",
					fileName=fileName & ".pdf" );
			</cfscript>
        </cfif>
        
        <!--- Table Footer --->
        <gui:tableFooter 
  	        width="98%"
			imagePath="../"
        />

	<!--- Page Footer --->
    <gui:pageFooter
        footerType="application"
    />

</cfoutput>