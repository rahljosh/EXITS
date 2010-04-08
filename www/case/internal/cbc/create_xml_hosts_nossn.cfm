<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'
'http://www.w3.org/TR/html4/loose.dtd'>
<html>
<head>
<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>
<title>CBC Host Family and Members</title>
</head>

<body>

<cfsetting requestTimeOut = "500">

<cfoutput>

<!--- GIS - WEBSITE - PRODUCTION --->
<cfset BGCDirectURL = "https://direct.backgroundchecks.com/integration/bgcdirectpost.aspx">

<!--- GIS - TEST - PRODUCTION --->
<!--- <cfset BGCDirectURL = "https://model.backgroundchecks.com/integration/bgcdirectpost.aspx"> --->

<cfif form.usertype EQ '0' OR form.seasonid EQ '0'>
	You must select a usertype or a season in order to run the batch. Please go back and try again.
	<cfabort>
</cfif>

<cfquery name="get_company" datasource="caseusa">
	SELECT companyid, companyshort, gis_account, gis_username, gis_password
	FROM smg_companies
	WHERE companyid = <cfqueryparam value="#client.companyid#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- HOSTS PARENTS --->
<cfif form.usertype NEQ 'member'>
	<cfquery name="get_cbc_hosts" datasource="caseusa">
		SELECT DISTINCT cbc.cbcfamid, cbc.hostid, cbc.cbc_type, cbc.date_authorized, cbc.date_sent, cbc.date_received,
			h.familylastname, h.fatherlastname, h.fatherfirstname, h.fathermiddlename, fatherdob, fatherssn,
			h.motherlastname, h.motherfirstname, h.mothermiddlename, motherdob, motherssn
		FROM smg_hosts_cbc cbc
		INNER JOIN smg_hosts h ON h.hostid = cbc.hostid
		WHERE cbc.date_sent IS NULL 
			AND requestid = ''
			AND cbc.companyid = <cfqueryparam value="#client.companyid#" cfsqltype="cf_sql_integer">
			AND cbc.seasonid =  <cfqueryparam value="#form.seasonid#" cfsqltype="cf_sql_integer">
		 	AND cbc.cbc_type = '#form.usertype#'
			<cfif form.usertype EQ 'father'>
				AND fatherssn = ''
			<cfelseif form.usertype EQ 'mother'>
				AND motherssn = ''
			</cfif>
		LIMIT 20
	</cfquery>

	<!--- NO CBC FOUND ---> 
	<cfif get_cbc_hosts.recordcount EQ '0'>
		Sorry, there were no users to populate the XML file at this time.
		<cfabort>
	</cfif>
	
	<cfset missing = '0'>
	
	<cfloop	query="get_cbc_hosts">
		<cfif #Evaluate(usertype & "firstname")# EQ ''>
				First Name is missing for user #Evaluate(usertype & "firstname")# #Evaluate(usertype & "lastname")# (###hostid#). <br>
				<cfset missing = missing + 1>
		<cfelseif #Evaluate(usertype & "lastname")# EQ ''>
				Last Name is missing for user #Evaluate(usertype & "firstname")# #Evaluate(usertype & "lastname")# (###hostid#). <br>
				<cfset missing = missing + 1>
		<cfelseif #Evaluate(usertype & "dob")# EQ ''>
				DOB is missing for rep #Evaluate(usertype & "firstname")# #Evaluate(usertype & "lastname")# (###hostid#). <br>
				<cfset missing = missing + 1>
		</cfif>
	</cfloop>

	<cfif missing GT '0'>
		<br>There are #missing# item(s). In order to continue please enter the information missing.
		<cfabort>
	</cfif>

	<table width="670" align="center" cellpadding="0" cellspacing="0">
		<th bgcolor="##CCCCCC">GIS - Criminal Background Check</th>
		<tr><td>Connecting to #BGCDirectURL#...</td></tr>
	</table><br>

	<!--- BATCH ID MUST BE UNIQUE --->
	<cfquery name="insert_batchid" datasource="caseusa">
		INSERT INTO smg_users_cbc_batch  (companyid, createdby, datecreated, total, type)
		VALUES ('#get_company.companyid#', '#client.userid#', #CreateODBCDateTime(now())#, '#get_cbc_hosts.recordcount#', 'host')
	</cfquery>
	<cfquery name="get_batchid" datasource="caseusa">
		SELECT MAX(cbcid) as cbcid
		FROM smg_users_cbc_batch
	</cfquery>

	<cfloop query='get_cbc_hosts'> 
	
	<!--- 
		TEST - https://model.backgroundchecks.com/integration/bgcdirectpost.aspx
		<user>smg1</user>
		<password>R3d3x##</password>
		<account>10005542</account>
	--->

	<cfxml variable='requestXML'>
	<BGC>
		<login>
			<user>#get_company.gis_username#</user>
			<password>#get_company.gis_password#</password>
			<account>#get_company.gis_account#</account>
		</login>
		<product>
			<USOneSearch version='1'>
				<order>
					<lastName>#Evaluate(usertype & "lastname")#</lastName>				
					<firstName>#Evaluate(usertype & "firstname")#</firstName>
					<middleName>#Left(Evaluate(usertype & "middlename"),1)#</middleName>
					<DOB>
						<year>#DateFormat(Evaluate(usertype & "dob"), 'yyyy')#</year>
						<month>#DateFormat(Evaluate(usertype & "dob"), 'mm')#</month>
						<day>#DateFormat(Evaluate(usertype & "dob"), 'dd')#</day>
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
	<table width="670" align="center" cellpadding="0" cellspacing="0">
		<tr><td>Submitting CBC for #get_company.companyshort# HF #usertype# - #Evaluate(usertype & "firstname")# #Evaluate(usertype & "lastname")# (###hostid#)</td></tr>
		<cftry>
			<cfhttp url="#BGCDirectURL#" method="POST" throwonerror="yes">
				<cfhttpparam type="XML" value="#requestXML#" />
				<cfhttpparam type="Header" name="charset" value="utf-8" />
			</cfhttp>
			
			<cfcatch type="any">
				<b>Error</b><br>
				Error Detail: #cfhttp.errorDetail#<br>
				Message: #cfcatch.message#<br>
				Detail: #cfcatch.detail#<br>
				Error Code: #cfcatch.errorcode#
				<cfabort>
			</cfcatch>
		</cftry>
		<tr><td><b>Success!</b></td></tr>
	</table><br>


helo
	<cffile action="write" file="/var/www/html/case/internal/uploadedfiles/xml_files/gis/#get_company.companyshort#/batch_#get_batchid.cbcid#_host_#form.usertype#_#hostid#_sent.xml" output="#toString(requestXML)#" mode="777">

	<cfset responseXML = ''>
   	<cfset responseXML = XmlParse(cfhttp.filecontent)>
   	
	<cffile action="write" file="/var/www/html/case/internal/uploadedfiles/xml_files/gis/#get_company.companyshort#/batch_#get_batchid.cbcid#_host_#form.usertype#_#hostid#_rec.xml" output="#toString(responseXML)#" mode="777">

	<table width="670" align="center" cellpadding="0" cellspacing="0">
		<tr><td>XML FILE <a href="../uploadedfiles/xml_files/gis/#get_company.companyshort#/batch_#get_batchid.cbcid#_host_#form.usertype#_#hostid#_sent.xml" target="_blank">Sent</a></td></tr>
		<tr><td>XML FILE <a href="../uploadedfiles/xml_files/gis/#get_company.companyshort#/batch_#get_batchid.cbcid#_host_#form.usertype#_#hostid#_rec.xml" target="_blank">Received</a></td></tr>
	</table><br>
	
	<!--- GET REPORT ID --->
	<cfif responseXML.bgc.product.USOneSearch.response.detail.offenders.XmlAttributes.qtyFound NEQ 0>
		<cfset ReportID = '#responseXML.bgc.product.USOneSearch.response.detail.offenders.offender.record.key.secureKey.XmlText#'>
	<cfelse>
		<cfset ReportID = '#responseXML.bgc.XmlAttributes.orderId#'>
	</cfif>	
	
	<cfmail from="support@case-usa.org" to="cbcresults@case-usa.org" subject="GIS Search for #get_company.companyshort# HF #usertype# - #Evaluate(usertype & "firstname")# #Evaluate(usertype & "lastname")# (###hostid#)" failto="support@case-usa.org" type="html">
		<table width="670" align="center">
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr bgcolor="##CCCCCC"><th colspan="2">* Search Results for : #get_company.companyshort# HF #usertype# - #Evaluate(usertype & "firstname")# #Evaluate(usertype & "lastname")# (###hostid#) *</th></tr>
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
	
	<cfquery name="update_cbc" datasource="caseusa">
		UPDATE smg_hosts_cbc  
		SET date_sent = #CreateODBCDate(now())#,
				date_received = #CreateODBCDate(now())#,
				batchid = '#get_batchid.cbcid#',
				Requestid = '#ReportID#'
		WHERE cbcfamid = <cfqueryparam value="#cbcfamid#" cfsqltype="cf_sql_integer">
	</cfquery>
	
</cfloop>

<!--- HOST MEMBERS --->  <!--- HOST MEMBERS --->  <!--- HOST MEMBERS --->
<cfelse>

	<cfquery name="get_cbc_members" datasource="caseusa">
		SELECT DISTINCT cbc.cbcfamid, cbc.hostid, cbc.cbc_type, cbc.date_authorized, cbc.date_sent, cbc.date_received,
		child.childid, child.name, child.middlename, child.lastname, child.birthdate, child.ssn, child.hostid
		FROM smg_hosts_cbc cbc
		INNER JOIN smg_host_children child ON child.childid = cbc.familyid
		WHERE cbc.date_sent IS NULL 
			AND requestid = ''
			AND cbc.companyid = <cfqueryparam value="#client.companyid#" cfsqltype="cf_sql_integer">
			AND cbc.seasonid =  <cfqueryparam value="#form.seasonid#" cfsqltype="cf_sql_integer">
			AND cbc.cbc_type = '#form.usertype#'
			AND ssn = ''
		LIMIT 20
	</cfquery>
	
	<cfif get_cbc_members.recordcount EQ '0'>
		Sorry, there were no host members to populate the XML file at this time.
		<cfabort>
	</cfif>
	
	<cfset missing = '0'>
	
	<cfloop query="get_cbc_members">
		<cfif name EQ ''>
				First Name is missing for host member #name# #lastname# member of (###hostid#). <br>
				<cfset missing = missing + 1>
		<cfelseif lastname EQ ''>
				Last Name is missing for host member #name# #lastname# member of (###hostid#). <br>
				<cfset missing = missing + 1>
		<cfelseif birthdate EQ ''>
				DOB is missing for host member #name# #lastname# member of (###hostid#). <br>
				<cfset missing = missing + 1>
		</cfif>
	</cfloop>
	
	<cfif missing GT '0'>
		<br>There are #missing# item(s). In order to continue please enter the information missing.
		<cfabort>
	</cfif>
	
	<!--- BATCH ID MUST BE UNIQUE --->
	<cfquery name="insert_batchid" datasource="caseusa">
		INSERT INTO smg_users_cbc_batch  (companyid, createdby, datecreated, total, type)
		VALUES ('#get_company.companyid#', '#client.userid#', #CreateODBCDateTime(now())#, '#get_cbc_members.recordcount#', 'host')
	</cfquery>
	<cfquery name="get_batchid" datasource="caseusa">
		SELECT MAX(cbcid) as cbcid
		FROM smg_users_cbc_batch
	</cfquery>

	<table width="670" align="center" cellpadding="0" cellspacing="0">
		<th bgcolor="##CCCCCC">GIS - Criminal Background Check</th>
		<tr><td>Connecting to #BGCDirectURL#...</td></tr>
	</table><br>

	<cfloop query='get_cbc_members'> 
	
	<cfxml variable='requestXML'>
	<BGC>
		<login>
			<user>#get_company.gis_username#</user>
			<password>#get_company.gis_password#</password>
			<account>#get_company.gis_account#</account>
		</login>
		<product>
			<USOneSearch version='1'>
				<order>
					<lastName>#lastname#</lastName>				
					<firstName>#name#</firstName>
					<middleName>#middlename#</middleName>
					<DOB>
						<year>#DateFormat(birthdate, 'yyyy')#</year>
						<month>#DateFormat(birthdate, 'mm')#</month>
						<day>#DateFormat(birthdate, 'dd')#</day>
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
	<table width="670" align="center" cellpadding="0" cellspacing="0">
		<tr><td>Submitting CBC for #get_company.companyshort# HF #usertype# - #name# #lastname# (###hostid#)</td></tr>
		<cftry>
			<cfhttp url="#BGCDirectURL#" method="POST" throwonerror="yes">
				<cfhttpparam type="XML" value="#requestXML#" />
				<cfhttpparam type="Header" name="charset" value="utf-8" />
			</cfhttp>
			
			<cfcatch type="any">
				<b>Error</b><br>
				Error Detail: #cfhttp.errorDetail#<br>
				Message: #cfcatch.message#<br>
				Detail: #cfcatch.detail#<br>
				Error Code: #cfcatch.errorcode#
				<cfabort>
			</cfcatch>
		</cftry>
		<tr><td><b>Success!</b></td></tr>
	</table><br>

	<cffile action="write" file="/var/www/html/case/internal/uploadedfiles/xml_files/gis/#get_company.companyshort#/batch_#get_batchid.cbcid#_host_#form.usertype#_#hostid#_sent.xml"  output="#toString(requestXML)#">

	<cfset responseXML = ''>
   	<cfset responseXML = XmlParse(cfhttp.filecontent)>
	
	<cffile action="write" file="/var/www/html/case/internal/uploadedfiles/xml_files/gis/#get_company.companyshort#/batch_#get_batchid.cbcid#_host_#form.usertype#_#hostid#_rec.xml" output="#toString(responseXML)#">	
	
	<table width="670" align="center" cellpadding="0" cellspacing="0">
		<tr><td>XML FILE <a href="../uploadedfiles/xml_files/gis/#get_company.companyshort#/batch_#get_batchid.cbcid#_host_#form.usertype#_#hostid#_sent.xml" target="_blank">Sent</a></td></tr>
		<tr><td>XML FILE <a href="../uploadedfiles/xml_files/gis/#get_company.companyshort#/batch_#get_batchid.cbcid#_host_#form.usertype#_#hostid#_rec.xml" target="_blank">Received</a></td></tr>
	</table><br><br>	
	
	<!--- GET REPORT ID --->
	<cfif responseXML.bgc.product.USOneSearch.response.detail.offenders.XmlAttributes.qtyFound NEQ 0>
		<cfset ReportID = '#responseXML.bgc.product.USOneSearch.response.detail.offenders.offender.record.key.secureKey.XmlText#'>
	<cfelse>
		<cfset ReportID = '#responseXML.bgc.XmlAttributes.orderId#'>
	</cfif>
	
	<cfmail from="support@case-usa.org" to="stacy@case-usa.org" subject="GIS Search for #get_company.companyshort# HF #usertype# - #name# #lastname# (###hostid#)" failto="support@case-usa.org" type="html">
		<table width="670" align="center">
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr bgcolor="##CCCCCC"><th colspan="2">* Search Results for : #get_company.companyshort# HF #usertype# - #name# #lastname# (###hostid#) *</th></tr>
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
					This is a transmission from CASE and may contain information that is confidential and proprietary.
					If you are not the addressee, any disclosure, copying or distribution or use of the contents of this message is expressly prohibited.
					If you have received this transmission in error, please destroy it and notify us immediately at 1-201-773-8299.<br>
					Thank you.<br>
					***************
			</td>
		</tr>
		</table><br><br>
	</cfmail>

	<cfquery name="update_cbc" datasource="caseusa">
		UPDATE smg_hosts_cbc  
		SET date_sent = #CreateODBCDate(now())#,
				date_received = #CreateODBCDate(now())#,
				batchid = '#get_batchid.cbcid#',
				Requestid = '#ReportID#'
		WHERE cbcfamid = <cfqueryparam value="#cbcfamid#" cfsqltype="cf_sql_integer">
	</cfquery>

	</cfloop>

</cfif>

</cfoutput>
</body>
</html>