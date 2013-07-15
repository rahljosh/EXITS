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
    	<cfargument name="regionID" default="" hint="regionID is not required">   
        <cfargument name="regionIDList" default="" hint="List of region IDs">     
        <cfargument name="companyID" default="" hint="companyID is not required">
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
                    c.companyName,
                    c.companyShort,
                    CAST( CONCAT(u.firstName, ' ', u.lastName, ' (##', u.userID, ')' ) AS CHAR) AS facilitatorName
                FROM 
                    smg_regions r
                LEFT OUTER JOIN
                	smg_companies c ON c.companyID = r.company
                LEFT OUTER JOIN
                	smg_users u ON u.userID = r.regionFacilitator
                WHERE
                	1 = 1
				
                <cfif LEN(ARGUMENTS.isActive)>
					AND	
	                    r.active = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.isActive)#">                
                </cfif>
                
				<cfif LEN(ARGUMENTS.regionID)>
                	AND
                    	r.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.regionID)#">
                </cfif>
                
                <cfif LEN(ARGUMENTS.regionIDList)>
                	AND
                    	r.regionID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.regionIDList#" list="yes"> )
                </cfif>
				
				<cfif LEN(ARGUMENTS.companyID)>
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
    
    <cffunction name="getRegionManagerByRegionID" access="public" returntype="query" output="false" hint="Returns the manager information for a region">
		<cfargument name="regionID" type="numeric" required="yes" hint="regionID is required">
        
        <cfquery name="qGetRegionManagerByRegion" datasource="#APPLICATION.DSN#">
        	SELECT smg_users.*
         	FROM smg_users
            INNER JOIN user_access_rights ON user_access_rights.userID = smg_users.userID
            	AND user_access_rights.userType = 5
                AND user_access_rights.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.regionID)#">
          	WHERE smg_users.active = 1
        </cfquery>
        
        <cfreturn qGetRegionManagerByRegion>
    
    </cffunction>


	<cffunction name="getRegionsByList" access="public" returntype="query" output="false" hint="Gets a list of regions by a list of region IDs">
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
        <cfif ListFind("1,2,3,4", ARGUMENTS.userType)>
              
            <cfquery 
                name="qGetUserRegions" 
                datasource="#APPLICATION.dsn#">
                    SELECT 
                    	r.regionID, 
                        4 AS userType,                        
                        r.regionname, 
                        c.companyshort,
                        'Office' AS userAccessLevel
                    FROM 
                    	smg_regions r
                    INNER JOIN 
                    	smg_companies c ON r.company = c.companyID
                    WHERE 
                    	r.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                    AND    
                        r.subofregion = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                    <cfif ARGUMENTS.companyID EQ 5>
                        AND 
                        	c.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISE#" list="yes"> )
                    <cfelse>
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
                        r.regionname,
                        c.companyshort,
                        u.usertype AS userAccessLevel                        
                    FROM 
                    	user_access_rights uar
                    INNER JOIN 
                    	smg_regions r ON r.regionID = uar.regionID
                    INNER JOIN 
                    	smg_companies c ON r.company = c.companyID
                    INNER JOIN 
                        smg_usertype u ON  u.userTypeID = uar.userType
                    WHERE 
                    	r.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">                        
                    AND    
                        uar.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#"> 
                    AND 
                    	uar.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyID#">
                    AND 
                        uar.usertype IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="5,6,7" list="yes"> )
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
                   		AND
                    		uar.userID IN (SELECT userID FROM smg_users WHERE active = 1)
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