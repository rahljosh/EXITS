<!--- ------------------------------------------------------------------------- ----
	
	File:		cbc.cfc
	Author:		Marcus Melo
	Date:		October, 09 2009
	Desc:		This holds the functions needed to run CBCs

----- ------------------------------------------------------------------------- --->

<cfcomponent 
	displayname="cbc"
	output="false" 
	hint="A collection of functions for the CBC">

	
    <!--- Return the initialized CBC object --->
	<cffunction name="Init" access="public" returntype="cbc" output="false" hint="Returns the initialized CBC object">
	
		<cfscript>	
			// Declare local variables
			decryptKey = 'BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR';
			decryptAlgorithm = 'desede';
			decryptEncoding = 'hex';

			// Server is Local - Set Up URL	
			if ( APPLICATION.isServerLocal ) {
				// DEVELOPMENT URL				
				BGCDirectURL = 'https://model.backgroundchecks.com/integration/bgcdirectpost.aspx';	
				BGCUser = 'smg1';
				BGCPassword = 'R3d3x##';
				BGCAccount = '10005542';
			// Server is Live - Set Up URL						
			} else {
				// PRODUCTION URL
				BGCDirectURL = 'https://direct.backgroundchecks.com/integration/bgcdirectpost.aspx';
				// stored in the database
				BGCUser = '';
				BGCPassword = '';
				BGCAccount = '';
			}
			
			// There is nothing really to initiate, so just return this
			return(this);
		</cfscript>
		
	</cffunction>

