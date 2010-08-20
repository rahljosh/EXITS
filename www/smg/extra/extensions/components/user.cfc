<!--- ------------------------------------------------------------------------- ----
	
	File:		user.cfc
	Author:		Marcus Melo
	Date:		August 19, 2010
	Desc:		This holds the functions needed for the user

----- ------------------------------------------------------------------------- --->

<cfcomponent 
	displayname="user"
	output="false" 
	hint="A collection of functions for the company">


	<!--- Return the initialized Company object --->
	<cffunction name="Init" access="public" returntype="user" output="false" hint="Returns the initialized User object">
		
		<cfscript>
			// There is nothing really to initiate, so just return this
			return(this);
		</cfscript>
        
	</cffunction>

	
	<cffunction name="getUsers" access="public" returntype="query" output="false" hint="Gets a list of users, if usertype is passed gets users by usertype">
    	<cfargument name="usertype" default="0" hint="usertype is not required">
        <cfargument name="isActive" default="1" hint="isActive is not required">
        <cfargument name="getAll" default="1" hint="getAll is not required. Set to 0 to get only users that are assigned to candidates">
		       
        <cfquery 
			name="qGetUsers" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT
					*
                FROM 
                    smg_users
                WHERE
                	1 = 1
                    
				<cfif VAL(ARGUMENTS.usertype)>
                	AND	
                    	usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.usertype#">
                </cfif>
                
                <cfif LEN(ARGUMENTS.isActive)>
                	AND
                    	active = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.isActive#">
                </cfif>
                
                <cfif NOT VAL(ARGUMENTS.getAll)>
                	AND
                    	userID IN 	
                        ( 
                            SELECT
                                intRep
                            FROM
                                extra_candidates
                            WHERE
                                companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
                            GROUP BY
                                intRep
                        )                                                
                </cfif>
                
				<cfif VAL(ARGUMENTS.usertype)>
                    ORDER BY 
                        businessName                
                <cfelse>
                    ORDER BY 
                        lastName
                </cfif>
		</cfquery>
		   
		<cfreturn qGetUsers>
	</cffunction>


	<cffunction name="getUserByID" access="public" returntype="query" output="false" hint="Gets a user by ID">
    	<cfargument name="userID" type="numeric" hint="userID is required">
              
        <cfquery 
			name="qGetUserByID" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT
					*
                FROM 
                    smg_users
                WHERE	
                    userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">
		</cfquery>
		   
		<cfreturn qGetUserByID>
	</cffunction>


	<cffunction name="getUserAccessRights" access="public" returntype="query" output="false" hint="Gets user access rights for a user or region">
    	<cfargument name="userID" type="numeric" default="0" hint="userID is required">
        <cfargument name="companyID" type="numeric" default="0" hint="companyID is required">
              
        <cfquery 
			name="qGetUserAccessRights" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT
					uar.id,
                    uar.userID,
                    uar.companyID,
                    uar.regionID,
                    uar.userType,
                    uar.advisorID,
                    uar.default_region,
                    uar.default_access,
                    uar.changeDate
                FROM 
                    user_access_rights uar
                WHERE
                    uar.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyID#">

				<cfif VAL(ARGUMENTS.userID)>
                	AND
                    	uar.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">
                </cfif>                  
                    
				ORDER BY
                	uar.default_access DESC                               
		</cfquery>
		   
		<cfreturn qGetUserAccessRights>
	</cffunction>

</cfcomponent>