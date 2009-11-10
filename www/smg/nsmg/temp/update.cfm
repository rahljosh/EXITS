    <cfquery name="getUsers" datasource="#application.dsn#">
        SELECT 
        	userID, userType
        FROM 
        	smg_users
        WHERE 
        	usertype = 8 
        OR
        	usertype = 11
    </cfquery>
    
    <cfloop query="getUsers">
    
        <cfquery name="update" datasource="#application.dsn#">
            INSERT INTO user_access_rights
            	(userID, companyID, regionID, usertype, default_access)
            VALUES
            	(
                <cfqueryparam cfsqltype="cf_sql_integer" value="#getUsers.userID#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="5">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="0">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#getUsers.userType#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                )
			
        </cfquery>
    
    </cfloop>
    
    Complete