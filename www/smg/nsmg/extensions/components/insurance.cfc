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
        
        <cfquery name="qGetInsurancePolicies" datasource="#APPLICATION.dsn#">
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

	
	<!--- Get Global Secutive History Only
    <cffunction name="getInsuranceHistory" access="public" returntype="query" output="false" hint="Returns insurance history by date">
        <cfargument name="companyID" type="numeric" hint="CompanyID is required">
              
        <cfquery name="qGetInsuranceHistory" datasource="#APPLICATION.dsn#">>
            SELECT 
                s.insurance, 
                COUNT(s.studentID) AS total
            FROM 
                smg_students s
            WHERE 
                s.insurance IS NOT <cfqueryparam cfsqltype="cf_sql_date" null="yes">
            
            <cfif VAL(ARGUMENTS.companyID) AND ARGUMENTS.companyID LTE 4>
                AND
                    s.companyID <= <cfqueryparam cfsqltype="cf_sql_integer" value="4">
            <cfelseif VAL(ARGUMENTS.companyID)>
                AND
                    s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyID#">    
            </cfif>
                
            GROUP BY  
                s.insurance 
            ORDER BY  
                s.insurance 
        </cfquery>
		   
		<cfreturn qGetInsuranceHistory>
	</cffunction>
	--->


	<cffunction name="getStudentsToInsure" access="public" returntype="query" output="false" hint="Returns students with flight info that needs to be insure">
        <cfargument name="programID" hint="List of program IDs. Required.">
        <cfargument name="PolicyID" hint="Policy ID required">

        <cfquery name="qGetStudentsToInsure" datasource="#APPLICATION.dsn#">
            SELECT DISTINCT
                s.studentID, 
                s.firstname, 
                s.familyLastName, 
                s.dob, 
                MIN(fi.dep_date) as dep_date,            
                it.type,  
                ic.policycode, 
                p.startDate,
                p.endDate,
                p.insurance_startdate, 
                p.insurance_enddate
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
                            s.companyid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,12" list="yes"> )
                    <cfelse>
                        AND          
                            s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#"> 
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

        <cfquery name="qGetStudentsToInsureNoFlight" datasource="#APPLICATION.dsn#">
            SELECT DISTINCT
                s.studentID, 
                s.firstname, 
                s.familyLastName, 
                s.dob, 
                "#ARGUMENTS.startDate#" as dep_date,                
                it.type,  
                ic.policycode, 
                p.startDate,
                p.endDate,
                p.insurance_startdate, 
                p.insurance_enddate
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
                s.firstname        
        </cfquery>
    
		<cfreturn qGetStudentsToInsureNoFlight>
	</cffunction>


	<cffunction name="getStudentsReturnRecords" access="public" returntype="query" output="false" hint="Returns students list with depature flight information">
        <cfargument name="programID" hint="List of program IDs. Required.">
        <cfargument name="PolicyID" hint="Policy ID required">
              
        <cfquery 
        	name="qGetStudentsReturnRecords" 
            datasource="#APPLICATION.dsn#">
                SELECT DISTINCT
                    s.studentID, 
                    s.firstname, 
                    s.familyLastName, 
                    s.dob, 
                    MIN(fi.dep_date) as dep_date,            
                    it.type,  
                    ic.policycode, 
                    p.startDate,
                    p.endDate,
                    p.insurance_startdate, 
                    p.insurance_enddate
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
                                s.companyid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,12" list="yes"> )
                        <cfelse>
                            AND          
                                s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#"> 
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
                            ib.type = <cfqueryparam cfsqltype="cf_sql_varchar" value="R">
                WHERE 
                    fi.flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="departure">
                AND
                    ib.studentID IS NULL
                    
                GROUP BY 
                    fi.studentID
                ORDER BY 
                    u.businessname, 
                    s.firstname
            </cfquery>
        
        <cfreturn qGetStudentsReturnRecords> 
           
	</cffunction>


	<cffunction name="insertInsuranceHistory" access="public" returntype="void" output="false" hint="Sets student insurance date">
        <cfargument name="studentID" type="numeric" hint="studentID is required">
        <cfargument name="type" hint="type is required">
        <cfargument name="startDate" hint="startDate is required">
        <cfargument name="endDate" hint="endDate is required">
        <cfargument name="fileName" hint="fileName is required">
              
        <cfquery datasource="#APPLICATION.dsn#">
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