<!--- ------------------------------------------------------------------------- ----
	
	File:		ESISetAccess.cfm
	Author:		Marcus Melo
	Date:		February 3, 2011
	Desc:		
	
	Updated: 	Set access to Active Intl. Reps and Branches to Exchange Service
				Information site es.exitsapplication.com

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

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
            u.userID NOT IN ( SELECT userID FROM user_access_rights WHERE companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="14"> )
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
            u.userID NOT IN ( SELECT userID FROM user_access_rights WHERE companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="14"> )
        ORDER BY
            u.businessName        
    </cfquery>

</cfsilent>


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
                <cfqueryparam cfsqltype="cf_sql_integer" value="14">,
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
                <cfqueryparam cfsqltype="cf_sql_integer" value="14">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetBranches.userType#">
            )
    </cfquery>

</cfloop>


Done! 