<!-- get company info -->
<cfquery name="get_company" datasource="caseusa">
	SELECT *
	FROM smg_companies
	WHERE companyid = '#client.companyid#'
</cfquery>

<cfquery name="get_students" datasource="caseusa"> 
	SELECT 	s.studentid, s.ds2019_no, s.firstname, s.familylastname, s.middlename, s.dob, s.sex, s.citybirth, 
			s.ayporientation, s.aypenglish, s.hostid, s.schoolid, s.host_fam_approved, 
			birth.seviscode as birthseviscode,
			resident.seviscode as residentseviscode,
			citizen.seviscode as citizenseviscode,
			h.familylastname as hostlastname, h.fatherlastname, h.motherlastname, h.address as hostaddress, 
			h.address2 as hostaddress2, h.city as hostcity, 
			h.state as hoststate, h.zip as hostzip,
			sc.schoolname, sc.address as schooladdress, sc.address2 as schooladdress2, sc.city as schoolcity,
			sc.state as schoolstate, sc.zip as schoolzip,
			p.startdate, p.enddate, p.preayp_date, p.type as programtype,
			u.businessname
	FROM smg_students s 
	INNER JOIN smg_programs p ON s.programid = p.programid
	INNER JOIN smg_users u ON s.intrep = u.userid
	INNER JOIN smg_countrylist birth ON s.countrybirth = birth.countryid
	INNER JOIN smg_countrylist resident ON s.countryresident = resident.countryid
	INNER JOIN smg_countrylist citizen ON s.countrycitizen = citizen.countryid
	LEFT JOIN smg_hosts h ON s.hostid = h.hostid
	LEFT JOIN smg_schools sc ON s.schoolid = sc.schoolid
	WHERE 
	<!----
	s.studentid = 14379
	---->
	s.active = '1'
			AND s.ds2019_no = ''
			AND s.countrybirth != '232' AND s.countryresident != '232' AND s.countrycitizen != '232'
			AND s.verification_received IS NOT NULL
			AND s.sevis_batchid = '0'
			AND (
			<cfloop list=#form.programid# index='prog'>
	 	    	s.programid = #prog# 
		   <cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
	   	   </cfloop> ) 
		<!---- AND s.intrep = '11878'  and s.companyid = 4---->
	
	ORDER BY u.businessname, s.firstname
	LIMIT 250
</cfquery><!--- COUNTRY 232 = USA --->


<cfif get_students.recordcount is '0'>
	Sorry, there were no students to populate the XML file at this time.
	<cfabort>
</cfif>

<cfsetting requestTimeOut = "500">

