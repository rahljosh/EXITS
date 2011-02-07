<!--- ------------------------------------------------------------------------- ----
	
	File:		accountActivationEmail.cfm
	Author:		Marcus Melo
	Date:		February 7, 2011
	Desc:		Scheduled Task - Emails account activation instructions
				It should be run weekly

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customtags/gui/" prefix="gui" />	
	
    <cfscript>
		// Get List of Candidates in Issued Status
		qGetCandidates = APPLICATION.CFC.candidate.getApplicationListbyStatusID(applicationStatusID=1);
		
		// Loop Through Query
		For ( i=1;i LTE qGetCandidates.Recordcount; i=i+1 ) {
		
			// Pending Activation - Send out Activation Email
			APPLICATION.CFC.EMAIL.sendEmail(
				emailFrom=APPLICATION.EMAIL.contactUs,
				emailTo=qGetCandidates.email[i],
				emailTemplate='newAccount',
				candidateID=qGetCandidates.candidateID[i]
			);
			
		}
	</cfscript>

</cfsilent>

<cfoutput>
	
    <p>#qGetCandidates.recordCount# candidates in issued status. Activation information emailed.</p>

</cfoutput>
