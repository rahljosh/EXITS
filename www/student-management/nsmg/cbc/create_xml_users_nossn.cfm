<!--- ------------------------------------------------------------------------- ----
	
	File:		create_xml_users_nossn.cfm
	Author:		Marcus Melo
	Date:		December 08, 2009
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
		qGetCompany = APPCFC.COMPANY.getCompanies(companyID=CLIENT.companyID);
	
		// Create Structure to store errors
		Errors = StructNew();
		// Create Array to store error messages
		Errors.Messages = ArrayNew(1);

		// Skip IDs List if any information is missing;
		skipUserIDs = 0;
		
		
		
		if ( userType EQ 'user' ) {
			// Get User CBCs
			qGetCBCUsers = APPCFC.CBC.getPendingCBCUser(
				companyID=CLIENT.companyID,
				seasonID=FORM.seasonID,
				noSSN=1
            );	
		} else {
			// Get Member CBCs
			qGetCBCUsers = APPCFC.CBC.getPendingCBCUserMember(
				companyID=CLIENT.companyID,
				seasonID=FORM.seasonID,
				noSSN=1
            );	
		}		
	</cfscript>
	
    <!--- Data Validation --->
    <cfloop query="qGetCBCUsers">
    
        <cfscript>
            //First Name
            if ( NOT LEN(qGetCBCUsers.firstName) ) {
                ArrayAppend(Errors.Messages, "Missing first name for user #firstName# #lastname# (###userid#).");			
                if ( NOT ListFind(skipUserIDs, qGetCBCUsers.userID) ) {
                    skipUserIDs = ListAppend(skipUserIDs, qGetCBCUsers.userID);
                }
            }
            // Last Name
            if ( NOT LEN(qGetCBCUsers.lastname) )  {
                ArrayAppend(Errors.Messages, "Missing last name for user #firstName# #lastname# (###userid#).");
                if ( NOT ListFind(skipUserIDs, qGetCBCUsers.userID) ) {
                    skipUserIDs = ListAppend(skipUserIDs, qGetCBCUsers.userID);
                }
            }
            // DOB
            if ( NOT LEN(qGetCBCUsers.dob) OR NOT IsDate(qGetCBCUsers.dob) )  {
                ArrayAppend(Errors.Messages, "Missing DOB for user #firstName# #lastname# (###userid#).");
                if ( NOT ListFind(skipUserIDs, qGetCBCUsers.userID) ) {
                    skipUserIDs = ListAppend(skipUserIDs, qGetCBCUsers.userID);
                }
            }
        </cfscript>
    
    </cfloop>
    
</cfsilent>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>CBC Users</title>
</head>
<body>

<cfoutput>

<table width="700" align="center" cellpadding="0" cellspacing="0">
    <th bgcolor="##CCCCCC">GIS - Criminal Background Check</th>
</table><br>

<cfif NOT LEN(FORM.usertype) OR NOT VAL(FORM.seasonID)>
    <table width="700" align="center" cellpadding="0" cellspacing="0">
        <td>You must select a usertype and a season in order to run the batch. Please go back and try again.</td>
    </table>
	<cfabort>
</cfif>

<cfif NOT VAL(qGetCBCUsers.recordcount)>
	Sorry, there were no users to populate the XML file at this time.
	<cfabort>
</cfif>

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
<cfquery name="qGetCBCUsers" dbtype="query">
	SELECT 
		*
	FROM	
		qGetCBCUsers
	 WHERE	
		userID NOT IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#skipUserIDs#" list="yes">)
</cfquery>

<!--- Check if there are records --->    
<cfif qGetCBCUsers.recordcount>
    
    <cfloop query="qGetCBCUsers"> 

        <cfscript>
            // Process Batch
            CBCStatus = APPCFC.CBC.processBatch(
                companyID=qGetCompany.companyID,
                companyShort=qGetCompany.companyShort,
                userType=FORM.userType,
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
				noSSN=1
            );	
        </cfscript>
    
        <!--- SUBMIT XML --->
        <table width="700" align="center" cellpadding="0" cellspacing="0">
       		<tr><td>Connecting to #CBCStatus.BGCDirectURL#...</td></tr>
            <tr><td>Submitting CBC for #qGetCompany.companyshort# User #FORM.userType# - #qGetCBCUsers.firstName# #qGetCBCUsers.lastName# (###userID#)</td></tr>
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

</cfoutput>

</body>
</html>
