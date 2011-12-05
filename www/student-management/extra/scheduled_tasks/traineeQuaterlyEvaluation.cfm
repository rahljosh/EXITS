<!--- ------------------------------------------------------------------------- ----
	
	File:		traineeQuaterlyEvaluation.cfm
	Author:		Marcus Melo
	Date:		December 2, 2011
	Desc:		Scheduled Task - Sends out an email every quarter 
				
				February 1st
				May 1st
				August 1st
				December 1st
				
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<cfscript>
		// Store Program List
		vProgramList = '194,195,196,197,198,199';
		
		// Set Current Month Evaluation
		vCurrentMonth = Month(now());
		
		// Set Month of Evaluation Report
		vMonthEvaluation = '';
		
		switch(vCurrentMonth) {
			
			// February
			case 2: case 3: case 4: {
				vMonthEvaluation = 2;
			}
			// May
			case 5: case 6: case 7: {
				vMonthEvaluation = 5;
			}
			// August
			case 8: case 9: case 10: {
				vMonthEvaluation = 8;
			}
			// November
			case 11: case 12: case 1: {
				vMonthEvaluation = 11;
			}

		}
		
		// Store Midterm Email Body in a variable
		savecontent variable="vQuaterlyEvaluationEmailBody" {
			WriteOutput(
			"
				<p>Dear Participant,</p>
				
				<p>				
					Your participation in the Training Program is sponsored by CSB International. 
					We are committed to provide you with an ongoing support during your program in the United States. 
					Every three months you will receive quarterly evaluations by e-mail. These evaluations are crucial for your successful experience.
				</p>
				
				<p>	
					Please use the link below to access the CSB quarterly evaluation, it consists of 7 (seven) questions you must answer. 
					You must respond in full within 10 (ten) business days of receiving this email.
				</p>
				
				<p>
					<a href=""{vQuaterlyEvaluationLink}"">CSB Quaterly Evaluation</a>
				</p>
				
				<p>
					If the link above does not work, please copy and paste the following text into a browser:
				</p>

				<p>
					{vQuaterlyEvaluationLink} 
				</p>				
				
				<p>	
					NOTE: Failure to respond in a timely manner may negatively affect your program. It is very important that you respond.
				</p>	
				
				<p>	
					Sergei Chernyshov  <br />
					Program Manager  <br />
					CSB International  <br />
					119 Cooper St, Babylon, NY, 11702  <br />
					Phone:(631) 893-4540 Ext.131 Fax:(631) 893-4550  <br />
					Toll Free: 1-800-766-4656  <br />
					Email: <a href=""mailto:sergei@iseusa.com"">sergei@iseusa.com</a> <br /> <br />
				</p>	
			");
		}	
	</cfscript>

	<!--- Get Active Candidates Pending Evaluation --->
    <cfquery name="qGetActiveCandidates" datasource="#APPLICATION.DSN.Source#">
        SELECT DISTINCT
            ec.candidateID,
            ec.uniqueID,
            ec.programID,
            ec.firstName,
            ec.lastName,
            ec.email,
            ec.ds2019_startDate,
            ec.ds2019_endDate,
            p.programName,
            hc.hostCompanyID,
            hc.name AS hostBusinessName,
            hc.email AS hostEmail
        FROM 
			extra_candidates ec
		INNER JOIN
        	smg_programs p ON p.programID = ec.programID
        INNER JOIN	
        	extra_hostCompany hc ON hc.hostCompanyID = ec.hostCompanyID            
		WHERE
        	ec.status = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
		AND
        	ec.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="7">
        AND	
        	ec.doc_midterm_evaluation IS NULL
        AND 
            ec.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#vProgramList#" list="yes"> )
        
		<!--- Evaluation not received --->
        AND
        	ec.candidateID NOT IN (
            	SELECT
                	candidateID
                FROM
                	extra_evaluation
                WHERE
                	monthEvaluation = <cfqueryparam cfsqltype="cf_sql_integer" value="#vMonthEvaluation#">            
            )
                   
		ORDER BY
        	p.programID,
            ec.lastName 
    </cfquery>

	<cfscript>
		// set email to
		vEmailFrom = 'sergei@iseusa.com';
	
		// Email Midterm - Loop Through Query
		For ( i=1;i LTE qGetActiveCandidates.Recordcount; i=i+1 ) {
			
			// check if we have a valid email for the candidate
			if ( IsValid("email", qGetActiveCandidates.email[i]) ) {
		
				// Change variable on email to display correct evaluation link
				vQuaterlyEvaluationLink = ReplaceNoCase(vQuaterlyEvaluationEmailBody, "{vQuaterlyEvaluationLink}", "http://www.csb-usa.com/trainee/quaterly-evaluation/?uniqueID=#qGetActiveCandidates.uniqueID[i]#", "All");
		
				// Email
				APPLICATION.CFC.EMAIL.sendEmail(
					emailFrom=vEmailFrom,
					emailTo=qGetActiveCandidates.email[i],
					emailReplyTo=vEmailFrom,
					emailSubject=qGetActiveCandidates.firstName[i] & ' ' & qGetActiveCandidates.lastName[i] & " CSB Trainee #MonthAsString(vMonthEvaluation)# Quaterly Questionnaire",
					emailMessage=vQuaterlyEvaluationLink,
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
    	<th colspan="8" style="border-bottom:1px solid ##999;">Quaterly Evaluation - #MonthAsString(vMonthEvaluation)# 1st</th>
	</tr>        
	<tr>
    	<td style="border-bottom:1px solid ##999;">Candidate</td>
        <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">Email</td>
        <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">Program</td>
        <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">Start Date</td>
        <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">End Date</td>
        <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">Host Company</td>
        <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">Email</td>
	</tr>
    <cfloop query="qGetActiveCandidates">
        <tr>
            <td style="border-bottom:1px solid ##999;">###qGetActiveCandidates.candidateID# #qGetActiveCandidates.firstName# #qGetActiveCandidates.lastName#</td>
            <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">#qGetActiveCandidates.email#</td>
            <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">#qGetActiveCandidates.programName#</td>
            <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">#DateFormat(qGetActiveCandidates.ds2019_startDate, 'mm/dd/yyyy')#</td>
            <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">#DateFormat(qGetActiveCandidates.ds2019_endDate, 'mm/dd/yyyy')#</td>
            <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">#qGetActiveCandidates.hostBusinessName#</td>
            <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">#qGetActiveCandidates.hostEmail#</td>
        </tr>
    </cfloop>
</table>

</cfoutput>