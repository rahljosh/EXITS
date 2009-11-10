<cfquery name="get_intl_rep" datasource="MYSQL">
	SELECT	intrep, businessname, userid
	FROM smg_students 
	INNER JOIN smg_users 	ON smg_students.intrep = smg_users.userid 
	<cfif #client.companyid# is '5'><cfelse>
		and smg_students.companyid = '#client.companyid#'
	</cfif>
	GROUP BY intrep
	ORDER BY businessname
</cfquery>

