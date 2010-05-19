<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>End Program</title>
</head>

<body>

<!-- get company info -->
<cfquery name="get_company" datasource="caseusa">
	SELECT *
	FROM smg_companies
	WHERE companyid = '#client.companyid#'
</cfquery>

<cfif NOT IsDefined('form.programid') OR form.type EQ '0'>
	You must select at least one program and a type in order to continue.
	<cfabort>
</cfif>

<!--- END PROGRAM ACCORDING TO TERMINATION DATE --->
<cfif form.type EQ 'termination'>
	<cfquery name="get_students" datasource="caseusa"> 
		SELECT DISTINCT s.studentid, s.ds2019_no, s.termination_date, s.firstname, s.familylastname, 
				u.businessname
		FROM smg_students s
		INNER JOIN smg_programs p ON s.programid = p.programid
		INNER JOIN smg_users u ON s.intrep = u.userid
		WHERE s.active = '1'
				AND s.ds2019_no LIKE 'N%'
				AND s.sevis_end_program = '0'
				AND s.termination_date IS NOT NULL
				AND s.termination_date < #CreateODBCDate(now())#
				AND (
				<cfloop list=#form.programid# index='prog'>
					s.programid = #prog# 
			   <cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			   </cfloop> )
		ORDER BY u.businessname, s.firstname
		LIMIT 250
	</cfquery>
<!--- END PROGRAM ACCORDING TO FLIGHT INFORMATION --->
<cfelse>
	<cfquery name="get_students" datasource="caseusa"> 
		SELECT DISTINCT	s.studentid, s.ds2019_no, s.firstname, s.familylastname,
				u.businessname
		FROM smg_students s
		INNER JOIN smg_programs p ON s.programid = p.programid
		INNER JOIN smg_users u ON s.intrep = u.userid
		INNER JOIN smg_flight_info f on s.studentid = f.studentid
		WHERE s.active = '1'
				AND s.ds2019_no LIKE 'N%'
				AND s.sevis_end_program = '0'
				AND f.flight_type = 'departure'
				AND f.dep_date < #CreateODBCDate(now())# 
				AND f.dep_date IS NOT NULL
				AND (
				<cfloop list=#form.programid# index='prog'>
					s.programid = #prog# 
			   <cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			   </cfloop> )
		ORDER BY u.businessname, s.firstname
		LIMIT 250
	</cfquery>
</cfif>

<cfif get_students.recordcount EQ '0'>
	Sorry, there were no students to populate the XML file at this time.
	<cfabort>
</cfif>

<cfsetting requestTimeOut = "500">

<cfquery name="insert_batchid" datasource="caseusa">
	INSERT INTO smg_sevis (companyid, createdby, datecreated, totalstudents, type)
	VALUES ('#get_company.companyid#', '#client.userid#', #CreateODBCDateTime(now())#, '#get_students.recordcount#', 'end')
</cfquery>
 
<!--- BATCH ID MUST BE UNIQUE --->
<cfquery name="get_batchid" datasource="caseusa">
	SELECT MAX(batchid) as batchid
	FROM smg_sevis
</cfquery>

<cfset add_zeros = 13 - len(#get_batchid.batchid#) - len(#get_company.companyshort#)>
<!--- Batch id has to be numeric in nature A through Z a through z 0 through 9  --->

<table align="center" width="100%" frame="box">
<th colspan="2"><cfoutput>#get_company.companyshort# &nbsp; - &nbsp; Batch ID #get_batchid.batchid# &nbsp; - &nbsp; List of Students &nbsp; - &nbsp; Total of students in this batch: #get_students.recordcount#</cfoutput></th>
<cfoutput query="get_students">
<tr bgcolor="#iif(get_students.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
	<td width="35%">#businessname#</td><td width="65%">#firstname# #familylastname# (#studentid#)</td>
</tr>
</cfoutput>
</table>
<br><br><br>

<!--- <BatchID>#get_company.iap_auth#_#add_zeros##get_batchid.batchid#</BatchID> --->
<!--- <BatchID>#get_company.companyshort#<cfloop index = "ZeroCount" from = "1" to = #qtd_zeros#>0</cfloop>#get_batchid.batchid#</BatchID>  --->

<!-- Create an XML document object containing the data -->
<cfxml variable="sevis_batch">
<cfoutput>
<SEVISBatchCreateUpdateEV 
	xmlns:common="http://www.ice.gov/xmlschema/sevisbatch/Common.xsd" 
	xmlns:table="http://www.ice.gov/xmlschema/sevisbatch/SEVISTable.xsd" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xsi:noNamespaceSchemaLocation="http://www.ice.gov/xmlschema/sevisbatch/Create-UpdateExchangeVisitor.xsd"
	userID='#get_company.sevis_userid#'>
<BatchHeader>
	<BatchID>#get_company.companyshort#-<cfloop index = "ZeroCount" from = "1" to = #add_zeros#>0</cfloop>#get_batchid.batchid#</BatchID>
	<OrgID>#get_company.iap_auth#</OrgID> 
</BatchHeader>

<UpdateEV>
<cfloop query="get_students">
	<ExchangeVisitor requestID="#get_students.studentid#" sevisID="#get_students.ds2019_no#" userID="#get_company.sevis_userid#">
		<UserDefinedA>#get_students.studentid#</UserDefinedA>
		<Status>
			<End>
				<Reason>COMP</Reason>
				<EffectiveDate>#DateFormat(now(), 'yyyy-mm-dd')#</EffectiveDate>
			</End>
		</Status>
	</ExchangeVisitor>
	<cfquery name="upd_stu" datasource="caseusa">
		UPDATE smg_students SET sevis_end_program = '#get_batchid.batchid#' WHERE studentid = '#get_students.studentid#'
	</cfquery>
	</cfloop>
</UpdateEV>
</SEVISBatchCreateUpdateEV>  
</cfoutput>
</cfxml>

<!-- dump the resulting XML document object -->
<cfdump var="#sevis_batch#">
<cfoutput>
<cffile action="write" file="/var/www/html/student-management/nsmg/sevis/xml/#get_company.companyshort#/#get_company.companyshort#_end_prog_00#get_batchid.batchid#.xml" output="#toString(sevis_batch)#">
</cfoutput>

</body>
</html>