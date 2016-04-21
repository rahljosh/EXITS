<!--- ------------------------------------------------------------------------- ----
	
	File:		newFormXML.cfm
	Author:		Marcus Melo
	Date:		June 8, 2012
	Desc:		Generates XML to create SEVIS form

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->

	
    <cfsetting requesttimeout="9999">

	<!--- Param Form Variables --->
    <cfparam name="FORM.programID" default="">
    <cfparam name="FORM.intRep" default="">
    
    <cfscript>
		// Create SEVIS Object
		oSevis = createObject("component","extensions.components.sevis");
		
		// Create Company Object
		oCompany = createObject("component","extensions.components.company");
		
		qGetCompany = oCompany.getCompanies(companyID=CLIENT.companyID);
	</cfscript>
    
    <cfquery name="qGetStudents" datasource="#APPLICATION.DSN.Source#"> 
        SELECT 	
            c.candidateid, 
            c.ds2019, 
            c.firstname, 
            c.lastname, 
            c.middlename, 
            c.dob, 
            c.sex, 
            c.birth_city, 
            c.birth_country,
            c.residence_country,
            c.citizen_country,
            c.companyID,
            c.hostcompanyid, 
            c.sevis_batchid,
            c.startdate as sevis_startdate,
            c.enddate as sevis_enddate,
            c.email,
            
          
            birth.seviscode AS birthseviscode,
            resident.seviscode AS residentseviscode,
            citizen.seviscode AS citizenseviscode,
            
			<!--- Program Information --->
         
            p.preayp_date, 
            p.type AS programtype,
            
			<!--- Intl. Rep Information --->
            u.businessname,
            
            <!--- Company Information ---->
            hc.name as hostCompanyName, 
            hc.address AS hostCompanyAddress, 
            hc.address2 AS hostCompanyAddress2, 
            hc.city AS hostCompanyCity,
            hc.state AS hostCompanyState, 
            hc.zip AS hostCompanyZip,
            hc.supervisor,
            hc.phone,
            
            cpc.startDate,
            cpc.endDate,
            cpc.placement_date,
            cpc.jobid,
            
            jobs.classification,
            jobs.title,
            
            smg_states.state
       
			 
            <!--- Area Representative Information
            areaRep.firstName AS areaRepFirstName,
            areaRep.lastName AS areaRepLastName
			 --->
        FROM 
            extra_candidates c 
        INNER JOIN 
            smg_programs p ON c.programid = p.programid
        INNER JOIN 
            smg_users u ON c.intrep = u.userid
        INNER JOIN 
            smg_countrylist birth ON c.birth_country = birth.countryid
        INNER JOIN 
            smg_countrylist resident ON c.residence_country = resident.countryid
        INNER JOIN 
            smg_countrylist citizen ON c.citizen_country = citizen.countryid
		INNER JOIN
        	extra_hostcompany hc on c.hostcompanyid = hc.hostcompanyid
		INNER JOIN 
        	extra_candidate_place_company cpc on cpc.candidateid = c.candidateid      
        INNER JOIN
        	extra_jobs jobs on jobs.id = cpc.jobid
        LEFT JOIN
        	 smg_states on smg_states.id = hc.state
        WHERE 
            c.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0"> 
        AND 
            c.ds2019 = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
        AND 
        	cpc.isSecondary = <cfqueryparam cfsqltype="cf_sql_bit" value="0"> 
         AND 
        	cpc.status = <cfqueryparam cfsqltype="cf_sql_bit" value="1"> 
        <!--- US or Canada --->
        AND 
            c.birth_country NOT IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="32,232" list="yes"> )
        AND 
            c.residence_country NOT IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="32,232" list="yes"> )
        AND 
            c.citizen_Country NOT IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="32,232" list="yes"> )
        AND 
            c.verification_received = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.verificationDate#">
        AND
            c.sevis_batchid = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
        AND 
            c.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programid#" list="yes"> )
		
		<cfif LEN(FORM.intRep)>
            AND
                c.intRep IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.intRep#" list="yes"> )
       	</cfif>
      
		 AND 
           c.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
	
    
        ORDER BY 
            u.businessname, 
            c.LastName
                   
        LIMIT 
            250
    </cfquery>
    
