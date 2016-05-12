<!--- ------------------------------------------------------------------------- ----
	
	File:		checkInWarning.cfm
	Author:		James Griffiths
	Date:		February 24, 2014
	Desc:		Scheduled Task - Email reminder to check in to candidates when they 
					move under warning.
				It should be scheduled to run daily.

----- ------------------------------------------------------------------------- --->

<cfsilent>
	
    <cfquery name="qGetCandidates" datasource="#APPLICATION.DSN.Source#">
		SELECT
        	c.candidateID,
            c.firstName,
            c.middleName,
            c.lastName,
            c.email AS candidateEmail,
            i.email AS intRepEmail,
            CASE 
            	WHEN ADDDATE(c.startDate, INTERVAL 5 DAY) = CURDATE() THEN "WARNING"         
                WHEN ADDDATE(c.startDate, INTERVAL 10 DAY) = CURDATE() THEN "NON-COMPLIANT"
                WHEN ADDDATE(c.startDate, INTERVAL 12 DAY) = CURDATE() THEN "NON-COMPLIANT"
                ELSE ""        
            	END AS compliantStatus
     	FROM extra_candidates c
        INNER JOIN smg_users i ON c.intRep = i.userID
        LEFT OUTER JOIN smg_programs p ON c.programID = p.programID
        WHERE c.status = 1
        AND c.isDeleted = 0
        AND c.watDateCheckedIn IS NULL
        AND c.applicationStatusID IN (0,11)
        AND c.companyID = 8
        AND c.ds2019 != ""        
        AND c.ds2019 IS NOT NULL
        AND (
        	ADDDATE(c.startDate, INTERVAL 5 DAY) = CURDATE()
             OR 
            ADDDATE(c.startDate, INTERVAL 10 DAY) = CURDATE() 
             OR 
            ADDDATE(c.startDate, INTERVAL 12 DAY) = CURDATE()
            )
    </cfquery>
    
</cfsilent>

<cfsavecontent variable="vEmailBodyTemplate">
	<p>   
    	Dear {candidateName},
	</p>
    
    <p>
    	According to the program rules, participants must Check-In within 10 (ten) business days from their arrival date in the U.S., 
        to ensure that the current address is accurately reflected in SEVIS. 
        <font color="red">
        	Our records show that you have not yet reported to CSB. 
        </font>
        This is your reminder to 
        <font color="red">
        	Check-in immediately via CSB website: 
     	</font>
        www.csb-usa.com/SWT/checkin.cfm Failure to report your information on time will result in a program termination. 
        This information does not mean to scare or threaten you, rather than properly inform and protect you.
    </p>                                                               
</cfsavecontent>

<cfscript>

	vEmailFrom = 'support@csb-usa.com (CSB Summer Work Travel)';
	
	For ( i=1;i LTE qGetCandidates.Recordcount; i=i+1 ) {
		vFullName = qGetCandidates.firstName[i] & " " & qGetCandidates.middleName[i] & " " & qGetCandidates.lastName[i];
		vEmailBody = ReplaceNoCase(vEmailBodyTemplate, "{candidateName}", vFullName);
		
		if (qGetCandidates.compliantStatus[i] EQ "WARNING") {
			
			if ( IsValid("email", qGetCandidates.candidateEmail[i]) ) {
				APPLICATION.CFC.EMAIL.sendEmail(
					emailFrom=vEmailFrom,
					emailTo=qGetCandidates.candidateEmail[i],
					emailCC=qGetCandidates.intRepEmail[i],
					emailReplyTo=vEmailFrom,
					emailSubject="CSB - Reminder to Check-in - " & vFullName,
					emailMessage=vEmailBody,
					footerType="emailNoInfo",
					companyID=8
				);
			}
			
			APPLICATION.CFC.CANDIDATE.setEvaluationTracking(
				candidateID=VAL(qGetCandidates.candidateID[i]),
				evaluationNumber=0,
				date=NOW(),
				comment="System - Alert sent on " & DateFormat(NOW(),'mm/dd/yyyy') & ".");
			} 
		
		else if (qGetCandidates.compliantStatus[i] EQ "NON-COMPLIANT") {
			if ( IsValid("email", qGetCandidates.candidateEmail[i]) ) {
				APPLICATION.CFC.EMAIL.sendEmail(
					emailFrom=vEmailFrom,
					emailTo=qGetCandidates.candidateEmail[i],
					emailCC=qGetCandidates.intRepEmail[i],
					emailReplyTo=vEmailFrom,
					emailSubject="CSB - Failure to Check-in - " & vFullName,
					emailMessage=vEmailBody,
					footerType="emailNoInfo",
					companyID=8
				);
			}
			
			APPLICATION.CFC.CANDIDATE.setEvaluationTracking(
				candidateID=VAL(qGetCandidates.candidateID[i]),
				evaluationNumber=0,
				date=NOW(),
				comment="System - Alert resent on " & DateFormat(NOW(),'mm/dd/yyyy') & ".");	
		}
	}
	
</cfscript>