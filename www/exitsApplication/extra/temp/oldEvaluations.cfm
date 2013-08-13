<!--- ------------------------------------------------------------------------- ----
	
	File:		watEvaluation.cfm
	Author:		James Griffiths
	Date:		June 5, 2012
	Desc:		Scheduled Task - Email link to evaluation report 20, 50, 80, and 110
					days after check in date.
				It should be scheduled to run daily.

----- ------------------------------------------------------------------------- --->

<cfsilent>

	<cfquery name="qEvaluation" datasource="#APPLICATION.DSN.Source#">
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
        	CURDATE() >= DATE_ADD(watDateCheckedIn, INTERVAL 20 DAY)
      	AND
        	CURDATE() < DATE_ADD(watDateCheckedIn, INTERVAL 55 DAY)
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
    
    <p style="font-weight:bold; font-size:16px; text-align:center;">
        Please click to access the evaluation form: <u><a href="http://www.csb-usa.com/evaluation?evaluation={evaluationID}&uniqueID={uniqueID}">Take Evaluation</a></u>
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
	For ( i=1;i LTE qEvaluation.Recordcount; i=i+1 ) {

		vEmailTo = qEvaluation.email[i];
		vEvaluationEmailBody = ReplaceNoCase(vEmailBody, "{evaluationID}", 1);
		vEvaluationEmailBody = ReplaceNoCase(vEvaluationEmailBody, "{uniqueID}", qEvaluation.uniqueID[i]);
			
		if ( IsValid("email", qEvaluation.email[i]) ) {
			APPLICATION.CFC.EMAIL.sendEmail(
				emailFrom=vEmailFrom,
				emailTo=qEvaluation.email[i],
				emailReplyTo=vEmailFrom,
				emailSubject='CSB - 1 - Mandatory Summer Work Travel Evaluation',
				emailMessage=vEvaluationEmailBody,
				footerType="emailNoInfo",
				companyID=8
			);
		}
	}
</cfscript>

<cfoutput>
	<p>Total of #qEvaluation.recordCount# records</p>
</cfoutput>