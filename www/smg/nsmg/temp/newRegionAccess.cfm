<cfquery name="qGetOfficeUsers" datasource="#APPLICATION.dsn#">
    SELECT 
    	u.userid,
        u.firstName, 
        u.lastName 
    FROM
    	user_access_rights uar
    INNER JOIN
    	smg_users u on u.userid = uar.userid
    WHERE 
    	uar.usertype <= <cfqueryparam cfsqltype="cf_sql_integer" value="4">
    AND
    	u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
    AND
    	uar.companyid in ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,12" list="yes"> )
    GROUP BY
    	u.userid
</cfquery>

<cfquery name="qGetManagers" datasource="#APPLICATION.dsn#">
    SELECT 
    	u.userid,
        u.firstName, 
        u.lastName 
    FROM
    	user_access_rights uar
    INNER JOIN
    	smg_users u on u.userid = uar.userid
    WHERE 
    	uar.usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="5">
    AND
    	u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
    AND
    	uar.companyid in ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,12" list="yes"> )
    GROUP BY
    	u.userid
</cfquery>

<cfoutput>

    <cfloop query="qGetOfficeUsers">
        
        <cfquery datasource="#APPLICATION.dsn#">
            INSERT INTO
                user_access_rights 
           (
                userID,
                companyID,
                regionID,
                userType
           )
           VALUES
           (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetOfficeUsers.userID#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="12">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="1444">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="3">
           )
        </cfquery>
        
        #qGetOfficeUsers.userID# - #qGetOfficeUsers.firstName# #qGetOfficeUsers.lastName# <br>
        
    </cfloop>
    
    --- Done Office Users ---  <br><br>


    <cfloop query="qGetManagers">
        
        <cfquery datasource="#APPLICATION.dsn#">
            INSERT INTO
                user_access_rights 
           (
                userID,
                companyID,
                regionID,
                userType
           )
           VALUES
           (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetManagers.userID#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="12">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="1444">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="9">
           )
        </cfquery>
        
        #qGetManagers.userID# - #qGetManagers.firstName# #qGetManagers.lastName# <br>     
        
    </cfloop>

</cfoutput>