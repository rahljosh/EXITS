<!--- Kill Extra Output --->
<cfsilent>

	<cfsetting requestTimeOut = "500">

	<!--- Param Form Variables --->
    <cfparam name="FORM.programID" default="">
    <cfparam name="FORM.intRep" default="">
    
    <!-- get company info -->
    <cfquery name="qGetCompany" datasource="MySQL">
        SELECT 
            *
        FROM 
            smg_companies
        WHERE 
            companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
    </cfquery>
    
    <cfquery name="qGetStudents" datasource="MySql"> 
        SELECT 	
            s.studentid, 
            s.ds2019_no, 
            s.firstname, 
            s.familylastname, 
            s.middlename, 
            s.dob, 
            s.sex, 
            s.citybirth, 
            s.companyID,
            s.ayporientation, 
            s.aypenglish, 
            s.hostid, 
            s.schoolid, 
            s.host_fam_approved, 
            birth.seviscode as birthseviscode,
            resident.seviscode as residentseviscode,
            citizen.seviscode as citizenseviscode,
            h.familylastname as hostlastname, 
            h.fatherlastname, 
            h.motherlastname, 
            h.address as hostaddress, 
            h.address2 as hostaddress2, 
            h.city as hostcity, 
            h.state as hoststate, 
            h.zip as hostzip,
            sc.schoolname, 
            sc.address as schooladdress, 
            sc.address2 as schooladdress2, 
            sc.city as schoolcity,
            sc.state as schoolstate, 
            sc.zip as schoolzip,
            p.sevis_startdate, 
            p.sevis_enddate, 
            p.preayp_date, 
            p.type as programtype,
            u.businessname
        FROM 
            smg_students s 
        INNER JOIN 
            smg_programs p ON s.programid = p.programid
        INNER JOIN 
            smg_users u ON s.intrep = u.userid
        INNER JOIN 
            smg_countrylist birth ON s.countrybirth = birth.countryid
        INNER JOIN 
            smg_countrylist resident ON s.countryresident = resident.countryid
        INNER JOIN 
            smg_countrylist citizen ON s.countrycitizen = citizen.countryid
        LEFT JOIN 
            smg_hosts h ON s.hostid = h.hostid
        LEFT JOIN 
            smg_schools sc ON s.schoolid = sc.schoolid
        WHERE 
            s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND 
            s.ds2019_no = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
        <!--- US or Canada --->
        AND 
            s.countrybirth NOT IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="32,232" list="yes"> )
        AND 
            s.countryresident NOT IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="32,232" list="yes"> )
        AND 
            s.countrycitizen NOT IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="32,232" list="yes"> )
        AND 
            s.verification_received IS NOT NULL
        AND 
            s.sevis_batchid = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
        AND 
            s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programid#" list="yes"> )
		
		<cfif VAL(FORM.intRep)>
        AND
            s.intRep = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.intRep#">
       	</cfif>

        AND
            s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
    
        <!--- Get Current Division Students --->
        <!---
        AND
            s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        --->
        
        <!--- Get ISE students --->
        <!---
        <cfif CLIENT.companyID EQ 10>
        AND
            s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        <cfelse>
        AND
            s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="$APPLICATION.SETTINGS.COMPANYLIST.ISE$" list="yes"> )
        </cfif>
        --->
    
        ORDER BY 
            u.businessname, 
            s.firstname,
            s.familyLastName,
            s.studentID       
        LIMIT 
            250
    </cfquery><!--- COUNTRY 232 = USA --->

</cfsilent>
    
<cfif NOT VAL(qGetStudents.recordcount)>
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
    	<cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">, 
        <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">, 
        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#">, 
        <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudents.recordcount#">, 
        <cfqueryparam cfsqltype="cf_sql_varchar" value="new">
    )
</cfquery>
 
<!--- BATCH ID MUST BE UNIQUE --->
<cfquery name="get_batchid" datasource="MySql">
	SELECT 
    	MAX(batchid) as batchid
	FROM 
    	smg_sevis
