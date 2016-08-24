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
		oSevis = createObject("component","nsmg.extensions.components.sevis");
		
		// Create Company Object
		oCompany = createObject("component","nsmg.extensions.components.company");
		
		qGetCompany = oCompany.getCompanies(companyID=CLIENT.companyID);
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
            s.hostID, 
            s.schoolID, 
            s.host_fam_approved, 
            s.email,
            birth.seviscode AS birthseviscode,
            resident.seviscode AS residentseviscode,
            citizen.seviscode AS citizenseviscode,
            <!--- Program Information --->
            p.sevis_startdate, 
            p.sevis_enddate, 
            p.preayp_date, 
            p.type AS programtype,
            <!--- Intl. Rep Information --->
            u.businessname,
            <!--- Host Family Information --->
            h.familylastname AS hostlastname, 
            h.fatherFirstName,            
            h.fatherlastname, 
            h.motherFirstName,
            h.motherlastname, 
            h.address AS hostaddress, 
            h.address2 AS hostaddress2,
            h.city AS hostcity, 
            h.state AS hoststate, 
            h.zip AS hostzip,
            h.phone AS hostPhone, 
            hostHistory.isWelcomeFamily,
            <!--- School Information --->
            sc.schoolname, 
            sc.address AS schooladdress, 
            sc.address2 AS schooladdress2, 
            sc.city AS schoolcity,
            sc.state AS schoolstate, 
            sc.zip AS schoolzip,
            <!--- Area Representative Information --->
            areaRep.firstName AS areaRepFirstName,
            areaRep.lastName AS areaRepLastName,
            areaRep.zip as areaRepPostalCode
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
        LEFT OUTER JOIN 
            smg_hosts h ON s.hostID = h.hostID
        LEFT OUTER JOIN 
            smg_schools sc ON s.schoolID = sc.schoolID
        LEFT OUTER JOIN
        	smg_users areaRep ON s.areaRepID = areaRep.userID
        LEFT OUTER JOIN
        	smg_hosthistory hostHistory ON s.studentid = hostHistory.studentid
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
        	hostHistory.isActive = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND 
            s.sevis_batchid = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
        AND 
            s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programid#" list="yes"> )
		
		<cfif LEN(FORM.intRep)>
            AND
                s.intRep IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.intRep#" list="yes"> )
       	</cfif>
         AND
		<Cfif client.companyid lte 4 or client.companyid eq 12>
          ( s.companyID < <cfqueryparam cfsqltype="cf_sql_integer" value="5"> or s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="12">)
        <cfelse>
           s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        </Cfif>
       
           
    
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
	sBatchInfo = oSevis.insertBatch(
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
            <td>
            #REReplace(qGetStudents.firstname, "[^\w ]", "", "all")# #REReplace(qGetStudents.familylastname, "[^\w ]", "", "all")#
             (###qGetStudents.studentid#)</td>
            <td>
                <cfif DateFormat(now(), 'mm/dd/yyyy') GT DateFormat(qGetStudents.sevis_startdate, 'mm/dd/yyyy')> <!--- Start Date after program start date --->
                    #DateFormat(now()+1, 'yyyy-mm-dd')#
                <cfelse>
                    <!----<cfif DateDiff('yyyy', qGetStudents.dob, qGetStudents.sevis_startdate) LT 15> <!--- Student has not completed 15 by the program start date --->
                        #dateformat (now(), 'yyyy')#-#dateformat (qGetStudents.dob, 'mm-dd')# ---->
                    <cfif qGetStudents.ayporientation NEQ 0 OR qGetStudents.aypenglish NEQ 0> <!--- Pre AYP student - get Pre Ayp Dates --->
                        #dateformat (qGetStudents.preayp_date, 'yyyy-mm-dd')# 
                    <cfelse> <!--- Get SEVIS start/end date --->
                        #DateFormat(qGetStudents.sevis_startdate, 'yyyy-mm-dd')#
                    </cfif>
                </cfif>
            </td>
            <td>
                <cfif VAL(qGetStudents.schoolID) AND qGetStudents.host_fam_approved LT 5>
                    <Address1>#qGetStudents.schooladdress#</Address1>
                    <cfif NOT LEN(qGetStudents.schooladdress2)><Address2>#qGetStudents.schooladdress2#</Address2></cfif>
                    <City>#qGetStudents.schoolcity#</City> 
                    <State>#qGetStudents.schoolstate#</State> 
                    <PostalCode>#Left(qGetStudents.schoolzip,5)#</PostalCode> 
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
     <cfquery name="hostStatus" datasource="#APPLICATION.DSN#"> 
        select isWelcomeFamily
        from smg_hosthistory
        where studentid = #qGetStudents.studentid# and isActive = 1
    </cfquery>
            <cfif #hostStatus.isWelcomeFamily# eq 1>
            	<cfset hostFamilyInd = 'ARRV'>
			<cfelseif qGetStudents.host_fam_approved LT 5>
            	<cfset hostFamilyInd = 'TEMP'>
            <cfelse>
            	<cfset hostFamilyInd = 'PERM'>
            </cfif>
    <cfsilent>
    	
        <!--- Host Family Address --->
        <cfif VAL(qGetStudents.hostID) AND qGetStudents.host_fam_approved LT 5>
        	
        	<!--- Student Placed --->
            <cfset vSetHostID = qGetStudents.hostID>
            
            <cfsavecontent variable="vHostFamilyAddress">
               <!--- <Address1>#XMLFormat(oSevis.displayHostFamilyName(fatherFirstName=qGetStudents.fatherFirstName,fatherLastName=qGetStudents.fatherLastName,motherFirstName=qGetStudents.motherFirstName,motherLastName=qGetStudents.motherLastName))#</Address1> 	---->
                <Address1>#XMLFormat(qGetStudents.hostaddress)#</Address1> 					
                <City>#XMLFormat(qGetStudents.hostcity)#</City> 
                <State>#XMLFormat(qGetStudents.hoststate)#</State> 
                <PostalCode>#XMLFormat(Left(qGetStudents.hostzip,5))#</PostalCode>
                <ExplanationCode>OO</ExplanationCode>
                <Explanation>Verified with host family.</Explanation>
			</cfsavecontent>  
           
        <cfelse>
        
        	<!--- Student Not Placed --->
            <cfset vSetHostID = 0>
            
        	<cfsavecontent variable="vHostFamilyAddress">
                <Address1>#qGetCompany.address#</Address1> 
                <City>#qGetCompany.city#</City> 
                <State>#qGetCompany.state#</State> 
                <PostalCode>#qGetCompany.zip#</PostalCode>
            </cfsavecontent>
		
        </cfif>

		<!--- Site of Activity --->
		<cfif VAL(qGetStudents.schoolID) AND qGetStudents.host_fam_approved LT 5>
        
        	<!--- Student Placed --->
            <cfset vSetSchoolName = XMLFormat(TRIM(qGetStudents.schoolname))>
            
        	<cfsavecontent variable="vSiteOfActivity">
                <Address1>#XMLFormat(qGetStudents.schooladdress)#</Address1> <cfif LEN(qGetStudents.schooladdress2)><Address2>#XMLFormat(qGetStudents.schooladdress2)#</Address2></cfif>
                <City>#XMLFormat(qGetStudents.schoolcity)#</City> 
                <State>#XMLFormat(qGetStudents.schoolstate)#</State> 
                <PostalCode>#XMLFormat(qGetStudents.schoolzip)#</PostalCode> 
                <ExplanationCode>OO</ExplanationCode>
                <Explanation>Verified with host family.</Explanation>
                <SiteName>#XMLFormat(TRIM(qGetStudents.schoolname))#</SiteName>
                <PrimarySite>true</PrimarySite>
                
			</cfsavecontent>  
                          
        <cfelse>
        
        	<!--- Student Not Placed --->
            <cfset vSetSchoolName = qGetCompany.companyname>

        	<cfsavecontent variable="vSiteOfActivity">
                <Address1>#qGetCompany.address#</Address1> <cfif LEN(schooladdress2)><Address2>#schooladdress2#</Address2></cfif>
                <City>#qGetCompany.city#</City> 
                <State>#qGetCompany.state#</State> 
                <PostalCode>#Left(qGetCompany.zip,5)#</PostalCode>
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
			//} else if ( DateDiff('yyyy', qGetStudents.dob, qGetStudents.sevis_startdate) LT 15 ) {
				// Student has not completed 15 by the program start date
		  //		vSetStartDate = '#dateformat (now(), 'yyyy')#-#dateformat (qGetStudents.dob, 'mm-dd')#';
			} else if ( VAL(qGetStudents.ayporientation) OR VAL(qGetStudents.aypenglish) ) {
				// Pre AYP student - get Pre Ayp Dates
				vSetStartDate = dateformat (qGetStudents.preayp_date, 'yyyy-mm-dd');
			} else {
				// Get SEVIS start/end date
				vSetStartDate = DateFormat(qGetStudents.sevis_startdate, 'yyyy-mm-dd');
			}
			
			// Insert Batch History
			oSevis.insertBatchHistory(
				batchID=sBatchInfo.newRecord,
				studentID=qGetStudents.studentID,
				hostID=vSetHostID,
				schoolName=vSetSchoolName,
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
            
            
                <LastName>#REReplace(qGetStudents.familylastname, "[^\w ]", "", "all")#</LastName> 
                <FirstName>#REReplace(qGetStudents.firstname, "[^\w ]", "", "all")# <cfif LEN(qGetStudents.middlename)> #REReplace(qGetStudents.middlename, "[^\w ]", "", "all")#</cfif></FirstName> 		
            </FullName>
            <BirthDate>#DateFormat(qGetStudents.dob, 'yyyy-mm-dd')#</BirthDate> 
            <Gender><cfif qGetStudents.sex EQ 'male'>M<cfelse>F</cfif></Gender> 
            <BirthCity>#XMLFormat(qGetStudents.citybirth)#</BirthCity> 
            <BirthCountryCode>#qGetStudents.birthseviscode#</BirthCountryCode> 
            <CitizenshipCountryCode>#qGetStudents.citizenseviscode#</CitizenshipCountryCode> 
            <PermanentResidenceCountryCode>#qGetStudents.residentseviscode#</PermanentResidenceCountryCode> 
            <EmailAddress>#XMLFormat(TRIM(qGetStudents.email))#</EmailAddress>	
        </Biographical>
        <PositionCode>223</PositionCode> 
        <PrgStartDate>#DateFormat(vSetStartDate, 'yyyy-mm-dd')#</PrgStartDate>  
        <PrgEndDate>#DateFormat(qGetStudents.sevis_enddate, 'yyyy-mm-dd')#</PrgEndDate>
        <CategoryCode>1A</CategoryCode>
        <SubjectField>
            <SubjectFieldCode>53.0299</SubjectFieldCode> 
            <Remarks>none</Remarks> 
        </SubjectField>
        <USAddress>#TRIM(vHostFamilyAddress)#</USAddress>
        <FinancialInfo>
            <ReceivedUSGovtFunds>false</ReceivedUSGovtFunds> 
            <OtherFunds>
                <Personal>3000</Personal> 
            </OtherFunds>
        </FinancialInfo>
        <AddSiteOfActivity>
            <SiteOfActivity xsi:type="SOA">#TRIM(vSiteOfActivity)#</SiteOfActivity>
        </AddSiteOfActivity>
        <cfif VAL(vSetHostID)> <!--- Residential Address Information --->
        	#oSevis.getResidentialAddressInformation(
                hostFatherFirstName=qGetStudents.fatherFirstName,
                hostFatherLastName=qGetStudents.fatherLastName,
                hostMotherFirstName=qGetStudents.motherFirstName,
                hostMotherLastName=qGetStudents.motherLastName,
                hostPhone=APPLICATION.CFC.UDF.formatPhoneNumber(qGetStudents.hostPhone),
                localCoordinatorFirstName=qGetStudents.areaRepFirstName,
                localCoordinatorLastName=qGetStudents.areaRepLastName,
                localCoordinatorPostalCode=qGetStudents.areaRepPostalCode,
                hostFamilyIndicator = hostFamilyInd
            )#
		</cfif>
        	<!--- Residential Address Information --->
                    #oSevis.getResidentialAddressInformation(
                        hostFatherFirstName=qGetStudents.fatherFirstName,
                        hostFatherLastName=qGetStudents.fatherLastName,
                        hostMotherFirstName=qGetStudents.motherFirstName,
                        hostMotherLastName=qGetStudents.motherLastName,
                        hostPhone=APPLICATION.CFC.UDF.formatPhoneNumber(qGetStudents.hostPhone),
                        localCoordinatorFirstName=qGetStudents.areaRepFirstName,
                        localCoordinatorLastName=qGetStudents.areaRepLastName,
                        localCoordinatorPostalCode=qGetStudents.areaRepPostalCode,
                        hostFamilyIndicator = hostFamilyInd
                    )#
	
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
http://www.ice.gov/doclib/sevis/schools/batch/common.xsd 
http://www.ice.gov/xmlschema/sevisbatch/alpha/Create-UpdateExchangeVisitor.xsd 
http://www.ice.gov/xmlschema/sevisbatch/alpha/Create-UpdateStudent.xsd 
http://www.ice.gov/xmlschema/sevisbatch/alpha/SEVISTable.xsd 
http://www.ice.gov/xmlschema/sevisbatch/alpha/SevisTransLog.xsd  --->