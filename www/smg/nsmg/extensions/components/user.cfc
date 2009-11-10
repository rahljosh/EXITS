<!--- ------------------------------------------------------------------------- ----
	
	File:		user.cfc
	Author:		Marcus Melo
	Date:		October, 27 2009
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

	
	<cffunction name="getUsers" access="public" returntype="query" output="false" hint="Gets a list of users, if userID is passed gets a user by ID">
    	<cfargument name="userID" default="0" hint="userID is not required">
    	<cfargument name="usertype" default="0" hint="usertype is not required">
              
        <cfquery 
			name="qGetUsers" 
			datasource="#APPLICATION.dsn#">
                SELECT
					*
                FROM 
                    smg_users
                WHERE
                	1 = 1
				<cfif VAL(ARGUMENTS.userID)>
                	AND	
                    	userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">
                </cfif>
				<cfif VAL(ARGUMENTS.usertype)>
                	AND	
                    	usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.usertype#">
                </cfif>
                ORDER BY 
                    lastName
		</cfquery>
		   
		<cfreturn qGetUsers>
	</cffunction>


	<cffunction name="getTraining" access="public" returntype="query" output="false" hint="Gets a list of training records for a userID">
    	<cfargument name="userID" default="0" hint="userID is not required">
              
        <cfquery 
			name="qGetTraining" 
			datasource="#APPLICATION.dsn#">
                SELECT
					id,
                    userID,
                    officeUserID,
                    notes,
                    dateTrained,
                    dateCreated,
                    dateUpdated
                FROM 
                    smg_users_training
                WHERE
                    userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">
                ORDER BY 
                    dateCreated
		</cfquery>
		   
		<cfreturn qGetTraining>
	</cffunction>


	<cffunction name="insertTraining" access="public" returntype="void" output="false" hint="Inserts a training. UserID must be passed.">
    	<cfargument name="userID" hint="userID is required">
        <cfargument name="officeUserID" hint="officeUserID is required">
        <cfargument name="notes" default="" hint="notes is not required">
        <cfargument name="dateTrained" hint="dateTrained is required">
              
        <cfquery 
			name="qInsertTraining" 
			datasource="#APPLICATION.dsn#">
                INSERT INTO
                	smg_users_training
                (
                    userID,
                    officeUserID,
                    notes,
                    dateTrained,
                    dateCreated,
                    dateUpdated
                )
                VALUES
                (
                	<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.officeUserID#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.notes#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(ARGUMENTS.dateTrained)#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(now())#">,
                	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(now())#">
                )	
		</cfquery>
		   
	</cffunction>

</cfcomponent>