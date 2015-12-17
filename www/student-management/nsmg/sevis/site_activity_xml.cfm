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

<cfquery name="qGetStudents" datasource="MySQL"> 
	SELECT 	
    	s.studentid, 
        s.dateapplication, 
        s.firstname, 
        s.familylastname, 
        s.ds2019_no, 
        s.companyID,
        s.middlename, 
        s.dob, 
        s.sex,	
        s.hostid, 
        s.schoolid, 
        s.host_fam_approved,
        s.ayporientation, 
        s.aypenglish,
        sc.schoolname, 
        sc.address as schooladdress, 
        sc.address2 as schooladdress2, 
        sc.city as schoolcity,
        sc.state as schoolstate, 
        sc.zip as schoolzip,
        p.startdate, 
        p.enddate,
        u.businessname
	FROM 
    	smg_students s
	INNER JOIN 
    	smg_programs p ON s.programid = p.programid
	INNER JOIN 
    	smg_users u ON s.intrep = u.userid
	INNER JOIN 
    	smg_schools sc ON s.schoolid = sc.schoolid
	WHERE  
    	s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">    
    AND 
    	s.host_fam_approved < <cfqueryparam cfsqltype="cf_sql_integer" value="5"> 
    <!--- Get Only Students with a valid DS-2019 Number --->
    AND
    	s.ds2019_no LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="N%">
                    
    <!--- Get only active records --->
    AND 
    	s.sevis_activated != <cfqueryparam cfsqltype="cf_sql_integer" value="0">        
        
	<!--- Get only the last record. Student could relocate to a previous school --->
    AND 
    	sc.schoolname NOT IN (SELECT school_name FROM smg_sevis_history WHERE studentid = s.studentid AND historyID = (SELECT max(historyID) FROM smg_sevis_history WHERE studentid = s.studentID AND isActive = <cfqueryparam cfsqltype="cf_sql_bit" value="1">) )
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
            s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISE#" list="yes"> )
    </cfif>
   
	ORDER BY 	    
    	u.businessname, 
        s.familylastname, 
        s.firstname
	LIMIT 
    	250
</cfquery>

<cfif qGetStudents.recordcount is '0'>
	Sorry, there were no students to populate the XML file at this time.
	<cfabort>
</cfif>

<cfquery datasource="MySQL">
	INSERT INTO smg_sevis (companyid, createdby, datecreated, totalstudents, type)
	VALUES ('#qGetCompany.companyid#', '#client.userid#', #CreateODBCDateTime(now())#, '#qGetStudents.recordcount#', 'school_update')
</cfquery>

<!--- BATCH ID MUST BE UNIQUE --->
<cfquery name="qBatchID" datasource="MySQL">
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


<!---- Create an XML document object containing the data ---->

<cfxml variable="sevis_batch">

<cfoutput>

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
				AND 
                	isActive = <cfqueryparam cfsqltype="cf_sql_bit" value="1">                    
                ORDER BY 
                	historyid DESC
            </cfquery>
            
            <cfset safeAddress1 = ReplaceNoCase(qGetStudents.schooladdress, "&", "and")>
            <cfset safeAddress2 = ReplaceNoCase(qGetStudents.schooladdress2, "&", "and")>
        </cfsilent>
        <ExchangeVisitor sevisID="#qGetStudents.ds2019_no#" requestID="#qGetStudents.studentid#" userID="#qGetCompany.sevis_userid#">
			<SiteOfActivity xsi:type="SOA">
				<Edit printForm="false">
					<Address1>#safeAddress1#</Address1> 
					<cfif NOT LEN(safeAddress2)><Address2>#safeAddress2#</Address2></cfif>
					<City>#schoolcity#</City> 
					<State>#schoolstate#</State> 
					<PostalCode>#schoolzip#</PostalCode> 
                    <ExplanationCode>OO</ExplanationCode>
                	<Explanation>Verified with host family.</Explanation>
					<SiteName>#qGetHistory.school_name#</SiteName>
					<NewSiteName>#schoolname#</NewSiteName>
					<PrimarySite>true</PrimarySite>
				</Edit>
			</SiteOfActivity>
		</ExchangeVisitor>
		<cfsilent>
            <!--- Update school name in history --->
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
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetStudents.schoolName#">, 
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
	currentDirectory = "#AppPath.sevis##qGetCompany.companyshort_nocolor#/school/";

	// Make sure the folder Exists
	AppCFC.UDF.createFolder(currentDirectory);
</cfscript>

<cffile action="write" file="#currentDirectory##qGetCompany.companyshort_nocolor#_school_00#qBatchID.batchid#.xml" output="#toString(sevis_batch)#">

<table align="center" width="100%" frame="box">
	<th>#qGetCompany.companyshort_nocolor# &nbsp; - &nbsp; Batch ID #qBatchID.batchid# &nbsp; - &nbsp; Total of students in this batch: #qGetStudents.recordcount#</th>
	<th>BATCH CREATED.</th>
</table>

</cfoutput>
