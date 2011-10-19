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
	
    <cfsetting requesttimeout="99999">
    
    <!--- Param Variables --->
    <cfparam name="userType" default="user">
    
    <cfscript>
		// Create Structure to store errors
		Errors = StructNew();
		// Create Array to store error messages
		Errors.Messages = ArrayNew(1);

		// Skip IDs List if any information is missing;
		skipUserIDs = 0;
		
		if ( userType EQ 'user' ) {
			// Get User CBCs
			qGetCBCUsers = APPLICATION.CFC.CBC.getPendingCBCUser(companyID=10);	
		} else {
			// Get Member CBCs
			qGetCBCUsers = APPLICATION.CFC.CBC.getPendingCBCUserMember(companyID=10);	
		}		
	</cfscript>
	
    <!--- Data Validation --->
    <cfloop query="qGetCBCUsers">
    
        <cfscript>
            //First Name
            if ( NOT LEN(qGetCBCUsers.firstName) ) {
                ArrayAppend(Errors.Messages, "Missing first name for #qGetCBCUsers.companyShort# - User - #firstName# #lastname# (###userid#).");			
                if ( NOT ListFind(skipUserIDs, qGetCBCUsers.userID) ) {
                    skipUserIDs = ListAppend(skipUserIDs, qGetCBCUsers.userID);
                }
            }
            // Last Name
            if ( NOT LEN(qGetCBCUsers.lastname) )  {
                ArrayAppend(Errors.Messages, "Missing last name for #qGetCBCUsers.companyShort# - User - #firstName# #lastname# (###userid#).");
                if ( NOT ListFind(skipUserIDs, qGetCBCUsers.userID) ) {
                    skipUserIDs = ListAppend(skipUserIDs, qGetCBCUsers.userID);
                }
            }
            // DOB
            if ( NOT LEN(qGetCBCUsers.dob) OR NOT IsDate(qGetCBCUsers.dob) )  {
                ArrayAppend(Errors.Messages, "Missing DOB for #qGetCBCUsers.companyShort# - User - #firstName# #lastname# (###userid#).");
                if ( NOT ListFind(skipUserIDs, qGetCBCUsers.userID) ) {
                    skipUserIDs = ListAppend(skipUserIDs, qGetCBCUsers.userID);
                }
            }
            // SSN
            if ( NOT LEN(qGetCBCUsers.ssn) )  {
                ArrayAppend(Errors.Messages, "Missing SSN for #qGetCBCUsers.companyShort# - User - #firstName# #lastname# (###userid#).");
                if ( NOT ListFind(skipUserIDs, qGetCBCUsers.userID) ) {
                    skipUserIDs = ListAppend(skipUserIDs, qGetCBCUsers.userID);
                }
            }
        </cfscript>
    
    </cfloop>

</cfsilent>

<cfoutput>

<table width="70%" cellpadding="2" style="margin-top:20px; margin-bottom:20px; border:1px solid ##CCCCCC">
	<tr bgcolor="##CCCCCC"><td colspan="4"><b>Run Expired CBCs for #userType#</b></td></tr>

	<cfif NOT VAL(qGetCBCUsers.recordcount)>
        <tr><td>Sorry, there were no users to populate the XML file at this time.</td></tr>
    </cfif>

	<!--- Display Errors --->
    <cfif VAL(ArrayLen(Errors.Messages))>
        
        <cfsavecontent variable="errorMessage">
            <p>Scheduled <cfif userType EQ 'member'>User</cfif> #userType# CBCs</p>
            
            <font color="##FF0000">Please review the following issues:</font> <br />
        
            <cfloop from="1" to="#ArrayLen(Errors.Messages)#" index="i">
                <p>#Errors.Messages[i]#</p>       	
            </cfloop>
        </cfsavecontent>
        
        <!--- Display Errors --->
        <tr><td>#errorMessage#</td></tr>
        
        <!--- Email Errors --->
        <cfmail 
            from="#APPLICATION.EMAIL.support#"
            to="#APPLICATION.EMAIL.cbcCaseNotifications#" 
            subject="Scheduled CBC #userType# Issues"
            type="html">
                <table width="70%" cellpadding="2" style="margin-top:20px; margin-bottom:20px; border:1px solid ##CCCCCC">
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
    
        <cfloop query="qGetCBCUsers">
    
            <cfscript>
                // Process Batch
                CBCStatus = APPLICATION.CFC.CBC.processBatch(
                    companyID=VAL(qGetCBCUsers.companyID),
                    companyShort=qGetCBCUsers.companyShort,
                    userType=userType,
                    userID=qGetCBCUsers.userID,
                    cbcID=qGetCBCUsers.cbcID,
                    // XML variables
                    username=qGetCBCUsers.gis_username,
                    password=qGetCBCUsers.gis_password,
                    account=qGetCBCUsers.gis_account,
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
            <tr><td>Submitting CBC for #qGetCBCUsers.companyshort# #userType# - #qGetCBCUsers.firstName# #qGetCBCUsers.lastName# (###userID#)</td></tr>
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
