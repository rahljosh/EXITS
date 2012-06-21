<!--- ------------------------------------------------------------------------- ----
	
	File:		watDailyEvaluation.cfm
	Author:		James Griffiths
	Date:		June 5, 2012
	Desc:		Scheduled Task - Email link to evaluation report 20, 50, 80, and 110
					days after check in date.
				It should be scheduled to run daily.

----- ------------------------------------------------------------------------- --->

<cfsilent>

	<cfquery name="qEvaluation1" datasource="#APPLICATION.DSN.Source#">
        SELECT
            ec.uniqueID,
            ec.candidateID,
            ec.firstName,
            ec.middleName,
            ec.lastName,
            ec.email,
            ec.ds2019,
            DATE_FORMAT(ec.watDateCheckedIn, '%m/%e/%Y') AS checkInDate,
            ec.watDateCheckedIn,
            IFNULL(DATE_FORMAT(ec.watDateEvaluation1, '%m/%e/%Y'), '') AS watDateEvaluation1,
            IFNULL(DATE_FORMAT(ec.watDateEvaluation2, '%m/%e/%Y'), '') AS watDateEvaluation2,
            IFNULL(DATE_FORMAT(ec.watDateEvaluation3, '%m/%e/%Y'), '') AS watDateEvaluation3,
            IFNULL(DATE_FORMAT(ec.watDateEvaluation4, '%m/%e/%Y'), '') AS watDateEvaluation4,
            DATE_FORMAT(ec.dob, '%m/%e/%Y') AS dob,
            DATE_FORMAT(ec.startDate, '%m/%e/%Y') AS startDate,
            DATE_FORMAT(ec.endDate, '%m/%e/%Y') AS endDate,
            IFNULL(u.businessName, '') AS businessName,
            IFNULL(p.programName, '') AS programName,
            IFNULL(eh.name, '') AS hostCompanyName
        FROM 
            extra_candidates ec
        INNER JOIN
            smg_users u ON u.userID = ec.intRep
        LEFT OUTER JOIN
            extra_hostCompany eh ON eh.hostCompanyID = ec.hostCompanyID
        LEFT OUTER JOIN
            smg_programs p ON p.programID = ec.programID
        WHERE
            ec.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
        AND
            ec.status = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
        AND    
            ec.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">                       
        AND
            ec.applicationStatusID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="0,11" list="yes"> )
		AND
        	CURDATE() = DATE_ADD(watDateCheckedIn, INTERVAL 20 DAY)
		ORDER BY
            ec.lastName,
            ec.firstName
    </cfquery>
    
    <cfquery name="qEvaluation2" datasource="#APPLICATION.DSN.Source#">
        SELECT
            ec.uniqueID,
            ec.candidateID,
            ec.firstName,
            ec.middleName,
            ec.lastName,
            ec.email,
            ec.ds2019,
            DATE_FORMAT(ec.watDateCheckedIn, '%m/%e/%Y') AS checkInDate,
            ec.watDateCheckedIn,
            IFNULL(DATE_FORMAT(ec.watDateEvaluation1, '%m/%e/%Y'), '') AS watDateEvaluation1,
            IFNULL(DATE_FORMAT(ec.watDateEvaluation2, '%m/%e/%Y'), '') AS watDateEvaluation2,
            IFNULL(DATE_FORMAT(ec.watDateEvaluation3, '%m/%e/%Y'), '') AS watDateEvaluation3,
            IFNULL(DATE_FORMAT(ec.watDateEvaluation4, '%m/%e/%Y'), '') AS watDateEvaluation4,
            DATE_FORMAT(ec.dob, '%m/%e/%Y') AS dob,
            DATE_FORMAT(ec.startDate, '%m/%e/%Y') AS startDate,
            DATE_FORMAT(ec.endDate, '%m/%e/%Y') AS endDate,
            IFNULL(u.businessName, '') AS businessName,
            IFNULL(p.programName, '') AS programName,
            IFNULL(eh.name, '') AS hostCompanyName
        FROM 
            extra_candidates ec
        INNER JOIN
            smg_users u ON u.userID = ec.intRep
        LEFT OUTER JOIN
            extra_hostCompany eh ON eh.hostCompanyID = ec.hostCompanyID
        LEFT OUTER JOIN
            smg_programs p ON p.programID = ec.programID
        WHERE
            ec.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
        AND
            ec.status = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
        AND    
            ec.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">                       
        AND
            ec.applicationStatusID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="0,11" list="yes"> )
        AND
        	CURDATE() = DATE_ADD(watDateCheckedIn, INTERVAL 50 DAY)
		ORDER BY
            ec.lastName,
            ec.firstName
    </cfquery>
    
    <cfquery name="qEvaluation3" datasource="#APPLICATION.DSN.Source#">
        SELECT
            ec.uniqueID,
            ec.candidateID,
            ec.firstName,
            ec.middleName,
            ec.lastName,
            ec.email,
            ec.ds2019,
            DATE_FORMAT(ec.watDateCheckedIn, '%m/%e/%Y') AS checkInDate,
            ec.watDateCheckedIn,
            IFNULL(DATE_FORMAT(ec.watDateEvaluation1, '%m/%e/%Y'), '') AS watDateEvaluation1,
            IFNULL(DATE_FORMAT(ec.watDateEvaluation2, '%m/%e/%Y'), '') AS watDateEvaluation2,
            IFNULL(DATE_FORMAT(ec.watDateEvaluation3, '%m/%e/%Y'), '') AS watDateEvaluation3,
            IFNULL(DATE_FORMAT(ec.watDateEvaluation4, '%m/%e/%Y'), '') AS watDateEvaluation4,
            DATE_FORMAT(ec.dob, '%m/%e/%Y') AS dob,
            DATE_FORMAT(ec.startDate, '%m/%e/%Y') AS startDate,
            DATE_FORMAT(ec.endDate, '%m/%e/%Y') AS endDate,
            IFNULL(u.businessName, '') AS businessName,
            IFNULL(p.programName, '') AS programName,
            IFNULL(eh.name, '') AS hostCompanyName
        FROM 
            extra_candidates ec
        INNER JOIN
            smg_users u ON u.userID = ec.intRep
        LEFT OUTER JOIN
            extra_hostCompany eh ON eh.hostCompanyID = ec.hostCompanyID
        LEFT OUTER JOIN
            smg_programs p ON p.programID = ec.programID
        WHERE
            ec.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
        AND
            ec.status = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
        AND    
            ec.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">                       
        AND
            ec.applicationStatusID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="0,11" list="yes"> )
		AND
        	CURDATE() = DATE_ADD(watDateCheckedIn, INTERVAL 80 DAY)
		ORDER BY
            ec.lastName,
            ec.firstName
    </cfquery>
    
    <cfquery name="qEvaluation4" datasource="#APPLICATION.DSN.Source#">
        SELECT
            ec.uniqueID,
            ec.candidateID,
            ec.firstName,
            ec.middleName,
            ec.lastName,
            ec.email,
            ec.ds2019,
            DATE_FORMAT(ec.watDateCheckedIn, '%m/%e/%Y') AS checkInDate,
            ec.watDateCheckedIn,
            IFNULL(DATE_FORMAT(ec.watDateEvaluation1, '%m/%e/%Y'), '') AS watDateEvaluation1,
            IFNULL(DATE_FORMAT(ec.watDateEvaluation2, '%m/%e/%Y'), '') AS watDateEvaluation2,
            IFNULL(DATE_FORMAT(ec.watDateEvaluation3, '%m/%e/%Y'), '') AS watDateEvaluation3,
            IFNULL(DATE_FORMAT(ec.watDateEvaluation4, '%m/%e/%Y'), '') AS watDateEvaluation4,
            DATE_FORMAT(ec.dob, '%m/%e/%Y') AS dob,
            DATE_FORMAT(ec.startDate, '%m/%e/%Y') AS startDate,
            DATE_FORMAT(ec.endDate, '%m/%e/%Y') AS endDate,
            IFNULL(u.businessName, '') AS businessName,
            IFNULL(p.programName, '') AS programName,
            IFNULL(eh.name, '') AS hostCompanyName
        FROM 
            extra_candidates ec
        INNER JOIN
            smg_users u ON u.userID = ec.intRep
        LEFT OUTER JOIN
            extra_hostCompany eh ON eh.hostCompanyID = ec.hostCompanyID
        LEFT OUTER JOIN
            smg_programs p ON p.programID = ec.programID
        WHERE
            ec.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
        AND
            ec.status = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
        AND    
            ec.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">                       
        AND
            ec.applicationStatusID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="0,11" list="yes"> )
		AND
        	CURDATE() = DATE_ADD(watDateCheckedIn, INTERVAL 110 DAY)
		ORDER BY
            ec.lastName,
            ec.firstName
    </cfquery>
	
