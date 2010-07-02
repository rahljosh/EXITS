<!--- ------------------------------------------------------------------------- ----
	
	File:		LookUpTables.cfc
	Author:		Marcus Melo
	Date:		June 18, 2010
	Desc:		This holds the functions used to get data from lookup tables

----- ------------------------------------------------------------------------- --->

<cfcomponent 
	displayname="LookUpTables"
	output="false" 
	hint="A collection of functions for lookup tables">


	<!--- Return the initialized Company object --->
	<cffunction name="Init" access="public" returntype="LookUpTables" output="false" hint="Returns the initialized LookUpTables object">
		
		<cfscript>
			// Return this initialized instance
			return(this);
		</cfscript>
        
	</cffunction>


	<cffunction name="getCountry" access="public" returntype="query" output="false" hint="Returns a country or list of countries">
    	<cfargument name="ID" default="0" hint="countryID is not required">

        <cfquery 
        	name="qGetCountry"
        	datasource="#APPLICATION.DSN.Source#">
                SELECT 
                	ID,
                    name,
                    code,
                    dateCreated,
                    dateUpdated
				FROM
                	country
				<cfif VAL(ARGUMENTS.ID)>
	                WHERE 
                        ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.ID#">
                </cfif>                        
        </cfquery> 

		<cfreturn qGetCountry>
	</cffunction>


	<cffunction name="getState" access="public" returntype="query" output="false" hint="Returns a state or list of states">
    	<cfargument name="ID" default="0" hint="countryID is not required">

        <cfquery 
        	name="qGetState"
        	datasource="#APPLICATION.DSN.Source#">
                SELECT 
                	ID,
                    name,
                    code,
                    dateCreated,
                    dateUpdated
				FROM
                	state
				<cfif VAL(ARGUMENTS.ID)>
	                WHERE 
                        ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.ID#">
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
                    question,
                    answer,
                    dateCreated,
                    dateUpdated
				FROM
                	faq
				WHERE
                	isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
				<cfif LEN(ARGUMENTS.searchKeyword)>
					AND
                    (
                        question LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ARGUMENTS.searchKeyword#%">
                    OR    
                    	answer LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ARGUMENTS.searchKeyword#%">
                    )
                </cfif>                        
        </cfquery> 

		<cfreturn qGetFAQ>
	</cffunction>


</cfcomponent>