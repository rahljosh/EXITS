<!--- ------------------------------------------------------------------------- ----
	
	File:		sendEmails.cfm
	Author:		Bruno Lopes
	Date:		Sep 9, 2016
	Desc:		Scheduled Task - Send emails before/after program start date.
				It should be scheduled to run daily.

----- ------------------------------------------------------------------------- --->
	<!--- Welcome Email - Send 10 (ten) days BEFORE the program START date --->
	<cfquery name="getWelcomeCandidates" datasource="#APPLICATION.DSN.Source#">
		SELECT
			ec.uniqueID,
			ec.candidateID,
			ec.email,
			DATE_FORMAT(ec.startdate, '%m/%e/%Y') AS startDate,
			eet.id AS tracking_id
		FROM extra_candidates ec
		LEFT JOIN extra_emails_tracking eet ON (ec.candidateID = eet.candidate_id AND eet.email_id = 1)
		WHERE ec.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
			AND ec.status = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
			AND ec.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">                       
			AND ec.applicationStatusID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="0,11" list="yes"> )
			AND eet.id IS NULL
			AND CURDATE() = DATE_SUB(ec.startDate, INTERVAL 10 DAY)
        ORDER BY
			ec.lastName,
			ec.firstName 
	</cfquery>

	Welcome Email - Send 10 (ten) days BEFORE the program START date
	<cfdump var="#getWelcomeCandidates#" />

	<cfquery name="getWelcomeEmail" datasource="#APPLICATION.DSN.Source#">
		SELECT
			id,
			subject,
			content
		FROM extra_emails
		WHERE id = 1
	</cfquery>


	<!--- Important Rules Reminder Email - Send  15 (fifteen) days AFTER the program START date --->
	<cfquery name="getImpRulesCandidates" datasource="#APPLICATION.DSN.Source#">
		SELECT
			ec.uniqueID,
			ec.candidateID,
			ec.email,
			DATE_FORMAT(ec.startdate, '%m/%e/%Y') AS startDate,
			eet.id AS tracking_id
		FROM extra_candidates ec
		LEFT JOIN extra_emails_tracking eet ON (ec.candidateID = eet.candidate_id AND eet.email_id = 2)
		WHERE ec.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
			AND ec.status = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
			AND ec.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">                       
			AND ec.applicationStatusID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="0,11" list="yes"> )
			AND eet.id IS NULL
			AND CURDATE() = DATE_ADD(ec.startDate, INTERVAL 15 DAY)
        ORDER BY
			ec.lastName,
			ec.firstName 
	</cfquery>

	Important Rules Reminder Email - Send  15 (fifteen) days AFTER the program START date
	<cfdump var="#getImpRulesCandidates#" />

	<cfquery name="getImpRulesEmail" datasource="#APPLICATION.DSN.Source#">
		SELECT
			id,
			subject,
			content
		FROM extra_emails
		WHERE id = 2
	</cfquery>


	<!--- Bicycle Safety - Send  20 (twenty) days AFTER the program START date --->
	<cfquery name="getBikeSafetyCandidates" datasource="#APPLICATION.DSN.Source#">
		SELECT
			ec.uniqueID,
			ec.candidateID,
			ec.email,
			DATE_FORMAT(ec.startdate, '%m/%e/%Y') AS startDate,
			eet.id AS tracking_id
		FROM extra_candidates ec
		LEFT JOIN extra_emails_tracking eet ON (ec.candidateID = eet.candidate_id AND eet.email_id = 3)
		WHERE ec.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
			AND ec.status = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
			AND ec.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">                       
			AND ec.applicationStatusID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="0,11" list="yes"> )
			AND eet.id IS NULL
			AND CURDATE() = DATE_ADD(ec.startDate, INTERVAL 20 DAY)
        ORDER BY
			ec.lastName,
			ec.firstName 
	</cfquery>

	Bicycle Safety - Send  20 (twenty) days AFTER the program START date
	<cfdump var="#getBikeSafetyCandidates#" />

	<cfquery name="getBikeSafetyEmail" datasource="#APPLICATION.DSN.Source#">
		SELECT
			id,
			subject,
			content
		FROM extra_emails
		WHERE id = 3
	</cfquery>


	<!--- Second and/or Replacement Job Procedure - Send  30 (thirty) days AFTER the program START date --->
	<cfquery name="getSecRepJobCandidates" datasource="#APPLICATION.DSN.Source#">
		SELECT
			ec.uniqueID,
			ec.candidateID,
			ec.email,
			DATE_FORMAT(ec.startdate, '%m/%e/%Y') AS startDate,
			eet.id AS tracking_id
		FROM extra_candidates ec
		LEFT JOIN extra_emails_tracking eet ON (ec.candidateID = eet.candidate_id AND eet.email_id = 4)
		WHERE ec.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
			AND ec.status = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
			AND ec.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">                       
			AND ec.applicationStatusID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="0,11" list="yes"> )
			AND eet.id IS NULL
			AND CURDATE() = DATE_ADD(ec.startDate, INTERVAL 30 DAY)
        ORDER BY
			ec.lastName,
			ec.firstName 
	</cfquery>

	Second and/or Replacement Job Procedure - Send  30 (thirty) days AFTER the program START date
	<cfdump var="#getSecRepJobCandidates#" />

	<cfquery name="getSecRepJobEmail" datasource="#APPLICATION.DSN.Source#">
		SELECT
			id,
			subject,
			content
		FROM extra_emails
		WHERE id = 4
	</cfquery>


	<!--- Explore America - Send  60 (sixty) days AFTER the program START date --->
	<cfquery name="getExpAmericaCandidates" datasource="#APPLICATION.DSN.Source#">
		SELECT
			ec.uniqueID,
			ec.candidateID,
			ec.email,
			DATE_FORMAT(ec.startdate, '%m/%e/%Y') AS startDate,
			eet.id AS tracking_id
		FROM extra_candidates ec
		LEFT JOIN extra_emails_tracking eet ON (ec.candidateID = eet.candidate_id AND eet.email_id = 5)
		WHERE ec.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
			AND ec.status = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
			AND ec.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">                       
			AND ec.applicationStatusID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="0,11" list="yes"> )
			AND eet.id IS NULL
			AND CURDATE() = DATE_ADD(ec.startDate, INTERVAL 60 DAY)
        ORDER BY
			ec.lastName,
			ec.firstName 
	</cfquery>

	Explore America - Send  60 (sixty) days AFTER the program START date
	<cfdump var="#getExpAmericaCandidates#" />

	<cfquery name="getExpAmericaEmail" datasource="#APPLICATION.DSN.Source#">
		SELECT
			id,
			subject,
			content
		FROM extra_emails
		WHERE id = 5
	</cfquery>


	<!--- Photo and Video Contest - Send  65 (sixty five) days AFTER the program START date --->
	<cfquery name="getPhotoContCandidates" datasource="#APPLICATION.DSN.Source#">
		SELECT
			ec.uniqueID,
			ec.candidateID,
			ec.email,
			DATE_FORMAT(ec.startdate, '%m/%e/%Y') AS startDate,
			eet.id AS tracking_id
		FROM extra_candidates ec
		LEFT JOIN extra_emails_tracking eet ON (ec.candidateID = eet.candidate_id AND eet.email_id = 6)
		WHERE ec.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
			AND ec.status = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
			AND ec.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">                       
			AND ec.applicationStatusID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="0,11" list="yes"> )
			AND eet.id IS NULL
			AND CURDATE() = DATE_ADD(ec.startDate, INTERVAL 65 DAY)
        ORDER BY
			ec.lastName,
			ec.firstName 
	</cfquery>

	Photo and Video Contest - Send  65 (sixty five) days AFTER the program START date
	<cfdump var="#getPhotoContCandidates#" />

	<cfquery name="getPhotoContEmail" datasource="#APPLICATION.DSN.Source#">
		SELECT
			id,
			subject,
			content
		FROM extra_emails
		WHERE id = 6
	</cfquery>


	<!--- Your program end - Send  15 (fifteen) days BEFORE the program END date --->
	<cfquery name="getProgEndCandidates" datasource="#APPLICATION.DSN.Source#">
		SELECT
			ec.uniqueID,
			ec.candidateID,
			ec.email,
			DATE_FORMAT(ec.enddate, '%m/%e/%Y') AS endDate,
			eet.id AS tracking_id
		FROM extra_candidates ec
		LEFT JOIN extra_emails_tracking eet ON (ec.candidateID = eet.candidate_id AND eet.email_id = 7)
		WHERE ec.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
			AND ec.status = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
			AND ec.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">                       
			AND ec.applicationStatusID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="0,11" list="yes"> )
			AND eet.id IS NULL
			AND CURDATE() = DATE_SUB(ec.endDate, INTERVAL 15 DAY)
        ORDER BY
			ec.lastName,
			ec.firstName 
	</cfquery>
	
	Your program end - Send  15 (fifteen) days BEFORE the program END date
	<cfdump var="#getProgEndCandidates#" />

	<cfquery name="getProgEndEmail" datasource="#APPLICATION.DSN.Source#">
		SELECT
			id,
			subject,
			content
		FROM extra_emails
		WHERE id = 7
	</cfquery>
    
