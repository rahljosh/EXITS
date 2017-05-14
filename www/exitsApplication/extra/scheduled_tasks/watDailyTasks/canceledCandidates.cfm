<!--- ------------------------------------------------------------------------- ----
	
	File:		canceledCandidates.cfm
	Author:		Bruno Lopes
	Date:		May 4, 2017
	Desc:		Scheduled Task - Send emails with a list of canceled candidates.
				It should be scheduled to run daily.

----- ------------------------------------------------------------------------- --->
<cfquery name="getCanceledCandidates" datasource="#APPLICATION.DSN.Source#">
	SELECT
		ec.candidateID,
		ec.firstName,
		ec.middleName,
		ec.lastname,
		ec.intrep,
		ec.cancellation_fee,
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

<cfset currentIntRep = 0 />

<cfsavecontent variable="emailContent" >

	<cfoutput>
		<h2>Cancellation SWT</h2>
		<cfloop query="getCanceledCandidates">

			<cfif currentIntRep NEQ  getCanceledCandidates.intrep>
				<cfset currentIntRep = getCanceledCandidates.intrep />
				<hr />
				<p><strong>#getCanceledCandidates.businessName#</strong> has the following participants cancelled on #DateFormat(Now(), "mm/dd/yyyy")#.</p>
			</cfif>
			#getCanceledCandidates.firstName# #getCanceledCandidates.middleName# #getCanceledCandidates.lastname# (###getCanceledCandidates.candidateID#): <cfif getCanceledCandidates.cancellation_fee NEQ ''> #getCanceledCandidates.cancellation_fee#<cfelse><em>None</em></cfif>. <br />
		
		</cfloop>
	</cfoutput>

</cfsavecontent>

    
<cfif getCanceledCandidates.RecordCount GT 0 >
	<cfscript>
		vEmailFrom 	= 'support@csb-usa.com (CSB Summer Work Travel)';
		vEmailTo	= 'anca@csb-usa.com, jennifer@iseusa.org';
		
		// Send Email
		
		//if ( IsValid("email", vEmailTo) ) {
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
		//}
		
	</cfscript>
</cfif>

<cfdump var="#getCanceledCandidates#" />
