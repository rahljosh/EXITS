<cfcomponent displayname="tour"output="false" hint="A collection of functions for MPD Tours">


	<!--- Return the initialized Tour object --->
	<cffunction name="Init" access="public" returntype="tour" output="false" hint="Returns the initialized tour object">
		
		<cfscript>
			// There is nothing really to initiate, so just return this
			return(this);
		</cfscript>
        
	</cffunction>

	<!--- Get all active tours --->
	<cffunction name="getAllActiveTours" access="public" returntype="query">
		
        <cfquery name="qGetAllActiveTours" datasource="#APPLICATION.DSN#">
        	SELECT
            	*
           	FROM
            	smg_tours
           	WHERE
            	isActive = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
           	ORDER BY
            	tour_name
        </cfquery>
        
		<cfreturn qGetAllActiveTours>
        
	</cffunction>
    
</cfcomponent>