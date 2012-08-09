<cfquery name="get_candidate_unqid" datasource="mysql">
	SELECT 
    	ec.*
	FROM 
    	extra_candidates ec
	WHERE 
    	ec.uniqueid = <cfqueryparam cfsqltype="cf_sql_char" value="#url.uniqueid#">
</cfquery>
