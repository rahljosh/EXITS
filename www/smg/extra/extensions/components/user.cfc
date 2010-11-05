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


	<!--- Authenticate User --->
	<cffunction name="authenticateUser" access="public" returntype="query" output="false" hint="Check user credentials">
		<cfargument name="username" required="yes" hint="Username is requireds" />
		<cfargument name="password" required="yes" hint="Password is required">
        
		<cfquery 
			name="qAuthenticateUser" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT 
                    u.userID,
                    u.firstName,
                    u.lastName,
                    u.lastLogin,
                    u.userType,
                    u.email,
                    uar.companyID
                FROM 
                    smg_users u 
                INNER JOIN
                    user_access_rights uar ON uar.userID = u.userID
                INNER JOIN
                    smg_companies c ON c.companyID = uar.companyID
                WHERE 
                    u.username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.username)#"> 
                AND 
                    u.password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.password)#">
                AND 
                    u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                AND   
                    c.system_id = <cfqueryparam cfsqltype="cf_sql_integer" value="4">
                ORDER BY 
                    uar.default_region DESC
		</cfquery>
		
		<cfreturn qAuthenticateUser /> 
	</cffunction>


	<!--- Check Email Address --->
	<cffunction name="checkEmail" access="public" returntype="query" output="false" hint="Check if email exists - Forgot password">
		<cfargument name="email" required="yes" hint="Email Address" />
		<cfargument name="userID" default="0" hint="Pass userID if you are updating account">
        
		<cfquery 
			name="qCheckEmail" 
			datasource="#APPLICATION.DSN.Source#">
				SELECT
					userID, 
                    firstName,
                    lastName,                    
                    email,
                    password
				FROM
					smg_users
				WHERE
                    email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.email)#">
				AND
					active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                <cfif VAL(ARGUMENTS.userID)>
                	AND
                    	userID != <cfqueryparam cfsqltype="cf_sql_integer" value="#TRIM(ARGUMENTS.userID)#">
                </cfif> 
		</cfquery>
		
		<cfreturn qCheckEmail /> 
	</cffunction>


	<!--- Login --->
	<cffunction name="doLogin" access="public" returntype="void" hint="Logs in a user / sets client variables">
		<cfargument name="qUser" type="query" default="0">
        <cfargument name="updateDateLastLoggedIn" type="numeric" default="1">
		
        <cfscript>
			// Set up Session Variables
			SESSION.auth = structNew();
			
			// Set Up Client Variables
			CLIENT.isLoggedIn = 1;
			CLIENT.loginType = 'user';
			CLIENT.userID = ARGUMENTS.qUser.userID;
			CLIENT.firstName = ARGUMENTS.qUser.firstName;
			CLIENT.lastname =  ARGUMENTS.qUser.lastname;
			CLIENT.lastLogin = ARGUMENTS.qUser.lastLogin;
			CLIENT.userType =  ARGUMENTS.qUser.userType;
			CLIENT.email = ARGUMENTS.qUser.email;
			CLIENT.companyID = ARGUMENTS.qUser.companyID;
			
			// Record last logged in date
			if ( VAL(ARGUMENTS.updateDateLastLoggedIn) ) {
				updateLoggedInDate(userID=ARGUMENTS.qUser.userID);
			}
		</cfscript>
        
	</cffunction>


	<!--- Last Logged In Date --->
	<cffunction name="updateLoggedInDate" access="public" returntype="void" hint="Update last logged in date" output="no">
		<cfargument name="userID" type="numeric" default="0">
        
		<cfquery 
			datasource="#APPLICATION.DSN.Source#">
            UPDATE 
                smg_users 
            SET 
                lastLogin = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
            WHERE 
                userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">
        </cfquery>
        
	</cffunction>

</cfcomponent>