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


	<!--- Get Current Season Based on Today's date --->
	<cffunction name="getCurrentSeason" access="public" returntype="query" output="false" hint=" Get Current Season Based on Today's date ">
	
		<cfquery 
			name="qGetCurrentSeason" 
			datasource="#APPLICATION.DSN.Source#">
				SELECT
                	seasonID,
                    season,
                    years,                    
                    active,
                    startDate,
                    endDate,
                    DATE_ADD(endDate, INTERVAL 31 DAY) AS newEndDate, 
                    datePaperworkStarted,
                    datePaperworkEnded
				FROM
                	smg_seasons
                WHERE
					CURRENT_DATE() BETWEEN startDate AND DATE_ADD(endDate, INTERVAL 31 DAY)  
    	</cfquery>
        
        <cfreturn qGetCurrentSeason>        
    </cffunction>
    

	<cffunction name="getPictureCategory" access="public" returntype="query" output="false" hint="Returns a list of categories">
    	<cfargument name="ID" default="" hint="ID is not required">

        <cfquery 
        	name="qGetCountry"
        	datasource="#APPLICATION.DSN.Source#">
                SELECT 
                	catID,
                    cat_name,
                    active,
                    requirements,
                    divName
				FROM
                	smg_host_pic_cat
				<cfif LEN(ARGUMENTS.ID)>
	                WHERE 
                        catID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.ID)#">
                </cfif>                        
        </cfquery> 

		<cfreturn qGetCountry>
	</cffunction>


	<cffunction name="getCountry" access="public" returntype="query" output="false" hint="Returns a country or list of countries">
    	<cfargument name="countryID" default="0" hint="countryID is not required">

        <cfquery 
        	name="qGetCountry"
        	datasource="#APPLICATION.DSN.Source#">
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


	<cffunction name="getState" access="public" returntype="query" output="false" hint="Returns a state or list of states">
    	<cfargument name="stateID" default="0" hint="stateID is not required">

        <cfquery 
        	name="qGetState"
        	datasource="#APPLICATION.DSN.Source#">
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


	<cffunction name="getInterest" access="public" returntype="query" output="false" hint="Returns a interest or a list of interests">
    	<cfargument name="interestID" default="" hint="interestID or a list of interestIDs - Not required">
        <cfargument name="Limit" default="" hint="Total of interests">

        <cfquery 
        	name="qGetInterest"
        	datasource="#APPLICATION.DSN.Source#">
                SELECT 
                	interestID,
                    interest,
                    student_app
				FROM
                	smg_interests
				<cfif LEN(ARGUMENTS.interestID)>
                    WHERE 
                        interestID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.interestID#" list="yes"> )
                </cfif> 
                
                <cfif LEN(ARGUMENTS.Limit) AND ListFind("1,2,3,4,5,6,7,8,9,10", ARGUMENTS.Limit)>
                	LIMIT
                    	#ARGUMENTS.Limit#
                </cfif>
                                       
        </cfquery> 

		<cfreturn qGetInterest>
	</cffunction>


</cfcomponent>