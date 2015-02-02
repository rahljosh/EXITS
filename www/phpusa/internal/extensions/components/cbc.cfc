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
				//BGCDirectURL = 'https://model.backgroundchecks.com/integration/bgcdirectpost.aspx';	
				//BGCUser = 'smg1';
				//BGCPassword = 'R3d3x##';
				//BGCAccount = '10005542';
				// PRODUCTION URL
				BGCDirectURL = 'https://direct.backgroundchecks.com/integration/bgcdirectpost.aspx';
				// stored in the database
				BGCUser = '';
				BGCPassword = '';
				BGCAccount = '';
			
			
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
                   php_hosts_cbc cbc
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
                       php_hosts_cbc h
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
    <!----Get Host Family Memebers---->
    <cffunction name="getPendingCBCHostMember" access="public" returntype="query" output="false" hint="Returns CBC records that need to be run for a host member">
        <cfargument name="companyID" type="numeric" default="0" hint="CompanyID is not required">
        <cfargument name="seasonID" type="numeric" default="0" hint="SeasonID is not required">
        <cfargument name="hostID" type="numeric" default="0" hint="HostID is not required">
        <cfargument name="noSSN" type="numeric" default="0" hint="Optional - Set to 1 to send batch with no SSN">
        
        <cfquery 
        	name="qGetCBCHostMember" 	
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
                    child.childID, 
                    child.name, 
                    child.middlename, 
                    child.lastName, 
                    child.birthdate, 
                    child.SSN, 
                    child.hostID,
					c.companyShort,
                    c.gis_username,
                    c.gis_password,
                    c.gis_account   
                FROM 
                	php_hosts_cbc cbc
                INNER JOIN 
                	smg_host_children child ON child.childID = cbc.familyID
						AND	
                        	child.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">                
                INNER JOIN	
                	smg_hosts h ON h.hostID = child.hostID
                LEFT OUTER JOIN
                	smg_companies c ON c.companyID = h.companyID    
                WHERE 
                	cbc.date_authorized IS NOT NULL 
				AND
                	cbc.date_sent IS NULL 	               
                AND 
                    requestID = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
            	AND	
                	cbc_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="member">
            
           
               
                <cfif VAL(ARGUMENTS.companyID)>
                AND 
                    h.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyID#">
                </cfif>

            	<!--- Check if we have a valid SeasonID --->
				<cfif VAL(ARGUMENTS.seasonID)>
                AND 
                	cbc.seasonID =  <cfqueryparam value="#ARGUMENTS.seasonID#" cfsqltype="cf_sql_integer">
				</cfif>
                    
            	<!--- Check if we have a valid hostID --->
				<cfif VAL(ARGUMENTS.hostID)>
                AND 
                    cbc.hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.hostID#">
				</cfif>

				<!--- NO SSN --->
                <cfif VAL(ARGUMENTS.noSSN)>
                AND 
                    child.SSN = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
                </cfif>            

                ORDER BY	
                	c.companyID

                LIMIT 20
			</cfquery>

        <cfreturn qGetCBCHostMember>
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
            	php_hosts_cbc
            SET 
            	date_sent = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                date_expired = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('yyyy', 1, now())#">, <!--- Expires in 1 Year --->
                requestID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.reportID#">,
                xml_received = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#ARGUMENTS.xmlReceived#">
            WHERE 
            	cbcfamID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.cbcFamID#">
        </cfquery>

	</cffunction>
    

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
					emailTo = 'james@iseusa.com';
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

    
    <cffunction name="displayXMLResult" access="public" returntype="void" output="true" hint="Reads and Display XML Result">
    	<cfargument name="companyID" required="yes">
        <cfargument name="responseXML" default="" hint="responseXML or XMLFilePath must be passed to this function">
        <cfargument name="userType" type="string" default="" hint="Father,Mother,User,Member">
        <cfargument name="hostID" type="numeric" default="0" hint="Optional">
        <cfargument name="userID" type="numeric" default="0" hint="Optional"> 
        <cfargument name="familyID" type="numeric" default="0" hint="User or Host member ID">  
        <cfargument name="dateProcessed" type="any" default="" hint="Optional">
			
            <cfscript>
				// Parse XML
				var readXML = XmlParse(ARGUMENTS.responseXML);
				
				// Declare First and Last Name
				setfirstName = '';
				setLastName = '';
				
				/* 
					Up to 3 Products 
				   	1. UsOneValidate
				   	2. UsOneSearch
				   	3. UsOneTrace 
				   	If run without social, there will be only one product UsOneSearch 
				*/

				// Get Total of Products
				vTotalProducts = ArrayLen(readXML.bgc.product);
				
				// Set USOneSearchID, if there is a social is product 2 if there is no social is product 1
				if ( vTotalProducts GT 1 ) {
					usOneSearchID = 2;					
				} else {
					usOneSearchID = 1;					
				}
				
				// Get Report ID
				try { 
					// Try to get from US One Search (if there is an error, get it from BCG order number)
                    ReportID = readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender.record.key.secureKey.XmlText;
				} catch (Any e) {
					// Error
                    ReportID = '#readXML.bgc.XmlAttributes.orderId#';
				}					

				// Get Total Offenses
				try { 
					// Get total of items - USOneSearch
					vTotalOffenses = readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.XmlAttributes.qtyFound;
				} catch (Any e) {
					// Get total of items - USOneSearch
					vTotalOffenses = 0;
				}					

				// Get Company Information
				qGetCompany = APPLICATION.CFC.COMPANY.getCompanies(companyID=ARGUMENTS.companyID);
							
				if ( VAL(ARGUMENTS.hostID) ) {
					// Set CBC Type 
					setCBCType = 'Host';
					
					// Get First Name / Last Name
					switch (ARGUMENTS.userType) {
						// Get host father first and last name
						case "father": {
							qHostFather = APPLICATION.CFC.HOST.getHosts(hostID=ARGUMENTS.hostID);
							setfirstName = qHostFather.fatherfirstName;
							setLastName = qHostFather.fatherLastName;
							break;
						}
						// Get host mother first and last name
						case "mother": {
							qHostMother = APPLICATION.CFC.HOST.getHosts(hostID=ARGUMENTS.hostID);
							setfirstName = qHostMother.motherfirstName;
							setLastName = qHostMother.motherLastName;
							break;
						}
						// Get host member first and last name
						case "member": {
							qHostMember = APPLICATION.CFC.HOST.getHostMemberByID(childID=ARGUMENTS.familyID, hostID=ARGUMENTS.hostID);
							setfirstName = qHostMember.name;
							setLastName = qHostMember.lastName;
							break;
						}
					}
				
				} else if ( VAL(ARGUMENTS.userID) ) {

					switch (ARGUMENTS.userType) {
						// Get User First and Last Name
						case "user": {
							// Set CBC Type 
							setCBCType = '';	
							qUser = APPLICATION.CFC.USER.getUserByID(userID=ARGUMENTS.userID);
							setfirstName = qUser.firstName;
							setLastName = qUser.lastName;
							break;
						}
						// Get Member First and Last Name
						case "member": {
							// Set CBC Type 
							setCBCType = 'User';	
							qUserMember = APPLICATION.CFC.USER.getUserMemberByID(ID=ARGUMENTS.familyID, userID=ARGUMENTS.userID);
							setfirstName = qUserMember.firstName;
							setLastName = qUserMember.lastName;
							break;
						}
					}
				}
            </cfscript>
        
			<cfoutput>
            
                <table width="670" align="center">
					<!--- Header --->
                    <tr bgcolor="##CCCCCC"><th colspan="2"><cfif APPLICATION.isServerLocal>DEVELOPMENT SERVER - </cfif> #qGetCompany.companyName#</th></tr>
                    <tr><td colspan="2">&nbsp;</td></tr>

                    <tr bgcolor="##CCCCCC">
                    	<th colspan="2">	
                        	Criminal Backgroud Check &nbsp; -  &nbsp; 
                            Date Processed: <cfif IsDate(ARGUMENTS.dateProcessed)>#DateFormat(ARGUMENTS.dateProcessed, 'mm/dd/yyyy')#<cfelse>#DateFormat(now(), 'mm/dd/yyyy')#</cfif>
                        </th>
                    </tr>
                    <tr><td colspan="2">&nbsp;</td></tr>
                    
                    <tr bgcolor="##CCCCCC">
                        <th colspan="2">
                            *** Search Results for #setCBCType# #ARGUMENTS.usertype# - #setfirstName# #setLastName# 
                            <cfif VAL(ARGUMENTS.hostID)>
                                (###ARGUMENTS.hostID#)
                            <cfelseif VAL(ARGUMENTS.userID)>
                                (###ARGUMENTS.userID#)
                            </cfif> 
                            ***
                        </th>
                    </tr>
                    
                    <tr><td colspan="2">&nbsp;</td></tr>
                    
                    <!--- USOneValidate --->
					<cfif vTotalProducts GT 1>                   
                        <tr bgcolor="##CCCCCC"><th colspan="2">US ONE VALIDATE</th></tr>
                        <tr><td colspan="2"><b>SSN Validation & Death Master Index Check for #readXML.bgc.product[1].USOneValidate.order.ssn#</b></td></tr>
                        <tr><td colspan="2">&nbsp; &nbsp; &nbsp; #readXML.bgc.product[1].USOneValidate.response.validation.textResponse#</td></tr>	
                        <tr><td colspan="2">&nbsp; &nbsp; &nbsp; The associated individual is <b> <cfif readXML.bgc.product[1].USOneValidate.response.validation.isDeceased.XmlText EQ 'no'>not</cfif> deceased.</b></td></tr>			
                        <tr><td colspan="2">&nbsp; &nbsp; &nbsp; Issued in <b>#readXML.bgc.product[1].USOneValidate.response.validation.stateIssued#</b> between <b>#readXML.bgc.product[1].USOneValidate.response.validation.yearIssued#</b></td></tr>			
                                                
                        <tr><td colspan="2"><hr width="100%" align="center"></td></tr>	
                    </cfif>
                                        
                    <!--- USOneSearch --->	
                    <tr bgcolor="##CCCCCC"><th colspan="2"><b>US ONE SEARCH</b></th></tr>
                    <tr><td colspan="2"><b>You searched for:</b></td></tr>
                    <tr><td colspan="2">&nbsp; &nbsp; &nbsp; <b>#readXML.bgc.product[usOneSearchID].USOneSearch.order.lastName#, #readXML.bgc.product[usOneSearchID].USOneSearch.order.firstName# #readXML.bgc.product[usOneSearchID].USOneSearch.order.middlename#</b></td></tr>
                    <cfif vTotalProducts GT 1>    
	                    <tr><td colspan="2">&nbsp; &nbsp; &nbsp; <b>SSN : </b> #readXML.bgc.product[1].USOneValidate.order.ssn#</td></tr>
                    </cfif>
                    <tr><td colspan="2">&nbsp; &nbsp; &nbsp; <b>DOB : </b> #readXML.bgc.product[usOneSearchID].USOneSearch.order.dob.month#/#readXML.bgc.product[usOneSearchID].USOneSearch.order.dob.day#/#readXML.bgc.product[usOneSearchID].USOneSearch.order.dob.year#</td></tr>						
                    <tr><td colspan="2">&nbsp; &nbsp; &nbsp; <b>Report ID : </b> #ReportID#</td></tr>
                    <tr><td colspan="2">&nbsp; &nbsp; &nbsp; <b>Number of items: </b> #vTotalOffenses#<br></td></tr>
                    
                    <tr><td colspan="2"><hr width="100%" align="center"></td></tr>	
                    
                    <cfif VAL(vTotalOffenses)>
                        
                        <!--- ITEMS - OFFENDER --->
                        <cfloop from="1" to ="#vTotalOffenses#" index="t">				
                            <cfset totalOffenses = ArrayLen(readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.XmlChildren)>
                            <tr>
                                <td><b>#readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].identity.personal.fullName#</b></td>
                                <td>ID ##: #readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].record.key.offenderid#</td>
                            </tr>
                            <tr>
                                <td>DOB: #readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].identity.personal.dob#</td>
                                <td>GENDER: #readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].identity.personal.gender#</td>
                            </tr>
                            <tr><td colspan="2">Total of Offenses: #totalOffenses#<br></td></tr>
                           
                            <tr><td colspan="2"><hr width="100%" align="center"></td></tr>	
                            
                            <!--- OFFENSES --->
                            <cfloop from="1" to ="#totalOffenses#" index="i">
                                <tr><td colspan="2">
                                        <b>#readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].description#</b>
                                        (#readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].record.provider#, #readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].record.key.state#)
                                    </td>
                                </tr>
                                <tr><td colspan="2">&nbsp;</td></tr>
                                
                                <!--- Disposition --->
                                <cfif LEN(readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].disposition.XmlText)>
                                    <tr><td colspan="2">Disposition : <b>#readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].disposition#</b></td></tr>
                                </cfif>
                                
                                <!--- Degree Of Offense --->
                                <cfif LEN(readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].degreeOfOffense.XmlText)>
                                    <tr><td colspan="2">Degree Of Offense : <b>#readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].degreeOfOffense#</b></td></tr>
                                </cfif>
                                
                                <!--- Sentence --->
                                <cfif LEN(readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].sentence.XmlText)>
                                    <tr><td colspan="2">Sentence : <b>#readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].sentence#</b></td></tr>
                                </cfif>
                                
                                <!--- Probation --->
                                <cfif LEN(readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].probation.XmlText)>
                                    <tr><td colspan="2">Probation : <b>#readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].probation#</b></td></tr>
                                </cfif>
                                
                                <!--- Offense --->
                                <cfif LEN(readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].confinement.XmlText)>
                                    <tr><td colspan="2">Offense : <b>#readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].confinement#</b></td></tr>
                                </cfif>
                                
                                <!--- Arresting Agency --->
                                <cfif LEN(readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].arrestingAgency.XmlText)>
                                    <tr><td colspan="2">Arresting Agency : <b>#readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].arrestingAgency#</b></td></tr>
                                </cfif>
                                
                                <!--- Original Agency --->
                                <cfif LEN(readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].originatingAgency.XmlText)>
                                    <tr><td colspan="2">Original Agency : <b>#readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].originatingAgency#</b></td></tr>
                                </cfif>
                                
                                <!--- Jurisdiction --->
                                <cfif LEN(readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].jurisdiction.XmlText)>
                                <tr><td colspan="2">Jurisdiction : <b>#readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].jurisdiction#</b></td></tr>
                                </cfif>
                               
                                <!--- Statute --->
                                <cfif LEN(readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].statute.XmlText)>
                                <tr><td colspan="2">Statute : <b>#readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].statute#</b></td></tr>
                                </cfif>
                                
                                <!--- Plea --->
                                <cfif LEN(readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].plea.XmlText)>
                                    <tr><td colspan="2">Plea : <b>#readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].plea#</b></td></tr>
                                </cfif>
                                
                                <!--- Court Decision --->
                                <cfif LEN(readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].courtDecision.XmlText)>
                                    <tr><td colspan="2">Court Decision : <b>#readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].courtDecision#</b></td></tr>
                                </cfif>
                                
                                <!--- Court Costs --->
                                <cfif LEN(readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].courtCosts.XmlText)>
                                    <tr><td colspan="2">Court Costs : <b>#readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].courtCosts#</b></td></tr>
                                </cfif>
                                
                                <!--- Fine --->
                                <cfif LEN(readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].fine.XmlText)>
                                    <tr><td colspan="2">Fine : <b>#readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].fine#</b></td></tr>
                                </cfif>
                                
                                <!--- Offense Date --->
                                <cfif LEN(readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].offenseDate.XmlText)>
                                <tr><td colspan="2">Offense Date : <b>#readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].offenseDate#</b></td></tr>
                                </cfif>
                                
                                <!--- Arrest Date --->
                                <cfif LEN(readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].arrestDate.XmlText)>
                                    <tr><td colspan="2">Arrest Date : <b>#readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].arrestDate#</b></td></tr>
                                </cfif>
                                
                                <!--- Sentence Date --->
                                <cfif LEN(readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].sentenceDate.XmlText)>
                                    <tr><td colspan="2">Sentence Date : <b>#readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].sentenceDate#</b></td></tr>
                                </cfif>
                                
                                <!--- Disposition Date --->
                                <cfif LEN(readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].dispositionDate.XmlText)>
                                    <tr><td colspan="2">Disposition Date : <b>#readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].dispositionDate#</b></td></tr>
                                </cfif>
                                
                                <!--- File Date --->
                                <cfif LEN(readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].fileDate.XmlText)>
                                <tr><td colspan="2">File Date : <b>#readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].fileDate#</b></td></tr>
                                </cfif>
                                
                                <tr><td colspan="2">&nbsp;</td></tr>
                                
                                <!--- SPECIFIC INFORMATION --->				
                                <tr><td colspan="2"><i>#readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].record.provider#, #readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].record.key.state# SPECIFIC INFORMATION</i></td></tr>
                                <cfset totalSpecifics = ArrayLen(readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].recorddetails.recorddetail.supplements.XmlChildren)>
                                <tr>
                                
                                <cfloop from="1" to ="#totalSpecifics#" index="s">
                                    <td>&nbsp; &nbsp; &nbsp; #readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].recorddetails.recorddetail.supplements.supplement[s].displayTitle# : 
                                        <b> #readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].recorddetails.recorddetail.supplements.supplement[s].displayValue# </b>
                                    </td>
                                    <cfif s MOD 2></tr><tr></tr></cfif>
                                </cfloop>
                                
                                <tr><td colspan="2"><hr width="100%" align="center"></td></tr>	
                                                        
                            </cfloop>
                            
                        </cfloop>	
                        
                    <cfelse>
                        <tr><td colspan="2">No data found.</td></tr>
                        <tr><td colspan="2"><hr width="100%" align="center"></td></tr>
                    </cfif>
                    
                    <!--- US ONE TRACE --->
                    <cfif vTotalProducts GT 1> 
                    
                        <tr bgcolor="##CCCCCC"><th colspan="2"><b>US ONE TRACE</b></th></tr>
                        <tr><td colspan="2"><b>You searched for:</b></td></tr>
                        <tr><td colspan="2">&nbsp; &nbsp; &nbsp; <b>#readXML.bgc.product[3].USOneTrace.order.lastName#, #readXML.bgc.product[3].USOneTrace.order.firstName#</b></td></tr>
                        <tr><td colspan="2">&nbsp; &nbsp; &nbsp; <b>SSN : </b> #readXML.bgc.product[3].USOneTrace.order.ssn#</td></tr>
                        
                        <tr><td colspan="2"><hr width="100%" align="center"></td></tr>			
                        
                        <cfset traceRecords = (ArrayLen(readXML.bgc.product[3].USOneTrace.response.records.XmlChildren))>
                        <cfif traceRecords GT 0>			
                            <cfloop index="tr" from="1" to ="#traceRecords#">
                                <tr>
                                    <td width="50%">First Name : <b>#readXML.bgc.product[3].USOneTrace.response.records.record[tr].firstName# 
                                        #readXML.bgc.product[3].USOneTrace.response.records.record[tr].middleName# 
                                        #readXML.bgc.product[3].USOneTrace.response.records.record[tr].lastName# </b>
                                    </td>
                                    <td width="50%">Phone Info : <b>#readXML.bgc.product[3].USOneTrace.response.records.record[tr].phoneInfo#</b></td>
                                </tr>
                                <tr>
                                    <td>Address : <b>#readXML.bgc.product[3].USOneTrace.response.records.record[tr].streetNumber# 
                                        #readXML.bgc.product[3].USOneTrace.response.records.record[tr].streetName# </b>
                                    </td>		
                                    <td>
                                        <b>
                                            #readXML.bgc.product[3].USOneTrace.response.records.record[tr].city#, 
                                            #readXML.bgc.product[3].USOneTrace.response.records.record[tr].state# 
                                            #readXML.bgc.product[3].USOneTrace.response.records.record[tr].postalCode#-
                                            #readXML.bgc.product[3].USOneTrace.response.records.record[tr].postalCode4# 
                                        </b>
                                    </td>
                                </tr>	
                                <tr>
                                    <td>County : <b>#readXML.bgc.product[3].USOneTrace.response.records.record[tr].county#</b></td>
                                    <td>Verified : <b>#readXML.bgc.product[3].USOneTrace.response.records.record[tr].verified#</b></td>
                                </tr>	
                                <tr><td colspan="2"><hr width="100%" align="center"></td></tr>
                            </cfloop>
                        <cfelse>
                            <tr><td colspan="2">No data found.</td></tr>
                            <tr><td colspan="2"><hr width="100%" align="center"></td></tr>
                        </cfif>
                        
                        <tr><td colspan="2">&nbsp;</td></tr>
                    
                    </cfif>
                    
                    <!--- FOOTER --->
                    <tr><td colspan="2">For more information please visit <a href="www.backgroundchecks.com">www.backgroundchecks.com</a></td></tr>	
                    <tr>
                    	<td colspan="2">
                            *******************************<br>
                            CONFIDENTIALITY NOTICE:<br>
                            This is a transmission from 
                            <cfif ARGUMENTS.companyID EQ 10>
                                #qGetCompany.companyName#
                            <cfelse>
                                International Student Exchange 
                            </cfif> 
                            and may contain information that is confidential and proprietary.
                            If you are not the addressee, any disclosure, copying or distribution or use of the contents of this message is expressly prohibited.
                            If you have received this transmission in error, please destroy it and notify us immediately at #qGetCompany.phone#.<br>
                            Thank you.<br>
                            *******************************
                    	</td>
	                </tr>
                </table>
                <br><br>
            </cfoutput>

	</cffunction>
    
    <cffunction name="UpdateHostXMLReceived" access="public" returntype="void" output="false" hint="Updates XML Received Information">
        <cfargument name="cbcFamID" type="numeric" required="yes">      
        <cfargument name="xmlReceived" type="string" default="">
        
        <cfquery 
        	datasource="MySql">
            UPDATE 
            	smg_hosts_cbc  
            SET 
                xml_received = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#ARGUMENTS.xmlReceived#">
            WHERE 
            	cbcfamID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.cbcFamID#">
        </cfquery>

	</cffunction>
    <!--- End of CBC Batch Functions --->
</cfcomponent>