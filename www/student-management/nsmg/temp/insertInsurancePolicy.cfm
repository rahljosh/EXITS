<!--- ------------------------------------------------------------------------- ----
	
	File:		setIntlRepAccess.cfm
	Author:		Marcus Melo
	Date:		February 3, 2011
	Desc:		
	
	Updated: 	Set access to ISE Active Intl. Reps and Branches to any of the other
				companies.

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>
	    
    <cfsetting requesttimeout="9999">
    
    <cfscript>
		vPublicHighSchoolList = "1,2,3,4,10,12,13,14";
		
		vPrivateHighSchoolList = 6;
		
		vExtraList = "7,8,9";
	</cfscript>
    
	<!--- Intl. Reps ---->
    <cfquery name="qGetIntlReps" datasource="mysql">
        SELECT
            userID,
            businessName,
            insurance_typeID,
            php_insurance_typeID,
            extra_insurance_typeID
		FROM
        	(    
    
                SELECT
                    u.userID,
                    u.businessName,
                    u.insurance_typeID,
                    u.php_insurance_typeID,
                    u.extra_insurance_typeID
                FROM
                    smg_users u 
                INNER JOIN
                    user_access_rights uar ON uar.userID = u.userID 
                        AND 
                            uar.userType = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
                WHERE
                    u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                
                UNION
                        
                SELECT DISTINCT
                    u.userID,
                    u.businessName,
                    u.insurance_typeID,
                    u.php_insurance_typeID,
                    u.extra_insurance_typeID
                FROM
                    smg_users u 
                WHERE
                    u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                AND	
                    u.userType = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
        	) AS t
        WHERE
        	businessName != <cfqueryparam cfsqltype="cf_sql_varchar" value=""> 
        GROUP BY
        	userID
        ORDER BY
           userID        
    </cfquery>

</cfsilent>

<cfloop query="qGetIntlReps">
	
	<!--- Public High School --->
    <cfif VAL(qGetIntlReps.insurance_typeID)>
        
        <cfloop list="#vPublicHighSchoolList#" index="companyID">
            
            <cfquery datasource="mysql">
                INSERT INTO 
                    smg_users_insurance_jn
                    (
                        companyID,
                        userID,
                        insuranceTypeID,
                        dateCreated
                    )
                VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#companyID#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetIntlReps.userID#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetIntlReps.insurance_typeID#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                    )
            </cfquery>
        
        </cfloop>
        
    </cfif>

	<!---

    <!--- Private High School --->
    <cfif VAL(qGetIntlReps.php_insurance_typeID)>
       
        <cfquery datasource="mysql">
            INSERT INTO 
                smg_users_insurance_jn
                (
                    companyID,
                    userID,
                    insuranceTypeID,
                    dateCreated
                )
            VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#vPrivateHighSchoolList#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetIntlReps.userID#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetIntlReps.php_insurance_typeID#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                )
        </cfquery>
        
	</cfif>
    
    
    <!--- Work Programs --->
    <cfif VAL(qGetIntlReps.extra_insurance_typeID)>
       
        <cfloop list="#vExtraList#" index="companyID">
            
            <cfquery datasource="mysql">
                INSERT INTO 
                    smg_users_insurance_jn
                    (
                        companyID,
                        userID,
                        insuranceTypeID,
                        dateCreated
                    )
                VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#companyID#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetIntlReps.userID#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetIntlReps.extra_insurance_typeID#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                    )
            </cfquery>
        
        </cfloop>
        
	</cfif>
    
	--->
    
</cfloop>

<cfoutput>

	<p>Total of Intl. Reps: #qGetIntlReps.recordCount#</p>
	
    Done!    
</cfoutput>

 