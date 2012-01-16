<!--- ------------------------------------------------------------------------- ----
	
	File:		user.cfc
	Author:		Marcus Melo
	Date:		May 16, 2011
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
    	<cfargument name="userID" default="" hint="userID is not required">
    	<cfargument name="usertype" default="0" hint="usertype is not required">
        <cfargument name="userTypeList" default="" hint="usertype list is not required">
        <cfargument name="isActive" default="1" hint="isActive is not required">
              
        <cfquery 
			name="qGetUsers" 
			datasource="#APPLICATION.dsn#">
                SELECT DISTINCT
					u.*
                FROM 
                    smg_users u
                INNER JOIN
                	user_access_rights uar ON uar.userID = u.userID
                        AND	
                            uar.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
                WHERE
                	1 = 1

				<cfif LEN(ARGUMENTS.userID)>
                	AND	
                    	u.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userID)#">
                </cfif>

                <cfif LEN(ARGUMENTS.isActive)>
                	AND
                    	u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.isActive#">
                </cfif>
                
				<cfif VAL(ARGUMENTS.usertype)>
                    AND	
                        uar.usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.usertype#">
                </cfif>

                <cfif VAL(ARGUMENTS.userTypeList)>
                    AND	
                        uar.usertype IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.usertype#" list="yes"> ) 
                </cfif>
                
                GROUP BY
                	u.userID
                    
				<cfif VAL(ARGUMENTS.usertype)>
                    ORDER BY 
                        u.businessName                
                <cfelse>
                    ORDER BY 
                        u.lastName
                </cfif>
		</cfquery>
		
		<cfreturn qGetUsers>
	</cffunction>


	<cffunction name="getFieldUsers" access="public" returntype="query" output="false" hint="Gets a list of supervised users | Managers - Advisors - Area Reps">
        <cfargument name="usertype" type="numeric" hint="usertype is required">
        <cfargument name="userID" type="numeric" hint="userID is required">
        <cfargument name="includeUserIDs" default="" hint="area reps will be able to see themselves and current assigned users on the list">
                
        <!--- Office Users --->
        <cfif ListFind("1,2,3,4", ARGUMENTS.userType)>
            
            <!--- Get all users for a specific region --->  
            <cfquery 
                name="qGetFieldUsers" 
                datasource="#APPLICATION.dsn#">
                    SELECT DISTINCT
                        u.*
                    FROM 
                    	smg_users u
                    INNER JOIN 
                    	user_access_rights uar ON uar.userid = u.userid
                    WHERE 
                    	u.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                    AND 
                    	uar.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
                    AND 
                        uar.usertype IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="5,6,7" list="yes"> )
					
                    <!--- Include Current Assigned User --->
                    <cfif LEN(ARGUMENTS.includeUserIDs)>
                    	OR
                            u.userID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.includeUserIDs#" list="yes"> )
                    </cfif>
                    
                    ORDER BY 
                    	u.lastname,
                        u.firstName
            </cfquery>

		<cfelse>
        
            <cfquery 
                name="qGetFieldUsers" 
                datasource="#APPLICATION.dsn#">
                    SELECT DISTINCT
                        u.*
                    FROM 
                    	smg_users u
                    INNER JOIN 
                    	user_access_rights uar ON uar.userid = u.userid
                    WHERE 
                    	u.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
					AND 
                    	uar.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
                        
                    <cfswitch expression="#ARGUMENTS.userType#">
                    	
                        <!--- Regional Manager --->
                    	<cfcase value="5">
                        
							<cfif VAL(is2ndVisitIncluded)>
                                AND 
                                    uar.usertype IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="5,6,7,15" list="yes"> )
                            <cfelse>
                                AND 
                                    uar.usertype IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="5,6,7" list="yes"> )
                            </cfif>
                            
                        </cfcase>
                        
                        <!--- Regional Advisor - Returns users under them --->
                    	<cfcase value="6">
                            AND 
                               	uar.advisorID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userID)#">
                        </cfcase>
                        
                    	<!--- Area Representative - Returns themselves --->	
                    	<cfcase value="7">
                        	AND
                                u.userID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#" list="yes"> )
                        </cfcase>
                        
                    </cfswitch>
					
                    <!--- Include Current Assigned User --->
                    <cfif LEN(ARGUMENTS.includeUserIDs)>
                    	OR
                            u.userID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.includeUserIDs#" list="yes"> )
                    </cfif>
                    
                    ORDER BY 
                    	u.lastname,
                        u.firstName
            </cfquery>
        
        </cfif>
               
		<cfreturn qGetFieldUsers>
	</cffunction>


</cfcomponent>