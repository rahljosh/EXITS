<!--- ------------------------------------------------------------------------- ----
	
	File:		profile.cfm
	Author:		Marcus Melo
	Date:		October 10, 2011
	Desc:		Profile
	
	Updates:	
	
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

    <!--- Param URL Variables --->
    <cfparam name="URL.studentID" default="0">
    <cfparam name="URL.tripID" default="0">

    <!--- Param FORM Variables --->
    <cfparam name="FORM.action" default="">
    <cfparam name="FORM.studentID" default="">
    <cfparam name="FORM.tripID" default="">
    <cfparam name="FORM.newtripID" default="">
    <cfparam name="FORM.emailAddress" default="">
	
    <cfscript>
		if ( VAL(URL.studentID) ) {
			FORM.studentID = URL.studentID;	
		}
		
		if ( VAL(URL.tripID) ) {
			FORM.tripID = URL.tripID;	
		}
	</cfscript>
    
    <cfquery name="qGetRegistrationInfo" datasource="#APPLICATION.DSN#">
        SELECT 
        	td.*,
        	st.id,
        	st.id, 
            st.tripID,
            st.med, 
            st.flightinfo, 
            st.date, 
            st.paid, 
            st.permissionForm,
            st.stuNationality, 
            st.email, 
        	st.person1, 
            st.person2, 
            st.person3, 
            st.nationality, 
            st.dateOnHold,
            st.holdReason, 
            s.studentID,
            s.companyID, 
            s.firstname, 
            s.familylastname, 
            s.dob,
            s.sex, 
            h.local_air_code, 
            h.major_air_code, 
            h.familylastname as hostLast,
            h.phone as hostPhone,
            h.email as hostEmail, 
            h.city as hostCity, 
            h.state as hostState
        FROM 
        	student_tours st
        LEFT OUTER JOIN 
        	smg_students s on s.studentID = st. studentID
        LEFT OUTER JOIN
        	smg_tours td on td.tour_id = st.tripID
        LEFT OUTER JOIN 
        	smg_hosts h on h.hostid = s.hostid
        WHERE 
            st.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.studentID)#">
        AND	
            st.tripID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.tripID)#">
    </cfquery>
    
    <!----Get Siblings on tours---->
    <cfquery name="qGetSiblingsRegistered" datasource="#APPLICATION.DSN#">
        SELECT 
            sibs.id,
            sibs.siblingid, 
            shc.name, 
            shc.lastname, 
            shc.birthdate, 
            shc.sex, 
            sibs.paid
        FROM 
            student_tours_siblings sibs
        LEFT OUTER JOIN
            smg_host_children shc on shc.childid = sibs.siblingid
        WHERE
            fk_studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.studentID)#">
        AND
            tripID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.tripID)#">
        AND 
            sibs.PAID IS NOT <cfqueryparam cfsqltype="cf_sql_date" null="yes">
        AND 
            sibs.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
    </cfquery>
    
    <!----Get available Tours so tours can be changed if needed---->
    <cfquery name="qGetAvailableTours" datasource="#APPLICATION.DSN#">
    	SELECT
        	tour_id, 
            tour_name
    	FROM
        	smg_tours
        WHERE
	        tour_status != <cfqueryparam cfsqltype="cf_sql_varchar" value="inactive">
    </cfquery>
	
    <!--- Check what action --->
    <cfswitch expression="#FORM.action#">
    
    	<cfcase value="resendEmail">
    
			<!--- Resend Email --->
            <cfif IsValid("email", FORM.emailAddress)>
                    
                <!--- trip Permission --->
                <cfdocument format="PDF" filename="#APPLICATION.PATH.temp#permissionForm_#VAL(qGetRegistrationInfo.studentID)#.pdf" overwrite="yes" margintop="0.2" marginbottom="0.2">
                    
                    <cfinclude template="tripPermission.cfm">
                    
                </cfdocument>
            
                <!--- Email to Student --->    
                <cfsavecontent variable="stuEmailMessage">		
                    <p>****This email was resent per your request.*****</p>
                    
                    <p>		
                        <h3>
                            A spot has been reserved for you <cfif VAL(qGetSiblingsRegistered.recordCount)> and #ValueList(qGetSiblingsRegistered.name)# </cfif> on the <strong>#qGetTourDetails.tour_name#</strong> tour.
                        </h3>
                            
                        <font color="red">* * Your spot will not be confirmed until permission form has been received by MPD Tours America.Please work on getting this completed as soon as possible * *</font> 
                    </p>
                    
                    <p>
                        Attached is a Student Packet with hotel, airport arrival instructions, emergency numbers, etc.  
                        Please keep this handy for your trip and leave a copy with your host family while you are on the trip.
                    </p>
                    
                    <p>
                        Please return the permission form by:<br />
                        <ul>
                            <li>email: info@mpdtoursamerica.com</li>
                            <li>fax:   +1 718 439 8565</li>
                            <li>mail:  9101 Shore Road, ##203 - Brooklyn, NY 11209</li>
                        </ul>
                    </p>
                
                    <p>
                        Please visit our website for additional questions. 
                        <a href="http://trips.exitsapplication.com/frequently-asked-questions.cfm">http://trips.exitsapplication.com/frequently-asked-questions.cfm</a>
                    </p>
                    
                    <p>If you have any questions that are not answerd please don't hesitate to contact us at #APPLICATION.MPD.email#. </p>
                    
                    <p>See you soon!</p>
                    
                    <p>
                        MPD Tour America, Inc.<br />
                        9101 Shore Road ##203- Brooklyn, NY 11209<br />
                        Email: info@mpdtoursamerica.com<br />
                        TOLL FREE: 1-800-983-7780<br />
                        Fax: 1-(718)-439-8565
                    </p>
                </cfsavecontent>   
                
                <cfinvoke component="nsmg.cfc.email" method="send_mail">
                    <cfinvokeargument name="email_from" value="<info@mpdtoursamerica.com> (Trip Support)">
                    <cfinvokeargument name="email_to" value="#FORM.emailAddress#">
                    <cfinvokeargument name="email_bcc" value="trips@iseusa.com">
                    <cfinvokeargument name="email_subject" value="Your #qGetRegistrationInfo.tour_name# trip Details">
                    <cfinvokeargument name="email_message" value="#stuEmailMessage#">
                    <cfinvokeargument name="email_file" value="#APPLICATION.PATH.temp#permissionForm_#VAL(qGetRegistrationInfo.studentID)#.pdf">
                    <cfinvokeargument name="email_file2" value="#APPLICATION.PATH.uploadedFiles#tours/#qGetRegistrationInfo.packetfile#">
                </cfinvoke>	
            	
                <cfscript>
					SESSION.pageMessages.Add("Forms have been resent to #FORM.emailAddress#");
					
					Location("#CGI.SCRIPT_NAME#?curdoc=tours/profile&studentID=#FORM.studentID#&tripID=#FORM.newtripID#", "no");
				</cfscript>
            
            <cfelse>
            
                <cfscript>
					SESSION.formErrors.Add("Please provide a valid email address");
				</cfscript>
                
            </cfif> 
            <!--- End of Resend Email --->	
        
        </cfcase>
        
        <cfcase value="updateTripInfo">

            <cfquery datasource="#APPLICATION.DSN#">
                UPDATE 
                    student_tours
                SET 
                    tripID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.newtripID#">
                WHERE 
                    studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.studentID)#">
                AND	
                    tripID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.tripID)#">
            </cfquery>

			<cfscript>
                SESSION.pageMessages.Add("Trip information has been updated");

				Location("#CGI.SCRIPT_NAME#?curdoc=tours/profile&studentID=#FORM.studentID#&tripID=#FORM.newtripID#", "no");
            </cfscript>
        
        </cfcase>

        <cfcase value="removeHold">

            <cfquery datasource="#APPLICATION.DSN#">
                UPDATE 
                    student_tours
                SET
                    dateOnHold = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    holdReason = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
                WHERE 
                    studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.studentID#">
            </cfquery>

			<cfscript>
                SESSION.pageMessages.Add("Hold has been removed");

				Location("#CGI.SCRIPT_NAME#?curdoc=tours/profile&studentID=#FORM.studentID#&tripID=#FORM.tripID#", "no");
            </cfscript>
        
        </cfcase>

        <cfcase value="permissionReceived">

            <cfquery datasource="#APPLICATION.DSN#">
                UPDATE 
                    student_tours
                SET 
                    permissionForm = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
                WHERE 
                    studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.studentID#">
            </cfquery>

			<cfscript>
                SESSION.pageMessages.Add("Permission form has been set as RECEIVED");

				Location("#CGI.SCRIPT_NAME#?curdoc=tours/profile&studentID=#FORM.studentID#&tripID=#FORM.tripID#", "no");
            </cfscript>
        
        </cfcase>

        <cfcase value="permissionNOTReceived">

            <cfquery datasource="#APPLICATION.DSN#">
                UPDATE 
                    student_tours
                SET 
                    permissionForm = <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                WHERE 
                    studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.studentID#">
            </cfquery>

			<cfscript>
                SESSION.pageMessages.Add("Permission form has been set as NOT RECEIVED");

				Location("#CGI.SCRIPT_NAME#?curdoc=tours/profile&studentID=#FORM.studentID#&tripID=#FORM.tripID#", "no");
            </cfscript>
        
        </cfcase>
        
        <cfcase value="flightInfoBooked">

            <cfquery datasource="#APPLICATION.DSN#">
                UPDATE 
                    student_tours
                SET 
                    flightInfo = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
                WHERE 
                    studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.studentID#">
            </cfquery>

			<cfscript>
                SESSION.pageMessages.Add("Flight information has been set as BOOKED");

				Location("#CGI.SCRIPT_NAME#?curdoc=tours/profile&studentID=#FORM.studentID#&tripID=#FORM.tripID#", "no");
            </cfscript>
        
        </cfcase>

        <cfcase value="flightInfoNotBooked">

            <cfquery datasource="#APPLICATION.DSN#">
                UPDATE 
                    student_tours
                SET 
                    flightINfo = <cfqueryparam cfsqltype="cf_sql_date" null="yes">           
                WHERE 
                    studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.studentID#">
            </cfquery>

			<cfscript>
                SESSION.pageMessages.Add("Flight information has been set as NOT BOOKED");

				Location("#CGI.SCRIPT_NAME#?curdoc=tours/profile&studentID=#FORM.studentID#&tripID=#FORM.tripID#", "no");
            </cfscript>
        
        </cfcase>
        
    </cfswitch>
        
