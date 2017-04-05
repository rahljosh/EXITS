<!--- ------------------------------------------------------------------------- ----
	
	File:		ds2019-Issued.cfm
	Author:		Bruno Lopes
	Date:		Sep 14, 2016
	Desc:		

----- ------------------------------------------------------------------------- --->

<cfoutput>

	<cfscript>
		qGetIntlRepList = APPLICATION.CFC.USER.getUsers(usertype=8,isActive=1,businessNameExists=1);
	</cfscript>


	<cfloop query="qGetIntlRepList">

			<cfscript>
	        	getVerification = APPLICATION.CFC.USER.getVerificationDate(qGetIntlRepList.userID,0);
	        </cfscript>

	        <cfset report_start_date = "4/4/2017">

	        	<cfif getVerification.recordCount GT 0  AND VAL(getVerification.VERIFICATIONRECEIVED) AND getVerification.VERIFICATIONRECEIVED GTE report_start_date>

			        <cfloop query="getVerification">

			        	<cfif VAL(getVerification.VERIFICATIONRECEIVED) >

				        	<cfquery name="qGetCandidates" datasource="#APPLICATION.DSN.Source#"> 
						        SELECT DISTINCT 
						        	c.candidateid, 
						            c.lastname, 
						            c.firstname, 
						            c.ds2019,
						            c.intrep,
						            u.businessname,
						            u.email,
						            p.programname, 
						            p.programID, 
						            p.extra_sponsor,
						            comp.companyname, 
						            comp.address AS c_address, 
						            comp.city AS c_city, 
						            comp.state AS c_state, 
						            comp.zip AS c_zip, 
						            comp.toll_free, 
						            c.hostcompanyid,
						            c.companyid,
						            h.name as hostcompanyname, 
						            h.address as hostaddress, 
						            h.city as hostcity,             
						            h.zip as hostzip,
						            h.supervisor,
						            h.phone,
						            s.state as hoststate,
						            p.programname, 
									p.programid,
									c.startdate, 
									c.enddate
						        FROM 
						        	extra_candidates c 
						        INNER JOIN smg_users u ON c.intrep = u.userid
						        INNER JOIN smg_programs p ON c.programID = p.programID
						        INNER JOIN smg_companies comp ON c.companyid = comp.companyid
						        INNER JOIN extra_hostcompany h ON c.hostcompanyid = h.hostcompanyid
						        INNER JOIN smg_states s ON s.id = h.state
								WHERE c.companyID = 8
									AND c.status = 1
									AND c.programid >= 458
						        	AND c.verification_received =  <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(getVerification.verificationReceived, 'yyyy-mm-dd')#">  
						            AND c.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetIntlRepList.userID#">
						            AND verification_received_emailSent = 0
						        GROUP BY 
						        	c.candidateid        
						        ORDER BY 
						        	u.businessname, 
						            c.lastname, 
						            c.firstname 
						    </cfquery>


				        	<cfif qGetCandidates.recordCount GT 0 >

					        	<cfquery dbtype="query" name="qGetCandidatesWithDS">
					        		SELECT *
					        		FROM qGetCandidates
					        		WHERE ds2019 IS NOT NULL
					        			AND ds2019 <> ''
					        	</cfquery>


					        	<cfif ((qGetCandidates.recordCount EQ qGetCandidatesWithDS.recordCount))>

					        		
					        		#qGetCandidates.businessname#  - #getVerification.verificationReceived# (#qGetCandidates.recordCount#)<br />
					        		

								  	<cfsavecontent variable="attachmentMessageContent">
								  		<table align="center" width="700" style="border:solid thin ##333; font-size: 9.0pt; font-family: Calibri,sans-serif;" cellspacing="2" cellpadding="0">	
											<tr>
												<td>		
													<table align="center" width="100%" border="0" cellspacing="2" cellpadding="0">	
														<tr>
										                	<td style="font-size:14px; padding-bottom:10px; font-size: 9.0pt; font-family: Calibri,sans-serif;" align="center">
										                    	<b>#qGetCandidates.companyname# &nbsp; - &nbsp; ID Cards List</b>
										                    </td>
										                </tr>
														<tr>
										                	<td style="font-size:14px; padding-bottom:5px; font-size: 9.0pt; font-family: Calibri,sans-serif;" align="center">
										                    	Program #qGetCandidates.programname# &nbsp; - &nbsp; Total of #qGetCandidates.recordcount# candidate(s)
										                    </td>
										                </tr>
														<tr>
										                	<td style="font-size:14px; padding-bottom:5px; font-size: 9.0pt; font-family: Calibri,sans-serif;" align="center">
										                		DS Verification Received on #DateFormat(verificationReceived, 'mm/dd/yyyy')#
										                	</td>
										                </tr>
													</table>
												</td>
											</tr>
										</table><br />

										<table align="center" cellpadding="10" cellspacing="0" style="font-size: 9.0pt; font-family: Calibri,sans-serif;border:solid thin ##333;">	
											<tr>
												<td class="one" style="font-size: 9.0pt; font-family: Calibri,sans-serif;"><b>Intl. Rep.</b></td>
												<td class="one" style="font-size: 9.0pt; font-family: Calibri,sans-serif;"><b>Student</b></td>
										        <td class="one" style="font-size: 9.0pt; font-family: Calibri,sans-serif;" align="center"><b>DS 2019</b></td>
												<td class="one" style="font-size: 9.0pt; font-family: Calibri,sans-serif;"><b>Start Date</b></td>
												<td class="one" style="font-size: 9.0pt; font-family: Calibri,sans-serif;"><b>End Date</b></td>
												<td class="two" style="font-size: 9.0pt; font-family: Calibri,sans-serif;"><b>Duration</b></td>
											</tr>
											<cfloop query="qGetCandidates">
												<tr bgcolor="#iif(currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
													<td class="three" style="font-size: 9.0pt; font-family: Calibri,sans-serif;" align="center">#businessname#</td>
													<td class="three" style="font-size: 9.0pt; font-family: Calibri,sans-serif;">#Firstname# #lastname# (###candidateid#)</td>
										            <td class="three" style="font-size: 9.0pt; font-family: Calibri,sans-serif;" align="center">#ds2019#</td>
													<td class="three" style="font-size: 9.0pt; font-family: Calibri,sans-serif;" align="center">#DateFormat(startdate, 'mm/dd/yyyy')#</td>
													<td class="three" style="font-size: 9.0pt; font-family: Calibri,sans-serif;" align="center">#DateFormat(enddate, 'mm/dd/yyyy')#</td>
													<td class="four" style="font-size: 9.0pt; font-family: Calibri,sans-serif;" align="center">#Ceiling(DateDiff('d',startdate, enddate) / 7)# weeks</td>
												</tr>
											</cfloop>
										</table>
										
									</cfsavecontent>