</cfquery>

<cfset add_zeros = 13 - len(get_batchid.batchid) - len(qGetCompany.companyshort_nocolor)>
<!--- Batch id has to be numeric in nature A through Z a through z 0 through 9  --->

<cfoutput>

<table align="center" width="100%" frame="box">
	<th colspan="5">#qGetCompany.companyshort_nocolor# &nbsp; - &nbsp; Batch ID #get_batchid.batchid# &nbsp; - &nbsp; List of Students &nbsp; - &nbsp; Total of students in this batch: #qGetStudents.recordcount#</th>
	<tr>
		<td>Record</td>
        <td>Company</td>
        <td>Student</td>
        <td>Start Date</td>
        <td>School</td>
	</tr>
	<cfloop query="qGetStudents">
	<tr bgcolor="#iif(qGetStudents.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
		<td>#qGetStudents.currentrow#</td>
        <td>#businessname#</td>
        <td>#firstname# #familylastname# (#studentid#)</td>
		<td>
			<cfif DateFormat(now(), 'mm/dd/yyyy') GT DateFormat(sevis_startdate, 'mm/dd/yyyy')> <!--- Start Date after program start date --->
                #DateFormat(now()+1, 'yyyy-mm-dd')#
                <cfset nstart_date = DateFormat(now()+1, 'yyyy-mm-dd')>
            <cfelse>
                <cfif DateDiff('yyyy', dob, sevis_startdate) LT 15> <!--- Student has not completed 15 by the program start date --->
                    #dateformat (now(), 'yyyy')#-#dateformat (dob, 'mm-dd')#
                    <cfset nstart_date = '#dateformat (now(), 'yyyy')#-#dateformat (dob, 'mm-dd')#'>
                <cfelseif ayporientation NEQ 0 OR aypenglish NEQ 0> <!--- Pre AYP student - get Pre Ayp Dates --->
                    #dateformat (preayp_date, 'yyyy-mm-dd')#
                    <cfset nstart_date = dateformat (preayp_date, 'yyyy-mm-dd')>
                <cfelse> <!--- Get SEVIS start/end date --->
                    #DateFormat(sevis_startdate, 'yyyy-mm-dd')#
                    <cfset nstart_date = DateFormat(sevis_startdate, 'yyyy-mm-dd')>
                </cfif>
            </cfif>
		</td>
        <td>
            <cfif schoolid NEQ 0 AND host_fam_approved LT 5>
                <Address1>#schooladdress#</Address1>
                <cfif NOT LEN(schooladdress2)><Address2>#schooladdress2#</Address2></cfif>
                <City>#schoolcity#</City> 
                <State>#schoolstate#</State> 
                <PostalCode>#schoolzip#</PostalCode> 
                <SiteName>#schoolname#</SiteName>
            <cfelse>
                <Address1>#qGetCompany.address#</Address1> 
                <cfif NOT LEN(schooladdress2)><Address2>#schooladdress2#</Address2></cfif>
                <City>#qGetCompany.city#</City> 
                <State>#qGetCompany.state#</State> 
                <PostalCode>#qGetCompany.zip#</PostalCode> 
                <SiteName>#qGetCompany.companyname#</SiteName>
            </cfif>
        </td>
	</tr>
	</cfloop>
</table>
<br><br><br>
END OF DISPLAY

<!--- <BatchID>#qGetCompany.iap_auth#_#add_zeros##get_batchid.batchid#</BatchID> --->
<!--- <BatchID>#qGetCompany.companyshort_nocolor#<cfloop index = "ZeroCount" from = "1" to = #qtd_zeros#>0</cfloop>#get_batchid.batchid#</BatchID>  --->

<!-- Create an XML document object containing the data -->

