<!--- ------------------------------------------------------------------------- ----
	
	File:		watDailyEvaluation.cfm
	Author:		James Griffiths
	Date:		June 5, 2012
	Desc:		Scheduled Task - Email link to evaluation report 20, 50, 80, and 110
					days after check in date.
				It should be scheduled to run daily.

----- ------------------------------------------------------------------------- --->

<cfsilent>

	<!--- Get evaluations to send out the first time, when they get into warning status and haven't been completed, and when they get into non-compliant status and haven't been completed.
		Note that the dates used are set to 1 day less than the actual difference, this is to account for using the DATE_ADD function --->
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
			u.email AS intRepEmail,
			IFNULL(DATE_FORMAT(ec.watDateEvaluation1, '%m/%e/%Y'), '') AS watDateEvaluation1,
			IFNULL(DATE_FORMAT(ec.watDateEvaluation2, '%m/%e/%Y'), '') AS watDateEvaluation2,
			IFNULL(DATE_FORMAT(ec.watDateEvaluation3, '%m/%e/%Y'), '') AS watDateEvaluation3,
			IFNULL(DATE_FORMAT(ec.watDateEvaluation4, '%m/%e/%Y'), '') AS watDateEvaluation4,
			DATE_FORMAT(ec.dob, '%m/%e/%Y') AS dob,
			DATE_FORMAT(ec.startDate, '%m/%e/%Y') AS startDate,
			DATE_FORMAT(ec.endDate, '%m/%e/%Y') AS endDate,
			IFNULL(u.businessName, '') AS businessName,
			IFNULL(p.programName, '') AS programName,
			IFNULL(eh.name, '') AS hostCompanyName,
            CASE
            	WHEN CURDATE() = DATE_ADD(watDateCheckedIn, INTERVAL 20 DAY) THEN "sent"
                ELSE "resent"
          	END AS sentType
		FROM extra_candidates ec
		INNER JOIN smg_users u ON u.userID = ec.intRep
		LEFT OUTER JOIN extra_hostcompany eh ON eh.hostCompanyID = ec.hostCompanyID
		LEFT OUTER JOIN smg_programs p ON p.programID = ec.programID
		WHERE ec.companyID = 8
		AND ec.status = 1
		AND ec.isDeleted = 0                       
		AND ec.applicationStatusID IN ( 0,11 )
		AND (
        	CURDATE() = DATE_ADD(watDateCheckedIn, INTERVAL 20 DAY)
            OR ( CURDATE() = DATE_ADD(watDateCheckedIn, INTERVAL 26 DAY) AND watDateEvaluation1 IS NULL )
            OR ( CURDATE() = DATE_ADD(watDateCheckedIn, INTERVAL 31 DAY) AND watDateEvaluation1 IS NULL ) )
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
			u.email AS intRepEmail,
			IFNULL(DATE_FORMAT(ec.watDateEvaluation1, '%m/%e/%Y'), '') AS watDateEvaluation1,
			IFNULL(DATE_FORMAT(ec.watDateEvaluation2, '%m/%e/%Y'), '') AS watDateEvaluation2,
			IFNULL(DATE_FORMAT(ec.watDateEvaluation3, '%m/%e/%Y'), '') AS watDateEvaluation3,
			IFNULL(DATE_FORMAT(ec.watDateEvaluation4, '%m/%e/%Y'), '') AS watDateEvaluation4,
			DATE_FORMAT(ec.dob, '%m/%e/%Y') AS dob,
			DATE_FORMAT(ec.startDate, '%m/%e/%Y') AS startDate,
			DATE_FORMAT(ec.endDate, '%m/%e/%Y') AS endDate,
			IFNULL(u.businessName, '') AS businessName,
			IFNULL(p.programName, '') AS programName,
			IFNULL(eh.name, '') AS hostCompanyName,
            CASE
            	WHEN CURDATE() = DATE_ADD(watDateCheckedIn, INTERVAL 50 DAY) THEN "sent"
                ELSE "resent"
          	END AS sentType
		FROM extra_candidates ec
		INNER JOIN smg_users u ON u.userID = ec.intRep
		LEFT OUTER JOIN extra_hostcompany eh ON eh.hostCompanyID = ec.hostCompanyID
		LEFT OUTER JOIN smg_programs p ON p.programID = ec.programID
		WHERE ec.companyID = 8
		AND ec.status = 1
		AND ec.isDeleted = 0                       
		AND ec.applicationStatusID IN ( 0,11 )
		AND (
        	CURDATE() = DATE_ADD(watDateCheckedIn, INTERVAL 50 DAY)
			OR ( CURDATE() = DATE_ADD(watDateCheckedIn, INTERVAL 56 DAY) AND watDateEvaluation2 IS NULL )
			OR ( CURDATE() = DATE_ADD(watDateCheckedIn, INTERVAL 61 DAY) AND watDateEvaluation2 IS NULL ) )
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
			u.email AS intRepEmail,
			IFNULL(DATE_FORMAT(ec.watDateEvaluation1, '%m/%e/%Y'), '') AS watDateEvaluation1,
			IFNULL(DATE_FORMAT(ec.watDateEvaluation2, '%m/%e/%Y'), '') AS watDateEvaluation2,
			IFNULL(DATE_FORMAT(ec.watDateEvaluation3, '%m/%e/%Y'), '') AS watDateEvaluation3,
			IFNULL(DATE_FORMAT(ec.watDateEvaluation4, '%m/%e/%Y'), '') AS watDateEvaluation4,
			DATE_FORMAT(ec.dob, '%m/%e/%Y') AS dob,
			DATE_FORMAT(ec.startDate, '%m/%e/%Y') AS startDate,
			DATE_FORMAT(ec.endDate, '%m/%e/%Y') AS endDate,
			IFNULL(u.businessName, '') AS businessName,
			IFNULL(p.programName, '') AS programName,
			IFNULL(eh.name, '') AS hostCompanyName,
            CASE
            	WHEN CURDATE() = DATE_ADD(watDateCheckedIn, INTERVAL 80 DAY) THEN "sent"
                ELSE "resent"
          	END AS sentType
		FROM extra_candidates ec
		INNER JOIN smg_users u ON u.userID = ec.intRep
		LEFT OUTER JOIN extra_hostcompany eh ON eh.hostCompanyID = ec.hostCompanyID
		LEFT OUTER JOIN smg_programs p ON p.programID = ec.programID
		WHERE ec.companyID = 8
		AND ec.status = 1
		AND ec.isDeleted = 0                       
		AND ec.applicationStatusID IN ( 0,11 )
		AND (
        	CURDATE() = DATE_ADD(watDateCheckedIn, INTERVAL 80 DAY)
			OR ( CURDATE() = DATE_ADD(watDateCheckedIn, INTERVAL 86 DAY) AND watDateEvaluation3 IS NULL )
			OR ( CURDATE() = DATE_ADD(watDateCheckedIn, INTERVAL 91 DAY) AND watDateEvaluation3 IS NULL ) )
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
			u.email AS intRepEmail,
			IFNULL(DATE_FORMAT(ec.watDateEvaluation1, '%m/%e/%Y'), '') AS watDateEvaluation1,
			IFNULL(DATE_FORMAT(ec.watDateEvaluation2, '%m/%e/%Y'), '') AS watDateEvaluation2,
			IFNULL(DATE_FORMAT(ec.watDateEvaluation3, '%m/%e/%Y'), '') AS watDateEvaluation3,
			IFNULL(DATE_FORMAT(ec.watDateEvaluation4, '%m/%e/%Y'), '') AS watDateEvaluation4,
			DATE_FORMAT(ec.dob, '%m/%e/%Y') AS dob,
			DATE_FORMAT(ec.startDate, '%m/%e/%Y') AS startDate,
			DATE_FORMAT(ec.endDate, '%m/%e/%Y') AS endDate,
			IFNULL(u.businessName, '') AS businessName,
			IFNULL(p.programName, '') AS programName,
			IFNULL(eh.name, '') AS hostCompanyName,
            CASE
            	WHEN CURDATE() = DATE_ADD(watDateCheckedIn, INTERVAL 120 DAY) THEN "sent"
                ELSE "resent"
          	END AS sentType
		FROM extra_candidates ec
		INNER JOIN smg_users u ON u.userID = ec.intRep
		LEFT OUTER JOIN extra_hostcompany eh ON eh.hostCompanyID = ec.hostCompanyID
		LEFT OUTER JOIN smg_programs p ON p.programID = ec.programID
		WHERE ec.companyID = 8
		AND ec.status = 1
		AND ec.isDeleted = 0                       
		AND ec.applicationStatusID IN ( 0,11 )
		AND (
        	CURDATE() = DATE_ADD(watDateCheckedIn, INTERVAL 110 DAY)
			OR ( CURDATE() = DATE_ADD(watDateCheckedIn, INTERVAL 116 DAY) AND watDateEvaluation4 IS NULL )
			OR ( CURDATE() = DATE_ADD(watDateCheckedIn, INTERVAL 121 DAY) AND watDateEvaluation4 IS NULL ) )
        ORDER BY
			ec.lastName,
			ec.firstName
	</cfquery>
	
	<!--- Get evaluations that have not been completed and are in the last day of warning status to send out a reminder --->
    <cfquery name="qEvaluation1Reminder" datasource="#APPLICATION.DSN.Source#">
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
			u.email AS intRepEmail,
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
		FROM extra_candidates ec
		INNER JOIN smg_users u ON u.userID = ec.intRep
		LEFT OUTER JOIN extra_hostcompany eh ON eh.hostCompanyID = ec.hostCompanyID
		LEFT OUTER JOIN smg_programs p ON p.programID = ec.programID
		WHERE ec.companyID = 8
		AND ec.status = 1
		AND ec.isDeleted = 0                       
		AND ec.applicationStatusID IN ( 0,11 )
		AND ( CURDATE() = DATE_ADD(watDateCheckedIn, INTERVAL 30 DAY) AND watDateEvaluation1 IS NULL )
        ORDER BY
			ec.lastName,
			ec.firstName
	</cfquery>
    
    <cfquery name="qEvaluation2Reminder" datasource="#APPLICATION.DSN.Source#">
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
			u.email AS intRepEmail,
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
		FROM extra_candidates ec
		INNER JOIN smg_users u ON u.userID = ec.intRep
		LEFT OUTER JOIN extra_hostcompany eh ON eh.hostCompanyID = ec.hostCompanyID
		LEFT OUTER JOIN smg_programs p ON p.programID = ec.programID
		WHERE ec.companyID = 8
		AND ec.status = 1
		AND ec.isDeleted = 0                       
		AND ec.applicationStatusID IN ( 0,11 )
		AND ( CURDATE() = DATE_ADD(watDateCheckedIn, INTERVAL 60 DAY) AND watDateEvaluation2 IS NULL )
        ORDER BY
			ec.lastName,
			ec.firstName
	</cfquery>
    
    <cfquery name="qEvaluation3Reminder" datasource="#APPLICATION.DSN.Source#">
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
			u.email AS intRepEmail,
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
		FROM extra_candidates ec
		INNER JOIN smg_users u ON u.userID = ec.intRep
		LEFT OUTER JOIN extra_hostcompany eh ON eh.hostCompanyID = ec.hostCompanyID
		LEFT OUTER JOIN smg_programs p ON p.programID = ec.programID
		WHERE ec.companyID = 8
		AND ec.status = 1
		AND ec.isDeleted = 0                       
		AND ec.applicationStatusID IN ( 0,11 )
		AND ( CURDATE() = DATE_ADD(watDateCheckedIn, INTERVAL 90 DAY) AND watDateEvaluation3 IS NULL )
        ORDER BY
			ec.lastName,
			ec.firstName
	</cfquery>
    
    <cfquery name="qEvaluation4Reminder" datasource="#APPLICATION.DSN.Source#">
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
			u.email AS intRepEmail,
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
		FROM extra_candidates ec
		INNER JOIN smg_users u ON u.userID = ec.intRep
		LEFT OUTER JOIN extra_hostcompany eh ON eh.hostCompanyID = ec.hostCompanyID
		LEFT OUTER JOIN smg_programs p ON p.programID = ec.programID
		WHERE ec.companyID = 8
		AND ec.status = 1
		AND ec.isDeleted = 0                       
		AND ec.applicationStatusID IN ( 0,11 )
		AND ( CURDATE() = DATE_ADD(watDateCheckedIn, INTERVAL 120 DAY) AND watDateEvaluation4 IS NULL )
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
        <u><a href="http://www.csb-usa.com/evaluation?evaluation={evaluationID}&uniqueID={uniqueID}">Take Evaluation</a></u>
        <span style="font-size:10px;">(You must click on "Take Evaluation" to open the online form.)</span>
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

