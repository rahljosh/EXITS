<cfquery name="get_program" datasource="MYSQL">
	SELECT	*
	FROM 	smg_programs p
	LEFT JOIN smg_program_type ON type = programtypeid
	INNER JOIN smg_companies c ON p.companyid = c.companyid
	WHERE 1 = 1
	<cfif client.companyid NEQ 5>
		AND p.companyid = #client.companyid#
	<cfelse>
		AND p.companyid <= 5
	</cfif>
	and p.active = 1
	<!----
	<cfif NOT IsDefined('url.all')>AND ADDDATE(p.enddate, INTERVAL 3 MONTH ) > #now()#</cfif>
	---->
	ORDER BY companyshort, startdate DESC, programname
</cfquery>