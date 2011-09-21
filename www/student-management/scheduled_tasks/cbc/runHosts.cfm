<!--- ------------------------------------------------------------------------- ----
	
	File:		runHosts.cfm
	Author:		Marcus Melo
	Date:		May 20, 2010
	Desc:		Scheduled CBCs
				Based on create_xml_hosts_gis.cfm

	Updated:  						

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<cfparam name="userType" default="father">
    
	<cfscript>	
		// Create Structure to store errors
		Errors = StructNew();
		// Create Array to store error messages
		Errors.Messages = ArrayNew(1);

		// Skip IDs List if any information is missing;
		skipHostIDs = 0;
		skipMemberIDs = 0;
	</cfscript>

</cfsilent>

<cfoutput>

<table width="70%" cellpadding="2" frame="box" style="margin-top:10px; margin-bottom:10px;">
	<tr bgcolor="##CCCCCC"><td colspan="4"><b>Run Expired CBCs for Host #userType#</b></td></tr>

	<!--- 
        HOSTS PARENTS 
    --->
    <cfif userType NEQ 'member'>   
        
        <cfscript>
            // Get CBCs
            qGetCBCHost = APPLICATION.CFC.CBC.getPendingCBCHost(userType=userType);	
        </cfscript>  
    
        <!--- NO CBC FOUND ---> 
        <cfif NOT VAL(qGetCBCHost.recordcount)>
            <tr><td>Sorry, there were no host #userType# to populate the XML file at this time.</td></tr>
        </cfif>
    
        <!--- Data Validation --->
        <cfloop	query="qGetCBCHost">
            
            <cfscript>
                // Data Validation
                // First Name
                if ( NOT LEN(Evaluate(userType & "firstname")) ) {
                    ArrayAppend(Errors.Messages, "Missing first name for #qGetCBCHost.companyShort# - host #userType# #Evaluate(userType & "lastname")# (###qGetCBCHost.hostid#).");			
                    if ( NOT ListFind(skipHostIDs, qGetCBCHost.hostID) ) {
                        skipHostIDs = ListAppend(skipHostIDs, qGetCBCHost.hostID);
                    }
                }
                // Last Name
                if ( NOT LEN(Evaluate(userType & "lastname")) )  {
                    ArrayAppend(Errors.Messages, "Missing last name for #qGetCBCHost.companyShort# - host #userType# #Evaluate(userType & "firstname")# (###qGetCBCHost.hostid#).");
                    if ( NOT ListFind(skipHostIDs, qGetCBCHost.hostID) ) {
                        skipHostIDs = ListAppend(skipHostIDs, qGetCBCHost.hostID);
                    }
                }
                // DOB
                if ( NOT LEN(Evaluate(userType & "dob")) OR NOT IsDate(Evaluate(userType & "dob")) )  {
                    ArrayAppend(Errors.Messages, "DOB is missing or is not a valid date for #qGetCBCHost.companyShort# - host #userType# #Evaluate(userType & "firstname")# #Evaluate(userType & "lastname")# (###qGetCBCHost.hostid#).");
                    if ( NOT ListFind(skipHostIDs, qGetCBCHost.hostID) ) {
                        skipHostIDs = ListAppend(skipHostIDs, qGetCBCHost.hostID);
                    }
                }
                // SSN
                if ( NOT LEN(Evaluate(userType & "ssn")) )  {
                    ArrayAppend(Errors.Messages, "Missing SSN for #qGetCBCHost.companyShort# - host #userType# #Evaluate(userType & "firstname")# #Evaluate(userType & "lastname")# (###qGetCBCHost.hostid#).");
                    if ( NOT ListFind(skipHostIDs, qGetCBCHost.hostID) ) {
                        skipHostIDs = ListAppend(skipHostIDs, qGetCBCHost.hostID);
                    }
                }
            </cfscript>
            
        </cfloop>
    
        <!--- Display Errors --->
        <cfif VAL(ArrayLen(Errors.Messages))>
            
            <cfsavecontent variable="errorMessage">
                <p>Scheduled Host #userType# CBCs</p>
                
                <font color="##FF0000">Please review the following issues:</font> <br />
            
                <cfloop from="1" to="#ArrayLen(Errors.Messages)#" index="i">
                    #Errors.Messages[i]# <br>        	
                </cfloop>
            </cfsavecontent>
        
			<!--- Display Errors --->
            <tr><td>#errorMessage#</td></tr>

			<!--- Email Errors | Email only once --->
            <cfif VAL(isUpcomingProgram)>
            
                <cfmail 
                    from="#APPLICATION.EMAIL.support#"
                    to="#APPLICATION.EMAIL.cbcNotifications#"
                    subject="Scheduled CBC Host #userType# Issues"
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
                    CBCStatus = APPLICATION.CFC.CBC.processBatch(
                        companyID=VAL(qGetCBCHost.companyID),
                        companyShort=qGetCBCHost.companyShort,
                        userType=userType,
                        hostID=qGetCBCHost.hostID,
                        cbcID=qGetCBCHost.CBCFamID,
                        // XML variables
                        username=qGetCBCHost.gis_username,
                        password=qGetCBCHost.gis_password,
                        account=qGetCBCHost.gis_account,
                        SSN=Evaluate(usertype & 'ssn'),
                        lastName=Evaluate(usertype & 'lastname'),
                        firstName=Evaluate(usertype & 'firstname'),
                        middleName=Left(Evaluate(usertype & 'middlename'),1),
                        DOBYear=DateFormat(Evaluate(usertype & 'dob'), 'yyyy'),
                        DOBMonth=DateFormat(Evaluate(usertype & 'dob'), 'mm'),
                        DOBDay=DateFormat(Evaluate(usertype & 'dob'), 'dd'),
                        isReRun=1
                    );	
                </cfscript>
            
                <!--- SUBMIT XML --->
                <tr><td>Connecting to #CBCStatus.BGCDirectURL#...</td></tr>
                <tr><td>Submitting CBC for #qGetCBCHost.companyshort# HF #userType# - #Evaluate(userType & "firstname")# #Evaluate(userType & "lastname")# (###qGetCBCHost.hostid#)</td></tr>
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
    
    <!--- 
        HOST MEMBERS 
    --->  
    <cfelse>
    
        <cfscript>
            // Get CBCs
            qGetCBCMember = APPLICATION.CFC.CBC.getPendingCBCHostMember();	
        </cfscript>  
    
	    <cfif NOT VAL(qGetCBCMember.recordcount)>
            <tr><td>Sorry, there were no host #userType# to populate the XML file at this time.</td></tr>
        </cfif>

        <cfloop query="qGetCBCMember">
            
            <cfscript>
                // Data Validation
                if ( NOT LEN(qGetCBCMember.name) ) {
                    ArrayAppend(Errors.Messages, "Missing first name for #qGetCBCMember.companyShort# - #qGetCBCMember.lastname# member of host family (###qGetCBCMember.hostid#).");			
                    if ( NOT ListFind(skipMemberIDs, qGetCBCMember.cbcfamID) ) {
                        skipMemberIDs = ListAppend(skipMemberIDs, qGetCBCMember.cbcfamID);
                    }
                }
            
                if ( NOT LEN(qGetCBCMember.lastname) )  {
                    ArrayAppend(Errors.Messages, "Missing last name for #qGetCBCMember.companyShort# - #qGetCBCMember.name# member of host family (###qGetCBCMember.hostid#).");
                    if ( NOT ListFind(skipMemberIDs, qGetCBCMember.cbcfamID) ) {
                        skipMemberIDs = ListAppend(skipMemberIDs, qGetCBCMember.cbcfamID);
                    }
                }
                
                if ( NOT LEN(qGetCBCMember.birthdate) OR NOT IsDate(qGetCBCMember.birthdate) )  {
                    ArrayAppend(Errors.Messages, "Missing DOB for #qGetCBCMember.companyShort# - #qGetCBCMember.name# #qGetCBCMember.lastname# member of host family (###qGetCBCMember.hostid#).");
                    if ( NOT ListFind(skipMemberIDs, qGetCBCMember.cbcfamID) ) {
                        skipMemberIDs = ListAppend(skipMemberIDs, qGetCBCMember.cbcfamID);
                    }
                }
    
                if ( NOT LEN(qGetCBCMember.ssn) )  {
                    ArrayAppend(Errors.Messages, "Missing SSN for #qGetCBCMember.companyShort# - #qGetCBCMember.name# #qGetCBCMember.lastname# member of host family (###qGetCBCMember.hostid#).");
                    if ( NOT ListFind(skipMemberIDs, qGetCBCMember.cbcfamID) ) {
                        skipMemberIDs = ListAppend(skipMemberIDs, qGetCBCMember.cbcfamID);
                    }
                }
            </cfscript>
            
        </cfloop>
    
        <!--- Display Errors --->
        <cfif VAL(ArrayLen(Errors.Messages))>

            <cfsavecontent variable="errorMessage">
                <p>Scheduled Host #userType# CBCs</p>
                
                <font color="##FF0000">Please review the following issues:</font> <br />
            
                <cfloop from="1" to="#ArrayLen(Errors.Messages)#" index="i">
                    #Errors.Messages[i]# <br>        	
                </cfloop>
            </cfsavecontent>
        
			<!--- Display Errors --->
            <tr><td>#errorMessage#</td></tr>

			<!--- Email Errors | Email only once --->
            <cfif VAL(isUpcomingProgram)>
    
                <!--- Email Errors --->
                <cfmail 
                    from="#APPLICATION.EMAIL.support#"
                    to="#APPLICATION.EMAIL.cbcNotifications#"
                    subject="Scheduled CBC Host #userType# Issues"
                    type="html">
                        <table width="70%" cellpadding="2" frame="box" style="margin-top:10px; margin-bottom:10px;">
                            <tr>
                                <td>
                                    <cfif APPLICATION.isServerLocal>
                                        <p>DEVELOPMENT SERVER</p>
                                    </cfif>
                                    
                                    <!--- Include Error Message --->
                                    <p>#errorMessage#</p>
                                </td>
                            </tr>
                        </table>   
                </cfmail>
			
            </cfif>
            
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
                    CBCStatus = APPLICATION.CFC.CBC.processBatch(
                        companyID=VAL(qGetCBCHost.companyID),
                        companyShort=qGetCBCHost.companyShort,
                        userType=userType,
                        hostID=qGetCBCMember.hostID,
                        cbcID=qGetCBCMember.CBCFamID,
                        // XML variables
                        username=qGetCBCHost.gis_username,
                        password=qGetCBCHost.gis_password,
                        account=qGetCBCHost.gis_account,
                        SSN=qGetCBCMember.ssn,
                        lastName=qGetCBCMember.lastName,
                        firstName=qGetCBCMember.name,
                        middleName=Left(qGetCBCMember.middleName,1),
                        DOBYear=DateFormat(qGetCBCMember.birthdate, 'yyyy'),
                        DOBMonth=DateFormat(qGetCBCMember.birthdate, 'mm'),
                        DOBDay=DateFormat(qGetCBCMember.birthdate, 'dd'),
                        isReRun=1
                    );	
                </cfscript>
        
                <!--- SUBMIT XML --->
                <tr><td>Connecting to #CBCStatus.BGCDirectURL#...</td></tr>
                <tr><td>Submitting CBC for #qGetCBCHost.companyshort# Host #userType# - #qGetCBCMember.name# #qGetCBCMember.lastName# (###qGetCBCMember.hostid#)</td></tr>
                <tr>
                    <td>
                        <b>Status: #CBCStatus.message#</b>
                        <!--- Display Link to Results --->
                        <cfif CBCStatus.message EQ 'success'> 
                            &nbsp; - &nbsp; <a href="#CBCStatus.URLResults#" target="_blank">See Results</a>
                        </cfif>                        
                    </td>
                </tr>
            </cfloop>
    
        </cfif> <!--- Check if there are records --->  
    
    </cfif>

</cfoutput>
