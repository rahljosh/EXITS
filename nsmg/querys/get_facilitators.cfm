<cfquery name="get_facilitators" datasource="MySql">
	SELECT 	u.userid, u.firstname, u.lastname
	FROM smg_users u
	LEFT JOIN smg_regions r ON r.regionfacilitator = u.userid
	WHERE 	subofregion = '0'
			<cfif client.companyid NEQ 5>AND r.company = '#client.companyid#'</cfif>
	GROUP BY u.userid
	ORDER BY u.firstname
</cfquery>