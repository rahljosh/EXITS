<!--- ------------------------------------------------------------------------- ----
	
	File:		int_flight_info.cfm
	Author:		Marcus Melo
	Date:		January 142, 2010
	Desc:		Inserts/Updates Students flight information

	PS:			Based on forms\flight_info.cfm - Links updated

	Updated:  	01/14/2010 - Reorganized - Marcus Melo
				01/14/2010 - Added date-pick - Marcus Melo
				09/29/2005 - revised by Josh Rahl

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<!----
<cfsilent>
---->
    
    <!--- Param Variables --->
	<cftry>
	    <cfparam name="studentID" type="numeric" default="0">
        
        <cfcatch type="any">
            <cfscript>
                // If it's not numeric, set ID to 0
                studentID = 0;
            </cfscript>
        </cfcatch>   
             
    </cftry>

	<!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.insuranceTypeID" default="0">
	<cfparam name="FORM.ar_count" default="0">
    <cfparam name="FORM.dp_count" default="0">
    <cfparam name="FORM.ar_update" default="">
    <cfparam name="FORM.dp_update" default="">
    <cfparam name="FORM.flight_notes" default="">

    

	<!--- Start of intrep\int_flight_info.cfm --->
    <cfparam name="URL.unqid" default="">
    <!--- End of intrep\int_flight_info.cfm --->

	<cfquery name="qCheckPHP" datasource="MySql">
            SELECT 
            	studentid, companyid
            FROM 
            	php_students_in_program
            WHERE 
            	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.studentid#">
        </cfquery>
     

 
	<!--- FORM SUBMITTED --->
	<cfif VAL(FORM.submitted)>
		
		<cfscript>
            // Update Flight Notes
            APPCFC.STUDENT.updateFlightNotes(studentID=studentID, flightNotes=FORM.flight_notes);
        </cfscript>
        
        <!--- ARRIVAL INFORMATION -  NEW FLIGHT ARRIVAL UP TO 4 LEGS--->
        <cfif FORM.ar_update EQ 'new'> 
        
            <cfloop From="1" To="4" Index="i">
                
                <!--- Param FORM Variables --->
                <cfparam name="FORM.ar_overnight#i#" default="0">
                
				<cfscript>
                    if ( LEN(FORM["ar_dep_date" & i]) ) {
						
						APPCFC.STUDENT.insertFlightInfo(
                            studentID=studentID,
                            flightNumber=FORM["ar_flight_number" & i],
                            depCity=FORM["ar_dep_city" & i],
                            depAirCode=FORM["ar_dep_aircode" & i],
                            depDate=FORM["ar_dep_date" & i],
                            depTime=FORM["ar_dep_time" & i],
                            arrivalCity=FORM["ar_arrival_city" & i],
                            arrivalAirCode=FORM["ar_arrival_aircode" & i],
                            arrivalTime=FORM["ar_arrival_time" & i],
                            overNight=FORM["ar_overnight" & i],
                            flightType='arrival'
                        );
						
                    }
                </cfscript>
                
            </cfloop>
            
        <!--- UPDATE FLIGHT ARRIVAL INFORMATION --->
        <cfelseif FORM.ar_update EQ 'update'> 
            
            <cfloop From="1" To="#FORM.ar_count#" Index="i">
            	
                <!--- Param FORM Variables --->
                <cfparam name="FORM.ar_overnight#i#" default="0">
                
                <cfscript>
					APPCFC.STUDENT.updateFlightInfo(
						flightID=FORM["ar_flightid" & i],
						flightNumber=FORM["ar_flight_number" & i],
						depCity=FORM["ar_dep_city" & i],
						depAirCode=FORM["ar_dep_aircode" & i],
						depDate=FORM["ar_dep_date" & i],
						depTime=FORM["ar_dep_time" & i],
						arrivalCity=FORM["ar_arrival_city" & i],
						arrivalAirCode=FORM["ar_arrival_aircode" & i],
						arrivalTime=FORM["ar_arrival_time" & i],
						overNight=FORM["ar_overnight" & i]
					);
				</cfscript>
                
            </cfloop>
            
        </cfif> 
		<!--- END OF FLIGHT ARRIVAL --->
        
        <!--- DEPARTURE INFORMATION - NEW FLIGHT DEPARTURE UP TO 4 LEGS --->
        <cfif FORM.dp_update is 'new'>
            
            <cfloop From="1" To="4" Index="i">
                
                <!--- Param FORM Variables --->
                <cfparam name="FORM.dp_overnight#i#" default="0">
                
				<cfscript>
                    if ( LEN(FORM["dp_dep_date" & i]) ) {
						
						APPCFC.STUDENT.insertFlightInfo(
                            studentID=studentID,
                            flightNumber=FORM["dp_flight_number" & i],
                            depCity=FORM["dp_dep_city" & i],
                            depAirCode=FORM["dp_dep_aircode" & i],
                            depDate=FORM["dp_dep_date" & i],
                            depTime=FORM["dp_dep_time" & i],
                            arrivalCity=FORM["dp_arrival_city" & i],
                            arrivalAirCode=FORM["dp_arrival_aircode" & i],
                            arrivalTime=FORM["dp_arrival_time" & i],
                            overNight=FORM["dp_overnight" & i],
                            flightType='departure'
                        );
						
                    }
                </cfscript>

            </cfloop>
            
        <!--- UPDATE FLIGHT DEPARTURE --->	
        <cfelseif FORM.dp_update is 'update'> 

            <cfloop From="1" To="#FORM.dp_count#" Index="i">

                <!--- Param FORM Variables --->
                <cfparam name="FORM.dp_overnight#i#" default="0">
            	
                <cfscript>
					APPCFC.STUDENT.updateFlightInfo(
						flightID=FORM["dp_flightid" & i],
						flightNumber=FORM["dp_flight_number" & i],
						depCity=FORM["dp_dep_city" & i],
						depAirCode=FORM["dp_dep_aircode" & i],
						depDate=FORM["dp_dep_date" & i],
						depTime=FORM["dp_dep_time" & i],
						arrivalCity=FORM["dp_arrival_city" & i],
						arrivalAirCode=FORM["dp_arrival_aircode" & i],
						arrivalTime=FORM["dp_arrival_time" & i],
						overNight=FORM["dp_overnight" & i]
					);
				</cfscript>
                
            </cfloop>
            
        </cfif> 
        <!--- END OF DEPARTURE INFORMATION --->
		<cfquery name="qCheckPHP" datasource="MySql">
            SELECT 
            	studentid
            FROM 
            	php_students_in_program
            WHERE 
            	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.studentid#">
        </cfquery>
       
        <!--- EMAIL FACILITATORS TO LET THEM KNOW THERE IS A NEW FLIGHT INFORMATION ---->
        <cfif qCheckPHP.studentid eq #studentid#>
            <cfquery name="qGetEmailInfo" datasource="MySQL">
            SELECT 
            	s.studentID,
                s.firstName,
                s.familyLastName,
                s.regionassigned,
                s.intRep,
                s.uniqueid,

                intRep.businessName 
            FROM 
            	smg_students s 
            INNER JOIN
            	smg_users intRep ON s.intRep = intRep.userID

            WHERE 
            	s.studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.studentid#">
        </cfquery>
        
           <cfset email_to = 'luke@phpusa.com'>

        <cfoutput>
        
           <cfsavecontent variable="email_message">