<!---
					        		<cfscript >
					        			to_email = qGetCandidates.email;
					        			bcc_email = 'support@csb-usa.com';

					        			APPLICATION.CFC.email.sendEmail(
											emailTo=to_email,
											emailBcc=bcc_email,
											companyID=qGetCandidates.companyID,
											emailSubject='SWT - SEVIS ##s / DS report batch #getVerification.verificationReceivedDisplay#',
											displayEmailLogoHeader=1,
											emailMessage='<p style="font-size: 9.0pt; font-family: Calibri,sans-serif; color: ##000;">Dear <strong>#qGetCandidates.businessname#</strong>,</p>

										<p style="font-size: 9.0pt; font-family: Calibri,sans-serif; color: ##000;">The visa documents for the participant(s) included on the <strong>DS verification Report</strong> batch <strong>#getVerification.verificationReceivedDisplay#</strong> have been successfully issued. Once the payment is received, the package with the original documents will be sent by courier with a tracking number.</p>

										<p style="font-size: 9.0pt; font-family: Calibri,sans-serif; color: red;"><strong>Reminders:</strong>
										<ul style="font-size: 9.0pt; font-family: Calibri,sans-serif; color: red;">
											<li>The generic arrival packages were sent by email to each participant, per handbook, page 10.</li>
											<li>Locate the SEVIS ##s - <span style="color: ##000;">Reports->All participating Candidates->DS-2019 column</span></li> 
											<li>Input the visa interview date <span style="color: ##000;">(<u><strong>mandatory<strong></u>) - via Tools->Visa interview</span></li>
										</ul>
										</p>

										<p style="font-size: 9.0pt; font-family: Calibri,sans-serif; color: ##000;"><strong>SEVIS fee:</strong><br />
										You may now also proceed with the <u>payment of the SEVIS fee</u> and with the schedule of the J-1 visa interview. Important information:
										<ul style="font-size: 9.0pt; font-family: Calibri,sans-serif; color: ##000;">
											<li>Exchange Visitor Program Number: <span style="color: red;">P-4-13299</span></li>
											<li>Exchange Visitor Category: <span style="color: red;">Summer Travel/Work ($35.00)</span></li>
										</ul>
										</p>

										#attachmentMessageContent#'
										);
					        		</cfscript>


					        		<cfloop query="qGetCandidates" >
					        			<cfquery name="updateCandidate" datasource="#APPLICATION.DSN.Source#"> 
					        				UPDATE extra_candidates
					        				SET verification_received_emailSent = 1
					        				WHERE extra_candidates.candidateid = #qGetCandidates.candidateid#
					        			</cfquery>
					        		</cfloop>
--->

					        	</cfif>

				        	</cfif>
			    		    	
			    		</cfif>    	

			        </cfloop>

		        </cfif>

    </cfloop>

    
	MESSAGES SENT!

</cfoutput>