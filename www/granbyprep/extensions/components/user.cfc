<!--- ------------------------------------------------------------------------- ----
	
	File:		user.cfc
	Author:		Marcus Melo
	Date:		November 09, 2010
	Desc:		This holds the functions needed for user

----- ------------------------------------------------------------------------- --->

<cfcomponent 
	displayname="user"
	output="false" 
	hint="A collection of functions for the user module">


	<!--- Return the initialized User object --->
	<cffunction name="Init" access="public" returntype="user" output="No" hint="Returns the initialized User object">

		<cfscript>
			// Return this initialized instance
			return(this);
		</cfscript>

	</cffunction>


	<!--- Get UserID --->
	<cffunction name="getUserID" access="public" returntype="numeric" hint="Get user ID from session. Returns 0 if it's not found." output="no">
        
        <cftry>
	        <cfparam name="SESSION.USER.ID" type="numeric" default="0">
            <cfcatch type="any">
                <cfset SESSION.USER.ID = 0>
            </cfcatch>
        </cftry>

		<cfscript>
			if (VAL(SESSION.USER.ID)) {
				// return userID 
				return SESSION.USER.ID;
			} else {
				// userID not found
				return 0;
			}
		</cfscript>
        
	</cffunction>


	<!--- Set User Session Variables --->
	<cffunction name="setUserSession" access="public" returntype="void" hint="Set user SESSION variables" output="no">
		<cfargument name="ID" type="numeric" default="0">
        <cfargument name="updateDateLastLoggedIn" type="numeric" default="0">
        
        <cfscript>
			if ( VAL(ARGUMENTS.ID) ) {
			
				// Set user ID
				SESSION.USER.ID = ARGUMENTS.ID;
	
				// Get User Information
				qGetUserInfo = getUserByID(ID=ARGUMENTS.ID);
			
				// Set user session variables 
				SESSION.USER.firstName = qGetUserInfo.firstName;
				SESSION.USER.lastName = qGetUserInfo.lastName;
				
				if ( VAL(ARGUMENTS.updateDateLastLoggedIn) ) {				
					SESSION.USER.dateLastLoggedIn = qGetUserInfo.dateLastLoggedIn;
				}

			}
		</cfscript>
        
	</cffunction>

	
    <!--- Get User Session Variables --->
	<cffunction name="getUserSession" access="public" returntype="struct" hint="Get user SESSION variables" output="no">

        <cfscript>
			return SESSION.USER;
		</cfscript>
        
	</cffunction>


	<!--- Check Login --->
	<cffunction name="checkLogin" access="public" returntype="query" output="false" hint="Check user credentials">
		<cfargument name="username" required="yes" hint="Username" />
		<cfargument name="password" required="yes" hint="Password" />		

		<cfquery 
			name="qCheckLogin" 
			datasource="#APPLICATION.DSN.Source#">
				SELECT
					id, 
                    firstName,
                    lastName,                    
                    email,
                    username,
                    password
				FROM
					user
				WHERE
                    username  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.username)#">
                AND 
    	            password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.password)#">
				AND
					isActive = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                AND    
                   	isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0"> 
		</cfquery>
		
		<cfreturn qCheckLogin /> 
	</cffunction>


	<!--- Check Username --->
	<cffunction name="checkEmail" access="public" returntype="query" output="false" hint="Check user credentials">
		<cfargument name="email" required="yes" hint="Email Address" />
		<cfargument name="ID" default="0" hint="Pass userID if you are updating account">
        
		<cfquery 
			name="qCheckEmail" 
			datasource="#APPLICATION.DSN.Source#">
				SELECT
					ID, 
                    firstName,
                    lastName,                    
                    email,
                    username,
                    password
				FROM
					user
				WHERE
                    email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.email)#">
				AND
					isActive = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                AND    
                   	isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                <cfif VAL(ARGUMENTS.ID)>
                	AND
                    	ID != <cfqueryparam cfsqltype="cf_sql_integer" value="#TRIM(ARGUMENTS.ID)#">
                </cfif> 
		</cfquery>
		
		<cfreturn qCheckEmail /> 
	</cffunction>


	<!--- Get Users --->
	<cffunction name="getUsers" access="public" returntype="query" output="false" hint="Gets user list">

		<cfquery 
			name="qGetUsers" 
			datasource="#APPLICATION.DSN.Source#">
				SELECT
					ID, 
                    firstName,
                    middleName,                    
                    lastName,  
                    email,
                    username,
                    password,
                    gender,
                    dob,
                    dateCanceled,
                    DATE_FORMAT(dateLastLoggedIn, '%m/%d/%y') AS dateLastLoggedIn,
                    isActive,
                    isDeleted,
                    CONVERT(CONCAT('<a href="index.cfm?action=userDetail=ID=(''', ID, ''');">[Details]</a>') USING latin1) AS action,
                    DATE_FORMAT(dateCreated, '%m/%d/%y') AS dateCreated,
                    dateupdated                  
				FROM
					user
				WHERE
	                isActive = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
				ORDER BY
                	lastName                    
		</cfquery>
		
		<cfreturn qGetUsers /> 
	</cffunction>
    

	<!--- Get User By ID --->
	<cffunction name="getUserByID" access="public" returntype="query" output="false" hint="Gets user information by ID">
		<cfargument name="ID" required="yes" hint="User ID" />

		<cfquery 
			name="qGetUserByID" 
			datasource="#APPLICATION.DSN.Source#">
				SELECT
					ID, 
                    firstName,
                    middleName,                    
                    lastName,  
                    email,
                    username,
                    password,
                    gender,
                    dob,
                    dateCanceled,
                    dateLastLoggedIn,
                    isActive,
                    isDeleted,
                    dateCreated,
                    dateupdated                  
				FROM
					user
				WHERE
	                ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.ID)#">
		</cfquery>
		
		<cfreturn qGetUserByID /> 
	</cffunction>


	<!--- Insert User --->
	<cffunction name="insertUser" access="public" returntype="numeric" output="false" hint="Inserts a new user. Returns user ID.">
		<cfargument name="firstName" required="yes" hint="First Name" />
        <cfargument name="middleName" required="yes" hint="Middle Name" />		
        <cfargument name="lastName" required="yes" hint="Last Name" />
        <cfargument name="email" required="yes" hint="Email" />
        <cfargument name="username" required="yes" hint="Username" />
        <cfargument name="password" required="yes" hint="Password" />
		<cfargument name="gender" required="yes" hint="Gender" />
		<cfargument name="dob" required="yes" hint="dob" />

		<cfquery 
            result="newRecord"
			datasource="#APPLICATION.DSN.Source#">
				INSERT INTO
					user
				(                    
                    firstName,
                    middleName,
                    lastName,                    
                    email,
                    username,
                    password,
                    gender,
                    dob,                    
                    dateCreated
				)
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.firstName)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.middleName)#">,	
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.lastName)#">,		
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.email)#">,	
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.username)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.password)#">,	
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.gender)#">,	
                    <cfif IsDate(ARGUMENTS.dob)>
	                    dob = <cfqueryparam cfsqltype="cf_sql_date" value="#TRIM(ARGUMENTS.dob)#">,
                    <cfelse>
                    	dob = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    </cfif>
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                )                    
		</cfquery>
		
		<cfreturn newRecord.GENERATED_KEY /> 
	</cffunction>


	<!--- Update User --->
	<cffunction name="updateUser" access="public" returntype="void" output="false" hint="Update User Information">
		<cfargument name="ID" required="yes" hint="User ID" />
		<cfargument name="firstName" default="" hint="User First Name">
        <cfargument name="middleName" default="" hint="User Middle Name">
        <cfargument name="lastName" default="" hint="User Last Name">
        <cfargument name="email" default="" hint="User Gender">
        <cfargument name="gender" default="" hint="User Gender">
        <cfargument name="dob" default="" hint="User Date of Birth">

		<cfquery 
			datasource="#APPLICATION.DSN.Source#">
				UPDATE
                	user
                SET
                    firstName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.firstName)#">,
                    middleName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.middleName)#">,                    
                    lastName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.lastName)#">,  
                    email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.email)#">,  
                    gender = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.gender)#">,
                    <cfif IsDate(ARGUMENTS.dob)>
	                    dob = <cfqueryparam cfsqltype="cf_sql_date" value="#TRIM(ARGUMENTS.dob)#">
                    <cfelse>
                    	dob = <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                    </cfif>
				WHERE
	                ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.ID)#">
		</cfquery>
		
	</cffunction>


	<cffunction name="udpateUsername" access="public" returntype="void" output="false" hint="Update User Email">
		<cfargument name="ID" required="yes" hint="User ID" />
		<cfargument name="username" required="yes" hint="Username">

		<cfquery 
			datasource="#APPLICATION.DSN.Source#">
				UPDATE
                	user
                SET
                    username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.username)#">
				WHERE
	                ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.ID)#">
		</cfquery>
		
	</cffunction>
    
    
    <!--- Update User Password --->
	<cffunction name="updatePassword" access="public" returntype="void" output="false" hint="Update User Password">
		<cfargument name="ID" required="yes" hint="User ID" />
        <cfargument name="password" required="yes" hint="Password">

		<cfquery 
			datasource="#APPLICATION.DSN.Source#">
				UPDATE
                	user
                SET
                    password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.password)#">
				WHERE
	                ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.ID)#">
		</cfquery>

	</cffunction>
 
 
 	<!--- Update Logged In Date --->
 	<cffunction name="updateLoggedInDate" access="public" returntype="void" output="false" hint="Update User last logged in date">
		<cfargument name="ID" required="yes" hint="User ID" />

		<cfquery 
			datasource="#APPLICATION.DSN.Source#">
				UPDATE 
                	user
                SET
                	dateLastLoggedIn =  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				WHERE
                	id = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.ID#">
		</cfquery>
		
	</cffunction>

</cfcomponent>