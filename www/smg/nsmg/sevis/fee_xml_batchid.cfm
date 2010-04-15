<cfsetting requestTimeOut = "500">

<cfif not IsDefined('form.batchid')>
	You must select at least one batch id. Please try again.
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


<!--- Query the database and get students --->
<cfquery name="qGetStudents" datasource="MySql">       
	SELECT 	
    	s.dateapplication, 
        s.active, 
        s.ds2019_no, 
        s.firstname, 
        s.familylastname, 
        s.dob, 
        s.middlename, 
        s.studentid,
        p.programname, 
        p.programid, 
        c.companyname, 
        c.usbank_iap_aut,
        u.accepts_sevis_fee, 
        u.businessname
	FROM 
    	smg_students s 
	INNER JOIN 
    	smg_programs p ON s.programid = p.programid
	INNER JOIN 
    	smg_companies c ON s.companyid = c.companyid
	INNER JOIN 
    	smg_users u ON s.intrep = u.userid
	WHERE	
    	u.accepts_sevis_fee = <cfqueryparam cfsqltype="cf_sql_varchar" value="1">
    AND 
    	s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
    AND 
    	s.sevis_bulkid = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
    AND 
    	s.ds2019_no LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="N%">
    AND 
    	(
        <cfloop list="#form.batchid#" index='batch'>
            s.sevis_batchid = #batch# 
       		<cfif batch is #ListLast(form.batchid)#><Cfelse>or</cfif>
    	</cfloop> 
       	)
	ORDER BY 
    	s.sevis_batchid DESC, 
        u.businessname DESC, 
        s.firstname DESC
        s,familyLastName DESC
	LIMIT 
    	2000
</cfquery>


<cfif NOT VAL(qGetStudents.recordcount)>
	Sorry, there were no students to populate the XML file at this time.
    <cfabort>
</cfif>


<cfquery name="insert_bulkid" datasource="MySqL">
	INSERT INTO 	
    	smg_sevisfee 
    (
    	companyid, 
        createdby, 
        datecreated, 
        totalstudents
    )
	VALUES
   	(
        <cfqueryparam cfsqltype="cf_sql_integer" value="#get_company.companyid#">,
        <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">,
        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#">,
        <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudents.recordcount#">
    )
</cfquery>

<!--- BATCH ID MUST BE UNIQUE --->
<cfquery name="get_bulkid" datasource="MySql">
	SELECT 
    	MAX(bulkid) as bulkid
	FROM 
    	smg_sevisfee
</cfquery>

<table align="center" width="100%" frame="box">
<tr><th colspan="2">PLEASE PRINT THIS PAGE FOR YOU REFERENCE.</th></tr>
<tr><th colspan="2"><cfoutput>#get_company.companyshort_nocolor# &nbsp; - &nbsp; SEVIS FEE BATCH #get_bulkid.bulkid# &nbsp; - &nbsp; List of Students &nbsp; - &nbsp; Total of students in this batch: #qGetStudents.recordcount#</cfoutput></th></tr>
<cfoutput query="qGetStudents">
<tr bgcolor="#iif(qGetStudents.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
	<td width="35%">#businessname#</td><td width="65%">#firstname# #familylastname# &nbsp; (#studentid#)</td>
</tr>
</cfoutput>
</table>
<br><br><br>

<cfset totalfee = qGetStudents.recordcount * 180.00>

<!--- Create an XML document object containing the data --->
<cfoutput>

<cfxml variable="transmission">
<transmission>
    <cfloop query="qGetStudents">
    <student>
        <sevisID>#ds2019_no#</sevisID>
        <firstName>#firstname#</firstName>
        <cfif LEN(middlename)><middleName>#middlename#</middleName></cfif>
        <lastName>#familylastname#</lastName>	
        <birthDate>#DateFormat(dob, 'yyyy-mm-dd')#</birthDate>
        <evProgramNumber>#usbank_iap_aut#</evProgramNumber>
        <evCategory>STUDENT</evCategory>
        <fee>#LSCurrencyFormat(180, "none")#</fee>
    </student>
    <cfquery name="upd_stu" datasource="MySql">
        UPDATE smg_students SET sevis_fee_paid_date = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(now())#">, sevis_bulkid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_bulkid.bulkid#">
        WHERE studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudents.studentid#">
    </cfquery>
	</cfloop>
	<controlRecord>
		<totalRecords>#qGetStudents.recordcount#</totalRecords>
		<totalFees>#totalfee#.00</totalFees>
	</controlRecord>
</transmission>
</cfxml>

<cfscript>
	// Get Folder Path 
	currentDirectory = "#AppPath.sevis##get_company.companyshort_nocolor#/fee/";

	// Make sure the folder Exists
	AppCFC.UDF.createFolder(currentDirectory);
</cfscript>

<cffile action="write" file="#currentDirectory##get_company.companyshort_nocolor#_fee_000#get_bulkid.bulkid#.xml" output="#toString(transmission)#" nameconflict="makeunique">

<table align="center" width="100%" frame="box">
	<th>#get_company.companyshort_nocolor# &nbsp; - &nbsp; Batch ID #get_bulkid.bulkid# &nbsp; - &nbsp; Total of students in this batch: #qGetStudents.recordcount#</th>
	<th>BATCH CREATED.</th>
</table>

</cfoutput>