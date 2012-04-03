<cfquery name="qGetUserStates" datasource="mySQL">
    SELECT 
        u.userID,
        sl.state
    FROM 
    	smg_users2 u
    INNER JOIN
    	smg_states sl ON sl.ID = u.state 
</cfquery>

<cfloop query="qGetUserStates">

    <cfquery datasource="mySQL">
        UPDATE
        	smg_users
        SET
        	state = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetUserStates.state#">
        WHERE
        	userID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetUserStates.userID#">
    </cfquery>

</cfloop>

<cfoutput>

<p>#qGetUserStates.recordCount# states updated</p>

</cfoutput>