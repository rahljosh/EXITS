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
        <cfargument name="isActive" default="1" hint="isActive is not required">
              
        <cfquery 
			name="qGetUsers" 
			datasource="#APPLICATION.dsn#">
                SELECT
					*
                FROM 
                    smg_users
                WHERE
                	1 = 1

				<cfif LEN(ARGUMENTS.userID)>
                	AND	
                    	userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userID)#">
                </cfif>
                    
				<cfif VAL(ARGUMENTS.usertype)>
                	AND	
                    	usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.usertype#">
                </cfif>
                
                <cfif LEN(ARGUMENTS.isActive)>
                	AND
                    	active = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.isActive#">
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


</cfcomponent>