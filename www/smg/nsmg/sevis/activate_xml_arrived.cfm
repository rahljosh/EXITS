<!-- get company info -->
<cfquery name="get_company" datasource="MySql">
SELECT *
FROM smg_companies
WHERE companyid = '#client.companyid#'
</cfquery>

<cfquery name="get_students" datasource="MySql"> 
	SELECT 	DISTINCT s.studentid, s.dateapplication, s.active, s.ds2019_no, s.firstname, s.familylastname, s.companyID, 
			s.middlename, s.dob, s.sex,	s.citybirth, s.hostid, s.schoolid, s.host_fam_approved,
			s.ayporientation, s.aypenglish,
			h.familylastname as hostlastname, h.fatherlastname, h.motherlastname, h.address as hostaddress, 
			h.address2 as hostaddress2, h.city as hostcity,
			h.state as hoststate, h.zip as hostzip,
			u.businessname
	FROM smg_students s
	INNER JOIN smg_programs p ON s.programid = p.programid
	INNER JOIN smg_users u ON s.intrep = u.userid
	INNER JOIN smg_flight_info f ON s.studentid = f.studentid
	LEFT JOIN smg_hosts h ON s.hostid = h.hostid
	WHERE s.active = '1'
			AND s.sevis_batchid != '0'
			AND s.sevis_activated = '0'
			<cfif IsDefined('form.pre_ayp')>
			AND (s.aypenglish <> '0' or s.ayporientation <> '0')
			</cfif>
			AND f.flight_type = 'arrival'
			AND f.dep_date < #CreateODBCDate(form.arrival_date)#
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
	VALUES ('#get_company.companyid#', '#client.userid#', #CreateODBCDateTime(now())#, '#get_students.recordcount#', 'activate')
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

<!-- Create an XML document object containing the data -->
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
		<ExchangeVisitor sevisID="#get_students.ds2019_no#" requestID="#get_students.studentid#" userID="#get_company.sevis_userid#">
			<Validate>
				<USAddress>
				<cfif hostid NEQ '0' and  host_fam_approved LT '5'>
					<Address1><cfif hostlastname NEQ ''>#hostlastname#<cfelseif fatherlastname NEQ ''>#fatherlastname#<cfelseif motherlastname NEQ ''>#motherlastname#</cfif> Family</Address1> 	
					<Address2>#hostaddress#</Address2> 	<!--- <cfif hostaddress2 NEQ ''><Address2>#hostaddress2#</Address2></cfif> --->
					<City>#hostcity#</City> 
					<State>#hoststate#</State> 
					<PostalCode>#hostzip#</PostalCode>
				<cfelse>
					<Address1>#get_company.address#</Address1> 
					<City>#get_company.city#</City> 
					<State>#get_company.state#</State> 
					<PostalCode>#get_company.zip#</PostalCode>
				</cfif>
				</USAddress>
			</Validate>
		</ExchangeVisitor>
		<cfquery name="upd_stu" datasource="MySql">UPDATE smg_students SET sevis_activated = '#get_batchid.batchid#' WHERE studentid = '#get_students.studentid#' LIMIT 1</cfquery>
		<!--- CREATE NEW HISTORY --->
		<cfquery name="get_previous_info" datasource="MySql">
			SELECT school_name, start_date, end_date FROM smg_sevis_history  WHERE studentid = '#get_students.studentid#' ORDER BY historyid DESC
		</cfquery>
		<cfquery name="create_new_history" datasource="MySql">
			INSERT INTO smg_sevis_history (batchid, studentid, hostid, school_name, start_date, end_date)	
			VALUES ('#get_batchid.batchid#', '#get_students.studentid#', '#get_students.hostid#', '#get_previous_info.school_name#', <cfif get_previous_info.start_date EQ ''>NULL<cfelse>#CreateODBCDate(get_previous_info.start_date)#</cfif>, <cfif get_previous_info.end_date EQ ''>NULL<cfelse>#CreateODBCDate(get_previous_info.end_date)#</cfif>)
		</cfquery>		
	</cfloop>
	</UpdateEV>
</SEVISBatchCreateUpdateEV>
</cfoutput>
</cfxml>

<!-- dump the resulting XML document object -->
<!--- <cfdump var="#sevis_batch#"> --->
<cfoutput>
<cffile action="write" file="/var/www/html/student-management/nsmg/sevis/xml/#get_company.companyshort#/activate/#get_company.companyshort#_activate_00#get_batchid.batchid#.xml" output="#toString(sevis_batch)#">

<table align="center" width="100%" frame="box">
	<th>#get_company.companyshort# &nbsp; - &nbsp; Batch ID #get_batchid.batchid# &nbsp; - &nbsp; Total of students in this batch: #get_students.recordcount#</th>
	<th>BATCH CREATED.</th>
</table>
</cfoutput>