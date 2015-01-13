<!--- ------------------------------------------------------------------------- ----
	
	File:		traineeEvaluations.cfm
	Author:		Marcus Melo
	Date:		February 17, 2011
	Desc:		Scheduled Task - Sends out an email every week to employer, 
				employee and office.
				
				evaluation/program	6 month			12 months		18 months
				
				midterm				n/a				beggining of	beginning of
													6th month		9th month
				
				summative			beggining of	beggining of	beginning of
									6th month		12th month		18th month
				
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<cfscript>
		// Store Program List
		lt6MonthProgram = '194,195';
		lt12MonthProgram = '196,197';
		lt18MonthProgram = '198,199';
		
		// Store Midterm Email Body in a variable
		savecontent variable="evaluationEmailBody" {
			WriteOutput(
			"<p>Dear Sir/Madam,</p>
			
			As you know the U.S. Department of State requires that the host companies submit 2 types of trainee evaluations to ISE (Sponsor) during the J-1 Training Program: <br /> <br />
			
			1.	Midterm evaluation – it should be submitted in the middle of the training program. <br /> <br />
			
			2.	Summative evaluation – it should be submitted during the last month of the training program. <br /> <br />
			
			Attached to this email you will find the evaluation form {evaluationType}. 
			The trainee’s supervisor should print the form, fill it in, date it and sign it together with the trainee. Then the form should be either: <br /> <br />
			
			1) scanned and emailed to <a href=""mailto:ryan@iseusa.com"">ryan@iseusa.com</a> (preferably) <br /> <br />
			
			OR <br /> <br />
			
			2) faxed to 631.893.4550 attention to Ryan Schreiber <br /> <br />   
			
			OR <br /> <br />
			
			3) sent via regular mail to: <br /> <br />
			
			Ryan Schreiber <br />
			119 Cooper Street <br />
			Babylon, NY, 11702 <br /> <br />
			
			<p>This is an automated email that will be sent every week until the evaluation form is received.</p>			
			
			<p>Should you have any questions, please feel free to contact me. <br />
			Thank you for your understanding.</p>	
			
			Best regards, <br /> <br />
			
			Ryan Schreiber <br />
			Program Manager <br />
			International Student Exchange <br />
			119 Cooper St, Babylon, NY, 11702 <br />
			Phone:(631) 893-4540 Ext.131 Fax:(631) 893-4550  <br />
			Toll Free: 1-800-766-4656 <br />
			Email: <a href=""mailto:ryan@iseusa.com"">ryan@iseusa.com</a> <br /> <br />");
		}	

		// Change variable on evaluationEmailBody to display midterm
		vMidTermEvaluation = ReplaceNoCase(evaluationEmailBody, "{evaluationType}", "midterm");

		// Change variable on evaluationEmailBody to display summative
		vSummativeEvaluation = ReplaceNoCase(evaluationEmailBody, "{evaluationType}", "summative");
	</cfscript>

	<!--- Get Midterm Evaluations --->
    <cfquery name="qGetMidterm" datasource="#APPLICATION.DSN.Source#">
		<!--- 6 Month Program - N/A --->	
		
		<!--- 12 Month Program - To be sent beginning of 6th month--->	
        SELECT DISTINCT
            ec.candidateID,
            ec.programID,
            ec.firstName,
            ec.lastName,
            ec.email,
            ec.ds2019_startDate,
            DATE_ADD(ec.ds2019_startDate, INTERVAL 5 MONTH) AS midtermDate,
            ec.ds2019_endDate,
            ec.doc_midterm_evaluation,
            ec.doc_summative_evaluation,
            p.programName,
            hc.hostCompanyID,
            hc.name AS hostBusinessName,
            hc.email AS hostEmail
        FROM 
			extra_candidates ec
        INNER JOIN	
        	extra_hostcompany hc ON hc.hostCompanyID = ec.hostCompanyID
		INNER JOIN
        	smg_programs p ON p.programID = ec.programID
		WHERE
        	ec.status = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
		AND
        	ec.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="7">
        AND	
        	ec.doc_midterm_evaluation IS NULL
        AND 
            ec.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#lt12MonthProgram#" list="yes"> )
        AND
            CURDATE() > DATE_ADD(ec.ds2019_startDate, INTERVAL 5 MONTH)           

		UNION
        
  		<!--- 18 Month Program - To be sent beginning of 9th month --->	            
        SELECT DISTINCT
            ec.candidateID,
            ec.programID,
            ec.firstName,
            ec.lastName,
            ec.email,
            ec.ds2019_startDate,
            DATE_ADD(ec.ds2019_startDate, INTERVAL 8 MONTH) AS midtermDate,
            ec.ds2019_endDate,
            ec.doc_midterm_evaluation,
            ec.doc_summative_evaluation,
            p.programName,
            hc.hostCompanyID,
            hc.name AS hostBusinessName,
            hc.email AS hostEmail
        FROM 
			extra_candidates ec
        INNER JOIN	
        	extra_hostcompany hc ON hc.hostCompanyID = ec.hostCompanyID
		INNER JOIN
        	smg_programs p ON p.programID = ec.programID
		WHERE
        	ec.status = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
		AND
        	ec.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="7">
        AND	
        	ec.doc_midterm_evaluation IS NULL
		AND
            ec.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#lt18MonthProgram#" list="yes"> )
        AND
            CURDATE() > DATE_ADD(ec.ds2019_startDate, INTERVAL 8 MONTH)             
           
		ORDER BY
        	programID,
            midtermDate,
            hostBusinessName,
            lastName 
    </cfquery>


	<!--- Get Summative Evaluations --->
    <cfquery name="qGetSummative" datasource="#APPLICATION.DSN.Source#">
		<!--- 6 Month Program - To be sent beginning of 6th month --->	
        SELECT DISTINCT
            ec.candidateID,
            ec.programID,
            ec.firstName,
            ec.lastName,
            ec.email,
            ec.ds2019_startDate,
            DATE_ADD(ec.ds2019_startDate, INTERVAL 5 MONTH) AS summativeDate,
            ec.ds2019_endDate,
            ec.doc_midterm_evaluation,
            ec.doc_summative_evaluation,
            p.programName,
            hc.hostCompanyID,
            hc.name AS hostBusinessName,
            hc.email AS hostEmail
        FROM 
			extra_candidates ec
        INNER JOIN	
        	extra_hostcompany hc ON hc.hostCompanyID = ec.hostCompanyID
		INNER JOIN
        	smg_programs p ON p.programID = ec.programID
        WHERE
        	ec.status = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
		AND
        	ec.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="7">
        AND	
        	ec.doc_summative_evaluation IS NULL
        AND 
            ec.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#lt6MonthProgram#" list="yes"> )
        AND
            CURDATE() > DATE_ADD(ec.ds2019_startDate, INTERVAL 5 MONTH)            
		
        UNION
        
		<!--- 12 Month Program - To be sent beginning of 12th month --->	
        SELECT DISTINCT
            ec.candidateID,
            ec.programID,
            ec.firstName,
            ec.lastName,
            ec.email,
            ec.ds2019_startDate,
            DATE_ADD(ec.ds2019_startDate, INTERVAL 11 MONTH) AS summativeDate,
            ec.ds2019_endDate,
            ec.doc_midterm_evaluation,
            ec.doc_summative_evaluation,
            p.programName,
            hc.hostCompanyID,
            hc.name AS hostBusinessName,
            hc.email AS hostEmail
        FROM 
			extra_candidates ec
        INNER JOIN	
        	extra_hostcompany hc ON hc.hostCompanyID = ec.hostCompanyID
		INNER JOIN
        	smg_programs p ON p.programID = ec.programID
        WHERE
        	ec.status = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
		AND
        	ec.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="7">
        AND	
        	ec.doc_summative_evaluation IS NULL
        AND 
            ec.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#lt12MonthProgram#" list="yes"> )
        AND
            CURDATE() > DATE_ADD(ec.ds2019_startDate, INTERVAL 11 MONTH)            

		UNION
        
  		<!--- 18 Month Program - To be sent beginning of 18th month --->	            
        SELECT DISTINCT
            ec.candidateID,
            ec.programID,
            ec.firstName,
            ec.lastName,
            ec.email,
            ec.ds2019_startDate,
            DATE_ADD(ec.ds2019_startDate, INTERVAL 17 MONTH) AS summativeDate,
            ec.ds2019_endDate,
            ec.doc_midterm_evaluation,
            ec.doc_summative_evaluation,
            p.programName,
            hc.hostCompanyID,
            hc.name AS hostBusinessName,
            hc.email AS hostEmail
        FROM 
			extra_candidates ec
        INNER JOIN	
        	extra_hostcompany hc ON hc.hostCompanyID = ec.hostCompanyID
		INNER JOIN
        	smg_programs p ON p.programID = ec.programID
		WHERE
        	ec.status = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
		AND
        	ec.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="7">
        AND	
        	ec.doc_summative_evaluation IS NULL
		AND
            ec.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#lt18MonthProgram#" list="yes"> )
        AND
            CURDATE() > DATE_ADD(ec.ds2019_startDate, INTERVAL 17 MONTH)          
           
		ORDER BY
        	programID,
            summativeDate,
            hostBusinessName,
            lastName
    </cfquery>

	<cfscript>
		// set email to
		vEmailFrom = 'ryan@iseusa.com (Ryan Schreiber - Trainee Program)';
	
		// Email Midterm - Loop Through Query
		For ( i=1;i LTE qGetMidterm.Recordcount; i=i+1 ) {
			
			// set email to
			vEmailTo = '';
			
			// check if we have a valid email for the candidate
			if ( IsValid("email", qGetMidterm.email[i]) ) {
				vEmailTo = qGetMidterm.email[i] & ';';	
			}

			// check if we have a valid email for the host company
			if ( IsValid("email", qGetMidterm.hostEmail[i]) ) {
				vEmailTo = vEmailTo & qGetMidterm.hostEmail[i];	
			}
			
			// At least one of the emails (candidate/host company) is valid
			if ( LEN(vEmailTo) ) {
		
				// Email
				APPLICATION.CFC.EMAIL.sendEmail(
					emailFrom=vEmailFrom,
					emailTo=vEmailTo,
					//emailCC=vEmailCC,
					emailReplyTo=vEmailFrom,
					emailSubject=qGetMidterm.firstName[i] & ' ' & qGetMidterm.lastName[i] & " Trainee Midterm Evaluation",
					emailMessage=vMidTermEvaluation,
					emailFilePath=APPLICATION.PATH.TRAINEE.PDFDOCS & "ISE_Midterm_Evaluation.pdf",
					emailPriority=1,
					footerType="emailNoInfo",
					companyID=7
				);
			
			}

		}


		// Email Summative - Loop Through Query
		For ( i=1;i LTE qGetSummative.Recordcount; i=i+1 ) {
			
			// set email to
			vEmailTo = '';
			
			// check if we have a valid email for the candidate
			if ( IsValid("email", qGetSummative.email[i]) ) {
				vEmailTo = qGetSummative.email[i] & ';';	
			}

			// check if we have a valid email for the candidate
			if ( IsValid("email", qGetSummative.hostEmail[i]) ) {
				vEmailTo = vEmailTo & qGetSummative.hostEmail[i];	
			}
			
			// At least one of the emails (candidate/host company) is valid
			if ( LEN(vEmailTo) ) {
		
				// Email
				APPLICATION.CFC.EMAIL.sendEmail(
					emailFrom=vEmailFrom,
					emailTo=vEmailTo,
					//emailCC=vEmailCC,
					emailReplyTo=vEmailFrom,
					emailSubject=qGetSummative.firstName[i] & ' ' & qGetSummative.lastName[i] & " Trainee Summative Evaluation",
					emailMessage=vSummativeEvaluation,
					emailFilePath=APPLICATION.PATH.TRAINEE.PDFDOCS & "ISE_Summative_Evaluation.pdf",
					emailPriority=1,
					footerType="emailNoInfo",
					companyID=7
				);

			}

		}
	</cfscript>	

