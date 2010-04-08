<cfoutput>
<Cfquery name="get_company" datasource="caseusa">
	select *
	from smg_companies
	where companyid = '#client.companyid#'
</Cfquery>
	<cffile action="read" file="/var/www/html/case/internal/uploadedfiles/xml_files/gis/#get_company.companyshort#/#url.file#" variable="rec_xml">	
<!----If no file found, dispaly such and end---->

	<cfset responseXML = ''>
   	<cfset responseXML = XmlParse(rec_xml)>


	<!--- GET REPORT ID --->
	<cfif responseXML.bgc.product[2].USOneSearch.response.detail.offenders.XmlAttributes.qtyFound NEQ 0>
		<cfset ReportID = '#responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender.record.key.secureKey.XmlText#'>
	<cfelse>
		<cfset ReportID = '#responseXML.bgc.XmlAttributes.orderId#'>
	</cfif>

<table width="670" align="center">
			<tr><td colspan="2">&nbsp;</td></tr>

			<tr><td colspan="2">&nbsp;</td></tr>
			<!--- USOneValidate --->
			<tr bgcolor="##CCCCCC"><th colspan="2">US ONE VALIDATE</td></tr>
			<tr><td colspan="2"><b>SSN Validation & Death Master Index Check for #responseXML.bgc.product[1].USOneValidate.order.ssn#</b></td></tr>
			<tr><td colspan="2">&nbsp; &nbsp; &nbsp; #responseXML.bgc.product[1].USOneValidate.response.validation.textResponse#</td></tr>	
			<tr><td colspan="2">&nbsp; &nbsp; &nbsp; The associated individual is <b> <cfif responseXML.bgc.product[1].USOneValidate.response.validation.isDeceased.XmlText EQ 'no'>not</cfif> deceased.</b></td></tr>			
			<tr><td colspan="2">&nbsp; &nbsp; &nbsp; Issued in <b>#responseXML.bgc.product[1].USOneValidate.response.validation.stateIssued#</b> between <b>#responseXML.bgc.product[1].USOneValidate.response.validation.yearIssued#</b></td></tr>			
			<tr><td colspan="2"><hr width="100%" align="center"></td></tr>	
			
			<!--- USOneSearch --->	
			<tr bgcolor="##CCCCCC"><th colspan="2"><b>US ONE SEARCH</b></th></tr>
			<tr><td colspan="2"><b>You searched for:</b></td></tr>
			<tr><td colspan="2">&nbsp; &nbsp; &nbsp; <b>#responseXML.bgc.product[2].USOneSearch.order.lastname#, #responseXML.bgc.product[2].USOneSearch.order.firstname# #responseXML.bgc.product[2].USOneSearch.order.middlename#</b></td></tr>
			<tr><td colspan="2">&nbsp; &nbsp; &nbsp; <b>SSN : </b> #responseXML.bgc.product[1].USOneValidate.order.ssn#</td></tr>
			<tr><td colspan="2">&nbsp; &nbsp; &nbsp; <b>DOB : </b> #responseXML.bgc.product[2].USOneSearch.order.dob.month#/#responseXML.bgc.product[2].USOneSearch.order.dob.day#/#responseXML.bgc.product[2].USOneSearch.order.dob.year#</td></tr>						
			
			<cfset totalItems = #responseXML.bgc.product[2].USOneSearch.response.detail.offenders.XmlAttributes.qtyFound#>
			<tr><td>&nbsp; &nbsp; &nbsp; <b>Report ID : </b> #ReportID#</td><td>Number of items: #totalItems#<br></td></tr>
			<tr><td colspan="2"><hr width="100%" align="center"></td></tr>	
			
			<cfif totalItems NEQ 0>
				<!--- ITEMS - OFFENDER --->
				<cfloop from="1" to ="#totalItems#" index="t">
					<cfset totalOffenses = (ArrayLen(responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.XmlChildren))>
					<tr>
						<td><b>#responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].identity.personal.fullName#</b></td>
						<td>ID ##: #responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].record.key.offenderid#</td>
					</tr>
					<tr>
						<td>DOB: #responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].identity.personal.dob#</td>
						<td>GENDER: #responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].identity.personal.gender#</td>
					</tr>
					<tr><td colspan="2">Total of Offenses: #totalOffenses#<br></td></tr>
					<tr><td colspan="2"><hr width="100%" align="center"></td></tr>	
					<!--- OFFENSES --->
					<cfloop from="1" to ="#totalOffenses#" index="i">
						<tr><td colspan="2">
								<b>#responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].description#</b>
								(#responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].record.provider#, #responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].record.key.state#)
							</td>
						</tr>
						<tr><td colspan="2">&nbsp;</td></tr>
						<!--- Disposition --->
						<cfif responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].disposition.XmlText NEQ ''>
							<tr><td colspan="2">Disposition : <b>#responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].disposition#</b></td></tr>
						</cfif>
						<!--- Degree Of Offense --->
						<cfif responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].degreeOfOffense.XmlText NEQ ''>
							<tr><td colspan="2">Degree Of Offense : <b>#responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].degreeOfOffense#</b></td></tr>
						</cfif>
						<!--- Sentence --->
						<cfif responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].sentence.XmlText NEQ ''>
							<tr><td colspan="2">Sentence : <b>#responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].sentence#</b></td></tr>
						</cfif>
						<!--- Probation --->
						<cfif responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].probation.XmlText NEQ ''>
							<tr><td colspan="2">Probation : <b>#responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].probation#</b></td></tr>
						</cfif>
						<!--- Offense --->
						<cfif responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].confinement.XmlText NEQ ''>
							<tr><td colspan="2">Offense : <b>#responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].confinement#</b></td></tr>
						</cfif>
						<!--- Arresting Agency --->
						<cfif responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].arrestingAgency.XmlText NEQ ''>
							<tr><td colspan="2">Arresting Agency : <b>#responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].arrestingAgency#</b></td></tr>
						</cfif>
						<!--- Original Agency --->
						<cfif responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].originatingAgency.XmlText NEQ ''>
							<tr><td colspan="2">Original Agency : <b>#responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].originatingAgency#</b></td></tr>
						</cfif>
						<!--- Jurisdiction --->
						<cfif responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].jurisdiction.XmlText NEQ ''>
						<tr><td colspan="2">Jurisdiction : <b>#responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].jurisdiction#</b></td></tr>
						</cfif>
						<!--- Statute --->
						<cfif responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].statute.XmlText NEQ ''>
						<tr><td colspan="2">Statute : <b>#responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].statute#</b></td></tr>
						</cfif>
						<!--- Plea --->
						<cfif responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].plea.XmlText NEQ ''>
							<tr><td colspan="2">Plea : <b>#responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].plea#</b></td></tr>
						</cfif>
						<!--- Court Decision --->
						<cfif responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].courtDecision.XmlText NEQ ''>
							<tr><td colspan="2">Court Decision : <b>#responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].courtDecision#</b></td></tr>
						</cfif>
						<!--- Court Costs --->
						<cfif responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].courtCosts.XmlText NEQ ''>
							<tr><td colspan="2">Court Costs : <b>#responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].courtCosts#</b></td></tr>
						</cfif>
						<!--- Fine --->
						<cfif responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].fine.XmlText NEQ ''>
							<tr><td colspan="2">Fine : <b>#responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].fine#</b></td></tr>
						</cfif>
						<!--- Offense Date --->
						<cfif responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].offenseDate.XmlText NEQ ''>
						<tr><td colspan="2">Offense Date : <b>#responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].offenseDate#</b></td></tr>
						</cfif>
						<!--- Arrest Date --->
						<cfif responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].arrestDate.XmlText NEQ ''>
							<tr><td colspan="2">Arrest Date : <b>#responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].arrestDate#</b></td></tr>
						</cfif>
						<!--- Sentence Date --->
						<cfif responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].sentenceDate.XmlText NEQ ''>
							<tr><td colspan="2">Sentence Date : <b>#responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].sentenceDate#</b></td></tr>
						</cfif>
						<!--- Disposition Date --->
						<cfif responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].dispositionDate.XmlText NEQ ''>
							<tr><td colspan="2">Disposition Date : <b>#responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].dispositionDate#</b></td></tr>
						</cfif>
						<!--- File Date --->
						<cfif responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].fileDate.XmlText NEQ ''>
						<tr><td colspan="2">File Date : <b>#responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].fileDate#</b></td></tr>
						</cfif>
						<tr><td colspan="2">&nbsp;</td></tr>
						
						<!--- SPECIFIC INFORMATION --->				
						<tr><td colspan="2"><i>#responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].record.provider#, #responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].record.key.state# SPECIFIC INFORMATION</i></td></tr>
						<cfset totalSpecifics = (ArrayLen(responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].recorddetails.recorddetail.supplements.XmlChildren))>
						<tr>
						<cfloop from="1" to ="#totalSpecifics#" index="s">
							<td>&nbsp; &nbsp; &nbsp; #responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].recorddetails.recorddetail.supplements.supplement[s].displayTitle# : 
								<b> #responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].recorddetails.recorddetail.supplements.supplement[s].displayValue# </b>
							</td>
							<cfif s MOD 2></tr><tr></tr></cfif>
						</cfloop>
						<tr><td colspan="2"><hr width="100%" align="center"></td></tr>							
					</cfloop>
				</cfloop>
			<cfelse>
				<tr><td colspan="2">No data found.</td></tr>
				<tr><td colspan="2"><hr width="100%" align="center"></td></tr>
			</cfif>
			<tr bgcolor="##CCCCCC"><th colspan="2"><b>US ONE TRACE</b></th></tr>
			<tr><td colspan="2"><b>You searched for:</b></td></tr>
			<tr><td colspan="2">&nbsp; &nbsp; &nbsp; <b>#responseXML.bgc.product[3].USOneTrace.order.lastname#, #responseXML.bgc.product[3].USOneTrace.order.firstname#</b></td></tr>
			<tr><td colspan="2">&nbsp; &nbsp; &nbsp; <b>SSN : </b> #responseXML.bgc.product[3].USOneTrace.order.ssn#</td></tr>
			<tr><td colspan="2"><hr width="100%" align="center"></td></tr>			
			<cfset traceRecords = (ArrayLen(responseXML.bgc.product[3].USOneTrace.response.records.XmlChildren))>
			<cfif traceRecords GT 0>			
				<cfloop index="tr" from="1" to ="#traceRecords#">
					<tr>
						<td>First Name : <b>#responseXML.bgc.product[3].USOneTrace.response.records.record[tr].firstName# 
							#responseXML.bgc.product[3].USOneTrace.response.records.record[tr].middleName# 
							#responseXML.bgc.product[3].USOneTrace.response.records.record[tr].lastName# </b>
						</td>
						<td>Phone Info : <b>#responseXML.bgc.product[3].USOneTrace.response.records.record[tr].phoneInfo#</b></td>
					</tr>
					<tr>
						<td>Address : <b>#responseXML.bgc.product[3].USOneTrace.response.records.record[tr].streetNumber# 
							#responseXML.bgc.product[3].USOneTrace.response.records.record[tr].streetName# </b>
						</td>		
						<td><b>#responseXML.bgc.product[3].USOneTrace.response.records.record[tr].city#, 
							#responseXML.bgc.product[3].USOneTrace.response.records.record[tr].state# 
							#responseXML.bgc.product[3].USOneTrace.response.records.record[tr].postalCode#-
							#responseXML.bgc.product[3].USOneTrace.response.records.record[tr].postalCode4# </b>
						</td>
					</tr>	
					<tr>
						<td>County : <b>#responseXML.bgc.product[3].USOneTrace.response.records.record[tr].county#</b></td>
						<td>Verified : <b>#responseXML.bgc.product[3].USOneTrace.response.records.record[tr].verified#</b></td>
					</tr>	
					<tr><td colspan="2"><hr width="100%" align="center"></td></tr>
				</cfloop>
			<cfelse>
				<tr><td colspan="2">No data found.</td></tr>
				<tr><td colspan="2"><hr width="100%" align="center"></td></tr>
			</cfif>
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr><td colspan="2">For more information please visit www.backgroundchecks.com</td></tr>	
	
		</tr>
		</table>
		</cfoutput>