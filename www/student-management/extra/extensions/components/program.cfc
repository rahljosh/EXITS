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