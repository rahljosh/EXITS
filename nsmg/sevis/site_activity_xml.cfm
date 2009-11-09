<cfsetting requesttimeout="300">

<!-- get company info -->
<cfquery name="get_company" datasource="MySql">
	SELECT *
	FROM smg_companies
	WHERE companyid = '#client.companyid#'
</cfquery>

<cfquery name="get_students" datasource="MySql"> 
	SELECT 	s.studentid, s.dateapplication, s.ds2019_no, s.firstname, s.familylastname, s.ds2019_no,
			s.middlename, s.dob, s.sex,	s.hostid, s.schoolid, s.host_fam_approved,
			s.ayporientation, s.aypenglish,
			sc.schoolname, sc.address as schooladdress, sc.address2 as schooladdress2, sc.city as schoolcity,
			sc.state as schoolstate, sc.zip as schoolzip,
			p.startdate, p.enddate,
			u.businessname
	FROM smg_students s
	INNER JOIN smg_programs p ON s.programid = p.programid
	INNER JOIN smg_users u ON s.intrep = u.userid
	INNER JOIN smg_schools sc ON s.schoolid = sc.schoolid
	WHERE s.companyid = '#client.companyid#' 
			AND s.active = '1'
			AND s.host_fam_approved < '5'
			AND s.sevis_batchid != '0'
			AND s.sevis_activated != '0'
			AND sc.schoolname NOT IN (SELECT school_name FROM smg_sevis_history WHERE studentid = s.studentid)
			<cfif IsDefined('form.pre_ayp')>
			AND (s.aypenglish <> '0' or s.ayporientation <> '0')
			</cfif>
			AND (
			<cfloop list=#form.programid# index='prog'>
	 	    	s.programid = #prog# 
		   <cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
	   	   </cfloop> )
	ORDER BY u.businessname, s.familylastname, s.firstname
	LIMIT 250
</cfquery>

<cfif get_students.recordcount is '0'>
	Sorry, there were no students to populate the XML file at this time.
	<cfabort>
</cfif>

<cfquery name="insert_batchid" datasource="MySqL">
	INSERT INTO smg_sevis (companyid, createdby, datecreated, totalstudents, type)
	VALUES ('#get_company.companyid#', '#client.userid#', #CreateODBCDateTime(now())#, '#get_students.recordcount#', 'school_update')
</cfquery>

<!--- BATCH ID MUST BE UNIQUE --->
<cfquery name="get_batchid" datasource="MySql">
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


<!---- Create an XML document object containing the data ---->

<cfxml variable="sevis_batch">

<cfoutput>

<SEVISBatchCreateUpdateEV 
	xmlns:common="http://www.ice.gov/xmlschema/sevisbatch/alpha/Common.xsd" 
	xmlns:table="http://www.ice.gov/xmlschema/sevisbatch/alpha/SEVISTable.xsd" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xsi:noNamespaceSchemaLocation="http://www.ice.gov/xmlschema/sevisbatch/alpha/Create-UpdateExchangeVisitor.xsd"
	userID='#get_company.sevis_userid#'>
	<BatchHeader>
		<BatchID>#get_company.companyshort#-<cfloop index = "ZeroCount" from = "1" to = #add_zeros#>0</cfloop>#get_batchid.batchid#</BatchID>
		<OrgID>#get_company.iap_auth#</OrgID> 
	</BatchHeader>
	<UpdateEV>
	<cfloop query="get_students">
		<cfquery name="get_previous_info" datasource="MySql">
			SELECT historyid, school_name, hostid, start_date, end_date FROM smg_sevis_history  WHERE studentid = '#get_students.studentid#' ORDER BY historyid DESC
		</cfquery>
		<ExchangeVisitor sevisID="#get_students.ds2019_no#" requestID="#get_students.studentid#" userID="#get_company.sevis_userid#">
			<SiteOfActivity>
				<Edit printForm="false">
					<Address1>#schooladdress#</Address1> 
					<cfif schooladdress2 is not ''><Address2>#schooladdress2#</Address2></cfif>
					<City>#schoolcity#</City> 
					<State>#schoolstate#</State> 
					<PostalCode>#schoolzip#</PostalCode> 
					<SiteName>#get_previous_info.school_name#</SiteName>
					<NewSiteName>#schoolname#</NewSiteName>
					<PrimarySite>true</PrimarySite>
				</Edit>
			</SiteOfActivity>
		</ExchangeVisitor>
		<cfquery name="create_new_history" datasource="MySql">
			INSERT INTO smg_sevis_history (batchid, studentid, hostid, school_name, start_date, end_date)	
			VALUES ('#get_batchid.batchid#', '#get_students.studentid#', '#get_previous_info.hostid#', '#get_students.schoolname#', <cfif get_previous_info.start_date EQ ''>NULL<cfelse>#CreateODBCDate(get_previous_info.start_date)#</cfif>, <cfif get_previous_info.end_date EQ ''>NULL<cfelse>#CreateODBCDate(get_previous_info.end_date)#</cfif>)
		</cfquery>
	</cfloop>
	</UpdateEV>
</SEVISBatchCreateUpdateEV>
</cfoutput>

</cfxml>

<cfoutput>

<cffile action="write" file="/var/www/html/student-management/nsmg/sevis/xml/#get_company.companyshort#/school/#get_company.companyshort#_school_00#get_batchid.batchid#.xml" output="#toString(sevis_batch)#">

<table align="center" width="100%" frame="box">
	<th>#get_company.companyshort# &nbsp; - &nbsp; Batch ID #get_batchid.batchid# &nbsp; - &nbsp; Total of students in this batch: #get_students.recordcount#</th>
	<th>BATCH CREATED.</th>
</table>

</cfoutput>
