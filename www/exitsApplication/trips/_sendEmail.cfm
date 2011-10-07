<!--- ------------------------------------------------------------------------- ----
	
	File:		_sendEmail.cfm
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

</cfsilent>

<cfoutput>	
	
    <!--- Trip Permission --->
    <cfdocument format="PDF" filename="#APPLICATION.PATH.TEMP#permissionForm_#VAL(qGetStudentInfo.studentID)#.pdf" overwrite="yes" margintop="0.2" marginbottom="0.2">
		
        <cfinclude template="_tripPermission.cfm">
        
	</cfdocument>

    <!--- Payment Form --->
    <!---
	<cfdocument format="PDF" filename="#APPLICATION.PATH.TEMP#paymentForm_#VAL(qGetStudentInfo.studentID)#.pdf" overwrite="yes" margintop="0.2" marginbottom="0.2">
        
        <cfinclude template="paymentFORM.cfm">
        
    </cfdocument>
	--->    

    <!--- Email to Student --->    
    <cfsavecontent variable="stuEmailMessage">
        <p>		
            <h3>
                A spot has been reserved for you <cfif VAL(qGetSiblingsRegistered.recordCount)> and #ValueList(qGetSiblingsRegistered.name)# </cfif> on the <strong>#qGetTourDetails.tour_name#</strong> tour.
            </h3>
                
            <font color="red">* * Your spot will not be confirmed until permission form has been received by MPD Tours America.Please work on getting this completed as soon as possible * *</font> 
        </p>
    
    	<!--- 
		<p><strong>IMPORTANT:</strong> On the MPD Payment form, enter <strong>#qGetStudentInfo.studentid#</strong> in the STUDENT ID field.</p>
    	--->
        
        <p>
        	Attached is a Student Packet with hotel, airport arrival instructions, emergency numbers, etc.  
            Please keep this handy for your trip and leave a copy with your host family while you are on the trip.
        </p>
        
    	<p>Please return the MPD Payment Form and Permission Form by:<br />
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
        
        <p>If you have any questions that are not answerd please don't hesitate to contact us at info@mpdtoursamerica.com. </p>
        
        <p>See you soon!</p>
        
        <p>
        	MPD Tour America, Inc.<br />
            9101 Shore Road ##203- Brooklyn, NY 11209<Br />
            Email: Info@Mpdtoursamerica.com<br />
            TOLL FREE: 1-800-983-7780<br />
            Fax: 1-(718)-439-8565
        </p>
    </cfsavecontent>   
    
    <cfinvoke component="extensions.components.email" method="sendEmail">
        <cfinvokeargument name="email_from" value="<#APPLICATION.EMAIL.trips#> (#SESSION.COMPANY.shortName# Trip Support)">
    	<cfinvokeargument name="email_to" value="#qGetRegistrationDetails.email#">
        <cfinvokeargument name="email_bcc" value="#APPLICATION.EMAIL.trips#">
        <cfinvokeargument name="email_subject" value="Your #qGetTourDetails.tour_name# Trip Details">
        <cfinvokeargument name="email_message" value="#stuEmailMessage#">
        <cfinvokeargument name="email_file" value="#APPLICATION.PATH.TEMP#permissionForm_#VAL(qGetStudentInfo.studentID)#.pdf">
        <cfinvokeargument name="email_file2" value="#APPLICATION.PATH.tour##qGetTourDetails.packetfile#">
        <!--- <cfinvokeargument name="email_file3" value="#APPLICATION.PATH.TEMP#paymentForm_#VAL(qGetStudentInfo.studentID)#.pdf"> --->
    </cfinvoke>	
    
    <!--- Email to Manager --->
    <cfsavecontent variable="repEmailMessage">
        #qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# (###qGetStudentInfo.studentID#) has registered to go on the #qGetTourDetails.tour_name# tour.<br /><br />
        
        Dates: #DateFormat(qGetTourDetails.tour_start, 'mmm d, yyyy')# - #DateFormat(qGetTourDetails.tour_end, 'mmm d, yyyy')#
        
        If you feel that #qGetStudentInfo.firstname# should NOT be going on this trip, please notify us by using this 
        <a href="#SESSION.COMPANY.exitsURL#/nsmg/index.cfm?curdoc=tours/hold&studentID=#qGetStudentInfo.studentid#&tour=#qGetTourDetails.tour_id#">form</a> 
        (you will need to be logged into follow the link)
    </cfsavecontent>
    
    <cfinvoke component="extensions.components.email" method="sendEmail">
        <cfinvokeargument name="email_from" value="<#APPLICATION.EMAIL.trips#> (#SESSION.COMPANY.shortName# Trip Support)">
        <cfinvokeargument name="email_to" value="#qGetRegionalManager.email#">
        <cfinvokeargument name="email_bcc" value="#APPLICATION.EMAIL.trips#">
        <cfinvokeargument name="email_subject" value="Student Trip Registration #qGetTourDetails.tour_name# - #qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# (###qGetStudentInfo.studentID#)">
        <cfinvokeargument name="email_message" value="#repEmailMessage#">
    </cfinvoke>	


    <!--- Email to MPD --->
    <cfsavecontent variable="mpdEmailMessage">
        <p>FYI,</p>
        
        <p>#qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# (###qGetStudentInfo.studentID#) has registered to go on the #qGetTourDetails.tour_name# tour.</p>
    </cfsavecontent>
    
    <cfinvoke component="extensions.components.email" method="sendEmail">
        <cfinvokeargument name="email_from" value="<#APPLICATION.EMAIL.trips#> (#SESSION.COMPANY.shortName# Trip Support)">
        <cfinvokeargument name="email_to" value="info@mpdtoursamerica.com"> 
        <cfinvokeargument name="email_bcc" value="#APPLICATION.EMAIL.trips#">
        <cfinvokeargument name="email_subject" value="Student Trip Registration #qGetTourDetails.tour_name# - #qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# (###qGetStudentInfo.studentID#)">
        <cfinvokeargument name="email_message" value="#mpdEmailMessage#">
    </cfinvoke>	

</cfoutput>