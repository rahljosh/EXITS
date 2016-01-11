<!--- ------------------------------------------------------------------------- ----
	
	File:		_reservationEmail.cfm
	Author:		Marcus Melo
	Date:		September 26, 2011
	Desc:		Email Student and MPD
	
	Updates:	
	
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
    <cfquery name="qGetHostInfo" datasource="#APPLICATION.DSN.Source#">
        SELECT 
        	hostID,
            email 
        FROM 
        	smg_hosts 
		WHERE
        	hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.hostID)#">
	</cfquery>

    <cfquery name="qGetRegionalManager" datasource="#APPLICATION.DSN.Source#">
        SELECT 
        	u.userID,
            u.firstName,
            u.lastName,
            u.email 
        FROM 
        	user_access_rights uar
        INNER JOIN
        	smg_users u ON u.userID = uar.userID 
		WHERE
        	uar.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.regionAssigned)#">
        AND
        	uar.userType = <cfqueryparam cfsqltype="cf_sql_integer" value="5">
	</cfquery>
    
    <cfquery name="qGetAreaRep" datasource="#APPLICATION.DSN.Source#">
    	SELECT *
        FROM smg_users
        WHERE userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.areaRepID)#">
    </cfquery>

</cfsilent>

<cfoutput>	
	
    <!--- Trip Permission --->
    <cfdocument format="PDF" filename="#APPLICATION.PATH.TEMP#permissionForm_#VAL(qGetStudentInfo.studentID)#.pdf" 
     overwrite="yes" margintop="0.2" marginbottom="0.2" localUrl="yes">
		
        <cfinclude template="_tripPermission.cfm">
        
	</cfdocument>

    <!--- Email to Student --->    
    <cfsavecontent variable="stuEmailMessage">
        <p>		
            <h3>
                A spot has been reserved for you <cfif VAL(qGetSiblingsRegistered.recordCount)> and #ValueList(qGetSiblingsRegistered.name)# </cfif> on the <strong>#qGetTourDetails.tour_name#</strong> tour.
            </h3>
                
            <font color="red">*** Your spot will not be confirmed until payment and permission form have been received by MPD Tours America. Please work on getting this completed as soon as possible ***</font> 
        </p>
    
        <p>
        	Attached is a Student Packet with hotel, airport arrival instructions, emergency numbers, etc.  
            Please keep this handy for your trip and leave a copy with your host family while you are on the trip.
        </p>

		<p>
        	Total Cost: #LSCurrencyFormat(vTotalDue)# <br />
            <em class="tripNotesRight">#LSCurrencyFormat(qGetTourDetails.tour_price)# Per person - Does not include your round trip airline ticket</em>
        </p>

        <p>
        	Your spot on the trip is then pending until you mail a: 
            
            <ul class="paragraphRules">
                <li>Business Check</li>
                <li>Personal Check</li>
                <li>Money Order</li>
            </ul>
            
            Made out to <strong>MPD Tour Company</strong>, for the specified cost of your trip found in your confirmation email and sent to: <br /><br />

            #APPLICATION.MPD.name# <br />
            #APPLICATION.MPD.address# <br />
            #APPLICATION.MPD.city#, #APPLICATION.MPD.state# #APPLICATION.MPD.zipCode#
        </p>

        <p>
        	Once the payment of the specified trip has been collected your spot is reserved.
        </p>

        <p>
        	If payment is not collected within 60 days of the trip your spot is vacated.
        </p>
    
        <p>
        	To be fully registered for your trip please return the permission form, emailed to you when you originally signed up, 
            back to MPD Tours signed by your host family, school, natural family, and regional manager. 
        </p>

        <p>
        	Once the permission forms are returned signed then MPD will contact you to book your flights. Do <strong>NOT</strong> book your own flights.
        </p>
        
        <p>
        	It is your responsibility as the student to make sure that this permission form is filled out in its entirety. Once the form is complete, you MUST forward a copy of the completed form to BOTH MPD Tours <cfif qGetStudentInfo.companyID EQ 6>the Program Director, Luke Davis: luke@phpusa.com<cfelse>and your Regional Manager</cfif>.
        </p>
    
        <p>
            Please submit your permission form with all signatures to MPD Tours
            <ul class="paragraphRules">
                <li><a href="mailto:#APPLICATION.MPD.email#">#APPLICATION.MPD.email#</a></li>
                <li>fax: #APPLICATION.MPD.fax#</li>
                <li>mail: #APPLICATION.MPD.address# - #APPLICATION.MPD.city#, #APPLICATION.MPD.state# #APPLICATION.MPD.zipCode#</li>
            </ul>
        </p>
	
        <p>
        	Please visit our website for additional questions. 
        	<a href="https://trips.exitsapplication.com/frequently-asked-questions.cfm">https://trips.exitsapplication.com/frequently-asked-questions.cfm</a>
        </p>
        
        <p>If you have any questions that are not answerd please don't hesitate to contact us at #APPLICATION.MPD.email#. </p>
        
        <p>See you soon!</p>
        
        <p>
        	MPD Tour America, Inc.<br />
            9101 Shore Road ##203- Brooklyn, NY 11209<Br />
            Email: #APPLICATION.MPD.email#<br />
            TOLL FREE: 1-800-983-7780<br />
            Fax: 1-(718)-439-8565
        </p>
    </cfsavecontent>   
    
    <cfinvoke component="extensions.components.email" method="sendEmail">
        <cfinvokeargument name="email_from" value="<#APPLICATION.MPD.email#> (#SESSION.COMPANY.shortName# Trip Support)">
    	<cfinvokeargument name="email_to" value="#qGetRegistrationDetails.email#">
        <cfinvokeargument name="email_bcc" value="#APPLICATION.EMAIL.trips#">
        <cfinvokeargument name="email_subject" value="Your #qGetTourDetails.tour_name# Trip Reservation">
        <cfinvokeargument name="email_message" value="#stuEmailMessage#">
       	<cfinvokeargument name="email_file" value="#APPLICATION.PATH.TEMP#permissionForm_#VAL(qGetStudentInfo.studentID)#.pdf">
        <cfinvokeargument name="email_file2" value="#APPLICATION.PATH.tour##qGetTourDetails.packetfile#">
    </cfinvoke>	
    
    
    <!--- Email to Manager --->
    <cfsavecontent variable="repEmailMessage">
        #qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# (###qGetStudentInfo.studentID#) has reserved a spot to go on the #qGetTourDetails.tour_name# tour.<br /><br />
        
        Dates: #DateFormat(qGetTourDetails.tour_start, 'mmm d, yyyy')# - #DateFormat(qGetTourDetails.tour_end, 'mmm d, yyyy')#
        
        If you feel that #qGetStudentInfo.firstname# should NOT be going on this trip, please notify us by using this 
        <a href="#SESSION.COMPANY.exitsURL#nsmg/index.cfm?curdoc=tours/hold&studentID=#qGetStudentInfo.studentid#&tripID=#qGetTourDetails.tour_id#">form</a> 
        (you will need to be logged in to follow the link)
    </cfsavecontent>
    
    <cfinvoke component="extensions.components.email" method="sendEmail">
        <cfinvokeargument name="email_from" value="<#APPLICATION.MPD.email#> (#SESSION.COMPANY.shortName# Trip Support)">
        <cfinvokeargument name="email_to" value="#qGetRegionalManager.email#,#qGetAreaRep.email#">
        <cfinvokeargument name="email_bcc" value="#APPLICATION.EMAIL.trips#">
        <cfinvokeargument name="email_subject" value="Student Trip Reservation #qGetTourDetails.tour_name# - #qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# (###qGetStudentInfo.studentID#)">
        <cfinvokeargument name="email_message" value="#repEmailMessage#">
    </cfinvoke>	


    <!--- Email to MPD --->
    <cfsavecontent variable="mpdEmailMessage">
        <p>FYI,</p>
        
        <p>#qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# (###qGetStudentInfo.studentID#) has reserved a spot to go on the #qGetTourDetails.tour_name# tour.</p>
        
        <p>
        	<table>
            	<tr>
                	<td><b>Regional Manager</b></td>
                    <td><b>Area Rep</b></td>
                </tr>
                <tr>
                	<td>#qGetRegionalManager.firstName# #qGetRegionalManager.lastName#</td>
                    <td>#qGetAreaRep.firstName# #qGetAreaRep.lastName#</td>
                </tr>
                <tr>
                	<td><b>Regional Manager Phone</b></td>
                    <td><b>Area Rep Phone</b></td>
                </tr>
                <tr>
                	<td>#qGetRegionalManager.phone#</td>
                    <td>#qGetAreaRep.phone#</td>
                </tr>
                <tr>
                	<td><b>Regional Manager Address</b></td>
                    <td><b>Area Rep Address</b></td>
                </tr>
                <tr>
                	<td>#qGetRegionalManager.address# #qGetRegionalManager.city#, #qGetRegionalManager.state# #qGetRegionalManager.zip#</td>
                    <td>#qGetAreaRep.address# #qGetAreaRep.city#, #qGetAreaRep.state# #qGetAreaRep.zip#</td>
                </tr>
                <tr>
                	<td><b>Regional Manager Email Address</b></td>
                    <td><b>Area Rep Email Address</b></td>
                </tr>
                <tr>
                	<td>#qGetRegionalManager.email#</td>
                    <td>#qGetAreaRep.email#</td>
                </tr>
            </table>
        </p>
        
        <p>
        	PS: PAYMENT IS PENDING, once you received the payment please check as received on EXITS.
        </p>
    </cfsavecontent>
    
    <cfinvoke component="extensions.components.email" method="sendEmail">
        <cfinvokeargument name="email_from" value="<#APPLICATION.MPD.email#> (#SESSION.COMPANY.shortName# Trip Support)">
        <cfinvokeargument name="email_to" value="#APPLICATION.MPD.email#"> 
        <cfinvokeargument name="email_bcc" value="#APPLICATION.EMAIL.trips#">
        <cfinvokeargument name="email_subject" value="Student Trip Reservation #qGetTourDetails.tour_name# - #qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# (###qGetStudentInfo.studentID#)">
        <cfinvokeargument name="email_message" value="#mpdEmailMessage#">
    </cfinvoke>	

</cfoutput>