</cfsilent>

<cfoutput>

<!--- MidTerm --->
<table width="100%" cellpadding="3" cellspacing="0" style="margin:10px; border:1px solid ##999;">
	<tr>
    	<th colspan="8" style="border-bottom:1px solid ##999;">Midterm Evaluation</th>
	</tr>        
	<tr>
    	<td style="border-bottom:1px solid ##999;">Candidate</td>
        <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">Email</td>
        <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">Program</td>
        <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">Start Date</td>
        <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">Midterm Date</td>
        <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">End Date</td>
        <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">Host Company</td>
        <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">Email</td>
	</tr>
    <cfloop query="qGetMidterm">
        <tr>
            <td style="border-bottom:1px solid ##999;">###qGetMidterm.candidateID# #qGetMidterm.firstName# #qGetMidterm.lastName#</td>
            <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">#qGetMidterm.email#</td>
            <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">#qGetMidterm.programName#</td>
            <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">#DateFormat(qGetMidterm.ds2019_startDate, 'mm/dd/yyyy')#</td>
            <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">#DateFormat(qGetMidterm.midtermDate, 'mm/dd/yyyy')#</td>
            <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">#DateFormat(qGetMidterm.ds2019_endDate, 'mm/dd/yyyy')#</td>
            <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">#qGetMidterm.hostBusinessName#</td>
            <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">#qGetMidterm.hostEmail#</td>
        </tr>
    </cfloop>
