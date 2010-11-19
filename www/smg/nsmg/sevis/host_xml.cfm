<cfsetting requesttimeout="300">

<!-- get company info -->
<cfquery name="qGetCompany" datasource="MySQL">
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

<cfquery name="qGetStudents" datasource="MySql"> 
	SELECT 	
    	s.studentID, 
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
        h.fatherlastname, 
        h.motherlastname, 
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
	LEFT JOIN 
    	smg_hosts h ON s.hostid = h.hostid
	WHERE  
    	s.active = '1'
    AND 
    	s.host_fam_approved < '5'
    AND 
    	s.sevis_batchid != '0'
    AND 
    	s.sevis_activated != '0'
    <!--- Get only the last record. Student could relocate to a previous host family --->
    AND 
    	h.hostid NOT IN (SELECT hostid FROM smg_sevis_history WHERE studentid = s.studentID AND historyID = (SELECT max(historyID) FROM smg_sevis_history WHERE studentid = s.studentID) )
    AND 
        s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#form.programid#" list="yes"> )

	<cfif IsDefined('form.pre_ayp')>
    	AND 
        	(
            	s.aypenglish != '0' 
             OR
             	s.ayporientation != '0'
            )
    </cfif>

	<cfif CLIENT.companyID EQ 10>
    AND
        s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
    <cfelse>
    AND
        s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.listISE#" list="yes"> )
    </cfif>
    
	ORDER BY 
    	u.businessname, 
        s.familylastname, 
        s.firstname
        
	LIMIT 
    	250
</cfquery>

<cfif NOT VAL(qGetStudents.recordcount)>
Sorry, there were no students to populate the XML file at this time.
<cfabort>
</cfif>

<cfquery datasource="MySqL">
	INSERT INTO smg_sevis (companyid, createdby, datecreated, totalstudents, type)
	VALUES ('#qGetCompany.companyid#', '#client.userid#', #CreateODBCDateTime(now())#, '#qGetStudents.recordcount#', 'host_update')
</cfquery>

<!--- BATCH ID MUST BE UNIQUE --->
<cfquery name="qBatchID" datasource="MySql">
	SELECT MAX(batchid) as batchid
	FROM smg_sevis
</cfquery>

<cfset add_zeros = 13 - len(#qBatchID.batchid#) - len(#qGetCompany.companyshort_nocolor#)>
<!--- Batch id has to be numeric in nature A through Z a through z 0 through 9  --->

<table align="center" width="100%" frame="box">
<th colspan="2"><cfoutput>#qGetCompany.companyshort_nocolor# &nbsp; - &nbsp; Batch ID #qBatchID.batchid# &nbsp; - &nbsp; List of Students &nbsp; - &nbsp; Total of students in this batch: #qGetStudents.recordcount#</cfoutput></th>
<cfoutput query="qGetStudents">
<tr bgcolor="#iif(qGetStudents.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
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
	userID='#qGetCompany.sevis_userid#'>
	<BatchHeader>
		<BatchID>#qGetCompany.companyshort_nocolor#-<cfloop index = "ZeroCount" from = "1" to = #add_zeros#>0</cfloop>#qBatchID.batchid#</BatchID>
		<OrgID>#qGetCompany.iap_auth#</OrgID> 
	</BatchHeader>
	<UpdateEV>
	<cfloop query="qGetStudents">
		<ExchangeVisitor sevisID="#qGetStudents.ds2019_no#" requestID="#qGetStudents.studentID#" userID="#qGetCompany.sevis_userid#">
			<Biographical printForm="false">
				<USAddress>
				<cfif hostid is not '0' and  host_fam_approved LT '5'>
					<Address1><cfif hostlastname NEQ ''>#hostlastname#<cfelseif fatherlastname NEQ ''>#fatherlastname#<cfelseif motherlastname NEQ ''>#motherlastname#</cfif> Family</Address1> 	
					<Address2>#hostaddress#</Address2> 	<!--- <cfif hostaddress2 NEQ ''><Address2>#hostaddress2#</Address2></cfif> --->
					<City>#hostcity#</City> 
					<State>#hoststate#</State> 
					<PostalCode>#hostzip#</PostalCode>
			<cfelse><Address1>#qGetCompany.address#</Address1> 
					<City>#qGetCompany.city#</City> 
					<State>#qGetCompany.state#</State> 
					<PostalCode>#qGetCompany.zip#</PostalCode></cfif>
				</USAddress>
			</Biographical>
		</ExchangeVisitor>
		<cfsilent>
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
                ORDER BY 
                	historyid DESC
            </cfquery>
            <!--- Update hostID in history --->
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
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudents.hostid#">, 
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
</cfoutput>
</cfxml>

<cfoutput>

<cfscript>
	// Get Folder Path 
	currentDirectory = "#AppPath.sevis##qGetCompany.companyshort_nocolor#/host_family/";

	// Make sure the folder Exists
	AppCFC.UDF.createFolder(currentDirectory);
</cfscript>

<cffile action="write" file="#currentDirectory##qGetCompany.companyshort_nocolor#_host_0#qBatchID.batchid#.xml" output="#toString(sevis_batch)#">

<table align="center" width="100%" frame="box">
	<th>#qGetCompany.companyshort_nocolor# &nbsp; - &nbsp; Batch ID #qBatchID.batchid# &nbsp; - &nbsp; Total of students in this batch: #qGetStudents.recordcount#</th>
	<th>BATCH CREATED.</th>
</table>

</cfoutput>