<cfxml variable="sevis_batch">
<SEVISBatchCreateUpdateEV 
	xmlns:common="http://www.ice.gov/xmlschema/sevisbatch/Common.xsd" 
	xmlns:table="http://www.ice.gov/xmlschema/sevisbatch/SEVISTable.xsd" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xsi:noNamespaceSchemaLocation="http://www.ice.gov/xmlschema/sevisbatch/Create-UpdateExchangeVisitor.xsd"
	userID='#qGetCompany.sevis_userid#'>
<BatchHeader>
	<BatchID>#qGetCompany.companyshort_nocolor#-<cfloop index = "ZeroCount" from="1" to="#add_zeros#">0</cfloop>#get_batchid.batchid#</BatchID>
	<OrgID>#qGetCompany.iap_auth#</OrgID> 
</BatchHeader>
<CreateEV>
<cfloop query="qGetStudents">
<ExchangeVisitor requestID="#qGetStudents.currentRow#_#qGetStudents.studentid#" printForm="true" userID="#qGetCompany.sevis_userid#">
	<UserDefinedA>#qGetStudents.studentid#</UserDefinedA>
	<Biographical>
		<FullName>
			<LastName>#familylastname#</LastName> 
			<FirstName>#firstname#</FirstName> 
			<cfif LEN(middlename)><MiddleName>#middlename#</MiddleName></cfif>			
		</FullName>
		<BirthDate>#DateFormat(dob, 'yyyy-mm-dd')#</BirthDate> 
		<Gender><cfif sex is 'male'>M<cfelseif sex is 'female'>F</cfif></Gender> 
		<BirthCity>#citybirth#</BirthCity> 
		<BirthCountryCode>#birthseviscode#</BirthCountryCode> 
		<CitizenshipCountryCode>#citizenseviscode#</CitizenshipCountryCode> 
		<PermanentResidenceCountryCode>#residentseviscode#</PermanentResidenceCountryCode> 		
	</Biographical>
	<PositionCode>223</PositionCode> 
	<PrgStartDate>
		<cfif DateFormat(now(), 'mm/dd/yyyy') GT DateFormat(sevis_startdate, 'mm/dd/yyyy')> 
        	#DateFormat(now()+1, 'yyyy-mm-dd')#
			<cfset nstart_date = DateFormat(now()+1, 'yyyy-mm-dd')>
        <cfelse>
			<cfif DateDiff('yyyy', dob, sevis_startdate) LT 15>
            	#dateformat (now(), 'yyyy')#-#dateformat (dob, 'mm-dd')#
				<cfset nstart_date = '#dateformat (now(), 'yyyy')#-#dateformat (dob, 'mm-dd')#'>
			<cfelseif ayporientation NEQ '0' OR aypenglish NEQ '0'>
				#dateformat (preayp_date, 'yyyy-mm-dd')#
				<cfset nstart_date = dateformat (preayp_date, 'yyyy-mm-dd')>
            <cfelse>
                #DateFormat(sevis_startdate, 'yyyy-mm-dd')#
                <cfset nstart_date = DateFormat(sevis_startdate, 'yyyy-mm-dd')>
			</cfif>
		</cfif>
    </PrgStartDate>  
	<PrgEndDate>#DateFormat(sevis_enddate, 'yyyy-mm-dd')#</PrgEndDate> <!--- <cfif programtype EQ '3'>2010-06-30<cfelse>#DateFormat(sevis_enddate, 'yyyy-mm-dd')#</cfif> <!--- type = 3 first semester ---> --->
	<CategoryCode>1A</CategoryCode>
	<SubjectField>
		<SubjectFieldCode>53.0299</SubjectFieldCode> 
		<Remarks>none</Remarks> 
	</SubjectField>
	<USAddress>
	<cfif VAL(hostid) AND host_fam_approved LT 5>
		<Address1><cfif LEN(hostlastname)>#hostlastname#<cfelseif LEN(fatherlastname)>#fatherlastname#<cfelseif LEN(motherlastname)>#motherlastname#</cfif> Family</Address1> 	
		<Address2>#hostaddress#</Address2> 					
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
	<FinancialInfo>
		<ReceivedUSGovtFunds>false</ReceivedUSGovtFunds> 
		<OtherFunds>
			<Personal>3000</Personal> 
		</OtherFunds>
	</FinancialInfo>
	<AddSiteOfActivity>
		<SiteOfActivity>
		<cfif VAL(schoolid) AND host_fam_approved LT 5>
            <Address1>#schooladdress#</Address1> 
            <cfif LEN(schooladdress2)><Address2>#schooladdress2#</Address2></cfif>
            <City>#schoolcity#</City> 
            <State>#schoolstate#</State> 
            <PostalCode>#schoolzip#</PostalCode> 
            <SiteName>#schoolname#</SiteName>
            <PrimarySite>true</PrimarySite>
		<cfelse><Address1>#qGetCompany.address#</Address1> 
			<cfif LEN(schooladdress2)><Address2>#schooladdress2#</Address2></cfif>
            <City>#qGetCompany.city#</City> 
            <State>#qGetCompany.state#</State> 
            <PostalCode>#qGetCompany.zip#</PostalCode> 
            <SiteName>#qGetCompany.companyname#</SiteName>
            <PrimarySite>true</PrimarySite>
       	</cfif>
	   </SiteOfActivity>
	</AddSiteOfActivity>
	</ExchangeVisitor>
        <cfquery name="upd_stu" datasource="MySql">
            UPDATE smg_students SET sevis_batchid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_batchid.batchid#"> WHERE studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudents.studentid#">
        </cfquery><cfquery name="insert_history" datasource="MySql">
            INSERT INTO smg_sevis_history (studentid, batchid, hostid, school_name, start_date, end_date)
            VALUES (#studentid#,#get_batchid.batchid#,#hostid#, <cfif VAL(schoolid) AND host_fam_approved LT 5>'#schoolname#'<cfelse>'#qGetCompany.companyname#'</cfif>, #CreateODBCDate(nstart_date)#, #CreateODBCDate(sevis_enddate)# <!---<cfif programtype EQ '3'>'2010-06-30'<cfelse>#CreateODBCDate(sevis_enddate)#</cfif>--->)
        </cfquery>
	</cfloop>
</CreateEV>
</SEVISBatchCreateUpdateEV>  
</cfxml>

<!-- dump the resulting XML document object -->

<cfscript>
	// Get Folder Path 
	currentDirectory = "#AppPath.sevis##qGetCompany.companyshort_nocolor#/new_forms/";

	// Make sure the folder Exists
	AppCFC.UDF.createFolder(currentDirectory);
</cfscript>

<cffile action="write" file="#currentDirectory#/#qGetCompany.companyshort_nocolor#_new_00#get_batchid.batchid#.xml" output="#toString(sevis_batch)#">

<table align="center" width="100%" frame="box">
	<th>#qGetCompany.companyshort_nocolor# &nbsp; - &nbsp; Batch ID #get_batchid.batchid# &nbsp; - &nbsp; Total of students in this batch: #qGetStudents.recordcount#</th>
	<th>BATCH CREATED.</th>
</table>

</cfoutput>

<!--- <cfdump var="#qGetStudents#">----->

<!--- <cffile action="write" file="#AppPath.sevis#sevis_batch_#Dateformat(now(), 'mm-dd-yyyy')#_#TimeFormat(now(), 'hh-mm-ss-tt')#.xml" output="#toString(sevis_batch)#"> --->
<!--- You can view the schemas at: 
http://www.ice.gov/xmlschema/sevisbatch/alpha/Common.xsd 
http://www.ice.gov/xmlschema/sevisbatch/alpha/Create-UpdateExchangeVisitor.xsd 
http://www.ice.gov/xmlschema/sevisbatch/alpha/Create-UpdateStudent.xsd 
http://www.ice.gov/xmlschema/sevisbatch/alpha/SEVISTable.xsd 
http://www.ice.gov/xmlschema/sevisbatch/alpha/SevisTransLog.xsd  --->