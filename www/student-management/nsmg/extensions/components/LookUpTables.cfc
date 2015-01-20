<!--- ------------------------------------------------------------------------- ----
	
	File:		LookUpTables.cfc
	Author:		Marcus Melo
	Date:		April 15, 2010
	Desc:		This holds the functions used to get data from lookup tables

----- ------------------------------------------------------------------------- --->

<cfcomponent 
	displayname="LookUpTables"
	output="false" 
	hint="A collection of functions for lookup tables">


	<!--- Return the initialized Company object --->
	<cffunction name="Init" access="public" returntype="LookUpTables" output="false" hint="Returns the initialized LookUpTables object">
		
		<cfscript>
			// There is nothing really to initiate, so just return this
			return(this);
		</cfscript>
        
	</cffunction>


	<cffunction name="getApplicationLookUp" access="public" returntype="query" output="false" hint="Returns a list from ApplicationLookUp Table. This table was created to store values used throughout the system">
    	<cfargument name="fieldKey" hint="fieldKey is required. This is what defines a group of data">
        <cfargument name="fieldID" default="" hint="fieldID is not required">
    	<cfargument name="isActive" default="1" hint="isActive is not required">
        <cfargument name="sortBy" type="string" default="fieldID" hint="sortBy is not required">
        <cfargument name="includeFieldIDList" default="" hint="includeFieldIDList is not required, display inactive data">

        <cfquery 
        	name="qGetApplicationLookUp"
        	datasource="#APPLICATION.DSN#">
                SELECT 
                	ID,
                    fieldKey,
                    fieldID,
                    name,
                    sortOrder,
                    isActive,
                    dateCreated,
                    dateUpdated
				FROM
                	applicationlookup
				WHERE
                    fieldKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.fieldKey#">
                
                <!--- If fieldID is passed, return it, if not return a list of active fields --->
				<cfif LEN(ARGUMENTS.fieldID)>
	                AND 
                        fieldID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.fieldID)#">
                <cfelseif LEN(ARGUMENTS.isActive)>
                    AND 
                        isActive = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(ARGUMENTS.isActive)#">
				</cfif>                        
				
                <!--- Include current selected to the list if current selected is inactive --->
                <cfif LEN(ARGUMENTS.includeFieldIDList)>
                	OR
                    (
                        fieldKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.fieldKey#">
	                AND 
                        fieldID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.includeFieldIDList)#" list="yes"> )
                    )
                </cfif>
                
                ORDER BY
                
                <cfswitch expression="#ARGUMENTS.sortBy#">
                    
                    <cfcase value="fieldID">                    
                        fieldID
                    </cfcase>
                
                    <cfcase value="name">
                        name
                    </cfcase>

                    <cfcase value="sortOrder">
                        sortOrder
                    </cfcase>

                    <cfdefaultcase>
                        fieldKey
                    </cfdefaultcase>
    
                </cfswitch>  
                
        </cfquery> 

		<cfreturn qGetApplicationLookUp>
	</cffunction>


	<cffunction name="getApplicationHistory" access="public" returntype="query" output="false" hint="Returns history">
    	<cfargument name="applicationID" hint="applicationID is required">
    	<cfargument name="foreignTable" hint="foreignTable is required. This is what defines a group of data">
        <cfargument name="foreignID" hint="foreignID is required">
        <cfargument name="enteredByID" default="" hint="enteredByID is not required">
        <cfargument name="isResolved" default="" hint="isResolved is not required">
        <cfargument name="sortBy" type="string" default="dateCreated" hint="sortBy is not required">
        <cfargument name="sortOrder" type="string" default="DESC" hint="sortOrder is not required">

        <cfscript>
			if ( NOT ListFind("ASC,DESC", ARGUMENTS.sortOrder ) ) {
				ARGUMENTS.sortOrder = 'DESC';			  
			}
		</cfscript>
        
        <cfquery 
        	name="qGetApplicationHistory"
        	datasource="#APPLICATION.DSN#">
                SELECT 
                	ah.ID,
                    ah.applicationID,
                    ah.foreignTable,
                    ah.foreignID,
                    ah.enteredByID,
                    ah.actions,
                    ah.comments,
                    ah.isResolved,
                    ah.dateCreated,
                    ah.dateUpdated,
                    <!--- Entered By --->
                    CAST(CONCAT(u.firstName, ' ', u.lastName,  ' ##', u.userID) AS CHAR) AS enteredBy
				FROM
                	applicationhistory ah 
                LEFT OUTER JOIN
                	smg_users u ON u.userID = ah.enteredByID    
                WHERE
                    ah.applicationID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.applicationID)#">
                AND 
				    ah.foreignTable = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.foreignTable#">
                AND 
                    ah.foreignID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.foreignID)#">
                
                <cfif VAL(ARGUMENTS.enteredByID)>
                    AND 
                        ah.enteredByID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.enteredByID)#">
                </cfif>
                
                <cfif LEN(ARGUMENTS.isResolved)>
                    AND 
                        ah.isResolved = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(ARGUMENTS.isResolved)#">
                </cfif>
                
                ORDER BY
					
                <cfswitch expression="#ARGUMENTS.sortBy#">
    
                    <cfcase value="dateCreated">
                        ah.dateCreated #ARGUMENTS.sortOrder#
                    </cfcase>
    
                    <cfdefaultcase>
                        ah.dateCreated DESC
                    </cfdefaultcase>
    
                </cfswitch>   
                    
        </cfquery> 

		<cfreturn qGetApplicationHistory>
	</cffunction>


	<cffunction name="insertApplicationHistory" access="public" returntype="void" output="false" hint="Inserts a History">
    	<cfargument name="applicationID" hint="applicationID is required">
    	<cfargument name="foreignTable" hint="foreignTable is required. This is what defines a group of data">
        <cfargument name="foreignID" hint="foreignID is required">
        <cfargument name="enteredByID" default="0" hint="enteredByID is not required">
        <cfargument name="actions" default="n/a" hint="actions is not required">
        <cfargument name="formatActionsText" default="0" hint="Set to 1 to replace CHR(13) with <br /> CHR(13)">
        <cfargument name="comments" default="n/a" hint="comments is not required">
        <cfargument name="isResolved" default="0" hint="isResolved is not required">
        <cfargument name="dateCreated" default="#now()#" hint="dateCreated is not required">
        <cfargument name="dateUpdated" default="#now()#" hint="dateCreated is not required">
		
        <cfscript>
			if ( VAL(ARGUMENTS.formatActionsText) ) {
				// Format Text
				vActionsText =  ReplaceNoCase(ARGUMENTS.actions, CHR(13), "<br /> #CHR(13)#", "All");
			} else {
				// Do not Format text
				vActionsText = ARGUMENTS.actions;
			}
		</cfscript>
        
        <cfquery 
        	datasource="#APPLICATION.DSN#">
                INSERT
                    applicationhistory
                 (
                    applicationID,
                    foreignTable,
                    foreignID,
                    enteredByID,
                    actions,
                    comments,
                    isResolved,
                    dateCreated,
                    dateUpdated
                 )           
                VALUES
                (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.applicationID#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.foreignTable#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.foreignID)#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.enteredByID)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#vActionsText#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.comments#">,
                    <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(ARGUMENTS.isResolved)#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ARGUMENTS.dateCreated#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ARGUMENTS.dateUpdated#">
                )        
        </cfquery> 

	</cffunction>


	<cffunction name="updateApplicationHistory" access="public" returntype="void" output="false" hint="Updates isResolved value on applicationhistory">
    	<cfargument name="ID" hint="ID is required">
    	<cfargument name="isResolved" default="" hint="isResolved is not required">

        <cfquery 
        	datasource="#APPLICATION.DSN#">
                UPDATE
                    applicationhistory
                SET
                	isResolved = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(ARGUMENTS.isResolved)#">
                WHERE
                	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.ID)#">
        </cfquery> 

	</cffunction>


	<cffunction name="getPaymentType" access="public" returntype="query" output="false" hint="Gets Area Representative Payment Type">
    	<cfargument name="ID" default="" hint="ID is not required">
        <cfargument name="IDList" default="" hint="ID is not required">
        <cfargument name="active" default="1" hint="active is not required">
        <cfargument name="paymentType" default="" hint="paymentType is not required">

        <cfquery 
        	name="qGetPaymentType"
        	datasource="#APPLICATION.DSN#">
                SELECT 
                	ID,
                    type,
                    companyID,
                    active,
                    description,
                    paymentType
				FROM
                	smg_users_payments_type
				WHERE
                	active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                
				<cfif LEN(ARGUMENTS.ID)>
	                AND 
                        ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.ID)#">
                </cfif> 

				<cfif LEN(ARGUMENTS.IDList)>
	                AND 
                        ID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.IDList#" list="yes"> )
                </cfif> 
                            
				<cfif LEN(ARGUMENTS.paymentType)>
	                AND 
                        paymentType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.paymentType#">
                </cfif> 
			
            	ORDER BY
                	type
        </cfquery> 

		<cfreturn qGetPaymentType>
	</cffunction>


	<cffunction name="getUserType" access="public" returntype="query" output="false" hint="Returns a usertype list">
    	<cfargument name="active" default="1" hint="active is not required">
        <cfargument name="userTypeList" default="" hint="userTypeList is not required">

        <cfquery 
        	name="qGetUserType"
        	datasource="#APPLICATION.DSN#">
                SELECT 
                	userTypeID,
                    userType,
                    shortUserType,
                    php_userType,
                    typeDescription
                    subOfType,
                    active,
                    formType
				FROM
                	smg_usertype
                WHERE 
                    active = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.active#">
                <cfif LEN(ARGUMENTS.userTypeList)>
                	AND
                    	userTypeID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userTypeList#" list="yes"> )
                </cfif>
        </cfquery> 

		<cfreturn qGetUserType>
	</cffunction>


	<cffunction name="getSeason" access="public" returntype="query" output="false" hint="Returns a list of seasons or a specific season">
    	<cfargument name="seasonID" default="" hint="seasonID is not required">
        <cfargument name="isActive" default="1" hint="isActive is not required">

        <cfquery 
        	name="qGetSeason"
        	datasource="#APPLICATION.DSN#">
                SELECT 
                	seasonID,
                    season,
                    years,                    
                    active,
                    startDate,
                    endDate,
                    datePaperworkStarted,
                    datePaperworkRequired,
                    datePaperworkEnded
                FROM 
                	smg_seasons
				WHERE 
                	active = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(ARGUMENTS.isActive)#">
				<cfif LEN(ARGUMENTS.seasonID)>
                  	AND  
                        seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.seasonID)#">
                </cfif>                        
        </cfquery> 

		<cfreturn qGetSeason>
	</cffunction>


	<!--- Get Current Season Based on Today's date --->
	<cffunction name="getCurrentSeason" access="public" returntype="query" output="false" hint=" Get Current Season Based on Today's date ">
	
		<cfquery 
			name="qGetCurrentSeason" 
			datasource="#APPLICATION.dsn#">
				SELECT
                	seasonID,
                    season,
                    years,                    
                    active,
                    startDate,
                    endDate,
                    DATE_ADD(endDate, INTERVAL 31 DAY) AS newEndDate,
                    datePaperworkStarted,
                    datePaperworkEnded
				FROM
                	smg_seasons
                WHERE
					CURRENT_DATE() BETWEEN startDate AND DATE_ADD(endDate, INTERVAL 31 DAY)  
    	</cfquery>
        
        <cfreturn qGetCurrentSeason>        
    </cffunction>
    

	<!--- Get Current Paperwork Season Based on Today's date --->
	<cffunction name="getCurrentPaperworkSeason" access="public" returntype="query" output="false" hint="Get Current Paperwork Season Based on Today's date">
	
		<cfquery 
			name="qGetCurrentPaperworkSeason" 
			datasource="#APPLICATION.dsn#">
				SELECT
                	seasonID,
                    season,
                    years,                    
                    active,
                    startDate,
                    endDate,
                    datePaperworkStarted,
                    datePaperworkRequired,
                    datePaperworkEnded
				FROM
                	smg_seasons
                WHERE
					CURRENT_DATE() BETWEEN datePaperworkStarted AND datePaperworkEnded  
    	</cfquery>
        
        <cfreturn qGetCurrentPaperworkSeason>        
    </cffunction>
    

	<cffunction name="getCountry" access="public" returntype="query" output="false" hint="Returns a list of countries or a specific country">
    	<cfargument name="countryID" default="" hint="countryID is not required">

        <cfquery 
        	name="qGetCountry"
        	datasource="#APPLICATION.DSN#">
                SELECT 
                	countryID,
                    countryName,
                    countryCode,
                    sevisCode,
                    continent,
                    funFact
				FROM
                	smg_countrylist
				<cfif LEN(ARGUMENTS.countryID)>
	                WHERE 
                        countryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.countryID)#">
                </cfif>     
				ORDER BY
                	countryName                    
        </cfquery> 

		<cfreturn qGetCountry>
	</cffunction>


	<cffunction name="getCountryList" access="public" returntype="query" output="false" hint="Returns a list of countries assigned to active students">

        <cfquery 
        	name="qGetCountryList"
        	datasource="#APPLICATION.DSN#">
                SELECT DISTINCT
                	cl.countryID,
                    cl.countryName,
                    cl.countryCode,
                    cl.sevisCode,
                    cl.continent,
                    cl.funFact
				FROM
                	smg_countrylist cl
                INNER JOIN
                	smg_students s ON 
                    ( 
                    	s.countryBirth = cl.countryID
					OR
                    	s.countryResident = cl.countryID
                    OR
                    	s.countryCitizen = cl.countryID
                    ) 
                    AND
                    	s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">                       		
				GROUP BY
                	cl.countryID
                ORDER BY
                	cl.countryName                    
        </cfquery> 

		<cfreturn qGetCountryList>
	</cffunction>


	<cffunction name="getCountryLanguage" access="public" returntype="query" output="false" hint="Returns a list of languages for a country">
    	<cfargument name="countryID" hint="countryID is required">

        <cfquery 
        	name="qGetCountryLanguage"
        	datasource="#APPLICATION.DSN#">
                SELECT 
                	cljn.ID,
                    cljn.countryID,
                    cljn.languageID,
                    cljn.dateCreated,
                    cljn.dateUpdated,
                    alu.name
				FROM
                	smg_countrylanguagejn cljn
                INNER JOIN
					applicationlookup alu ON alu.fieldID = cljn.languageID
                    	AND
                        	fieldKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="language">
                WHERE 
                    cljn.countryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.countryID)#">
        </cfquery> 

		<cfreturn qGetCountryLanguage>
	</cffunction>


	<cffunction name="getState" access="public" returntype="query" output="false" hint="Returns a list of states or a specific state">
    	<cfargument name="stateID" default="" hint="stateID is not required">
		<cfargument name="country" default="US" hint="country pass in country if states aren't needed">
        
        <cfquery 
        	name="qGetState"
        	datasource="#APPLICATION.DSN#">
                SELECT 
                	ID,
                    state,
                    stateName,
                    guarantee_fee
				FROM
                	smg_states
                WHERE 
               
                	country = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.country#">
              
				<cfif LEN(ARGUMENTS.stateID)>
                AND
                    ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.stateID)#">
                </cfif>  
                                 
        </cfquery> 

		<cfreturn qGetState>
	</cffunction>


	<cffunction name="getInterest" access="public" returntype="query" output="false" hint="Returns a interest or a list of interests">
    	<cfargument name="interestID" default="" hint="interestID or a list of interestIDs - Not required">
        <cfargument name="Limit" default="" hint="Total of interests">

        <cfquery 
        	name="qGetInterest"
        	datasource="#APPLICATION.DSN#">
                SELECT 
                	interestID,
                    interest,
                    student_app
				FROM
                	smg_interests
				<cfif LEN(ARGUMENTS.interestID)>
                    WHERE 
                        interestID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.interestID#" list="yes"> )
                </cfif> 
                
                <cfif LEN(ARGUMENTS.Limit) AND ListFind("1,2,3,4,5,6,7,8,9,10", ARGUMENTS.Limit)>
                	LIMIT
                    	#ARGUMENTS.Limit#
                </cfif>
                                       
        </cfquery> 

		<cfreturn qGetInterest>
	</cffunction>


	<cffunction name="getPrivateSchool" access="public" returntype="query" output="false" hint="Returns a private school or a list of private school options">
    	<cfargument name="privateSchoolID" default="0" hint="privateSchoolID is not required">

        <cfquery 
        	name="qGetPrivateSchool"
        	datasource="#APPLICATION.DSN#">
                SELECT 
                	privateSchoolID,
                    privateSchoolPrice,
                    type
				FROM
                	smg_private_schools
				<cfif IsNumeric(ARGUMENTS.privateSchoolID)>
                    WHERE 
                        privateSchoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.privateSchoolID#">
                </cfif>                        
        </cfquery> 

		<cfreturn qGetPrivateSchool>
	</cffunction>


</cfcomponent>