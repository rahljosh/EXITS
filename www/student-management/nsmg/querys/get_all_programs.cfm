<cfquery name="get_all_programs" datasource="MYSQL">
    SELECT	
    	*
    FROM 	
    	smg_programs p
	INNER JOIN 
    	smg_companies c ON p.companyid = c.companyid
	LEFT JOIN 
    	smg_program_type t ON type = t.programtypeid
    WHERE 
        p.companyid IN (<cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,5,10,12,13" list="yes">)
    AND	
    	p.is_deleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
	ORDER BY 
    	p.startdate DESC, 
        p.programname
</cfquery>