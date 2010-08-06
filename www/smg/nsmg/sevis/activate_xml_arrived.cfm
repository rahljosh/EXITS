<!-- get company info -->
<cfquery name="qGetCompany" datasource="MySQL">
    SELECT 
        companyID,
        companyName,
        companyshort,
        companyshort_nocolor,
        sevis_userid,
        iap_auth,
        team_id,
        address,
        city,
        state,
        zip
    FROM 
        smg_companies
    WHERE 
        companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
</cfquery>


<cfquery name="qGetStudents" datasource="MySql"> 
	SELECT DISTINCT 
    	s.studentid, 
        s.dateapplication, 
        s.active,
        s.ds2019_no, 
        s.firstname, 
        s.familylastname, 
        s.companyID, 
        s.middlename, 
        s.dob, 
        s.sex,	
        s.citybirth, 
        s.hostid, 
        s.schoolid, 
        s.host_fam_approved,
        s.ayporientation,
        s.aypenglish,
        h.familylastname as hostlastname,
        h.fatherlastname, h.motherlastname,
        h.address as hostaddress, 
        h.address2 as hostaddress2, 
        h.city as hostcity,
        h.state as hoststate, 
        h.zip as hostzip,
        u.businessname
	FROM 
    	smg_students s
	INNER JOIN 
    	smg_programs p ON s.programid = p.programid
	INNER JOIN 
    	smg_users u ON s.intrep = u.userid
	INNER JOIN 
    	smg_flight_info f ON s.studentid = f.studentid 
        	AND 
            	f.flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="arrival">
            AND
            	f.dep_date < <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(form.arrival_date)#">
	LEFT JOIN 
    	smg_hosts h ON s.hostid = h.hostid
	WHERE 
    	s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
    AND 
    	s.sevis_activated = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
    AND 
    	s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#form.programid#" list="yes"> )
	AND 
    	s.ds2019_no != <cfqueryparam cfsqltype="cf_sql_varchar" value="">
    	
	<cfif IsDefined('form.pre_ayp')>
	    AND 
        	(
        		s.aypenglish != <cfqueryparam cfsqltype="cf_sql_integer" value="0">
            OR 
            	s.ayporientation != <cfqueryparam cfsqltype="cf_sql_integer" value="0">
            )
    </cfif>

	<cfif CLIENT.companyID EQ 10>
    AND
    	s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
    <cfelse>
    AND
    	s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,5,12" list="yes"> )
    </cfif>
    
	ORDER BY 
    	u.businessname, 
        s.familylastname, 
        s.firstname
	LIMIT 250
</cfquery>

<cfif NOT VAL(qGetStudents.recordcount)>
Sorry, there were no students to populate the XML file at this time.
<cfabort>
</cfif>

