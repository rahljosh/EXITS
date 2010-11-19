<!--- ------------------------------------------------------------------------- ----
	
	File:		LookUpTables.cfc
	Author:		Marcus Melo
	Date:		April 15, 2010
	Desc:		This holds the functions used to get data from lookup tables

----- ------------------------------------------------------------------------- --->

<cfcomponent 
	displayname="LookUpTables"
	output="false" 
	hint="A collection of functions for lookup tables">


	<!--- Return the initialized Company object --->
	<cffunction name="Init" access="public" returntype="LookUpTables" output="false" hint="Returns the initialized LookUpTables object">
		
		<cfscript>
			// There is nothing really to initiate, so just return this
			return(this);
		</cfscript>
        
	</cffunction>


	<cffunction name="getCountry" access="public" returntype="query" output="false" hint="Returns a country or list of countries">
    	<cfargument name="countryID" default="0" hint="countryID is not required">

        <cfquery 
        	name="qGetCountry"
        	datasource="MySQL">
                SELECT 
                	countryID,
                    countryName,
                    countryCode,
                    sevisCode,
                    continent
				FROM
                	smg_countrylist
				<cfif VAL(ARGUMENTS.countryID)>
	                WHERE 
                        countryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.countryID#">
                </cfif>                        
        </cfquery> 

		<cfreturn qGetCountry>
	</cffunction>


	<cffunction name="getInterest" access="public" returntype="query" output="false" hint="Returns a interest or a list of interests">
    	<cfargument name="interestID" default="0" hint="interestID or a list of interestIDs - Not required">

        <cfquery 
        	name="qGetInterest"
        	datasource="MySQL">
                SELECT 
                	interestID,
                    interest,
                    student_app
				FROM
                	smg_interests
				<cfif VAL(ARGUMENTS.interestID)>
                    WHERE 
                        interestID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.interestID#" list="yes"> )
                </cfif>                        
        </cfquery> 

		<cfreturn qGetInterest>
	</cffunction>


	<cffunction name="getPrivateSchool" access="public" returntype="query" output="false" hint="Returns a private school or a list of private school options">
    	<cfargument name="privateSchoolID" default="0" hint="privateSchoolID is not required">

        <cfquery 
        	name="qGetPrivateSchool"
        	datasource="MySQL">
                SELECT 
                	privateSchoolID,
                    privateSchoolPrice,
                    type
				FROM
                	smg_private_schools
				<cfif IsNumeric(ARGUMENTS.privateSchoolID)>
                    WHERE 
                        privateSchoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.privateSchoolID#">
                </cfif>                        
        </cfquery> 

		<cfreturn qGetPrivateSchool>
	</cffunction>


	<cffunction name="getState" access="public" returntype="query" output="false" hint="Returns a state or list of states">
    	<cfargument name="stateID" default="0" hint="stateID is not required">

        <cfquery 
        	name="qGetState"
        	datasource="MySQL">
                SELECT 
                	ID,
                    state,
                    stateName,
                    guarantee_fee
				FROM
                	smg_states
				<cfif VAL(ARGUMENTS.stateID)>
                    WHERE 
                        ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.stateID#">
                </cfif>                        
        </cfquery> 

		<cfreturn qGetState>
	</cffunction>



</cfcomponent>