<cfsavecontent variable="vReminderBody">
	<p>
    	Dear {candidateName},
    </p>
    
    <p>
    	As required by the U.S. Department of State, CSB is sending an evaluation request by email every month, for the duration of your program, and you are required to respond within 10 (ten) business days. 
        The evaluation is designed for your best interest! <font color="red">Our records show that you are failing to take the monthly evaluation {evaluationID} on time.</font>
    </p>
    
    <p>
    	This is your reminder  to  take the evaluation {evaluationID2} immediately or contact CSB by email or phone in regards to your current program status.  
        For your convenience,  the evaluation email was resent. Please remember to always check your Spam/Junk folders.
    </p>
   
   	<p>
    	Failure to take the evaluation or contact CSB  will result in a program termination.This information does not mean to scare or threaten you, rather than properly inform and protect you.
 	</p>
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
		APPLICATION.CFC.CANDIDATE.setEvaluationTracking(
			candidateID=VAL(qEvaluation1.candidateID[i]),
			evaluationNumber=1,
			date=NOW(),
			comment="System - Evaluation " & qEvaluation1.sentType[i] & " on " & DateFormat(NOW(),'mm/dd/yyyy') & ".");
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
		APPLICATION.CFC.CANDIDATE.setEvaluationTracking(
			candidateID=VAL(qEvaluation2.candidateID[i]),
			evaluationNumber=2,
			date=NOW(),
			comment="System - Evaluation " & qEvaluation2.sentType[i] & " on " & DateFormat(NOW(),'mm/dd/yyyy') & ".");
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
		APPLICATION.CFC.CANDIDATE.setEvaluationTracking(
			candidateID=VAL(qEvaluation3.candidateID[i]),
			evaluationNumber=3,
			date=NOW(),
			comment="System - Evaluation " & qEvaluation3.sentType[i] & " on " & DateFormat(NOW(),'mm/dd/yyyy') & ".");
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
		APPLICATION.CFC.CANDIDATE.setEvaluationTracking(
			candidateID=VAL(qEvaluation4.candidateID[i]),
			evaluationNumber=4,
			date=NOW(),
			comment="System - Evaluation " & qEvaluation4.sentType[i] & " on " & DateFormat(NOW(),'mm/dd/yyyy') & ".");
	}
	
	// Evaluation 1 Reminder
	For ( i=1;i LTE qEvaluation1Reminder.Recordcount; i=i+1 ) {
		vEmailTo = qEvaluation1Reminder.email[i];
		vCandidateName = qEvaluation1Reminder.firstName[i] & " " & qEvaluation1Reminder.middleName[i] & " " & qEvaluation1Reminder.lastName[i];
		vEvaluationEmailBody = ReplaceNoCase(vReminderBody, "{candidateName}", vCandidateName);
		vEvaluationEmailBody = ReplaceNoCase(vEvaluationEmailBody, "{evaluationID}", 1);
		vEvaluationEmailBody = ReplaceNoCase(vEvaluationEmailBody, "{evaluationID2}", 1);

		if ( IsValid("email", qEvaluation1Reminder.email[i]) ) {
			APPLICATION.CFC.EMAIL.sendEmail(
				emailFrom=vEmailFrom,
				emailTo=qEvaluation1Reminder.email[i],
				emailCC=qEvaluation1Reminder.intRepEmail[i],
				emailReplyTo=vEmailFrom,
				emailSubject="CSB – Evaluation 1 Reminder - " & vCandidateName,
				emailMessage=vEvaluationEmailBody,
				footerType="emailNoInfo",
				companyID=8
			);
		}
		APPLICATION.CFC.CANDIDATE.setEvaluationTracking(
			candidateID=VAL(qEvaluation1Reminder.candidateID[i]),
			evaluationNumber=1,
			date=NOW(),
			comment="System - Reminder sent on " & DateFormat(NOW(),'mm/dd/yyyy') & ".");
	}
	
	// Evaluation 2 Reminder
	For ( i=1;i LTE qEvaluation2Reminder.Recordcount; i=i+1 ) {
		vEmailTo = qEvaluation2Reminder.email[i];
		vCandidateName = qEvaluation2Reminder.firstName[i] & " " & qEvaluation2Reminder.middleName[i] & " " & qEvaluation2Reminder.lastName[i];
		vEvaluationEmailBody = ReplaceNoCase(vReminderBody, "{candidateName}", vCandidateName);
		vEvaluationEmailBody = ReplaceNoCase(vEvaluationEmailBody, "{evaluationID}", 2);
		vEvaluationEmailBody = ReplaceNoCase(vEvaluationEmailBody, "{evaluationID2}", 2);

		if ( IsValid("email", qEvaluation2Reminder.email[i]) ) {
			APPLICATION.CFC.EMAIL.sendEmail(
				emailFrom=vEmailFrom,
				emailTo=qEvaluation2Reminder.email[i],
				emailCC=qEvaluation2Reminder.intRepEmail[i],
				emailReplyTo=vEmailFrom,
				emailSubject="CSB – Evaluation 2 Reminder - " & vCandidateName,
				emailMessage=vEvaluationEmailBody,
				footerType="emailNoInfo",
				companyID=8
			);
		}
		APPLICATION.CFC.CANDIDATE.setEvaluationTracking(
			candidateID=VAL(qEvaluation2Reminder.candidateID[i]),
			evaluationNumber=2,
			date=NOW(),
			comment="System - Reminder sent on " & DateFormat(NOW(),'mm/dd/yyyy') & ".");
	}
	
	// Evaluation 3 Reminder
	For ( i=1;i LTE qEvaluation3Reminder.Recordcount; i=i+1 ) {
		vEmailTo = qEvaluation3Reminder.email[i];
		vCandidateName = qEvaluation3Reminder.firstName[i] & " " & qEvaluation3Reminder.middleName[i] & " " & qEvaluation3Reminder.lastName[i];
		vEvaluationEmailBody = ReplaceNoCase(vReminderBody, "{candidateName}", vCandidateName);
		vEvaluationEmailBody = ReplaceNoCase(vEvaluationEmailBody, "{evaluationID}", 3);
		vEvaluationEmailBody = ReplaceNoCase(vEvaluationEmailBody, "{evaluationID2}", 3);

		if ( IsValid("email", qEvaluation3Reminder.email[i]) ) {
			APPLICATION.CFC.EMAIL.sendEmail(
				emailFrom=vEmailFrom,
				emailTo=qEvaluation3Reminder.email[i],
				emailCC=qEvaluation3Reminder.intRepEmail[i],
				emailReplyTo=vEmailFrom,
				emailSubject="CSB – Evaluation 3 Reminder - " & vCandidateName,
				emailMessage=vEvaluationEmailBody,
				footerType="emailNoInfo",
				companyID=8
			);
		}
		APPLICATION.CFC.CANDIDATE.setEvaluationTracking(
			candidateID=VAL(qEvaluation3Reminder.candidateID[i]),
			evaluationNumber=3,
			date=NOW(),
			comment="System - Reminder sent on " & DateFormat(NOW(),'mm/dd/yyyy') & ".");
	}
	
	// Evaluation 4 Reminder
	For ( i=1;i LTE qEvaluation4Reminder.Recordcount; i=i+1 ) {
		vEmailTo = qEvaluation4Reminder.email[i];
		vCandidateName = qEvaluation4Reminder.firstName[i] & " " & qEvaluation4Reminder.middleName[i] & " " & qEvaluation4Reminder.lastName[i];
		vEvaluationEmailBody = ReplaceNoCase(vReminderBody, "{candidateName}", vCandidateName);
		vEvaluationEmailBody = ReplaceNoCase(vEvaluationEmailBody, "{evaluationID}", 4);
		vEvaluationEmailBody = ReplaceNoCase(vEvaluationEmailBody, "{evaluationID2}", 4);

		if ( IsValid("email", qEvaluation4Reminder.email[i]) ) {
			APPLICATION.CFC.EMAIL.sendEmail(
				emailFrom=vEmailFrom,
				emailTo=qEvaluation4Reminder.email[i],
				emailCC=qEvaluation4Reminder.intRepEmail[i],
				emailReplyTo=vEmailFrom,
				emailSubject="CSB – Evaluation 4 Reminder - " & vCandidateName,
				emailMessage=vEvaluationEmailBody,
				footerType="emailNoInfo",
				companyID=8
			);
		}
		APPLICATION.CFC.CANDIDATE.setEvaluationTracking(
			candidateID=VAL(qEvaluation4Reminder.candidateID[i]),
			evaluationNumber=4,
			date=NOW(),
			comment="System - Reminder sent on " & DateFormat(NOW(),'mm/dd/yyyy') & ".");
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