</table>

<!--- Summative --->
<table width="100%" cellpadding="3" cellspacing="0" style="margin:10px; border:1px solid ##999;">
	<tr>
    	<th colspan="8" style="border-bottom:1px solid ##999;">Summative Evaluation</th>
	</tr>        
	<tr>
    	<td style="border-bottom:1px solid ##999;">Candidate</td>
        <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">Email</td>
        <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">Program</td>
        <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">Start Date</td>
        <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">Summative Date</td>
        <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">End Date</td>
        <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">Host Company</td>
        <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">Email</td>
	</tr>
    <cfloop query="qGetSummative">
        <tr>
            <td style="border-bottom:1px solid ##999;">###qGetSummative.candidateID# #qGetSummative.firstName# #qGetSummative.lastName#</td>
            <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">#qGetSummative.email#</td>
            <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">#qGetSummative.programName#</td>
            <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">#DateFormat(qGetSummative.ds2019_startDate, 'mm/dd/yyyy')#</td>
            <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">#DateFormat(qGetSummative.summativeDate, 'mm/dd/yyyy')#</td>
            <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">#DateFormat(qGetSummative.ds2019_endDate, 'mm/dd/yyyy')#</td>
            <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">#qGetSummative.hostBusinessName#</td>
            <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">#qGetSummative.hostEmail#</td>
        </tr>
    </cfloop>
</table>

</cfoutput>