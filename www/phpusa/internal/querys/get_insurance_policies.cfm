<cfparam name="FORM.provider" default="">

<cfquery name="get_insurance_policies" datasource="MySql">
    SELECT 
        insuTypeID,
        type,
        shortType,
        provider,
        ayp5,
        ayp10,
        ayp12,
        active 
    FROM 
        smg_insurance_type 
    WHERE
        active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
	<cfif LEN(FORM.provider)>
		AND
        	provider = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.provider#">
	</cfif>		
</cfquery>