<cfif FORM.ar_update eq 'update'><strong>ARRIVAL INFORMATION HAS CHANGED</strong><br /></cfif>
<cfif FORM.dp_update eq 'update'><strong>DEPARTURE INFORMATION HAS CHANGED</strong><Br /></cfif>
<Br />

What: Flight Information<BR />
Student: #qGetEmailInfo.firstname# #qGetEmailInfo.familylastname# (###qGetEmailInfo.studentid#)<Br />
Submitted By: #qGetEmailInfo.businessname#.<br><br>
Please click <a href="http://www.phpusa.com/internal/index.cfm?curdoc=student/student_info&unqid=#qGetEmailInfo.uniqueid#">here</a> then click on Flight Information to see the student's flight information.<br><br>
        
            Sincerely,<br>
            EXITS Flight Info<br><br>
        </cfsavecontent>
        
   
                    
		<!--- send email --->
        <cfinvoke component="nsmg.cfc.email" method="send_mail">
            <cfinvokeargument name="email_to" value="#email_to#">
            <Cfif form.dp_update eq 'update' or form.ar_update eq 'update'>
            <cfinvokeargument name="email_subject" value="UPDATED Flight Information for #qGetEmailInfo.firstname# #qGetEmailInfo.familylastname# (#qGetEmailInfo.studentid#)">
            <cfelse>
            <cfinvokeargument name="email_subject" value="Flight Information for #qGetEmailInfo.firstname# #qGetEmailInfo.familylastname# (#qGetEmailInfo.studentid#)">
            </Cfif>
            <cfinvokeargument name="email_message" value="#email_message#">
            <cfinvokeargument name="email_from" value="#CLIENT.support_email#">
        </cfinvoke>
        </cfoutput>
      
     <cfelse>
        
        <cfquery name="qGetEmailInfo" datasource="MySQL">
            SELECT 
            	s.studentID,
                s.firstName,
                s.familyLastName,
                s.regionassigned,
                s.intRep,
                s.uniqueid,
             
                r.regionname, 
                r.regionfacilitator, 
                r.regionid, 
                r.company,
				
                u.firstname as ufirstname, 
                u.lastname ulastname, 
                u.email,
                intRep.businessName 
            FROM 
            	smg_students s 
            INNER JOIN 
            	smg_regions r ON s.regionassigned = r.regionid
				
            INNER JOIN
            	smg_users intRep ON s.intRep = intRep.userID
              
            LEFT JOIN 
            	smg_users u ON r.regionfacilitator = u.userid
			
            WHERE 
            	s.studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.studentid#">
        </cfquery>

        <cfif qGetEmailInfo.email EQ ''>
            <cfset email_to = 'support@student-management.com'>
        <cfelse>	
            <cfset email_to = '#qGetEmailInfo.email#'>
        </cfif>
        <cfoutput>
           <cfsavecontent variable="email_message">
           
