<!--- ------------------------------------------------------------------------- ----
	
	File:		runUsers.cfm
	Author:		Marcus Melo
	Date:		May 20, 2010
	Desc:		Scheduled CBCs
				Based on create_xml_users_gis.cfm

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

    <!--- Param Variables --->
    <cfparam name="userType" default="">
    
    <cfscript>
		// Create Structure to store errors
		Errors = StructNew();
		// Create Array to store error messages
		Errors.Messages = ArrayNew(1);

		// Skip IDs List if any information is missing;
		skipUserIDs = 0;
		
		if ( userType EQ 'user' ) {
			// Get User CBCs
			qGetCBCUsers = APPLICATION.CFC.CBC.getPendingCBCUser();	
		} else {
			// Get Member CBCs
			qGetCBCUsers = APPLICATION.CFC.CBC.getPendingCBCUserMember();	
		}		
	</cfscript>
	
    <!--- Data Validation --->
    <cfloop query="qGetCBCUsers">
    
        <cfscript>
            //First Name
            if ( NOT LEN(qGetCBCUsers.firstName) ) {
                ArrayAppend(Errors.Messages, "First Name is missing for user #firstName# #lastname# (###userid#).");			
                if ( NOT ListFind(skipUserIDs, qGetCBCUsers.userID) ) {
                    skipUserIDs = ListAppend(skipUserIDs, qGetCBCUsers.userID);
                }
            }
            // Last Name
            if ( NOT LEN(qGetCBCUsers.lastname) )  {
                ArrayAppend(Errors.Messages, "Last Name is missing for user #firstName# #lastname# (###userid#).");
                if ( NOT ListFind(skipUserIDs, qGetCBCUsers.userID) ) {
                    skipUserIDs = ListAppend(skipUserIDs, qGetCBCUsers.userID);
                }
            }
            // DOB
            if ( NOT LEN(qGetCBCUsers.dob) OR NOT IsDate(qGetCBCUsers.dob) )  {
                ArrayAppend(Errors.Messages, "DOB is missing for user #firstName# #lastname# (###userid#).");
                if ( NOT ListFind(skipUserIDs, qGetCBCUsers.userID) ) {
                    skipUserIDs = ListAppend(skipUserIDs, qGetCBCUsers.userID);
                }
            }
            // SSN
            if ( NOT LEN(qGetCBCUsers.ssn) )  {
                ArrayAppend(Errors.Messages, "SSN is missing for user #firstName# #lastname# (###userid#). <br> NOTE: Please run it manually.");
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

<table width="70%" cellpadding="2" frame="box" style="margin-top:10px; margin-bottom:10px;">
	<tr bgcolor="##CCCCCC"><td colspan="4"><b>Run Expired CBCs for #userType#</b></td></tr>

	<cfif NOT VAL(qGetCBCUsers.recordcount)>
        <tr><td>Sorry, there were no users to populate the XML file at this time.</td></tr>
        <cfabort>
    </cfif>

	<!--- Display Errors --->
    <cfif VAL(ArrayLen(Errors.Messages))>
        
        <cfsavecontent variable="errorMessage">
            <p>Scheduled <cfif userType EQ 'member'>User</cfif> #userType# Re-Run CBCs</p>
            
            <font color="##FF0000">Please review the following issues:</font> <br />
        
            <cfloop from="1" to="#ArrayLen(Errors.Messages)#" index="i">
                #Errors.Messages[i]# <br>        	
            </cfloop>
        </cfsavecontent>
        
        <!--- Display Errors --->
        <tr><td>#errorMessage#</td></tr>
        
        <!--- Email Errors --->
        <cfmail 
            from="#APPLICATION.EMAIL.support#"
            to="#APPLICATION.EMAIL.support#" <!--- #qGetCompany.gis_email# / gary@iseusa.com --->
            subject="Scheduled CBC #userType# Re-Run Issues"
            type="html">
                <table width="70%" cellpadding="2" frame="box" style="margin-top:10px; margin-bottom:10px;">
                    <tr>
                        <td>
                            <cfif APPLICATION.isServerLocal>
                                <p>DEVELOPMENT SERVER</p>
                            </cfif>
                            
                            <!--- Include Error Message --->
                            #errorMessage#
                        </td>
                    </tr>
                </table>   
        </cfmail>
        
    </cfif>	

	<!--- Filter Query - Get only records that do not have any problems --->
    <cfquery name="qGetCBCUsers" dbtype="query">
        SELECT 
            *
        FROM	
            qGetCBCUsers
         WHERE	
            userID NOT IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#skipUserIDs#" list="yes"> )
    </cfquery>
    
    <!--- Check if there are records ---> 
    <cfif qGetCBCUsers.recordcount>
    
        <cfscript>
            // Create a batch ID - It must be unique
            newBatchID = APPLICATION.CFC.CBC.createBatchID(
                companyID=qGetCBCUsers.companyID,
                userID=CLIENT.userid,
                cbcTotal=qGetCBCUsers.recordcount,
                batchType='user'
            );	
        </cfscript>
    
        <cfloop query="qGetCBCUsers">
    
            <cfscript>
                // Gets Current Company
                qGetCompany = APPLICATION.CFC.COMPANY.getCompanies(companyID=qGetCBCUsers.companyID);
    
                // Process Batch
                CBCStatus = APPLICATION.CFC.CBC.processBatch(
                    companyID=qGetCompany.companyID,
                    companyShort=qGetCompany.companyShort,
                    batchID=newBatchID,
                    userType=userType,
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
                    isReRun=1
                );	
            </cfscript>
        
            <!--- SUBMIT XML --->
            <tr><td>Connecting to #CBCStatus.BGCDirectURL#...</td></tr>
            <tr><td>Submitting CBC for #qGetCompany.companyshort# #userType# - #qGetCBCUsers.firstName# #qGetCBCUsers.lastName# (###userID#)</td></tr>
            <tr>
                <td>
                    <strong>Status: </strong> #CBCStatus.message#
                    <!--- Display Link to Results --->
                    <cfif CBCStatus.message EQ 'success'> 
                        &nbsp; - &nbsp; <a href="#CBCStatus.URLResults#" target="_blank">See Results</a>
                    </cfif>                        
                </td>
            </tr>
        </cfloop>
    
    </cfif> <!--- Check if there are records --->  

</table>

</cfoutput>

</body>
</html>
