<!--- ------------------------------------------------------------------------- ----
	
	File:		_flightInfo.cfm
	Author:		Marcus Melo
	Date:		January 12, 2010
	Desc:		Inserts/Updates Students flight information

	Updated:  	04/27/2011 - Combining flight information files (form/intrep)
				04/26/2011 - Added pre-ayp arrival section / Jquery Modal
				01/14/2010 - Reorganized - Marcus Melo
				01/14/2010 - Added date-pick - Marcus Melo
				09/29/2005 - revised by Josh Rahl

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

    <!--- Delete Flight Information --->
    <cfparam name="URL.uniqueID" type="string" default="">
    <cfparam name="URL.flightID" default="0">
		        
	<!--- Param GLOBAL FORM Variables --->
    <cfparam name="FORM.subAction" type="string"  default="">
    <cfparam name="FORM.uniqueID" type="string" default="">
    <cfparam name="FORM.flight_notes" type="string" default="">
    <cfparam name="FORM.preAYPArrivalCount" default="0">
    <cfparam name="FORM.arrivalCount" default="0">
    <cfparam name="FORM.departureCount" default="0">
	
    <cfscript>
		// Check if there is a valid URL variable
		if ( LEN(URL.uniqueID) AND NOT LEN(FORM.uniqueID) ) {
			FORM.uniqueID = URL.uniqueID;	
		}	
	</cfscript>
    
    <!--- Get Student Information --->
    <cfquery name="qGetStudentInfo" datasource="MySQL">
        SELECT  
        	s.studentID,
            s.uniqueID,
            s.companyID,
            s.programID,
            s.schoolID,             
            s.familylastname, 
            s.firstname,             
            s.hostid, 
            s.flight_info_notes, 
            s.insurance, 
            s.AYPOrientation,
            s.AYPEnglish,
            u.insurance_typeid, 
            u.businessname,
            p.insurance_startdate,
            h.airport_city, 
            h.major_air_code
        FROM 
        	smg_students s
        INNER JOIN 
        	smg_users u ON u.userid = s.intrep
        LEFT OUTER JOIN 	
        	smg_programs p ON p.programid = s.programid
        LEFT OUTER JOIN 
        	smg_hosts h ON h.hostid = s.hostid
        WHERE 
        	s.uniqueID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.uniqueID#">
    </cfquery>
       
	<cfscript>
		// Get School Dates
		qGetSchoolDates = APPLICATION.CFC.SCHOOL.getSchoolDates(schoolID=qGetStudentInfo.schoolID, programID=qGetStudentInfo.programID);
	
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
            
            <cfscript>
                if ( LEN(FORM["incomingNewPreAYPDepartureDate" & i]) ) {
                    
                    APPLICATION.CFC.STUDENT.insertFlightInfo(
                        studentID=qGetStudentInfo.studentID,
						companyID=qGetStudentInfo.companyID,
						programID=qGetStudentInfo.programID,
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
					programID=qGetStudentInfo.programID,
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
						programID=qGetStudentInfo.programID,
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
					programID=qGetStudentInfo.programID,
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
						programID=qGetStudentInfo.programID,
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
					programID=qGetStudentInfo.programID,
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
				APPLICATION.CFC.STUDENT.emailFlightInformation(studentID=qGetStudentInfo.studentID);
			}
			
			// Set Page Message
			SESSION.pageMessages.Add("Flight Information Updated");
		</cfscript>


	<cfelseif FORM.subAction EQ 'emailRegionalManager'>
    
        <cfscript>
			// Send out email notification to the regional manager
			APPLICATION.CFC.STUDENT.emailFlightInformation(studentID=qGetStudentInfo.studentID, sendEmailTo='regionalManager');
			
			// Set Page Message
			SESSION.pageMessages.Add("Flight Information emailed to the Regional Manager");
		</cfscript>
            
    <cfelseif FORM.subAction EQ 'emailCurrentUser'>

        <cfscript>
			// Send out email notification to the current user
			APPLICATION.CFC.STUDENT.emailFlightInformation(studentID=qGetStudentInfo.studentID, sendEmailTo='currentUser');

			// Set Page Message
			SESSION.pageMessages.Add("Flight Information emailed to you");
		</cfscript>
            
    </cfif> 
	<!--- END OF FORM.subAction --->

    <cfscript>
		// Get Pre-AYP Arrival
		qGetPreAYPArrival = APPLICATION.CFC.STUDENT.getFlightInformation(studentID=VAL(qGetStudentInfo.studentID), flightType="preAYPArrival");

		// Get Arrival
		qGetArrival = APPLICATION.CFC.STUDENT.getFlightInformation(studentID=VAL(qGetStudentInfo.studentID), flightType="arrival");

		// Get Departure
		qGetDeparture = APPLICATION.CFC.STUDENT.getFlightInformation(studentID=VAL(qGetStudentInfo.studentID), flightType="departure");
	</cfscript>

</cfsilent>

<cfoutput>

	<!--- Page Header --->
    <gui:pageHeader
        headerType="applicationNoHeader"
    />	

		<script type="text/javascript" language="javascript">
			$(document).ready(function() {	
				/* Date Pick Function */									   	
				$('.date-pick').datePicker({startDate:'01/01/2009'});
			});

            <!--
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
            
            function checkDate(theField){
                var eDate = new Date(theField.value);
                var nowDate  = new Date();
                nowDate.setHours(0,0,0);
                var mDate = new Date();
                mDate.setMonth(mDate.getMonth()+24);
                if (eDate > mDate || eDate < nowDate){
                  alert("This date is prior to todays date: "+eDate);
                  return false;
                } else{
                 
                  return true;
                }
            }
            // -->
        </script>

		<cfif LEN(FORM.subAction) AND NOT SESSION.formErrors.length()>
        
            <script language="javascript">
                // Close Window After 1.5 Seconds
                setTimeout(function() { parent.$.fn.colorbox.close(); }, 2000);
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

        <table width="98%" border="0" cellpadding="4" cellspacing="0" class="section" align="center">
            <tr>
                <td>
        
                    <!--- EMAIL FLIGHT INFORMATION / Only Office Users --->
                    <cfif ListFind("1,2,3,4", CLIENT.userType)>
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
                                    	<input type="image" src="../pics/sendemail.gif" value="send email">
                                    </form>
                                    <font size="-2" color="##CC6600"><b>Be sure you have updated the flight information before sending the e-mail to the Regional Director.</b></font>
                                </td>
                                <td align="center" width="50%">
                                    <form name="emailCurrentUser" action="#CGI.SCRIPT_NAME#" method="post">
                                        <input type="hidden" name="subAction" value="emailCurrentUser" />
                                        <input type="hidden" name="uniqueID" value="#qGetStudentInfo.uniqueID#" />
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
                    </cfif>
        
                    <form name="flightInformation" action="#CGI.SCRIPT_NAME#" method="post">
                    <input type="hidden" name="subAction" value="update" />
                    <input type="hidden" name="uniqueID" value="#qGetStudentInfo.uniqueID#" />
                    
                    <!--- PRE-AYP ARRIVAL INFORMATION --->
                    <cfif VAL(qGetStudentInfo.AYPEnglish) OR VAL(qGetStudentInfo.AYPOrientation)>
                        
                        <table align="center" width="99%" bordercolor="##C0C0C0" valign="top" cellpadding="3" cellspacing="1" style="border:1px solid ##CCC">
                            <th colspan="11" bgcolor="##A0D69A"> P R E - A Y P &nbsp;&nbsp; A R R I V A L &nbsp; &nbsp; I N F O R M A T I O N </th>
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
                                <th><font size="-2">Status</font></th>
                            </tr>
							
                            <!--- EDIT FLIGHT INFORMATION --->
                            <input type="hidden" name="preAYPArrivalCount" value='#qGetPreAypArrival.recordcount#'>
                            <cfloop query="qGetPreAypArrival">
                                <input type="hidden" name="incomingPreAYPflightID#qGetPreAypArrival.currentrow#" value="#qGetPreAypArrival.flightID#">
                                <tr bgcolor="##DDF0DD">  
                                    <!--- Delete Option --->                      
                                    <cfif ListFind("1,2,3,4,8,11,13", CLIENT.userType)>
                                        <td align="center">
                                            <a href="#CGI.SCRIPT_NAME#?uniqueID=#qGetStudentInfo.uniqueID#&flightID=#flightID#" onClick="return areYouSure(this);"><img src="../pics/deletex.gif" border="0"></img></a>
                                        </td>
                                    </cfif>
                                    <td><input type="text" name="incomingPreAYPDepartureDate#qGetPreAypArrival.currentrow#" value="#DateFormat(dep_date , 'mm/dd/yyyy')#" class="date-pick" maxlength="10"></td>
                                    <td><input type="text" name="incomingPreAYPDepartureCity#qGetPreAypArrival.currentrow#" size="7" maxlength="40" value="#dep_city#"></td>
                                    <td><input type="text" name="incomingPreAYPDepartureAirCode#qGetPreAypArrival.currentrow#" size="1" maxlength="3" value="#dep_aircode#" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                                    <td><input type="text" name="incomingPreAYPArrivalCity#qGetPreAypArrival.currentrow#" size="7" maxlength="40" value="#arrival_city#"></td>
                                    <td><input type="text" name="incomingPreAYPArrivalAirCode#qGetPreAypArrival.currentrow#" size="1" maxlength="3" value="#arrival_aircode#" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                                    <td><input type="text" name="incomingPreAYPFlightNumber#qGetPreAypArrival.currentrow#" size="4" maxlength="8" value="#flight_number#" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                                    <td><input type="text" name="incomingPreAYPDepartureTime#qGetPreAypArrival.currentrow#" size="5" maxlength="8" value="#TimeFormat(dep_time, 'hh:mm tt')#"></td>
                                    <td><input type="text" name="incomingPreAYPArrivalTime#qGetPreAypArrival.currentrow#" size="5" maxlength="8" value="#TimeFormat(arrival_time, 'h:mm tt')#"></td>
                                    <td align="center"><input type="checkbox" name="incomingPreAYPOvernight#qGetPreAypArrival.currentrow#" value="1" <cfif VAL(qGetPreAypArrival.overnight)> checked="checked" </cfif> ></td>
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
                                    <tr bgcolor="##DDF0DD" class="trNewPreAYPArrival <cfif qGetPreAypArrival.recordCount> displayNone </cfif>">
                                        <td>&nbsp;</td>
                                        <td><input type="text" name="incomingNewPreAYPDepartureDate#i#" class="date-pick" maxlength="10" onChange="return checkDate(this)"></td>
                                        <td><input type="text" name="incomingNewPreAYPDepartureCity#i#" size="7" maxlength="40"></td>
                                        <td><input type="text" name="incomingNewPreAYPDepartureAirCode#i#" size="1" maxlength="3" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                                        <td><input type="text" name="incomingNewPreAYPArrivalCity#i#" size="7" maxlength="40"></td>
                                        <td><input type="text" name="incomingNewPreAYPArrivalAirCode#i#" size="1" maxlength="3" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                                        <td><input type="text" name="incomingNewPreAYPFlightNumber#i#" size="4" maxlength="8" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                                        <td><input type="text" name="incomingNewPreAYPDepartureTime#i#" size="5" maxlength="8"></td>
                                        <td><input type="text" name="incomingNewPreAYPArrivalTime#i#" size="5" maxlength="8"></td>
                                        <td align="center"><input type="checkbox" name="incomingNewPreAYPOvernight#i#" value="1"></td>
                                        <td align="center">&nbsp;</td>
                                    </tr>
                                </cfloop>
								
                                <cfif qGetPreAypArrival.recordCount>
	                                <tr bgcolor="##DDF0DD"><td colspan="11" align="center"><a href="javascript:displayClass('trNewPreAYPArrival');">Click here to add more legs</a></td></tr>
                                </cfif>
                                
                            </cfif>
                            
                            <cfif qGetPreAypArrival.recordCount>
                                <tr bgcolor="##DDF0DD">
                                    <td colspan="11" align="center"><font size=-1>*Flight tracking information by Travelocity, not all flights will be available. #CLIENT.companyShort# is not responsible for information on or gathered from travelocity.com.</font></td>
                                </tr>
                            </cfif>
                                          
                        </table> 
                        <br />
        
                    </cfif>            
                    
                    
                    <!--- A R R I V A L    I N F O R M A T I O N --->
                    <table align="center" width="99%" bordercolor="##C0C0C0" valign="top" cellpadding="3" cellspacing="1" style="border:1px solid ##CCC">
                        <th colspan="11" bgcolor="##ACB9CD"> A R R I V A L &nbsp;&nbsp; T O &nbsp; &nbsp; H O S T &nbsp; &nbsp; F A M I L Y &nbsp; &nbsp; I N F O R M A T I O N </th>

                        <tr bgcolor="##ACB9CD">
                            <td colspan="11">
                                Arrival/Departure Airport: <cfif LEN(qGetStudentInfo.airport_city)>#qGetStudentInfo.airport_city# <cfelse> n/a </cfif>
                                - Airport Code: <cfif LEN(qGetStudentInfo.major_air_code)>#qGetStudentInfo.major_air_code# <cfelse> n/a </cfif>
                            </td>
                        </tr> 
                        
                        <tr bgcolor="##ACB9CD">
                            <td colspan="11">
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
                            <th><font size="-2">Status</font></th>
                        </tr>
                        
						<!--- EDIT FLIGHT INFORMATION --->                
                        <input type="hidden" name="arrivalCount" value='#qGetArrival.recordcount#'>
                        <cfloop query="qGetArrival">
                            <input type="hidden" name="incomingflightID#qGetArrival.currentrow#" value="#flightID#">
                            <tr bgcolor="##D5DCE5">                        
                                <cfif ListFind("1,2,3,4,8,11,13", CLIENT.userType)>
    	                            <td align="center">
                                        <a href="#CGI.SCRIPT_NAME#?uniqueID=#qGetStudentInfo.uniqueID#&flightID=#flightID#" onClick="return areYouSure(this);"><img src="../pics/deletex.gif" border="0"></img></a>
		                            </td>
                                </cfif>                                
                                <td><input type="text" name="incomingDepartureDate#qGetArrival.currentrow#" value="#DateFormat(dep_date , 'mm/dd/yyyy')#" class="date-pick" maxlength="10"></td>
                                <td><input type="text" name="incomingDepartureCity#qGetArrival.currentrow#" size="7" maxlength="40" value="#dep_city#"></td>
                                <td><input type="text" name="incomingDepartureAirCode#qGetArrival.currentrow#" size="1" maxlength="3" value="#dep_aircode#" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                                <td><input type="text" name="incomingArrivalCity#qGetArrival.currentrow#" size="7" maxlength="40" value="#arrival_city#"></td>
                                <td><input type="text" name="incomingArrivalAirCode#qGetArrival.currentrow#" size="1" maxlength="3" value="#arrival_aircode#" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                                <td><input type="text" name="incomingFlightNumber#qGetArrival.currentrow#" size="4" maxlength="8" value="#flight_number#" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                                <td><input type="text" name="incomingDepartureTime#qGetArrival.currentrow#" size="5" maxlength="8" value="#TimeFormat(dep_time, 'hh:mm tt')#"></td>
                                <td><input type="text" name="incomingArrivalTime#qGetArrival.currentrow#" size="5" maxlength="8" value="#TimeFormat(arrival_time, 'h:mm tt')#"></td>
                                <td align="center"><input type="checkbox" name="incomingOvernight#qGetArrival.currentrow#" value="1" <cfif VAL(qGetArrival.overnight)> checked="checked" </cfif> ></td>
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
                                <tr bgcolor="##D5DCE5" class="trNewAYPArrival <cfif qGetArrival.recordCount> displayNone </cfif>">
                                    <td>&nbsp;</td>
                                    <td><input type="text" name="incomingNewDepartureDate#i#" class="date-pick" maxlength="10" onChange="return checkDate(this)"></td>
                                    <td><input type="text" name="incomingNewDepartureCity#i#" size="7" maxlength="40"></td>
                                    <td><input type="text" name="incomingNewDepartureAirCode#i#" size="1" maxlength="3" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                                    <td><input type="text" name="incomingNewArrivalCity#i#" size="7" maxlength="40"></td>
                                    <td><input type="text" name="incomingNewArrivalAirCode#i#" size="1" maxlength="3" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                                    <td><input type="text" name="incomingNewFlightNumber#i#" size="4" maxlength="8" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                                    <td><input type="text" name="incomingNewDepartureTime#i#" size="5" maxlength="8"></td>
                                    <td><input type="text" name="incomingNewArrivalTime#i#" size="5" maxlength="8"></td>
                                    <td align="center"><input type="checkbox" name="incomingNewOvernight#i#" value="1"></td>
                                    <td align="center">&nbsp;</td>
                                </tr>
                            </cfloop>

							<cfif qGetArrival.recordCount>
                                <tr bgcolor="##D5DCE5"><td colspan="11" align="center"><a href="javascript:displayClass('trNewAYPArrival');">Click here to add more legs</a></td></tr>
                            </cfif>
                            
                        </cfif>
                        
                        <cfif qGetArrival.recordCount>
                            <tr bgcolor="##D5DCE5">
                                <td colspan="11" align="center"><font size=-1>*Flight tracking information by Travelocity, not all flights will be available. #CLIENT.companyShort# is not responsible for information on or gathered from travelocity.com.</font></td>
                            </tr>
                        </cfif>
                        
                    </table>
                    <br />
					
                    
                    <!--- N O T E S --->            
                    <table align="center" width="99%" bordercolor="##C0C0C0" valign="top" cellpadding="3" cellspacing="1" style="border:1px solid ##CCC">
                        <th bgcolor="##ACB9CD"> N O T E S &nbsp; O N &nbsp; T H I S &nbsp; F L I G H T &nbsp; I N F O R M A T I O N </tr>
                        <tr bgcolor="##D5DCE5">
                            <td align="center"><textarea cols="75" rows="3" name="flightNotes" wrap="VIRTUAL">#qGetStudentInfo.flight_info_notes#</textarea></td>
                        </tr>
                    </table>
                    <br />
                
                
                    <!--- D E P A R T U R E      I N F O R M A T I O N    --->
                    <table align="center" width="99%" bordercolor="##C0C0C0" valign="top" cellpadding="3" cellspacing="1" style="border:1px solid ##CCC">
                        <th colspan="11" bgcolor="##FDCEAC">D E P A R T U R E &nbsp;&nbsp; F R O M &nbsp; &nbsp; U S A  &nbsp; &nbsp; I N F O R M A T I O N</th>

                        <tr bgcolor="##FDCEAC">
                            <td colspan="11">
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
                            <th><font size="-2">Status</font></th>
                        </tr>

                        <!--- EDIT FLIGHT INFORMATION --->
                        <input type="hidden" name="departureCount" value='#qGetDeparture.recordcount#'>
                    
                        <cfloop query="qGetDeparture">	
                            <input type="hidden" name="outgoingflightID#qGetDeparture.currentrow#" value="#flightID#">
                            <tr bgcolor="##FEE6D3">                        
                            	<cfif ListFind("1,2,3,4,8,11,13", CLIENT.userType)>
	                                <td align="center">
                                        <a href="#CGI.SCRIPT_NAME#?uniqueID=#qGetStudentInfo.uniqueID#&flightID=#flightID#" onClick="return areYouSure(this);"><img src="../pics/deletex.gif" border="0"></img></a>
	                                </td>
								</cfif>
                                <td><input type="text" name="outgoingDepartureDate#qGetDeparture.currentrow#" value="#DateFormat(dep_date , 'mm/dd/yyyy')#" class="date-pick" maxlength="10"></td>
                                <td><input type="text" name="outgoingDepartureCity#qGetDeparture.currentrow#" size="7" maxlength="40" value="#dep_city#"></td>
                                <td><input type="text" name="outgoingDepartureAirCode#qGetDeparture.currentrow#" size="1" maxlength="3" value="#dep_aircode#" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                                <td><input type="text" name="outgoingArrivalCity#qGetDeparture.currentrow#" size="7" maxlength="40" value="#arrival_city#"></td>
                                <td><input type="text" name="outgoingArrivalAirCode#qGetDeparture.currentrow#" size="1" maxlength="3" value="#arrival_aircode#" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                                <td><input type="text" name="outgoingFlightNumber#qGetDeparture.currentrow#" size="4" maxlength="8" value="#flight_number#" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                                <td><input type="text" name="outgoingDepartureTime#qGetDeparture.currentrow#" size="5" maxlength="8" value="#TimeFormat(dep_time, 'hh:mm tt')#"></td>
                                <td><input type="text" name="outgoingArrivalTime#qGetDeparture.currentrow#" size="5" maxlength="8" value="#TimeFormat(arrival_time, 'h:mm tt')#"></td>
                                <td align="center"><input type="checkbox" name="outgoingOvernight#qGetDeparture.currentrow#" value="1" <cfif VAL(qGetDeparture.overnight)> checked="checked" </cfif> ></td>
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
                            
                            <cfloop from="1" to="4" index="i"> 
                                <tr bgcolor="##FEE6D3" class="trNewAYPDeparture <cfif qGetDeparture.recordCount> displayNone </cfif>">                        
                                    <td>&nbsp;</td>
                                    <td><input type="text" name="outgoingNewDepartureDate#i#" class="date-pick" maxlength="10"></td>
                                    <td><input type="text" name="outgoingNewDepartureCity#i#" size="7" maxlength="40"></td>
                                    <td><input type="text" name="outgoingNewDepartureAirCode#i#" size="1" maxlength="3" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                                    <td><input type="text" name="outgoingNewArrivalCity#i#" size="7" maxlength="40"></td>
                                    <td><input type="text" name="outgoingNewArrivalAirCode#i#" size="1" maxlength="3" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                                    <td><input type="text" name="outgoingNewFlightNumber#i#" size="4" maxlength="8" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                                    <td><input type="text" name="outgoingNewDepartureTime#i#" size="5" maxlength="8"></td>
                                    <td><input type="text" name="outgoingNewArrivalTime#i#" size="5" maxlength="8"></td>
                                    <td align="center"><input type="checkbox" name="outgoingNewOvernight#i#" value="1"></td>
                                    <td>&nbsp;</td>
                                </tr>
                            </cfloop>
                        
							<cfif qGetDeparture.recordCount>
                                <tr bgcolor="##FEE6D3"><td colspan="11" align="center"><a href="javascript:displayClass('trNewAYPDeparture');">Click here to add more legs</a></td></tr>
                            </cfif>
                            
                        </cfif>
                        
                        <cfif qGetDeparture.recordCount>
                            <tr bgcolor="##FEE6D3">
                                <td colspan="11" align="center"><font size=-1>*Flight tracking information by Travelocity, not all flights will be available. #CLIENT.companyShort# is not responsible for information on or gathered from travelocity.com.</font></td>
                            </tr>
                        </cfif>
                       
                    </table>
                    
                </td>
            </tr>
        </table> <!--- end of main table --->
        
        <cfif ListFind("1,2,3,4,8,11,13", CLIENT.userType) AND VAL(qGetStudentInfo.recordCount)>
            <table cellpadding="4" cellspacing="0" width="98%" class="section" align="center" style="border:1px solid ##CCC">
                <tr>
                    <td align="center"><input name="Submit" type="image" src="../pics/update.gif" border="0" alt=" update ">&nbsp;</td>
                </tr>
            </table>
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

</form>

</cfoutput>