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
            	f.flight_type IN ( <cfqueryparam cfsqltype="cf_sql_varchar" value="arrival,preAypArrival" list="yes"> )
            AND
            	f.dep_date < <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(form.arrival_date)#">
			AND
            	f.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">                
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
            s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISE#" list="yes"> )
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

<cfquery datasource="MySqL">
	INSERT INTO smg_sevis (companyid, createdby, datecreated, totalstudents, type)
	VALUES ('#qGetCompany.companyid#', '#client.userid#', #CreateODBCDateTime(now())#, '#qGetStudents.recordcount#', 'activate')
</cfquery>

<!--- BATCH ID MUST BE UNIQUE --->
<cfquery name="qBatchID" datasource="MySql">
	SELECT MAX(batchid) as batchid
	FROM smg_sevis
</cfquery> 

<cfset add_zeros = 13 - len(qBatchID.batchid) - len(qGetCompany.companyshort_nocolor)>
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

<cfoutput>

<!-- Create an XML document object containing the data -->
<cfxml variable="sevis_batch">
<SEVISBatchCreateUpdateEV 
	xmlns:common="http://www.ice.gov/xmlschema/sevisbatch/Common.xsd" 
	xmlns:table="http://www.ice.gov/xmlschema/sevisbatch/SEVISTable.xsd" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xsi:noNamespaceSchemaLocation="http://www.ice.gov/xmlschema/sevisbatch/Create-UpdateExchangeVisitor.xsd"
	userID='#qGetCompany.sevis_userid#'>
	<BatchHeader>
		<BatchID>#qGetCompany.companyshort_nocolor#-<cfloop index = "ZeroCount" from = "1" to = #add_zeros#>0</cfloop>#qBatchID.batchid#</BatchID>
		<OrgID>#qGetCompany.iap_auth#</OrgID> 
	</BatchHeader>
	<UpdateEV>
	<cfloop query="qGetStudents">
		<ExchangeVisitor sevisID="#qGetStudents.ds2019_no#" requestID="#qGetStudents.studentid#" userID="#qGetCompany.sevis_userid#">
			<Validate>
				<USAddress>
				<cfif VAL(qGetStudents.hostid) AND qGetStudents.host_fam_approved LT 5>
                	<cfset safeHostAddress = ReplaceNoCase(qGetStudents.hostAddress, "&", "and")>
					<Address1><cfif LEN(qGetStudents.hostlastname)>#qGetStudents.hostlastname#<cfelseif LEN(qGetStudents.fatherlastname)>#qGetStudents.fatherlastname#<cfelseif LEN(motherlastname)>#motherlastname#</cfif> Family</Address1> 	
					<Address2>#safeHostAddress#</Address2>
					<City>#qGetStudents.hostcity#</City> 
					<State>#qGetStudents.hoststate#</State> 
					<PostalCode>#qGetStudents.hostzip#</PostalCode>
				<cfelse>
					<Address1>#qGetCompany.address#</Address1> 
					<City>#qGetCompany.city#</City> 
					<State>#qGetCompany.state#</State> 
					<PostalCode>#qGetCompany.zip#</PostalCode>
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
	currentDirectory = "#AppPath.sevis##qGetCompany.companyshort_nocolor#/activate/";

	// Make sure the folder Exists
	AppCFC.UDF.createFolder(currentDirectory);
</cfscript>

<cffile action="write" file="#currentDirectory##qGetCompany.companyshort_nocolor#_activate_00#qBatchID.batchid#.xml" output="#toString(sevis_batch)#">

<table align="center" width="100%" frame="box">
	<th>#qGetCompany.companyshort_nocolor# &nbsp; - &nbsp; Batch ID #qBatchID.batchid# &nbsp; - &nbsp; Total of students in this batch: #qGetStudents.recordcount#</th>
	<th>BATCH CREATED.</th>
</table>

</cfoutput>
