<!--- ------------------------------------------------------------------------- ----
	
	File:		canceledCandidates.cfm
	Author:		Bruno Lopes
	Date:		May 4, 2017
	Desc:		Scheduled Task - Send emails with a list of canceled candidates.
				It should be scheduled to run daily.

----- ------------------------------------------------------------------------- --->
<cfquery name="getCanceledCandidatesHC" datasource="#APPLICATION.DSN.Source#">
	SELECT
		ec.candidateID,
		ec.firstName,
		ec.middleName,
		ec.lastname,
		ec.intrep,
		ec.cancellation_fee,
		u.businessName,
		ehc.supervisor,
		ehc.email
	FROM extra_candidates ec
	INNER JOIN smg_users u ON u.userID = ec.intrep
	INNER JOIN extra_hostcompany ehc ON ec.hostcompanyid = ehc.hostcompanyid
	WHERE ec.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
		AND ec.status = 0
		AND ec.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
		AND ec.DS2019 IS NOT NULL
		AND ec.DS2019 <> ''
		AND ec.cancel_date = CURDATE()
	GROUP BY ehc.hostcompanyid
    ORDER BY
		ec.lastName,
		ec.firstName 
</cfquery>

    
<cfif getCanceledCandidatesHC.RecordCount GT 0 >
	<cfloop query="getCanceledCandidatesHC">
		<cfquery name="getCanceledCandidates" datasource="#APPLICATION.DSN.Source#">
			SELECT
				ec.candidateID,
				ec.firstName,
				ec.middleName,
				ec.lastname,
				ec.intrep,
				ec.cancel_reason,
				u.businessName
			FROM extra_candidates ec
			INNER JOIN smg_users u ON u.userID = ec.intrep
			WHERE ec.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
				AND ec.status = 0
				AND ec.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
				AND ec.DS2019 IS NOT NULL
				AND ec.DS2019 <> ''
				AND ec.cancel_date = CURDATE()
		    ORDER BY
				ec.lastName,
				ec.firstName 
		</cfquery>

		<cfsavecontent variable="emailContent" >
			<cfoutput>
				<p>Dear #getCanceledCandidatesHC.supervisor#,

				<p>We would like to inform you that has the following participant(s) is(are) cancelled on #DateFormat(Now(), "mm/dd/yyyy")#.</p>

				<cfloop query="getCanceledCandidates">
					#getCanceledCandidates.firstName# #getCanceledCandidates.middleName# #getCanceledCandidates.lastname# (###getCanceledCandidates.candidateID#): #getCanceledCandidates.cancel_reason#.<br />
				</cfloop>
			</cfoutput>
		</cfsavecontent>


		<cfscript>
			vEmailFrom 	= 'support@csb-usa.com (CSB Summer Work Travel)';
			vEmailTo	= getCanceledCandidatesHC.email;
			
			// Send Email
			
			if ( IsValid("email", vEmailTo) ) {
				APPLICATION.CFC.EMAIL.sendEmail(
					emailFrom 	 = vEmailFrom,
					emailTo 	 = vEmailTo,
					emailReplyTo = vEmailFrom,
					emailSubject = "Cancellation SWT",
					emailMessage = emailContent,
					footerType	 = "emailNoInfo",
					displayEmailLogoHeader=1,
					companyID	 = 8
				);
			}
			
		</cfscript>
	</cfloop>
</cfif>

<cfdump var="#getCanceledCandidatesHC#" />
