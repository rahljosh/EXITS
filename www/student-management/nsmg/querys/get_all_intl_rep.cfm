<cfquery name="get_all_intl_rep" datasource="MYSQL">
	SELECT	*
	FROM smg_users
	WHERE USERTYPE = '8'
    and businessname != ""
	ORDER BY businessname
</cfquery>
