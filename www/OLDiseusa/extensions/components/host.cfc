 <!--- ------------------------------------------------------------------------- ----
	
	File:		host.cfc
	Author:		Marcus Melo
	Date:		October, 09 2009
	Desc:		This holds the functions needed for the host families
	
	Update: 
	
----- ------------------------------------------------------------------------- --->

<cfcomponent 
	displayname="host"
	output="false" 
	hint="A collection of functions for the company">


	<!--- Return the initialized Company object --->
	<cffunction name="Init" access="public" returntype="host" output="false" hint="Returns the initialized Host object">
		
		<cfscript>
			// There is nothing really to initiate, so just return this
			return(this);
		</cfscript>
        
	</cffunction>

	
	<cffunction name="getHosts" access="public" returntype="query" output="false" hint="Gets a list with hosts, if HostID is passed gets a Host by ID">
    	<cfargument name="hostID" default="" hint="HostID is not required">
        <cfargument name="regionID" default="" hint="regionID is not required">
        <cfargument name="companyID" default="" hint="CompanyID is not required">
        
        <cfquery 
			name="qGetHosts" 
			datasource="#APPLICATION.DSN#">
                SELECT
                	*        
                FROM 
                    smg_hosts
                WHERE
                	active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                 
                <cfif LEN(ARGUMENTS.hostID)>
                    AND
                        hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">
                </cfif>

                <cfif LEN(ARGUMENTS.regionID)>
                    AND
                        regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.regionID)#">
                </cfif>
                
				<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, ARGUMENTS.companyID)>
                    AND          
                        companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
                <cfelseif VAL(ARGUMENTS.companyID)>
                    AND          
                        companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyID#"> 
                </cfif>
                    
                ORDER BY 
                    familyLastName
		</cfquery>
		   
		<cfreturn qGetHosts>
	</cffunction>
    

	<cffunction name="getCompleteHostAddress" access="public" returntype="query" output="false" hint="Returns complete host family address">
    	<cfargument name="hostID" default="" hint="HostID is required">
        
        <cfquery 
			name="qGetCompleteHostAddress" 
			datasource="#APPLICATION.DSN#">
                SELECT
                	hostID,
                    CONCAT(address, ', ', city, ', ', state, ', ', zip) AS completeAddress
                FROM 
                    smg_hosts
                WHERE
                    hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">
		</cfquery>
		   
		<cfreturn qGetCompleteHostAddress>
	</cffunction>


	<!--- Start of Auto Suggest --->
    <cffunction name="remoteLookUpHost" access="remote" returnFormat="json" output="false" hint="Remote function to get host families, returns an array">
        <cfargument name="searchString" type="string" default="" hint="Search is not required">
        <cfargument name="maxRows" type="numeric" required="false" default="30" hint="Max Rows is not required" />
        <cfargument name="companyID" default="#CLIENT.companyID#" hint="CompanyID is not required">
        
        <cfscript>
			var vReturnArray = arrayNew(1);
		</cfscript>
        
        <cfquery 
			name="qRemoteLookUpHost" 
			datasource="#APPLICATION.DSN#">
                SELECT 
                	hostID,
					CAST( 
                    	CONCAT(                      
                            familyLastName,
                            ' - ', 
                            IFNULL(fatherFirstName, ''),                                                  
                            IF (fatherFirstName != '', IF (motherFirstName != '', ' and ', ''), ''),
                            IFNULL(motherFirstName, ''),
                            ' (##',
                            hostID,
                            ')'                    
						) 
					AS CHAR) AS displayName
                FROM 
                	smg_hosts
                WHERE 
                	 1 = 1

				<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, ARGUMENTS.companyID)>
                    AND          
                        companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
                <cfelseif VAL(ARGUMENTS.companyID)>
                    AND          
                        companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
                </cfif>

				<cfif IsNumeric(ARGUMENTS.searchString)>
                    AND
                    	hostID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.searchString#%">
                <cfelse>
                    AND 
                    	(                        
                        	familyLastName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.searchString#%">
                		OR
                        	fatherFirstName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.searchString#%">
                        OR
                        	motherFirstName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.searchString#%">
						)
				</cfif>	

                ORDER BY 
                    familyLastName

				LIMIT 
                	<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.maxRows#" />                 
        </cfquery>

		<cfscript>
			// Loop through query
            For ( i=1; i LTE qRemoteLookUpHost.recordCount; i++ ) {

				vUserStruct = structNew();
				vUserStruct.hostID = qRemoteLookUpHost.hostID[i];
				vUserStruct.displayName = qRemoteLookUpHost.displayName[i];
				
				ArrayAppend(vReturnArray,vUserStruct);
            }
			
			return vReturnArray;
        </cfscript>

    </cffunction>       
    
    
    <cffunction name="lookupHostFamily" access="remote" returntype="string" output="false" hint="Remote function to get host families">
        <cfargument name="search" type="string" default="" hint="Search is not required">
        <cfargument name="regionID" default="" hint="regionID is not required">
        
        <!--- Do search --->
        <cfquery 
			name="qLookupHostFamily" 
			datasource="#APPLICATION.DSN#">
                SELECT 
                	hostID,
					CAST( 
                    	CONCAT(                      
                            familyLastName,
                            ' - ', 
                            IFNULL(fatherFirstName, ''),                                                  
                            IF (fatherFirstName != '', IF (motherFirstName != '', ' and ', ''), ''),
                            IFNULL(motherFirstName, ''),
                            ' (##',
                            hostID,
                            ')'                    
						) 
					AS CHAR) AS displayHostFamily
                FROM 
                	smg_hosts
                WHERE 
                	 active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
				AND
                	isNotQualifiedToHost = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                    
                <cfif LEN(ARGUMENTS.regionID)>
                    AND
                        regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.regionID)#">
                </cfif>
                
                AND
					CAST( 
                    	CONCAT(                      
                            familyLastName,
                            ' - ', 
                            IFNULL(fatherFirstName, ''),                                                  
                            IF (fatherFirstName != '', IF (motherFirstName != '', ' and ', ''), ''),
                            IFNULL(motherFirstName, ''),
                            ' (##',
                            hostID,
                            ')'                    
						) 
					AS CHAR) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.search#%">
                ORDER BY 
                    familyLastName
        </cfquery>
        
        <cfscript>
			// Return List
			return ValueList(qLookupHostFamily.displayHostFamily);		
        </cfscript>

    </cffunction>


	<cffunction name="getHostByName" access="remote" returntype="string">
        <cfargument name="search" type="string" default="" hint="Search is not required">
        
        <cfscript>
			var vhostID = 0;
		</cfscript>
        
        <cfif LEN(ARGUMENTS.search)>
        
            <cfquery 
                name="qGetHostByName" 
                datasource="#APPLICATION.DSN#">
                    SELECT
                        hostID
                    FROM
                        smg_hosts		
                    WHERE 
                        active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                    AND 
                        CAST( 
                            CONCAT(                      
                                familyLastName,
                                ' - ', 
                                IFNULL(fatherFirstName, ''),                                                  
                                IF (fatherFirstName != '', IF (motherFirstName != '', ' and ', ''), ''),
                                IFNULL(motherFirstName, ''),
                                ' (##',
                                hostID,
                                ')'                    
                            ) 
                        AS CHAR) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.search)#">
                    ORDER BY
                        familyLastName
                    LIMIT
                    	1
            </cfquery>

			<cfscript>
                vhostID = ValueList(qGetHostByName.hostID);
            </cfscript>

        </cfif>

		<cfscript>
            return vhostID;
        </cfscript>
        
	</cffunction>
	<!--- End of Auto Suggest --->


	<cffunction name="getHostStateListByRegionID" access="public" returntype="string" output="false" hint="Returns a list of host family states assigned to a region">
    	<cfargument name="regionID" type="numeric" hint="regionID is required">

        <cfquery 
			name="qGetHostStateListByRegionID" 
			datasource="#APPLICATION.DSN#">
                SELECT
					state
                FROM 
                    smg_hosts
                WHERE	
                    regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.regionID)#">
                AND
                	active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                AND
                	state != <cfqueryparam cfsqltype="cf_sql_varchar" value="">
                GROUP BY
                	state
                ORDER BY
                	state
		</cfquery>
		
        <cfscript>
			var vReturnState = ValueList(qGetHostStateListByRegionID.state);			
			
			// Return List
			return vReturnState;
		</cfscript>
           
	</cffunction>


	<cffunction name="getHostMemberByID" access="public" returntype="query" output="false" hint="Gets a host member by ID">
    	<cfargument name="childID" default="" hint="Child ID is not required">
        <cfargument name="hostID" default="" hint="HostID is not required">
        <cfargument name="liveAtHome" default="" hint="liveAtHome is not required">
        <cfargument name="getAllMembers" default="0" hint="Returns all family members including deleted">
        
        <cfquery 
			name="qGetHostMemberByID" 
			datasource="#APPLICATION.DSN#">
                SELECT
					*
                FROM 
                    smg_host_children
                WHERE
                	1 = 1
                
                <cfif NOT VAL(ARGUMENTS.getAllMembers)>    
                    AND
	                    isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">    
                </cfif>
                
                <cfif LEN(ARGUMENTS.childID)>
                    AND
                        childID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.childID)#">
                </cfif>
                
                <cfif LEN(ARGUMENTS.hostID)>
                    AND
                        hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">
                </cfif>

                <cfif LEN(ARGUMENTS.liveAtHome)>
                    AND
                        liveAtHome = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.liveAtHome#">
                </cfif>
				
		</cfquery>
		   
		<cfreturn qGetHostMemberByID>
	</cffunction>


	<cffunction name="getHostPets" access="public" returntype="query" output="false" hint="Gets a host pets by ID">
    	<cfargument name="animalID" default="" hint="Child ID is not required">
        <cfargument name="hostID" default="" hint="HostID is not required">
        
        <cfquery 
			name="qGetHostPets" 
			datasource="#APPLICATION.DSN#">
                SELECT
					animalID,
                    hostID,
                    animalType,
                    number,
                    indoor
                FROM 
                    smg_host_animals
                WHERE
                	1 = 1
                
                <cfif LEN(ARGUMENTS.animalID)>
                    AND
                        animalID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.animalID)#">
                </cfif>
                
                <cfif LEN(ARGUMENTS.hostID)>
                    AND
                        hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">
                </cfif>

		</cfquery>
		   
		<cfreturn qGetHostPets>
	</cffunction>


	<cffunction name="displayHostFamilyName" access="public" returntype="string" output="false" hint="Displays Host Family Information (father/mother)">
        <cfargument name="hostID" default="0" hint="hostID">
    	<cfargument name="fatherFirstName" default="" hint="fatherFirstName">
        <cfargument name="fatherLastName" default="" hint="fatherLastName">
        <cfargument name="motherFirstName" default="" hint="motherFirstName">
        <cfargument name="motherLastName" default="" hint="motherLastName">
        <cfargument name="familyLastName" default="" hint="familyLastName">

		<cfscript>
			// Declare Variables		
			vReturnName = "";
			
			if ( LEN(ARGUMENTS.fatherFirstName) ) {
				
				vReturnName = vReturnName & ' ' & ARGUMENTS.fatherFirstName;
				
				if ( ARGUMENTS.fatherLastName NEQ ARGUMENTS.familyLastName ) {
					vReturnName = vReturnName & ' ' & ARGUMENTS.fatherLastName;
				}
				
			}
			
			if ( LEN(ARGUMENTS.fatherFirstName) AND LEN(ARGUMENTS.motherFirstName) ) {
				vReturnName = vReturnName & ' and ';
			}
            
			if ( LEN(ARGUMENTS.motherFirstName) ) {
				
				vReturnName = vReturnName & ' ' & ARGUMENTS.motherFirstName;
				
				if ( ARGUMENTS.motherLastName NEQ ARGUMENTS.familyLastName ) {
					vReturnName = vReturnName & ' ' & ARGUMENTS.motherLastName;
				}
				
			}

			if ( ARGUMENTS.motherLastName EQ ARGUMENTS.familyLastName OR  ARGUMENTS.fatherLastName EQ ARGUMENTS.familyLastName ) {
				vReturnName = vReturnName & ' ' & ARGUMENTS.familyLastName;
			}

            if ( VAL(ARGUMENTS.hostID) ) {
				vReturnName = vReturnName & ' (##' & ARGUMENTS.hostID & ')';
			}
			
			// Return Host Family Formatted Name
			return(vReturnName);
        </cfscript>
		   
	</cffunction>


	<cffunction name="isSingleParentFamily" access="public" returntype="boolean" output="false" hint="Calculate the total of members at home and returns true/false">
        <cfargument name="hostID" default="" hint="hostID">

        <cfquery name="qCalculateMembersAtHome" datasource="#APPLICATION.DSN#">
            SELECT 
            	*,
                (isFatherHome + isMotherHome + totalChildrenAtHome) AS totalFamilyMembers
            FROM 
            (
                SELECT 
                    <!--- Host Family --->
                    h.hostID,             
                    h.familyLastName as hostFamilyLastName,
                    <!--- Is father home? --->
                    (
                        CASE 
                            WHEN 
                                h.fatherFirstName != '' 
                            THEN 
                                1
                            WHEN 	
                                h.fatherFirstName = ''  
                            THEN 
                                0
                        END
                    ) AS isFatherHome,
                    <!--- Is mother home? --->
                    (
                        CASE 
                            WHEN 
                                h.motherFirstName != '' 
                            THEN 
                                1
                            WHEN 	
                                h.motherFirstName = ''  
                            THEN 
                                0                               
                        END
                    ) AS isMotherHome,
                    <!--- Total of Children at home --->
                    (
                        SELECT 
                            COUNT(shc.childID) 
                        FROM 
                            smg_host_children shc
                        WHERE
                            shc.hostID = h.hostID
                        AND
                            shc.liveathome = <cfqueryparam cfsqltype="cf_sql_varchar" value="yes">
                        AND	
                            shc.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                    ) AS totalChildrenAtHome
                FROM 
                    smg_hosts h
                WHERE 
                    h.hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">
            ) AS tmpTable          
        </cfquery>
        
        <cfscript>
			if ( qCalculateMembersAtHome.totalFamilyMembers EQ 1 ) {
				return true;
			} else {
				return false;	
			}		
		</cfscript>
        
	</cffunction>
    
    
    <cffunction name="getHostEligibility" access="public" returntype="boolean" output="false" hint="Checks if the host family is eligible to host, returns true if they are, false otherwise.">
        <cfargument name="hostID" default="" hint="hostID">
        
        <cfquery name="qGetHostQualified" datasource="#APPLICATION.DSN#">
        	SELECT 
            	isNotQualifiedToHost
            FROM 
            	smg_hosts
            WHERE 
            	hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">
            AND 
            	isNotQualifiedToHost != 0
        </cfquery>
        
        <cfquery name="qGetHostCBCFlags" datasource="#APPLICATION.DSN#">
        	SELECT 
            	flagCBC
            FROM 
            	smg_hosts_cbc
            WHERE 
            	hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">
            AND 
            	flagCBC != 0
        </cfquery>
        
        <cfscript>
			if (VAL(qGetHostQualified.recordCount) OR VAL(qGetHostCBCFlags.recordCount)) {
				return false;	
			} else {
				return true;	
			}
		</cfscript>
        
    </cffunction>
    
    <cffunction name="sendWelcomeLetter" access="public" returntype="void" output="no" hint="Sends the host family welcome letter">
    	<cfargument name="email" required="yes" hint="email is required">
        <cfargument name="password" required="yes" hint="password is required">
        <cfargument name="fatherFirstName" default="" hint="fatherFirstName is not required">
        <cfargument name="motherFirstName" default="" hint="motherFirstName is not required">
        
        <cfsavecontent variable="hostWelcome">       
			<style type="text/css">
         		.rdholder {
                    height:auto;
                    width:auto;
                    margin-bottom:25px;
                    margin-top: 15px;
                }
                .rdholder .rdbox {
                    border-left:1px solid #c6c6c6;
                    border-right:1px solid #c6c6c6;
                    padding:2px 15px;
                    margin:0;
                    display: block;
                    min-height: 137px;
                }
                .rdtop {
                    width:auto;
                    height:20px;
                    /* -webkit for Safari and Google Chrome */
                    -webkit-border-top-left-radius:12px;
                    -webkit-border-top-right-radius:12px;
                    /* -moz for Firefox, Flock and SeaMonkey  */
                    -moz-border-radius-topright:12px;
                    -moz-border-radius-topleft:12px;
                    background-color: #FFF;
                    color: #006699;
                    border-top-width: 1px;
                    border-right-width: 1px;
                    border-bottom-width: 0px;
                    border-left-width: 1px;
                    border-top-style: solid;
                    border-right-style: solid;
                    border-bottom-style: solid;
                    border-left-style: solid;
                    border-top-color: #c6c6c6;
                    border-right-color: #c6c6c6;
                    border-bottom-color: #c6c6c6;
                    border-left-color: #c6c6c6;
                }
                .rdtop .rdtitle {
                    margin:0;
                    line-height:30px;
                    font-family:Arial, Geneva, sans-serif;
                    font-size:20px;
                    padding-top: 5px;
                    padding-right: 10px;
                    padding-bottom: 0px;
                    padding-left: 10px;
                    color: #006699;
                 }
                 .rdbottom {
                    width:auto;
                    height:10px;
                    border-bottom: 1px solid #c6c6c6;
                    border-left:1px solid #c6c6c6;
                    border-right:1px solid #c6c6c6;
                    /* -webkit for Safari and Google Chrome */
                    -webkit-border-bottom-left-radius:12px;
                    -webkit-border-bottom-right-radius:12px;
                    /* -moz for Firefox, Flock and SeaMonkey  */
                    -moz-border-radius-bottomright:12px;
                    -moz-border-radius-bottomleft:12px; 
                 }
                 .clearfix {
                    display: block;
                    height: 5px;
                    width: 500px;
                    clear: both;
                }
                .rdholder .rdbox p, li, td {
                    font-family: "Palatino Linotype", "Book Antiqua", Palatino, serif;
                    font-size: .80em;
                    padding-top: 0px;
                    padding-right: 20px;
                    padding-bottom: 0px;
                    padding-left: 20px;
                }         
            </style>
                            
            <div class="rdholder" style="width: 595px;"> 
                <div class="rdtop"> </div> <!-- end top -->
                <cfoutput>
                    <div class="rdbox">
                        <p>
                            <strong>
                                <cfif ARGUMENTS.fatherfirstname is not ''>#ARGUMENTS.fatherfirstname#</cfif>
                                <Cfif ARGUMENTS.fatherfirstname is not '' and ARGUMENTS.motherfirstname is not ''> and</cfif>
                                <cfif ARGUMENTS.motherfirstname is not ''>#ARGUMENTS.motherfirstname#</cfif>-
                            </strong>
                        </p>
                        <p>I am so excited that you have decided to host a student!</p>
                        <p>Everytime you host a student, we require host families to update the information, if needed, that we have on file</p>
                        <p>We are required by the Department of State to collect the following information:</p>
                        <ul>
                            <li>a background check on any person who is 17 years of age or older and who is living in the home.</li> 
                            <li>pictures of certain areas of your home and property to reflect where the student will be living.</li>
                            <li>basic financial and financial aid information on your family</li>
                        </ul>
                        At the end of this email, you will find login information that will allow you to update any information that has changed 
                        and to provide new information that may be required since you last hosted. 
                        <p>The application process can take any where from 15-60 minutes to complete depending on the information needed and number of pictures you submit.</p> 
                        <p>You can always come back to the  application at a later time to complete it or change any information  that you want.  Please keep in mind though, 
                        that once the application is  submitted, you will no longer be able to change any information on the  application. </p>
                        <p><em> We have just launched this electronic  host family application, and you are one of the first families to use  this new tool.  Please bear with 
                        us as we work out the final bugs. Should you get any errors or feel  that something is confusing, please feel free to let us know how we can  improve 
                        the process.  There is a live chat and email support available  through the application if you need immediate assistance while filling  out the application. 
                        Any and all feedback would be greatly appreciated.</em></p>
                        <div style="display: block; float: left; width: 250px;  padding: 10px;  font-family:Arial, Helvetica, sans-serif; font-size: .80em">
                            <strong>
                                <em>
                                    To start filling out your application, please click on the following link:
                                </em>
                            </strong>
                            <br /><br />
                            <cfif client.companyid eq 10>
                                <a href="http://www.case-usa.org/hostApplication/" target="_blank">
                                    <img src="#client.exits_url#/nsmg/pics/hostAppEmail.jpg" width="200" height="56" border="0">
                                </a>
                            <cfelse>
                                <a href="https://www.iseusa.com/hostApplication/" target="_blank">
                                    <img src="#client.exits_url#/nsmg/pics/hostAppEmail.jpg" width="200" height="56" border="0">
                                </a>
                            </cfif>
                            <br />
                        </div>
                        <div style="display: block; float: right; width: 270px; padding: 10px; font-family:Arial, Helvetica, sans-serif; font-size: .80em; border: thin solid ##CCC;">
                            <div>
                                <strong><em>Please use the following login information:</em></strong>
                            </div>
                            <br /><br />
                            <div style="width: 50px; float: left;">
                                <img src="#client.exits_url#/nsmg/pics/lock.png" width="39" height="56">
                            </div>
                            <div>
                                <strong>Username / Email:</strong>
                                <br />
                                #ARGUMENTS.email#
                                <br />
                                <strong>Password:</strong>
                                <br />
                                #ARGUMENTS.password#
                            </div>
                        </div>
                    </div>
                </cfoutput>
            </div>
        </cfsavecontent>         
        <cfinvoke component="nsmg.cfc.email" method="send_mail">
            <cfinvokeargument name="email_to" value="#ARGUMENTS.email#">
            <cfinvokeargument name="email_subject" value="Host Family Application">
            <cfinvokeargument name="email_message" value="#hostWelcome#">
            <cfinvokeargument name="email_from" value="#CLIENT.email#">
        </cfinvoke>
    </cffunction>
    
    <!--- Combine Hosts --->
    <cffunction name="combineHosts" access="public" returntype="boolean" output="no" hint="Changes all fields from fromHost to toHost and deletes fromHost">
    	<cfargument name="fromHost" default="0" required="yes" hint="fromHost is required">
        <cfargument name="toHost" default="0" required="yes" hint="toHost is required">
        
        <cfquery datasource="#APPLICATION.DSN#">
            UPDATE smg_hosthistoryTracking
            SET fieldID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.toHost#">
            WHERE fieldID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.fromHost#">	
            AND fieldName =  <cfqueryparam cfsqltype="cf_sql_varchar" value="hostID">           	
        </cfquery>

        <cfquery datasource="#APPLICATION.DSN#">
            UPDATE progress_reports
            SET fk_host = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.toHost#">
            WHERE fk_host = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.fromHost#">
        </cfquery>
        
        <!--- List of tables to update the host on - all of these tables use the hostID field name so they can be looped through to update them. --->
        <cfset updateTables = "
			extra_hostauthenticationfiles,
			extra_hostinfohistory,
			php_hosts_cbc,
			php_students_in_program,
			smg_csiet_history,
			smg_documents,
			smg_host_app_history,
			smg_host_missing_docs,
			smg_host_reference_tracking,
			smg_hosthistory,
			smg_hosts_cbc,
			smg_sevis_history,
			smg_students,
			smg_users,
			smg_users_payments
		">
        <!--- List of tables to delete the host from - all of these tables use the hostID field name so they can be looped through to update them. --->
        <cfset deleteTables = "
			extra_confirmations,
			extra_j1_positions,
			smg_host_animals,
			smg_host_children,
			smg_hosts
		">
        
        <cfloop list="#updateTables#" index="i">
        	<cfquery datasource="#APPLICATION.DSN#">
            	UPDATE #i#
                SET hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.toHost#">
                WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.fromHost#">
            </cfquery>
        </cfloop>
        
        <cfloop list="#deleteTables#" index="i">
        	<cfquery datasource="#APPLICATION.DSN#">
            	DELETE FROM #i#
                WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.fromHost#">
            </cfquery>
        </cfloop>
        
        <cfquery name="qGetHost" datasource="#APPLICATION.DSN#">
        	SELECT smg_hosts.hostID
            FROM smg_hosts
            <cfloop list="#updateTables#" index="i">
            	LEFT JOIN #i# ON #i#.hostID = smg_hosts.hostID
            </cfloop>
            WHERE smg_hosts.hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.fromHost#">
        </cfquery>
        
        <cfif VAL(qGetHost.recordCount)>
        	<cfreturn false>
        <cfelse>
        	<cfreturn true>
        </cfif>
    
    </cffunction>


	<!--- ------------------------------------------------------------------------- ----
		HOST FAMILY APPLICATION
	----- ------------------------------------------------------------------------- --->

	<cffunction name="getApplicationList" access="public" returntype="query" output="false" hint="Gets a list of host family applications">
        <cfargument name="hostID" default="" hint="hostID">
        <cfargument name="uniqueID" default="" hint="uniqueID">
        <cfargument name="statusID" default="" hint="statusID is not required">
        <cfargument name="companyID" default="#CLIENT.companyID#" hint="CompanyID is not required">
        <cfargument name="userType" default="#CLIENT.userType#" hint="userType is not required">
        <cfargument name="regionID" default="#CLIENT.regionID#" hint="regionID is not required">
        <cfargument name="userID" default="#CLIENT.userID#" hint="userID is not required">

        <cfquery 
			name="qGetApplicationList" 
			datasource="#APPLICATION.DSN#">
                SELECT DISTINCT
                	*,
                     <!--- Total Family At Home --->
                    (isFatherHome + isMotherHome + totalChildrenAtHome) AS totalFamilyMembers,
                    <!--- Regional Manager Info --->
                    rm.userID AS regionalManagerID,
                    (
                        CASE 
                            WHEN 
                                regionalManagerID IS NULL
                            THEN 
                                "Not Assigned"
                            ELSE 
                            	CAST(CONCAT(rm.firstName, ' ', rm.lastName,  ' (##', rm.userID, ')' ) AS CHAR)
                            END
                    ) AS regionalManager,
                    rm.email AS regionalManagerEmail,
                    rm.phone AS regionalManagerPhone
                FROM
                (
                    SELECT
                        h.*,
                        <!--- Host Family Display Name --->
                        CAST( 
                            CONCAT(                      
                                h.familyLastName,
                                ' - ', 
                                IFNULL(h.fatherFirstName, ''),                                                  
                                IF (h.fatherFirstName != '', IF (h.motherFirstName != '', ' and ', ''), ''),
                                IFNULL(h.motherFirstName, ''),
                                ' (##',
                                h.hostID,
                                ')'                    
                            ) 
                        AS CHAR) AS displayHostFamily,
                        <!--- Is father home? --->
                        (
                            CASE 
                                WHEN 
                                    h.fatherFirstName != '' 
                                THEN 
                                    1
                                WHEN 	
                                    h.fatherFirstName = ''  
                                THEN 
                                    0
                            END
                        ) AS isFatherHome,
                        <!--- Is mother home? --->
                        (
                            CASE 
                                WHEN 
                                    h.motherFirstName != '' 
                                THEN 
                                    1
                                WHEN 	
                                    h.motherFirstName = ''  
                                THEN 
                                    0                               
                            END
                        ) AS isMotherHome,
                        <!--- Total of Children at home --->
                        (
                            SELECT 
                                COUNT(shc.childID) 
                            FROM 
                                smg_host_children shc
                            WHERE
                                shc.hostID = h.hostID
                            AND
                                shc.liveathome = <cfqueryparam cfsqltype="cf_sql_varchar" value="yes">
                            AND	
                                shc.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                        ) AS totalChildrenAtHome,
                        <!--- Region --->
                        (
                            CASE 
                                WHEN 
                                    r.regionID > 0
                                THEN 
                                    r.regionName 
                                ELSE 
                                    "Not Assigned"
                            END
                        ) AS regionName,
                        <!--- Get Regional Manager ID --->
                        (
                            SELECT 
                                rm.userID
                            FROM
                                smg_users rm
                            INNER JOIN
                                user_access_rights uarRM ON uarRM.userID = rm.userID
                            WHERE 
                                rm.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                            AND 
                                uarRM.usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="5">
                            AND 
                                uarRM.regionID = r.regionID
                            LIMIT 1 
                        ) AS regionalManagerID,
						<!--- Regional Advisor Info --->
                        ra.userID AS regionalAdvisorID,
                        (
                            CASE 
                                WHEN 
                                    ra.userID IS NULL
                                THEN 
                                    "n/a"
                                ELSE 
                                    CAST(CONCAT(ra.firstName, ' ', ra.lastName,  ' (##', ra.userID, ')' ) AS CHAR)
                                END
                        ) AS regionalAdvisor,
                        ra.email AS regionalAdvisorEmail,
                        ra.phone AS regionalAdvisorPhone,
                        <!--- Area Representative Info --->
                        areaRep.userID AS areaRepresentativeID,
                        (
                            CASE 
                                WHEN 
                                    areaRep.userID IS NULL
                                THEN 
                                    "Not Assigned"
                                ELSE 
                                    CAST(CONCAT(areaRep.firstName, ' ', areaRep.lastName,  ' (##', areaRep.userID, ')' ) AS CHAR)
                            END
                        ) AS areaRepresentative,
                        areaRep.email AS areaRepresentativeEmail,
                        areaRep.phone AS areaRepresentativePhone,
                        <!--- Facilitator --->
                        fac.userID AS facilitatorID,
                        (
                            CASE 
                                WHEN 
                                    fac.userID IS NULL
                                THEN 
                                    "Not Assigned"
                                ELSE 
                                    CAST(CONCAT(fac.firstName, ' ', fac.lastName,  ' (##', fac.userID, ')' ) AS CHAR)
                            END
                        ) AS facilitator,
                        fac.email AS facilitatorEmail	                        
                    FROM 
                        smg_hosts h
                    <!--- Region --->
                    LEFT OUTER JOIN
                        smg_regions r ON r.regionID = h.regionID
                    <!--- Area Representative --->
                    LEFT OUTER JOIN
                        smg_users areaRep ON areaRep.userID = h.areaRepID
                    LEFT OUTER JOIN
                        user_access_rights uar ON uar.userID = areaRep.userID
                            AND
                                h.regionID = uar.regionID
					<!--- Regional Advisor Info --->
                    LEFT OUTER JOIN
                        smg_users ra ON ra.userID = uar.advisorID
					<!--- Facilitator --->
                    LEFT OUTER JOIN
                        smg_users fac ON fac.userID = r.regionFacilitator
                    WHERE
                        1 = 1 
                    
                    <!--- If hostID is passed ignore active and companyID filters --->
                    <cfif LEN(ARGUMENTS.hostID)>
                        AND
                            h.hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">
					<!--- Unique ID --->
					<cfelseif LEN(ARGUMENTS.uniqueID)>
                        AND
                            h.uniqueID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.uniqueID#">
					<!--- We are getting a list of families so make sure we get only active and families from the appropriate company --->
					<cfelse>
                    
                    	AND
                        	h.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                    
						<!--- ISE - Displays all apps |  OR APPLICATION.CFC.USER.isOfficeUser() --->
                        <cfif ARGUMENTS.companyID EQ 5>
                            AND          
                                h.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
                        <cfelseif VAL(ARGUMENTS.companyID)>
                            AND          
                                h.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyID#"> 
                        </cfif>
                        
					</cfif>
                    
                    <cfif LEN(ARGUMENTS.statusID)>
                        AND
                            h.hostAppStatus = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.statusID)#">
                    </cfif>
                    
                    <cfswitch expression="#ARGUMENTS.userType#">
                        
                        <!--- Regional Manager --->
                        <cfcase value="5">
                            AND 
                                h.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.regionID)#">
                        </cfcase>
                        
                        <!--- Regional Advisor --->
                        <cfcase value="6">
                            AND 
                                h.areaRepID IN ( 
                                    SELECT
                                        uarSU.userID
                                    FROM
                                        user_access_rights uarSU
                                    WHERE
                                        uarSU.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.regionID)#">
                                    AND 
                                        (
                                            uarSU.advisorID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userID)#">
                                        OR
                                            uarSU.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userID)#">
                                        )
                                ) 
                        </cfcase>
                        
                        <!--- Area Rep --->
                        <cfcase value="7">
                            AND 
                                h.areaRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">
                        </cfcase>
                        
                    </cfswitch>
				) AS tmpTable     

				<!--- Regional Manager Info --->
                LEFT OUTER JOIN
                    smg_users rm ON rm.userID = regionalManagerID
                             
                ORDER BY 
                    regionName,
                    familyLastName
		</cfquery>
        
		<cfreturn qGetApplicationList>
	</cffunction>
    
    
	<cffunction name="updateApplicationStatus" access="public" returntype="void" output="false" hint="Updates a host family application status">
        <cfargument name="hostID" default="" hint="HostID is not required">
        <cfargument name="statusID" default="" hint="statusID is not required">
			
            <cfif VAL(ARGUMENTS.hostID) AND listFind("0,1,2,3,4,5,6,7,8,9", ARGUMENTS.statusID)>
            
                <cfquery datasource="#APPLICATION.DSN#">
                    UPDATE
                        smg_hosts
                    SET 
                        hostAppStatus = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.statusID#">
                    WHERE        	
                        hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.hostID#">
                </cfquery>
                
			</cfif>                
	
    </cffunction>
    

	<cffunction name="getReferences" access="public" returntype="query" output="false" hint="Gets references for a host family application">
        <cfargument name="hostID" default="" hint="HostID is not required">
        <cfargument name="refID" default="" hint="refID is not required">
		<cfargument name="seasonID" default="" hint="Current Paperwork Season ID">        
        <cfargument name="getCurrentUserApprovedReferences" default="0" hint="Pass userType to get current user ID approved references">
        
        <cfquery 
			name="qGetReferences" 
			datasource="#APPLICATION.DSN#">
                SELECT
					sfr.refID,
                    sfr.firstName,
                    sfr.lastName,
                    sfr.address,
                    sfr.address2,
                    sfr.city,
                    sfr.state,
                    sfr.zip,
                    sfr.phone,
                    sfr.email,
                    sfr.referenceFor,
                    sfr.approved,
                    hrqt.ID,
                    hrqt.dateInterview,
                    hrqt.areaRepID,
                    hrqt.fk_referencesID,
                    hrqt.season,
                    hrqt.hostID,
                    hrqt.areaRepStatus,
                    hrqt.areaRepDateStatus,
                    hrqt.areaRepNotes,                    
                    hrqt.regionalAdvisorStatus,
                    hrqt.regionalAdvisorDateStatus,
                    hrqt.regionalAdvisorNotes,
                    hrqt.regionalManagerStatus,
                    hrqt.regionalManagerDateStatus,
                    hrqt.regionalManagerNotes,
                    hrqt.facilitatorStatus,
                    hrqt.facilitatorDateStatus,
                    hrqt.facilitatorNotes, 
                    hrqt.dateInterview, 
                    CAST(CONCAT(u.firstName, ' ', u.lastName,  ' (##', u.userID, ')' ) AS CHAR) AS submittedBy  
                FROM 
                    smg_host_reference sfr
                LEFT OUTER JOIN
                	smg_host_reference_tracking hrqt ON hrqt.fk_referencesID = sfr.refID

					<!--- Get SeasonID --->
                    <cfif LEN(ARGUMENTS.seasonID)>
                        AND
                            hrqt.season = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.seasonID)#">
                    </cfif>
                    
                LEFT OUTER JOIN
                	smg_users u ON u.userID = hrqt.interviewer
                WHERE
                	sfr.referenceFor = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">
				
                <!--- Get RefID --->
                <cfif LEN(ARGUMENTS.refID)>
                	AND
                    	sfr.refID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.refID)#">
                </cfif>
                
				<!--- Get Approved References for current User --->
                <cfswitch expression="#ARGUMENTS.getCurrentUserApprovedReferences#">
                	
                    <!--- Office --->
                    <cfcase value="1,2,3,4">
                    	AND	
                        	hrqt.facilitatorStatus = <cfqueryparam cfsqltype="cf_sql_varchar" value="approved">
                        AND
                            hrqt.facilitatorDateStatus IS NOT NULL
                    </cfcase>
                    
                    <!--- Regional Manager --->
                    <cfcase value="5">
                    	AND	
                        	hrqt.regionalManagerStatus = <cfqueryparam cfsqltype="cf_sql_varchar" value="approved">
                        AND
                            hrqt.regionalManagerDateStatus IS NOT NULL
                    </cfcase>

					<!--- Regional Advisor --->
                    <cfcase value="6">
                    	AND	
                        	hrqt.regionalAdvisorStatus = <cfqueryparam cfsqltype="cf_sql_varchar" value="approved">
                        AND
                            hrqt.regionalAdvisorDateStatus IS NOT NULL
                    </cfcase>
					
                    <!--- Area Representative --->
                    <cfcase value="7">
                    	AND	
                        	hrqt.areaRepStatus = <cfqueryparam cfsqltype="cf_sql_varchar" value="approved">
                        AND
                            hrqt.areaRepDateStatus IS NOT NULL
                    </cfcase>
                   
                </cfswitch>
                    
		</cfquery>
        		   
		<cfreturn qGetReferences>
	</cffunction>
    

	<cffunction name="getReferenceQuestionnaireQuestions" access="public" returntype="query" output="false" hint="Gets references questionnaire questions">
        
        <cfquery 
			name="qGetReferenceQuestionnaireQuestions" 
			datasource="#APPLICATION.DSN#">
                SELECT 
                	*
                FROM 
                	smg_host_reference_questions
                WHERE
                	active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">  
				ORDER BY
                	ID                                       
        </cfquery>
        
        <cfreturn qGetReferenceQuestionnaireQuestions>        
	</cffunction>      
    
    
	<cffunction name="getReferenceQuestionnaireAnswers" access="public" returntype="query" output="false" hint="Gets references questionnaire anwers">
        <cfargument name="fk_reportID" default="0" hint="fk_reportID is not required">

        <cfquery 
			name="qGetReferenceQuestionnaireQuestions" 
			datasource="#APPLICATION.DSN#">
                SELECT 
                	shrq.ID,
                    shrq.active,
                    shrq.qText,
                    shra.ID AS answerID,
                    shra.fk_reportID,
                    shra.fk_questionID,
                    shra.answer
                FROM 
                	smg_host_reference_questions shrq
                LEFT OUTER JOIN
                	smg_host_reference_answers shra ON shra.fk_questionID = shrq.ID 
                	AND
                    	fk_reportID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.fk_reportID)#">
                WHERE
                	shrq.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">   
				ORDER BY
                	shrq.ID                                       
        </cfquery>
        
        <cfreturn qGetReferenceQuestionnaireQuestions>        
	</cffunction>      


	<cffunction name="getApplicationApprovalHistory" access="public" returntype="query" output="false" hint="Gets a list of items and their approval history">
        <cfargument name="hostID" default="" hint="HostID is not required">
        <cfargument name="seasonID" default="#APPLICATION.CFC.LOOKUPTABLES.getCurrentPaperworkSeason().seasonID#" hint="Gets current paperwork season ID">
        <cfargument name="whoViews" default="" hint="whoViews is not required">
        <cfargument name="itemID" default="" hint="itemID is not required">
        <cfargument name="facilitatorStatus" default="" hint="facilitatorStatus is not required">
        <cfargument name="sortBy" type="string" default="listOrder" hint="sortBy is not required">
        <cfargument name="sortOrder" type="string" default="ASC" hint="sortOrder is not required">

        <cfscript>
			if ( NOT ListFind("ASC,DESC", ARGUMENTS.sortOrder ) ) {
				ARGUMENTS.sortOrder = 'ASC';			  
			}
		</cfscript>
       
        <cfquery 
			name="qGetApplicationApprovalHistory" 
			datasource="#APPLICATION.DSN#">
                SELECT
					ap.ID,
                    ap.section,
                    ap.whoViews,
                    ap.description,
                    ap.isStudentRequired,
                    ap.isRequiredForApproval,
                    ap.listOrder,
                    h.areaRepStatus,
                    h.areaRepDateStatus,
                    h.areaRepNotes,                    
                    h.regionalAdvisorStatus,
                    h.regionalAdvisorDateStatus,
                    h.regionalAdvisorNotes,
                    h.regionalManagerStatus,
                    h.regionalManagerDateStatus,
                    h.regionalManagerNotes,
                    h.facilitatorStatus,
                    h.facilitatorDateStatus,
                    h.facilitatorNotes
                FROM 
                    smg_host_app_section ap
				LEFT OUTER JOIN	
					smg_host_app_history h ON h.itemID = ap.ID                  
                    AND
                        h.hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">
                    AND
                        h.seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.seasonID)#">
                WHERE
                	1 = 1
                      
                <cfif LEN(ARGUMENTS.whoViews)>
                	AND
                    	ap.whoViews LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#VAL(ARGUMENTS.whoViews)#%">
                </cfif>
		                    
                <cfif LEN(ARGUMENTS.itemID)>
                	AND
                    	ap.ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.itemID)#">
                </cfif>
                
                <cfif LEN(ARGUMENTS.facilitatorStatus)>
                	AND
                    	h.facilitatorStatus = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.facilitatorStatus#">
                </cfif>
				
                ORDER BY
                <cfswitch expression="#ARGUMENTS.sortBy#">
                
                	<cfcase value="listOrder,facilitatorDateStatus">
                    	#ARGUMENTS.sortBy# #ARGUMENTS.sortOrder#                        
                    </cfcase>

                    <cfdefaultcase>
                		listOrder #ARGUMENTS.sortOrder#
					</cfdefaultcase>
				
                </cfswitch>
                                                                                           
		</cfquery>
		   
		<cfreturn qGetApplicationApprovalHistory>
	</cffunction>


	<cffunction name="getApprovalFieldNames" access="public" returntype="struct" output="false" hint="Returns the fields used in the approval process based on the logged in user">
        <cfargument name="userType" default="#CLIENT.userType#" hint="userType">
        
        <cfscript>
			var stFieldSet = StructNew();
			
			// This is the same for any levels
			stFieldSet.prDateRejectName = "pr_rejected_date";
			
            // Set Field Names
            switch ( ARGUMENTS.usertype ) {
                
                // Area Representative
                case 7: 
                    stFieldSet.statusFieldName = "areaRepStatus";
                    stFieldSet.dateFieldName = "areaRepDateStatus";
                    stFieldSet.notesFieldName = "areaRepNotes";
					// Used for Initial Host Family Visit
					stFieldSet.prUserFieldName = "fk_sr_user";
                    stFieldSet.prApproveFieldName = "pr_sr_approved_date";
                break;
                
                // Regional Advisor
                case 6: 
                    stFieldSet.statusFieldName = "regionalAdvisorStatus";
                    stFieldSet.dateFieldName = "regionalAdvisorDateStatus";
                    stFieldSet.notesFieldName = "regionalAdvisorNotes";
					// Used for Initial Host Family Visit
					stFieldSet.prUserFieldName = "fk_ra_user";
                    stFieldSet.prApproveFieldName = "pr_ra_approved_date";
                break;
                
                // Regional Manager
                case 5:
                    stFieldSet.statusFieldName = "regionalManagerStatus";
                    stFieldSet.dateFieldName = "regionalManagerDateStatus";
                    stFieldSet.notesFieldName = "regionalManagerNotes";
					// Used for Initial Host Family Visit
					stFieldSet.prUserFieldName = "fk_rd_user";
                    stFieldSet.prApproveFieldName = "pr_rd_approved_date";
				break;
                
                // Office Users
                case 4: 
                case 3:
                case 2:
                case 1: 
                    stFieldSet.statusFieldName = "facilitatorStatus";
                    stFieldSet.dateFieldName = "facilitatorDateStatus";
                    stFieldSet.notesFieldName = "facilitatorNotes";
					// Used for Initial Host Family Visit
					stFieldSet.prUserFieldName = "fk_ny_user";
                    stFieldSet.prApproveFieldName = "pr_ny_approved_date";
                break;
                
                // User Not Found - Default to lowest level
                default: 
                    stFieldSet.statusFieldName = "areaRepStatus";
                    stFieldSet.dateFieldName = "areaRepDateStatus";
                    stFieldSet.notesFieldName = "areaRepNotes";
					// Used for Initial Host Family Visit
					stFieldSet.prUserFieldName = "fk_sr_user";
                    stFieldSet.prApproveFieldName = "pr_sr_approved_date";
				break;
            }	 
            
            return stFieldSet;       
       </cfscript>
       
	</cffunction>
    
    
	<cffunction name="updateSectionStatus" access="public" returntype="void" output="false" hint="Approves/Denies sections">
        <cfargument name="hostID" default="" hint="HostID is not required">
        <cfargument name="itemID" default="" hint="itemID">
        <cfargument name="seasonID" default="#APPLICATION.CFC.LOOKUPTABLES.getCurrentPaperworkSeason().seasonID#" hint="Gets current paperwork season ID">
        <cfargument name="action" default="" hint="Approve/Deny an item">
        <cfargument name="notes" default="" hint="notes, usually reason for denial">
        <cfargument name="areaRepID" default="0" hint="areaRepID is not required">
        <cfargument name="regionalAdvisorID" default="0" hint="regionalAdvisorID is not required">
        <cfargument name="regionalManagerID" default="0" hint="regionalManagerID is not required">

        <cfscript>
			// This returns the approval fields for the logged in user
			stFieldSet = getApprovalFieldNames();
		</cfscript>
        
        <cfif listFind("approved,denied", ARGUMENTS.action)>
        
            <cfquery 
                name="qCheckRecord" 
                datasource="#APPLICATION.DSN#">
                    SELECT
                        ID
                    FROM
                        smg_host_app_history
                    WHERE
                        hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">
                    AND
                        itemID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.itemID)#">                  
                    AND
                        seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.seasonID)#">                   
            </cfquery>	
            
            <!--- Update --->
            <cfif qCheckRecord.recordCount>
    
                <cfquery 
                    datasource="#APPLICATION.DSN#">
                        UPDATE	
                            smg_host_app_history
                        SET
                            #stFieldSet.statusFieldName# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.action#">,
                            #stFieldSet.dateFieldName# = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                            #stFieldSet.notesFieldName# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.notes#" null="#yesNoFormat(NOT LEN(ARGUMENTS.notes))#">
                        WHERE
                            ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qCheckRecord.ID)#">
                </cfquery>	
            
            <!--- Insert --->
            <cfelse>
    
                <cfquery 
                    datasource="#APPLICATION.DSN#">
                        INSERT INTO	
                            smg_host_app_history
                        (
                            hostID,
                            itemID,
                            seasonID,
                            #stFieldSet.statusFieldName#,
                            #stFieldSet.dateFieldName#,
                            #stFieldSet.notesFieldName#,
                            dateCreated
                        )
                        VALUES
                        (
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.itemID)#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.seasonID)#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.action#">,
                            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.notes#">,
                            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                        )
                </cfquery>	
            
            </cfif>
            
            <!--- Reset approval level of denied items | RA denies section 1 and 2 so we'll need to resset the AR approval to NULL for these sections --->
            <cfif ARGUMENTS.action EQ 'denied' AND listFind("regionalAdvisorStatus,regionalManagerStatus,facilitatorStatus", stFieldSet.statusFieldName)>
            	
                <cfscript>
					// Default Values
					vUserTypeOneLevelDown = 0;
				
					// Reset Area Representative
					if ( stFieldSet.statusFieldName EQ 'regionalAdvisorStatus' OR stFieldSet.statusFieldName EQ 'regionalManagerStatus' AND NOT VAL(ARGUMENTS.regionalAdvisorID) ) {
						vUserTypeOneLevelDown = 7;
					// Reset Regional Advisor
					} else if ( stFieldSet.statusFieldName EQ 'regionalManagerStatus' AND VAL(ARGUMENTS.regionalAdvisorID) ) {
						vUserTypeOneLevelDown = 6;
					// Reset Regional Manager
					} else if ( stFieldSet.statusFieldName EQ 'facilitatorStatus' ) {
						vUserTypeOneLevelDown = 5;
					}
					
					// This returns the fields that need to be reset
					stFieldReset = getApprovalFieldNames(userType=vUserTypeOneLevelDown);
				</cfscript>
                
				<!--- Update --->
                <cfif VAL(vUserTypeOneLevelDown)>
        
                    <cfquery 
                        datasource="#APPLICATION.DSN#">
                            UPDATE	
                                smg_host_app_history
                            SET
                                #stFieldReset.statusFieldName# = <cfqueryparam cfsqltype="cf_sql_varchar" value="">,
                                #stFieldReset.dateFieldName# = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,
                                #stFieldReset.notesFieldName# = <cfqueryparam cfsqltype="cf_sql_varchar" null="yes">
                            WHERE
                                hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">
                            AND
                                itemID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.itemID)#">                  
                            AND
                                seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.seasonID)#">                   
                    </cfquery>	
                    
              	</cfif> 
                                
            </cfif>
    
    	</cfif>
    
    </cffunction>     
    
    
	<cffunction name="updateReferenceStatus" access="public" returntype="void" output="false" hint="Approves/Denies references">
    	<cfargument name="ID" default="" hint="ID of smg_host_reference_tracking">
        <cfargument name="hostID" default="" hint="HostID is not required">
        <cfargument name="fk_referencesID" default="" hint="fk_referencesID">
        <cfargument name="seasonID" default="#APPLICATION.CFC.LOOKUPTABLES.getCurrentPaperworkSeason().seasonID#" hint="Gets current paperwork season ID">
        <cfargument name="action" default="" hint="Approve/Deny an item">
        <cfargument name="notes" default="" hint="notes, usually reason for denial">
        <cfargument name="areaRepID" default="0" hint="areaRepID is not required">
        <cfargument name="regionalAdvisorID" default="0" hint="regionalAdvisorID is not required">
        <cfargument name="regionalManagerID" default="0" hint="regionalManagerID is not required">
        <cfargument name="dateInterview" default="" hint="dateInterview is not required">
        
        <cfscript>
			// This returns the approval fields for the logged in user
			stFieldSet = getApprovalFieldNames();
		</cfscript>
        
        <cfif listFind("approved,denied", ARGUMENTS.action)>
        
        	<!--- Check if we are Inserting/Updating --->
            <cfif VAL(ARGUMENTS.ID)>
            
				<!--- Update --->
                <cfquery 
                    datasource="#APPLICATION.DSN#">
                        UPDATE	
                            smg_host_reference_tracking
                        SET
                            <cfif isDate(ARGUMENTS.dateInterview)>
                                dateInterview = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.dateInterview#">,
                            </cfif>
                            #stFieldSet.statusFieldName# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.action#">,
                            #stFieldSet.dateFieldName# = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                            #stFieldSet.notesFieldName# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.notes#" null="#yesNoFormat(NOT LEN(ARGUMENTS.notes))#">
                        WHERE
                            ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.ID#">
                        AND
                        	hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">
                </cfquery>	
            
           <cfelse> 
        		
                <!--- INSERT --->
                <cfquery 
                	result="newRecord"
                    datasource="#APPLICATION.DSN#">
                        INSERT INTO 
                            smg_host_reference_tracking 
                        (
                            <cfif isDate(ARGUMENTS.dateInterview)>
                            	dateInterview, 
                            </cfif>
                            interviewer, 
                            arearepID, 
                            fk_referencesID, 
                            hostID,
                            season,
                            #stFieldSet.statusFieldName#,
                            #stFieldSet.dateFieldName#,
                            #stFieldSet.notesFieldName#
                        )
                        VALUES
                        (
                            <cfif isDate(ARGUMENTS.dateInterview)>
                                <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.dateInterview#">, 
                            </cfif>
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#CLIENT.userID#">, 
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.areaRepID)#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.fk_referencesID)#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.hostID#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.seasonID#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.action#">,
                            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.notes#" null="#yesNoFormat(NOT LEN(ARGUMENTS.notes))#">
                        )
				</cfquery>

                <cfscript>
					// Set Generated ID 
					ARGUMENTS.ID = newRecord.GENERATED_KEY;
				</cfscript>
            
            </cfif>
            
            <!--- Reset approval level of denied items | RA denies section 1 and 2 so we'll need to resset the AR approval to NULL for these sections --->
            <cfif ARGUMENTS.action EQ 'denied' AND listFind("regionalAdvisorStatus,regionalManagerStatus,facilitatorStatus", stFieldSet.statusFieldName)>
            	
                <cfscript>
					// Default Values
					vUserTypeOneLevelDown = 0;
				
					// Reset Area Representative
					if ( stFieldSet.statusFieldName EQ 'regionalAdvisorStatus' OR stFieldSet.statusFieldName EQ 'regionalManagerStatus' AND NOT VAL(ARGUMENTS.regionalAdvisorID) ) {
						vUserTypeOneLevelDown = 7;
					// Reset Regional Advisor
					} else if ( stFieldSet.statusFieldName EQ 'regionalManagerStatus' AND VAL(ARGUMENTS.regionalAdvisorID) ) {
						vUserTypeOneLevelDown = 6;
					// Reset Regional Manager
					} else if ( stFieldSet.statusFieldName EQ 'facilitatorStatus' ) {
						vUserTypeOneLevelDown = 5;
					}
					
					// This returns the fields that need to be reset
					stFieldReset = getApprovalFieldNames(userType=vUserTypeOneLevelDown);
				</cfscript>
                
				<!--- Update --->
                <cfif VAL(vUserTypeOneLevelDown) AND VAL(ARGUMENTS.ID)>
        
                    <cfquery 
                        datasource="#APPLICATION.DSN#">
                            UPDATE	
                                smg_host_reference_tracking
                            SET
                                #stFieldReset.statusFieldName# = <cfqueryparam cfsqltype="cf_sql_varchar" value="">,
                                #stFieldReset.dateFieldName# = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,
                                #stFieldReset.notesFieldName# = <cfqueryparam cfsqltype="cf_sql_varchar" null="yes">
                            WHERE
                                ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.ID#">                 
                    </cfquery>	
                    
              	</cfif> 
                                
            </cfif>
    
    	</cfif>
    
    </cffunction>         
        
    
	<cffunction name="submitApplication" access="public" returntype="struct" output="false" hint="Approves a Host Family Application">
        <cfargument name="hostID" default="" hint="hostID">
        <cfargument name="action" default="" hint="approve/deny/newApplication">
        <cfargument name="issueList" default="" hint="Lists issues when denying an application">
        <cfargument name="userType" default="#CLIENT.userType#" hint="userType">

        <cfscript>
			// These are returned to the calling page
			var stReturnMessage = structNew();
			var stReturnMessage.pageMessages = "";
			var stReturnMessage.formErrors = "";

			// Make sure we have correct data
			if ( NOT ListFind("approved,denied,newApplication", ARGUMENTS.action) ) {
				//throw("The action passed is not recognized, please try again", "invalidAction", "This argument must receive an approved/denied variable", "customHostAction1"); 	
				stReturnMessage.formErrors = "The action value passed is not recognized, it must be either approved or denied. Please try again";
				abort;
			}			

			// this is used in the email notification
			var vEmailTo = "";
			vEmailCC = "";
			
			// Default Values
			var vNextStatus = CLIENT.userType;
			var vSetEmailTemplate = "";
			
			// Get Host Family Info - Includes AR, RA, RD and Facilitator information
			var qGetHostInfo = getApplicationList(hostID=ARGUMENTS.hostID);	
			
			// Get Current User
			var vSubmittedBy = SESSION.USER.fullName & " (##" & SESSION.USER.ID & ")";
			var vSubmittedByEmail = SESSION.USER.email;
			
			// New Application - Welcome Email
			if ( ARGUMENTS.action EQ 'newApplication' ) {
				
				vEmailTo = qGetHostInfo.email;
				vSetEmailTemplate = "welcomeEmail";
				stReturnMessage.pageMessages = "E-Host Application Created. A notification has been sent to the host family. Thank you.";
				
			} else {
			
				// Set Next Status Level
				switch ( ARGUMENTS.usertype ) {
					
					// Area Representative
					case 7: 
						
						// Approved
						if ( ARGUMENTS.action EQ 'approved' ) {
							
							// Submit to RA - AR and RA must not be the same
							if ( VAL(qGetHostInfo.regionalAdvisorID) AND qGetHostInfo.regionalAdvisorID NEQ qGetHostInfo.areaRepID ) {
								vNextStatus = 6;	
								vEmailTo = qGetHostInfo.regionalAdvisorEmail;
								vSetEmailTemplate = "submitToRegionalAdvisor";
								stReturnMessage.pageMessages = "Application has been submitted to your Regional Advisor #qGetHostInfo.regionalAdvisor# for review. Thank you.";
							// Submit to RM - AR and RM must not be the same
							} else if ( VAL(qGetHostInfo.regionalManagerID) AND qGetHostInfo.regionalManagerID NEQ qGetHostInfo.areaRepID ) {
								vNextStatus = 5;
								vEmailTo = qGetHostInfo.regionalManagerEmail;
								vSetEmailTemplate = "submitToRegionalManager";
								stReturnMessage.pageMessages = "Application has been submitted to your Regional Manager #qGetHostInfo.regionalManager# for review. Thank you.";
							// Submit to Headquarters
							} else {
								vNextStatus = 4;
								vEmailTo = APPLICATION.CFC.USER.getUserSession().emailCompliance;
								//vEmailTo = qGetHostInfo.facilitatorEmail;
								vSetEmailTemplate = "submitToFacilitator";
								stReturnMessage.pageMessages = "Application has been submitted to your Region Facilitator #qGetHostInfo.facilitator# for review. Thank you.";
							}
							
						// Denied
						} else {
							// Reject to Host Family
							vNextStatus = 8;
							vEmailTo = qGetHostInfo.email;
							// vEmailCC = qGetHostInfo.areaRepresentativeEmail;
							vSetEmailTemplate = "denyToHostFamily";
							stReturnMessage.pageMessages = "Application has been sent back to Host Family as you have suggested some changes. Thank you.";
						}
						
					break;
				
					// Regional Advisor
					case 6: 
					
						// Approved
						if ( ARGUMENTS.action EQ 'approved' ) {
							
							// Submit to RM - RA and RM must not be the same
							if ( VAL(qGetHostInfo.regionalManagerID) AND qGetHostInfo.regionalManagerID NEQ qGetHostInfo.regionalAdvisorID ) {
								vNextStatus = 5;
								vEmailTo = qGetHostInfo.regionalManagerEmail;
								vSetEmailTemplate = "submitToRegionalManager";
								stReturnMessage.pageMessages = "Application has been submitted to your Regional Manager #qGetHostInfo.regionalManager# for review. Thank you.";
							// Submit to Headquarters
							} else {
								vNextStatus = 4;
								vEmailTo = APPLICATION.CFC.USER.getUserSession().emailCompliance;
								//vEmailTo = qGetHostInfo.facilitatorEmail;
								vSetEmailTemplate = "submitToFacilitator";
								stReturnMessage.pageMessages = "Application has been submitted to your Region Facilitator #qGetHostInfo.facilitator# for review. Thank you.";							
							}						
						
						// Denied
						} else {
							
							// Reject to AR - RA and AR must not be the same
							if ( VAL(qGetHostInfo.regionalAdvisorID) AND ( qGetHostInfo.regionalAdvisorID NEQ qGetHostInfo.areaRepID ) ) {
								// Reject to AR
								vNextStatus = 7;
								vEmailTo = qGetHostInfo.areaRepresentativeEmail;
								vEmailCC = qGetHostInfo.regionalAdvisorEmail;
								vSetEmailTemplate = "denyToAreaRepresentative";
								stReturnMessage.pageMessages = "Application has been sent back to Area Representative #qGetHostInfo.areaRepresentative# as you have suggested some changes. Thank you.";
							} else {
								// Reject to Host Family
								vNextStatus = 8;
								vEmailTo = qGetHostInfo.email;
								vEmailCC = qGetHostInfo.regionalAdvisorEmail;
								vSetEmailTemplate = "denyToHostFamily";
								stReturnMessage.pageMessages = "Application has been sent back to Host Family as you have suggested some changes. Thank you.";
							}
								
						}
						
					break;
					
					// Regional Manager
					case 5:
					
						// Approved
						if ( ARGUMENTS.action EQ 'approved' ) {
							// Submit to Headquarters
							vNextStatus = 4;
							// Compliance will be notified
							vEmailTo = APPLICATION.CFC.USER.getUserSession().emailCompliance;
							//vEmailTo = qGetHostInfo.facilitatorEmail;
							vSetEmailTemplate = "submitToFacilitator";
							stReturnMessage.pageMessages = "Application has been submitted to your Region Facilitator #qGetHostInfo.facilitator# for review. Thank you.";
						// Denied
						} else {
							
							// Reject to RA - RM and RA must not be the same
							if ( VAL(qGetHostInfo.regionalAdvisorID) AND qGetHostInfo.regionalAdvisorID NEQ qGetHostInfo.regionalManagerID ) {
								vNextStatus = 6;
								vEmailTo = qGetHostInfo.regionalAdvisorEmail;
								vEmailCC = qGetHostInfo.regionalManagerEmail;
								vSetEmailTemplate = "denyToRegionalAdvisor";
								stReturnMessage.pageMessages = "Application has been sent back to Regional Advisor #qGetHostInfo.regionalAdvisor# as you have suggested some changes. Thank you.";
							// Reject to AR	- RM and AR must not be the same
							} else if ( VAL(qGetHostInfo.areaRepID) AND qGetHostInfo.areaRepID NEQ qGetHostInfo.regionalManagerID ) {
								vNextStatus = 7;
								vEmailTo = qGetHostInfo.areaRepresentativeEmail;
								vEmailCC = qGetHostInfo.regionalManagerEmail;
								vSetEmailTemplate = "denyToAreaRepresentative";
								stReturnMessage.pageMessages = "Application has been sent back to Area Representative #qGetHostInfo.areaRepresentative# as you have suggested some changes. Thank you.";
							// Reject to HF
							} else {
								// Reject to Host Family
								vNextStatus = 8;
								vEmailTo = qGetHostInfo.email;
								vEmailCC = qGetHostInfo.regionalManagerEmail;
								vSetEmailTemplate = "denyToHostFamily";
								stReturnMessage.pageMessages = "Application has been sent back to Host Family as you have suggested some changes. Thank you.";
							}
							
						}
						
					break;
					
					// Office Users
					case 4: 
					case 3:
					case 2:
					case 1: 
	
						// Approved
						if ( ARGUMENTS.action EQ 'approved' ) {
							// Approve Application
							vNextStatus = 3;
							vEmailTo = qGetHostInfo.email;
							
							// Copy RM
							if ( isValid("email", qGetHostInfo.regionalManagerEmail) ) {
								vEmailCC = ListAppend(qGetHostInfo.regionalManagerEmail, ";");
							}
							// Copy RA
							if ( isValid("email", qGetHostInfo.regionalAdvisorEmail) ) {
								vEmailCC = ListAppend(qGetHostInfo.regionalAdvisorEmail, ";");
							}
							// Copy AR
							if ( isValid("email", qGetHostInfo.areaRepresentativeEmail) ) {
								vEmailCC = ListAppend(qGetHostInfo.areaRepresentativeEmail, ";");
							}

							vSetEmailTemplate = "applicationApproved";
							stReturnMessage.pageMessages = "Application has been approved. Thank you.";
							
							// Check if there is a student assigned to this host family and copy data to placement management
							setPlacementManagementPaperwork(hostID=qGetHostInfo.hostID,dateApproved=now());
							
						// Denied
						} else {
							// Reject to RM
							vNextStatus = 5;
							vEmailTo = qGetHostInfo.regionalManagerEmail;
							vEmailCC = APPLICATION.CFC.USER.getUserSession().emailCompliance;
							//vEmailCC = qGetHostInfo.facilitatorEmail;
							vSetEmailTemplate = "denyToRegionalManager";
							stReturnMessage.pageMessages = "Application has been sent back to Regional Manager #qGetHostInfo.regionalManager# as you have suggested some changes. Thank you.";
						}
	
					break;
	
				}
				
				// Update Host Status According to usertype approving/denying the application
				updateApplicationStatus(hostID=qGetHostInfo.hostID,statusID=vNextStatus);
		
			} // New Application - Welcome Email


			// Check if application is being resubmitted or not
			vIsResubmitted = false;

			// Get Application Approval History
			qGetApprovalHistory = APPLICATION.CFC.HOST.getApplicationApprovalHistory(hostID=qGetHostInfo.hostID, whoViews=CLIENT.userType);

			// This Returns who is the next user approving / denying the report
			stUserOneLevelUpInfo = APPLICATION.CFC.USER.getUserOneLevelUpInfo(currentUserType=qGetHostInfo.hostAppStatus,regionalAdvisorID=qGetHostInfo.regionalAdvisorID);
			
			// This returns the fields that need to be checked
			stOneLevelUpFieldSet = APPLICATION.CFC.HOST.getApprovalFieldNames(userType=stUserOneLevelUpInfo.userType);
	
			// Param Form Variables - Approval History
			For ( i=1; i LTE qGetApprovalHistory.recordCount; i++ ) {
				// Check if level app has denied any of the sections
				if ( qGetApprovalHistory[stOneLevelUpFieldSet.statusFieldName][i] EQ 'denied' ) {
					vIsResubmitted = true;
				}
			}


			// Get Email Template
			vGetEmailTemplate = getApplicationEmailTemplate(
				applicatonStatus = qGetHostInfo.hostAppStatus,
				issueList = ARGUMENTS.issueList,												
				emailTemplate = vSetEmailTemplate,
				submittedBy = vSubmittedBy,
				hostFamily = qGetHostInfo.displayHostFamily,
				hostFamilyLastName = qGetHostInfo.familyLastName,
				hostFamilyUsername = qGetHostInfo.email,
				hostFamilyPassword = qGetHostInfo.password,
				areaRepresentative = qGetHostInfo.areaRepresentative,
				areaRepresentativeEmail = qGetHostInfo.areaRepresentativeEmail,
				areaRepresentativePhone = qGetHostInfo.areaRepresentativePhone,
				regionalAdvisor = qGetHostInfo.regionalAdvisor,
				regionalManager = qGetHostInfo.regionalManager,
				facilitator = qGetHostInfo.facilitator,
				isResubmitted = vIsResubmitted
			);
						
			// Try to send out email
			try {
			
				// Create Email Object
				e = createObject("component","nsmg.cfc.email");
				// Send Email
				e.send_mail(
					email_from = CLIENT.email,
					email_to = vEmailTo,
					email_cc = vEmailCC,
					email_subject = vGetEmailTemplate.emailSubject,
					email_message = vGetEmailTemplate.emailBody
				);
			
			// Deal with error - most likely not a valid email address - Append error message
			} catch( any error ) {
				stReturnMessage.formErrors = "There was a problem sending out an email notification";
			}

			return stReturnMessage;
		</cfscript>
        
    </cffunction>
    

	<cffunction name="getApplicationEmailTemplate" access="public" returntype="struct" output="false" hint="Retuns templates based on action">
        <cfargument name="applicationStatus" default="" hint="Current status so we can set the link">
        <cfargument name="issueList" default="" hint="issueList - Not required">
        <cfargument name="emailTemplate" default="" hint="emailTemplate - Not required">
        <cfargument name="submittedBy" default="" hint="submittedBy - Not required">
        <cfargument name="hostFamily" default="" hint="hostFamily - Not required">
        <cfargument name="hostFamilyLastName" default="" hint="hostFamilyLastName - Not required">
        <cfargument name="hostFamilyUsername" default="" hint="hostFamilyUsername - Not required">
        <cfargument name="hostFamilyPassword" default="" hint="hostFamilyPassword - Not required">
        <cfargument name="areaRepresentative" default="" hint="areaRepresentative - Not required">
        <cfargument name="areaRepresentativeEmail" default="" hint="areaRepresentativeEmail - Not required">
        <cfargument name="areaRepresentativePhone" default="" hint="areaRepresentativePhone - Not required">
        <cfargument name="regionalAdvisor" default="" hint="regionalAdvisor - Not required">
        <cfargument name="regionalManager" default="" hint="regionalManager - Not required">
        <cfargument name="facilitator" default="" hint="facilitator - Not required">
        <cfargument name="isResubmitted" default="false" hint="isResubmitted - Not required">
		
        <cfscript>
			// Declare Struct
			var stReturnData = StructNew();
			var stReturnData.emailSubject = "";
			var stReturnData.emailBody = "";	
			
			// Set List of Issues
			var vDisplayIssues = "<p>Please see below a list of issues found:<ul>#ARGUMENTS.issueList#</ul></p>";
			
			if ( ARGUMENTS.isResubmitted ) {
				var vApplicationAction = "Resubmitted";
			} else {
				var vApplicationAction = "Submitted";
			}
			
			/***
				HF Submits = Notify AR
				AR Approves = Notify Advisor/Manager
				AR Denies = Notify HF
				Advisor Approves = Notify Manager
				Advisor Denies = Notify AR
				Manager Approves = Notify Office
				Manager Denies = Notify AR/Advisor
				Office Approves = Notify Host, AR, RA/Manager
			***/
		</cfscript>
    
    	<cfswitch expression="#ARGUMENTS.emailTemplate#">
        	
            <!--- Welcome Email --->
            <cfcase value="welcomeEmail">
            
                <cfscript>
					stReturnData.emailSubject = "#CLIENT.companyshort# - Host Family Application";
				</cfscript>

                <cfsavecontent variable="stReturnData.emailBody">
					<cfoutput>
                        <p>Dear #ARGUMENTS.hostFamilyLastName# Family,</p>
                        
                        <p>Thank you for your interest in student exchange and your commitment to learn more about hosting a student with #CLIENT.companyshort#.</p>
                        
                        <p>This email has been sent to you because your local #CLIENT.companyshort# Area Representative has notified us that you intend to host a student for one of our upcoming programs.</p>
                        
                        <p>Every time you host a student, we are required to have you update the information in your Host Family application.</p>
                        
                        <p>
                            If this is not your first time filling out an online application, your information should all be there when you log in. 
                            We just ask that you review this information and update anything that may have changed from last time you hosted.
                        </p>
                                        
                        <p>                    
                            As you may have been told by your Area Representative, all student exchange companies are strictly governed by the Department of State. 
                            We have done our best to be as unobtrusive and brief as possible while still gathering the information required for you to be properly vetted as a host family. 
                            There is nothing in this application which is not required by the Department of State.
                        </p>
                        
                        <p>
                            This application takes an average of 30 minutes to complete. It does not have to be completed in one sitting. 
                            You can always come back to the application at a later time. 
                            Please keep in mind though, that once the application is submitted to your area rep, you will no longer be able to change any information on the application unless requested by your Area Rep.
                        </p>
        
                        <p>
                            To start filling out your application, please click on the following link:
                            <cfif CLIENT.companyID EQ 10>
                                <a href="http://www.case-usa.org/hostApplication/" target="_blank">http://www.case-usa.org/hostApplication/</a>
                                <!--- <img src="#CLIENT.exits_url#/nsmg/pics/hostAppEmail.jpg" width="200" height="56" border="0"> --->
                            <cfelse>
                                <a href="https://www.iseusa.com/hostApplication/" target="_blank">https://www.iseusa.com/hostApplication/</a>
                            </cfif>
                        </p>

                        <p>
                            <strong>Please use the following login information:</strong>
                        </p>
                        
                        <p>
                            <strong>Email:</strong> #ARGUMENTS.hostFamilyUsername#<br />
                            <strong>Password:</strong> #ARGUMENTS.hostFamilyPassword#<br />
                        </p>
                        
                        <p> 
                            <em>
                                We have just launched this electronic host family application, and you are one of the first families to use this new tool. 
                                Please bear with us as we work out the final "bugs". Should you get any errors or feel that something is confusing, please feel free to let us know how we can improve the process. 
                                There is a live chat and email support available through the application if you need immediate assistance while filling it out. Any and all feedback would be greatly appreciated.
                            </em>
                        </p>
                                        
                        <p>	
                            Thank you, <br />
                            #CLIENT.companyName#
                        </p>
                    </cfoutput>
                </cfsavecontent>
                        
            </cfcase>
            
            
            <!--- Approved - Submit To Regional Advisor --->
        	<cfcase value="submitToRegionalAdvisor">
				
                <cfscript>
					stReturnData.emailSubject = "#CLIENT.companyshort# - Host Family Application #vApplicationAction#";
				</cfscript>
                
                <cfsavecontent variable="stReturnData.emailBody">
					<cfoutput>
                        <p>Dear #ARGUMENTS.regionalAdvisor#,</p>
                        
                        <p>
							This email is being sent to notify you that a Host Family application has been approved by your Area Representative #ARGUMENTS.areaRepresentative#, 
                            for the #ARGUMENTS.hostFamilyLastName# family. This Area Representative has been notified that you have started the review process and will be 
                            contacting them if any additional information is required. 
                        </p>
                        
                        <p>
                        	Please log in to EXITS to view this application or click the link below for direct access (you must be logged in EXITS). <br />
                            <a href="#CLIENT.exits_URL#/nsmg/index.cfm?curdoc=hostApplication/listOfApps&status=7">View Host Family Application</a>
						</p>
                        
                        <p>
                        	Thank you, <br />
                            #CLIENT.companyName#
						</p>              
                    </cfoutput>
                </cfsavecontent>
                            
            </cfcase>
            
            <!--- Approved - Submit To Regional Manager --->
        	<cfcase value="submitToRegionalManager">
            
                <cfscript>
					stReturnData.emailSubject = "#CLIENT.companyshort# - Host Family Application #vApplicationAction#";
				</cfscript>
                
                <cfsavecontent variable="stReturnData.emailBody">
					<cfoutput>
                        <p>Dear #ARGUMENTS.regionalManager#,</p>
                        
                        <p>
							This email is being sent to notify you that a Host Family application has been approved by your 
                            <cfif LEN(ARGUMENTS.regionalAdvisor)>Regional Advisor #ARGUMENTS.regionalAdvisor#<cfelse>Area Representative #ARGUMENTS.areaRepresentative#</cfif> 
                            for the #ARGUMENTS.hostFamilyLastName# family. This representative has been notified that you have started the review process and will be
                            contacting them if any additional information is required. 
                        </p>
                        
                        <p>
                        	Please log in to EXITS to view this application or click the link below for direct access (you must be logged in EXITS). <br />
                            <a href="#CLIENT.exits_URL#/nsmg/index.cfm?curdoc=hostApplication/listOfApps&status=7">View Host Family Application</a>
						</p>
                        
                        <p>
                        	Thank you, <br />
                            #CLIENT.companyName#
						</p>              
                    </cfoutput>
                </cfsavecontent>
                            
            </cfcase>
            
            <!--- Approved - Submit To Facilitator --->
        	<cfcase value="submitToFacilitator">
            
                <cfscript>
					stReturnData.emailSubject = "#CLIENT.companyshort# - Host Family Application #vApplicationAction#";
				</cfscript>
                
                <cfsavecontent variable="stReturnData.emailBody">
					<cfoutput>
                        <p>Dear HQ,</p> <!--- #ARGUMENTS.facilitator#, --->

                        <p>We would like to notify you that an application has been #LCase(vApplicationAction)# for the #ARGUMENTS.hostFamilyLastName# family.</p>
                         
                        <p>
                        	Please log in to EXITS to view this application or click the link below for direct access (you must be logged in EXITS). <br />
                            <a href="#CLIENT.exits_URL#/nsmg/index.cfm?curdoc=hostApplication/listOfApps&status=4">View Host Family Application</a>
						</p>

                        <p>
                        	Thank you, <br />
                            #CLIENT.companyName#
						</p>              
                    </cfoutput>
                </cfsavecontent>
                            
            </cfcase>
            
            <!--- Approved - Notify Host Family | Regional Manager | Regional Advisor | Area Representative --->
        	<cfcase value="applicationApproved">

                <cfscript>
					stReturnData.emailSubject = "#CLIENT.companyshort# - Your Host Family Application Has Been Approved";
				</cfscript>
                				
                <cfsavecontent variable="stReturnData.emailBody">
					<cfoutput>
                        <p>Dear #ARGUMENTS.hostFamilyLastName# Family,</p>
                        
                        <p>
                        	We would like to let you know that your Host Family Application has been approved by our compliance department, here at headquarters. 
                        	We thank you for your hard work and dedication to this process. 
                        </p>
                        
                        <p>Everyone here is excited about your decision to host next season and looks forward to sharing the experience with you.</p>
                        
                        <p>If you have any questions, you should always contact your Area Rep first. In an emergency, you can contact us, here at the headquarters.</p>
                    	
                        <p>Your host family application has been approved by headquarters.</p>
                        
                        <p>
                        	Best Regards, <br />
                            #CLIENT.companyName#
						</p>              
                    </cfoutput>
                </cfsavecontent>
                            
            </cfcase>
        	
            <!--- Denied - Sent back to Host Family --->
        	<cfcase value="denyToHostFamily">

                <cfscript>
					stReturnData.emailSubject = "#CLIENT.companyshort# - Host Family Application Needs Additional Info";
				</cfscript>
				
                <cfsavecontent variable="stReturnData.emailBody">
                	<cfoutput>
                        <p>Dear #ARGUMENTS.hostFamilyLastName# Family,</p>
                        
                        <p>Your Area Representative would like you to submit some additional documents in order to complete your Host Family Application.</p>
                        
                        <p>Please find a list of requested updates below.</p>
                        
                        #vDisplayIssues#
                        
                        <p>To make changes to your application, please log in to our website or click the link below.</p>
                        
                        <p><a href="#APPLICATION.CFC.USER.getUserSession().hostApplicationURL#">#APPLICATION.CFC.USER.getUserSession().hostApplicationURL#</a></p>
                        
                        <p>In case you may have misplaced your login information, we have listed it below.</p>
                        
                        <p>
                            <strong>Email:</strong> #ARGUMENTS.hostFamilyUsername#<br />
                            <strong>Password:</strong> #ARGUMENTS.hostFamilyPassword#<br />
                        </p>
                        
                        <p>All questions can be directed at your Area Representative.</p>
                        
                        <p>
                        	<strong>Area Representative:</strong> #ARGUMENTS.areaRepresentative# <br />
                            <strong>Phone:</strong> #ARGUMENTS.areaRepresentativePhone# <br />
                            <strong>Email:</strong> <a href="mailto:#ARGUMENTS.areaRepresentativeEmail#">#ARGUMENTS.areaRepresentativeEmail#</a>
                        </p>
                        
                        <p>Once again, we would like to thank you for your efforts to support our goal of bringing people of the world closer together.</p>

                        <p>
                        	Thank you, <br />
                            #CLIENT.companyName#
						</p>                            
					</cfoutput>                        
                </cfsavecontent>
                            
            </cfcase>

            <!--- Denied - Sent back to Area Representatitve --->
        	<cfcase value="denyToAreaRepresentative">

                <cfscript>
					stReturnData.emailSubject = "#CLIENT.companyshort# - Host Family Application Needs Additional Info";
				</cfscript>
				
                <cfsavecontent variable="stReturnData.emailBody">
                	<cfoutput>
                        <p>Dear #ARGUMENTS.areaRepresentative#,</p>
                        
                        <p>
	                        This email is intended to notify you that your Regional Advisor #ARGUMENTS.submittedBy# has requested additional information in order to 
                            approve the #ARGUMENTS.hostFamilyLastName# family’s Host Application. 
                        </p>
                        
                        <p>Please find a list of requested updates below.</p>
                        
                        #vDisplayIssues#
                        
                        <p>
                        	Please log in to EXITS to view this application or click the link below for direct access (you must be logged in EXITS). <br />
                            <a href="#CLIENT.exits_URL#/nsmg/index.cfm?curdoc=hostApplication/listOfApps&status=7">View Host Family Application</a>
						</p>
                        
                        <p>
                        	Thank you, <br />
                            #CLIENT.companyName#
						</p>                            
					</cfoutput>
                </cfsavecontent>
                            
            </cfcase>
            
            <!--- Denied - Sent back to Regional Advisor --->
        	<cfcase value="denyToRegionalAdvisor">

                <cfscript>
					stReturnData.emailSubject = "#CLIENT.companyshort# - Host Family Application Needs Additional Info";
				</cfscript>
				
                <cfsavecontent variable="stReturnData.emailBody">
                	<cfoutput>
                        <p>Dear #ARGUMENTS.regionalAdvisor#,</p>
                        
                        <p>
	                        This email is intended to notify you that your Regional Advisor #ARGUMENTS.submittedBy# has requested additional information in order to 
                            approve the #ARGUMENTS.hostFamilyLastName# family’s Host Application. 
                        </p>
                        
                        <p>Please find a list of requested updates below.</p>
                        
                        #vDisplayIssues#
                        
                        <p>
                        	Please log in to EXITS to view this application or click the link below for direct access (you must be logged in EXITS). <br />
                            <a href="#CLIENT.exits_URL#/nsmg/index.cfm?curdoc=hostApplication/listOfApps&status=6">View Host Family Application</a>
						</p>
                        
                        <p>
                        	Thank you, <br />
                            #CLIENT.companyName#
						</p>                            
					</cfoutput>                        
                </cfsavecontent>
                            
            </cfcase>

            <!--- Denied - Sent back to Regional Manager --->
        	<cfcase value="denyToRegionalManager">

                <cfscript>
					stReturnData.emailSubject = "#CLIENT.companyshort# - Host Family Application Needs Additional Info";
				</cfscript>
				
                <cfsavecontent variable="stReturnData.emailBody">
                	<cfoutput>
                        <p>Dear #ARGUMENTS.regionalManager#,</p>
                        
                        <p>
	                        This email is intended to notify you that your Facilitator #ARGUMENTS.submittedBy# has requested additional information in order to 
                            approve the #ARGUMENTS.hostFamilyLastName# family’s Host Application. 
                        </p>
                        
                        <p>Please find a list of requested updates below.</p>
                        
                        #vDisplayIssues#
                        
                        <p>
                        	Please log in to EXITS to view this application or click the link below for direct access (you must be logged in EXITS). <br />
                            <a href="#CLIENT.exits_URL#/nsmg/index.cfm?curdoc=hostApplication/listOfApps&status=5">View Host Family Application</a>
						</p>
                        
                        <p>
                        	Thank you, <br />
                            #CLIENT.companyName#
						</p>                            
					</cfoutput>                        
                </cfsavecontent>
                            
            </cfcase>
            
        </cfswitch>
        
        <cfscript>
			return stReturnData;
		</cfscript>

	</cffunction>     


	<cffunction name="setPlacementManagementPaperwork" access="public" returntype="void" output="false" hint="Copy paperwork data upon HF approval or student placement">
        <cfargument name="hostID" default="" hint="HostID is not required">
        <cfargument name="dateApproved" default="" hint="dateApproved is not required">

        <cfscript>	
			// Get List of Host Family Applications
			var	qGetHostInfo = APPLICATION.CFC.HOST.getApplicationList(hostID=ARGUMENTS.hostID);	

			// Date submitted by Host Family
			var vDateFamilySubmitted = qGetHostInfo.dateApplicationSubmitted;
			
			// Date of office approval
			var vDateOfficeApproved = ARGUMENTS.dateApproved;
			
			// Reference Questionnaire
			var vDateReferenceInterviewed1 = "";
			var vDateReferenceInterviewed2 = "";

			// Get Host Family Headquarters Most Recent Approval Date
			if ( NOT isDate(vDateOfficeApproved) ) {
				// Get Application Approval History
				qGetApprovalHistory = APPLICATION.CFC.HOST.getApplicationApprovalHistory(hostID=ARGUMENTS.hostID, whoViews=CLIENT.userType, sortBy="facilitatorDateStatus", sortOrder="DESC");
				vDateOfficeApproved = qGetApprovalHistory.facilitatorDateStatus;
			}				
			
			// Check if there is a student assigned to this host family (same season)
			var stCheckFamily = isFamilyCurrentlyHosting(hostID=ARGUMENTS.hostID);
			
			// Family Hosting - Update Paperwork
			if ( stCheckFamily.isHosting ) {
				
				// Get References
				qGetReferences = APPLICATION.CFC.HOST.getReferences(hostID=ARGUMENTS.hostID);
				
				// Try to get Reference 1
				try {
					vDateReferenceInterviewed1 = qGetReferences.dateInterview[1];
				} catch( any error ) {
					// Error Found
				}

				// Try to get Reference 2
				try {
					vDateReferenceInterviewed2 = qGetReferences.dateInterview[2];
				} catch( any error ) {
					// Error Found
				}
				
				// Get Confidential Visit Form
				qGetConfidentialVisitForm = APPLICATION.CFC.PROGRESSREPORT.getVisitInformation(hostID=ARGUMENTS.hostID,reportType=5);
				
				// Loop Through History ID list to update placement paperwork
	            For ( i=1; i LTE ListLen(stCheckFamily.hostHistoryListID); i++ ) {
					
					// Update Student Placement Paperwork
					APPLICATION.CFC.STUDENT.updatePlacementPaperworkUponHostFamilyAppApproval(
						historyID= ListGetAt(stCheckFamily.hostHistoryListID, i),																	  
						dateReceived=vDateOfficeApproved,																  
						doc_host_app_page1_date=vDateOfficeApproved,
						doc_host_app_page2_date=vDateOfficeApproved,	
						doc_letter_rec_date=vDateOfficeApproved,	
						doc_photos_rec_date=vDateOfficeApproved,	
						doc_bedroom_photo=vDateOfficeApproved,	
						doc_bathroom_photo=vDateOfficeApproved,	
						doc_kitchen_photo=vDateOfficeApproved,	
						doc_living_room_photo=vDateOfficeApproved,	
						doc_outside_photo=vDateOfficeApproved,	
						doc_rules_rec_date=vDateOfficeApproved,	
						doc_rules_sign_date=vDateFamilySubmitted, // Date HF submitted application	
						doc_school_profile_rec=vDateOfficeApproved,	
						doc_income_ver_date=vDateOfficeApproved,	
						doc_conf_host_rec=vDateOfficeApproved,	
						doc_date_of_visit=qGetConfidentialVisitForm.dateOfVisit, // Date of Visit from form
						doc_ref_form_1=vDateOfficeApproved,	
						doc_ref_check1=vDateReferenceInterviewed1, // Date of questionnaire
						doc_ref_form_2=vDateOfficeApproved,	
						doc_ref_check2=vDateReferenceInterviewed2 // Date of questionnaire	
					);	
				
				}

			}
		</cfscript>
            
    </cffunction>  
    
    
	<cffunction name="isFamilyCurrentlyHosting" access="public" returntype="struct" output="false" hint="Checks if a host family is linked to an active student">
        <cfargument name="hostID" default="" hint="HostID is not required">
        <cfargument name="seasonID" default="#APPLICATION.CFC.LOOKUPTABLES.getCurrentPaperworkSeason().seasonID#" hint="seasonID is not required">
		
        <cfscript>
			// Check for students that are assigned to programs on the same season and are currently being hosted by hostID
			// Return struct with true/false statament and a list of history IDs
			var stResult = StructNew();
			
			stResult.isHosting = false;
			stResult.hostHistoryListID = false;
		</cfscript>
        
        <cfquery 
			name="qIsFamilyCurrentlyHosting" 
			datasource="#APPLICATION.DSN#">
				SELECT DISTINCT
                	s.studentID,
                    h.historyID
                FROM
                	smg_students s
       			INNER JOIN
                	smg_programs p ON p.programID = s.programID
                    AND
                    	p.smgSeasonID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#VAL(ARGUMENTS.seasonID)#">  
				INNER JOIN
                	smg_hostHistory h ON h.studentID = s.studentID
                    AND
                    	h.isActive = 1
                    AND
                		h.hostID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#VAL(ARGUMENTS.hostID)#"> 
					<!--- Do not get PHP students --->
                    AND
                		h.assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">  
				WHERE                        
					<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
                        s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(APPLICATION.SETTINGS.COMPANYLIST.ISESMG)#" list="yes"> )
                    <cfelseif VAL(CLIENT.companyID)>
                        s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.companyID)#"> 
                    </cfif>
        </cfquery>

        <cfscript>
			// Populate Results
			if ( qIsFamilyCurrentlyHosting.recordCount ) {
				stResult.isHosting = true;
				// This is the list of IDS that we are going to update paperwork
				stResult.hostHistoryListID = ValueList(qIsFamilyCurrentlyHosting.historyID);
			}
		
			// Return Query
			return stResult;
		</cfscript>
            	
    </cffunction>  

        

	<!--- ------------------------------------------------------------------------- ----
		END OF HOST FAMILY APPLICATION
	----- ------------------------------------------------------------------------- --->


	<!--- ------------------------------------------------------------------------- ----
		HOST LEADS
	----- ------------------------------------------------------------------------- --->

	<cffunction name="getHostLeads" access="public" returntype="query" output="false" hint="Gets host leads entered from ISEUSA.com">
        <cfargument name="sortBy" type="string" default="dateCreated" hint="sortBy is not required">
        <cfargument name="sortOrder" type="string" default="ASC" hint="sortOrder is not required">
        <cfargument name="isDeleted" type="string" default="0" hint="isDeleted is not required">
        
        <cfquery 
			name="qGetHostLeads" 
			datasource="#APPLICATION.DSN#">
                SELECT
					hl.ID,
                    hl.regionID,
                    hl.areaRepID,
                    hl.statusID,
                    hl.firstName,
                    hl.lastName,
                    hl.address,
                    hl.address2,
                    hl.city,
                    hl.stateID,
                    hl.zipCode,
                    hl.phone,
                    hl.email,
                    hl.hearAboutUs,
                    hl.hearAboutUsDetail,
                    hl.isListSubscriber,
                    hl.dateCreated,
                    hl.dateUpdated,
                    r.regionName AS regionAssigned,
                    CONCAT(u.firstName, ' ', u.lastName) AS areaRepAssigned,
                    alk.name AS statusAssigned
                FROM 
                    smg_host_lead hl
                LEFT OUTER JOIN
                	smg_states st ON st.id = hl.stateID
                LEFT OUTER JOIN
                	smg_regions r ON r.regionID = hl.regionID
                LEFT OUTER JOIN
                	smg_users u ON u.userID = hl.areaRepID    
                LEFT OUTER JOIN
                	applicationLookUp alk ON alk.fieldID = hl.statusID 
                    	AND 
                            alk.fieldKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="hostLeadStatus">
                WHERE
                	isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="#ARGUMENTS.isDeleted#">

                ORDER BY
                
                <cfswitch expression="#ARGUMENTS.sortBy#">
                    
                    <cfcase value="firstName">                    
                        hl.firstName,
                        hl.lastName
                    </cfcase>
                
                    <cfcase value="lastName">
                        hl.lastName,
                        hl.firstName
                    </cfcase>
    
                    <cfcase value="city">
                        hl.city
                    </cfcase>
    
                    <cfcase value="state">
                        st.state
                    </cfcase>
    
                    <cfcase value="dateCreated">
                        hl.dateCreated,
                        hl.lastName
                    </cfcase>
    
                    <cfdefaultcase>
                        hl.dateCreated DESC,
                        hl.lastName
                    </cfdefaultcase>
    
                </cfswitch>   
            
		</cfquery>
		   
		<cfreturn qGetHostLeads>
	</cffunction>


	<cffunction name="getPendingHostLeads" access="public" returntype="query" output="false" hint="Gets a list of pending leads assigned to a region or user">
        <cfargument name="userType" type="numeric" hint="userType is required">
        <cfargument name="regionID" type="numeric" hint="regionID is required">
        <cfargument name="areaRepID" type="numeric" default="0" hint="areaRepID is not required">
        <cfargument name="lastLogin" default="" hint="lastLogin is not required">
        <cfargument name="setClientVariable" type="numeric" default="0" hint="Set to 1 to display popUp on initial welcome">
        
        <cfscript>
			// If there is no last login date, use now() instead
			if ( NOT IsDate(ARGUMENTS.lastLogin) ) {
				ARGUMENTS.lastLogin = now();
			}		
		</cfscript>
        
        <cfquery 
			name="qGetPendingHostLeads" 
			datasource="#APPLICATION.DSN#">
                SELECT
					hl.ID,
                    hl.hashID,
                    hl.regionID,
                    hl.areaRepID,
                    hl.statusID,
                    hl.firstName,
                    hl.lastName,
                    hl.address,
                    hl.address2,
                    hl.city,
                    hl.stateID,
                    hl.zipCode,
                    hl.phone,
                    hl.email,
                    hl.hearAboutUs,
                    hl.hearAboutUsDetail,
                    hl.isListSubscriber,
                    hl.dateCreated,
                    hl.dateUpdated,
                    st.stateName,
                    r.regionName AS regionAssigned,
                    CONCAT(u.firstName, ' ', u.lastName) AS areaRepAssigned,
                    alk.name AS statusAssigned
                FROM 
                    smg_host_lead hl
                LEFT OUTER JOIN
                	smg_states st ON st.id = hl.stateID
                LEFT OUTER JOIN
                	smg_regions r ON r.regionID = hl.regionID
                LEFT OUTER JOIN
                	smg_users u ON u.userID = hl.areaRepID    
                LEFT OUTER JOIN
                	applicationLookUp alk ON alk.fieldID = hl.statusID 
                    	AND 
                            alk.fieldKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="hostLeadStatus">
                WHERE
                	hl.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
				
                AND
                    hl.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.regionID#">

				<cfif ARGUMENTS.userType NEQ 5 AND VAL(ARGUMENTS.areaRepID)>
                    <!--- Advisors / Area Representatives --->
                    AND
                        hl.areaRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.areaRepID#">
                </cfif>
                
                AND
                    (
                    	<!--- Get New Host Leads | 3 = Not Interested | 8 = Committed to Host | 9 - Interested in Hosting in the Future --->
                    	hl.dateUpdated >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ARGUMENTS.lastLogin#">
					 AND
                     	hl.statusID NOT IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="3,8,9" list="yes"> )

                     OR
                     	<!--- Get Host Leads That do not have a final disposition --->
                     	hl.ID NOT IN (
                        	SELECT
                            	ID
                            FROM
                            	smg_host_lead
                            WHERE	
                            	statusID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="3,8" list="yes"> )
                        )
                     
                     )
                ORDER BY
                    hl.dateCreated,
                    hl.lastName
		</cfquery>

        <cfscript>
			// Set CLIENT.isTherePendingHostLeads
			if ( VAL(ARGUMENTS.setClientVariable) AND qGetPendingHostLeads.recordcount ) {
				CLIENT.displayHostLeadPopUp = 1;	
			}
			
			return qGetPendingHostLeads;
		</cfscript>
		   
	</cffunction>


	<cffunction name="getHostLeadByID" access="public" returntype="query" output="false" hint="Gets host leads entered from ISEUSA.com">
        <cfargument name="ID" type="numeric" required="yes" hint="ID is required">
        
        <cfquery 
			name="qGetHostLeadByID" 
			datasource="#APPLICATION.DSN#">
                SELECT
					hl.ID,
                    hl.hashID,
                    hl.statusID,
                    hl.followUpID,	
                    hl.regionID,
                    hl.areaRepID,                    				
                    hl.firstName,
                    hl.lastName,
                    hl.address,
                    hl.address2,
                    hl.city,
                    hl.stateID,
                    hl.zipCode,
                    hl.phone,
                    hl.email,
                    hl.password,
                    hl.hearAboutUs,
                    hl.hearAboutUsDetail,
                    hl.isListSubscriber,
                    hl.dateLastLoggedIn,
                    hl.dateCreated,
                    hl.dateUpdated,
                    <!--- Follow Up Representative --->
                    CONCAT(fu.firstName, ' ', fu.lastName) AS followUpAssigned,
					<!--- State --->
                    st.state,
                    <!--- Region --->
                    r.regionName AS regionAssigned,
                    <!--- Company --->
                    c.companyID,
                    c.companyShort,
                    <!--- Area Representative --->
                    CAST(CONCAT(u.firstName, ' ', u.lastName,  ' ##', u.userID) AS CHAR) AS areaRepAssigned,
                    <!--- Status --->
                    alk.name AS statusAssigned
                FROM 
                    smg_host_lead hl
                LEFT OUTER JOIN
                	smg_users fu ON fu.userID = hl.followUpID    
                LEFT OUTER JOIN
                	smg_states st ON st.id = hl.stateID
                LEFT OUTER JOIN
                	smg_regions r ON r.regionID = hl.regionID
                LEFT OUTER JOIN
                	smg_companies c ON c.companyID = r.company
                LEFT OUTER JOIN
                	smg_users u ON u.userID = hl.areaRepID    
                LEFT OUTER JOIN
                	applicationLookUp alk ON alk.fieldID = hl.statusID 
                    	AND 
                            alk.fieldKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="hostLeadStatus">
                WHERE
                	isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                AND	
                	hl.ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.ID#">

				ORDER BY	
                   hl.dateUpdated DESC                 
		</cfquery>
		   
		<cfreturn qGetHostLeadByID>
	</cffunction>
    
    
	<cffunction name="setHostLeadDataIntegrity" access="public" returntype="void" output="false" hint="This makes sure that all records have a hashID and a history">
        
		<!--- Insert HashID --->
        <cfquery 
			name="qGetHostNoHashID" 
			datasource="#APPLICATION.DSN.source#">
                SELECT
                    ID
                FROM
                    smg_host_lead
                WHERE
                    hashID = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
        </cfquery>
        
        <cfloop query="qGetHostNoHashID">
            <cfquery datasource="MySQL">
                UPDATE
                    smg_host_lead
                SET
                    hashID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.generateHashID(qGetHostNoHashID.ID)#">
                WHERE
                    ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetHostNoHashID.ID#">
            </cfquery>
        </cfloop>
        
        <!--- Insert Initial Comment --->
        <cfquery 
			name="qGetHostNoHistory" 
			datasource="#APPLICATION.DSN.source#">
            SELECT
                ID,
                dateCreated,
                dateUpdated
            FROM
                smg_host_lead
            WHERE
                ID NOT IN 
                    (
                        SELECT
                            foreignID
                        FROM
                            applicationHistory
                        WHERE
                            foreignTable = <cfqueryparam cfsqltype="cf_sql_varchar" value="smg_host_lead">
                    ) 
        </cfquery>
				
		<cfscript>
			// Loop through query
            For ( i=1; i LTE qGetHostNoHistory.recordCount; i++ ) {
				
				// Insert Initial Comment
                APPLICATION.CFC.LOOKUPTABLES.insertApplicationHistory(
                    applicationID=6,
                    foreignTable='smg_host_lead',
                    foreignID=qGetHostNoHistory.ID[i],
                    actions='Status: Initial - Host Lead Received',
                    dateCreated=qGetHostNoHistory.dateCreated[i],
                    dateUpdated=qGetHostNoHistory.dateUpdated[i]
                );
				
            }
        </cfscript>

	</cffunction>
       
    
	<cffunction name="updateHostLead" access="public" returntype="void" output="false" hint="Updates host lead JN">
        <cfargument name="ID" type="numeric" required="yes" hint="ID is required">
        <cfargument name="followUpID" type="numeric" required="yes" hint="followUpID is required">
        <cfargument name="regionID" type="numeric" required="yes" hint="regionID is required">        
        <cfargument name="areaRepID" type="numeric" required="yes" hint="areaRepID is required">
        <cfargument name="statusID" type="numeric" required="yes" hint="statusID is required">
        <cfargument name="enteredByID" type="numeric" required="yes" hint="enteredByID is required">
        <cfargument name="comments" type="string" default="" hint="comments is not required">
        
        <cfscript>
			// Set actions
			var vActions = "";
			
			// Get current host lead information
			qGetHostLead = getHostLeadByID(ID=ARGUMENTS.ID);				

			// Get User Information
			qGetFollowUpUser = APPLICATION.CFC.USER.getUserByID(userID=ARGUMENTS.followUpID);

			// Get User Information
			qGetUser = APPLICATION.CFC.USER.getUserByID(userID=ARGUMENTS.areaRepID);

			// Get Entered By Information
			qGetEnterBy = APPLICATION.CFC.USER.getUserByID(userID=ARGUMENTS.enteredByID);
			
			// Get Status
			qGetStatus = APPLICATION.CFC.LOOKUPTABLES.getApplicationLookUp(fieldKey='hostLeadStatus',fieldID=ARGUMENTS.statusID);
		</cfscript>
        
        <cfsavecontent variable="emailNewHostLead">
            <cfoutput>
                <p>Dear #qGetUser.firstName# #qGetUser.lastName#,</p>
                
                <p>A new host family lead has been assigned to you. Please see the details below:</p>
                
                Name: #qGetHostLead.firstName# #qGetHostLead.lastName# <br />
                Location: #qGetHostLead.city#, #qGetHostLead.state# <br />
                Phone Number: #qGetHostLead.phone# <br />
                Email Address: #qGetHostLead.email# <br />
                
                <cfif LEN(ARGUMENTS.comments)>
                    Comments: #ARGUMENTS.comments# <br />
                </cfif>
                
                <p>Please visit <a href="#CLIENT.exits_url#">#CLIENT.exits_url#</a> to view the complete host lead information.</p>
                
                Regards, <Br />
                #CLIENT.companyName#
			</cfoutput>
        </cfsavecontent>

        <cfsavecontent variable="emailFinalDecision">
            <cfoutput>
                <p>NY Office-</p>
                
                <p>The host lead below has received a final decision.</p>
                
                Name: #qGetHostLead.firstName# #qGetHostLead.lastName# <br />
                Location: #qGetHostLead.city#, #qGetHostLead.state# <br />
                Phone Number: #qGetHostLead.phone# <br />
                Email Address: #qGetHostLead.email# <br />                
                Decision: #qGetStatus.name# <br />     
                Comments: #ARGUMENTS.comments# <br />
                Updated By: #qGetEnterBy.firstName# #qGetEnterBy.lastName# ###qGetEnterBy.userID# <br />
                
                <p>Please visit <a href="#CLIENT.exits_url#">#CLIENT.exits_url#</a> to view the complete host lead information.</p>
                
                Regards, <Br />
                #CLIENT.companyName#
			</cfoutput>
        </cfsavecontent>
    
        <cfscript>	
			// Follow Up User
			if ( ARGUMENTS.followUpID NEQ qGetHostLead.followUpID ) {
				// Assign new area rep 
				vActions = vActions & "Follow Up Representative: #qGetFollowUpUser.firstName# #qGetFollowUpUser.lastName# ###qGetFollowUpUser.userID# <br /> #CHR(13)#";
				
			}
		
			// Region
			if ( ARGUMENTS.regionID NEQ qGetHostLead.regionID ) {
				// Get Region Information
				qGetRegion = APPLICATION.CFC.REGION.getRegions(regionID=ARGUMENTS.regionID);
				// Assign new region
				vActions = vActions & "Region: #qGetRegion.regionName# ###qGetRegion.regionID# <br /> #CHR(13)#";
			}

			// Area Representative
			if ( ARGUMENTS.areaRepID NEQ qGetHostLead.areaRepID ) {
				// Assign new area rep 
				vActions = vActions & "Area Representative: #qGetUser.firstName# #qGetUser.lastName# ###qGetUser.userID# <br /> #CHR(13)#";
				
				// Email Area Representative / Production Only
				if ( NOT APPLICATION.isServerLocal AND isvalid("email", qGetUser.Email) ) { 
					
					// Create Object
					oEmail = createObject("component","nsmg.cfc.email");
					
					// Send Out Email
					oEmail.send_mail(
						email_to=qGetUser.email,
						email_from='#companyshort#-support@exitsapplication.com',
						email_subject='New Host Family Lead Assigned To You',
						email_message=emailNewHostLead
					);
					
				}
				
			}
			
			// Status
			if ( ARGUMENTS.statusID NEQ qGetHostLead.statusID ) {
				// Get Status Information
				qGetStatus = APPLICATION.CFC.LOOKUPTABLES.getApplicationLookUp(fieldKey='hostLeadStatus',fieldID=ARGUMENTS.statusID);				
				// Assign new statusID
				vActions = vActions & "Status: #qGetStatus.name# <br /> #CHR(13)#";
			}
			
			// Comments
			if ( LEN(ARGUMENTS.comments) ) {
				vActions = vActions & "Comment added <br /> #CHR(13)#";
			}
			
			// Check if information has been updated
			if ( LEN(vActions) ) {
				
				// Add User and TimeStamp Information
				vActions = vActions & "Assigned by: #qGetEnterBy.firstName# #qGetEnterBy.lastName# ###qGetEnterBy.userID# <br /> #CHR(13)#";

				// Insert New History
				APPLICATION.CFC.LOOKUPTABLES.insertApplicationHistory(
					applicationID=APPLICATION.CONSTANTS.TYPE.hostFamilyLead,
					foreignTable='smg_host_lead',
					foreignID=ARGUMENTS.ID,
					enteredByID=ARGUMENTS.enteredByID,
					actions=vActions,
					comments=ARGUMENTS.comments
				);
				
				// Final Decisions (Not Interested / Committed to Host) - Email Budge/Bob
				if ( ListFind("3,8", ARGUMENTS.statusID) ) {
					
					// Create Object
					oEmail = createObject("component","nsmg.cfc.email");
					
					// Send Out Email
					oEmail.send_mail(
						email_to=APPLICATION.EMAIL.hostLeadNotifications,
						email_from='#companyshort#-support@exitsapplication.com',
						email_subject='Host Lead - #qGetHostLead.lastName# from #qGetHostLead.city#, #qGetHostLead.state# - final decision',
						email_message=emailFinalDecision
					);
					
				}

			}
		</cfscript>
			
		<!--- Update Host Lead --->
        <cfquery 
            datasource="#APPLICATION.DSN#">
                UPDATE
                    smg_host_lead
                SET
                    statusID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.statusID)#">,
                    followUpID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.followUpID)#">,
                    regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.regionID)#">,
                    areaRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.areaRepID)#">
                WHERE	                        
                    ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.ID#">
        </cfquery>
            
    </cffunction>


	<cffunction name="exportHostLeads" access="public" returntype="query" output="false" hint="Export Leads to Excel">
		<cfargument name="dateExported" default="" hint="Gets new leads if no date is passed">
        
        <cfquery 
			name="qExportHostLeads" 
			datasource="#APPLICATION.DSN#">
                SELECT
                	ID,
                    firstName,
                    lastName,
                    email,
					dateExported
                FROM 
                    smg_host_lead
                WHERE
 					isListSubscriber = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                AND	
                	isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                        
                <cfif isDate(ARGUMENTS.dateExported)>
                    AND	                    
                        dateExported = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ARGUMENTS.dateExported#">             
				<cfelse>
                	AND
                    	dateExported IS NULL				
				</cfif>
                
                ORDER BY
                	dateCreated DESC
		</cfquery>
		
        <cfscript>
			// Add IDs to a list
			vIDList = ValueList(qExportHostLeads.ID);
		</cfscript>
        
        <!--- Record date leads were exported --->
        <cfif LEN(vIDList)>
       
            <cfquery 
                datasource="#APPLICATION.DSN#">
                    UPDATE
                        smg_host_lead
                    SET	
                    	dateExported = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                    WHERE
                        ID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#vIDList#" list="yes"> )
            </cfquery>
        
        </cfif>
           
		<cfreturn qExportHostLeads>
	</cffunction>


	<cffunction name="getHostLeadExportHistory" access="public" returntype="query" output="false" hint="Lists export history">

        <cfquery 
			name="qGetHostLeadExportHistory" 
			datasource="#APPLICATION.DSN#">
                SELECT
                	count(ID) AS totalLeads,
					dateExported
                FROM 
                    smg_host_lead
				WHERE
                	dateExported IS NOT NULL                    
                GROUP BY            
                    dateExported                  
                ORDER BY            
                    dateExported DESC
                LIMIT
                	30
		</cfquery>
		   
		<cfreturn qGetHostLeadExportHistory>
	</cffunction>

    
    
    <!--- 
		Start of Remote Functions 
	--->
	<cffunction name="getHostLeadsRemote" access="remote" returnFormat="json" output="false" hint="Returns host leads in Json format">
        <cfargument name="pageNumber" type="numeric" default="1" hint="Page number is not required">
        <cfargument name="keyword" type="string" default="" hint="keyword is not required">
        <cfargument name="followUpID" type="numeric" default="0" hint="followUpID is not required">
        <cfargument name="regionID" type="string" default="0" hint="regionID is not required">
        <cfargument name="stateID" type="string" default="0" hint="keyword is not required">
        <cfargument name="statusID" type="string" default="" hint="statusID is not required">
        <cfargument name="sortBy" type="string" default="dateCreated" hint="sortBy is not required">
        <cfargument name="sortOrder" type="string" default="DESC" hint="sortOrder is not required">
        <cfargument name="numberOfRecordsOnPage" type="numeric" default="30" hint="Page number is not required">
        <cfargument name="isDeleted" type="numeric" default="0" hint="isDeleted is not required">
        <cfargument name="hasLoggedIn" type="numeric" default="0" hint="hasLoggedIn is not required">
		
        <cfscript>
			if ( NOT ListFind("ASC,DESC", ARGUMENTS.sortOrder ) ) {
				ARGUMENTS.sortOrder = 'DESC';			  
			}
		</cfscript>
              
        <cfquery 
			name="qGetHostLeadsRemote" 
			datasource="#APPLICATION.DSN#">
                SELECT
					hl.ID,
                    <!--- 17E0 was being displayed as 17 or 17.0 --->
					<!--- CAST(hl.hashID AS CHAR) AS hashID, --->
                    <!--- CONVERT(hl.hashID USING utf8) AS hashID, --->                    
                    CONCAT(hl.hashID, '&') AS hashID,
                    hl.statusID,
                    hl.followUpID,
                    hl.regionID,
                    hl.areaRepID,
                    hl.firstName,
                    hl.lastName,
                    hl.address,
                    hl.address2,
                    hl.city,
                    hl.zipCode,
                    hl.phone,
                    hl.email,
                    hl.hearAboutUs,
                    hl.hearAboutUsDetail,
                    hl.isListSubscriber,
                    DATE_FORMAT(hl.dateCreated, '%m/%e/%Y') as dateCreated,
                    DATE_FORMAT(hl.dateLastLoggedIn, '%m/%e/%Y') as dateLastLoggedIn,
                    <!--- Follow Up Representative --->
                    CONCAT(fu.firstName, ' ', fu.lastName) AS followUpAssigned,
                    <!--- State --->
                    st.state,
                    <!--- Region --->
                    r.regionName AS regionAssigned,
                    <!--- Area Representative --->
                    CONCAT(u.firstName, ' ', u.lastName) AS areaRepAssigned,
                    <!--- Status --->
                    alk.name AS statusAssigned
                FROM 
                    smg_host_lead hl
                LEFT OUTER JOIN
                	smg_users fu ON fu.userID = hl.followUpID    
                LEFT OUTER JOIN
                	smg_states st ON st.id = hl.stateID
                LEFT OUTER JOIN
                	smg_regions r ON r.regionID = hl.regionID
                LEFT OUTER JOIN
                	smg_users u ON u.userID = hl.areaRepID    
                LEFT OUTER JOIN
                	applicationLookUp alk ON alk.fieldID = hl.statusID 
                    	AND 
                            alk.fieldKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="hostLeadStatus">
                WHERE
                	hl.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="#ARGUMENTS.isDeleted#">
				
                <!--- Get Only Leads Entered as of 04/01/2011 --->
                AND
                	(
                    	hl.dateCreated >= <cfqueryparam cfsqltype="cf_sql_date" value="2011/04/01">
                	OR
                    	hl.dateLastLoggedIn IS NOT NULL	
                	)
                    
                <cfif VAL(ARGUMENTS.hasLoggedIn)>
                    AND	
                        hl.dateLastLoggedIn IS NOT NULL
				</cfif>                    

				<cfif CLIENT.companyID NEQ 5>
                    AND
                        r.company = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
                </cfif>

                <!--- Screnner --->
                <cfif CLIENT.userType EQ 26>
                	AND
                    	hl.followUpID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
                </cfif>
                
                <!--- RA and AR can only see leads assigned to them --->
                <cfif ListFind("6,7,9", CLIENT.userType)>
                	AND
                    	hl.areaRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
                </cfif>

				<cfif VAL(ARGUMENTS.followUpID)>
                    AND
                        hl.followUpID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.followUpID#">
                </cfif>
				
				<cfif VAL(ARGUMENTS.regionID)>
                    AND
                        hl.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.regionID#">
                </cfif>

                <cfif VAL(ARGUMENTS.statusID)>
                    AND
                        hl.statusID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.statusID#">
                <cfelseif ARGUMENTS.statusID NEQ 'All'>
                	<!--- Do not display final dispositions: 3=Not Interested / 8=Converted to Host Family --->
                    AND
						hl.statusID NOT IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="3,8" list="yes"> )
				</cfif>
                
                <cfif LEN(ARGUMENTS.keyword)>
                	AND
                    	(
                        	hl.firstName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ARGUMENTS.keyword#%">
	                	OR
                        	hl.lastName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ARGUMENTS.keyword#%">
	                	OR
                        	hl.address LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ARGUMENTS.keyword#%">
	                	OR
                        	hl.city LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ARGUMENTS.keyword#%">
	                	OR
                        	st.state LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ARGUMENTS.keyword#%">
	                	OR
                        	hl.zipCode LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ARGUMENTS.keyword#%">
	                	OR
                        	hl.email LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ARGUMENTS.keyword#%">
                        )
                </cfif>

                <cfif VAL(ARGUMENTS.stateID)>
                	AND
                        hl.stateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.stateID#">
                </cfif>
                
                ORDER BY
                
                <cfswitch expression="#ARGUMENTS.sortBy#">
                    
                    <cfcase value="firstName">                    
                        hl.firstName #ARGUMENTS.sortOrder#,
                        hl.lastName
                    </cfcase>
                
                    <cfcase value="lastName">
                        hl.lastName #ARGUMENTS.sortOrder#,
                        hl.firstName
                    </cfcase>
    
                    <cfcase value="city">
                        hl.city #ARGUMENTS.sortOrder#,
                        hl.lastName
                    </cfcase>
    
                    <cfcase value="state">
                        st.state #ARGUMENTS.sortOrder#,
                        hl.lastName
                    </cfcase>

                    <cfcase value="zipCode">
                        hl.zipCode #ARGUMENTS.sortOrder#,
                        hl.lastName
                    </cfcase>
    
                    <cfcase value="phone">
                        hl.phone #ARGUMENTS.sortOrder#,
                        hl.lastName
                    </cfcase>

                    <cfcase value="email">
                        hl.email #ARGUMENTS.sortOrder#,
                        hl.lastName
                    </cfcase>
    
                    <cfcase value="dateCreated">
                        hl.dateCreated #ARGUMENTS.sortOrder#,
                        hl.lastName
                    </cfcase>

                    <cfcase value="dateLastLoggedIn">
                        hl.dateLastLoggedIn #ARGUMENTS.sortOrder#,
                        hl.lastName
                    </cfcase>
    
                    <cfcase value="statusAssigned">
						statusAssigned,
                        hl.lastName
                    </cfcase>

                    <cfcase value="regionAssigned">
						regionAssigned,
                        hl.lastName
                    </cfcase>

                    <cfcase value="areaRepAssigned">
						areaRepAssigned,
                        hl.lastName
                    </cfcase>
    
                    <cfdefaultcase>
                        hl.dateCreated DESC,
                        hl.lastName
                    </cfdefaultcase>
    
                </cfswitch>   
            
		</cfquery>

        <cfscript>
			// Set return structure that will store query + pagination information
			stResult = StructNew();
			
			// Populate structure with pagination information
			stResult.pageNumber = ARGUMENTS.pageNumber;
			stResult.numberOfRecordsOnPage = ARGUMENTS.numberOfRecordsOnPage;
			stResult.numberOfPages = Ceiling( qGetHostLeadsRemote.recordCount / stResult.numberOfRecordsOnPage );
			stResult.numberOfRecords = qGetHostLeadsRemote.recordCount;
			stResult.sortBy = ARGUMENTS.sortBy;
			stResult.sortOrder = ARGUMENTS.sortOrder;
			
			// Here using url.pagenumber to work out what records to display on current page
			stResult.recordFrom = ( (ARGUMENTS.pageNumber * stResult.numberOfRecordsOnPage) - stResult.numberOfRecordsOnPage) + 1;
			stResult.recordTo = ( ARGUMENTS.pageNumber * stResult.numberOfRecordsOnPage );
			
			/* 
				if on last page display the actual number of records in record set as the last to 'figure'. Otherwise it gives 
				a false reading and gives the pagenumber * numberOfRecordsOnPage which is always a multiple of 10
			*/
			if ( stResult.recordTo EQ (stResult.numberOfPages * 10) ) {
				stResult.recordTo = qGetHostLeadsRemote.recordCount;
			}

			// Populate structure with query
			resultQuery = QueryNew("ID, hashID, firstName, lastName, city, state, zipCode, phone, email, dateCreated, dateLastLoggedIn, statusAssigned, regionAssigned, areaRepAssigned");
			
			if ( qGetHostLeadsRemote.recordCount < stResult.recordTo ) {
				stResult.recordTo = qGetHostLeadsRemote.recordCount;
			}
			
			// Populate query below
			if ( qGetHostLeadsRemote.recordCount ) {
				
				For ( i=stResult.recordFrom; i LTE stResult.recordTo; i++ ) {
					QueryAddRow(resultQuery);
					QuerySetCell(resultQuery, "ID", qGetHostLeadsRemote.ID[i]);
					QuerySetCell(resultQuery, "HASHID", qGetHostLeadsRemote.hashID[i]);
					QuerySetCell(resultQuery, "firstName", qGetHostLeadsRemote.firstName[i]);
					QuerySetCell(resultQuery, "lastName", qGetHostLeadsRemote.lastName[i]);
					QuerySetCell(resultQuery, "city", qGetHostLeadsRemote.city[i]);
					QuerySetCell(resultQuery, "state", qGetHostLeadsRemote.state[i]);
					QuerySetCell(resultQuery, "zipCode", qGetHostLeadsRemote.zipCode[i]);
					QuerySetCell(resultQuery, "phone", qGetHostLeadsRemote.phone[i]);
					QuerySetCell(resultQuery, "email", qGetHostLeadsRemote.email[i]);
					QuerySetCell(resultQuery, "dateCreated", qGetHostLeadsRemote.dateCreated[i]);
					QuerySetCell(resultQuery, "dateLastLoggedIn", qGetHostLeadsRemote.dateLastLoggedIn[i]);
					QuerySetCell(resultQuery, "statusAssigned", qGetHostLeadsRemote.statusAssigned[i]);
					QuerySetCell(resultQuery, "regionAssigned", qGetHostLeadsRemote.regionAssigned[i]);
					QuerySetCell(resultQuery, "areaRepAssigned", qGetHostLeadsRemote.areaRepAssigned[i]);
				}
			
			}
			
			// Add query to structure
			stResult.query = resultQuery;
			
			// return structure
			return stResult;			
		</cfscript>
        
	</cffunction>
    

	<cffunction name="deleteHostLeadRemote" access="remote" returntype="void" output="false" hint="Deletes a host lead">
        <cfargument name="ID" type="numeric" hint="ID is not required">
		
        <cfquery 
			datasource="#APPLICATION.DSN#">
                UPDATE
                	smg_host_lead
				SET
                	isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
				WHERE
                	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.ID#">                                         
		</cfquery>
        
	</cffunction>            
    
    <!--- 
		End of Remote Functions 
	--->
    
    
    <!--- 
		Host Lead Reports 
	--->
	<cffunction name="getHostLeadFollowUpReport" access="public" returntype="query" output="false" hint="Gets host leads report">
        <cfargument name="followUpID" type="numeric" default="0" hint="followUpID is not required">
        <cfargument name="regionID" type="string" default="0" hint="regionID is not required">
        <cfargument name="statusID" type="string" default="" hint="statusID is not required">
        <cfargument name="dateFrom" type="string" default="" hint="dateFrom is not required">
        <cfargument name="dateTo" type="string" default="" hint="dateTo is not required">
        <cfargument name="isAdWords" type="any" default="" hint="isAdWords is not required">
        
        <cfquery 
			name="qGetHostLeadFollowUpReport" 
			datasource="#APPLICATION.DSN#">
                SELECT
					hl.ID,
                    hl.hashID,
                    hl.statusID,
                    hl.followUpID,
                    hl.regionID,
                    hl.areaRepID,
                    hl.firstName,
                    hl.lastName,
                    hl.address,
                    hl.address2,
                    hl.city,
                    hl.zipCode,
                    hl.phone,
                    hl.email,
                    hl.hearAboutUs,
                    hl.hearAboutUsDetail,
                    hl.isListSubscriber,
                    hl.isAdWords,
                    DATE_FORMAT(hl.dateCreated, '%m/%e/%Y') as dateCreated,
                    DATE_FORMAT(hl.dateLastLoggedIn, '%m/%e/%Y') as dateLastLoggedIn,
                    <!--- Follow Up Representative --->
                    CONCAT(fu.firstName, ' ', fu.lastName) AS followUpAssigned,
                    <!--- State --->
                    st.state,
                    <!--- Region --->
                    r.regionName AS regionAssigned,
                    <!--- Area Representative --->
                    CONCAT(u.firstName, ' ', u.lastName) AS areaRepAssigned,
                    <!--- Status --->
                    alk.name AS statusAssigned
                FROM 
                    smg_host_lead hl
                LEFT OUTER JOIN
                	smg_users fu ON fu.userID = hl.followUpID    
                LEFT OUTER JOIN
                	smg_states st ON st.id = hl.stateID
                LEFT OUTER JOIN
                	smg_regions r ON r.regionID = hl.regionID
                LEFT OUTER JOIN
                	smg_users u ON u.userID = hl.areaRepID    
                LEFT OUTER JOIN
                	applicationLookUp alk ON alk.fieldID = hl.statusID 
                    	AND 
                            alk.fieldKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="hostLeadStatus">
                WHERE
                	hl.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">

                <cfif isDate(ARGUMENTS.dateFrom) AND isDate(ARGUMENTS.dateTo)>
                	AND 
                    (
                        hl.dateCreated 
                        BETWEEN 
                        	<cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.dateFrom#"> 
	                    AND 
    	                    <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d', 1, ARGUMENTS.dateTo)#">
                    )                 	
                <cfelse>
                	<!--- Get Only Leads Entered as of 04/01/2011 --->
                    AND
                        (
                            hl.dateCreated >= <cfqueryparam cfsqltype="cf_sql_date" value="2011/04/01">
                        OR
                            hl.dateLastLoggedIn IS NOT NULL	
                        )
                </cfif>
                
                <cfif LEN(ARGUMENTS.isAdWords)>
                	AND
                    	hl.isAdWords = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.isAdWords#">
                </cfif>

				<cfif CLIENT.companyID NEQ 5>
                    AND
                        r.company = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
                </cfif>

				<cfif VAL(ARGUMENTS.followUpID)>
                    AND
                        hl.followUpID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.followUpID#">
                </cfif>
				
				<cfif VAL(ARGUMENTS.regionID)>
                    AND
                        hl.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.regionID#">
                </cfif>

                <cfif VAL(ARGUMENTS.statusID)>
                    AND
                        hl.statusID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.statusID#">
				</cfif>
                
                ORDER BY
                    hl.dateCreated DESC,
                    hl.lastName
		</cfquery>
		   
		<cfreturn qGetHostLeadFollowUpReport>
	</cffunction>
    
    
    <cffunction name="getHostLeadsList" access="public" returntype="query" output="false" hint="Gets host leads report">
        <cfargument name="dateFrom" type="string" default="" hint="dateFrom is not required">
        <cfargument name="dateTo" type="string" default="" hint="dateTo is not required">
        <cfargument name="isAdWords" type="any" default="" hint="isAdWords is not required">
        
        <cfquery 
			name="qGetHostLeadFollowUpReport" 
			datasource="#APPLICATION.DSN#">
                SELECT
					hl.ID,
                    hl.hashID,
                    hl.statusID,
                    hl.followUpID,
                    hl.regionID,
                    hl.areaRepID,
                    hl.firstName,
                    hl.lastName,
                    hl.address,
                    hl.address2,
                    hl.city,
                    hl.zipCode,
                    hl.phone,
                    hl.email,
                    hl.hearAboutUs,
                    hl.hearAboutUsDetail,
                    hl.isListSubscriber,
                    hl.isAdWords,
                    DATE_FORMAT(hl.dateCreated, '%m/%e/%Y') as dateCreated,
                    DATE_FORMAT(hl.dateLastLoggedIn, '%m/%e/%Y') as dateLastLoggedIn,
                    st.state,
                    r.regionName AS regionAssigned,
                    CONCAT(u.firstName, ' ', u.lastName) AS areaRepAssigned,
                    alk.name AS statusAssigned
                FROM 
                    smg_host_lead hl    
                LEFT OUTER JOIN
                	smg_states st ON st.id = hl.stateID
                LEFT OUTER JOIN
                	smg_regions r ON r.regionID = hl.regionID
                LEFT OUTER JOIN
                	smg_users u ON u.userID = hl.areaRepID    
                LEFT OUTER JOIN
                	applicationLookUp alk ON alk.fieldID = hl.statusID 
                    	AND 
                            alk.fieldKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="hostLeadStatus">
                WHERE
                	hl.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">

                <cfif isDate(ARGUMENTS.dateFrom)>
                	AND 
                        hl.dateCreated >= <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.dateFrom#">
                </cfif>
                
                <cfif isDate(ARGUMENTS.dateTo)>
                	AND
                    	hl.dateCreated <= <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d',1,ARGUMENTS.dateTo)#">
                </cfif>
                
                <cfif LEN(ARGUMENTS.isAdWords)>
                	AND
                    	hl.isAdWords = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.isAdWords#">
                </cfif>

				<cfif CLIENT.companyID NEQ 5>
                    AND
                        r.company = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
                </cfif>
                
                ORDER BY
                    hl.dateCreated DESC,
                    hl.lastName
		</cfquery>
        
        <cfreturn qGetHostLeadFollowUpReport>
	</cffunction>   

	<!--- ------------------------------------------------------------------------- ----
		END OF HOST LEADS
	----- ------------------------------------------------------------------------- --->
    
</cfcomponent>