<!--- ------------------------------------------------------------------------- ----
	
	File:		region.cfc
	Author:		Marcus Melo
	Date:		October, 27 2009
	Desc:		This holds the functions needed for the region

----- ------------------------------------------------------------------------- --->

<cfcomponent 
	displayname="region"
	output="false" 
	hint="A collection of functions for the company">


	<!--- Return the initialized Company object --->
	<cffunction name="Init" access="public" returntype="region" output="false" hint="Returns the initialized region object">
		
		<cfscript>
			// There is nothing really to initiate, so just return this
			return(this);
		</cfscript>
        
	</cffunction>

	
	<cffunction name="getRegions" access="public" returntype="query" output="false" hint="Gets a list of regions, if regionID is passed gets a region by ID">
    	<cfargument name="regionID" default="0" hint="regionID is not required">
        <cfargument name="companyID" default="0" hint="companyID is not required">
              
        <cfquery 
			name="qGetRegions" 
			datasource="#APPLICATION.dsn#">
                SELECT
					regionID,
                    active,
                    regionName,
                    subOfRegion,
                    regionFacilitator,
                    company,
                    masterRegion,
                    regional_guarantee
                FROM 
                    smg_regions
                WHERE
                	1 = 1
				<cfif VAL(ARGUMENTS.regionID)>
                	AND
                    	regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.regionID#">
                </cfif>    
				<cfif VAL(ARGUMENTS.companyID)>
                	AND
                    	company = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyID#">
                </cfif>    
                ORDER BY 
                    regionName
		</cfquery>
		   
		<cfreturn qGetRegions>
	</cffunction>

</cfcomponent>