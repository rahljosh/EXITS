<cfquery name="get_all_programs" datasource="MYSQL">
SELECT	*
FROM 	smg_programs p
LEFT OUTER JOIN smg_program_type ON type = programtypeid
INNER JOIN smg_companies c ON p.companyid = c.companyid
WHERE 1 = 1
<cfif #client.companyid# is 5><cfelse>
	AND p.companyid = #client.companyid#
</cfif>
ORDER BY companyshort, programname
</cfquery>