<cfquery name="get_program" datasource="MYSQL">
	SELECT	*
	FROM smg_programs p
	LEFT JOIN smg_program_type ON type = programtypeid
	INNER JOIN smg_companies c ON p.companyid = c.companyid
	WHERE enddate > '#DateFormat(now(), 'yyyy-mm-dd')#'
        p.is_deleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
    AND 
        p.companyid IN (<cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,5,10" list="yes">)
	ORDER BY companyshort, startdate DESC, programname
</cfquery>