<!--- CBC Batch Functions --->
	<cffunction name="processBatch" access="public" returntype="struct" output="false" hint="Process XML Batch. Creates, submits and sends email">
        <cfargument name="companyID" type="numeric" required="yes">
        <cfargument name="userType" type="string" required="yes" hint="Father,Mother,User,Member">
        <cfargument name="hostID" type="numeric" default="0">
        <cfargument name="cbcID" type="string" default="0" hint="ID of smg_users_cbc or smg_hosts_cbc so we know which record we need to update">
        <cfargument name="userID" type="numeric" default="0">
        <cfargument name="username" type="string" required="yes">
        <cfargument name="password" type="string" required="yes">
        <cfargument name="account" type="string" required="yes">
        <cfargument name="SSN" type="string" required="yes">
        <cfargument name="lastName" type="string" required="yes">
        <cfargument name="firstName" type="string" required="yes">
        <cfargument name="middleName" type="string" required="yes">
        <cfargument name="DOBYear" type="numeric" required="yes">
        <cfargument name="DOBMonth" type="numeric" required="yes">
        <cfargument name="DOBDay" type="numeric" required="yes">
        <cfargument name="noSSN" type="numeric" default="0" hint="Optional - Set to 1 to send batch with no SSN">
        <cfargument name="isRerun" type="numeric" default="0" hint="Set to 1 if re running batches automtically">
               
			<cfscript>
				// declare variable
				var requestXML = '';
				var responseXML = '';
				var reportID = 0;
				var decryptedSSN = '';
				
				// declare return structure
				var batchResult = StructNew();

				batchResult.message = 'Success';
				batchResult.URLResults = '';
			
				// URL is shown in the create_xml_users_gis and create_xml_hosts_gis pages.
				batchResult.BGCDirectURL = BGCDirectURL;
			
				// If we are running this local, update the user information
				if ( APPLICATION.isServerLocal ) {
					ARGUMENTS.username = BGCUser;
					ARGUMENTS.password = BGCPassword;
					ARGUMENTS.account = BGCAccount;
				}
				
				// Get Company Information
				//qGetCompany = APPLICATION.CFC.COMPANY.getCompanies(companyID=ARGUMENTS.companyID);
			</cfscript>
        	
            <!--- Create XML --->
            <cfoutput>
                
                <!--- Check if we should include SSN --->
                <cfif NOT VAL(ARGUMENTS.noSSN)>

                    <cftry>
                        <cfscript>
                            // Decrypt SSN
                            decryptedSSN = Replace(Decrypt(ARGUMENTS.SSN, decryptKey, decryptAlgorithm, decryptEncoding),"-","","All");
                            decryptedSSN = Replace(decryptedSSN, " ", "", "All");
                        </cfscript>
               
                        <cfcatch type="any">
                            
                            <cfscript>
                                // Set up message
                                if ( VAL(ARGUMENTS.hostID) ) {
                                    batchResult.message = 'Please check SSN for host #ARGUMENTS.usertype# family #ARGUMENTS.lastName# (###ARGUMENTS.hostID#)';
                                } else {
                                    batchResult.message = 'Please check SSN for user #ARGUMENTS.lastName# (###ARGUMENTS.userID#)';
                                }
                                
                                return batchResult;
                            </cfscript>
                            
                        </cfcatch>
                    </cftry>
                    
                    <cfxml variable="requestXML">
                    <BGC>
                        <login>
                            <user>#ARGUMENTS.username#</user>
                            <password>#ARGUMENTS.password#</password>
                            <account>#ARGUMENTS.account#</account>
                        </login>
                        <product>
                            <USOneValidate version="1">
                                <order>
                                    <SSN>#decryptedSSN#</SSN>
                                </order>
                            </USOneValidate>
                        </product>
                        <product>
                            <USOneSearch version='1'>
                                <order>
                                    <lastName>#ARGUMENTS.lastName#</lastName>				
                                    <firstName>#ARGUMENTS.firstName#</firstName>
                                    <middleName>#ARGUMENTS.middleName#</middleName>
                                    <DOB>
                                        <year>#ARGUMENTS.DOBYear#</year>
                                        <month>#ARGUMENTS.DOBMonth#</month>
                                        <day>#ARGUMENTS.DOBDay#</day>
                                    </DOB>
                                </order>
                                <custom>
                                    <options>
                                        <noSummary>YES</noSummary>			
                                        <includeDetails>YES</includeDetails>
                                    </options>
                                </custom>				
                            </USOneSearch>
                        </product>
                        <product>	
                            <USOneTrace version="1">
                                <order>
                                    <SSN>#decryptedSSN#</SSN>
                                    <lastName>#ARGUMENTS.lastName#</lastName>
                                    <firstName>#ARGUMENTS.firstName#</firstName>
                                </order>
                            </USOneTrace>
                        </product>	
                    </BGC>
                    </cfxml>
                
				<!--- 
					No SNN USOneSearch Only
				--->   
				<cfelse>     
                               
                    <cfxml variable="requestXML">
                    <BGC>
                        <login>
                            <user>#ARGUMENTS.username#</user>
                            <password>#ARGUMENTS.password#</password>
                            <account>#ARGUMENTS.account#</account>
                        </login>
                        <product>
                            <USOneSearch version='1'>
                                <order>
                                    <lastName>#ARGUMENTS.lastName#</lastName>				
                                    <firstName>#ARGUMENTS.firstName#</firstName>
                                    <middleName>#ARGUMENTS.middleName#</middleName>
                                    <DOB>
                                        <year>#ARGUMENTS.DOBYear#</year>
                                        <month>#ARGUMENTS.DOBMonth#</month>
                                        <day>#ARGUMENTS.DOBDay#</day>
                                    </DOB>
                                </order>
                                <custom>
                                    <options>
                                        <noSummary>YES</noSummary>			
                                        <includeDetails>YES</includeDetails>
                                    </options>
                                </custom>				
                            </USOneSearch>
                        </product>
                    </BGC>
                    </cfxml>
                
                </cfif> <!--- End of NO SSN --->
                
			</cfoutput>
            
            <cftry>
            
				<!--- Submit CBC --->
                <cfhttp url="#BGCDirectURL#" method="post" throwonerror="yes">
                    <cfhttpparam type="Header" name="charset" value="utf-8" />
                    <cfhttpparam type="XML" value="#requestXML#" />                    
                </cfhttp>
                
                <cfscript>	
                    // Parse XML we received back to a variable
                    responseXML = XmlParse(cfhttp.filecontent);		
					
                    // Reads XML File and Send Email CFC
                    batchResult.message = sendEmailResult(
                        companyID=ARGUMENTS.companyID,
                        responseXML=responseXML,
                        userType=ARGUMENTS.userType,
                        hostID=ARGUMENTS.hostID,
                        userID=ARGUMENTS.userID,
                        lastName=ARGUMENTS.lastName,
                        firstName=ARGUMENTS.firstName,
						isRerun=ARGUMENTS.isRerun
                    );				
    
                    // Get Report ID
					try { 
						// Try to get from US One Search (if there is an error, get it from BCG order number)
						ReportID = '#responseXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender.record.key.secureKey.XmlText#';
					} catch (Any e) {
						// Error
						ReportID = '#responseXML.bgc.XmlAttributes.orderId#';
					}					
					
                    // Check if we have successfully submitted the background check
                    if (batchResult.message EQ 'success') {
                        
                        if ( VAL(ARGUMENTS.hostID) ) {
                            // Update Host CBC 
                            updateHostCBC(
                                ReportID=ReportID,
                                cbcFamID=ARGUMENTS.cbcID,
                                xmlReceived=responseXML
                            );							
							
							// Set up URL Results
							batchResult.URLResults = "view_host_cbc.cfm?hostID=#ARGUMENTS.hostID#&CBCFamID=#ARGUMENTS.cbcID#";

						} else {
                            // Update User CBC 
                            updateUserCBC(
                                ReportID=ReportID,
                                cbcID=ARGUMENTS.cbcID,
                                xmlReceived=responseXML
                            );

							// Set up URL Results
							batchResult.URLResults = "view_user_cbc.cfm?userid=#ARGUMENTS.userID#&cbcID=#ARGUMENTS.cbcID#";
                        }
                    }
                    
                    return batchResult;
                </cfscript>
                
                <cfcatch type="any">
                    
                    <!--- Store XML in a temp file --->
                    <cffile action="write" file="#APPLICATION.PATH.temp#xmlReceived.xml" output="#responseXML#" nameconflict="overwrite" charset="utf-8">
                    
                    <cfmail 
                    	from="#APPLICATION.EMAIL.support#"
                        to="#APPLICATION.EMAIL.errors#"
                        subject="CBC Error"
                        type="html">
						
                        <cfmailparam file="#APPLICATION.PATH.temp#xmlReceived.xml" type="text">
                        
                    	<p>#CLIENT.exits_url#</p>
                    
                        <p>
                        	<strong>
                            	Error Processing CBC for #ARGUMENTS.userType# #ARGUMENTS.firstName# #ARGUMENTS.lastName# 
								<cfif VAL(ARGUMENTS.userID)> #ARGUMENTS.userID# </cfif>
                                <cfif VAL (ARGUMENTS.hostID)> #ARGUMENTS.hostID# </cfif> 
                          	</strong>
                       </p>                 
                        
                        <p>Message: #cfcatch.message#</p>
                        
                        <!--- Do Not Include Sent XML - It contains SSN --->
                        <!---
                        <p>XML Sent:<br>
                        <cfdump var="#requestXML#"> </p>
						--->
                        
                        <!---
                        <p>XML Received: <br>
                        <cfdump var="#responseXML#"> </p>
						--->
                        
                        <p>Error: <br>
                        <cfdump var="#cfcatch#"> </p>
                        
                     </cfmail>

					<cfscript>
                        // Set up message
                        batchResult.message = 'Error Processing CBC for #ARGUMENTS.firstName# #ARGUMENTS.lastName#. Please try again.';
						
						return batchResult;
					</cfscript>
                </cfcatch>
                
            </cftry>

	</cffunction>
</cfcomponent>