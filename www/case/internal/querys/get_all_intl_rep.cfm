<cfquery name="get_all_intl_rep" datasource="caseusa">
	SELECT	*
	FROM smg_users
	WHERE USERTYPE = '8'
	ORDER BY businessname
</cfquery>
