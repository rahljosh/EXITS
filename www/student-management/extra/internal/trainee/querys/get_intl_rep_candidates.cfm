<cfquery name="get_intl_rep_candidates" datasource="MYSQL">
	SELECT	intrep, businessname, candidateid
	FROM extra_candidates
	INNER JOIN smg_users ON smg_users.userid = extra_candidates.intrep
	<!---<cfif #client.companyid# is '5'><cfelse>--->
		and extra_candidates.companyid = '#client.companyid#'
	<!---</cfif>--->
	GROUP BY intrep
	ORDER BY businessname
</cfquery>


<!--- from nsmg ----
<cfquery name="get_intl_rep" datasource="MYSQL">
	SELECT	intrep, businessname, userid
	FROM smg_students 
	INNER JOIN smg_users 	ON smg_students.intrep = smg_users.userid 
	<cfif #session.companyid# is '5'><cfelse>
		and smg_students.companyid = '#session.companyid#'
	</cfif>
	GROUP BY intrep
	ORDER BY businessname
</cfquery>
------>