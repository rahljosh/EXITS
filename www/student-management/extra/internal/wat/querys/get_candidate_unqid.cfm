<cfquery name="get_candidate_unqid" datasource="mysql">
	SELECT 
    	*
	FROM 
    	extra_candidates
	WHERE 
    	uniqueid = <cfqueryparam value="#URL.uniqueid#" cfsqltype="cf_sql_char">
</cfquery>