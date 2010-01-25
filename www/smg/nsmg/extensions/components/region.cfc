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
        <cfargument name="includeGuaranteed" default="0" hint="Set to 1 to include regional guaranteed">
              
        <cfquery 
			name="qGetRegions" 
			datasource="#APPLICATION.dsn#">
                SELECT
					r.regionID,
                    r.active,
                    r.regionName,
                    r.subOfRegion,
                    r.regionFacilitator,
                    r.company,
                    r.masterRegion,
                    r.regional_guarantee
                FROM 
                    smg_regions r
                WHERE
                	1 = 1
				
				<cfif VAL(ARGUMENTS.regionID)>
                	AND
                    	r.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.regionID#">
                </cfif>    
				
				<cfif VAL(ARGUMENTS.companyID)>
                	AND
                    	r.company = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyID#">
                </cfif>    

				<cfif NOT VAL(ARGUMENTS.includeGuaranteed)>
                	AND
                    	r.subOfRegion = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                </cfif>    
                
                ORDER BY 
                    r.regionName
		</cfquery>
		   
		<cfreturn qGetRegions>
	</cffunction>


	<cffunction name="getUserRegions" access="public" returntype="query" output="false" hint="Gets a list of regions, if regionID is passed gets a region by ID">
        <cfargument name="companyID" type="numeric" hint="companyID is required">
        <cfargument name="userID" type="numeric" hint="userID is required">
        <cfargument name="usertype" type="numeric" hint="usertype is required">
        
        <!--- Office Users --->
        <cfif VAL(ARGUMENTS.usertype) LTE 4>
              
            <cfquery 
                name="qGetUserRegions" 
                datasource="#APPLICATION.dsn#">
                    SELECT 
                    	r.regionID, 
                        r.regionname, 
                        c.companyshort
                    FROM 
                    	smg_regions r
                    INNER JOIN 
                    	smg_companies c ON r.company = c.companyID
                    WHERE 
                    	r.subofregion = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                    <cfif VAL(ARGUMENTS.companyID) NEQ 5>
                        AND 
                        	c.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyID#">
                    </cfif>
                    ORDER BY 
                    	companyshort, 
                        regionname
            </cfquery>

		<cfelse>
        
            <cfquery 
                name="qGetUserRegions" 
                datasource="#APPLICATION.dsn#">
                    SELECT 
                    	uar.regionID, 
                        uar.usertype,
                        r.regionname                        
                    FROM 
                    	user_access_rights uar
                    INNER JOIN 
                    	smg_regions r ON r.regionID = uar.regionID
                    WHERE 
                    	uar.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#"> 
                    AND 
                    	uar.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyID#">
                    AND 
                    	(
                        	uar.usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="5"> 
                        OR 
                        	uar.usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="6">
                        OR 
                        	uar.usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="7">
                        )
                    ORDER BY 
                    	default_region DESC, 
                        regionname
            </cfquery>
        
        </cfif>
               
		<cfreturn qGetUserRegions>
	</cffunction>

</cfcomponent>