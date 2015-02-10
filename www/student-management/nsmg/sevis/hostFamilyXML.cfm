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

    <cfquery name="qGetStudents" datasource="#APPLICATION.DSN.Source#"> 
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
            <!--- Intl. Rep Information --->
            u.businessname,
            <!--- Host Family Information --->
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
            h.phone AS hostPhone, 
            <!--- Area Representative Information --->
            areaRep.firstName AS areaRepFirstName,
            areaRep.lastName AS areaRepLastName
        FROM 
            smg_students s
        INNER JOIN 
            smg_programs p ON s.programid = p.programid
        INNER JOIN 
            smg_users u ON s.intrep = u.userid
        INNER JOIN
            smg_hosts h ON s.hostid = h.hostid
        LEFT OUTER JOIN
        	smg_users areaRep ON s.areaRepID = areaRep.userID
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
            
        <!--- Get only the last record. Student could relocate to a previous host family --->
        AND 
            h.hostid NOT IN ( SELECT hostid FROM smg_sevis_history WHERE studentid = s.studentID AND historyID = (SELECT max(historyID) FROM smg_sevis_history WHERE studentid = s.studentID AND isActive = <cfqueryparam cfsqltype="cf_sql_bit" value="1"> ) )
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
		type="host_update"
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
	</tr>
	<cfloop query="qGetStudents">
        <tr bgcolor="#iif(qGetStudents.currentrow MOD 2 ,DE("ededed") ,DE("ffffff") )#">
            <td>#qGetStudents.currentrow#</td>
            <td>#qGetStudents.businessname#</td>
            <td>#qGetStudents.firstname# #qGetStudents.familylastname# (###qGetStudents.studentid#)</td>
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
	<UpdateEV>
	<cfloop query="qGetStudents">
        <cfsilent>
		
			<cfscript> 
				// Get Active History
				qGetBatchHistory = oSevis.getBatchHistory(studentID=qGetStudents.studentID);
				
                // Insert Batch History
                oSevis.insertBatchHistory(
                    batchID=sBatchInfo.newRecord,
                    studentID=qGetStudents.studentID,
                    hostID=qGetStudents.hostID,
                    schoolName=qGetBatchHistory.school_name,
                    startDate=qGetBatchHistory.start_date,
                    endDate=qGetBatchHistory.end_date
                );
            </cfscript>

			<!--- Host Family Address --->
            <cfif VAL(qGetStudents.hostid)>
            
                <!--- Student Placed --->
                <cfsavecontent variable="vHostFamilyAddress">
                    <Address1>#XMLFormat(oSevis.displayHostFamilyName(fatherFirstName=qGetStudents.fatherFirstName,fatherLastName=qGetStudents.fatherLastName,motherFirstName=qGetStudents.motherFirstName,motherLastName=qGetStudents.motherLastName))#</Address1> 	
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
        
		</cfsilent>
		<ExchangeVisitor sevisID="#qGetStudents.ds2019_no#" requestID="#qGetStudents.studentID#" userID="#qGetCompany.sevis_userid#">
			<Biographical printForm="false">
				<USAddress>
					#TRIM(vHostFamilyAddress)#
				</USAddress> <!--- Residential Address Information --->
                #oSevis.getResidentialAddressInformation(
                    hostFatherFirstName=qGetStudents.fatherFirstName,
                    hostFatherLastName=qGetStudents.fatherLastName,
                    hostMotherFirstName=qGetStudents.motherFirstName,
                    hostMotherLastName=qGetStudents.motherLastName,
                    hostPhone=APPLICATION.CFC.UDF.formatPhoneNumber(qGetStudents.hostPhone),
                    localCoordinatorFirstName=qGetStudents.areaRepFirstName,
                    localCoordinatorLastName=qGetStudents.areaRepLastName
                )#
			</Biographical>
		</ExchangeVisitor>
	</cfloop>
	</UpdateEV>
</SEVISBatchCreateUpdateEV>
</cfxml>

<cfscript>
	// Get Folder Path 
	currentDirectory = "#APPLICATION.PATH.sevis##qGetCompany.companyshort_nocolor#/host_family/";

	// Make sure the folder Exists
	APPLICATION.CFC.UDF.createFolder(currentDirectory);
</cfscript>

<cffile action="write" file="#currentDirectory##qGetCompany.companyshort_nocolor#_host_0#sBatchInfo.newRecord#.xml" output="#toString(xmlSevisBatch)#">

<table align="center" width="100%" frame="box">
	<th>#qGetCompany.companyshort_nocolor# &nbsp; - &nbsp; Batch ID #sBatchInfo.newRecord# &nbsp; - &nbsp; Total of students in this batch: #qGetStudents.recordcount#</th>
	<th>BATCH CREATED.</th>
</table>

</cfoutput>