<cfif FORM.ar_update eq 'update'><strong>ARRIVAL INFORMATION HAS CHANGED</strong><br /></cfif>
<cfif FORM.dp_update eq 'update'><strong>DEPARTURE INFORMATION HAS CHANGED</strong><Br /></cfif>

What: Flight Information<BR />
Student: #qGetEmailInfo.firstname# #qGetEmailInfo.familylastname# (###qGetEmailInfo.studentid#)<Br />
Submitted By: #qGetEmailInfo.businessname#.<br><br>

            Please click <a href="http://#CLIENT.exits_url#/nsmg/forms/flight_info.cfm?unqid=#qGetEmailInfo.uniqueid#">here</a>
            to see the student's flight information.<br><br>
        
            Sincerely,<br>
            EXITS Flight Info<br><br>
        </cfsavecontent>
             
      
                    
		<!--- send email --->
        <cfinvoke component="nsmg.cfc.email" method="send_mail">
            <cfinvokeargument name="email_to" value="#email_to#">
         <Cfif form.dp_update eq 'update' or form.ar_update eq 'update'>
            <cfinvokeargument name="email_subject" value="UPDATED Flight Information for #qGetEmailInfo.firstname# #qGetEmailInfo.familylastname# (#qGetEmailInfo.studentid#)">
            <cfelse>
            <cfinvokeargument name="email_subject" value="Flight Information for #qGetEmailInfo.firstname# #qGetEmailInfo.familylastname# (#qGetEmailInfo.studentid#)">
            </Cfif><cfinvokeargument name="email_message" value="#email_message#">
            <cfinvokeargument name="email_from" value="#CLIENT.support_email#">
        </cfinvoke>
      
      	</cfoutput>  
        </cfif>
    
    
   


        <!----End of Email---->
        
    </cfif> 
	<!--- FORM.submitted --->

	<!--- Start of intrep\int_flight_info.cfm --->
	<cfif LEN(URL.unqid)>
        <cfquery name="qGetStudentID" datasource="MySQL">
        	SELECT
            	studentid, companyid
		    FROM	
            	smg_students       
            WHERE
            	uniqueid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.unqid#">
        </cfquery>
        <cfset CLIENT.studentID = qGetStudentID.studentid>
        
    <cfelse>
      <cfquery name="qGetStudentID" datasource="MySQL">
        	SELECT
            	studentid, companyid
		    FROM	
            	smg_students       
            WHERE
            	studentid = #client.studentid#
        </cfquery>
    </cfif> 
	<!--- End of intrep\int_flight_info.cfm --->

    <Cfquery name="qGetStudentInfo" datasource="MySQL">
        SELECT  
        	s.familylastname, 
            s.firstname, 
            s.studentID, 
            s.hostid, 
            s.flight_info_notes, 
            s.insurance, 
            s.termination_date,
            u.insurance_typeid, 
            u.businessname
            <cfif qGetStudentID.companyid neq 6>,
            p.insurance_startdate,
            h.airport_city, 
            h.major_air_code
            </cfif>
        FROM 
        	smg_students s
        INNER JOIN 
        	smg_users u ON u.userid = s.intrep
            <cfif qGetStudentID.companyid neq 6>
        INNER JOIN 	
        	smg_programs p ON p.programid = s.programid
	    LEFT OUTER JOIN 
        	smg_hosts h ON h.hostid = s.hostid
    		<Cfelse>
        LEFT JOIN php_students_in_program psip on psip.studentid = s.studentid
        INNER JOIN 	
        	smg_programs p ON p.programid = psip.programid
            </cfif>
        WHERE 
        	s.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.studentID#">
    </Cfquery>

    <cfscript>
		// Get Company Information
		qGetCompanyShort = APPCFC.COMPANY.getCompanies(companyID=CLIENT.companyID);
		
		// Get Arrival
		qGetArrival = APPCFC.STUDENT.getFlightInformation(studentID=VAL(qGetStudentInfo.studentID), flightType="arrival");

		// Get Departure
		qGetDeparture = APPCFC.STUDENT.getFlightInformation(studentID=VAL(qGetStudentInfo.studentID), flightType="departure");
	</cfscript>
