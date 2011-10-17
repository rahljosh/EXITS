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
    <cfparam name="FORM.submitted" default="">
    <cfparam name="FORM.studentID" default="">
    <cfparam name="FORM.tripID" default="">
    <cfparam name="FORM.holdReason" default="">
	
    <cfscript>
		if ( VAL(URL.studentID) ) {
			FORM.studentID = URL.studentID;	
		}
		
		if ( VAL(URL.tripID) ) {
			FORM.tripID = URL.tripID;	
		}
	</cfscript>

    <cfquery name="qGetStudentInfo" datasource="#APPLICATION.DSN#">
        SELECT 
        	studentID,
        	firstName, 
            familylastname
        FROM 
        	smg_students
        WHERE
        	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.studentID#">
    </cfquery>

    <cfquery name="qGetTripDetails" datasource="#APPLICATION.DSN#">
        SELECT 
        	*
        FROM 
        	smg_tours
        WHERE 
        	tour_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.tripID#"> 
    </cfquery>

    <cfif VAL(FORM.submitted)>
		
        <cfscript>
			if ( NOT LEN(FORM.holdReason) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please explain why you don't think the student should be able to go");
            }
		</cfscript>

        <!--- // Check if there are no errors --->
        <cfif NOT SESSION.formErrors.length()>
    
            <cfquery datasource="#APPLICATION.DSN#">
                UPDATE 
                    student_tours
                SET
                    dateOnHold = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                    holdReason = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.holdReason#">
                WHERE 
                    studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.studentID)#">
                AND	
                    tripID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.tripID)#">
            </cfquery>
        
            <cfsavecontent variable="holdEmailMessage">
                <cfoutput>
                    <p>
                        #CLIENT.name# put #qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# (#qGetStudentInfo.studentID#), who registered to go on the 
                        #qGetTripDetails.tour_name# tour on hold for the following reason:
                    </p>
                    
                    <p>
                        #FORM.holdreason#
                    </p>
				</cfoutput>                    
            </cfsavecontent>
    
            <cfinvoke component="nsmg.cfc.email" method="send_mail">
                <cfinvokeargument name="email_from" value="<trips@iseusa.com> (Trip Support)">
                <cfinvokeargument name="email_to" value="tal@iseusa.com">
                <cfinvokeargument name="email_bcc" value="trips@iseusa.com">
                <cfinvokeargument name="email_subject" value="#qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# - #qGetTripDetails.tour_name# - Student on Hold">
                <cfinvokeargument name="email_message" value="#holdEmailMessage#">
            </cfinvoke>	
    
            <cfscript>
                SESSION.pageMessages.Add("#qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# successfully put on hold for the #qGetTripDetails.tour_name# trip");
                
                if ( ListFind("1,2,3,4", CLIENT.userType) ) {
                    Location("#CGI.SCRIPT_NAME#?curdoc=tours/profile&studentID=#FORM.studentID#&tripID=#FORM.tripID#", "no");
                } 	
            </cfscript>
       
       </cfif>
            
    </cfif>

</cfsilent>

<cfoutput>
   
	<!--- Table Header --->
    <gui:tableHeader
        imageName="plane.png"
        tableTitle="Trips - Hold Information"
    />

	<!--- Page Messages --->
    <gui:displayPageMessages 
        pageMessages="#SESSION.pageMessages.GetCollection()#"
        messageType="tableSection"
        width="100%"
        />
    
    <cfif VAL(FORM.submitted) AND NOT SESSION.formErrors.length()>

        <table border="0" cellpadding="4" cellspacing="0" class="section" width="100%" align="center">
            <tr>
                <td align="center">
                    <p>You've placed this student on hold. Our office has been notified and will get back to you shortly</p> 
                </td>
            </tr>   
        </table>

    <cfelse>

        <!--- Form Errors --->
        <gui:displayFormErrors 
            formErrors="#SESSION.formErrors.GetCollection()#"
            messageType="tableSection"
            width="100%"
            />   
    
        <form method="post" action="#CGI.SCRIPT_NAME#?curdoc=tours/hold">
            <input type="hidden" name="submitted" value="1" />
            <input type="hidden" name="studentID" value="#FORM.studentID#">
            <input type="hidden" name="tripID" value="#FORM.tripID#">
    
            <table border="0" cellpadding="4" cellspacing="0" class="section" width="100%" align="center">
                <tr>
                    <td align="center">
                        <h2>Put Student on Hold</h2>
                    </td>
                </tr>            
                <tr>
                    <td align="center">
                        <p>You are about to place a hold on the registration process for #qGetStudentInfo.firstname# #qGetStudentInfo.familylastname#</p>
                        
                        Please explain why you don't think they should be able to go. 
                    </td>
                </tr>   
                <tr>
                    <td align="center"><textarea name="holdReason" class="xxLargeTextArea">#FORM.holdReason#</textarea></td>
                </tr>    
                <tr>
                    <td align="center">The hold is not placed until this form is submitted.</td>
                </tr>
                <tr>
                    <td align="center"><input type="image" src="pics/submitBlue.png" /></td>
                </tr>
            </table>
        
        </form>
    
    </cfif>
    
    <!--- Table Footer --->
    <gui:tableFooter />

</cfoutput>
