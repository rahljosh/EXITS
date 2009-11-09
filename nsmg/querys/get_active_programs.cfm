<cfquery name="get_program" datasource="MYSQL">
	SELECT	*
	FROM smg_programs p
	LEFT JOIN smg_program_type ON type = programtypeid
	INNER JOIN smg_companies c ON p.companyid = c.companyid
	WHERE enddate > '#DateFormat(now(), 'yyyy-mm-dd')#'
	<cfif #client.companyid# is 5><cfelse>
		AND p.companyid = #client.companyid#
	</cfif>
	ORDER BY companyshort, startdate DESC, programname
</cfquery>