<cfquery name="insert_batchid" datasource="caseusa">
	INSERT INTO smg_sevis (companyid, createdby, datecreated, totalstudents, type)
	VALUES (#get_company.companyid#, #client.userid#, #CreateODBCDateTime(now())#, #get_students.recordcount#, 'new')
</cfquery>
 
<!--- BATCH ID MUST BE UNIQUE --->
<cfquery name="get_batchid" datasource="caseusa">
	SELECT MAX(batchid) as batchid
	FROM smg_sevis
</cfquery>

<cfset add_zeros = 13 - len(#get_batchid.batchid#) - len(#get_company.companyshort#)>
<!--- Batch id has to be numeric in nature A through Z a through z 0 through 9  --->

<cfoutput>

<table align="center" width="100%" frame="box">
	<th colspan="2">#get_company.companyshort# &nbsp; - &nbsp; Batch ID #get_batchid.batchid# &nbsp; - &nbsp; List of Students &nbsp; - &nbsp; Total of students in this batch: #get_students.recordcount#</th>
	<cfloop query="get_students">
	<tr bgcolor="#iif(get_students.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
		<td width="35%">#businessname#</td><td width="65%">#firstname# #familylastname# (#studentid#)</td>
	</tr>
	</cfloop>
</table>
<br><br><br>
END OF DISPLAY

<!--- <BatchID>#get_company.iap_auth#_#add_zeros##get_batchid.batchid#</BatchID> --->
<!--- <BatchID>#get_company.companyshort#<cfloop index = "ZeroCount" from = "1" to = #qtd_zeros#>0</cfloop>#get_batchid.batchid#</BatchID>  --->

<!-- Create an XML document object containing the data -->

<cfxml variable="sevis_batch">

<SEVISBatchCreateUpdateEV 
	xmlns:common="http://www.ice.gov/xmlschema/sevisbatch/Common.xsd" 
	xmlns:table="http://www.ice.gov/xmlschema/sevisbatch/SEVISTable.xsd" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xsi:noNamespaceSchemaLocation="http://www.ice.gov/xmlschema/sevisbatch/Create-UpdateExchangeVisitor.xsd"
	userID='#get_company.sevis_userid#'>
<BatchHeader>
	<BatchID>#get_company.companyshort#-<cfloop index = "ZeroCount" from="1" to="#add_zeros#">0</cfloop>#get_batchid.batchid#</BatchID>
	<OrgID>#get_company.iap_auth#</OrgID> 
</BatchHeader>

<CreateEV>
<cfloop query="get_students">
<ExchangeVisitor requestID="#get_students.studentid#" printForm="true" userID="#get_company.sevis_userid#">
	<UserDefinedA>#get_students.studentid#</UserDefinedA>
	<Biographical>
		<FullName>
			<LastName>#familylastname#</LastName> 
			<FirstName>#firstname#</FirstName> 
			<cfif middlename is ''><cfelse><MiddleName>#middlename#</MiddleName></cfif>			
		</FullName>
		<BirthDate>#DateFormat(dob, 'yyyy-mm-dd')#</BirthDate> 
		<Gender><cfif sex is 'male'>M</cfif><cfif sex is 'female'>F</cfif></Gender> 
		<BirthCity>#citybirth#</BirthCity> 
		<BirthCountryCode>#birthseviscode#</BirthCountryCode> 
		<CitizenshipCountryCode>#citizenseviscode#</CitizenshipCountryCode> 
		<PermanentResidenceCountryCode>#residentseviscode#</PermanentResidenceCountryCode> 		
	</Biographical>
	<PositionCode>223</PositionCode> 
	<PrgStartDate>
	<cfif DateFormat(now(), 'mm/dd/yyyy') GT DateFormat(startdate, 'mm/dd/yyyy')> #DateFormat(now()+1, 'yyyy-mm-dd')#<cfset nstart_date = #DateFormat(now()+1, 'yyyy-mm-dd')#><cfelse><cfif DateDiff('yyyy', dob, startdate) LT 15>#dateformat (now(), 'yyyy')#-#dateformat (dob, 'mm-dd')#
			<cfset nstart_date = '#dateformat (now(), 'yyyy')#-#dateformat (dob, 'mm-dd')#'><cfelseif ayporientation NEQ '0' OR aypenglish NEQ '0'>
			#dateformat (preayp_date, 'yyyy-mm-dd')#
			<cfset nstart_date = #dateformat (preayp_date, 'yyyy-mm-dd')#>
			
		<cfelse>
			#DateFormat(startdate, 'yyyy-mm-dd')#
			<cfset nstart_date = #DateFormat(startdate, 'yyyy-mm-dd')#>
			
		</cfif>
	</cfif>
	
	</PrgStartDate>  
	<PrgEndDate><cfif programtype EQ '3'>2009-06-30<cfelse>#DateFormat(enddate, 'yyyy-mm-dd')#</cfif></PrgEndDate><!--- type = 3 first semester --->
	<CategoryCode>1A</CategoryCode>
	<SubjectField>
		<SubjectFieldCode>53.0299</SubjectFieldCode> 
		<Remarks>none</Remarks> 
	</SubjectField>
	<USAddress>
	<cfif hostid NEQ '0' and  host_fam_approved LT '5'>
		<Address1><cfif hostlastname NEQ ''>#hostlastname#<cfelseif fatherlastname NEQ ''>#fatherlastname#<cfelseif motherlastname NEQ ''>#motherlastname#</cfif> Family</Address1> 	
		<Address2>#hostaddress#</Address2> 					
		<!--- <cfif hostaddress2 NEQ ''><Address2>#hostaddress2#</Address2></cfif> --->
		<City>#hostcity#</City> 
		<State>#hoststate#</State> 
		<PostalCode>#hostzip#</PostalCode>
	<cfelse>
		<Address1>#get_company.address#</Address1> 
		<City>#get_company.city#</City> 
		<State>#get_company.state#</State> 
		<PostalCode>#get_company.zip#</PostalCode></cfif>
	</USAddress>
	<FinancialInfo>
		<ReceivedUSGovtFunds>false</ReceivedUSGovtFunds> 
		<OtherFunds>
			<Personal>3000</Personal> 
		</OtherFunds>
	</FinancialInfo>
	<AddSiteOfActivity>
		<SiteOfActivity>
	<cfif schoolid NEQ '0' and host_fam_approved LT '5'>
			<Address1>#schooladdress#</Address1> 
			<cfif schooladdress2 NEQ ''><Address2>#schooladdress2#</Address2></cfif>
			<City>#schoolcity#</City> 
			<State>#schoolstate#</State> 
			<PostalCode>#schoolzip#</PostalCode> 
			<SiteName>#schoolname#</SiteName>
			<PrimarySite>true</PrimarySite>
	<cfelse><Address1>#get_company.address#</Address1> 
			<cfif schooladdress2 NEQ ''><Address2>#schooladdress2#</Address2></cfif>
			<City>#get_company.city#</City> 
			<State>#get_company.state#</State> 
			<PostalCode>#get_company.zip#</PostalCode> 
			<SiteName>#get_company.companyname#</SiteName>
			<PrimarySite>true</PrimarySite></cfif>
	   </SiteOfActivity>
	</AddSiteOfActivity>
	</ExchangeVisitor>
	<cfquery name="upd_stu" datasource="caseusa">
		UPDATE smg_students SET sevis_batchid = #get_batchid.batchid# WHERE studentid = #get_students.studentid#
	</cfquery><cfquery name="insert_history" datasource="caseusa">
		INSERT INTO smg_sevis_history (studentid, batchid, hostid, school_name, start_date, end_date)
		VALUES (#studentid#,#get_batchid.batchid#,#hostid#, <cfif schoolid NEQ '0' and host_fam_approved LT '5'>'#schoolname#'<cfelse>'#get_company.companyname#'</cfif>, #CreateODBCDate(nstart_date)#, <cfif programtype EQ '3'>'2009-06-30'<cfelse>#CreateODBCDate(enddate)#</cfif>)
	</cfquery>
	</cfloop>
</CreateEV>
</SEVISBatchCreateUpdateEV>  

</cfxml>

<!-- dump the resulting XML document object -->

<cffile action="write" file="/var/www/html/student-management/nsmg/sevis/xml/#get_company.companyshort#/new_forms/#get_company.companyshort#_new_00#get_batchid.batchid#.xml" output="#toString(sevis_batch)#">

<table align="center" width="100%" frame="box">
	<th>#get_company.companyshort# &nbsp; - &nbsp; Batch ID #get_batchid.batchid# &nbsp; - &nbsp; Total of students in this batch: #get_students.recordcount#</th>
	<th>BATCH CREATED.</th>
</table>

</cfoutput>

<!--- <cfdump var="#get_students#">----->

<!--- <cffile action="write" file="/var/www/html/student-management/nsmg/sevis/xml/sevis_batch_#Dateformat(now(), 'mm-dd-yyyy')#_#TimeFormat(now(), 'hh-mm-ss-tt')#.xml" output="#toString(sevis_batch)#"> --->
<!--- You can view the schemas at: 
http://www.ice.gov/xmlschema/sevisbatch/alpha/Common.xsd 
http://www.ice.gov/xmlschema/sevisbatch/alpha/Create-UpdateExchangeVisitor.xsd 
http://www.ice.gov/xmlschema/sevisbatch/alpha/Create-UpdateStudent.xsd 
http://www.ice.gov/xmlschema/sevisbatch/alpha/SEVISTable.xsd 
http://www.ice.gov/xmlschema/sevisbatch/alpha/SevisTransLog.xsd  --->