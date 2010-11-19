<!--- Kill Extra Output --->
<cfsilent>

	<!--- Purge smg_user_tracking - Records over 7 days old --->
    <cfquery datasource="MySql">
        DELETE FROM
            smg_user_tracking
        WHERE
        	time_viewed <= <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d', -7, now())#"> 
    </cfquery>

</cfsilent>

<h1>Purge Tables</h1>

<p>smg_user_tracking updated</p>