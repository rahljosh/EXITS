<!--- ------------------------------------------------------------------------- ----
	
	File:		traineeSEVISActivation.cfm
	Author:		Marcus Melo
	Date:		June 13, 2011
	Desc:		Scheduled Task - Sends out an email every week to Intl. Representative
				
----- ------------------------------------------------------------------------- --->
<!--- Remove trainee program 
<!--- Kill Extra Output --->
<cfsilent>

	<cfscript>	
		// Store Email Body in a variable
		savecontent variable="vEvaluationEmailBody" {
			WriteOutput(
			"<p>Dear {traineeName},</p>
			
			<p>Welcome to the United States!</p>
			
			<b>As a J-1 program participant, you must validate your program by Checking-in with ISE within 10 (ten) business days from arrival in the United States via ISE website</b> (please follow the flashing Check-in section): 
			<a href='http://www.isetraining.org'>www.isetraining.org</a> <br /> <br />
			
			This is an important step to ensure that your current U.S. address is accurately reflected in the Student Exchange Visitor Information System (SEVIS). To be in a good standing, ISE recommends that you check-in the next 
			day after arrival. Once you Check-in, the SEVIS system will show that your visa is current and that you are lawfully present in the United States and authorized to pursue program activities. <br />
			<font color='red'>Note: Failure to Check-in on time will lead to a program termination.</font> <br /> <br />
			
			If you should have any questions or you need assistance during your stay, please feel free to always contact us by emailing Ryan Schreiber at <a href=""mailto:ryan@iseusa.com"">ryan@iseusa.com</a>
			or by calling our toll-free number 1-877-779-0717 (dial 0 for the operator). <br /> <br />
			
			Best regards, <br /> <br />
			
			Ryan Schreiber <br />
			Program Manager <br />
			International Student Exchange <br />
			119 Cooper St, Babylon, NY, 11702 <br />
			Phone:(631) 893-4540 Ext.131 Fax:(631) 893-4550  <br />
			Toll Free: 1-800-766-4656 <br />
			Email: <a href=""mailto:ryan@iseusa.com"">ryan@iseusa.com</a> <br /> <br />");
		}	
	</cfscript>

	<!--- Get Pending Activation Candidates --->
    <cfquery name="qGetCandidates" datasource="#APPLICATION.DSN.Source#">
        SELECT DISTINCT
            ec.candidateID,
            ec.firstName,
            ec.lastName,
            ec.email,
            ec.ds2019_startDate,
            DATE_ADD(ec.ds2019_startDate, INTERVAL 1 WEEK) AS activationDeadLine,
            ec.ds2019_dateActivated,
            u.email AS intlRepEmail,
            p.programName,
            hc.email AS hostEmail
        FROM 
			extra_candidates ec
        INNER JOIN
        	smg_users u ON u.userID = ec.intRep
        INNER JOIN	
        	extra_hostcompany hc ON hc.hostCompanyID = ec.hostCompanyID
		INNER JOIN
        	smg_programs p ON p.programID = ec.programID
		WHERE
        	ec.status = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
		AND
        	ec.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="7">
        AND
            CURDATE() > DATE_ADD(ec.ds2019_startDate, INTERVAL 1 DAY) 
        <!--- 45 Days before it was implemented - There is a 30 day window to activate records in SEVIS --->
        AND
        	ec.ds2019_startDate >= <cfqueryparam cfsqltype="cf_sql_date" value="2011-06-01">
        AND	
        	ec.ds2019_dateActivated IS NULL
		ORDER BY
        	ec.ds2019_startDate 
    </cfquery>
	
	<cfscript>
		// Email Midterm - Loop Through Query
		For ( i=1;i LTE qGetCandidates.Recordcount; i=i+1 ) {
			
			// set email variables
			vEmailFrom = 'ryan@iseusa.com (Ryan Schreiber - Trainee Program)';
			vEmailTo = '';
	   	    vEmailCC = '';
			vEmailBCC = '';
			
			// check if we have a valid email for the candidate
			if ( IsValid("email", qGetCandidates.email[i]) ) {
				vEmailTo = qGetCandidates.email[i];	
			}

			// check if we have a valid email for the intl rep.
			if ( IsValid("email", qGetCandidates.intlRepEmail[i]) ) {
				vEmailCC = vEmailCC & qGetCandidates.intlRepEmail[i] & ';';	
			}

			// check if we have a valid email for the host family
			if ( IsValid("email", qGetCandidates.hostEmail[i]) ) {
				vEmailCC = vEmailCC & qGetCandidates.hostEmail[i];	
			}
			
			// Debug Settings
			// vEmailTo = 'james@iseusa.com';
			// vEmailCC = '';

			// At least one of the emails (candidate/host company) is valid
			if ( LEN(vEmailTo) ) {

				vCandidateName = qGetCandidates.firstName[i] & ' ' & qGetCandidates.lastName[i];	
	
				// Change variable on vEvaluationEmailBody to display midterm
				vEditedEvaluationEmailBody = ReplaceNoCase(vEvaluationEmailBody, "{traineeName}", vCandidateName);

				// Email
				APPLICATION.CFC.EMAIL.sendEmail(
					emailFrom=vEmailFrom,
					emailTo=vEmailTo,
					emailCC=vEmailCC,
					emailBCC=vEmailBCC,
					emailReplyTo=vEmailFrom,
					emailSubject=vCandidateName & " - Check-in / SEVIS Record Validation Required",
					emailMessage=vEditedEvaluationEmailBody,
					emailPriority=1,
					footerType="emailNoInfo",
					companyID=7
				);
			
			}

		}
	</cfscript>	

</cfsilent>

<cfoutput>

<!--- Display List of Students --->
<table width="100%" cellpadding="3" cellspacing="0" style="margin:10px; border:1px solid ##999;">
	<tr>
    	<th colspan="8" style="border-bottom:1px solid ##999;">DS-2019 Activation</th>
	</tr>        
	<tr>
    	<td style="border-bottom:1px solid ##999;">Candidate</td>
        <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">Email</td>
        <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">Program</td>
        <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">Start Date</td>
	</tr>
    <cfloop query="qGetCandidates">
        <tr>
            <td style="border-bottom:1px solid ##999;">#qGetCandidates.firstName# #qGetCandidates.lastName# (###qGetCandidates.candidateID#)</td>
            <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">#qGetCandidates.email#</td>
            <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">#qGetCandidates.programName#</td>
            <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">#DateFormat(qGetCandidates.ds2019_startDate, 'mm/dd/yyyy')#</td>
        </tr>
    </cfloop>
</table>

</cfoutput>
--->