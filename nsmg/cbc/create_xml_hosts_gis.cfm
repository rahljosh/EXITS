<!--- ------------------------------------------------------------------------- ----
	
	File:		hosts_cbc.cfm
	Author:		Marcus Melo
	Date:		October 12, 2009
	Desc:		Host CBC Management

	Updated:  	10/12/09 - Combined qr_hosts_cbc.cfm to this file.
				10/13/09 - Running CBC background checks						

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

    <cfsetting requestTimeOut = "999">
	
	<cfparam name="FORM.userType" default="">
    <cfparam name="FORM.seasonID" default="0">
    
    <cfscript>
		// Gets Current Company
		qGetCompany = APPLICATION.CFC.COMPANY.getCompanies(companyID=CLIENT.companyID);
	</cfscript>

</cfsilent>

<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'
'http://www.w3.org/TR/html4/loose.dtd'>
<html>
<head>
<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>
<title>CBC Host Family and Members</title>
</head>

<body>

<cfoutput>


<cfif NOT LEN(FORM.usertype) OR NOT VAL(FORM.seasonID)>
	You must select a usertype or a season in order to run the batch. Please go back and try again.
	<cfabort>
</cfif>


<!--- HOSTS PARENTS --->
<cfif FORM.usertype NEQ 'member'>   
    
    <cfscript>
		// Get CBCs
		qGetCBCHost = APPLICATION.CFC.CBC.getHostNewCBC(
			companyID=CLIENT.companyID,
			seasonID=FORM.seasonID,
			userType=FORM.usertype
		);	
		
		// Set Missing Count
		missionCount = 0;
	</cfscript>  

	<!--- NO CBC FOUND ---> 
	<cfif NOT VAL(qGetCBCHost.recordcount)>
		Sorry, there were no users to populate the XML file at this time.
		<cfabort>
	</cfif>
	
	<!--- Data Validation --->
	<cfloop	query="qGetCBCHost">
		<cfif NOT LEN(Evaluate(usertype & "firstname"))>
            First Name is missing for host #Evaluate(usertype & "lastname")# (###hostid#). <br>
            <cfset missionCount = missionCount + 1>
		</cfif>
		
		<cfif NOT LEN(Evaluate(usertype & "lastname"))>
            Last Name is missing for host #Evaluate(usertype & "firstname")# (###hostid#). <br>
            <cfset missionCount = missionCount + 1>
		</cfif>
		
		<cfif NOT LEN(Evaluate(usertype & "dob")) OR NOT IsDate(Evaluate(usertype & "dob"))>
            DOB is missing or is not a valid date for host #Evaluate(usertype & "firstname")# #Evaluate(usertype & "lastname")# (###hostid#). <br>
            <cfset missionCount = missionCount + 1>
		</cfif>
		
		<cfif NOT LEN(Evaluate(usertype & "ssn"))>
            SSN is missing for host #Evaluate(usertype & "firstname")# #Evaluate(usertype & "lastname")# (###hostid#). <br>
            <cfset missionCount = missionCount + 1>
		</cfif>
	</cfloop>

	<cfif VAL(missionCount)>
		<br>There are #missionCount# item(s). In order to continue please enter the information missing.
		<cfabort>
	</cfif>

	<cfscript>
		// Create a batch ID - It must be unique
		newBatchID = APPLICATION.CFC.CBC.createBatchID(
			companyID=qGetCompany.companyID,
			userID=CLIENT.userid,
			cbcTotal=qGetCBCHost.recordcount,
			batchType='host'
		);	
	</cfscript>
    
	<cfloop query="qGetCBCHost"> 
	
	<cfscript>
		// Process Batch
		CBCStatus = APPLICATION.CFC.CBC.processBatch(
			companyID=qGetCompany.companyID,
			companyShort=qGetCompany.companyShort,
			batchID=newBatchID,
			userType=userType,
			hostID=hostid,
			CBCFamID=qGetCBCHost.CBCFamID,
			// XML variables
			username=qGetCompany.gis_username,
			password=qGetCompany.gis_password,
			account=qGetCompany.gis_account,
			SSN=Evaluate(usertype & 'ssn'),
			lastName=Evaluate(usertype & 'lastname'),
			firstName=Evaluate(usertype & 'firstname'),
			middleName=Left(Evaluate(usertype & 'middlename'),1),
			DOBYear=DateFormat(Evaluate(usertype & 'dob'), 'yyyy'),
			DOBMonth=DateFormat(Evaluate(usertype & 'dob'), 'mm'),
			DOBDay=DateFormat(Evaluate(usertype & 'dob'), 'dd'),
			noSummary='YES',
			includeDetails='YES'
		);	
	</cfscript>

	<table width="670" align="center" cellpadding="0" cellspacing="0">
		<th bgcolor="##CCCCCC">GIS - Criminal Background Check</th>
		<tr><td>Connecting to #CBCStatus.BGCDirectURL#...</td></tr>
	</table><br>

	<!--- SUBMIT XML --->
	<table width="670" align="center" cellpadding="0" cellspacing="0">
		<tr><td>Submitting CBC for #qGetCompany.companyshort# HF #usertype# - #Evaluate(usertype & "firstname")# #Evaluate(usertype & "lastname")# (###hostid#)</td></tr>
		<tr><td><b>Status: #CBCStatus.message#</b></td></tr>
	</table>

	<!--- Display Link to XML --->
    <table width="670" align="center" cellpadding="0" cellspacing="0">
        <tr><td>XML FILE <a href="#CBCStatus.sentFile#" target="_blank">Sent</a></td></tr>
        <tr><td>XML FILE <a href="#CBCStatus.receivedFile#" target="_blank">Received</a></td></tr>
    </table><br>
	
