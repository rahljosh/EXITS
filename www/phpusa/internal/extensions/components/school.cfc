<!--- ------------------------------------------------------------------------- ----
	
	File:		school.cfc
	Author:		Marcus Melo
	Date:		May 13, 2011
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
    	<cfargument name="schoolID" default="" hint="schoolID is not required">
              
        <cfquery 
			name="qGetSchools" 
			datasource="#APPLICATION.dsn#">
                SELECT
					schoolID,
					fk_ny_user,
                    active,
                    show_school,
                    schoolName,
                    address,
                    address2,
                    city,
                    state,
                    zip,
                    email,
                    phone,
                    cell_phone,
                    emergency_contact,
                    emergency_phone,
                    fax,
                    website,
                    tuition_notes,
                    tuition_semester,
                    tuition_year,
                    tuition_12months,
                    nonRef_deposit,
                    refund_plan,
                    focus_gender,
                    contact,
                    contact_title,
                    fax_comments,
                    misc_notes,
                    communityType,
                    nearBigCity,
                    bigCityDistance,
                    local_air_code,
                    major_air_code,
                    airport_city,
                    airport_state,
                    boarding_school,
                    boarding_notes,
                    pert_info,
                    localContact,
                    ext_school_type,
                    ext_school_grade_offer,
                    ext_school_religion,
                    ext_school_number_students,
                    ext_school_int_students,
                    ext_ratio,
                    ext_uniform,
                    ext_esl,
                    ext_school_about,
                    ext_school_location,
                    ext_housing,
                    ext_courses,
                    ext_dress_code,
                    ext_athletics,
                    ext_sat,
                    ext_major_city,
                    payHost,
                    manager,
                    supervising_rep,
                    password,
                    dateAdded,
                    lastLogin,
                    lastUpdated
                FROM 
                    php_schools
                <cfif LEN(ARGUMENTS.schoolID)>                	
                	WHERE
                    	schoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.schoolID)#">
                </cfif>    
                ORDER BY 
                    schoolName
		</cfquery>
		   
		<cfreturn qGetSchools>
	</cffunction>
    
 
	<cffunction name="getSchoolDates" access="public" returntype="query" output="false" hint="Returns school dates">
    	<cfargument name="schoolID" hint="schoolID is required">
        <cfargument name="programID" hint="programID is required to get the correct dates according to the season">
        <cfargument name="seasonID" default="0" hint="seasonID is not required">
              
        <cfquery 
			name="qGetSchoolDates" 
			datasource="#APPLICATION.dsn#">
                SELECT 
                	sd.schoolDateID,
                    sd.schoolID,
                    sd.seasonID,
                    sd.enrollment,
                    sd.year_begins,
                    sd.semester_ends,
                    sd.semester_begins,
                    sd.year_ends,
                    p.type
                FROM 
                	php_school_dates sd
                INNER JOIN
                	smg_programs p ON p.seasonID = sd.seasonID
                WHERE
                	sd.schoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.schoolID)#">
                AND 
                	p.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.programID)#">
		</cfquery>
		
        <cfscript>
			var qReturnDates = QueryNew("startDate, endDate");
			
			/*  Return Start/End dates based on programType
				1 = 10 month
				5 = 10 month J1 Private
				
				3 = 1st Semester
				25 = 1st Semester J1 Private

				4 = 2nd Semester
				26 - 2nd Semester J1 Private								

				2 = 12 month
				24 = 12 month J1 Private
			*/
		</cfscript>

		<cfswitch expression="#qGetSchoolDates.type#">
        
        	<cfcase value="1,5">
            	
				<cfscript>
					// 10 Month Program
					QueryAddRow(qReturnDates);
					QuerySetCell(qReturnDates, "startDate", DateFormat(qGetSchoolDates.year_begins, 'mm/dd/yyyy') );	
					QuerySetCell(qReturnDates, "endDate", DateFormat(qGetSchoolDates.year_ends, 'mm/dd/yyyy') );
				</cfscript>
                
            </cfcase>
            
        	<cfcase value="3,25">
            	
				<cfscript>
					// 1st Semester
					QueryAddRow(qReturnDates);
					QuerySetCell(qReturnDates, "startDate", DateFormat(qGetSchoolDates.year_begins, 'mm/dd/yyyy') );	
					QuerySetCell(qReturnDates, "endDate", DateFormat(qGetSchoolDates.semester_ends, 'mm/dd/yyyy'));
				</cfscript>
                
            </cfcase>

        	<cfcase value="4,26">
            	
				<cfscript>
					// 2nd Semester
					QueryAddRow(qReturnDates);
					QuerySetCell(qReturnDates, "startDate", DateFormat(qGetSchoolDates.semester_begins, 'mm/dd/yyyy') );	
					QuerySetCell(qReturnDates, "endDate", DateFormat(qGetSchoolDates.year_ends, 'mm/dd/yyyy') );
				</cfscript>
                
            </cfcase>

        	<cfcase value="2,24">
            	
				<cfscript>
					// 12 Month
					QueryAddRow(qReturnDates);
					QuerySetCell(qReturnDates, "startDate", DateFormat(qGetSchoolDates.semester_begins, 'mm/dd/yyyy') );	
					QuerySetCell(qReturnDates, "endDate", DateFormat(qGetSchoolDates.year_ends, 'mm/dd/yyyy') );
				</cfscript>
                
            </cfcase>
        	
            <cfdefaultcase>
				
				<cfscript>
					// Query did not return data
					QueryAddRow(qReturnDates);
					QuerySetCell(qReturnDates, "startDate", "n/a");	
					QuerySetCell(qReturnDates, "endDate", "n/a");
            	</cfscript>
                
            </cfdefaultcase>
        
        </cfswitch>
        		   
		<cfreturn qReturnDates>
	</cffunction>

    
</cfcomponent>