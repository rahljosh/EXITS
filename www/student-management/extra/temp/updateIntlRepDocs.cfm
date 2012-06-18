<title>Update Docs</title>

<cfsetting requestTimeOut = "9999">

<cfquery datasource="MySql">
    UPDATE
        smg_users
    SET
        watDocBankruptcyDisclosureExpiration = <cfqueryparam cfsqltype="cf_sql_date" value="#CreateDate(YEAR(NOW()),12,31)#">
    WHERE
        userType = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
    AND
        active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
    AND
        watDocBankruptcyDisclosure = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
</cfquery>

<cfquery datasource="MySql">
    UPDATE
        smg_users
    SET
        watDocNotarizedFinancialStatementExpiration = <cfqueryparam cfsqltype="cf_sql_date" value="#CreateDate(YEAR(NOW()),12,31)#">
    WHERE
        userType = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
    AND
        active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
    AND
        watDocNotarizedFinancialStatement = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
</cfquery>

<cfquery datasource="MySql">
    UPDATE
        smg_users
    SET
        watDocOriginalAdvertisingMaterialExpiration = <cfqueryparam cfsqltype="cf_sql_date" value="#CreateDate(YEAR(NOW()),12,31)#">
    WHERE
        userType = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
    AND
        active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
    AND
        watDocOriginalAdvertisingMaterial = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
</cfquery>

<cfquery datasource="MySql">
    UPDATE
        smg_users
    SET
        watDocEnglishAdvertisingMaterialExpiration = <cfqueryparam cfsqltype="cf_sql_date" value="#CreateDate(YEAR(NOW()),12,31)#">
    WHERE
        userType = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
    AND
        active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
    AND
        watDocEnglishAdvertisingMaterial = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
</cfquery>