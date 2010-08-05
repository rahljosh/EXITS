<!--- ------------------------------------------------------------------------- ----
	
	File:		flightInformation.cfc
	Author:		Marcus Melo
	Date:		August, 05 2010
	Desc:		This holds the functions needed for the flightInformation

----- ------------------------------------------------------------------------- --->

<cfcomponent 
	displayname="flightInformation"
	output="false" 
	hint="A collection of functions for the flightInformation">


	<!--- Return the initialized Company object --->
	<cffunction name="Init" access="public" returntype="flightInformation" output="false" hint="Returns the initialized flightInformation object">
		
		<cfscript>
			// There is nothing really to initiate, so just return this
			return(this);
		</cfscript>
        
	</cffunction>

	
	<cffunction name="setAssignedID" access="public" returntype="void" output="false" hint="Sets the programID for flight information that are missing it">
        <cfargument name="studentID" type="numeric" hint="studentID is required">
        <cfargument name="assignedID" type="numeric" hint="assignedID is required">
        <cfargument name="programID" type="numeric" hint="programID is required">
        <cfargument name="depDate" hint="depDate is required">
              
        <cfquery datasource="#APPLICATION.dsn#">
            UPDATE
            	smg_flight_info
            SET
                assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.assignedID#">,
                programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.programID#">
			WHERE
            	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">  
			AND
            	assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
			<!--- Get all legs for this flight information - use a 20 day window --->                
			AND 
                dep_date >= DATE_ADD(<cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.depDate#">, INTERVAL -20 DAY)
			AND 
                dep_date <= DATE_ADD(<cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.depDate#">, INTERVAL 20 DAY)
        </cfquery>
           
	</cffunction>   

</cfcomponent>