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
    
    <cffunction name="getRepTraining" access="public" returntype="query" output="no" hint="gets the training records for the given user">
    	<cfargument name="userID" type="numeric" required="yes" hint="userID is required">
        <cfargument name="programID" type="numeric" required="no" hint="programID is not required">
        
        <cfquery name="qGetTraining" datasource="#APPLICATION.DSN#">
   			SELECT t.*
            FROM php_rep_season t
            WHERE userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userID)#">
            <cfif ARGUMENTS.programID>
            	AND programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.programID)#">
           	</cfif>
        </cfquery>
        
        <cfreturn qGetTraining>
        
    </cffunction>

	<!--- ------------------------------------------------------------------------- ----
		
		CBC FUNCTIONS
	
	----- ------------------------------------------------------------------------- --->
    
    <cffunction name="getCBC" access="public" returntype="query" output="no" hint="Gets the cbc records associated with the given user">
    	<cfargument name="userID" type="numeric" hint="userID is required">
        <cfargument name="isNotExpired" type="boolean" default="false" hint="isNotExpired is not required (if set to true it will only return records that have not yet expired AND are approved)">
        
        <cfquery name="qGetCBC" datasource="#APPLICATION.DSN#">
            SELECT
            	u.userID,
                u.firstName,
                u.lastName,
                u.SSN,
                u.DOB,
                cbc.*
            FROM smg_users u
            INNER JOIN php_users_cbc cbc ON cbc.userID = u.userID
            WHERE u.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userID)#">
            <cfif ARGUMENTS.isNotExpired>
                AND cbc.date_expiration > NOW()
                AND cbc.date_approved IS NOT NULL
            </cfif>
            ORDER BY date_submitted DESC
        </cfquery>
        <cfreturn qGetCBC>
    </cffunction>
    
    <cffunction name="setCBC" access="public" returntype="void" output="no" hint="inserts or updates a user cbc record">
    	<cfargument name="date_submitted" type="string" hint="date_submitted is required">
        <cfargument name="userID" type="numeric" default="0" hint="userID is not required (but it is neccessary when adding)">
        <cfargument name="date_authorization" type="string" default="" hint="date_authorization is not required">
        <cfargument name="date_approved" type="string" default="" hint="date_approved is not required">
        <cfargument name="notes" type="string" default="" hint="notes is not required">
        <cfargument name="id" type="numeric" default="0" hint="id is not required (if this equals 0 it will insert, otherwise it will attempt to update that record)">
        
        <cfif VAL(ARGUMENTS.id)>
       		<cfquery datasource="#APPLICATION.DSN#">
            	UPDATE 
                	php_users_cbc
                SET
                    notes = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#ARGUMENTS.notes#">,
                    date_authorization = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.date_authorization#" null="#NOT IsDate(ARGUMENTS.date_authorization)#">,
                    date_submitted = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.date_submitted#" null="#NOT IsDate(ARGUMENTS.date_submitted)#">,
                    date_expiration = <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('yyyy',+1,ARGUMENTS.date_submitted)#">,
                    date_approved = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.date_approved#" null="#NOT IsDate(ARGUMENTS.date_approved)#">
              	WHERE
                	Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.id)#">
            </cfquery>
        <cfelse>
        	<cfquery datasource="#APPLICATION.DSN#">
            	INSERT INTO php_users_cbc (
                	userID,
                    notes,
                    date_authorization,
                    date_submitted,
                    date_expiration,
                    date_approved )
               	VALUES (
                	<cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userID)#">,
                    <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#ARGUMENTS.notes#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.date_authorization#" null="#NOT IsDate(ARGUMENTS.date_authorization)#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.date_submitted#" null="#NOT IsDate(ARGUMENTS.date_submitted)#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('yyyy',+1,ARGUMENTS.date_submitted)#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.date_approved#" null="#NOT IsDate(ARGUMENTS.date_approved)#"> )
            </cfquery>
        </cfif>
    </cffunction>
    
    <!--- ------------------------------------------------------------------------- ----
		
		END CBC FUNCTIONS
	
	----- ------------------------------------------------------------------------- --->

</cfcomponent>