<cfquery name="insert_batchid" datasource="MySqL">
	INSERT INTO smg_sevis (companyid, createdby, datecreated, totalstudents, type)
	VALUES ('#qGetCompany.companyid#', '#client.userid#', #CreateODBCDateTime(now())#, '#qGetStudents.recordcount#', 'activate')
</cfquery>

<!--- BATCH ID MUST BE UNIQUE --->
<cfquery name="get_batchid" datasource="MySql">
	SELECT MAX(batchid) as batchid
	FROM smg_sevis
</cfquery> 

<cfset add_zeros = 13 - len(#get_batchid.batchid#) - len(#qGetCompany.companyshort_nocolor#)>
<!--- Batch id has to be numeric in nature A through Z a through z 0 through 9  --->

<table align="center" width="100%" frame="box">
<th colspan="2"><cfoutput>#qGetCompany.companyshort_nocolor# &nbsp; - &nbsp; Batch ID #get_batchid.batchid# &nbsp; - &nbsp; List of Students &nbsp; - &nbsp; Total of students in this batch: #qGetStudents.recordcount#</cfoutput></th>
<cfoutput query="qGetStudents">
<tr bgcolor="#iif(qGetStudents.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
	<td width="35%">#businessname#</td><td width="65%">#firstname# #familylastname# (#studentid#)</td>
</tr>
</cfoutput>
</table>
<br><br><br>

<cfoutput>

<!-- Create an XML document object containing the data -->
<cfxml variable="sevis_batch">
<SEVISBatchCreateUpdateEV 
	xmlns:common="http://www.ice.gov/xmlschema/sevisbatch/alpha/Common.xsd" 
	xmlns:table="http://www.ice.gov/xmlschema/sevisbatch/alpha/SEVISTable.xsd" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xsi:noNamespaceSchemaLocation="http://www.ice.gov/xmlschema/sevisbatch/alpha/Create-UpdateExchangeVisitor.xsd"
	userID='#qGetCompany.sevis_userid#'>
	<BatchHeader>
		<BatchID>#qGetCompany.companyshort_nocolor#-<cfloop index = "ZeroCount" from = "1" to = #add_zeros#>0</cfloop>#get_batchid.batchid#</BatchID>
		<OrgID>#qGetCompany.iap_auth#</OrgID> 
	</BatchHeader>
	<UpdateEV>
	<cfloop query="qGetStudents">
		<ExchangeVisitor sevisID="#qGetStudents.ds2019_no#" requestID="#qGetStudents.studentid#" userID="#qGetCompany.sevis_userid#">
			<Validate>
				<USAddress>
				<cfif hostid NEQ '0' and  host_fam_approved LT '5'>
					<Address1><cfif hostlastname NEQ ''>#hostlastname#<cfelseif fatherlastname NEQ ''>#fatherlastname#<cfelseif motherlastname NEQ ''>#motherlastname#</cfif> Family</Address1> 	
					<Address2>#hostaddress#</Address2> 	<!--- <cfif hostaddress2 NEQ ''><Address2>#hostaddress2#</Address2></cfif> --->
					<City>#hostcity#</City> 
					<State>#hoststate#</State> 
					<PostalCode>#hostzip#</PostalCode>
				<cfelse>
					<Address1>#qGetCompany.address#</Address1> 
					<City>#qGetCompany.city#</City> 
					<State>#qGetCompany.state#</State> 
					<PostalCode>#qGetCompany.zip#</PostalCode>
				</cfif>
				</USAddress>
			</Validate>
		</ExchangeVisitor>
		<cfquery name="upd_stu" datasource="MySql">UPDATE smg_students SET sevis_activated = '#get_batchid.batchid#' WHERE studentid = '#qGetStudents.studentid#' LIMIT 1</cfquery>
		<!--- CREATE NEW HISTORY --->
		<cfquery name="get_previous_info" datasource="MySql">
			SELECT school_name, start_date, end_date FROM smg_sevis_history  WHERE studentid = '#qGetStudents.studentid#' ORDER BY historyid DESC
		</cfquery>
		<cfquery name="create_new_history" datasource="MySql">
			INSERT INTO smg_sevis_history (batchid, studentid, hostid, school_name, start_date, end_date)	
			VALUES ('#get_batchid.batchid#', '#qGetStudents.studentid#', '#qGetStudents.hostid#', '#get_previous_info.school_name#', <cfif get_previous_info.start_date EQ ''>NULL<cfelse>#CreateODBCDate(get_previous_info.start_date)#</cfif>, <cfif get_previous_info.end_date EQ ''>NULL<cfelse>#CreateODBCDate(get_previous_info.end_date)#</cfif>)
		</cfquery>		
	</cfloop>
	</UpdateEV>
</SEVISBatchCreateUpdateEV>
</cfxml>

<cfscript>
	// Get Folder Path 
	currentDirectory = "#AppPath.sevis##qGetCompany.companyshort_nocolor#/activate/";

	// Make sure the folder Exists
	AppCFC.UDF.createFolder(currentDirectory);
</cfscript>

<cffile action="write" file="#currentDirectory##qGetCompany.companyshort_nocolor#_activate_00#get_batchid.batchid#.xml" output="#toString(sevis_batch)#">

<table align="center" width="100%" frame="box">
	<th>#qGetCompany.companyshort_nocolor# &nbsp; - &nbsp; Batch ID #get_batchid.batchid# &nbsp; - &nbsp; Total of students in this batch: #qGetStudents.recordcount#</th>
	<th>BATCH CREATED.</th>
</table>

</cfoutput>