</cfsilent>

<cfsavecontent variable="vEmailBody">
    <p>
        Your participation in the Summer Travel Program is sponsored by CSB. We are committed to provide you with an ongoing support during your program 
        in the United States. During your program, you will receive monthly evaluations by e-mail, as required by the US Department of State. 
        These evaluations are mandatory and crucial for your experience.
    </p>
    
    <p>
        <strong>The CSB monthly evaluation consists of</strong> 9 (nine) questions that require your answer. You must <strong><u>answer in full</u></strong> 
        within 10 (ten) days of receiving the evaluation notification.
    </p>
    
    <p style="font-weight:bold; text-decoration:underline; font-size:16px; text-align:center;">
        Please click to access the evaluation form: <a href="http://www.csb-usa.com/evaluation?evaluation={evaluationID}&uniqueID={uniqueID}">Take Evaluation</a>
    </p>
    
    <p style="color:red;">
        Note: Failure to respond in a timely manner may result in program termination. It is very important that you respond.
    </p>
    
    Kind Regards,<br />
    CSB Summer Work Travel Program<br /> 
    119 Cooper Street<br />
    Babylon, NY 11702<br />
    877-669-0717 - Toll Free<br />
    631-893-4549 - Phone<br />
    support@csb-usa.com<br />
</cfsavecontent>
    
