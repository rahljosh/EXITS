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
    
    <!----Get pending hosts who need CBC run---->
<cffunction name="getPendingCBCHost" access="public" returntype="query" output="false" hint="Returns CBC records that need to be run for a host">
        <cfargument name="companyID" type="numeric" default="0" hint="CompanyID is not required">
        <cfargument name="seasonID" type="numeric" default="0" hint="SeasonID is not required">
        <cfargument name="userType" type="string" default="" hint="UserType is not required. List of values such as mother,father">
        <cfargument name="hostID" type="numeric" default="0" hint="HostID is not required">
        <cfargument name="noSSN" type="numeric" default="0" hint="Optional - Set to 1 to send batch with no SSN">
        
        <cfquery 
        	name="qGetCBCHost" 	
        	datasource="#APPLICATION.dsn#">
                SELECT DISTINCT 
                    cbc.cbcfamID, 
                    cbc.hostID, 
                    cbc.cbc_type,
                    cbc.seasonID,
                    cbc.isNoSSN,
                    cbc.date_authorized, 
                    cbc.date_sent, 
                    cbc.date_expired,
                    h.companyID,
                    h.familylastName,
                    h.fatherlastName, 
                    h.fatherfirstName, 
                    h.fathermiddlename, 
                    h.fatherdob, 
                    h.fatherssn,
                    h.motherlastName, 
                    h.motherfirstName, 
                    h.mothermiddlename, 
                    h.motherdob,
                    h.motherssn,
                    c.companyShort,
                    c.gis_username,
                    c.gis_password,
                    c.gis_account                                           
                FROM 
                   php_hosts_cbc_new cbc
                INNER JOIN 
                    smg_hosts h ON h.hostID = cbc.hostID
                LEFT OUTER JOIN
                	smg_companies c ON c.companyID = h.companyID
                WHERE 
                    cbc.date_authorized IS NOT NULL                
				AND
                	cbc.date_sent IS NULL 	
                AND 
                    cbc.requestID = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
                
                <!--- Check if we are running ISE's CBC --->
              

                AND 
                    h.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyID#">
             

            	<!--- Check if we have a valid SeasonID --->
				<cfif VAL(ARGUMENTS.seasonID)>
                AND 
                    cbc.seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.seasonID#">
				</cfif>
                
                <!--- Check if userType was passed --->
                <cfif LEN(ARGUMENTS.userType)>
                AND 
                    cbc.cbc_type IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.userType#" list="yes">)
                
                	<!--- NO SSN --->
                	<cfif VAL(ARGUMENTS.noSSN) AND ARGUMENTS.userType EQ 'father'>
					AND 
                        h.fatherSSN = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
                    <cfelseif VAL(ARGUMENTS.noSSN) AND ARGUMENTS.userType EQ 'mother'>
					AND 
                        h.motherSSN = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
                    </cfif>
                
                </cfif>
				
            	<!--- Check if we have a valid hostID --->
				<cfif VAL(ARGUMENTS.hostID)>
                AND 
                    cbc.hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.hostID#">
				</cfif>
                
                ORDER BY	
                	c.companyID
                
                <!--- If running batch, limit to 20 so we don't get time outs --->
                LIMIT 20
        </cfquery>
   
        <cfreturn qGetCBCHost>
    </cffunction>
    
    <!----Get CBC info by ID---->
    <cffunction name="getCBCHostByID" access="public" returntype="query" output="false" hint="Returns CBC records for a mother, father or family member">
		<cfargument name="hostID" required="yes" hint="Host ID is required">
        <cfargument name="familyMemberID" default="0" hint="Family Member ID is not required">
        <cfargument name="cbcType" default="" hint="cbcType is required (mother, father or member)">
        <cfargument name="cbcfamID" default="0" hint="CBCFamID is not required">
        <cfargument name="sortBy" type="string" default="seasonID" hint="sortBy is not required">
        <cfargument name="sortOrder" type="string" default="ASC" hint="sortOrder is not required">
        <cfargument name="getOneRecord" type="numeric" default="0" hint="getOneRecord is not required">

			<cfscript>
				// Make sure we have a valid sortOrder value
                if ( NOT ListFind("ASC,DESC", ARGUMENTS.sortOrder ) ) {
                    ARGUMENTS.sortOrder = 'DESC';			  
                }
            </cfscript>

            <cfquery 
            	name="qGetCBCHostByID" 
                datasource="#APPLICATION.dsn#">
                    SELECT 
                        h.cbcfamID, 
                        h.hostID, 
                        h.familyID,
                        h.batchID,  <!--- phase out | storing cbc in the database --->
                        h.cbc_type,
                        h.notes,
                        h.date_authorized, 
                        h.date_sent, 
                        h.date_expired,
                        h.date_approved,
                        h.xml_received, 
                        h.requestID, 
                        h.isNoSSN,
                        h.flagcbc,
                        h.seasonID, 
                        s.season,
                        c.companyID,
                        c.companyshort
                    FROM 
                       php_hosts_cbc_new h
                    LEFT OUTER JOIN 
                        smg_seasons s ON s.seasonID = h.seasonID
                    LEFT OUTER JOIN 
                        smg_companies c ON c.companyID = h.companyID
                    WHERE 
                        h.hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#"> 

                    <cfif VAL(ARGUMENTS.cbcfamID)>
                        AND
                            h.cbcfamID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.cbcfamID#">                                	
                    </cfif>
	                    
                    <cfif LEN(ARGUMENTS.cbcType)>
                        AND 
                            h.cbc_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.cbcType#">
                    </cfif>
                    
                    <cfif VAL(ARGUMENTS.familyMemberID)>
                        AND 
                            h.familyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.familyMemberID#">
                    </cfif>
                    
                    ORDER BY 
                            
                    <cfswitch expression="#ARGUMENTS.sortBy#">
                        
                        <cfcase value="seasonID">                    
                            h.seasonID #ARGUMENTS.sortOrder#
                        </cfcase>

                        <cfcase value="familyID">                    
                            h.familyID #ARGUMENTS.sortOrder#,
                            h.seasonID #ARGUMENTS.sortOrder#
                        </cfcase>

                        <cfcase value="date_sent">
                            h.date_sent #ARGUMENTS.sortOrder#
                        </cfcase>
        
                        <cfdefaultcase>
                            h.seasonID #ARGUMENTS.sortOrder#
                        </cfdefaultcase>
        
                    </cfswitch> 
                    
                    <cfif VAL(ARGUMENTS.getOneRecord)>
                    	LIMIT 1
                    </cfif>
                                        
            </cfquery>    

		<cfreturn qGetCBCHostByID>
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
                        
                    	<p>http://www.phpusa.com/</p>
                    
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
    
    <cffunction name="updateHostCBC" access="public" returntype="void" output="false" hint="Updates CBC Information">
        <cfargument name="ReportID" type="string" required="yes">  
        <cfargument name="cbcFamID" type="numeric" required="yes">      
        <cfargument name="xmlReceived" type="string" default="">
        
        <cfquery 
        	datasource="MySql">
            UPDATE 
            	php_hosts_cbc_new
            SET 
            	date_sent = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                date_expired = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('yyyy', 1, now())#">, <!--- Expires in 1 Year --->
                requestID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.reportID#">,
                xml_received = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#ARGUMENTS.xmlReceived#">
            WHERE 
            	cbcfamID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.cbcFamID#">
        </cfquery>

	</cffunction>
    
    <!----Send Email Results---->
    <cffunction name="sendEmailResult" access="public" returntype="string" output="false" hint="Reads XML File and Sends Email Result">
    	<cfargument name="companyID" required="yes">
        <cfargument name="responseXML" default="" hint="responseXML or XMLFilePath must be passed to this function">
        <cfargument name="XMLFilePath" default="" hint="responseXML or XMLFilePath must be passed to this function">
        <cfargument name="userType" type="string" default="" hint="Father,Mother,User,Member">
        <cfargument name="hostID" type="numeric" default="0" hint="Optional">
        <cfargument name="userID" type="numeric" default="0" hint="Optional">        
        <cfargument name="firstName" type="string" default="" hint="Optional">
		<cfargument name="lastName" type="string" default="" hint="Optional">
        <cfargument name="isRerun" type="numeric" default="0" hint="Optional - Set to 1 if re running batches automtically">
        	
            <cfscript>
				// Set return variable
				var emailResult = 'Success';
				var readXML = '';
				var setCBCType = '';
				
				// check if we have at least one of the required arguments
				if ( NOT LEN(ARGUMENTS.responseXML) AND NOT LEN(ARGUMENTS.XMLFilePath) ) {										
					emailResult = 'Error - responseXML or XMLFilePath must be passed to this function';
					return emailResult;
				}
				
				// check if we have a valid XML
				if ( LEN(ARGUMENTS.responseXML) AND NOT IsXML(ARGUMENTS.responseXML) ) {
					emailResult = 'Error - Not a valid XML';
					return emailResult;
				}				
			</cfscript>
            
            <!--- Check if we have a file Path, if we do read the XML and store it in ARGUMENTS.responseXML --->
			<cfif LEN(ARGUMENTS.XMLFilePath)>
				             
				<cftry>               
                    
                    <cffile 
                        action="read" 
                        variable="ARGUMENTS.responseXML"
                        file="#ARGUMENTS.XMLFilePath#">		
				
                    <cfcatch type="any">
                        <cfscript>
							emailResult = 'Error - Could not find XML file #ARGUMENTS.XMLFilePath#';
							
							return emailResult;
						</cfscript>
                    </cfcatch>
                    
                </cftry>
                            
            </cfif>
			
            <cfscript>
				// Parse XML
				readXML = XmlParse(ARGUMENTS.responseXML);

				// Get Company Information
				qGetCompany = APPLICATION.CFC.COMPANY.getCompanies(companyID=ARGUMENTS.companyID);
				
				// These are used in the email subject to display User, User Member, Host Father, Host Mother and Host Member
				if ( VAL(ARGUMENTS.hostID) ) {
					setCBCType = 'Host';	
					setCBCID = ' (###ARGUMENTS.hostID#)';
				} else if ( VAL(ARGUMENTS.userID) AND ARGUMENTS.userType EQ 'user' ) {
					setCBCType = '';	
					setCBCID = ' (###ARGUMENTS.userID#)';
				} else if ( VAL(ARGUMENTS.userID) ) {
					setCBCType = 'User';	
					setCBCID = ' (###ARGUMENTS.userID#)';
				}

				// Set Email To
				if ( APPLICATION.isServerLocal ) {
					emailTo = 'marcus@iseusa.com';
				} else if ( listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, qGetCompany.companyID) AND VAL(ARGUMENTS.isRerun) ) {
					// ISE - ReRun - Send email to cbcResults and Program Manager
					emailTo = "#qGetCompany.gis_email#,#qGetCompany.pm_email#";
				} else {
					// Not Re-Run - Send email to cbcResults only
					emailTo = qGetCompany.gis_email;
				}
				
				// Set Email Subject
				if ( NOT VAL(ARGUMENTS.isRerun) ) {
	            	emailSubject = 'Background Check Search for #qGetCompany.companyshort# - #setCBCType# #ARGUMENTS.userType# - #ARGUMENTS.firstName# #ARGUMENTS.lastName# #setCBCID#';
				} else {
	            	emailSubject = 'Scheduled Rerun Background Check Search for #qGetCompany.companyshort# - #setCBCType# #ARGUMENTS.userType# - #ARGUMENTS.firstName# #ARGUMENTS.lastName# #setCBCID#';
				}
			</cfscript>        	
            	
            <cfmail 
            	from="#qGetCompany.support_email#" 
                to="#emailTo#"
                subject="#emailSubject#" 
                failto="#qGetCompany.support_email#"
                type="html">
                
                    <cfscript>
						// Display Formatted Results
                        displayXMLResult(
                            companyID=ARGUMENTS.companyID, 
                            responseXML=ARGUMENTS.responseXML, 
                            userType=ARGUMENTS.userType,
                            hostID=ARGUMENTS.hostID,
                            userID=ARGUMENTS.userID
                        );
                    </cfscript>
                    
            </cfmail>

		<cfreturn emailResult>
	</cffunction>
</cfcomponent>