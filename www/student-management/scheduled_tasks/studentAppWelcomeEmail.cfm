<!--- ------------------------------------------------------------------------- ----
	
	File:		studentAppWelcomeEmail.cfm
	Author:		Marcus Melo
	Date:		July 27, 2012
	Desc:		Resends the welcome email to the student

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

    <cfquery name="qGetStudentInfo" datasource="mysql">
        SELECT 
        	*,
            sc.companyName,
            sc.companyShort,
            sc.support_email,
            sc.url_ref            
        FROM (
        
                SELECT 
                    s.studentID,
                    s.uniqueid, 
                    IF(s.companyID = 0, 1, s.companyID) AS companyID, <!--- ISE students have 0 as their company so we need to set to 1 --->
                    s.intrep, 
                    s.branchID,
                    s.randid, 	
                    s.firstname, 
                    s.familylastname,
                    s.email,
                    s.password,
                    intlRep.businessname AS intlRepBusinessName, 
                    intlRep.phone AS intlRepPhone, 
                    intlRep.email AS intlRepEmail, 
                    intlRep.studentContactEmail AS intlRepStudentContactEmail, 
                    branch.businessname AS branchBusinessName, 
                    branch.phone AS branchPhone, 
                    branch.email AS branchEmail, 
                    branch.studentContactEmail AS branchstudentContactEmail 
                FROM 
                    smg_students s
                INNER JOIN
                    smg_users intlRep ON intlRep.userID = s.intRep
                LEFT OUTER JOIN
                    smg_users branch ON branch.userID = s.branchID
                WHERE 
                    s.randid != <cfqueryparam cfsqltype="cf_sql_integer" value="0">	
                AND
                    s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                AND
                    s.app_current_status = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
			) AS t
		    INNER JOIN
            	smg_companies sc ON sc.companyID = t.companyID  
    </cfquery>
    
</cfsilent>

<cfoutput>

	<!--- Welcome Email --->
    <cfloop query="qGetStudentInfo">
    	
        <cfif isValid("email", qGetStudentInfo.email)>
        
			<cfscript>
                CLIENT.companyID = qGetStudentInfo.companyID;
            
                vEmailSubject = '#qGetStudentInfo.companyshort# Student Exchange Application - Account Activation Required';
                
                if ( VAL(qGetStudentInfo.branchID) ) {
                    // BRANCH 
                    vEmail = qGetStudentInfo.branchEmail;
                    vEmailAddress = qGetStudentInfo.branchstudentContactEmail;
                    vBusinessName = qGetStudentInfo.branchBusinessname;
                    vPhone = qGetStudentInfo.branchPhone;
                } else {
                    // MAIN OFFICE 
                    vEmailAddress = qGetStudentInfo.intlRepEmail;
                    vBusinessName = qGetStudentInfo.IntlRepBusinessname;
                    vPhone = qGetStudentInfo.IntlRepPhone;
                    vEmail = qGetStudentInfo.IntlRepEmail;
                }
            </cfscript>
            
            <!----Email To be Send. nsmg cfc emal cfc---->
            <cfsavecontent variable="vEmailMessage">
                #qGetStudentInfo.firstname# #qGetStudentInfo.familyLastName#-
                <br /> <br />
                An account has been created for you on the #qGetStudentInfo.companyName# EXITS system.  
                Using EXITS you will be able to apply for your exchange program and view the status of your application as it is processed. 
                <br /> <br />
                You can start your application at any time and do not need to complete it all at once.
                You can save your work at any time and return to the application when convenient.  
                The first time you access EXITS you will create a username and password that will allow you to work 
                on your application at any time. 
                <br /> <br />
                Please provide the information requested by the application and press the submit button when it is complete.
                Once submitted, the application can no longer be edited.  
                The completed application will be reviewed by your international representative and if accepted, sent on to there partner organization.
                The status of your application can be viewed by logging into the Exits Login Portal. 
                After your placement has been made, you will also be able to access your host family profile.
                <br /> <br />
                You are taking the first step in what will become one of the greatest experiences in your life!
                <br /> <br />
                Click the link below to start your application process.  
                <br /> <br />
                <a href="http://#qGetStudentInfo.url_ref#/nsmg/student_app/index.cfm?s=#qGetStudentInfo.uniqueid#">http://#qGetStudentInfo.url_ref#/nsmg/student_app/index.cfm?s=#qGetStudentInfo.uniqueid#</a>
                <br /> <br />
                You will need the following information to verify your account: <br />
                *email address <br />
                *this ID: #qGetStudentInfo.randid#
                <br /> <br />
                If you have any questions about the application or the information you need to submit, please contact:
                <br /> <br />
    
                #vBusinessName# <br />
                #vPhone# <br />
                #vEmail# <br /> <br />
                
                For technical issues with EXITS, submit questions to the support staff via the EXITS system.
            </cfsavecontent>
            
            <!--- send email --->
            <cfinvoke component="nsmg.cfc.email" method="send_mail">
                <cfinvokeargument name="email_from" value="#qGetStudentInfo.support_email# ( #qGetStudentInfo.companyName# )">
                <cfinvokeargument name="email_to" value="#qGetStudentInfo.email#">
                <cfinvokeargument name="email_subject" value="#vEmailSubject#">
                <cfinvokeargument name="email_message" value="#vEmailMessage#">
            </cfinvoke>
            <!----End of Email---->

		</cfif>

	</cfloop>
	
    <p>#qGetStudentInfo.recordCount# emails sent</p>
    
</cfoutput>