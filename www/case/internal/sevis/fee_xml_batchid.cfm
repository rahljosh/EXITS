<cfsetting requestTimeOut = "500">

<cfif not IsDefined('form.batchid')>
	You must select at least one batch id. Please try again.
	<cfabort>
</cfif>

<!-- get company info -->
<cfquery name="get_company" datasource="caseusa">
	SELECT *
	FROM smg_companies
	WHERE companyid = '#client.companyid#'
</cfquery>

<!--- Query the database and get students --->
<cfquery name="get_students" datasource="caseusa"> 
	SELECT 	s.dateapplication, s.active, s.ds2019_no, s.firstname, s.familylastname, s.dob, s.middlename, s.studentid,
			p.programname, p.programid, 
			c.companyname, c.usbank_iap_aut,
			u.accepts_sevis_fee, u.businessname
	FROM smg_students s 
	INNER JOIN smg_programs p ON s.programid = p.programid
	INNER JOIN smg_companies c ON s.companyid = c.companyid
	INNER JOIN smg_users u ON s.intrep = u.userid
	WHERE	u.accepts_sevis_fee = '1'
			AND s.active = '1'
			AND s.sevis_bulkid = '0'
			AND s.ds2019_no LIKE 'N%'
			AND (
			<cfloop list="#form.batchid#" index='batch'>
	 	    	s.sevis_batchid = #batch# 
		   <cfif batch is #ListLast(form.batchid)#><Cfelse>or</cfif>
	   </cfloop> )
	ORDER BY s.sevis_batchid DESC, u.businessname DESC, s.firstname DESC
	LIMIT 2000
</cfquery>

<cfif get_students.recordcount is '0'>
	Sorry, there were no students to populate the XML file at this time.
<cfabort>
</cfif>

<cfquery name="insert_bulkid" datasource="caseusa">
	INSERT INTO smg_sevisfee (companyid, createdby, datecreated, totalstudents)
	VALUES ('#get_company.companyid#', '#client.userid#', #CreateODBCDateTime(now())#, '#get_students.recordcount#')
</cfquery>

<!--- BATCH ID MUST BE UNIQUE --->
<cfquery name="get_bulkid" datasource="caseusa">
	SELECT MAX(bulkid) as bulkid
	FROM smg_sevisfee
</cfquery>

<table align="center" width="100%" frame="box">
<tr><th colspan="2">PLEASE PRINT THIS PAGE FOR YOU REFERENCE.</th></tr>
<tr><th colspan="2"><cfoutput>#get_company.companyshort# &nbsp; - &nbsp; SEVIS FEE BATCH #get_bulkid.bulkid# &nbsp; - &nbsp; List of Students &nbsp; - &nbsp; Total of students in this batch: #get_students.recordcount#</cfoutput></th></tr>
<cfoutput query="get_students">
<tr bgcolor="#iif(get_students.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
	<td width="35%">#businessname#</td><td width="65%">#firstname# #familylastname# &nbsp; (#studentid#)</td>
</tr>
</cfoutput>
</table>
<br><br><br>

<cfset totalfee = #get_students.recordcount# * 180.00>

<!--- Create an XML document object containing the data --->
<cfxml variable="transmission">
<transmission>
    <cfloop query="get_students">
	<student>
	    <cfoutput>
		<sevisID>#ds2019_no#</sevisID>
		<firstName>#firstname#</firstName>
		<cfif middlename is not ''>
		<middleName>#middlename#</middleName>	
		</cfif>
		<lastName>#familylastname#</lastName>	
		<birthDate>#DateFormat(dob, 'yyyy-mm-dd')#</birthDate>
		<evProgramNumber>#usbank_iap_aut#</evProgramNumber>
		<evCategory>STUDENT</evCategory>
		<fee>#LSCurrencyFormat(180, "none")#</fee>
		</cfoutput>
	</student>
	<cfquery name="upd_stu" datasource="caseusa">
		UPDATE smg_students SET sevis_fee_paid_date = #CreateODBCDate(now())#, sevis_bulkid = '#get_bulkid.bulkid#' 
		WHERE studentid = '#get_students.studentid#'
	</cfquery>
	</cfloop>
	<controlRecord>
		<cfoutput>
		<totalRecords>#get_students.recordcount#</totalRecords>
		<totalFees>#totalfee#.00</totalFees>
		</cfoutput>
	</controlRecord>
</transmission>
</cfxml>

<cfoutput>								
<cffile action="write" file="/var/www/html/student-management/nsmg/sevis/xml/#get_company.companyshort#/fee/#get_company.companyshort#_fee_000#get_bulkid.bulkid#.xml" output=#toString(transmission)# nameconflict="makeunique">
</cfoutput>

<table align="center" width="100%" frame="box">
<tr><th>XML CREATED</th></tr>
</table>

<!--- dump the resulting XML document object --->
<!--- <cfdump var=#transmission#> --->