</cfsilent>

<link rel="stylesheet" href="tours/trips.css" type="text/css"> <!-- trips -->

<cfoutput>

	<!--- Table Header --->
    <gui:tableHeader
        imageName="plane.png"
        tableTitle="Student Details"
        tableRightTitle='<a href="index.cfm?curdoc=tours/mpdtours&tour_id=#FORM.tripID#&submitted=1">Back to List</a>'
    />

	<!--- Page Messages --->
    <gui:displayPageMessages 
        pageMessages="#SESSION.pageMessages.GetCollection()#"
        messageType="tableSection"
        width="100%"
        />
    
    <!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="tableSection"
        width="100%"
        />

    <table border="0" cellpadding="4" cellspacing="0" class="section" width="100%">
        <tr>
            <td rowspan="5">
                <img src="https://ise.exitsapplication.com/nsmg/uploadedfiles/web-students/#qGetRegistrationInfo.studentID#.jpg" height="150"/> 
                <br />
                <span class="greyText">DOB:</span> <span class="bigLabel">#DateFormat(qGetRegistrationInfo.dob, 'mm/dd/yyyy')#</span>
                <br />
                <span class="greyText">Gender:</span> <span class="bigLabel">#qGetRegistrationInfo.sex#</span>
            </td>
            <td><span class="greyText">Name</span><br /><span class="bigLabel">#qGetRegistrationInfo.firstname# #qGetRegistrationInfo.familylastname# (###qGetRegistrationInfo.studentID#)</span></td>
            <td rowspan="5" valign="top">
                
                <table cellpadding="4" cellspacing="0" border="0">
                    <tr>
                        <td valign="top">
                            <span class="greyText">Host Family </span>
                            <br />
                            <span class="bigLabel">#qGetRegistrationInfo.hostLast#</span>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top">
                            <span class="greyText">Host Phone</span>
                            <br />
                            <span class="bigLabel">#qGetRegistrationInfo.hostPhone#</span>
                        </td>
                    </tr>                
                   <tr>
                        <td valign="top">
                            <span class="greyText">Host Email</span>
                            <br />
                            <span class="bigLabel">#qGetRegistrationInfo.hostEmail#</span>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top">
                            <span class="greyText">Host City & State</span>
                            <br />
                            <span class="bigLabel">#qGetRegistrationInfo.hostCity# #qGetRegistrationInfo.hostState#</span>
                        </td>
                    </tr>
                </table>
                
            </td>
            <td rowspan="5" valign="top">
            
                <table cellpadding="4" cellspacing="0" border="0">
                    <tr>
                        <td valign="top">
                            <span class="greyText">#qGetRegistrationInfo.firstname# Nationality </span>
                            <br />
                            <span class="bigLabel">#qGetRegistrationInfo.stunationality#</span>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top">
                            <span class="greyText">Roomate Nationality</span>
                            <br />
                            <span class="bigLabel">#qGetRegistrationInfo.nationality#</span>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top">
                            <span class="greyText">Roommate Requests</span>
                            <br />
                            <span class="bigLabel">
                                <cfif NOT LEN(qGetRegistrationInfo.person1) AND NOT LEN(qGetRegistrationInfo.person2) AND NOT LEN(qGetRegistrationInfo.person3)>
                                    None
                                <cfelse>
                                    <cfif LEN(qGetRegistrationInfo.person1)>#qGetRegistrationInfo.person1#<br /></cfif> 
                                    <cfif LEN(qGetRegistrationInfo.person2)>#qGetRegistrationInfo.person2#<br /></cfif> 
                                    <cfif LEN(qGetRegistrationInfo.person3)>#qGetRegistrationInfo.person3#<br /></cfif> 
                                </cfif>
							</span>                                
                        </td>
                    </tr>
                </table>
            
                <br />
                <span class="greyText">Medical / Allergy Info</span>
                <br />
                <span class="bigLabel">#qGetRegistrationInfo.med#</span>
           
            </td>
        </tr>
        <tr>
            <td valign="top">
                <span class="greyText">Tour</span>
                <form action="#CGI.SCRIPT_NAME#?curdoc=tours/profile" method="post">
                	<input type="hidden" name="action" value="updateTripInfo" />
                    <input type="hidden" name="studentID" value="#FORM.studentID#" />
                    <input type="hidden" name="tripID" value="#FORM.tripID#" />
  
                    <select name="newtripID">
                        <cfloop query="qGetAvailableTours">
                            <option value="#qGetAvailableTours.tour_id#" <cfif qGetRegistrationInfo.tripID EQ qGetAvailableTours.tour_id>selected</cfif>>#qGetAvailableTours.tour_name#</option>
                        </cfloop>
                    </select>
                    
                    <input type="submit" value="Update trip" />
                </form>
            </td>
        </tr>
        <tr>
            <td valign="top">
                <span class="greyText">Registered</span>
                <br />
                <span class="bigLabel">#DateFormat(qGetRegistrationInfo.date)#</span>
            </td>
        </tr>
        <tr>
            <td valign="top">
                <span class="greyText">Email</span>
                <br />
                <span class="bigLabel">#qGetRegistrationInfo.email#</span>
            </td>
        </tr>
        <tr>
            <td valign="top">
                <span class="greyText">Prefered Airport / Alt. Airport</span>
                <br />
                <span class="bigLabel">
                    <cfif NOT LEN(qGetRegistrationInfo.local_air_code)>
                        none
                    <cfelse>
                        #qGetRegistrationInfo.local_air_code#
                    </cfif> 
                    / 
                    <cfif NOT LEN(qGetRegistrationInfo.major_air_code)>
                        none
                    <cfelse>
                        #qGetRegistrationInfo.major_air_code#
                    </cfif> 
                </span>
            </td>
        </tr>
    </table>
	
    <table border="0" cellpadding="4" cellspacing="0" class="section" width="100%">
        <tr>
            <td>
            
                <table cellpadding="4" cellspacing="0" border="0" align="center">
                    <tr style="text-align:center;">
                        <td><h2>Hold</h2></td>
                        <td><h2>Payment</h2></td>
                        <td><h2>Permission</h2></td>
                        <td><h2>Flights</h2></td>
                    </tr>
                    <tr style="text-align:center;">
                        <td>#dateFormat(qGetRegistrationInfo.dateOnHold, 'mm/dd/yyyy')#</td>
                        <td>#dateFormat(qGetRegistrationInfo.paid, 'mm/dd/yyyy')#</td>
                        <td>#dateFormat(qGetRegistrationInfo.permissionForm, 'mm/dd/yyyy')#</td>
                        <td>#dateFormat(qGetRegistrationInfo.flightInfo, 'mm/dd/yyyy')#</td>
                	</tr>
                    <tr style="text-align:center;">
                        <!--- On Hold --->
                        <td>
                            <cfif NOT isDate(qGetRegistrationInfo.dateOnHold)>
                                
                                <form method="post" action="index.cfm?curdoc=tours/hold&studentID=#FORM.studentID#&tripID=#FORM.tripID#">
                                    <input type="hidden" name="putHold" value="#FORM.studentID#" />
                                    
                                    <cfif listFind("1,2,3,4", CLIENT.userType)>                        
                                        <input name="submit" type="image" src="pics/buttons/putHold_25.png" />
                                    <cfelse>
                                        <img src="pics/buttons/putHold_25.png" border="0" />
                                    </cfif>
                                
                                </form>
                                    
                            <cfelse>
            
                                <form method="post" action="#CGI.SCRIPT_NAME#?curdoc=tours/profile">
                                    <input type="hidden" name="action" value="removeHold">
                                    <input type="hidden" name="studentID" value="#FORM.studentID#" />
                                    <input type="hidden" name="tripID" value="#FORM.tripID#" />                                    
            
                                    <cfif listFind("1,2,3,4", CLIENT.userType)>                        
                                        <input name="submit" type="image" src="pics/buttons/removeHold_29.png" />
                                    <cfelse>
                                        <img src="pics/buttons/removeHold_29.png" border="0" />
                                    </cfif>
            
                                </form>
                            
                            </cfif>
                        </td>
                        <!--- Payment --->
                        <td>
                            <img src="pics/buttons/received_17.png" border="0" />
                        </td>
                        <!--- Permission --->
                        <td>
                            <cfif NOT LEN(qGetRegistrationInfo.permissionForm)>
                            
                                <form method="post" action="#CGI.SCRIPT_NAME#?curdoc=tours/profile">
                                    <input type="hidden" name="action" value="permissionReceived">
                                    <input type="hidden" name="studentID" value="#FORM.studentID#" />
                                    <input type="hidden" name="tripID" value="#FORM.tripID#" />                                    
                                    <input type="image" src="pics/buttons/Notreceived_21.png" >
                                </form>
                                
                            <cfelse>
                            
                                <form method="post" action="#CGI.SCRIPT_NAME#?curdoc=tours/profile">
                                    <input type="hidden" name="action" value="permissionNOTReceived">
                                    <input type="hidden" name="studentID" value="#FORM.studentID#" />
                                    <input type="hidden" name="tripID" value="#FORM.tripID#" />                                    
                                    <input type="image" src="pics/buttons/received_17.png" >
                                </form>
                                
                            </cfif>
                        </td>
                        <!--- Flights --->
                        <td>
                            <cfif NOT LEN(qGetRegistrationInfo.flightInfo)>
                            
                                <form method="post" action="#CGI.SCRIPT_NAME#?curdoc=tours/profile">
									<input type="hidden" name="action" value="flightInfoBooked">                                    
                                    <input type="hidden" name="studentID" value="#FORM.studentID#" />
                                    <input type="hidden" name="tripID" value="#FORM.tripID#" />
                                    <input type="image" src="pics/buttons/notbooked_35.png" >
                                </form>
                                
                            <cfelse>
                            
                                <form method="post" action="#CGI.SCRIPT_NAME#?curdoc=tours/profile">
                                    <input type="hidden" name="action" value="flightInfoNotBooked">
                                    <input type="hidden" name="studentID" value="#FORM.studentID#" />
                                    <input type="hidden" name="tripID" value="#FORM.tripID#" />                                    
                                    <input type="image" src="pics/buttons/booked_32.png" >
                                </form>
                                
                            </cfif>
                        </td>
                    </tr>
            
					<cfif isDate(qGetRegistrationInfo.dateOnHold)>
                        <tr>
                            <td colspan="4"><h2>Hold Reason</h2></td>
                        </tr>
                        <tr>
                            <td colspan="4">#qGetRegistrationInfo.holdReason#</td>
                        </tr>
                    </cfif>
                                        
        		</table>
	
			</td>
		</tr>
	</table>                    
	    
	<!--- Siblings Information --->
    <cfif qGetSiblingsRegistered.recordcount>
        <table border="0" cellpadding="4" cellspacing="0" class="section" width="100%">
            <tr>
                <td>
                
                    <table border="0" cellpadding="4" cellspacing="0" width="750px" align="center" style="border:1px solid ##3b5998; margin-top:25px; margin-bottom:25px;">
                        <tr style="background-color:##3b5998; color:##FFF; font-weight:bold;">
                            <th colspan="4" style="border-bottom:1px solid ##FFF;">SIBLINGS GOING ALONG</th>
                        </tr>
                        <tr style="background-color:##3b5998; color:##FFF; font-weight:bold;">
                            <td>Name</td>
                            <td>Age</td>
                            <td>Gender</td>
                            <td>Paid</td>
                        </tr>
                        <cfloop query="qGetSiblingsRegistered">
                            <tr bgcolor="#iif(qGetSiblingsRegistered.currentRow MOD 2 ,DE("ffffe6") ,DE("white") )#">
                                <td>#name# #lastname#</td>
                                <td>#DateDiff('yyyy', '#birthdate#', '#now()#')#</td>
                                <td>#sex#</td>
                                <td>#DateFormat(paid, 'mm/dd/yyyy')#</td>
                            </tr>	
                        </cfloop>
                    </table>
    
                </td>
            </tr>
        </table>
    </cfif>                    
          
	<form action="#CGI.SCRIPT_NAME#?curdoc=tours/profile" method="post"> 
        <input type="hidden" name="studentID" value="#FORM.studentID#" />
        <input type="hidden" name="tripID" value="#FORM.tripID#" />
        <input type="hidden" name="action" value="resendEmail" />
                   
        <table border="0" cellpadding="4" cellspacing="0" class="section" width="100%">
            <tr>
                <td align="center">
                    <span class="greyText">Resend Forms to</span>  <br />
                    <input type="text" name="emailAddress" value="#qGetRegistrationInfo.email#" class="largeField"/> 
                    <input type="submit" value="Resend Email" />
                </td>
             </tr>
    	</table>
  	</form>      
     
    <!--- Table Footer --->
    <gui:tableFooter />

</cfoutput>
