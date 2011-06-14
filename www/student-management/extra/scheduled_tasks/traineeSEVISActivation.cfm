<!--- ------------------------------------------------------------------------- ----
	
	File:		traineeSEVISActivation.cfm
	Author:		Marcus Melo
	Date:		June 13, 2011
	Desc:		Scheduled Task - Sends out an email every week to Intl. Representative
				
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<cfscript>	
		// Store Email Body in a variable
		savecontent variable="evaluationEmailBody" {
			WriteOutput(
			"<p>Dear {traineeName},</p>
			
			<p>Welcome to the United States!</p>
			
			As you know, your profile should be activated in SEVIS database so that you can officially start your Training Program and apply for your Social Security Card.  
			In order to do that ISE needs your current US Address. Please email it to Sergei Chernyshov at <a href=""mailto:sergei@iseusa.com"">sergei@iseusa.com</a> <br /> <br />
			
			Failure to do so within 30 days of the official program start date (as stated on your DS2019 form) could result in your SEVIS profile to become inactive and your termination from the program. 
			So, please send it as soon as possible. <br /> <br />
			
			Should you have any questions, please feel free to contact me. <br /> <br />
			
			Best regards, <br /> <br />
			
			Sergei Chernyshov <br />
			Program Manager <br />
			International Student Exchange <br />
			119 Cooper St, Babylon, NY, 11702 <br />
			Phone:(631) 893-4540 Ext.131 Fax:(631) 893-4550  <br />
			Toll Free: 1-800-766-4656 <br />
			Email: <a href=""mailto:sergei@iseusa.com"">sergei@iseusa.com</a> <br /> <br />");
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
        	extra_hostCompany hc ON hc.hostCompanyID = ec.hostCompanyID
		INNER JOIN
        	smg_programs p ON p.programID = ec.programID
		WHERE
        	ec.status = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
		AND
        	ec.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="7">
        AND
            CURDATE() > DATE_ADD(ec.ds2019_startDate, INTERVAL 1 WEEK) 
        <!--- 45 Days before it was implemented - There is a 30 day window to activate records in SEVIS --->
        AND
        	ec.ds2019_startDate > <cfqueryparam cfsqltype="cf_sql_date" value="2011-05-01">
        AND	
        	ec.ds2019_dateActivated IS NULL
		ORDER BY
        	ec.ds2019_startDate 
    </cfquery>
	
	<cfscript>
		// Email Midterm - Loop Through Query
		For ( i=1;i LTE qGetCandidates.Recordcount; i=i+1 ) {
			
			// set email variables
			vEmailFrom = 'sergei@iseusa.com';
			vEmailTo = '';
	   	    vEmailCC = '';
			// vEmailBCC = '';
			vEmailBCC = 'sergei@iseusa.com';
			
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
			
			// At least one of the emails (candidate/host company) is valid
			if ( LEN(vEmailTo) ) {

				// Change variable on evaluationEmailBody to display midterm
				evaluationEmailBody = ReplaceNoCase(evaluationEmailBody, "{traineeName}", qGetCandidates.firstName[i] & ' ' & qGetCandidates.lastName[i]);

				// Email
				APPLICATION.CFC.EMAIL.sendEmail(
					emailFrom=vEmailFrom,
					emailTo=vEmailTo,
					emailCC=vEmailCC,
					emailBCC=vEmailBCC,
					emailReplyTo=vEmailFrom,
					emailSubject=qGetCandidates.firstName[i] & ' ' & qGetCandidates.lastName[i] & " - SEVIS Activation Required",
					emailMessage=evaluationEmailBody,
					emailPriority=1,
					footerType="emailRegular",
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
            <td style="border-bottom:1px solid ##999;">###qGetCandidates.candidateID# #qGetCandidates.firstName# #qGetCandidates.lastName#</td>
            <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">#qGetCandidates.email#</td>
            <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">#qGetCandidates.programName#</td>
            <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">#DateFormat(qGetCandidates.ds2019_startDate, 'mm/dd/yyyy')#</td>
        </tr>
    </cfloop>
</table>

</cfoutput>