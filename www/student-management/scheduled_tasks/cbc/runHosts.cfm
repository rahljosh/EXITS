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

<table width="70%" cellpadding="2" style="margin-top:20px; margin-bottom:20px; border:1px solid ##CCCCCC">
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
            
        </cfif>	
        
        <!--- Filter Query - Get only records that do not have any problems --->
        <cfquery name="qGetCBCHostNoErrors" dbtype="query">
            SELECT 
                *
            FROM	
                qGetCBCHost
             WHERE	
                hostID NOT IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#skipHostIDs#" list="yes">)            
        </cfquery>
    
        <!--- Check if there are records --->    
        <cfif qGetCBCHostNoErrors.recordcount>
                   
            <cfloop query="qGetCBCHostNoErrors"> 
            
				<cfscript>
                    // Process Batch
                    CBCStatus = APPLICATION.CFC.CBC.processBatch(
                        companyID=VAL(qGetCBCHostNoErrors.companyID),
                        companyShort=qGetCBCHostNoErrors.companyShort,
                        userType=userType,
                        hostID=qGetCBCHostNoErrors.hostID,
                        cbcID=qGetCBCHostNoErrors.CBCFamID,
                        // XML variables
                        username=qGetCBCHostNoErrors.gis_username,
                        password=qGetCBCHostNoErrors.gis_password,
                        account=qGetCBCHostNoErrors.gis_account,
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
                <tr><td>Submitting CBC for #qGetCBCHostNoErrors.companyshort# HF #userType# - #Evaluate(userType & "firstname")# #Evaluate(userType & "lastname")# (###qGetCBCHostNoErrors.hostid#)</td></tr>
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
                        <table width="70%" cellpadding="2" style="margin-top:20px; margin-bottom:20px; border:1px solid ##CCCCCC">
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
        <cfquery name="qGetNoErrorsCBCMember" dbtype="query">
            SELECT 
                *
            FROM	
                qGetCBCMember
             WHERE	
                cbcfamID NOT IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#skipMemberIDs#" list="yes">)
        </cfquery>
    
        <!--- Check if there are records --->    
        <cfif qGetNoErrorsCBCMember.recordcount>
        
            <cfloop query="qGetNoErrorsCBCMember"> 
    
                <cfscript>
                    // Process Batch
                    CBCStatus = APPLICATION.CFC.CBC.processBatch(
                        companyID=VAL(qGetNoErrorsCBCMember.companyID),
                        companyShort=qGetNoErrorsCBCMember.companyShort,
                        userType=userType,
                        hostID=qGetNoErrorsCBCMember.hostID,
                        cbcID=qGetNoErrorsCBCMember.CBCFamID,
                        // XML variables
                        username=qGetNoErrorsCBCMember.gis_username,
                        password=qGetNoErrorsCBCMember.gis_password,
                        account=qGetNoErrorsCBCMember.gis_account,
                        SSN=qGetNoErrorsCBCMember.ssn,
                        lastName=qGetNoErrorsCBCMember.lastName,
                        firstName=qGetNoErrorsCBCMember.name,
                        middleName=Left(qGetNoErrorsCBCMember.middleName,1),
                        DOBYear=DateFormat(qGetNoErrorsCBCMember.birthdate, 'yyyy'),
                        DOBMonth=DateFormat(qGetNoErrorsCBCMember.birthdate, 'mm'),
                        DOBDay=DateFormat(qGetNoErrorsCBCMember.birthdate, 'dd'),
                        isReRun=1
                    );	
                </cfscript>
        
                <!--- SUBMIT XML --->
                <tr><td>Connecting to #CBCStatus.BGCDirectURL#...</td></tr>
                <tr><td>Submitting CBC for #qGetNoErrorsCBCMember.companyshort# Host #userType# - #qGetNoErrorsCBCMember.name# #qGetNoErrorsCBCMember.lastName# (###qGetNoErrorsCBCMember.hostid#)</td></tr>
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
