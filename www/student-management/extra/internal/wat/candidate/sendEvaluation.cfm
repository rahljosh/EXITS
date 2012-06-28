<!--- ------------------------------------------------------------------------- ----
	
	File:		sendEvaluation.cfm
	Author:		James Griffiths
	Date:		June 28, 2012
	Desc:		Sends the monthly evaluation email to the student id sent in the url.
					NOTE: There is a scheduled task that sends this to all students
					at the appropriate time, this file should only be run per student
					if they did not receive the scheduled email.

----- ------------------------------------------------------------------------- --->

<cfparam name="URL.candidateID" default="0">
<cfparam name="URL.evaluationID" default="1">

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
            DATE_FORMAT(ec.endDate, '%m/%e/%Y') AS endDate
        FROM 
            extra_candidates ec
        WHERE
        	ec.candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.candidateID#">
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
	vEmailTo = qEvaluation.email;
	
	vEvaluationEmailBody = ReplaceNoCase(vEmailBody, "{evaluationID}", URL.evaluationID);
	vEvaluationEmailBody = ReplaceNoCase(vEvaluationEmailBody, "{uniqueID}", qEvaluation.uniqueID);
				
	if ( IsValid("email", qEvaluation.email) ) {
		APPLICATION.CFC.EMAIL.sendEmail(
			emailFrom=vEmailFrom,
			emailTo=qEvaluation.email,
			emailReplyTo=vEmailFrom,
			emailSubject='CSB - 1 - Mandatory Summer Work Travel Evaluation',
			emailMessage=vEvaluationEmailBody,
			footerType="emailNoInfo",
			companyID=8
		);
	}
	
</cfscript>

<script type="text/javascript">
	alert("Evaluation email was sent to:\n<cfoutput>#qEvaluation.firstName# #qEvaluation.lastName# (###qEvaluation.candidateID#) at #qEvaluation.email#</cfoutput>");
	window.location = "../index.cfm?curdoc=candidate/candidate_info&uniqueid=<cfoutput>#qEvaluation.uniqueID#</cfoutput>";
</script>