<cfscript>
	vEmailFrom = 'support@csb-usa.com (CSB Summer Work Travel)';
	
	// Welcome Email
	For ( i=1;i LTE getWelcomeCandidates.Recordcount; i=i+1 ) {
		vEmailTo = getWelcomeCandidates.email[i];
		
		if ( IsValid("email", vEmailTo) ) {
			APPLICATION.CFC.EMAIL.sendEmail(
				emailFrom=vEmailFrom,
				emailTo=vEmailTo,
				emailReplyTo=vEmailFrom,
				emailSubject=#replace(getWelcomeEmail.subject,"*2016*", #year(now())#,"all")#,
				emailMessage=#replace(getWelcomeEmail.content,"*2016*", #year(now())#,"all")#,
				footerType="emailNoInfo",
				displayEmailLogoHeader=0,
				companyID=8
			);
		}

		APPLICATION.CFC.CANDIDATE.setEmailTracking(
			candidate_id=VAL(getWelcomeCandidates.candidateID[i]),
			email_id=getWelcomeEmail.id,
			date=NOW());
	}


	// Important Rules Email
	For ( i=1;i LTE getImpRulesCandidates.Recordcount; i=i+1 ) {
		vEmailTo = getImpRulesCandidates.email[i];
		
		if ( IsValid("email", vEmailTo) ) {
			APPLICATION.CFC.EMAIL.sendEmail(
				emailFrom=vEmailFrom,
				emailTo=vEmailTo,
				emailReplyTo=vEmailFrom,
				emailSubject=#replace(getImpRulesEmail.subject,"*2016*", #year(now())#,"all")#,
				emailMessage=#replace(getImpRulesEmail.content,"*2016*", #year(now())#,"all")#,
				footerType="emailNoInfo",
				displayEmailLogoHeader=0,
				companyID=8
			);
		}

		APPLICATION.CFC.CANDIDATE.setEmailTracking(
			candidate_id=VAL(getImpRulesCandidates.candidateID[i]),
			email_id=getImpRulesEmail.id,
			date=NOW());
	}


	// Bicycle Safety Email
	For ( i=1;i LTE getBikeSafetyCandidates.Recordcount; i=i+1 ) {
		vEmailTo = getBikeSafetyCandidates.email[i];
		
		if ( IsValid("email", vEmailTo) ) {
			APPLICATION.CFC.EMAIL.sendEmail(
				emailFrom=vEmailFrom,
				emailTo=vEmailTo,
				emailReplyTo=vEmailFrom,
				emailSubject=#replace(getBikeSafetyEmail.subject,"*2016*", #year(now())#,"all")#,
				emailMessage=#replace(getBikeSafetyEmail.content,"*2016*", #year(now())#,"all")#,
				footerType="emailNoInfo",
				displayEmailLogoHeader=0,
				companyID=8
			);
		}

		APPLICATION.CFC.CANDIDATE.setEmailTracking(
			candidate_id=VAL(getBikeSafetyCandidates.candidateID[i]),
			email_id=getBikeSafetyEmail.id,
			date=NOW());
	}


	// Second Replacement Job Email
	For ( i=1;i LTE getSecRepJobCandidates.Recordcount; i=i+1 ) {
		vEmailTo = getSecRepJobCandidates.email[i];
		
		if ( IsValid("email", vEmailTo) ) {
			APPLICATION.CFC.EMAIL.sendEmail(
				emailFrom=vEmailFrom,
				emailTo=vEmailTo,
				emailReplyTo=vEmailFrom,
				emailSubject=#replace(getSecRepJobEmail.subject,"*2016*", #year(now())#,"all")#,
				emailMessage=#replace(getSecRepJobEmail.content,"*2016*", #year(now())#,"all")#,
				footerType="emailNoInfo",
				displayEmailLogoHeader=0,
				companyID=8
			);
		}

		APPLICATION.CFC.CANDIDATE.setEmailTracking(
			candidate_id=VAL(getSecRepJobCandidates.candidateID[i]),
			email_id=getSecRepJobEmail.id,
			date=NOW());
	}


	// Explore America Email
	For ( i=1;i LTE getExpAmericaCandidates.Recordcount; i=i+1 ) {
		vEmailTo = getExpAmericaCandidates.email[i];
		
		if ( IsValid("email", vEmailTo) ) {
			APPLICATION.CFC.EMAIL.sendEmail(
				emailFrom=vEmailFrom,
				emailTo=vEmailTo,
				emailReplyTo=vEmailFrom,
				emailSubject=#replace(getExpAmericaEmail.subject,"*2016*", #year(now())#,"all")#,
				emailMessage=#replace(getExpAmericaEmail.content,"*2016*", #year(now())#,"all")#,
				footerType="emailNoInfo",
				displayEmailLogoHeader=0,
				companyID=8
			);
		}

		APPLICATION.CFC.CANDIDATE.setEmailTracking(
			candidate_id=VAL(getExpAmericaCandidates.candidateID[i]),
			email_id=getExpAmericaEmail.id,
			date=NOW());
	}
	

	// Photo and Video Contest Email
	For ( i=1;i LTE getPhotoContCandidates.Recordcount; i=i+1 ) {
		vEmailTo = getPhotoContCandidates.email[i];
		
		if ( IsValid("email", vEmailTo) ) {
			APPLICATION.CFC.EMAIL.sendEmail(
				emailFrom=vEmailFrom,
				emailTo=vEmailTo,
				emailReplyTo=vEmailFrom,
				emailSubject=#replace(getPhotoContEmail.subject,"*2016*", #year(now())#,"all")#,
				emailMessage=#replace(getPhotoContEmail.content,"*2016*", #year(now())#,"all")#,
				footerType="emailNoInfo",
				displayEmailLogoHeader=0,
				companyID=8
			);
		}

		APPLICATION.CFC.CANDIDATE.setEmailTracking(
			candidate_id=VAL(getPhotoContCandidates.candidateID[i]),
			email_id=getPhotoContEmail.id,
			date=NOW());
	}


	// Program End Email
	For ( i=1;i LTE getProgEndCandidates.Recordcount; i=i+1 ) {
		vEmailTo = getProgEndCandidates.email[i];
		
		if ( IsValid("email", vEmailTo) ) {
			APPLICATION.CFC.EMAIL.sendEmail(
				emailFrom=vEmailFrom,
				emailTo=vEmailTo,
				emailReplyTo=vEmailFrom,
				emailSubject=#replace(getProgEndEmail.subject,"*2016*", #year(now())#,"all")#,
				emailMessage=#replace(getProgEndEmail.content,"*2016*", #year(now())#,"all")#,
				footerType="emailNoInfo",
				displayEmailLogoHeader=0,
				companyID=8
			);
		}

		APPLICATION.CFC.CANDIDATE.setEmailTracking(
			candidate_id=VAL(getProgEndCandidates.candidateID[i]),
			email_id=getProgEndEmail.id,
			date=NOW());
	}
	
</cfscript>
