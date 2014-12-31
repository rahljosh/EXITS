<!--- ------------------------------------------------------------------------- ----
	
	File:		LookUpTables.cfc
	Author:		Marcus Melo
	Date:		August 19, 2010
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


	<cffunction name="getApplicationLookUp" access="public" returntype="query" output="false" hint="Returns a list of look up fields">
    	<cfargument name="fieldKey" required="yes" hint="fieldKey is required.">
    	<cfargument name="orderBy" default="ID" hint="orderBy is required.">

        <cfquery 
        	name="qGetApplicationLookUp"
        	datasource="#APPLICATION.DSN.Source#">
                SELECT 
                	ID,
                    fieldKey,
                    name,
                    isActive
                    dateCreated,
                    dateUpdated
				FROM
                	applicationlookup
				WHERE
                	isActive = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                AND
                    fieldKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.fieldKey#">
				<cfif ListFind('ID,fieldKey,name', ARGUMENTS.orderBy)>
                ORDER BY
                	#ARGUMENTS.orderBy#                    
				</cfif>                    
        </cfquery> 

		<cfreturn qGetApplicationLookUp>
	</cffunction>


	<cffunction name="getCountry" access="public" returntype="query" output="false" hint="Returns a country or list of countries">		
        <cfargument name="countryID" default="" hint="countryID is not required">
        
        <cfquery 
        	name="qGetCountry"
        	datasource="#APPLICATION.DSN.Source#">
                SELECT 
                	countryID,
                    countryName,
                    countryCode,
                    sevisCode,
                    continent
				FROM
                	smg_countryList
                    
				<cfif LEN(ARGUMENTS.countryID)>
                    WHERE 
                        countryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.countryID)#">
                </cfif> 
                                   
        </cfquery> 
		       
		<cfreturn qGetCountry>
	</cffunction>


	<cffunction name="getCountryByID" access="public" returntype="query" output="false" hint="Returns a country or list of countries">
    	<cfargument name="ID" hint="countryID is required">
		
        <cfquery 
        	name="qGetCountryByID"
        	datasource="#APPLICATION.DSN.Source#">
                SELECT 
                	countryID,
                    countryName,
                    countryCode,
                    sevisCode,
                    continent
				FROM
                	smg_countryList
                WHERE 
                    countryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.ID)#">
        </cfquery> 
		       
		<cfreturn qGetCountryByID>
	</cffunction>


	<cffunction name="getState" access="public" returntype="query" output="false" hint="Returns a state or list of states">
    	<cfargument name="ID" default="0" hint="stateID is not required">
        <cfargument name="shortState" default="" hint="shortState is not required">

        <cfquery 
        	name="qGetState"
        	datasource="#APPLICATION.DSN.Source#">
                SELECT 
                	ID,
                    state,
                    stateName,
                    guarantee_fee
				FROM
                	smg_states
				WHERE 
					1 = 1
                    
				<cfif VAL(ARGUMENTS.ID)>
	                AND 
                        ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.ID#">
                </cfif>       
				
				<cfif LEN(ARGUMENTS.shortState)>
	                AND 
                        state LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.shortState#">
                </cfif>                        
                                 
        </cfquery> 
        
		<cfreturn qGetState>
	</cffunction>


	<cffunction name="getFAQ" access="public" returntype="query" output="false" hint="Returns a list of FAQs">
    	<cfargument name="searchKeyword" default="" hint="Search Keyword is not required">

        <cfquery 
        	name="qGetFAQ"
        	datasource="#APPLICATION.DSN.Source#">
                SELECT 
                	ID,
                    applicationID,
                    question,
                    answer,
                    isDeleted,
                    dateCreated,
                    dateUpdated
				FROM
                	applicationFaq
				WHERE
                	applicationID = <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.applicationID#">
                AND	
                    isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
				<cfif LEN(ARGUMENTS.searchKeyword)>
					AND
                    (
                        question LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ARGUMENTS.searchKeyword#%">
                    OR    
                    	answer LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ARGUMENTS.searchKeyword#%">
                    )
                </cfif>  
				ORDER BY
                	question                                   
        </cfquery> 
        
		<cfreturn qGetFAQ>
	</cffunction>

</cfcomponent>