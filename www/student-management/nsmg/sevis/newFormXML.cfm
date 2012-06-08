<!--- ------------------------------------------------------------------------- ----
	
	File:		newFormXML.cfm
	Author:		Marcus Melo
	Date:		June 8, 2012
	Desc:		Generates XML to create SEVIS form

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
    <cfsetting requesttimeout="9999">

	<!--- Param Form Variables --->
    <cfparam name="FORM.programID" default="">
    <cfparam name="FORM.intRep" default="">
    
    <cfscript>
		// Create SEVIS Object
		s = createObject("component","nsmg.extensions.components.sevis");
		
		// Create Company Object
		c = createObject("component","nsmg.extensions.components.company");
		
		qGetCompany = c.getCompanies(companyID=CLIENT.companyID);
	</cfscript>
    
    <cfquery name="qGetStudents" datasource="#APPLICATION.DSN#"> 
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
            h.fatherFirstName,            
            h.fatherlastname, 
            h.motherFirstName,
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
		
		<cfif LEN(FORM.intRep)>
            AND
                s.intRep IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.intRep#" list="yes"> )
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
            s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISE#" list="yes"> )
        </cfif>
        --->
    
        ORDER BY 
            u.businessname, 
            s.firstname,
            s.familyLastName,
            s.studentID       
        LIMIT 
            250
    </cfquery>
    
</cfsilent>    

<cfif NOT VAL(qGetStudents.recordcount)>
	Sorry, there were no students to populate the XML file at this time.
	<cfabort>
</cfif>

<cfscript>
	// Insert Batch Information
	sBatchInfo = s.insertBatch(
		companyID=qGetCompany.companyID,			   
		companyShort=qGetCompany.companyshort_nocolor,							   
		totalStudents=qGetStudents.recordcount,
		type="new"
	);
</cfscript>

<cfoutput>

<table align="center" width="100%" frame="box">
	<tr>
    	<th colspan="5">
    		#qGetCompany.companyshort_nocolor# &nbsp; - &nbsp; Batch ID #sBatchInfo.newRecord# 
            &nbsp; - &nbsp; 
            List of Students 
            &nbsp; - &nbsp; 
            Total of students in this batch: #qGetStudents.recordcount#
		</th>
	</tr>
    <tr>
		<td>Record</td>
        <td>Intl. Representative</td>
        <td>Student</td>
        <td>Start Date</td>
        <td>School</td>
	</tr>
	<cfloop query="qGetStudents">
        <tr bgcolor="#iif(qGetStudents.currentrow MOD 2 ,DE("ededed") ,DE("ffffff") )#">
            <td>#qGetStudents.currentrow#</td>
            <td>#qGetStudents.businessname#</td>
            <td>#qGetStudents.firstname# #qGetStudents.familylastname# (###qGetStudents.studentid#)</td>
            <td>
                <cfif DateFormat(now(), 'mm/dd/yyyy') GT DateFormat(qGetStudents.sevis_startdate, 'mm/dd/yyyy')> <!--- Start Date after program start date --->
                    #DateFormat(now()+1, 'yyyy-mm-dd')#
                <cfelse>
                    <cfif DateDiff('yyyy', qGetStudents.dob, qGetStudents.sevis_startdate) LT 15> <!--- Student has not completed 15 by the program start date --->
                        #dateformat (now(), 'yyyy')#-#dateformat (qGetStudents.dob, 'mm-dd')# 
                    <cfelseif qGetStudents.ayporientation NEQ 0 OR qGetStudents.aypenglish NEQ 0> <!--- Pre AYP student - get Pre Ayp Dates --->
                        #dateformat (qGetStudents.preayp_date, 'yyyy-mm-dd')# 
                    <cfelse> <!--- Get SEVIS start/end date --->
                        #DateFormat(qGetStudents.sevis_startdate, 'yyyy-mm-dd')#
                    </cfif>
                </cfif>
            </td>
            <td>
                <cfif VAL(qGetStudents.schoolid) AND qGetStudents.host_fam_approved LT 5>
                    <Address1>#qGetStudents.schooladdress#</Address1>
                    <cfif NOT LEN(qGetStudents.schooladdress2)><Address2>#qGetStudents.schooladdress2#</Address2></cfif>
                    <City>#qGetStudents.schoolcity#</City> 
                    <State>#qGetStudents.schoolstate#</State> 
                    <PostalCode>#qGetStudents.schoolzip#</PostalCode> 
                    <SiteName>#qGetStudents.schoolname#</SiteName>
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
</table> <br />

