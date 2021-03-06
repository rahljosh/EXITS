<!--- ------------------------------------------------------------------------- ----
	
	File:		create_xml_hosts_nossn.cfm
	Author:		Marcus Melo
	Date:		December 08, 2009
	Desc:		Host CBC Management

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

    <cfsetting requestTimeOut = "999">
	
	<cfparam name="FORM.userType" default="">
    <cfparam name="FORM.seasonID" default="0">
    
    <cfscript>
		// Gets Current Company
		qGetCompany = APPCFC.COMPANY.getCompanies(companyID=CLIENT.companyID);
		
		// Create Structure to store errors
		Errors = StructNew();
		// Create Array to store error messages
		Errors.Messages = ArrayNew(1);

		// Skip IDs List if any information is missing;
		skipHostIDs = 0;
		skipMemberIDs = 0;
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

<table width="700" align="center" cellpadding="0" cellspacing="0">
    <th bgcolor="##CCCCCC">GIS - Criminal Background Check</th>
</table> <br />

<cfif NOT LEN(FORM.usertype) OR NOT VAL(FORM.seasonID)>
    <table width="700" align="center" cellpadding="0" cellspacing="0">
        <td>You must select a usertype and a season in order to run the batch. Please go back and try again.</td>
    </table>
	<cfabort>
</cfif>

<!--- 
	HOSTS PARENTS 
--->
<cfif form.usertype NEQ 'member'>

    <cfscript>
		// Get CBCs
		qGetCBCHost = APPCFC.CBC.getPendingCBCHost(
			companyID=CLIENT.companyID,
			seasonID=FORM.seasonID,
			userType=FORM.usertype,
			noSSN=1
		);	
	</cfscript>  

	<!--- NO CBC FOUND ---> 
	<cfif NOT VAL(qGetCBCHost.recordcount)>
		Sorry, there were no users to populate the XML file at this time.
		<cfabort>
	</cfif>

	<!--- Data Validation --->
	<cfloop	query="qGetCBCHost">
    	
        <cfscript>
			// Data Validation
			// First Name
			if ( NOT LEN(Evaluate(FORM.userType & "firstname")) ) {
				ArrayAppend(Errors.Messages, "Missing first name for host #FORM.userType# #Evaluate(FORM.userType & "lastname")# (###qGetCBCHost.hostid#).");			
				if ( NOT ListFind(skipHostIDs, qGetCBCHost.hostID) ) {
					skipHostIDs = ListAppend(skipHostIDs, qGetCBCHost.hostID);
				}
			}
			// Last Name
			if ( NOT LEN(Evaluate(FORM.userType & "lastname")) )  {
				ArrayAppend(Errors.Messages, "Missing last name for host #FORM.userType# #Evaluate(FORM.userType & "firstname")# (###qGetCBCHost.hostid#).");
				if ( NOT ListFind(skipHostIDs, qGetCBCHost.hostID) ) {
					skipHostIDs = ListAppend(skipHostIDs, qGetCBCHost.hostID);
				}
			}
			// DOB
			if ( NOT LEN(Evaluate(FORM.userType & "dob")) OR NOT IsDate(Evaluate(FORM.userType & "dob")) )  {
				ArrayAppend(Errors.Messages, "DOB is missing or is not a valid date for host #FORM.userType# #Evaluate(FORM.userType & "firstname")# #Evaluate(FORM.userType & "lastname")# (###qGetCBCHost.hostid#).");
				if ( NOT ListFind(skipHostIDs, qGetCBCHost.hostID) ) {
					skipHostIDs = ListAppend(skipHostIDs, qGetCBCHost.hostID);
				}
			}
		</cfscript>
		
	</cfloop>

	<!--- Display Errors --->
	<cfif VAL(ArrayLen(Errors.Messages))>
		<table width="700" align="center" cellpadding="0" cellspacing="0">
        	<tr>
            	<td>
			        <font color="##FF0000">Please review the following items:</font> <br>
	
                    <cfloop from="1" to="#ArrayLen(Errors.Messages)#" index="i">
                        #Errors.Messages[i]# <br>        	
                    </cfloop>
				</td>
			</tr>
		</table>  <br /><br />                                
	</cfif>	

	<!--- Filter Query - Get only records that do not have any problems --->
    <cfquery name="qGetCBCHost" dbtype="query">
        SELECT 
            *
        FROM	
            qGetCBCHost
         WHERE	
            hostID NOT IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#skipHostIDs#" list="yes">)            
    </cfquery>

	<!--- Check if there are records --->    
    <cfif qGetCBCHost.recordcount>
               
        <cfloop query="qGetCBCHost"> 
        
			<cfscript>
                // Process Batch
                CBCStatus = APPCFC.CBC.processBatch(
                    companyID=qGetCompany.companyID,
                    companyShort=qGetCompany.companyShort,
                    userType=FORM.userType,
                    hostID=qGetCBCHost.hostID,
                    cbcID=qGetCBCHost.CBCFamID,
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
					noSSN=1
                );	
            </cfscript>
        
            <!--- SUBMIT XML --->
            <table width="700" align="center" cellpadding="0" cellspacing="0">
                <tr><td>Connecting to #CBCStatus.BGCDirectURL#...</td></tr>
                <tr><td>Submitting CBC for #qGetCompany.companyshort# Host #FORM.userType# - #Evaluate(FORM.userType & "firstname")# #Evaluate(FORM.userType & "lastname")# (###qGetCBCHost.hostid#)</td></tr>
                <tr>
                	<td>
                		<strong>Status: </strong> #CBCStatus.message#
                        <!--- Display Link to Results --->
						<cfif CBCStatus.message EQ 'success'> 
                        	&nbsp; - &nbsp; <a href="#CBCStatus.URLResults#" target="_blank">See Results</a>
                        </cfif>                        
                 	</td>
                </tr>
            </table> <br />

		</cfloop>

    </cfif> <!--- Check if there are records ---> 

	
