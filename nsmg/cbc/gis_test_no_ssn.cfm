<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'
'http://www.w3.org/TR/html4/loose.dtd'>
<html>
<head>
<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>
<title>CBC Hosts</title>
</head>

<body>

<cfsetting requestTimeOut = "500">

<cfquery name="get_company" datasource="MySql">
	SELECT companyid, companyshort, bcc_userid, bcc_password
	FROM smg_companies
	WHERE companyid = <cfqueryparam value="#client.companyid#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- BATCH ID MUST BE UNIQUE --->
<cfoutput>
	
	<cfxml variable='requestXML'>
	<BGC>
		<login>
				<user>smg1</user>
				<password>R3d3x##</password>
				<account>10005542</account>
		</login>
		<product>
			<USOneSearch version='1'>
				<order>
					<lastName>Johnson</lastName>				
					<firstName>Scott</firstName>
					<middleName>William</middleName>
					<DOB>
						<year>1970</year>
						<month>12</month>
						<day>31</day>
					</DOB>
				</order>
				<custom>
					<options>
							<noSummary>YES</noSummary>			
							<includeDetails>YES</includeDetails>
					</options>					
				</custom>		
			</USOneSearch>
		</product>
	</BGC>
	</cfxml>
 
	<!--- SUBMIT XML --->
	
	<cfset get_batchid.cbcid = 1>
	<cfset get_cbc_users.userid = 1>
	
	<!---
	 https://model.backgroundchecks.com/integration/bgcdirectpost.aspx
	 https://model.backgroundchecks.com/integration/bgcdirectpost2.aspx
	 --->	
	
	<cfset BGCDirectURL = "https://model.backgroundchecks.com/integration/bgcdirectpost.aspx">
	<table width="670" align="center">
		<th bgcolor="##CCCCCC">GIS - Criminal Background Check</th>
		<tr><td>Connecting to #BGCDirectURL#...</td></tr>
		<tr><td>Submitting CBC for...</td></tr>
		
		<!--- <cfdump var="#requestXML#"> <br> --->
		
		<!--- <cffile action="write" file="d:\websites\nsmg\cbc\gis\#get_company.companyshort#\batch_#get_batchid.cbcid#_host_#get_cbc_users.userid#_sent.xml" output="#toString(requestXML)#"> --->
		
		<cftry>
			<cfhttp url="#BGCDirectURL#" method="POST" throwonerror="yes">
				<cfhttpparam type="XML" value="#requestXML#" />
				<cfhttpparam type="Header" name="charset" value="utf-8" />
			</cfhttp>
			<br>
			
			<cfcatch type="any">
				<h2>Error</h2>
				<br>
				Error Detail: <cfoutput>#cfhttp.errorDetail#</cfoutput><br>
				<cfoutput>
					Message: #cfcatch.message#<br>
					Detail: #cfcatch.detail#<br>
					Error Code: #cfcatch.errorcode#
				</cfoutput>
				<cfabort>
			</cfcatch>
		</cftry>
		<tr><td><h2>Success!</h2></td></tr>
		<tr><td>&nbsp;</td></tr>
	</table>
	
	<cfset responseXML = ''>
   	<cfset responseXML = XmlParse(cfhttp.filecontent)>
   	
	<!--- <cfdump var="#responseXML#"> --->

	<cfdump var="#responseXML#">

	<cfif responseXML.bgc.product.USOneSearch.response.detail.offenders.XmlAttributes.qtyFound NEQ 0>
		<cfset ReportID = '#responseXML.bgc.product.USOneSearch.response.detail.offenders.offender.record.key.secureKey#'>
	<cfelse>
		<cfset ReportID = '#responseXML.bgc.XmlAttributes.orderId#'>
	</cfif>

	<cfmail from="support@student-management.com" to="marcus@student-management.com" subject="GIS Search for " failto="support@student-management.com" type="html">
		<table width="670" align="center">
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr bgcolor="##CCCCCC"><th colspan="2">* Search Results for : USER NAME + ID + COMPANY *</th></tr>
			<tr><td colspan="2">&nbsp;</td></tr>	
			<!--- USOneSearch --->	
			<tr bgcolor="##CCCCCC"><th colspan="2"><b>US ONE SEARCH</b></th></tr>
			<tr><td colspan="2"><b>You searched for:</b></td></tr>
			<tr><td colspan="2">&nbsp; &nbsp; &nbsp; <b>#responseXML.bgc.product.USOneSearch.order.lastname#, #responseXML.bgc.product.USOneSearch.order.firstname# #responseXML.bgc.product.USOneSearch.order.middlename#</b></td></tr>
			<tr><td colspan="2">&nbsp; &nbsp; &nbsp; <b>DOB : </b> #responseXML.bgc.product.USOneSearch.order.dob.month#/#responseXML.bgc.product.USOneSearch.order.dob.day#/#responseXML.bgc.product.USOneSearch.order.dob.year#</td></tr>						
			
			<cfset totalItems = #responseXML.bgc.product.USOneSearch.response.detail.offenders.XmlAttributes.qtyFound#>
			<tr><td>&nbsp; &nbsp; &nbsp; <b>Report ID : </b> #ReportID#</td><td>Number of items: #totalItems#<br></td></tr>
			<tr><td colspan="2"><hr width="100%" align="center"></td></tr>	
			
			<cfif totalItems NEQ 0>
				<!--- ITEMS - OFFENDER --->
				<cfloop from="1" to ="#totalItems#" index="t">
					<cfset totalOffenses = (ArrayLen(responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].offenses.XmlChildren))>
					<tr>
						<td><b>#responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].identity.personal.fullName#</b></td>
						<td>ID ##: #responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].record.key.offenderid#</td>
					</tr>
					<tr>
						<td>DOB: #responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].identity.personal.dob#</td>
						<td>GENDER: #responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].identity.personal.gender#</td>
					</tr>
					<tr><td colspan="2">Total of Offenses: #totalOffenses#<br></td></tr>
					<tr><td colspan="2"><hr width="100%" align="center"></td></tr>	
					<!--- OFFENSES --->
					<cfloop from="1" to ="#totalOffenses#" index="i">
						<tr><td colspan="2">
								<b>#responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].description#</b>
								(#responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].record.provider#, #responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].record.key.state#)
							</td>
						</tr>
						<tr><td colspan="2">&nbsp;</td></tr>
						<!--- Disposition --->
						<cfif responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].disposition.XmlText NEQ ''>
							<tr><td colspan="2">Disposition : <b>#responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].disposition#</b></td></tr>
						</cfif>
						<!--- Degree Of Offense --->
						<cfif responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].degreeOfOffense.XmlText NEQ ''>
							<tr><td colspan="2">Degree Of Offense : <b>#responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].degreeOfOffense#</b></td></tr>
						</cfif>
						<!--- Sentence --->
						<cfif responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].sentence.XmlText NEQ ''>
							<tr><td colspan="2">Sentence : <b>#responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].sentence#</b></td></tr>
						</cfif>
						<!--- Probation --->
						<cfif responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].probation.XmlText NEQ ''>
							<tr><td colspan="2">Probation : <b>#responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].probation#</b></td></tr>
						</cfif>
						<!--- Offense --->
						<cfif responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].confinement.XmlText NEQ ''>
							<tr><td colspan="2">Offense : <b>#responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].confinement#</b></td></tr>
						</cfif>
						<!--- Arresting Agency --->
						<cfif responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].arrestingAgency.XmlText NEQ ''>
							<tr><td colspan="2">Arresting Agency : <b>#responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].arrestingAgency#</b></td></tr>
						</cfif>
						<!--- Original Agency --->
						<cfif responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].originatingAgency.XmlText NEQ ''>
							<tr><td colspan="2">Original Agency : <b>#responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].originatingAgency#</b></td></tr>
						</cfif>
						<!--- Jurisdiction --->
						<cfif responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].jurisdiction.XmlText NEQ ''>
						<tr><td colspan="2">Jurisdiction : <b>#responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].jurisdiction#</b></td></tr>
						</cfif>
						<!--- Statute --->
						<cfif responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].statute.XmlText NEQ ''>
						<tr><td colspan="2">Statute : <b>#responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].statute#</b></td></tr>
						</cfif>
						<!--- Plea --->
						<cfif responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].plea.XmlText NEQ ''>
							<tr><td colspan="2">Plea : <b>#responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].plea#</b></td></tr>
						</cfif>
						<!--- Court Decision --->
						<cfif responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].courtDecision.XmlText NEQ ''>
							<tr><td colspan="2">Court Decision : <b>#responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].courtDecision#</b></td></tr>
						</cfif>
						<!--- Court Costs --->
						<cfif responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].courtCosts.XmlText NEQ ''>
							<tr><td colspan="2">Court Costs : <b>#responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].courtCosts#</b></td></tr>
						</cfif>
						<!--- Fine --->
						<cfif responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].fine.XmlText NEQ ''>
							<tr><td colspan="2">Fine : <b>#responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].fine#</b></td></tr>
						</cfif>
						<!--- Offense Date --->
						<cfif responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].offenseDate.XmlText NEQ ''>
						<tr><td colspan="2">Offense Date : <b>#responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].offenseDate#</b></td></tr>
						</cfif>
						<!--- Arrest Date --->
						<cfif responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].arrestDate.XmlText NEQ ''>
							<tr><td colspan="2">Arrest Date : <b>#responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].arrestDate#</b></td></tr>
						</cfif>
						<!--- Sentence Date --->
						<cfif responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].sentenceDate.XmlText NEQ ''>
							<tr><td colspan="2">Sentence Date : <b>#responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].sentenceDate#</b></td></tr>
						</cfif>
						<!--- Disposition Date --->
						<cfif responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].dispositionDate.XmlText NEQ ''>
							<tr><td colspan="2">Disposition Date : <b>#responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].dispositionDate#</b></td></tr>
						</cfif>
						<!--- File Date --->
						<cfif responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].fileDate.XmlText NEQ ''>
						<tr><td colspan="2">File Date : <b>#responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].fileDate#</b></td></tr>
						</cfif>
						<tr><td colspan="2">&nbsp;</td></tr>
						
						<!--- SPECIFIC INFORMATION --->				
						<tr><td colspan="2"><i>#responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].record.provider#, #responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].record.key.state# SPECIFIC INFORMATION</i></td></tr>
						<cfset totalSpecifics = (ArrayLen(responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].recorddetails.recorddetail.supplements.XmlChildren))>
						<tr>
						<cfloop from="1" to ="#totalSpecifics#" index="s">
							<td>&nbsp; &nbsp; &nbsp; #responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].recorddetails.recorddetail.supplements.supplement[s].displayTitle# : 
								<b> #responseXML.bgc.product.USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].recorddetails.recorddetail.supplements.supplement[s].displayValue# </b>
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
			<tr><td colspan="2">For more information please visit www.backgroundchecks.com</td></tr>	
			<tr><td colspan="2">
					***************<br>
					CONFIDENTIALITY NOTICE:<br>
					This is a transmission from Student Management Group and may contain information that is confidential and proprietary.
					If you are not the addressee, any disclosure, copying or distribution or use of the contents of this message is expressly prohibited.
					If you have received this transmission in error, please destroy it and notify us immediately at 1-631-893-4540.<br>
					Thank you.<br>
					***************
			</td>
		</tr>
		</table><br><br>
	</cfmail>
	
   <!--- <cffile action="write" file="d:\websites\nsmg\cbc\gis\#get_company.companyshort#\batch_#get_batchid.cbcid#_host_#get_cbc_users.userid#_rec.xml" output="#toString(responseXML)#">	--->

</cfoutput>
</body>
</html>

<!--- FILTERS 
					<filters>
							<SOF>
								<firstName>
									<filterType>FM</filterType>
								</firstName>
								<lastName>
									<filterType>FM</filterType>
								</lastName>
								<DOB>
										<yearRange>0</yearRange>
										<matchFuzzyDates>YES</matchFuzzyDates>
										<matchMissingDates>NO</matchMissingDates>
								</DOB>
							</SOF>
							<NSF>
								<firstName>
									<filterType>FM</filterType>
								</firstName>
								<lastName>
									<filterType>FM</filterType>
								</lastName>
								<DOB>
										<yearRange>0</yearRange>
										<matchFuzzyDates>YES</matchFuzzyDates>
										<matchMissingDates>NO</matchMissingDates>
								</DOB>
							</NSF>
							<GCF>
								<firstName>
									<filterType>FM</filterType>
								</firstName>
								<lastName>
									<filterType>FM</filterType>
								</lastName>
								<DOB>
										<yearRange>0</yearRange>
										<matchFuzzyDates>YES</matchFuzzyDates>
										<matchMissingDates>NO</matchMissingDates>
								</DOB>
							</GCF>
					</filters>						
--->