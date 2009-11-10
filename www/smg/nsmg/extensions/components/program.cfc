<!--- ------------------------------------------------------------------------- ----
	
	File:		program.cfc
	Author:		Marcus Melo
	Date:		October, 27 2009
	Desc:		This holds the functions needed for the user

----- ------------------------------------------------------------------------- --->

<cfcomponent 
	displayname="program"
	output="false" 
	hint="A collection of functions for the company">


	<!--- Return the initialized Company object --->
	<cffunction name="Init" access="public" returntype="program" output="false" hint="Returns the initialized program object">
		
		<cfscript>
			// There is nothing really to initiate, so just return this
			return(this);
		</cfscript>
        
	</cffunction>

	
	<cffunction name="getPrograms" access="public" returntype="query" output="false" hint="Gets a list of users, if programID is passed gets a program by ID">
    	<cfargument name="programID" default="0" hint="programID is not required">
              
        <cfquery 
			name="qGetPrograms" 
			datasource="#APPLICATION.dsn#">
                SELECT
					programID,
                    programName,
                    type,
                    startDate,
                    endDate,
                    insurance_startDate,
                    insurance_endDate,
                    sevis_startDate,
                    sevis_endDate,
                    preAyp_date,
                    companyID,
                    programFee,
                    application_fee,
                    insurance_w_deduct,
                    insurance_wo_deduct,
                    blank,
                    hold,
                    progress_reports_active,
                    seasonID,
                    smgSeasonID,
                    tripID,
                    active,
                    fieldViewable,
                    insurance_batch
                FROM 
                    smg_programs
                <cfif VAL(ARGUMENTS.programID)>
                	WHERE
                    	programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.programID#">
                </cfif>    
                ORDER BY 
                    programName
		</cfquery>
		   
		<cfreturn qGetPrograms>
	</cffunction>

</cfcomponent>