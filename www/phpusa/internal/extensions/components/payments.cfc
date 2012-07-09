<cfcomponent>

	<!--- Return the initialized Payments object --->
	<cffunction name="Init" access="public" returntype="payments" output="false" hint="Returns the initialized Payments object">
		
		<cfscript>
			// There is nothing really to initiate, so just return this
			return(this);
		</cfscript>
        
	</cffunction>

	<!--- Function to input new school payment record --->
	<cffunction name="addSchoolPayment" access="remote" returntype="string" hint="returns 1 for success and 0 for failure">
		<cfargument name="studentID" type="numeric" required="yes">
        <cfargument name="schoolID" type="numeric" required="yes">
        <cfargument name="programID" type="numeric" required="yes">
        <cfargument name="amount" type="numeric" required="yes">
        <cfargument name="checkNumber" default="">
        <cfargument name="date" default="">
        
        <cftry>
        
        	<cfquery datasource="#APPLICATION.DSN#">
            	INSERT INTO
                	php_school_payments (
                    	studentID,
                        schoolID,
                        programID,
                        amount,
                        checkNumber,
                       	date,
                        dateCreated
                    )
                    VALUES (
                    	<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.schoolID#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.programID#">,
                        <cfqueryparam cfsqltype="cf_sql_decimal" value="#ARGUMENTS.amount#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.checkNumber#">,
                      	<cfif LEN(ARGUMENTS.date)>
                        	<cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.date#">,
                       	<cfelse>
                        	NULL,
                        </cfif>
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">
                    )
            </cfquery>
        
        	<cfreturn "1">
            
        	<cfcatch type="any">
            	<cfreturn "0">
            </cfcatch>
            
        </cftry>
        
	</cffunction>
    
    <cffunction name="deleteSchoolPayment" access="remote">
    	<cfargument name="ID" type="numeric" required="yes">
        
        <cfquery datasource="#APPLICATION.DSN#">
        	DELETE FROM
            	php_school_payments
           	WHERE
            	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.ID#">
        </cfquery>
    
    </cffunction>
    
</cfcomponent>