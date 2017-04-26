<!--- ------------------------------------------------------------------------- ----
	
	File:		ds2019-Issued.cfm
	Author:		Bruno Lopes
	Date:		Apr 6, 2017
	Desc:		

----- ------------------------------------------------------------------------- --->

<cfoutput>

	<cfquery name="qGetHostCompList" datasource="#APPLICATION.DSN.Source#">
        SELECT eh.hostCompanyID, eh.name, eh.email, eh.companyID, MIN(ec.startdate)
        FROM extra_hostcompany eh
        JOIN extra_candidates ec ON ec.hostCompanyID = eh.hostCompanyID
        WHERE eh.name != ""
            AND eh.companyID = 8
            AND eh.active = 1
            AND ec.status = 1
            AND ec.programID = 458
            AND ec.startdate = <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
        GROUP BY eh.hostCompanyID
    </cfquery>


	<cfloop query="qGetHostCompList">

		<cfquery name="qGetParticipantsList" datasource="#APPLICATION.DSN.Source#">
	        SELECT ec.candidateID, ec.uniqueID, ec.firstname, ec.lastname, ec.sex, ec.dob, country.countryname, ec.email, ej.title,
	        		ec.ds2019, ec.ssn, ec.startdate, ec.enddate, u.businessname, ec.wat_placement, ecpc.isSecondary, 
	        		ec.englishAssessment, ec.visaInterview, ehc.name, ehc.address, ehc.address2, ehc.city, ehc.zip, s.statename
	        FROM extra_candidates ec
	        INNER JOIN smg_users u on u.userid = ec.intrep
	        INNER JOIN extra_candidate_place_company ecpc ON ecpc.candidateID = ec.candidateID
                	AND ecpc.status = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
	        LEFT JOIN smg_countrylist country ON country.countryid = ec.home_country
	        LEFT JOIN extra_jobs ej ON ej.ID = ecpc.jobID
	        LEFT JOIN extra_hostcompany ehc ON ehc.hostCompanyID = ec.hostCompanyID
	        LEFT OUTER JOIN smg_states s ON ehc.state = s.ID
	        WHERE  ec.status = 1
	            AND ec.programID = 458
	            AND ec.hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetHostCompList.hostCompanyID#">
	            AND ec.applicationStatusID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="0,11" list="yes"> )
	    </cfquery>


		<cfsavecontent variable="participantsList">
			<h3 style="margin-bottom:0">#qGetParticipantsList.name# - Total candidates: #qGetParticipantsList.recordCount#</h3>
			<p style="margin-top:3px">#qGetParticipantsList.address#, #qGetParticipantsList.city# - #qGetParticipantsList.statename# #qGetParticipantsList.zip#</p>
			<table border="1" cellspacing="0" cellpadding="5">
                    <tr style="background-color:##4F8EA4; color:##FFF; padding:5px; font-weight:bold; font-size: 11px; vertical-align:top;">
                        <td width="4%">ID</td>
                        <td width="10%">Last Name</td>
                        <td width="8%">First Name</td>
                        <td width="3%">Sex</td>
                        <td width="5%">DOB</td>
                        <td width="5%">Country</td>
                        <td width="10%">Email</td>
                        <td width="7%">Job Title</td>
                        <td width="5%">DS-2019</td>
                        <td width="5%">Start Date</td>
                        <td width="5%">End Date</td>
                        <td width="10%">Intl. Rep.</td>
                        <td width="7%">Option</td>
                        <td width="5%">Placement Type</td>
                        <td width="8%">English Assessment CSB</td>
                        <td width="5%">Visa Interview</td>
                    </tr>

				<cfoutput>
				<cfloop query="qGetParticipantsList" >
					<tr bgcolor="##FFFFFF">
                            <td><a href="http://extra.exitsapplication.com/internal/wat/index.cfm?curdoc=candidate/candidate_info&amp;uniqueid=#uniqueID#" target="_blank" class="style4">#candidateID#</a></td>
                            <td><a href="http://extra.exitsapplication.com/internal/wat/index.cfm?curdoc=candidate/candidate_info&amp;uniqueid=#uniqueID#" target="_blank" class="style4">#lastname#</a></td>
                            <td><a href="http://extra.exitsapplication.com/internal/wat/index.cfm?curdoc=candidate/candidate_info&amp;uniqueid=#uniqueID#" target="_blank" class="style4">#firstname#</a></td>
                            <td class="style1">#sex#</td>
                            <td class="style1">#dateformat(dob, 'mm/dd/yyyy')#</td>
                            <td class="style1">#countryname#</td>
                            <td class="style1"><a href="mailto:#email#" class="style4">#email#</a></td>
                            <td class="style1">#title#</td>
                            <td class="style1">#ds2019#</td>
                            <td class="style1">#dateformat(startdate, 'mm/dd/yyyy')#</td>
                            <td class="style1">#dateformat(enddate, 'mm/dd/yyyy')#</td>
                            <td class="style1">#businessname#</td>
                            <td class="style1">#wat_placement#</td>
                            <td class="style1"><cfif VAL(isSecondary)>Secondary<cfelse>Primary</cfif></td>
                            <td class="style1">#englishAssessment#</span></td>
                            <td class="style1">#DateFormat(visaInterview,'mm/dd/yyyy')#</td>
                        </tr>
				</cfloop>
				</cfoutput>

				
            </table>
		</cfsavecontent>

		<cfquery name="getEmail" datasource="#APPLICATION.DSN.Source#">
			SELECT
				id,
				subject,
				content
			FROM extra_emails
			WHERE id = 8
		</cfquery>

		<cfset emailMessage = #replace(getEmail.content, "**participantsList**", participantsList)# />


		<cfscript >
			to_email = email;
			bcc_email = 'support@csb-usa.com';

			APPLICATION.CFC.email.sendEmail(
				emailTo=to_email,
				emailBcc=bcc_email,
				companyID=companyID,
				emailSubject='#replace(getEmail.subject, "*2016*", year(now()))#',
				displayEmailLogoHeader=1,
				emailMessage='#emailMessage#'
			);

			APPLICATION.CFC.HOSTCOMPANY.setEmailTracking(
				hc_id=VAL(qGetHostCompList.hostCompanyID),
				email_id=8,
				email_content=emailMessage,
				date=NOW()
			);
		</cfscript>


    </cfloop>


    
	MESSAGES SENT!

</cfoutput>
