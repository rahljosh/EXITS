<!--- ------------------------------------------------------------------------- ----
	
	File:		insurance.cfc
	Author:		Marcus Melo
	Date:		January 06, 2010
	Desc:		This holds the functions needed for the insurance

----- ------------------------------------------------------------------------- --->

<cfcomponent 
	displayname="insurance"
	output="false" 
	hint="A collection of functions for the company">


	<!--- Return the initialized Company object --->
	<cffunction name="Init" access="public" returntype="insurance" output="false" hint="Returns the initialized program object">
		
		<cfscript>
			// There is nothing really to initiate, so just return this
			return(this);
		</cfscript>
        
	</cffunction>


	<cffunction name="getInsurancePolicies" access="public" returntype="query" output="false" hint="Returns Insurance Policies">
        <cfargument name="insuTypeID" default="0" hint="InsuTypeID is not required">
        <cfargument name="provider" default="" hint="Provider Name eg. Global">
        <cfargument name="isActive" default="1">
        
        <cfquery 
        	name="qGetInsurancePolicies" 
            datasource="#APPLICATION.dsn#">
                SELECT 
                    insuTypeID,
                    type,
                    shortType,
                    provider,
                    ayp5,
                    ayp10,
                    ayp12,
                    active 
                FROM 
                    smg_insurance_type 
                WHERE
                    active = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.isActive)#">
                
                <cfif VAL(ARGUMENTS.insuTypeID)>
                    AND
                        insuTypeID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.insuTypeID#">
                </cfif>
                
                <cfif LEN(ARGUMENTS.provider)>
                    AND
                        provider = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.provider#">
                </cfif>
        </cfquery>
		   
		<cfreturn qGetInsurancePolicies>
	</cffunction>


	<!--- Get Global Secutive History Only --->   
    <cffunction name="getInsuranceHistory" access="public" returntype="query" output="false" hint="Returns insurance history by date">
        <cfargument name="type" default="" hint="Type is not required.">
        <cfargument name="companyID" hint="companyID is required.">
             
        <cfquery 
        	name="qGetInsuranceHistory" 
            datasource="#APPLICATION.dsn#">
                SELECT 
                    date,
                    file,
                    type,                    
                    count(studentID) as totalStudents
                FROM 
                    smg_insurance_batch 
                WHERE
                
                <cfif ARGUMENTS.companyID EQ 10>
                    file LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%CASE%">
                <cfelse>
                    file LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%ISE%">
                </cfif>
                
                <cfif LEN(ARGUMENTS.type)>
                	AND
                    	type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.type#">               
                </cfif>
                
                GROUP BY            
                    file                  
                ORDER BY            
                    date DESC
                LIMIT
                	30
        </cfquery>
		   
		<cfreturn qGetInsuranceHistory>
	</cffunction>


    <cffunction name="getInsuranceHistoryByStudent" access="public" returntype="query" output="false" hint="Returns insurance history by date">
        <cfargument name="studentID" hint="Student ID is required.">
        <cfargument name="type" default="N" hint="List value is not required.">
             
        <cfquery 
        	name="qGetInsuranceHistoryByStudent" 
        	datasource="#APPLICATION.dsn#">
                SELECT 
                    ID,
                    date,
                    studentID,
                    type,
                    startDate,
                    endDate,
                    file
                FROM 
                    smg_insurance_batch 
                WHERE
                    studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">
                AND  
                    type IN ( <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.type#" list="yes"> )                       
                GROUP BY            
                    file                  
                ORDER BY            
                    ID
        </cfquery>
		   
		<cfreturn qGetInsuranceHistoryByStudent>
	</cffunction>

	
    <cffunction name="getStudentsHistory" access="public" returntype="query" output="false" hint="Returns insurance history by date">
        <cfargument name="file" hint="file is required.">
        <cfargument name="date" hint="date is required.">
             
        <cfquery 
        	name="qGetStudentsHistory" 
            datasource="#APPLICATION.dsn#">
                SELECT 
                    s.firstname, 
                    s.familyLastName, 
                    s.dob,
                    s.email,
                    ib.type,
                    ib.startDate,
                    ib.endDate
                FROM 
                    smg_insurance_batch ib
                INNER JOIN
                    smg_students s ON s.studentID = ib.studentID
                INNER JOIN
                    smg_users u ON u.userID = s.intRep                
                WHERE
                    ib.file = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.file#">
                AND
                    ib.date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.date#">                               
                ORDER BY 
                    u.businessname, 
                    s.firstname
        </cfquery>
		   
		<cfreturn qGetStudentsHistory>
	</cffunction>


	<!--- Enroll Students --->
	<cffunction name="getStudentsToInsure" access="public" returntype="query" output="false" hint="Returns students with flight info that needs to be insure">
        <cfargument name="programID" hint="List of program IDs. Required.">
        <cfargument name="PolicyID" hint="Policy ID required">

        <cfquery 
        	name="qGetStudentsToInsure" 
            datasource="#APPLICATION.dsn#">
                SELECT DISTINCT
                    s.studentID, 
                    s.firstname, 
                    s.familyLastName, 
                    s.dob,
                    s.email, 
                    MIN(fi.dep_date) as dep_date,            
                    it.type,  
                    ic.policycode, 
                    p.startDate,
                    p.endDate
                FROM
                    smg_flight_info fi
                INNER JOIN
                    smg_students s ON fi.studentID = s.studentID 
                        AND
                            s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                        AND 
                            s.programID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes">)   
                        <cfif CLIENT.companyID EQ 5>
                            AND          
                                s.companyid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.listISE#" list="yes"> )
                        <cfelse>
                            AND          
                                s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#"> 
                        </cfif>
                INNER JOIN 
                    smg_users u ON u.userid = s.intrep 
                        AND 
                            u.insurance_typeid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.policyID#">
                INNER JOIN
                    smg_insurance_type it ON it.insutypeid = u.insurance_typeid
                INNER JOIN 
                    smg_insurance_codes ic ON ic.insutypeid = it.insutypeid
                INNER JOIN  
                    smg_programs p ON p.programID = s.programID
                LEFT OUTER JOIN 
                    smg_insurance_batch ib ON ib.studentID = fi.studentID 
                        AND 
                            ib.type = <cfqueryparam cfsqltype="cf_sql_varchar" value="N">
                WHERE 
                    fi.flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="arrival">
                AND
                    ib.studentID IS NULL
                GROUP BY 
                    fi.studentID
                ORDER BY 
                    u.businessname, 
                    s.firstname
        </cfquery>
    
		<cfreturn qGetStudentsToInsure>
	</cffunction>


	<!--- Insure Students --->
	<cffunction name="getStudentsToInsureNoFlight" access="public" returntype="query" output="false" hint="Returns students with flight info that needs to be insure">
        <cfargument name="programID" hint="List of program IDs. Required.">
        <cfargument name="PolicyID" hint="Policy ID required">
        <cfargument name="startDate" default="" hint="Start Date is not required">

		<cfscript>			
			// Set up date in the same format to keep consistency with the other date fields {ts 'YYYY-MM-DD HH:MM:SS'} 
			if ( IsDate(ARGUMENTS.startDate) ) {
				ARGUMENTS.startDate = CreateODBCDateTime(ARGUMENTS.startDate);
			} else {
				ARGUMENTS.startDate = CreateODBCDateTime(now());		
			}
		</cfscript>

        <cfquery 
        	name="qGetStudentsToInsureNoFlight" 
            datasource="#APPLICATION.dsn#">
                SELECT DISTINCT
                    s.studentID, 
                    s.firstname, 
                    s.familyLastName, 
                    s.dob, 
                    s.email,
                    "#ARGUMENTS.startDate#" as dep_date,                
                    it.type,  
                    ic.policycode, 
                    p.startDate,
                    p.endDate
                FROM
                    smg_students s  
                INNER JOIN 
                    smg_users u ON u.userid = s.intrep 
                        AND 
                            u.insurance_typeid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.policyID#">
                INNER JOIN
                    smg_insurance_type it ON it.insutypeid = u.insurance_typeid
                INNER JOIN 
                    smg_insurance_codes ic ON ic.insutypeid = it.insutypeid
                INNER JOIN  
                    smg_programs p ON p.programID = s.programID
                LEFT OUTER JOIN 
                    smg_insurance_batch ib ON ib.studentID = s.studentID 
                        AND 
                            ib.type = <cfqueryparam cfsqltype="cf_sql_varchar" value="N">
                WHERE 
                    s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                AND 
                    s.programID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes">)  
                AND
                    ib.studentID IS NULL
                ORDER BY 
                    u.businessname, 
                    s.familyLastName,
                    s.firstName        
		</cfquery>
    
		<cfreturn qGetStudentsToInsureNoFlight>
	</cffunction>

	
    <!--- End Date Correction --->
	<cffunction name="getStudentsReturnRecords" access="public" returntype="query" output="false" hint="Returns students list with depature flight information">
        <cfargument name="programID" hint="List of program IDs. Required.">
              
        <cfquery 
        	name="qGetStudentsReturnRecords" 
            datasource="#APPLICATION.dsn#">
                SELECT DISTINCT
                    s.studentID, 
                    s.firstname, 
                    s.familyLastName, 
                    s.dob,                     
                    ibEndDate.endDate AS insuranceEndDate,                    
                    DATE_ADD( fi.dep_date, INTERVAL 1 DAY) AS returnDate,
                    DATEDIFF( ibEndDate.endDate, DATE_ADD( fi.dep_date, INTERVAL 1 DAY) ) AS returnDays
                FROM
                    smg_students s 
                INNER JOIN
                    smg_flight_info fi ON fi.studentID = s.studentID 
					AND 
                         fi.dep_date = ( SELECT MAX(dep_date) FROM smg_flight_info WHERE studentID = s.studentID AND fi.flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="departure"> ) 
                INNER JOIN 
                    smg_users u ON u.userid = s.intrep 
                INNER JOIN 
                    smg_insurance_batch ibEndDate ON ibEndDate.studentID = s.studentID 
                        AND 
                            ibEndDate.ID = ( SELECT MAX(ID) FROM smg_insurance_batch WHERE studentID = s.studentID )                            
                WHERE 
                    s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                AND 
                    s.programID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes">)
				<cfif CLIENT.companyID EQ 5>
                    AND          
                        s.companyid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.listISE#" list="yes"> )
                <cfelse>
                    AND          
                        s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#"> 
                </cfif>
                AND 
                	DATE_ADD( fi.dep_date, INTERVAL 1 DAY) < ibEndDate.endDate
                GROUP BY 
                    s.studentID
                ORDER BY 
                    u.businessname, 
                    s.familyLastName,
                    s.firstName   
		</cfquery>
        
        <cfreturn qGetStudentsReturnRecords> 
           
	</cffunction>


    <!--- Cancel Insurance --->
	<cffunction name="getStudentsToCancel" access="public" returntype="query" output="false" hint="Returns canceled students with active insurance that needs to be canceled">
        <cfargument name="programID" hint="List of program IDs. Required.">

        <cfquery 
        	name="qGetStudentsToCancel" 
            datasource="#APPLICATION.dsn#">
                SELECT DISTINCT
                    s.studentID, 
                    s.firstname, 
                    s.familyLastName, 
                    s.dob,
                    s.email,
                    s.cancelDate, 
                    ib.startDate,
                    ib.endDate
                FROM
                    smg_insurance_batch ib
                INNER JOIN
                    smg_students s ON s.studentID = ib.studentID   
                        AND	
                            s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                        AND
                            cancelDate IS NOT NULL
                        AND 
                            s.programID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes">)   
                        <cfif CLIENT.companyID EQ 5>
                            AND          
                                s.companyid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.listISE#" list="yes"> )
                        <cfelse>
                            AND          
                                s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#"> 
                        </cfif>
                INNER JOIN 
                    smg_users u ON u.userid = s.intrep 
                INNER JOIN  
                    smg_programs p ON p.programID = s.programID
                LEFT OUTER JOIN 
                    smg_insurance_batch ibc ON ibc.studentID = s.studentID 
                        AND 
                            ibc.type = <cfqueryparam cfsqltype="cf_sql_varchar" value="X">
                WHERE 
                    ib.type = <cfqueryparam cfsqltype="cf_sql_varchar" value="N">
                AND
                    ibc.studentID IS NULL                            
                GROUP BY 
                    s.studentID
                ORDER BY 
                    u.businessname, 
                    s.firstname
        </cfquery>
    
		<cfreturn qGetStudentsToCancel>
	</cffunction>


	<!--- Extend insurance based on program extension --->
	<cffunction name="getStudentsToExtend" access="public" returntype="query" output="false" hint="Extend insurance based on program extension">
        <cfargument name="programID" hint="List of program IDs. Required.">

        <cfquery 
        	name="qGetStudentsToExtend" 
            datasource="#APPLICATION.dsn#">
                SELECT DISTINCT
                    s.studentID, 
                    s.firstname, 
                    s.familyLastName, 
                    s.dob, 
                    u.businessName,
                    DATE_ADD(ibEndDate.endDate, INTERVAL 1 DAY) AS extensionStartDate,
                    p.endDate AS extensionEndDate
                FROM
                    smg_students s 
                INNER JOIN 
                    smg_insurance_batch ibEndDate ON ibEndDate.studentID = s.studentID 
                        AND 
                            ibEndDate.ID = ( SELECT MAX(ID) FROM smg_insurance_batch WHERE studentID = s.studentID AND type != <cfqueryparam cfsqltype="cf_sql_varchar" value="R"> )
                INNER JOIN 
                    smg_users u ON u.userid = s.intrep 
                INNER JOIN  
                    smg_programs p ON p.programID = s.programID
                WHERE 
                    s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                AND 
                    s.programID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes">)
                <cfif CLIENT.companyID EQ 5>
                    AND          
                        s.companyid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.listISE#" list="yes"> )
                <cfelse>
                    AND          
                        s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#"> 
                </cfif>
                AND
                	 DATE_ADD(ibEndDate.endDate, INTERVAL 1 DAY) < p.endDate 
                GROUP BY 
                    s.studentID
                ORDER BY 
                    u.businessname, 
                    s.familyLastName,
                    s.firstName
        </cfquery>
    
		<cfreturn qGetStudentsToExtend>
	</cffunction>


	<!--- Extensions Based on Flight Departure --->
	<cffunction name="getStudentsToExtendFlight" access="public" returntype="query" output="false" hint="Extend insurance based on flight departure">
        <cfargument name="programID" hint="List of program IDs. Required.">

        <cfquery 
        	name="qGetStudentsToExtendFlight" 
            datasource="#APPLICATION.dsn#">
                SELECT DISTINCT
                    s.studentID, 
                    s.firstname, 
                    s.familyLastName, 
                    s.dob,          
					u.businessName,
                    ibEndDate.endDate AS extensionStartDate,                    
                    DATE_ADD( fi.dep_date, INTERVAL 1 DAY) AS extensionEndDate,
                    DATEDIFF( DATE_ADD( fi.dep_date, INTERVAL 1 DAY), ibEndDate.endDate ) AS extensionDays
                FROM
                    smg_students s 
                INNER JOIN
                    smg_flight_info fi ON fi.studentID = s.studentID 
					AND 
                         fi.dep_date = ( SELECT MAX(dep_date) FROM smg_flight_info WHERE studentID = s.studentID AND fi.flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="departure"> ) 
                INNER JOIN 
                    smg_users u ON u.userid = s.intrep 
                INNER JOIN 
                    smg_insurance_batch ibEndDate ON ibEndDate.studentID = s.studentID 
                        AND 
                            ibEndDate.ID = ( SELECT MAX(ID) FROM smg_insurance_batch WHERE studentID = s.studentID )                            
                WHERE 
                    s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                AND 
                    s.programID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes">)
				<cfif CLIENT.companyID EQ 5>
                    AND          
                        s.companyid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.listISE#" list="yes"> )
                <cfelse>
                    AND          
                        s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#"> 
                </cfif>
                AND 
                	DATE_ADD( fi.dep_date, INTERVAL 1 DAY) > ibEndDate.endDate
                GROUP BY 
                    s.studentID
                ORDER BY 
                    u.businessname, 
                    s.familyLastName,
                    s.firstName
        </cfquery>
    
		<cfreturn qGetStudentsToExtendFlight>
	</cffunction>


	<!--- Insert History --->
	<cffunction name="insertInsuranceHistory" access="public" returntype="void" output="false" hint="Sets student insurance date">
        <cfargument name="studentID" type="numeric" hint="studentID is required">
        <cfargument name="type" hint="type is required N = New | R = Return/Adjustment | X = Cancelation | EX = Extension Program">
        <cfargument name="startDate" hint="startDate is required">
        <cfargument name="endDate" hint="endDate is required">
        <cfargument name="fileName" hint="fileName is required">
              
        <cfquery 
        	datasource="#APPLICATION.dsn#">
                INSERT INTO 
                    smg_insurance_batch
                (
                    studentID,
                    date,
                    type,
                    startDate,
                    endDate,
                    file
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">, 
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(now())#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.type#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.startDate#">, 
                    <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.endDate#">, 
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.fileName#">
                )	
        </cfquery>
           
	</cffunction>

</cfcomponent>