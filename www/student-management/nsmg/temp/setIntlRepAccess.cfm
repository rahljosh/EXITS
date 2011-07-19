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

	<cfscript>
		vSetCompanyID = 0;
		
		// PHP
		// vSetCompanyID = 6; 
		
		// CASE
		// vSetCompanyID = 10; 

		// CANADA
		// vSetCompanyID = 13; 

		// ESI
		// vSetCompanyID = 14; 
	</cfscript>

	<!--- Intl. Reps ---->
    <cfquery name="qGetIntlReps" datasource="mysql">
        SELECT DISTINCT
            u.userID,
            u.businessName,
            uar.userType      
        FROM
            smg_users u 
        INNER JOIN
            user_access_rights uar ON uar.userID = u.userID 
                AND 
                    uar.userType = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
                AND
                    uar.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,5,10,12" list="yes"> )
        WHERE
            u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND
            u.userID NOT IN ( SELECT userID FROM user_access_rights WHERE companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#vSetCompanyID#"> )
        ORDER BY
            u.businessName        
    </cfquery>

	<!--- Branches ---->
    <cfquery name="qGetBranches" datasource="mysql">
        SELECT DISTINCT
            u.userID,
            u.businessName,
            uar.userType            
        FROM
            smg_users u 
        INNER JOIN
            user_access_rights uar ON uar.userID = u.userID 
                AND 
                    uar.userType = <cfqueryparam cfsqltype="cf_sql_integer" value="11">
                AND
                    uar.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,5,10,12" list="yes"> )
        WHERE
            u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND
            u.userID NOT IN ( SELECT userID FROM user_access_rights WHERE companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#vSetCompanyID#"> )
        ORDER BY
            u.businessName        
    </cfquery>

</cfsilent>

<cfif VAL(vSetCompanyID)>

	<!--- Set Intl. Rep Access --->
    <cfloop query="qGetIntlReps">
    
        <cfquery datasource="mysql">
            INSERT INTO 
                user_access_rights
                (
                    userID,
                    companyID,
                    userType
                )
            VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetIntlReps.userID#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#vSetCompanyID#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetIntlReps.userType#">
                )
        </cfquery>
    
    </cfloop>
    
    
    <!--- Set Branch Access --->
    <cfloop query="qGetBranches">
    
        <cfquery datasource="mysql">
            INSERT INTO 
                user_access_rights
                (
                    userID,
                    companyID,
                    userType
                )
            VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetBranches.userID#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#vSetCompanyID#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetBranches.userType#">
                )
        </cfquery>
    
    </cfloop>

</cfif>

<cfoutput>

	<p>Company: #vSetCompanyID#</p>

	<p>Total of Intl. Reps: #qGetIntlReps.recordCount#</p>

	<p>Total of Branches: #qGetBranches.recordCount#</p>
	
    Done!    
</cfoutput>

 