<cfxml variable="xmlSevisBatch">
<SEVISBatchCreateUpdateEV 
	xmlns:common="http://www.ice.gov/xmlschema/sevisbatch/Common.xsd" 
	xmlns:table="http://www.ice.gov/xmlschema/sevisbatch/SEVISTable.xsd" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xsi:noNamespaceSchemaLocation="http://www.ice.gov/xmlschema/sevisbatch/Create-UpdateExchangeVisitor.xsd"
	userID='#qGetCompany.sevis_userid#'>
<BatchHeader>
	<BatchID>#sBatchInfo.sevisBatchID#</BatchID>
	<OrgID>#qGetCompany.iap_auth#</OrgID> 
</BatchHeader>
<CreateEV>
<cfloop query="qGetStudents">
	<cfsilent>
    	
        <!--- Host Family Address --->
        <cfif VAL(qGetStudents.hostid) AND qGetStudents.host_fam_approved LT 5>
        
        	<!--- Student Placed --->
            <cfsavecontent variable="vHostFamilyAddress">
                <Address1>#XMLFormat(s.displayHostFamilyName(fatherFirstName=qGetStudents.fatherFirstName,fatherLastName=qGetStudents.fatherLastName,motherFirstName=qGetStudents.motherFirstName,motherLastName=qGetStudents.motherLastName))#</Address1> 	
                <Address2>#XMLFormat(qGetStudents.hostaddress)#</Address2> 					
                <City>#XMLFormat(qGetStudents.hostcity)#</City> 
                <State>#XMLFormat(qGetStudents.hoststate)#</State> 
                <PostalCode>#XMLFormat(qGetStudents.hostzip)#</PostalCode>
			</cfsavecontent>  
            
        <cfelse>
        
        	<!--- Student Not Placed --->
        	<cfsavecontent variable="vHostFamilyAddress">
                <Address1>#qGetCompany.address#</Address1> 
                <City>#qGetCompany.city#</City> 
                <State>#qGetCompany.state#</State> 
                <PostalCode>#qGetCompany.zip#</PostalCode>
            </cfsavecontent>
            
        </cfif>

		<!--- Site of Activity --->
		<cfif VAL(qGetStudents.schoolid) AND qGetStudents.host_fam_approved LT 5>
        
        	<!--- Student Placed --->
        	<cfsavecontent variable="vSiteOfActivity">
                <Address1>#XMLFormat(qGetStudents.schooladdress)#</Address1> <cfif LEN(qGetStudents.schooladdress2)><Address2>#XMLFormat(qGetStudents.schooladdress2)#</Address2></cfif>
                <City>#XMLFormat(qGetStudents.schoolcity)#</City> 
                <State>#XMLFormat(qGetStudents.schoolstate)#</State> 
                <PostalCode>#XMLFormat(qGetStudents.schoolzip)#</PostalCode> 
                <SiteName>#XMLFormat(qGetStudents.schoolname)#</SiteName>
                <PrimarySite>true</PrimarySite>
			</cfsavecontent>  
                          
        <cfelse>
        
        	<!--- Student Not Placed --->
        	<cfsavecontent variable="vSiteOfActivity">
                <Address1>#qGetCompany.address#</Address1> <cfif LEN(schooladdress2)><Address2>#schooladdress2#</Address2></cfif>
                <City>#qGetCompany.city#</City> 
                <State>#qGetCompany.state#</State> 
                <PostalCode>#qGetCompany.zip#</PostalCode> 
                <SiteName>#qGetCompany.companyname#</SiteName>
                <PrimarySite>true</PrimarySite>
			</cfsavecontent>  
                          
        </cfif>

        <cfscript>
			// Set Start Date
			vSetStartDate = '';
			
			if ( DateFormat(now(), 'mm/dd/yyyy') GT DateFormat(qGetStudents.sevis_startdate, 'mm/dd/yyyy') ) {
				//Start Date after program start date 
				vSetStartDate = DateFormat(now()+1, 'yyyy-mm-dd');
			} else if ( DateDiff('yyyy', qGetStudents.dob, qGetStudents.sevis_startdate) LT 15 ) {
				// Student has not completed 15 by the program start date
				vSetStartDate = '#dateformat (now(), 'yyyy')#-#dateformat (qGetStudents.dob, 'mm-dd')#';
			} else if ( VAL(qGetStudents.ayporientation) OR VAL(qGetStudents.aypenglish) ) {
				// Pre AYP student - get Pre Ayp Dates
				vSetStartDate = dateformat (qGetStudents.preayp_date, 'yyyy-mm-dd');
			} else {
				// Get SEVIS start/end date
				vSetStartDate = DateFormat(qGetStudents.sevis_startdate, 'yyyy-mm-dd');
			}
			
			// Insert Batch History
			s.insertBatchHistory(
				batchID=sBatchInfo.newRecord,
				studentID=qGetStudents.studentID,
				hostID=qGetStudents.hostID,
				schoolName=qGetStudents.schoolName,
				startDate=vSetStartDate,
				endDate=sevis_enddate
			);
		</cfscript>
        
        <cfquery datasource="#APPLICATION.DSN#">
            UPDATE 
                smg_students 
            SET 
                sevis_batchid = <cfqueryparam cfsqltype="cf_sql_integer" value="#sBatchInfo.newRecord#"> 
            WHERE 
                studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudents.studentid#">
        </cfquery>
    </cfsilent>
    <ExchangeVisitor requestID="#qGetStudents.currentRow#_#qGetStudents.studentid#" printForm="true" userID="#qGetCompany.sevis_userid#">
        <UserDefinedA>#qGetStudents.studentid#</UserDefinedA>
        <Biographical>
            <FullName>
                <LastName>#XMLFormat(qGetStudents.familylastname)#</LastName> 
                <FirstName>#XMLFormat(qGetStudents.firstname)#</FirstName> 
				<cfif LEN(qGetStudents.middlename)><MiddleName>#XMLFormat(qGetStudents.middlename)#</MiddleName></cfif>			
            </FullName>
            <BirthDate>#DateFormat(qGetStudents.dob, 'yyyy-mm-dd')#</BirthDate> 
            <Gender><cfif qGetStudents.sex EQ 'male'>M<cfelseif qGetStudents.sex EQ 'female'>F</cfif></Gender> 
            <BirthCity>#XMLFormat(qGetStudents.citybirth)#</BirthCity> 
            <BirthCountryCode>#qGetStudents.birthseviscode#</BirthCountryCode> 
            <CitizenshipCountryCode>#qGetStudents.citizenseviscode#</CitizenshipCountryCode> 
            <PermanentResidenceCountryCode>#qGetStudents.residentseviscode#</PermanentResidenceCountryCode> 		
        </Biographical>
        <PositionCode>223</PositionCode> 
        <PrgStartDate>#DateFormat(vSetStartDate, 'yyyy-mm-dd')#</PrgStartDate>  
        <PrgEndDate>#DateFormat(qGetStudents.sevis_enddate, 'yyyy-mm-dd')#</PrgEndDate>
        <CategoryCode>1A</CategoryCode>
        <SubjectField>
            <SubjectFieldCode>53.0299</SubjectFieldCode> 
            <Remarks>none</Remarks> 
        </SubjectField>
        <USAddress>
        	#TRIM(vHostFamilyAddress)#
        </USAddress>
        <FinancialInfo>
            <ReceivedUSGovtFunds>false</ReceivedUSGovtFunds> 
            <OtherFunds>
                <Personal>3000</Personal> 
            </OtherFunds>
        </FinancialInfo>
        <AddSiteOfActivity>
            <SiteOfActivity>
            	#TRIM(vSiteOfActivity)#
			</SiteOfActivity>
        </AddSiteOfActivity>
	</ExchangeVisitor>
