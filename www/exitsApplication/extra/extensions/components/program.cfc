<!--- ------------------------------------------------------------------------- ----
	
	File:		program.cfc
	Author:		Marcus Melo
	Date:		August 19, 2010
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
    	<cfargument name="programID" default="" hint="programID is not required">
        <cfargument name="isActive" default="" hint="IsActive is not required">
        <cfargument name="dateActive" default="" hint="DateActive is not required">
        <cfargument name="companyID" default="" hint="CompanyID is not required">
              
        <cfquery 
			name="qGetPrograms" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT
					p.programID,
                    p.companyID,
                    p.programName,
                    p.type,
                    p.extra_sponsor,
                    p.startDate,
                    p.endDate,
                    p.programFee,
                    p.application_fee,
                    p.insurance_startdate, 
                    p.insurance_enddate, 
                    p.insurance_w_deduct,
                    p.insurance_wo_deduct,
                    p.active,
                    p.hold,
                    p.fieldViewable,
                    p.insurance_batch,
                    type.programType,
                    c.companyName
                FROM 
                    smg_programs p
                INNER JOIN 
                    smg_companies c ON c.companyid = p.companyid
                LEFT OUTER JOIN 
                    smg_program_type type ON type.programTypeID = p.type
                WHERE
                	p.is_deleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                AND
                    p.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.companyID)#">
                    
				<cfif LEN(ARGUMENTS.programID)>
                	AND
                    	p.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.programID)#">
                </cfif>
                
				<cfif LEN(ARGUMENTS.isActive)>
                	AND
                    	p.active = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.isActive)#">
                </cfif>

				<cfif VAL(ARGUMENTS.dateActive)>
                    AND
                    	p.endDate >= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
                </cfif>

                ORDER BY 
                   p.startDate DESC,
                   p.programName
		</cfquery>
		   
		<cfreturn qGetPrograms>
	</cffunction>   
    
    
    <!--- Remote --->
	<cffunction name="getProgramsRemote" access="remote" returntype="array" output="false" hint="Gets a list of Programs">
        <cfargument name="isActive" default="1" hint="isActive is not required">
		 
        <cfscript>
			// Define variables
        	var qGetProgramsRemote='';
			var result=ArrayNew(2);
			var i=0;
        </cfscript>
               
        <cfquery 
			name="qGetProgramsRemote" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT
					programID,
                    programName
                FROM 
                    smg_programs
                WHERE
                    companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
                AND
                	active = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.isActive#">
                ORDER BY   
					startDate DESC,
                    programName                    
		</cfquery>

        <cfscript>
			// Add default value
			result[1][1]=0;
			result[1][2]="---- Select a Program ----";
			
			// Convert results to array
			For (i=1;i LTE qGetProgramsRemote.Recordcount; i=i+1) {
				result[i+1][1]=qGetProgramsRemote.programID[i];
				result[i+1][2]=qGetProgramsRemote.programName[i];
			}
			
			return result;
		</cfscript>
	</cffunction>
    <!--- End Of Remote --->

</cfcomponent>