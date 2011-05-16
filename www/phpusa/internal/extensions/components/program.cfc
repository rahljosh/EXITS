<!--- ------------------------------------------------------------------------- ----
	
	File:		program.cfc
	Author:		Marcus Melo
	Date:		May 12, 2011
	Desc:		This holds the functions needed for the program

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

	
	<cffunction name="getPrograms" access="public" returntype="query" output="false" hint="Gets a list of programs, if programID is passed gets a program by ID">
    	<cfargument name="programID" default="0" hint="programID is not required">
        <cfargument name="isActive" default="" hint="IsActive is not required">
        <cfargument name="dateActive" default="" hint="DateActive is not required">
        <cfargument name="companyID" default="" hint="CompanyID is not required">
        <cfargument name="isEndingSoon" default="0" hint="Get only programs that are ending soon for the insurance extension/early return">
        <cfargument name="isFullYear" default="0" hint="Get only 10 month programs">
        <cfargument name="isUpcomingPrograms" default="0" hint="Get only upcoming programs, used to assign new student applications at the time of approval">         
              
        <cfquery 
			name="qGetPrograms" 
			datasource="#APPLICATION.dsn#">
                SELECT
					p.programID,
                    p.programName,
                    p.type,
                    p.startDate,
                    p.endDate,
                    p.insurance_startDate,
                    p.insurance_endDate,
                    p.sevis_startDate,
                    p.sevis_endDate,
                    p.preAyp_date,
                    p.companyID,
                    p.programFee,
                    p.application_fee,
                    p.insurance_w_deduct,
                    p.insurance_wo_deduct,
                    p.blank,
                    p.hold,
                    p.progress_reports_active,
                    p.seasonID,
                    p.smgSeasonID,
                    p.tripID,
                    p.active,
                    p.fieldViewable,
                    p.insurance_batch,
                    c.companyName,
                    c.companyShort
                FROM 
                    smg_programs p
				LEFT OUTER JOIN
                	smg_companies c ON c.companyID = p.companyID                    
                WHERE
                	p.is_deleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
               
				<cfif LEN(ARGUMENTS.companyID)>
                    AND
                        p.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyID#">
                <cfelse>
                    AND
                        p.companyid IN (<cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,5,10,12,13" list="yes">)
                </cfif>	                
                    
				<cfif VAL(ARGUMENTS.programID)>
                	AND
                    	p.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.programID#">
                </cfif>
                
				<cfif LEN(ARGUMENTS.isActive)>
                	AND
                    	p.active = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.isActive)#">
                </cfif>

				<cfif VAL(ARGUMENTS.dateActive)>
                    AND
                    	p.endDate >= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
                </cfif>

				<cfif VAL(ARGUMENTS.isEndingSoon)>
                    AND
                    	( p.endDate BETWEEN <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('m', -3, now())#"> AND <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('m', 3, now())#"> ) 
                </cfif>

				<cfif VAL(ARGUMENTS.isFullYear)>
                    AND
                    	p.type IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,5" list="yes"> )
                </cfif>

				<cfif VAL(ARGUMENTS.isUpcomingPrograms)>
                    AND
                    	p.startDate >= <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('m', -1, now())#">
                </cfif>

                ORDER BY 
                   p.startDate DESC,
                   p.programName
		</cfquery>
		   
		<cfreturn qGetPrograms>
	</cffunction>


</cfcomponent>