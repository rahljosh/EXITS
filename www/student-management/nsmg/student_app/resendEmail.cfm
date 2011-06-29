<!--- ------------------------------------------------------------------------- ----
	
	File:		resendEmail.cfc
	Author:		Marcus Melo
	Date:		June 29, 2011
	Desc:		Resends the welcome email or login information to the student

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Param URL Variables --->
	<cfparam name="URL.unqID" default="">
    <cfparam name="URL.emailAction" default="login"> <!--- login / welcomeEmail --->

	<cfif NOT LEN(URL.unqID)>
		<cfinclude template="../error_message.cfm">
		<cfabort>
	</cfif>

    <cfquery name="qGetStudentInfo" datasource="mysql">
        SELECT 
            studentID,
            uniqueid, 
            intrep, 
            branchid,
			randid, 	
        	firstname, 
            familylastname,
            email,
            password           
        FROM 
        	smg_students
        WHERE 
        	uniqueid = <cfqueryparam cfsqltype="cf_sql_char" value="#url.unqid#">
    </cfquery>
    
    <!--- send a copy to MAIN OFFICE OR BRANCH - IT DEPENDS WHO CREATED THE STUDENT --->
    <cfquery name="qGetIntlRepInfo" datasource="MySQL">
        SELECT
        	userID,
            businessname, 
            phone, 
            email, 
            studentcontactemail
        FROM 
        	smg_users 
        WHERE 
			<cfif qGetStudentInfo.branchid EQ 0>
            	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.intrep#">
			<cfelse>
            	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.branchid#">
			</cfif>
    </cfquery>
    
    <cfscript>
		vEmailSubject = '';
		vEmailMessage = '';		
		
		if ( VAL(qGetStudentInfo.branchid) ) {
			// BRANCH 
			vIntlEmailAddress = '#qGetIntlRepInfo.studentcontactemail#';
		} else {
			// MAIN OFFICE 
			vIntlEmailAddress = '#qGetIntlRepInfo.email#';
		}
	</cfscript>

</cfsilent>

<cfoutput>

	<cfswitch expression="#URL.emailAction#">
    
    	<!--- Login Email --->
    	<cfcase value="login">

            <cfsavecontent variable="vEmailMessage">
                #qGetStudentInfo.firstname#-
                <br><br>
                **This email has been resent to you. This may indicate that your login info has changed, please note any changes to your login info below.**
                <br /><br />
                
                See your login information below: 
                <br /><br />
                username: #qGetStudentInfo.email# <br>
                password: #qGetStudentInfo.password# 
                <br /><br />
                
                Please visit <a href="#client.exits_url#">#client.exits_url#</a> to log in into your online application.
                <br><br>
                If you have any questions about the application or the information you need to submit, please contact your international representative:
                <br><br>
                #qGetIntlRepInfo.businessname#<br>
                #qGetIntlRepInfo.phone#<br>
                #qGetIntlRepInfo.email#<br><br>
                
                For technical issues with EXITS, submit questions to the support staff via the EXITS system.
            </cfsavecontent>

			<cfscript>
				vEmailSubject = '#CLIENT.companyshort# Exchange Application - Login Information';
				vSuccessfullMessage = 'EXITS - You have successfully resent the login information for #qGetStudentInfo.firstname# #qGetStudentInfo.familylastname#. Thank You.';				
			</cfscript>
            
		</cfcase>


    	<!--- Welcome Email --->
    	<cfcase value="welcomeEmail">

			<!----Email To be Send. nsmg cfc emal cfc---->
            <cfsavecontent variable="vEmailMessage">
                #qGetStudentInfo.firstname#-
                <br><br>
                An account has been created for you on the #CLIENT.companyname# EXITS system.  
                Using EXITS you will be able to apply for your exchange program and view the status of your application as it is processed. 
                <br><br>
                You can start your application at any time and do not need to complete it all at once.
                You can save your work at any time and return to the application when convenient.  
                The first time you access EXITS you will create a username and password that will allow you to work 
                on your application at any time. 
                <br><br>
                Please provide the information requested by the application and press the submit button when it is complete.
                Once submitted, the application can no longer be edited.  
                The completed application will be reviewed by your international representative and if accepted, sent on to there partner organization.
                The status of your application can be viewed by logging into the Exits Login Portal. 
                After your placement has been made, you will also be able to access your host family profile.
                <br><br>
                You are taking the first step in what will become one of the greatest experiences in your life!
                <br><br>
                Click the link below to start your application process.  
                <br><br>
                <a href="#CLIENT.exits_url#/nsmg/student_app/index.cfm?s=#qGetStudentInfo.uniqueid#">#CLIENT.exits_url#/nsmg/student_app/index.cfm?s=#qGetStudentInfo.uniqueid#</a>
                <br><br>
                You will need the following information to verify your account:<br>
                *email address<br>
                *this ID: #qGetStudentInfo.randid#
                <br><br>
                If you have any questions about the application or the information you need to submit, please contact:
                <br><br>
                #qGetIntlRepInfo.businessname#<br>
                #qGetIntlRepInfo.phone#<br>
                #qGetIntlRepInfo.email#<br><br>
                
                For technical issues with EXITS, submit questions to the support staff via the EXITS system.
                
                <!----
                <p>To login please visit: <cfoutput><a href="#CLIENT.exits_url#">#CLIENT.exits_url#</a></cfoutput></p>
                ---->
            </cfsavecontent>

			<cfscript>
				vEmailSubject = 'EXITS - Online Student Application - Account Activation Required';
				vSuccessfullMessage = 'EXITS - You have successfully resent the welcome email for #qGetStudentInfo.firstname# #qGetStudentInfo.familylastname#. Thank You.';					
			</cfscript>

		</cfcase>

	</cfswitch>
	
	<!--- Check Valid Student Email --->
    <cfif IsValid("email", qGetStudentInfo.email)>
    	
        <!--- send email --->
        <cfinvoke component="nsmg.cfc.email" method="send_mail">
            <cfinvokeargument name="email_to" value="#qGetStudentInfo.email#">
            <cfinvokeargument name="email_subject" value="#vEmailSubject#">
            <cfinvokeargument name="email_message" value="#vEmailMessage#">
            <cfinvokeargument name="email_from" value="#CLIENT.support_email#">
        </cfinvoke>
    
		<script language="JavaScript">
            <!-- 
            alert("#vSuccessfullMessage#");
            window.close();
            -->
        </script>
    
    <cfelse>
    
		<script language="JavaScript">
            <!-- 
            alert("Student does not have a valid email address. Please add one on page 1 of the application.");
            window.close();
            -->
        </script>
        
	</cfif>
    <!----End of Email---->

</cfoutput>
