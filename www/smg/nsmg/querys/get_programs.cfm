<cfquery name="get_program" datasource="MYSQL">
	SELECT	
    	*
	FROM 	
    	smg_programs p
	INNER JOIN 
    	smg_companies c ON p.companyid = c.companyid
	LEFT JOIN 
    	smg_program_type t ON type = t.programtypeid
	WHERE
		p.active = 1
	AND        
        p.companyid IN (<cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,5,10" list="yes">)
    AND	
    	p.is_deleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
	<!----
	<cfif NOT IsDefined('url.all')>AND ADDDATE(p.enddate, INTERVAL 3 MONTH ) > #now()#</cfif>
	---->
	ORDER BY 
    	p.startdate DESC, 
        p.programname
</cfquery>