<cfscript>
	vEmailFrom = 'support@csb-usa.com (CSB Summer Work Travel)';
	
	// Evaluation 1
	For ( i=1;i LTE qEvaluation1.Recordcount; i=i+1 ) {

		vEmailTo = qEvaluation1.email[i];

		vEvaluationEmailBody = ReplaceNoCase(vEmailBody, "{evaluationID}", 1);
		vEvaluationEmailBody = ReplaceNoCase(vEvaluationEmailBody, "{uniqueID}", qEvaluation1.uniqueID[i]);
		
		if ( IsValid("email", qEvaluation1.email[i]) ) {

			
			APPLICATION.CFC.EMAIL.sendEmail(
				emailFrom=vEmailFrom,
				emailTo=qEvaluation1.email[i],
				emailReplyTo=vEmailFrom,
				emailSubject="CSB - 1 - Mandatory Summer Work Travel Evaluation",
				emailMessage=vEvaluationEmailBody,
				footerType="emailNoInfo",
				companyID=8
			);
			
		}
		
	}

	// Evaluation 2
	For ( i=1;i LTE qEvaluation2.Recordcount; i=i+1 ) {
		
		vEmailTo = qEvaluation2.email[i];
		vEvaluationEmailBody = ReplaceNoCase(vEmailBody, "{evaluationID}", 2);
		vEvaluationEmailBody = ReplaceNoCase(vEvaluationEmailBody, "{uniqueID}", qEvaluation2.uniqueID[i]);
			
		if ( IsValid("email", qEvaluation2.email[i]) ) {
			
				APPLICATION.CFC.EMAIL.sendEmail(
				emailFrom=vEmailFrom,
				emailTo=qEvaluation2.email[i],
				emailReplyTo=vEmailFrom,
				emailSubject="CSB - 2 - Mandatory Summer Work Travel Evaluation",
				emailMessage=vEvaluationEmailBody,
				footerType="emailNoInfo",
				companyID=8
			);
				
		}
		
	}
	
	// Evaluation 3
	For ( i=1;i LTE qEvaluation3.Recordcount; i=i+1 ) {
		
		vEmailTo = qEvaluation3.email[i];	
		vEvaluationEmailBody = ReplaceNoCase(vEmailBody, "{evaluationID}", 3);
		vEvaluationEmailBody = ReplaceNoCase(vEvaluationEmailBody, "{uniqueID}", qEvaluation3.uniqueID[i]);
		
		if ( IsValid("email", qEvaluation3.email[i]) ) {
			
			APPLICATION.CFC.EMAIL.sendEmail(
				emailFrom=vEmailFrom,
				emailTo=qEvaluation3.email[i],
				emailReplyTo=vEmailFrom,
				emailSubject="CSB - 3 - Mandatory Summer Work Travel Evaluation",
				emailMessage=vEvaluationEmailBody,
				footerType="emailNoInfo",
				companyID=8
			);
			
		}
		
	}
	
	// Evaluation 4
	For ( i=1;i LTE qEvaluation4.Recordcount; i=i+1 ) {
		
		vEmailTo = qEvaluation4.email[i];
		vEvaluationEmailBody = ReplaceNoCase(vEmailBody, "{evaluationID}", 4);
		vEvaluationEmailBody = ReplaceNoCase(vEvaluationEmailBody, "{uniqueID}", qEvaluation4.uniqueID[i]);

		if ( IsValid("email", qEvaluation4.email[i]) ) {
			
			APPLICATION.CFC.EMAIL.sendEmail(
				emailFrom=vEmailFrom,
				emailTo=qEvaluation4.email[i],
				emailReplyTo=vEmailFrom,
				emailSubject="CSB - 4 - Mandatory Summer Work Travel Evaluation",
				emailMessage=vEvaluationEmailBody,
				footerType="emailNoInfo",
				companyID=8
			);
			
		}
		
	}
</cfscript>

<cfoutput>
	
    <!--- Evaluation Results --->
    <cfloop list="1,2,3,4" index="i">
        
        <table width="100%" cellpadding="3" cellspacing="0" style="margin:10px; border:1px solid ##999;">
            <tr>
                <th colspan="8" style="border-bottom:1px solid ##999;">Evaluation #i#</th>
            </tr>        
            <tr>
                <td style="border-bottom:1px solid ##999;">Candidate</td>
                <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">Email</td>
                <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">Program</td>
                <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">Host Company</td>
            </tr>
            <cfloop query="qEvaluation#i#">
                <tr>
                    <td style="border-bottom:1px solid ##999;">###candidateID# #firstName# #lastName#</td>
                    <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">#email#</td>
                    <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">#programName#</td>
                    <td style="border-bottom:1px solid ##999; border-left:1px solid ##999;">#hostCompanyName#</td>
                </tr>
            </cfloop>
        </table>
        
	</cfloop>
    
</cfoutput>