</cfloop>
</CreateEV>
</SEVISBatchCreateUpdateEV>  
</cfxml>

<!-- dump the resulting XML document object -->

<cfscript>
	// Get Folder Path 
	currentDirectory = "#AppPath.sevis##qGetCompany.companyshort_nocolor#/new_forms/";

	// Make sure the folder Exists
	APPLICATION.CFC.UDF.createFolder(currentDirectory);
</cfscript>

<cffile action="write" file="#currentDirectory#/#qGetCompany.companyshort_nocolor#_new_00#sBatchInfo.newRecord#.xml" output="#toString(TRIM(xmlSevisBatch))#">

<table align="center" width="100%" frame="box">
	<th>#qGetCompany.companyshort_nocolor# &nbsp; - &nbsp; Batch ID #sBatchInfo.newRecord# &nbsp; - &nbsp; Total of students in this batch: #qGetStudents.recordcount#</th>
	<th>BATCH CREATED.</th>
</table>

</cfoutput>

<!--- <cffile action="write" file="#AppPath.sevis#sevis_batch_#Dateformat(now(), 'mm-dd-yyyy')#_#TimeFormat(now(), 'hh-mm-ss-tt')#.xml" output="#toString(xmlSevisBatch)#"> --->
<!--- You can view the schemas at: 
http://www.ice.gov/xmlschema/sevisbatch/alpha/Common.xsd 
http://www.ice.gov/xmlschema/sevisbatch/alpha/Create-UpdateExchangeVisitor.xsd 
http://www.ice.gov/xmlschema/sevisbatch/alpha/Create-UpdateStudent.xsd 
http://www.ice.gov/xmlschema/sevisbatch/alpha/SEVISTable.xsd 
http://www.ice.gov/xmlschema/sevisbatch/alpha/SevisTransLog.xsd  --->