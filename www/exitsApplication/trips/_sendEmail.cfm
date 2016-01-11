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

    <cfquery name="qGetAreaRep" datasource="#APPLICATION.DSN.Source#">
        SELECT 
        	u.userID,
            u.firstName,
            u.lastName,
            u.email 
        FROM 
        	smg_users u
        where u.userid  = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.arearepid)#">
	</cfquery>
</cfsilent>

<cfoutput>	
	
    <!--- Trip Permission --->
    <cfdocument format="PDF" filename="#APPLICATION.PATH.TEMP#permissionForm_#VAL(qGetStudentInfo.studentID)#.pdf" overwrite="yes" margintop="0.2" marginbottom="0.2" localUrl="true">
		
        <cfinclude template="_tripPermission.cfm">
        
	</cfdocument>


    <!--- Email to Student --->    
    <cfsavecontent variable="stuEmailMessage">
        <p>		
            <h3>
                A spot has been reserved for you <cfif VAL(qGetSiblingsRegistered.recordCount)> and #ValueList(qGetSiblingsRegistered.name)# </cfif> on the <strong>#qGetTourDetails.tour_name#</strong> tour.
            </h3>
             <!----  
            <font color="red">* * Your spot will not be confirmed until permission form has been received by MPD Tours America. Please work on getting this completed as soon as possible * *</font> 
			---->
            
          <font color="red">* *  It is your responsibility as the student to make sure that this permission form is filled out in its entirety. Once the form is complete, you MUST forward a copy of the completed form to BOTH MPD Tours and your Regional Manager. * *</font> 
        </p>
    
        <p>
        	Attached is a Student Packet with hotel, airport arrival instructions, emergency numbers, etc.  
            Please keep this handy for your trip and leave a copy with your host family while you are on the trip.
        </p>
        <p>
        
        </p>
    	<p>
        	Please return the permission form by:<br />
            <ul>
                <li>email: #APPLICATION.MPD.email#</li>
                <li>fax:   +1 718 439 8565</li>
                <li>mail:  9101 Shore Road, ##203 - Brooklyn, NY 11209</li>
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
    
    <cfscript>
		// Make sure we have a valid email address
		if ( IsValid("email", qGetRegistrationDetails.email) ) {
			vSetEmailTo = qGetRegistrationDetails.email;
		} else {
			vSetEmailTo = APPLICATION.EMAIL.trips;
		}
	</cfscript>
    
    <cfinvoke component="extensions.components.email" method="sendEmail">
        <cfinvokeargument name="email_from" value="<#APPLICATION.MPD.email#> (#SESSION.COMPANY.shortName# Trip Support)">
    	<cfinvokeargument name="email_to" value="#vSetEmailTo#">
        <cfinvokeargument name="email_cc" value="josh@iseusa.com">
        <cfinvokeargument name="email_bcc" value="#APPLICATION.EMAIL.trips#">
        <cfinvokeargument name="email_subject" value="Your #qGetTourDetails.tour_name# Trip Details">
        <cfinvokeargument name="email_message" value="#stuEmailMessage#">
        <cfinvokeargument name="email_file" value="#APPLICATION.PATH.TEMP#permissionForm_#VAL(qGetStudentInfo.studentID)#.pdf">
        <cfinvokeargument name="email_file2" value="#APPLICATION.PATH.tour##qGetTourDetails.packetfile#">
    </cfinvoke>	
    <!--- End of Email to Student --->
    
    
    <!--- Email to Manager --->
    <cfif IsValid("email", qGetRegionalManager.email)>
    
        <cfsavecontent variable="repEmailMessage">
            #qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# (###qGetStudentInfo.studentID#) has registered to go on the #qGetTourDetails.tour_name# tour.<br /><br />
            
            Dates: #DateFormat(qGetTourDetails.tour_start, 'mmm d, yyyy')# - #DateFormat(qGetTourDetails.tour_end, 'mmm d, yyyy')#
            <br />
            Please be advised that this student has been sent a permission form which will need to be signed by their host parents, the representative of their high school,  their Area Representative, and Regional Manager. Upon receipt and completion of this form, please fax the form back to MPD Tours at 1-718-439-8565.
            
            If you feel that #qGetStudentInfo.firstname# should NOT be going on this trip, please notify us by using this 
            <a href="#SESSION.COMPANY.exitsURL#/nsmg/index.cfm?curdoc=tours/hold&studentID=#qGetStudentInfo.studentid#&tripID=#qGetTourDetails.tour_id#">form</a> 
            (you will need to be logged in to follow the link)
        </cfsavecontent>
        
        <cfinvoke component="extensions.components.email" method="sendEmail">
            <cfinvokeargument name="email_from" value="<#APPLICATION.MPD.email#> (#SESSION.COMPANY.shortName# Trip Support)">
            <cfinvokeargument name="email_to" value="#qGetRegionalManager.email#,#qGetAreaRep.email#">
            <cfinvokeargument name="email_bcc" value="#APPLICATION.EMAIL.trips#">
            <cfinvokeargument name="email_subject" value="Student Trip Registration #qGetTourDetails.tour_name# - #qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# (###qGetStudentInfo.studentID#)">
            <cfinvokeargument name="email_message" value="#repEmailMessage#">
        </cfinvoke>	
	</cfif>
    <!--- End of Email to Manager --->


    <!--- Email to MPD --->
    <cfsavecontent variable="mpdEmailMessage">
        <p>FYI,</p>
        
        <p>#qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# (###qGetStudentInfo.studentID#) has registered to go on the #qGetTourDetails.tour_name# tour.</p>
    </cfsavecontent>
    
    <cfinvoke component="extensions.components.email" method="sendEmail">
        <cfinvokeargument name="email_from" value="<#APPLICATION.MPD.email#> (#SESSION.COMPANY.shortName# Trip Support)">
        <cfinvokeargument name="email_to" value="#APPLICATION.MPD.email#"> 
        <cfinvokeargument name="email_bcc" value="#APPLICATION.EMAIL.trips#">
        <cfinvokeargument name="email_subject" value="Student Trip Registration #qGetTourDetails.tour_name# - #qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# (###qGetStudentInfo.studentID#)">
        <cfinvokeargument name="email_message" value="#mpdEmailMessage#">
    </cfinvoke>	
    <!--- End of Email to MPD --->

</cfoutput>