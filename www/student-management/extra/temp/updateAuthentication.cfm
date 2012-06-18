<title>Update Authentication</title>

<cfsetting requestTimeOut = "9999">

<cfquery name="qGetAllHostCompanies" datasource="MySql">
	SELECT
    	*
   	FROM
    	extra_hostCompany
</cfquery>

<cfoutput query="qGetAllHostCompanies">

	<cfset auth = qGetAllHostCompanies.authenticationType>
    
	<cfif auth NEQ "">
    	<cfquery datasource="MySql">
        	UPDATE
            	extra_hostCompany
           	<cfif auth EQ "Secretary of State website">
                SET
                    authentication_secretaryOfState = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
           	<cfelseif auth EQ "Google Earth">
            	SET
                	authentication_googleEarth = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
           	<cfelseif auth EQ "US Department of Labor">
            	SET
                	authentication_departmentOfLabor = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
          	<cfelse>
            	SET
                	authentication_departmentOfLabor = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
            </cfif>
            WHERE
            	hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetAllHostCompanies.hostCompanyID#">
        </cfquery>
    </cfif>
	
</cfoutput>

<cfoutput>
	UPDATE COMPLETE
</cfoutput>