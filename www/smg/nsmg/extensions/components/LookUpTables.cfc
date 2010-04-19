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


	<cffunction name="getCountry" access="public" returntype="query" output="false" hint="Returns a country or list of countries">
    	<cfargument name="countryID" default="0" hint="countryID is not required">

        <cfquery 
        	name="qGetCountry"
        	datasource="MySQL">
                SELECT 
                	countryID,
                    countryName,
                    countryCode,
                    sevisCode,
                    continent
				FROM
                	smg_countrylist
                WHERE 
                    1 = 1
                    <cfif VAL(ARGUMENTS.countryID)>
                    AND
                        countryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.countryID#">
					</cfif>                        
        </cfquery> 

		<cfreturn qGetCountry>
	</cffunction>

</cfcomponent>