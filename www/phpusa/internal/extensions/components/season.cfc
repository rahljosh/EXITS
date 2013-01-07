<!--- ------------------------------------------------------------------------- ----
	
	File:		season.cfc
	Author:		James Griffiths
	Date:		January 4, 2013
	Desc:		This holds the functions needed for the season

----- ------------------------------------------------------------------------- --->

<cfcomponent displayname="season" output="false" hint="A collection of functions for the season">


	<!--- Return the initialized Season object --->
	<cffunction name="Init" access="public" returntype="season" output="false" hint="Returns the initialized season object">
		
		<cfscript>
			// There is nothing really to initiate, so just return this
			return(this);
		</cfscript>
        
	</cffunction>
    
    <!--- Function to get seasons --->
    <cffunction name="getSeasons" access="public" returntype="query" output="false" hint="Gets a list of seasons, if seasonID is passed it gets a season by ID">
    	<cfargument name="seasonID" default="0" hint="seasonID is not required">
        <cfargument name="active" default="0" hint="active is not required, 0: all seasons, 1: seasons between startDate and endDate, 2: seasons between datePaperworkStarted and endDate">
        
        <cfquery name="qGetSeasons" datasource="#APPLICATION.DSN#">
        	SELECT *
            FROM smg_seasons
            WHERE 1 = 1
            <cfif VAL(ARGUMENTS.seasonID)>
            	AND seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.seasonID)#">
            </cfif>
            <cfif ARGUMENTS.active EQ 1>
            	AND NOW() BETWEEN startDate AND endDate
            <cfelseif ARGUMENTS.active EQ 2>
            	AND NOW() BETWEEN datePaperworkStarted AND endDate
            </cfif>
            
        </cfquery>
    	
        <cfreturn qGetSeasons>
    
    </cffunction>
    <!--- END Function to get seasons --->

</cfcomponent>