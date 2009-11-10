<!--- ------------------------------------------------------------------------- ----
	
	File:		school.cfc
	Author:		Marcus Melo
	Date:		October, 27 2009
	Desc:		This holds the functions needed for the school

----- ------------------------------------------------------------------------- --->

<cfcomponent 
	displayname="school"
	output="false" 
	hint="A collection of functions for the company">


	<!--- Return the initialized Company object --->
	<cffunction name="Init" access="public" returntype="school" output="false" hint="Returns the initialized School object">
		
		<cfscript>
			// There is nothing really to initiate, so just return this
			return(this);
		</cfscript>
        
	</cffunction>

	
	<cffunction name="getSchools" access="public" returntype="query" output="false" hint="Gets a list of schools, if schoolID is passed gets a school by ID">
    	<cfargument name="schoolID" default="0" hint="schoolID is not required">
              
        <cfquery 
			name="qGetSchools" 
			datasource="#APPLICATION.dsn#">
                SELECT
					schoolID,
                    schoolName,
                    regionID,
                    schoolDistrict,
                    principal,
                    address,
                    address2,
                    city,
                    state,
                    zip,
                    phone,
                    phone_ext,
                    fax,
                    email,
                    url,
                    allowGraduation,
                    tuition,
                    bookFees,
                    numberOfStudents,
                    collegeBound,
                    comments,
                    begins,
                    semesterEnds,
                    semesterBegins,
                    ends,
                    enrollment,
                    special_programs,
                    grad_policy,
                    sports,
                    other_policies,
                    private_school_info,
                    other_trans
                FROM 
                    smg_schools
                <cfif VAL(ARGUMENTS.schoolID)>
                	WHERE
                    	schoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.schoolID#">
                </cfif>    
                ORDER BY 
                    schoolName
		</cfquery>
		   
		<cfreturn qGetSchools>
	</cffunction>
    
    
	<cffunction name="getPrivateSchools" access="public" returntype="query" output="false" hint="Gets a list of Private schools, if privateSchoolID is passed gets it by ID">
    	<cfargument name="privateSchoolID" default="0" hint="privateSchoolID is not required">
              
        <cfquery 
			name="qGetPrivateSchools" 
			datasource="#APPLICATION.dsn#">
                SELECT
					privateSchoolID,
                    privateSchoolPrice,
                    type
                FROM 
                    smg_private_schools
                <cfif VAL(ARGUMENTS.privateSchoolID)>
                	WHERE
                    	privateSchoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.privateSchoolID#">
                </cfif>    
                ORDER BY 
                    privateSchoolPrice
		</cfquery>
		   
		<cfreturn qGetPrivateSchools>
	</cffunction>
    
    
	<cffunction name="getIFFSchools" access="public" returntype="query" output="false" hint="Gets a list of IFF schools, if IFFID is passed gets it by ID">
    	<cfargument name="IFFID" default="0" hint="IFFID is not required">
              
        <cfquery 
			name="qGetIFFSchools" 
			datasource="#APPLICATION.dsn#">
                SELECT
					IFFID,
                    name
                FROM 
                    smg_iff
                <cfif VAL(ARGUMENTS.IFFID)>
                	WHERE
                    	IFFID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.IFFID#">
                </cfif>    
                ORDER BY 
                    name
		</cfquery>
		   
		<cfreturn qGetIFFSchools>
	</cffunction>
    
    
	<cffunction name="getAYPCamps" access="public" returntype="query" output="false" hint="Gets a list of AYP Camps, if campID is passed gets it by ID">
    	<cfargument name="campID" default="0" hint="IFFID is not required">
              
        <cfquery 
			name="qGetAYPCamps" 
			datasource="#APPLICATION.dsn#">
                SELECT
					campID,
                    name,
                    campType
                FROM 
                    smg_aypcamps
                <cfif VAL(ARGUMENTS.campID)>
                	WHERE
                    	campID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.campID#">
                </cfif>    
                ORDER BY 
                    name
		</cfquery>
		   
		<cfreturn qGetAYPCamps>
	</cffunction>
    

</cfcomponent>