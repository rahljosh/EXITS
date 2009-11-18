<!--- ------------------------------------------------------------------------- ----
	
	File:		student.cfc
	Author:		Marcus Melo
	Date:		October, 27 2009
	Desc:		This holds the functions needed for the user

----- ------------------------------------------------------------------------- --->

<cfcomponent 
	displayname="student"
	output="false" 
	hint="A collection of functions for the company">


	<!--- Return the initialized Company object --->
	<cffunction name="Init" access="public" returntype="student" output="false" hint="Returns the initialized student object">
		
		<cfscript>
			// There is nothing really to initiate, so just return this
			return(this);
		</cfscript>
        
	</cffunction>

	
	<cffunction name="getStudents" access="public" returntype="query" output="false" hint="Gets a list of students, if studentID is passed gets a student by ID">
    	<cfargument name="studentID" default="0" hint="studentID is not required">
              
        <cfquery 
			name="qGetStudents" 
			datasource="#APPLICATION.dsn#">
                SELECT
					*
                FROM 
                    smg_students
                <cfif VAL(ARGUMENTS.studentID)>
                	WHERE
                    	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">
                </cfif>    
                ORDER BY 
                    familyLastName
		</cfquery>
		   
		<cfreturn qGetStudents>
	</cffunction>


	<cffunction name="setProjectHelpDate" access="public" returntype="void" output="false" hint="Updates Project Help Date">
    	<cfargument name="studentID" hint="studentID is required">
        <cfargument name="dateProjectHelp" hint="Date is required">
              
        <cfquery 
			datasource="#APPLICATION.dsn#">
                UPDATE
                	smg_students
                SET	
                	<cfif IsDate(ARGUMENTS.dateProjectHelp)>
	                    date_project_help_completed = <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(ARGUMENTS.dateProjectHelp)#">
                    <cfelse>
                    	date_project_help_completed = <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                    </cfif>
                WHERE
                    studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">
		</cfquery>
		   
	</cffunction>


</cfcomponent>