<cfparam name="FORM.start_date" default="">

<cfif NOT IsDate(FORM.start_date)>
	Please you must enter start and/or end date.
	<cfabort>
</cfif>

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


<cfquery name="get_students" datasource="MySql"> 
	SELECT 	
    	s.studentid, 
        s.dateapplication, 
        s.active, 
        s.ds2019_no, 
        s.firstname, 
        s.familylastname, 
        s.middlename, 
        s.dob, 
        s.sex,	
        s.citybirth, 
        s.hostid, 
        s.schoolid, 
        s.host_fam_approved,
        s.ayporientation, 
        s.aypenglish,
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
    	s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
    AND 
    	s.sevis_amend_dates = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
    AND 
    	s.ds2019_no LIKE 'N%'
    AND 
    	s.sevis_activated = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
    <!---
    AND
    	s.studentID NOT IN 
        (
        	SELECT
            	sh.studentID
            FROM
            	smg_sevis_history sh
            INNER JOIN
            	smg_sevis s ON s.batchID = sh.batchID
            WHERE
            	type = <cfqueryparam cfsqltype="cf_sql_varchar" value="activate">
        
        )
    --->
    AND 
    	s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programid#" list="yes"> )
               
    <cfif IsDefined('FORM.pre_ayp')>
    AND 
    	(
        	s.aypenglish != <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
        OR
        	s.ayporientation != <cfqueryparam cfsqltype="cf_sql_integer" value="0">
        )
    </cfif>

    <cfif IsDefined('FORM.non_pre_ayp')>
    AND 
    	s.aypenglish = <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
    AND 
    	s.ayporientation = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
    </cfif>

	<cfif CLIENT.companyID EQ 10>
    AND
    	s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
    <cfelse>
    AND
    	s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,12" list="yes"> )
    </cfif>

	ORDER BY 
    	u.businessname, 
        s.familylastname, 
        s.firstname
	LIMIT 250
</cfquery>

<cfif get_students.recordcount is '0'>
	Sorry, there were no students to populate the XML file at this time.
	<cfabort>
</cfif>

<cfquery name="insert_batchid" datasource="MySqL">
	INSERT INTO 
    	smg_sevis 
        (
        	companyid,
            createdby,
            datecreated, 
            totalstudents, 
            type
        )
	VALUES 
    	(
			'#get_company.companyid#', 
            '#client.userid#', 
            #CreateODBCDateTime(now())#, 
            '#get_students.recordcount#', 
            'amend'
       	)
</cfquery>

<!--- BATCH ID MUST BE UNIQUE --->
<cfquery name="get_batchid" datasource="MySql">
	SELECT MAX(batchid) as batchid
	FROM smg_sevis
</cfquery>

<cfset add_zeros = 13 - len(#get_batchid.batchid#) - len(#get_company.companyshort_nocolor#)>
<!--- Batch id has to be numeric in nature A through Z a through z 0 through 9  --->

<table align="center" width="100%" frame="box">
<th colspan="2"><cfoutput>#get_company.companyshort_nocolor# &nbsp; - &nbsp; Batch ID #get_batchid.batchid# &nbsp; - &nbsp; List of Students &nbsp; - &nbsp; Total of students in this batch: #get_students.recordcount#</cfoutput></th>
<cfoutput query="get_students">
<tr bgcolor="#iif(get_students.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
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
	userID='#get_company.sevis_userid#'>
	<BatchHeader>
		<BatchID>#get_company.companyshort_nocolor#-<cfloop index = "ZeroCount" from = "1" to = #add_zeros#>0</cfloop>#get_batchid.batchid#</BatchID>
		<OrgID>#get_company.iap_auth#</OrgID> 
	</BatchHeader>
	<UpdateEV>
	<cfloop query="get_students">
		    	<cfsilent>
            <cfquery datasource="MySql">
            	UPDATE 
                	smg_students 
                SET 
                	sevis_amend_dates = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_batchid.batchid#"> 
                WHERE 
                	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_students.studentid#">
            </cfquery>	
            <cfquery name="qGetPreviousInfo" datasource="MySql">
                SELECT 
                	hostid, 
                    school_name, 
                    start_date, 
                    end_date 
                FROM 
                	smg_sevis_history  
               	WHERE 
                	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_students.studentid#">
                ORDER BY
                	historyid DESC
            </cfquery>
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
                    	<cfqueryparam cfsqltype="cf_sql_integer" value="#get_batchid.batchid#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#get_students.studentid#">, 
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetPreviousInfo.hostid)#">, 
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetPreviousInfo.school_name#">, 
                        <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(FORM.start_date)#">, 
                        <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(qGetPreviousInfo.end_date)#">
					)
            </cfquery>
		</cfsilent>            
        <ExchangeVisitor sevisID="#get_students.ds2019_no#" requestID="#get_students.studentid#" userID="#get_company.sevis_userid#">
			<Program>
				<Amend printForm="false">
					<PrgStartDate>#DateFormat(FORM.start_date, 'yyyy-mm-dd')#</PrgStartDate>
					<PrgEndDate>#DateFormat(qGetPreviousInfo.end_date, 'yyyy-mm-dd')#</PrgEndDate>
				</Amend>
			</Program>
		</ExchangeVisitor>
	</cfloop>
	</UpdateEV>
</SEVISBatchCreateUpdateEV>
</cfxml>

<cfscript>
	// Get Folder Path 
	currentDirectory = "#AppPath.sevis##get_company.companyshort_nocolor#/amend/";

	// Make sure the folder Exists
	AppCFC.UDF.createFolder(currentDirectory);
</cfscript>

<cffile action="write" file="#currentDirectory##get_company.companyshort_nocolor#_amend_00#get_batchid.batchid#.xml" output="#toString(sevis_batch)#">

<table align="center" width="100%" frame="box">
	<th>#get_company.companyshort_nocolor# &nbsp; - &nbsp; Batch ID #get_batchid.batchid# &nbsp; - &nbsp; Total of students in this batch: #get_students.recordcount#</th>
	<th>BATCH CREATED.</th>
</table>

</cfoutput>