<!----
</cfsilent>
---->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><cfoutput>Flight Information - #qGetStudentInfo.firstName# #qGetStudentInfo.familyLastName# ###qGetStudentInfo.studentID#</cfoutput></title>
    <link rel="stylesheet" href="../smg.css" type="text/css">
    <!-- DatePicker CSS -->
    <link rel="stylesheet" href="../linked/css/datePicker.css" type="text/css">
    <!-- jQuery -->
    <script src="../linked/js/jquery.js" type="text/javascript"></script>
    <!-- required plugins -->
    <script src="../linked/js/date.js" type="text/javascript"></script>
    <!-- jquery.datePicker.js -->
    <script src="../linked/js/jquery.datePicker.js " type="text/javascript"></script>

    <script type="text/javascript" language="javascript">
		/* Date Pick Function */
		$(function() {            
			$('.date-pick').datePicker({startDate:'01/01/2009'});
		});	

		<!--
        function areYouSure() { 
           if(confirm("You are about to delete this flight information. Click OK to continue")) { 
             FORM.submit(); 
                return true; 
           } else { 
                return false; 
           } 
        } 
        
        /* Script to show certain fields */
        function changeDiv(the_div,the_change)
        {
          var the_style = getStyleObject(the_div);
          if (the_style != false)
          {
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
        if (document.form1.insu_dp_trans_type.value == 'extension') {
                document.form1.insu_dp_new_date.value = (startdate);
            } else {
                document.form1.insu_dp_new_date.value = "";
            }
        if (document.form1.insu_dp_trans_type.value == 'early return') {
                document.form1.insu_dp_end_date.value = (enddate);
            } else {
                document.form1.insu_dp_end_date.value = ""
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
</head>

<body>

<cfoutput>

<br>
<table width="98%" cellpadding="0" cellspacing="0" border="0" height="24" align="center">
	<tr valign="middle" height="24">
		<td height="24" width="13" background="../pics/header_leftcap.gif">&nbsp;</td>
		<td width="26" background="../pics/header_background.gif"><img src="../pics/students.gif"></td>
		<td background="../pics/header_background.gif"><h2>FLIGHT INFORMATION</h2></td>
		<td align="right" background="../pics/header_background.gif"><h2>#qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# (#qGetStudentInfo.studentID#)</h2></td>
		<td width="17" background="../pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table width="98%" border="0" cellpadding="4" cellspacing="0" class="section" align="center">
    <tr>
    	<td>
    
    		<!--- Start of intrep\int_flight_info.cfm --->
            <cfif qGetStudentInfo.insurance_typeid GT 1>
                <p align="center" style="color:##F00">
                    * Please be aware that flight information provided by you will affect the student's insurance start or end date.<br />
                    Please submit only confirmed arrivals/departures.
                </p>
            </cfif>
			<!--- End of intrep\int_flight_info.cfm --->
            
			<cfif VAL(FORM.submitted)>
                <br /><div align="center"><span class="get_Attention"><b>Flight Information Updated</b></span></div><br />
            </cfif>            

            <form name="form1" action="int_flight_info.cfm" method="post">
			<input type="hidden" name="submitted" value="1" />
			<input type="hidden" name="studentID" value="#qGetStudentInfo.studentID#" />
            <input type="hidden" name="insuranceTypeID" value="#qGetStudentInfo.insurance_typeid#" />
            
			<!--- A R R I V A L    I N F O R M A T I O N --->
            <table border="0" align="center" width="99%" bordercolor="##C0C0C0" valign="top" cellpadding="3" cellspacing="1">
            	<th colspan="11" bgcolor="##ACB9CD"> A R R I V A L &nbsp;&nbsp; T O &nbsp; &nbsp; U S A &nbsp; &nbsp; I N F O R M A T I O N </th>
            	<tr bgcolor="##ACB9CD">
                    <th><font size="-2"><b>Delete</b></font></th>
                    <th>Date <br /> (mm/dd/yyyy)</th>
                    <th>Departure <br /> City</th>
                    <th>Airport <br /> Code</th>
                    <th>Arrival <br /> City</th>
                    <th>Airport <br /> Code</th>
                    <th>Flight <br /> Number</th>
                    <th>Departure Time <br />(12:00am)</th>
                    <th>Arrival Time <br />(12:00am)</th>
                    <th>Overnight <br /> Flight</th>
                    <th><font size="-2"><b>Status</b></font></th>
            	</tr>
               <cfif qGetStudentID.companyid neq 6>
            	<tr bgcolor="##ACB9CD">
                	<td colspan="11">The Airport Arrival is: &nbsp; #qGetStudentInfo.airport_city# - #qGetStudentInfo.major_air_code#</td>
                </tr> 
                </cfif>

				<cfif NOT VAL(qGetArrival.recordcount) OR IsDefined('URL.add_arr')>
                    <input type="hidden" name="ar_update" value='new'>
                    
					<!--- Previous Flight Information --->
                    <cfloop query="qGetArrival"> 
                        <tr bgcolor="##D5DCE5">
                            <td align="center"><a href="del_int_flight_info.cfm?flightid=#flightid#" onClick="return areYouSure(this);"><img src="../pics/deletex.gif" border="0"></img></a></td>
                            <td align="center">#DateFormat(qGetArrival.dep_date , 'mm/dd/yyyy')#&nbsp;</td>
                            <td align="center">#qGetArrival.dep_city#&nbsp;</td>
                            <td align="center">#qGetArrival.dep_aircode#&nbsp;</td>
                            <td align="center">#qGetArrival.arrival_city#&nbsp;</td>
                            <td align="center">#qGetArrival.arrival_aircode#&nbsp;</td>
                            <td align="center">#qGetArrival.flight_number#&nbsp;</td>
                            <td align="center">#TimeFormat(qGetArrival.dep_time, 'hh:mm tt')#&nbsp;</td>
                            <td align="center">#TimeFormat(qGetArrival.arrival_time, 'h:mm tt')#&nbsp;</td>
                            <td align="center"><input type="checkbox" name="ar_overnight#qGetArrival.currentrow#" value="1" disabled <cfif VAL(qGetArrival.overnight)> checked="checked" </cfif> ></td>
                            <td align="center">
                                <cfif LEN(qGetArrival.flight_number)>
                                	<a href="http://dps1.travelocity.com/dparflifo.ctl?aln_name=#left(qGetArrival.flight_number,2)#&flt_num=#RemoveChars(qGetArrival.flight_number,1,2)#" target="blank">
                                    	<img src="../pics/arrow.gif" border="0"></img>
                                    </a>
                                <cfelse>
                               		n/a
                                </cfif>
                          	</td>
                        </tr>
                    </cfloop>
                    
                    <!--- NEW FLIGHT INFORMATION --->
                    <cfloop from="1" to="4" index="i"> 
                        <tr bgcolor="##D5DCE5">
                            <td>&nbsp;</td>
                            <td><input type="text" name="ar_dep_date#i#" class="date-pick" maxlength="10" onChange="return checkDate(this)"></td>
                            <td><input type="text" name="ar_dep_city#i#" size="7" maxlength="40"></td>
                            <td><input type="text" name="ar_dep_aircode#i#" size="1" maxlength="3" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                            <td><input type="text" name="ar_arrival_city#i#" size="7" maxlength="40"></td>
                            <td><input type="text" name="ar_arrival_aircode#i#" size="1" maxlength="3" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                            <td><input type="text" name="ar_flight_number#i#" size="4" maxlength="8" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                            <td><input type="text" name="ar_dep_time#i#" size="5" maxlength="8"></td>
                            <td><input type="text" name="ar_arrival_time#i#" size="5" maxlength="8"></td>
                            <td align="center"><input type="checkbox" name="ar_overnight#i#" value="1"></td>
                            <td align="center">&nbsp;</td>
                        </tr>
                    </cfloop>
                
                <!--- EDIT FLIGHT INFORMATION --->                
                <cfelse> 
                    <input type="hidden" name="ar_update" value='update'>
                    <input type="hidden" name="ar_count" value='#qGetArrival.recordcount#'>
                    <cfloop query="qGetArrival">
                        <input type="hidden" name="ar_flightid#qGetArrival.currentrow#" value="#flightid#">
                        <tr bgcolor="##D5DCE5">                        
	                        <td align="center"><a href="del_int_flight_info.cfm?flightid=#flightid#" onClick="return areYouSure(this);"><img src="../pics/deletex.gif" border="0"></img></a></td>
                            <td><input type="text" name="ar_dep_date#qGetArrival.currentrow#" value="#DateFormat(dep_date , 'mm/dd/yyyy')#" class="date-pick" maxlength="10"></td>
                            <td><input type="text" name="ar_dep_city#qGetArrival.currentrow#" size="7" maxlength="40" value="#dep_city#"></td>
                            <td><input type="text" name="ar_dep_aircode#qGetArrival.currentrow#" size="1" maxlength="3" value="#dep_aircode#" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                            <td><input type="text" name="ar_arrival_city#qGetArrival.currentrow#" size="7" maxlength="40" value="#arrival_city#"></td>
                            <td><input type="text" name="ar_arrival_aircode#qGetArrival.currentrow#" size="1" maxlength="3" value="#arrival_aircode#" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                            <td><input type="text" name="ar_flight_number#qGetArrival.currentrow#" size="4" maxlength="8" value="#flight_number#" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                            <td><input type="text" name="ar_dep_time#qGetArrival.currentrow#" size="5" maxlength="8" value="#TimeFormat(dep_time, 'hh:mm tt')#"></td>
                            <td><input type="text" name="ar_arrival_time#qGetArrival.currentrow#" size="5" maxlength="8" value="#TimeFormat(arrival_time, 'h:mm tt')#"></td>
                        	<td align="center"><input type="checkbox" name="ar_overnight#qGetArrival.currentrow#" value="1" <cfif VAL(qGetArrival.overnight)> checked="checked" </cfif> ></td>
                        	<td align="center">
                        		<cfif LEN(qGetArrival.flight_number)>
                        			<a href="http://dps1.travelocity.com/dparflifo.ctl?aln_name=#left(qGetArrival.flight_number,2)#&flt_num=#RemoveChars(qGetArrival.flight_number,1,2)#" target="blank"><img src="../pics/arrow.gif" border="0"></img></a>
                                <cfelse>
                               		n/a
                                </cfif>
                         	</td>
                        </tr>	
                    </cfloop>
                    
                    <tr bgcolor="##D5DCE5"><td colspan="11" align="center"><a href="int_flight_info.cfm?add_arr=yes">Add more legs to the flight information above</a></td></tr>
                    
                    <tr bgcolor="##D5DCE5">
                    	<td colspan="11" align="center"><font size=-1>*Flight tracking information by Travelocity, not all flights will be available. #qGetCompanyShort.companyshort_nocolor# is not responsible for information on or gathered from travelocity.com.</font></td>
                    </tr>
                </cfif>
			</table>
			
            <br>
	
            <table border="0" align="center" width="99%" bordercolor="##C0C0C0" valign="top" cellpadding="3" cellspacing="1">
            	<th bgcolor="##ACB9CD"> N O T E S &nbsp; O N &nbsp; T H I S &nbsp; F L I G H T &nbsp; I N F O R M A T I O N </tr>
            	<tr bgcolor="##D5DCE5">
                	<td align="center"><textarea cols="75" rows="3" name="flight_notes" wrap="VIRTUAL">#qGetStudentInfo.flight_info_notes#</textarea></td>
                </tr>
            </table><br>
		
			<!--- D E P A R T U R E      I N F O R M A T I O N    --->
            <table border="0" align="center" width="99%" bordercolor="##C0C0C0" valign="top" cellpadding="3" cellspacing="1">
                <th colspan="11" bgcolor="##FDCEAC">D E P A R T U R E &nbsp;&nbsp; F R O M &nbsp; &nbsp; U S A  &nbsp; &nbsp; I N F O R M A T I O N</th>
                <tr bgcolor="##FDCEAC">
                    <th><font size="-2"><b>Delete</b></font></th>
                    <th>Date <br /> (mm/dd/yyyy)</th>
                    <th>Departure <br /> City</th>
                    <th>Airport <br /> Code</th>
                    <th>Arrival <br /> City</th>
                    <th>Airport <br /> Code</th>
                    <th>Flight <br /> Number</th>
                    <th>Departure Time <br /> (12:00am)</th>
                    <th>Arrival Time <br /> (12:00am)</th>
                    <th>Overnight <br /> Flight</th>
                    <th><font size="-2"><b>Status</b></font></th>
                </tr>
            	<cfif NOT VAL(qGetDeparture.recordcount) OR IsDefined('URL.add_dep')>
            		<input type="hidden" name="dp_update" value='new'>
            
                    <cfloop query="qGetDeparture">
                        <tr bgcolor="##FEE6D3">
                            <td align="center"><a href="del_int_flight_info.cfm?flightid=#flightid#" onClick="return areYouSure(this);"><img src="../pics/deletex.gif" border="0"></img></a></td>
                            <td>#DateFormat(qGetDeparture.dep_date , 'mm/dd/yyyy')#&nbsp;</td>
                            <td align="center">#qGetDeparture.dep_city#&nbsp;</td>
                            <td align="center">#qGetDeparture.dep_aircode#&nbsp;</td>
                            <td>#qGetDeparture.arrival_city#&nbsp;</td>
                            <td align="center">#qGetDeparture.arrival_aircode#&nbsp;</td>
                            <td align="center">#qGetDeparture.flight_number#&nbsp;</td>
                            <td align="center">#TimeFormat(qGetDeparture.dep_time, 'hh:mm tt')#&nbsp;</td>
                            <td align="center">#TimeFormat(qGetDeparture.arrival_time, 'h:mm tt')#&nbsp;</td>
                            <td align="center"><input type="checkbox" name="ar_overnight#qGetArrival.currentrow#" value="1" disabled <cfif VAL(qGetDeparture.overnight)> checked="checked" </cfif> ></td>
                            <td align="center">
                            	<cfif LEN(qGetDeparture.flight_number)>
                            		<a href="http://dps1.travelocity.com/dparflifo.ctl?aln_name=#left(qGetDeparture.flight_number,2)#&flt_num=#RemoveChars(qGetDeparture.flight_number,1,2)#" target="blank"><img src="../pics/arrow.gif" border="0"></img></a>
								<cfelse>
                                	n/a
                                </cfif>
                            </td>
                        </tr>
                    </cfloop>
					
                    <!--- ADD NEW FLIGHT INFORMATION --->
                    <cfloop from="1" to="4" index="i"> 
                        <input type="hidden" name="dp_type#i#" value="departure">
                        <tr bgcolor="##FEE6D3">                        
                            <td>&nbsp;</td>
                            <td><input type="text" name="dp_dep_date#i#" class="date-pick" maxlength="10"></td>
                            <td><input type="text" name="dp_dep_city#i#" size="7" maxlength="40"></td>
                            <td><input type="text" name="dp_dep_aircode#i#" size="1" maxlength="3" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                            <td><input type="text" name="dp_arrival_city#i#" size="7" maxlength="40"></td>
                            <td><input type="text" name="dp_arrival_aircode#i#" size="1" maxlength="3" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                            <td><input type="text" name="dp_flight_number#i#" size="4" maxlength="8" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                            <td><input type="text" name="dp_dep_time#i#" size="5" maxlength="8"></td>
                            <td><input type="text" name="dp_arrival_time#i#" size="5" maxlength="8"></td>
                            <td align="center"><input type="checkbox" name="dp_overnight#i#" value="1"></td>
                            <td>&nbsp;</td>
                        </tr>
                    </cfloop>
                
                <!--- ADD/EDIT FLIGHT INFORMATION --->
                <cfelse> 
                    <input type="hidden" name="dp_update" value='update'>
                    <input type="hidden" name="dp_count" value='#qGetDeparture.recordcount#'>
                
                    <cfloop query="qGetDeparture">	
                        <input type="hidden" name="dp_flightid#qGetDeparture.currentrow#" value="#flightid#">
                        <tr bgcolor="##FEE6D3">                        
                            <td align="center"><a href="del_int_flight_info.cfm?flightid=#flightid#" onClick="return areYouSure(this);"><img src="../pics/deletex.gif" border="0"></img></a></td>
                            <td><input type="text" name="dp_dep_date#qGetDeparture.currentrow#" value="#DateFormat(dep_date , 'mm/dd/yyyy')#" class="date-pick" maxlength="10"></td>
                            <td><input type="text" name="dp_dep_city#qGetDeparture.currentrow#" size="7" maxlength="40" value="#dep_city#"></td>
                            <td><input type="text" name="dp_dep_aircode#qGetDeparture.currentrow#" size="1" maxlength="3" value="#dep_aircode#" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                            <td><input type="text" name="dp_arrival_city#qGetDeparture.currentrow#" size="7" maxlength="40" value="#arrival_city#"></td>
                            <td><input type="text" name="dp_arrival_aircode#qGetDeparture.currentrow#" size="1" maxlength="3" value="#arrival_aircode#" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                            <td><input type="text" name="dp_flight_number#qGetDeparture.currentrow#" size="4" maxlength="8" value="#flight_number#" onChange="javascript:this.value=this.value.toUpperCase();"></td>
                            <td><input type="text" name="dp_dep_time#qGetDeparture.currentrow#" size="5" maxlength="8" value="#TimeFormat(dep_time, 'hh:mm tt')#"></td>
                            <td><input type="text" name="dp_arrival_time#qGetDeparture.currentrow#" size="5" maxlength="8" value="#TimeFormat(arrival_time, 'h:mm tt')#"></td>
                            <td align="center"><input type="checkbox" name="dp_overnight#qGetDeparture.currentrow#" value="1" <cfif VAL(qGetDeparture.overnight)> checked="checked" </cfif> ></td>
                            <td align="center">
								<cfif LEN(qGetDeparture.flight_number)>
                                    <a href="http://dps1.travelocity.com/dparflifo.ctl?aln_name=#left(qGetDeparture.flight_number,2)#&flt_num=#RemoveChars(qGetDeparture.flight_number,1,2)#" target="blank"><img src="../pics/arrow.gif" border="0"></img></a>
                                <cfelse>
                                    n/a
                                </cfif>
                        	</td>
                        </tr>	
                    </cfloop>
                    
                    <tr bgcolor="##FEE6D3"><td colspan="11" align="center"><a href="int_flight_info.cfm?add_dep=yes">Add more legs to the flight information above</a></td></tr>
                    
                	<tr bgcolor="##FEE6D3"><td colspan="11" align="center"><font size=-1>*Flight tracking information by Travelocity, not all flights will be available. #qGetCompanyShort.companyshort_nocolor# is not responsible for information on or gathered from travelocity.com.</font></td></tr>
               
                </cfif>
            </table>
            
		</td>
	</tr>
</table> <!--- end of main table --->

<table border="0" cellpadding="4" cellspacing="0" width="98%" class="section" align="center">
    <tr>
        <td align="right" width="50%"><input name="Submit" type="image" src="../pics/update.gif" border="0" alt=" update ">&nbsp;</td>
    	<td align="left" width="50%">&nbsp;<input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()"></td></tr>
</table>

<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
	<tr valign="bottom">
		<td width="9" valign="top" height="12"><img src="../pics/footer_leftcap.gif" ></td>
		<td width="98%" background="../pics/header_background_footer.gif"></td>
		<td width="9" valign="top"><img src="../pics/footer_rightcap.gif"></td>
	</tr>
</table>

</form>

</cfoutput>

</body>
</html>