<!--- 
	HOST MEMBERS 
--->  
<cfelse>

    <cfscript>
		// Get CBCs
		qGetCBCMember = APPCFC.CBC.getPendingCBCHostMember(
			companyID=CLIENT.companyID,
			seasonID=FORM.seasonID,
			noSSN=1
		);	
	</cfscript>  

	<cfif NOT VAL(qGetCBCMember.recordcount)>
		Sorry, there were no host members to populate the XML file at this time.
		<cfabort>
	</cfif>
	
	<cfloop query="qGetCBCMember">
		
        <cfscript>
			// Data Validation
			if ( NOT LEN(qGetCBCMember.name) ) {
				ArrayAppend(Errors.Messages, "Missing first name for #qGetCBCMember.lastname# member of (###qGetCBCMember.hostid#).");			
				if ( NOT ListFind(skipMemberIDs, qGetCBCMember.cbcfamID) ) {
					skipMemberIDs = ListAppend(skipMemberIDs, qGetCBCMember.cbcfamID);
				}
			}
		
			if ( NOT LEN(qGetCBCMember.lastname) )  {
				ArrayAppend(Errors.Messages, "Missing last name for #qGetCBCMember.name# member of (###qGetCBCMember.hostid#).");
				if ( NOT ListFind(skipMemberIDs, qGetCBCMember.cbcfamID) ) {
					skipMemberIDs = ListAppend(skipMemberIDs, qGetCBCMember.cbcfamID);
				}
			}
			
			if ( NOT LEN(qGetCBCMember.birthdate) OR NOT IsDate(qGetCBCMember.birthdate) )  {
				ArrayAppend(Errors.Messages, "Missing DOB for #qGetCBCMember.name# #qGetCBCMember.lastname# member of (###qGetCBCMember.hostid#).");
				if ( NOT ListFind(skipMemberIDs, qGetCBCMember.cbcfamID) ) {
					skipMemberIDs = ListAppend(skipMemberIDs, qGetCBCMember.cbcfamID);
				}
			}
		</cfscript>
		
	</cfloop>

	<!--- Display Errors --->
	<cfif VAL(ArrayLen(Errors.Messages))>
		<table width="700" align="center" cellpadding="0" cellspacing="0">
        	<tr>
            	<td>
			        <font color="##FF0000">Please review the following items:</font> <br>
	
                    <cfloop from="1" to="#ArrayLen(Errors.Messages)#" index="i">
                        #Errors.Messages[i]# <br>        	
                    </cfloop>
				</td>
			</tr>
		</table>                        
	</cfif>	

	<!--- Filter Query - Get only records that do not have any problems --->
    <cfquery name="qGetCBCMember" dbtype="query">
        SELECT 
            *
        FROM	
            qGetCBCMember
         WHERE	
            cbcfamID NOT IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#skipMemberIDs#" list="yes">)
    </cfquery>

	<!--- Check if there are records --->    
    <cfif qGetCBCMember.recordcount>
    
        <cfloop query="qGetCBCMember"> 

			<cfscript>
                // Process Batch
                CBCStatus = APPCFC.CBC.processBatch(
                    companyID=qGetCompany.companyID,
                    companyShort=qGetCompany.companyShort,
                    userType=FORM.userType,
                    hostID=qGetCBCMember.hostID,
                    cbcID=qGetCBCMember.CBCFamID,
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
					noSSN=1
                );	
            </cfscript>
           
            <!--- SUBMIT XML --->
            <table width="700" align="center" cellpadding="0" cellspacing="0">
                <tr><td>Connecting to #CBCStatus.BGCDirectURL#...</td></tr>
                <tr><td>Submitting CBC for #qGetCompany.companyshort# Host #FORM.userType# - #qGetCBCMember.name# #qGetCBCMember.lastName# (###qGetCBCMember.hostid#)</td></tr>
                <tr>
                	<td>
                		<strong>Status: </strong> #CBCStatus.message#
                        <!--- Display Link to Results --->
						<cfif CBCStatus.message EQ 'success'> 
                        	&nbsp; - &nbsp; <a href="#CBCStatus.URLResults#" target="_blank">See Results</a>
                        </cfif>                        
                 	</td>
                </tr>
            </table> <br />
        
        </cfloop>

	</cfif> <!--- Check if there are records --->  

</cfif>

</cfoutput>
</body>
</html>