<!--- ------------------------------------------------------------------------- ----
	
	File:		create_xml_users_gis.cfm
	Author:		Marcus Melo
	Date:		November 24, 2009
	Desc:		User CBC Management

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

    <cfsetting requestTimeOut = "999">
	
	<cfparam name="FORM.userType" default="">
    <cfparam name="FORM.seasonID" default="0">
    
    <cfscript>
		// Gets Current Company
		qGetCompany = APPLICATION.CFC.COMPANY.getCompanies(companyID=CLIENT.companyID);
	
		// Create Structure to store errors
		Errors = StructNew();
		// Create Array to store errors messages
		Errors.Messages = ArrayNew(1);

		// Skip IDs List if any information is missing;
		skipUserIDs = '';
	</cfscript>

</cfsilent>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>CBC Users</title>
</head>

<body>

<cfoutput>

<cfif NOT LEN(FORM.usertype) OR NOT VAL(FORM.seasonID)>
	You must select a usertype or a season in order to run the batch. Please go back and try again.
	<cfabort>
</cfif>

<!--- OFFICE AND REP USERS --->
<cfif FORM.userType EQ 'user'>
	
    <cfscript>
		// Get CBCs
		qGetCBCUsers = APPLICATION.CFC.CBC.getCBCUser(
			companyID=CLIENT.companyID,
			seasonID=FORM.seasonID
		);	
	</cfscript>  
    
<!--- REPS FAMILY MEMBERS --->
<cfelse>

    <cfscript>
		// Get CBCs
		qGetCBCUsers = APPLICATION.CFC.CBC.getCBCUserMember(
			companyID=CLIENT.companyID,
			seasonID=FORM.seasonID
		);	
	</cfscript>  
    
</cfif>

<cfif NOT VAL(qGetCBCUsers.recordcount)>
	Sorry, there were no users to populate the XML file at this time.
	<cfabort>
</cfif>

<cfloop query="qGetCBCUsers">

	<cfscript>
		// Data Validation
        if ( NOT LEN(qGetCBCUsers.firstName) ) {
            ArrayAppend(Errors.Messages, "First Name is missing for user #firstName# #lastname# (###userid#).");			
            if ( NOT ListFind(skipUserIDs, qGetCBCUsers.userID) ) {
                skipUserIDs = ListAppend(skipUserIDs, qGetCBCUsers.userID);
            }
        }
    
        if ( NOT LEN(qGetCBCUsers.lastname) )  {
            ArrayAppend(Errors.Messages, "Last Name is missing for user #firstName# #lastname# (###userid#).");
            if ( NOT ListFind(skipUserIDs, qGetCBCUsers.userID) ) {
                skipUserIDs = ListAppend(skipUserIDs, qGetCBCUsers.userID);
            }
        }
        
        if ( NOT LEN(qGetCBCUsers.dob) OR NOT IsDate(qGetCBCUsers.dob) )  {
            ArrayAppend(Errors.Messages, "DOB is missing for user #firstName# #lastname# (###userid#).");
            if ( NOT ListFind(skipUserIDs, qGetCBCUsers.userID) ) {
                skipUserIDs = ListAppend(skipUserIDs, qGetCBCUsers.userID);
            }
        }

        if ( NOT LEN(qGetCBCUsers.ssn) )  {
            ArrayAppend(Errors.Messages, "SSN is missing for user #firstName# #lastname# (###userid#).");
            if ( NOT ListFind(skipUserIDs, qGetCBCUsers.userID) ) {
                skipUserIDs = ListAppend(skipUserIDs, qGetCBCUsers.userID);
            }
        }
    </cfscript>

</cfloop>

<!--- Display Errors --->
<cfif VAL(ArrayLen(Errors.Messages))>
	<table width="670" align="center" cellpadding="0" cellspacing="0">
		<tr>
			<td>
				<font color="##FF0000">Please review the following items:</font> <br>

				<cfloop from="1" to="#ArrayLen(Errors.Messages)#" index="i">
					#Errors.Messages[i]# <br>        	
				</cfloop>
			</td>
		</tr>
	</table> <br><br>                          
</cfif>	

<!--- Check if there are records --->    
<cfif qGetCBCUsers.recordcount GT ListLen(skipUserIDs)>

	<!--- Filter Query - Get only records that do not have any problems --->
    <cfquery name="qGetCBCUsers" dbtype="query">
        SELECT 
            *
        FROM	
            qGetCBCUsers
         WHERE	
            userID NOT IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(skipUserIDs)#" list="yes">)
    </cfquery>
    
    <cfscript>
        // Create a batch ID - It must be unique
        newBatchID = APPLICATION.CFC.CBC.createBatchID(
            companyID=qGetCompany.companyID,
            userID=CLIENT.userid,
            cbcTotal=qGetCBCUsers.recordcount,
            batchType='user'
        );	
    </cfscript>

    <cfloop query="qGetCBCUsers"> 

        <cfscript>
            // Process Batch
            CBCStatus = APPLICATION.CFC.CBC.processBatch(
                companyID=qGetCompany.companyID,
                companyShort=qGetCompany.companyShort,
                batchID=newBatchID,
                userType=FORM.userType
                userID=qGetCBCUsers.userID,
                cbcID=qGetCBCUsers.cbcID,
                // XML variables
                username=qGetCompany.gis_username,
                password=qGetCompany.gis_password,
                account=qGetCompany.gis_account,
                SSN=qGetCBCUsers.ssn,
                lastName=qGetCBCUsers.lastName,
                firstName=qGetCBCUsers.firstName,
                middleName=Left(qGetCBCUsers.middleName,1),
                DOBYear=DateFormat(qGetCBCUsers.dob, 'yyyy'),
                DOBMonth=DateFormat(qGetCBCUsers.dob, 'mm'),
                DOBDay=DateFormat(qGetCBCUsers.dob, 'dd'),
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
            <tr><td>Submitting CBC for #qGetCompany.companyshort# User - #qGetCBCUsers.firstName# #qGetCBCUsers.lastName# (###userID#)</td></tr>
            <tr><td><b>Status: #CBCStatus.message#</b></td></tr>
        </table>
    
        <!--- Display Link to XML --->
        <cfif CBCStatus.message EQ 'success'>
        <table width="670" align="center" cellpadding="0" cellspacing="0">
            <!--- <tr><td>XML FILE <a href="#CBCStatus.sentFile#" target="_blank">Sent</a></td></tr> --->
            <tr><td>XML FILE <a href="view_user_cbc.cfm?userID=#qGetCBCUsers.userID#&batchID=#newBatchID#" target="_blank">Received</a></td></tr>
        </table><br>
		</cfif>
            
    </cfloop>

</cfif> <!--- Check if there are records --->  

</cfoutput>
</body>
</html>