</cfloop>

<!--- 
	HOST MEMBERS 
--->  
<cfelse>

    <cfscript>
		// Get CBCs
		qGetCBCMember = APPLICATION.CFC.CBC.GetCBCMember(
			companyID=CLIENT.companyID,
			seasonID=FORM.seasonID
		);	

		// Set Missing Count
		missionCount = 0;
	</cfscript>  

	<cfif NOT VAL(qGetCBCMember.recordcount)>
		Sorry, there were no host members to populate the XML file at this time.
		<cfabort>
	</cfif>
	
	<cfloop query="qGetCBCMember">
		<cfif NOT LEN(qGetCBCMember.name)>
            First Name is missing for host member #qGetCBCMember.lastname# member of (###qGetCBCMember.hostid#). <br>
            <cfset missionCount = missionCount + 1>
		</cfif>
        
		<cfif NOT LEN(qGetCBCMember.lastname)>
            Last Name is missing for host member #qGetCBCMember.name# member of (###qGetCBCMember.hostid#). <br>
            <cfset missionCount = missionCount + 1>
		</cfif>
        
		<cfif NOT LEN(birthdate) OR NOT IsDate(qGetCBCMember.birthdate)>
            DOB is missing for host member #qGetCBCMember.name# #qGetCBCMember.lastname# member of (###qGetCBCMember.hostid#). <br>
            <cfset missionCount = missionCount + 1>
		</cfif>
        
		<cfif NOT LEN(qGetCBCMember.ssn)>
            SSN is missing for host member #qGetCBCMember.name# #qGetCBCMember.lastname# member of (###qGetCBCMember.hostid#). <br>
            <cfset missionCount = missionCount + 1>
		</cfif>
        
	</cfloop>
	
	<cfif VAL(missionCount)>
		<br>There are #missionCount# item(s). In order to continue please enter the information missing.
		<cfabort>
	</cfif>

	<cfscript>
		// Create a batch ID - It must be unique
		newBatchID = APPLICATION.CFC.CBC.createBatchID(
			companyID=qGetCompany.companyID,
			userID=CLIENT.userid,
			cbcTotal=qGetCBCMember.recordcount,
			batchType='host'
		);	
	</cfscript>

	<cfloop query="qGetCBCMember"> 
	
		<cfscript>
            // Process Batch
            CBCStatus = APPLICATION.CFC.CBC.processBatch(
                companyID=qGetCompany.companyID,
                companyShort=qGetCompany.companyShort,
                batchID=newBatchID,
                userType=userType,
                hostID=hostid,
                CBCFamID=qGetCBCMember.CBCFamID,
                // XML variables
                username=qGetCompany.gis_username,
                password=qGetCompany.gis_password,
                account=qGetCompany.gis_account,
                SSN=qGetCBCMember.ssn,
                lastName=qGetCBCMember.lastName,
                firstName=qGetCBCMember.name,
                middleName=Left(qGetCBCMember.middleName,1),
                DOBYear=DateFormat(qGetCBCMember.birthdate, 'yyyy'),
                DOBMonth=DateFormat(qGetCBCMember.birthdate, 'mm'),
                DOBDay=DateFormat(qGetCBCMember.birthdate, 'dd'),
                noSummary='YES',
                includeDetails='YES'
            );	
        </cfscript>

        <table width="670" align="center" cellpadding="0" cellspacing="0">
            <th bgcolor="##CCCCCC">GIS - Criminal Background Check</th>
            <tr><td>Connecting to #CBCStatus.BGCDirectURL#...</td></tr>
        </table><br>
    
        <!--- SUBMIT XML --->
        <table width="670" align="center" cellpadding="0" cellspacing="0">
            <tr><td>Submitting CBC for #qGetCompany.companyshort# HF #usertype# - #qGetCBCMember.name# #qGetCBCMember.lastName# (###hostid#)</td></tr>
            <tr><td><b>Status: #CBCStatus.message#</b></td></tr>
        </table>
    
        <!--- Display Link to XML --->
        <table width="670" align="center" cellpadding="0" cellspacing="0">
            <tr><td>XML FILE <a href="#CBCStatus.sentFile#" target="_blank">Sent</a></td></tr>
            <tr><td>XML FILE <a href="#CBCStatus.receivedFile#" target="_blank">Received</a></td></tr>
        </table><br>

	</cfloop>

</cfif>

</cfoutput>
</body>
</html>


<!---
<cfset thisPath=ExpandPath("*.*")>
<cfset thisDirectory=GetDirectoryFromPath(thisPath)>
The current directory is: #GetDirectoryFromPath(thisPath)#
<cfabort>
--->
