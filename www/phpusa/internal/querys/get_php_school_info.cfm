<cfquery name="qGetPHPSchools" datasource="MySql">
	SELECT
    	*
   	FROM
    	php_schools
  	WHERE
    	active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
</cfquery>