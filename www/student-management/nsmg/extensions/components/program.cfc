<!--- ------------------------------------------------------------------------- ----
	
	File:		program.cfc
	Author:		Marcus Melo
	Date:		October, 27 2009
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
                    	p.startDate <= <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('m', 6, now())#">
                    AND
                    	p.endDate >= <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('m', -3, now())#">
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


	<cffunction name="getOnlineAppPrograms" access="public" returntype="query" output="false" hint="Gets a list of program used on the online application, if app_programID is passed gets a program by ID">
    	<cfargument name="app_programID" default="0" hint="app_programID is not required">
        <cfargument name="companyID" default="" hint="List of companies">
        <cfargument name="isActive" default="" hint="IsActive is not required">
              
        <cfquery 
			name="qGetOnlineAppPrograms" 
			datasource="#APPLICATION.dsn#">
                SELECT
					app_programID,
                    companyID,
                    app_program,
                    short_name,
                    app_type,
                    country,
                    isActive
                FROM 
                    smg_student_app_programs
                WHERE
                	1 = 1

				<cfif VAL(ARGUMENTS.app_programID)>
                	AND
                    	app_programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.app_programID#">
                </cfif>
                
				<cfif LEN(ARGUMENTS.companyID)>
                    AND
                        companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyID#">
                <cfelse>
                    AND
                        companyid IN (<cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,5,10,12,13,14" list="yes">)
                </cfif>	                
                    
				<cfif LEN(ARGUMENTS.isActive)>
                	AND
                    	isActive = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.isActive)#">
                </cfif>
				ORDER BY 
                app_program
		</cfquery>
		   
		<cfreturn qGetOnlineAppPrograms>
	</cffunction>
    
	<!----Get available acive programs that match the type of program selected---->
    <cffunction access="remote" name="qGetActiveInternalPrograms" output="no" returntype="query" hint="Gets a list of active programs associated with the program type indicated. Needs to get the program type id." verifyclient="no" securejson="false">

    	<cfargument name="programTypeID" default="0" hint="programTypeID is not required">

        <cfquery 
			name="qGetActiveInternalPrograms" 
			datasource="#APPLICATION.dsn#">
                SELECT
                	programid,
					programname,
                    startdate,
                    enddate
                FROM 
                    smg_programs
                WHERE
                	fk_smg_student_app_programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.programTypeID)#">
                    							  
                AND
                    active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                ORDER BY 
                   programname
		</cfquery>
		   
		<cfscript>
			// Return message to user if not was found
			if ( NOT VAL(qGetActiveInternalPrograms.recordCount) ) {
				QueryAddRow(qGetActiveInternalPrograms, 1);
				QuerySetCell(qGetActiveInternalPrograms, "programID", 0);	
				QuerySetCell(qGetActiveInternalPrograms, "programname", "---- No Additional Program Info ----", 1);
				
			}
			
			// Return message if companyID is not valid
			if ( NOT VAL(ARGUMENTS.programTypeID) ) {
				qGetActiveInternalPrograms = QueryNew("programID, programname");
				QueryAddRow(qGetActiveInternalPrograms);
				QuerySetCell(qGetActiveInternalPrograms, "programID", 0);	
				QuerySetCell(qGetActiveInternalPrograms, "programname", "---- Select a program type ----", 1);
				
			}

			return qGetActiveInternalPrograms;
		</cfscript>
	</cffunction>

	<cffunction name="insertProgramHistory" access="public" returntype="void" output="false" hint="Inserts a program history">
    	<cfargument name="studentID" hint="studentID is required">
        <cfargument name="programID" hint="programID is required">
        <cfargument name="reason" default="" hint="reason is not required">
        <cfargument name="changedBy" hint="changedBy is required">
              
        <cfquery 
			datasource="#APPLICATION.dsn#">
			INSERT INTO 
            	smg_programhistory
			(
            	studentID, 
                programID, 
                reason, 
                changedby,  
                date
            )
			VALUES
			(
            	<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">, 
                <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.programID#">, 
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.reason#">, 
                <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.changedBy#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
           )
		</cfquery>

	</cffunction>

</cfcomponent>