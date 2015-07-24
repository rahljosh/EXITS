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
    	c.candidateid, 
     	c.watDateCheckedIn,
        c.ds2019, 
        c.firstname, 
        c.lastname, 
      	c.arrival_address,
        c.arrival_address_2,
        c.other_arrival_address_information,
        c.arrival_city,
        c.arrival_state,
        c.arrival_zip,
        c.intrep,
      	u.businessname,
        s.state
	FROM 
    	extra_candidates c
	INNER JOIN 
    	smg_programs p ON c.programid = p.programid
	INNER JOIN 
    	smg_users u ON c.intrep = u.userid
    INNER JOIN 
    	smg_states s ON s.id = c.arrival_state
	WHERE 
    	
    	c.sevis_activated = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
    AND 
    	c.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#form.programid#" list="yes"> )
	AND 
    	c.ds2019 != <cfqueryparam cfsqltype="cf_sql_varchar" value="">
    AND 
    	c.sevis_arrival_updated != <cfqueryparam cfsqltype="cf_sql_varchar" value="manual">
	
	AND
    	c.watDateCheckedIn = <cfqueryparam cfsqltype="cf_sql_date" value="#form.watDateCheckedIn#" list="yes">
    AND
        c.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
 
    
	ORDER BY 
    	
        c.lastname, 
        c.firstname
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
	<td width="35%">#businessname#</td><td width="65%">#firstname# #lastname# (#candidateid#)</td>
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
		<ExchangeVisitor sevisID="#qGetStudents.ds2019#" requestID="#qGetStudents.candidateid#" userID="#qGetCompany.sevis_userid#">
			<Validate>
				<USAddress>
				
			
					<Address1>#arrival_address#</Address1> 
                    <cfif len(#other_arrival_address_information#)>
                    	<Address2>#other_arrival_address_information#</Address2> 
                    </cfif>
                   <cfif len(#other_arrival_address_information#)>
                    	<Address2>#other_arrival_address_information#</Address2> 
                    </cfif>
					<City>#arrival_city#</City> 
					<State>#state#</State> 
					<PostalCode>#arrival_zip#</PostalCode>
				
				</USAddress>
			</Validate>
		</ExchangeVisitor>
		<cfsilent>
            <cfquery datasource="MySql">
            	UPDATE 
                	extra_candidates
                SET 
                	sevis_activated = <cfqueryparam cfsqltype="cf_sql_integer" value="#qBatchID.batchid#"> 
                WHERE 
                	candidateid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudents.candidateid#">
            </cfquery>
            <!--- CREATE NEW HISTORY --->
           	<!----
            <cfquery name="qGetHistory" datasource="MySql">
                SELECT 
                	candidateid,
                    start_date,
                    end_date 
                FROM 
                	smg_sevis_history  
                WHERE 
                	candidateid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudents.candidateid#">
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
			---->
		</cfsilent>            
	</cfloop>
	</UpdateEV>
</SEVISBatchCreateUpdateEV>
</cfxml>

<cfscript>
	// Get Folder Path 
	currentDirectory = "#APPLICATION.PATH.sevis##qGetCompany.companyshort_nocolor#/activate/";

	// Make sure the folder Exists
	//AppCFC.UDF.createFolder(currentDirectory);
</cfscript>

<cffile action="write" file="#currentDirectory##qGetCompany.companyshort_nocolor#_activate_00#qBatchID.batchid#.xml" output="#toString(sevis_batch)#">

<table align="center" width="100%" frame="box">
	<th>#qGetCompany.companyshort_nocolor# &nbsp; - &nbsp; Batch ID #qBatchID.batchid# &nbsp; - &nbsp; Total of students in this batch: #qGetStudents.recordcount#</th>
	<th>BATCH CREATED.</th>
</table>

</cfoutput>
