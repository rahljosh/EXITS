<!--- Query for Office Users --->
<cfif CLIENT.usertype LTE 4>
	
	<cfquery name="get_regions" datasource="MySQL">
        SELECT 
        	r.regionid, 
            r.regionname, 
            c.companyshort
        FROM 
        	smg_regions r
        INNER JOIN 
        	smg_companies c ON r.company = c.companyid
        WHERE 
            r.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND    
            r.subofregion = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
        <cfif CLIENT.companyid NEQ 5>
            AND r.company = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
        </cfif>
        ORDER BY 
        	c.companyshort, 
            r.regionname
	</cfquery> 

<!--- Query for the field / MANAGERS AND ADVISORS --->
<cfelse>

	<cfquery name="get_regions" datasource="MySQL">
		SELECT 
        	uar.regionid, 
            uar.usertype,
            r.regionname 
		FROM 
        	user_access_rights uar
		INNER JOIN 
        	smg_regions r ON r.regionid = uar.regionid AND r.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
		WHERE 
            uar.userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
        AND 
        	uar.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
        AND 
            uar.usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="5">
		ORDER BY 
        	default_region DESC, 
            regionname
	</cfquery>
    
</cfif>