<cfdump var="#qGetStudents#">


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
    		#qGetCompany.companyshort_nocolor# &nbsp; - &nbsp; Batch ID <!----#sBatchInfo.newRecord# ---->
            &nbsp; - &nbsp; 
            List of Students 
            &nbsp; - &nbsp; 
            Total of students in this batch: #qGetStudents.recordcount#
		</th>
	</tr>
    <tr>
		<td>Record</td>
        <td>Intl. Representative</td>
        <td>Candidate</td>
        <td>Start Date</td>
        <td>Company</td>
	</tr>
	<cfloop query="qGetStudents">
        <tr bgcolor="#iif(qGetStudents.currentrow MOD 2 ,DE("ededed") ,DE("ffffff") )#">
            <td>#qGetStudents.currentrow#</td>
            <td>#qGetStudents.businessname#</td>
            <td>#REReplace(qGetStudents.firstname, "[^\w ]", "", "all")# #REReplace(qGetStudents.lastname, "[^\w ]", "", "all")# (###qGetStudents.candidateid#)</td>
            <td>
                <cfif DateFormat(now(), 'mm/dd/yyyy') GT DateFormat(qGetStudents.sevis_startdate, 'mm/dd/yyyy')> <!--- Start Date after program start date --->
                    #DateFormat(now()+1, 'yyyy-mm-dd')#
                <cfelse>
         
                    #DateFormat(qGetStudents.sevis_startdate, 'yyyy-mm-dd')#
                    
                </cfif>
            </td>
            <td>
                    <SiteName>#Trim(LEFT(qGetStudents.hostCompanyname, 60))#</SiteName>
                    <Address1>#qGetStudents.hostCompanyAddress#</Address1>
                    <cfif NOT LEN(qGetStudents.hostCompanyaddress2)><Address2>#qGetStudents.hostCompanyaddress2#</Address2></cfif>
                    <City>#qGetStudents.hostCompanycity#</City> 
                    <State>#qGetStudents.state#</State> 
                    <PostalCode>#qGetStudents.hostCompanyzip#</PostalCode> 
                   
            
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
<cfset phoneString = ReReplaceNoCase(phone,"[^0-9]","","ALL")>
<cfset phoneString = Insert('.',phoneString,3)>
<cfset phoneString = Insert('.',phoneString,7)>
	<cfsilent>
    	
        <!--- Host COmpany Address --->
       
  	
            <!--- Home Placement Placed --->
 

		<!--- Site of Activity --->
	
        
            <cfset vSetHostID = qGetStudents.hostcompanyid>
        	<cfset vSetSchoolName = XMLFormat(TRIM(LEFT(qGetStudents.hostCompanyname, 60)))>
        	<cfsavecontent variable="vSiteOfActivity">
                    <Address1>#XMLFormat(qGetStudents.hostCompanyAddress)#</Address1>
                    <cfif LEN(trim(qGetStudents.hostCompanyaddress2))><Address2>#XMLFormat(qGetStudents.hostCompanyaddress2)#</Address2></cfif>
                    <City>#XMLFormat(qGetStudents.hostCompanycity)#</City> 
                    <State>#XMLFormat(qGetStudents.state)#</State> 
                    <PostalCode>#XMLFormat(qGetStudents.hostCompanyzip)#</PostalCode> 
                    <ExplanationCode>OO</ExplanationCode>
                	<Explanation>Verified with employer.</Explanation>
                    <SiteName>#XMLFormat(Trim(LEFT(qGetStudents.hostCompanyname,60)))#</SiteName>
                    <PrimarySite>true</PrimarySite>
                    <Remarks>#XMLFormat(qGetStudents.title)#, POC: #XMLFormat(qGetStudents.supervisor)#, POC Phone: #phoneString#</Remarks>
                    
			</cfsavecontent>  
                          
      

        <cfscript>
			// Set Start Date
			vSetStartDate = '';
			
			
				//vSetStartDate = DateFormat(qGetStudents.sevis_startdate, 'yyyy-mm-dd');
				vSetStartDate = DateFormat(qGetStudents.startdate, 'yyyy-mm-dd');
			
			// Insert Batch History
			oSevis.insertBatchHistory(
				batchID=sBatchInfo.newRecord,
				studentID=qGetStudents.candidateID,
				hostID=vSetHostID,
				schoolName=vSetSchoolName,
				startDate=vSetStartDate,
				endDate=enddate
			);
		</cfscript>
        
        <cfquery datasource="#APPLICATION.DSN.Source#">
            UPDATE 
               extra_candidates
            SET 
                sevis_batchid = <cfqueryparam cfsqltype="cf_sql_integer" value="#sBatchInfo.newRecord#">
            WHERE 
                candidateid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudents.candidateid#">
        </cfquery>
    </cfsilent>
    <ExchangeVisitor requestID="#qGetStudents.currentRow#_#qGetStudents.candidateid#" printForm="true" userID="#qGetCompany.sevis_userid#">
        <UserDefinedA>#qGetStudents.candidateid#</UserDefinedA>
        <Biographical>
            <FullName>
                <LastName>#XMLFormat(qGetStudents.lastname)#</LastName> 
                <FirstName>#XMLFormat(qGetStudents.firstname)# <cfif LEN(qGetStudents.middlename)> #XMLFormat(qGetStudents.middlename)#</cfif></FirstName> 
				
            </FullName>
            <BirthDate>#DateFormat(qGetStudents.dob, 'yyyy-mm-dd')#</BirthDate> 
            <Gender><cfif qGetStudents.sex EQ 'M'>M<cfelse>F</cfif></Gender> 
            <BirthCity>#XMLFormat(qGetStudents.birth_city)#</BirthCity> 
            <BirthCountryCode>#qGetStudents.birthseviscode#</BirthCountryCode> 
            <CitizenshipCountryCode>#qGetStudents.citizenseviscode#</CitizenshipCountryCode> 
            <PermanentResidenceCountryCode>#qGetStudents.residentseviscode#</PermanentResidenceCountryCode> 
            <EmailAddress>#qGetStudents.email#</EmailAddress>		
        </Biographical>
        <PositionCode>219</PositionCode> 
        <PrgStartDate>#DateFormat(qGetStudents.sevis_startdate, 'yyyy-mm-dd')#</PrgStartDate>  
        <PrgEndDate>#DateFormat(qGetStudents.sevis_enddate, 'yyyy-mm-dd')#</PrgEndDate>
        <CategoryCode>12</CategoryCode>
        <SubjectField>
            <SubjectFieldCode>#XMLFormat(qGetStudents.classification)#</SubjectFieldCode> 
            <Remarks>#XMLFormat(qGetStudents.title)#</Remarks> 
        </SubjectField>
        
        <FinancialInfo>
            <ReceivedUSGovtFunds>false</ReceivedUSGovtFunds> 
            <OtherFunds>
                <Personal>1000</Personal> 
            </OtherFunds>
        </FinancialInfo>
        <AddSiteOfActivity>
            <SiteOfActivity xsi:type="SOA">#TRIM(vSiteOfActivity)#</SiteOfActivity>
        </AddSiteOfActivity>
       
	</ExchangeVisitor>
</cfloop>
</CreateEV>
</SEVISBatchCreateUpdateEV>  
</cfxml>

<!-- dump the resulting XML document object -->

<cfscript>
	// Get Folder Path 
	//currentDirectory = "#AppPath.sevis##qGetCompany.companyshort_nocolor#/new_forms/";

	// Make sure the folder Exists
	//APPLICATION.CFC.UDF.createFolder(currentDirectory);
</cfscript>

<cffile action="write" file="C:/websites/exitsApplication/extra/internal/uploadedfiles/sevis/csb/new_forms/#qGetCompany.companyshort_nocolor#_new_00#sBatchInfo.newRecord#.xml" output="#toString(TRIM(xmlSevisBatch))#">

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