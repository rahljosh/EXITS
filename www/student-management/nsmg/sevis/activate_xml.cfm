<!-- get company info -->
<cfquery name="get_company" datasource="MySQL">
    SELECT 
        companyID,
        companyName,
        companyshort,
        companyshort_nocolor,
        sevis_userid,
        iap_auth,
        team_id
    FROM 
        smg_companies
    WHERE 
        companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
</cfquery>


<cfquery name="qGetCandidates" datasource="MySql"> 
	select candidateid, firstname, lastname, middlename, ds2019, arrivaldate, startdate, enddate, dob, sex,
	birth_country, birth_city, citizen_country, residence_country, email, verification_received, ds2019_position, ds2019_subject, programRemarks
	from extra_candidates
	where candidateid = 22642
</cfquery>
<cfdump var="#qGetCandidates#">
<cfif qGetStudents.qGetCandidates is '0'>
Sorry, there were no candidates to populate the XML file at this time.
<cfabort>
</cfif>

<cfquery datasource="MySqL">
	INSERT INTO smg_sevis (companyid, createdby, datecreated, totalstudents, type)
	VALUES ('#get_company.companyid#', '#client.userid#', #CreateODBCDateTime(now())#, '#qGetCandidates.recordcount#', 'activate')
</cfquery>

<!--- BATCH ID MUST BE UNIQUE --->
<cfquery name="qBatchID" datasource="MySql">
	SELECT MAX(batchid) as batchid
	FROM smg_sevis
</cfquery>

<cfset add_zeros = 13 - len(#qBatchID.batchid#) - len(#get_company.companyshort_nocolor#)>
<!--- Batch id has to be numeric in nature A through Z a through z 0 through 9  --->

<table align="center" width="100%" frame="box">
<th colspan="2"><cfoutput>#get_company.companyshort_nocolor# &nbsp; - &nbsp; Batch ID #qBatchID.batchid# &nbsp; - &nbsp; List of Students &nbsp; - &nbsp; Total of students in this batch: #qGetStudents.recordcount#</cfoutput></th>
<cfoutput query="qGetStudents">
<tr bgcolor="#iif(qGetStudents.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
	<td width="35%">#businessname#</td><td width="65%">#firstname# #familylastname# (#studentid#)</td>
</tr>
</cfoutput>
</table>
<br><br><br>
<cfabort>
<cfoutput>

<!-- Create an XML document object containing the data -->
<cfxml variable="sevis_batch">
<SEVISBatchCreateUpdateEV 
	xmlns:common="http://www.ice.gov/xmlschema/sevisbatch/Common.xsd" 
	xmlns:table="http://www.ice.gov/xmlschema/sevisbatch/SEVISTable.xsd" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xsi:noNamespaceSchemaLocation="http://www.ice.gov/xmlschema/sevisbatch/Create-UpdateExchangeVisitor.xsd"
	userID='#get_company.sevis_userid#'>
	<BatchHeader>
		<BatchID>#get_company.companyshort_nocolor#-<cfloop index = "ZeroCount" from = "1" to = #add_zeros#>0</cfloop>#qBatchID.batchid#</BatchID>
		<OrgID>#get_company.iap_auth#</OrgID> 
	</BatchHeader>
	<UpdateEV>
	<cfloop query="qGetStudents">
		<ExchangeVisitor sevisID="#qGetStudents.ds2019_no#" requestID="#qGetStudents.studentid#" userID="#get_company.sevis_userid#">
			<Validate>
				<USAddress>
				<cfif hostid is not '0' and  host_fam_approved LT '5'>
					<Address1>#hostaddress#</Address1> 			
					<cfif hostaddress2 is not ''><Address2>#hostaddress2#</Address2></cfif>
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
		<cfsilent>
            <cfquery datasource="MySql">
            	UPDATE 
                	smg_students 
                SET 
                	sevis_activated = <cfqueryparam cfsqltype="cf_sql_integer" value="#qBatchID.batchid#"> 
                WHERE 
                	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudents.studentid#">
            </cfquery>
            <!--- CREATE NEW HISTORY --->
            <cfquery name="qGetHistory" datasource="MySql">
                SELECT 
                	studentID,
                    hostID,
                    school_name, 
                    start_date, 
                    end_date 
                FROM 
                	smg_sevis_history  
                WHERE 
                	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudents.studentid#">
                AND
                    isActive = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                ORDER BY 
                	historyid DESC
            </cfquery>
            <!--- Keep history the same --->
            <cfquery datasource="MySql">
                INSERT INTO 
                    smg_sevis_history 
                    (
                    	batchid, 
                        studentid, 
                        hostid, 
                        school_name, 
                        start_date,
                        end_date
                    )	
                VALUES 
                	(
                    	<cfqueryparam cfsqltype="cf_sql_integer" value="#qBatchID.batchid#">, 
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetHistory.studentid#">, 
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetHistory.hostid#">, 
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetHistory.school_name#">, 
						<cfif LEN(qGetHistory.start_date)>
                        	<cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(qGetHistory.start_date)#">,
						<cfelse>
                        	<cfqueryparam cfsqltype="cf_sql_date" null="yes">,
						</cfif>
						<cfif LEN(qGetHistory.end_date)>
                        	<cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(qGetHistory.end_date)#">
						<cfelse>
                        	<cfqueryparam cfsqltype="cf_sql_date" null="yes">
						</cfif>
                    )
            </cfquery>	
		</cfsilent>            
	</cfloop>
	</UpdateEV>
</SEVISBatchCreateUpdateEV>
</cfxml>

<cfscript>
	// Get Folder Path 
	currentDirectory = "#AppPath.sevis##get_company.companyshort_nocolor#/activate/";

	// Make sure the folder Exists
	AppCFC.UDF.createFolder(currentDirectory);
</cfscript>

<cffile action="write" file="#currentDirectory##get_company.companyshort_nocolor#_activate_00#qBatchID.batchid#.xml" output="#toString(sevis_batch)#">

<table align="center" width="100%" frame="box">
	<th>#get_company.companyshort_nocolor# &nbsp; - &nbsp; Batch ID #qBatchID.batchid# &nbsp; - &nbsp; Total of students in this batch: #qGetStudents.recordcount#</th>
	<th>BATCH CREATED.</th>
</table>

</cfoutput>
