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
        <cfargument name="includeGuaranteed" default="0" hint="Set to 1 to include region preference">
        <cfargument name="isActive" default="1" hint="isActive is not required.">
              
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
                    r.regional_guarantee,
                    c.team_id,
                    c.companyName
                FROM 
                    smg_regions r
                LEFT OUTER JOIN
                	smg_companies c ON c.companyID = r.company
                WHERE
                	1 = 1
				
                <cfif LEN(ARGUMENTS.isActive)>
					AND	
	                    r.active = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.isActive)#">                
                </cfif>
                
				<cfif VAL(ARGUMENTS.regionID)>
                	AND
                    	r.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.regionID)#">
                </cfif>    
				
				<cfif VAL(ARGUMENTS.companyID)>
                	AND
                    	r.company = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.companyID)#">
                </cfif>    

				<cfif NOT VAL(ARGUMENTS.includeGuaranteed)>
                	AND
                    	r.subOfRegion = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                </cfif>    
                
                ORDER BY 
                    c.team_id,
                    r.regionName
		</cfquery>
		   
		<cfreturn qGetRegions>
	</cffunction>


	<cffunction name="getRegionFacilitatorByRegionID" access="public" returntype="query" output="false" hint="Returns the facilitator information for a region">
    	<cfargument name="regionID" default="0" hint="regionID is not required">        
              
        <cfquery 
			name="qGetRegionFacilitatorByRegionID" 
			datasource="#APPLICATION.dsn#">
                SELECT
                	r.regionID,
                    r.company,
                    r.regionName, 
                    u.userID,
                    u.firstname,
                    u.lastname,
                    u.email
                FROM 
                    smg_regions r
                LEFT JOIN 
                    smg_users u ON r.regionfacilitator = u.userid                    
                WHERE
                    r.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.regionID)#">                
		</cfquery>
		   
		<cfreturn qGetRegionFacilitatorByRegionID>
	</cffunction>


	<cffunction name="getRegionsByList" access="public" returntype="query" output="false" hint="Gets a list of regions by region list">
    	<cfargument name="regionIDList" default="" hint="regionID list is not required">        
        <cfargument name="companyID" default="0" hint="companyID is not required">
        <cfargument name="isActive" default="1" hint="isActive is not required.">

        <cfquery 
			name="qGetRegionsByList" 
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
                    r.active = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.isActive)#">                
                
				<cfif VAL(ARGUMENTS.regionIDList)>
                	AND
                    	r.regionID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.regionIDList#" list="yes"> )
                </cfif>    
                
				<cfif VAL(ARGUMENTS.companyID)>
                	AND
                    	r.company = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyID#">
                </cfif>    
                
                ORDER BY 
                    r.regionName
		</cfquery>
		   
		<cfreturn qGetRegionsByList>
	</cffunction>


	<cffunction name="getUserRegions" access="public" returntype="query" output="false" hint="Gets a list of regions, if regionID is passed gets a region by ID">
        <cfargument name="companyID" type="numeric" hint="companyID is required">
        <cfargument name="userID" type="numeric" hint="userID is required">
        <cfargument name="usertype" type="numeric" hint="usertype is required">
        
        <!--- Office Users --->
        <cfif ListFind("1,2,3,4", ARGUMENTS.userType )>
              
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
                    	r.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                    AND    
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
                    	r.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">                        
                    AND    
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
    
	
    <!--- Start of Remote Functions --->
	<cffunction name="getRegionRemote" access="remote" returntype="query" output="false" hint="Gets a list of Regions">
		<cfargument name="companyID" default="0" hint="Get Regions based on companyID">
               
        <cfquery 
			name="qGetRegionRemote" 
                datasource="#APPLICATION.DSN#">
                SELECT DISTINCT
					r.regionID,
                    r.regionName,
                    CONCAT(r.regionName, ' - ', u.firstName, ' ', u.lastName) AS regionInfo
                FROM 
                    smg_regions r
				LEFT OUTER JOIN                 
                   user_access_rights UAR on UAR.regionID = r.regionID                         
                       AND                                         
                           uar.userType = <cfqueryparam cfsqltype="cf_sql_integer" value="5">
                LEFT OUTER JOIN                     
                    smg_users u ON u.userID = uar.userID                         
                        AND                         
                            u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">        
			    WHERE
                    r.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">  
                AND
                    r.company = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.companyID)#">    
                ORDER BY
                	r.regionName                
		</cfquery>

        <cfscript>
			var qReturnRegions = QueryNew("regionID, regionName, regionInfo");
			
			// Return message to user if not was found
			if ( NOT VAL(qGetRegionRemote.recordCount) ) {
				
				QueryAddRow(qReturnRegions, 1);
				QuerySetCell(qReturnRegions, "regionID", 0);	
				QuerySetCell(qReturnRegions, "regionName", "---- No Regions assigned to this company ----", 1);
				QuerySetCell(qReturnRegions, "regionInfo", "---- No Regions assigned to this company ----", 1);
				
			} else if ( NOT VAL(ARGUMENTS.companyID) ) {
				
				// Return message if companyID is not valid
				qGetRegionRemote = QueryNew("regionID, regionName, regionInfo");
				QueryAddRow(qReturnRegions, 1);
				QuerySetCell(qReturnRegions, "regionID", 0);	
				QuerySetCell(qReturnRegions, "regionName", "---- Select a company first ----", 1);
				QuerySetCell(qReturnRegions, "regionInfo", "---- Select a company first ----", 1);
				
			} else {

				// Add first row "Select a Guarantee"
				QueryAddRow(qReturnRegions, 1);
				QuerySetCell(qReturnRegions, "regionID", 0);	
				QuerySetCell(qReturnRegions, "regionName", "---- Select a Region ----", 1);
				QuerySetCell(qReturnRegions, "regionInfo", "---- Select a Region ----", 1);

				For ( i=1; i LTE qGetRegionRemote.recordCount; i=i+1 ) {
					QueryAddRow(qReturnRegions, 1);
					QuerySetCell(qReturnRegions, "regionID", qGetRegionRemote.regionID[i]);
					QuerySetCell(qReturnRegions, "regionName", qGetRegionRemote.regionName[i]);
					QuerySetCell(qReturnRegions, "regionInfo", qGetRegionRemote.regionInfo[i]);
				}

			}

			return qReturnRegions;
		</cfscript>
        
	</cffunction>
    
    
	<cffunction name="getRegionGuaranteeRemote" access="remote" returntype="query" output="false" hint="Gets a list of Region Guarantees">
		<cfargument name="regionID" default="0" hint="Get Guarantees based on regionID">
               
        <cfquery 
			name="qGetRegionGuaranteeRemote" 
                datasource="#APPLICATION.DSN#">
                SELECT DISTINCT
					regionID,
                    regionName
                FROM 
                    smg_regions  
                WHERE
                    active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                AND
                    subOfRegion = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAl(ARGUMENTS.regionID)#"> 
                ORDER BY
                	regionName       
		</cfquery>

        <cfscript>
			var qReturnGurantee = QueryNew("regionID, regionName");
			
			// Return message to user if not was found
			if ( NOT VAL(qGetRegionGuaranteeRemote.recordCount) ) {
				
				// Return message to user if not was found
				QueryAddRow(qReturnGurantee);
				QuerySetCell(qReturnGurantee, "regionID", 0);	
				QuerySetCell(qReturnGurantee, "regionName", "---- No Guarantees available ----");
				
			} else if ( NOT VAL(ARGUMENTS.regionID) ) {
				
				// Return message if regionID is not valid
				QueryAddRow(qReturnGurantee);
				QuerySetCell(qReturnGurantee, "regionID", 0);	
				QuerySetCell(qReturnGurantee, "regionName", "---- Select a Region first ----");
				
			} else {
				
				// Add first row "Select a Guarantee"
				QueryAddRow(qReturnGurantee);
				QuerySetCell(qReturnGurantee, "regionID", 0);	
				QuerySetCell(qReturnGurantee, "regionName", "---- Select a Preference ----");

				For ( i=1; i LTE qGetRegionGuaranteeRemote.recordCount; i=i+1 ) {
					QueryAddRow(qReturnGurantee);
					QuerySetCell(qReturnGurantee, "regionID", qGetRegionGuaranteeRemote.regionID[i]);
					QuerySetCell(qReturnGurantee, "regionName", qGetRegionGuaranteeRemote.regionName[i]);
				}

			}

			return qReturnGurantee;
		</cfscript>
        
	</cffunction>
    
    
</cfcomponent>