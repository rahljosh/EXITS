<!--- ------------------------------------------------------------------------- ----
	
	File:		dosCertificationEmailReminder.cfm
	Author:		Marcus Melo
	Date:		April 18, 2012
	Desc:		Runs every wednesday and sent out emails to users that need to
				re-do the DOS test

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
    <!--- Do not run task - New procedure in place --->
    <cfabort>
    
    <cfsetting requesttimeout="9999">
    
    <cfscript>
		// Create User Object
		u = createObject("component","nsmg.extensions.components.user");
		
		// Create Email Object
		e = createObject("component","nsmg.cfc.email");

		// ISE
	    qGetIseExpiredTraining = u.getExpiringTraining(companyID=1);
		
		// CASE
	    qGetCaseExpiredTraining = u.getExpiringTraining(companyID=10);
	</cfscript>

	<cfsavecontent variable="vIseEmailTemplate">
        <p>Dear {userInformation},</p>
        
        <p>It is that time again - your Department of State Annual Certification deadline is approaching!</p>
        
        <p>This is a reminder that you must complete the certification test by the deadline to remain in compliance with DOS regulations.</p>
        
        <p>By now, you have likely already received an email from no_reply@traincaster.com with your training due date (remember to check your spam and junk folders).</p>
        
        <p>If you have not already done so, please do not delay in completing this test by the given due date.</p>
        
        <p>If you have not received a message from traincaster, please contact me and I will provide you with your deadline and login information.</p>
        
        <p>
        	Thank you, <br />
	        Megan Perlleshi <br />
    	    International Student Exchange <br />
    	</p>
    </cfsavecontent>

	<cfsavecontent variable="vCaseEmailTemplate">
        <p>Dear {userInformation},</p>
        
        <p>It is that time again - your Department of State Annual Certification deadline is approaching!</p>
        
        <p>This is a reminder that you must complete the certification test by the deadline to remain in compliance with DOS regulations.</p>
        
        <p>By now, you have likely already received an email from no_reply@traincaster.com with your training due date (remember to check your spam and junk folders).</p>
        
        <p>If you have not already done so, please do not delay in completing this test by the given due date.</p>
        
        <p>If you have not received a message from traincaster, please contact me and I will provide you with your deadline and login information.</p>
        
        <p>
        	Thank you, <br />
	        Stacy Lynn <br />
    	    Cultural Academic Student Exchange <br />
    	</p>
    </cfsavecontent>
    
</cfsilent>

<cfoutput>
	
    <!--- ISE --->
	<cfscript>
        // Set CompanyID
		CLIENT.companyID = 1;
    </cfscript>
    
	<cfloop query="qGetIseExpiredTraining">
    	
        <cfscript>
			vIseEmailMessage = ReplaceNoCase(vIseEmailTemplate, "{userInformation}", qGetIseExpiredTraining.userInformation);
			
			// Get Regional Manager
			qGetRegionalManagerEmail = u.getRegionalManager(regionID=qGetIseExpiredTraining.regionID).email;
			
			if ( isValid("email", qGetIseExpiredTraining.email) AND isValid("email", qGetRegionalManagerEmail) ) {
				
				// Send Email				
				e.send_mail(
					email_from="<megan@iseusa.com> (Megan Perlleshi - ISE)",
					email_to=qGetIseExpiredTraining.email,
					email_cc=qGetRegionalManagerEmail,
					//email_bcc="support@iseusa.com",
					email_replyto="megan@iseusa.com",
					email_subject="Department of State Annual Certification deadline is approaching!",
					email_message=vIseEmailMessage	
				);

			}
		</cfscript>

    </cfloop>
	    
	<p>ISE - Total of #qGetIseExpiredTraining.recordCount# records</p>


    <!--- CASE --->
	<cfscript>
        // Set CompanyID
		CLIENT.companyID = 10;
    </cfscript>
    
	<cfloop query="qGetCaseExpiredTraining">

        <cfscript>
			vCaseEmailMessage = ReplaceNoCase(vCaseEmailTemplate, "{userInformation}", qGetCaseExpiredTraining.userInformation);
			
			if ( isValid("email", qGetCaseExpiredTraining.email) ) {
				
				// Send Email
				e.send_mail(
					email_from="<stacy@case-usa.org> (Stacy Lynn - CASE)",
					email_to=qGetCaseExpiredTraining.email,
					email_bcc="stacy@case-usa.org",
					email_replyto="stacy@case-usa.org",
					email_subject="Department of State Annual Certification deadline is approaching!",
					email_message=vCaseEmailMessage					
				);
			
			}
		</cfscript>
    
    </cfloop>

	<p>CASE - Total of #qGetCaseExpiredTraining.recordCount# records</p>

</cfoutput>