<cfquery name="get_student_info" datasource="#APPLICATION.DSN#">
	SELECT 
    	*
	FROM 
    	smg_students
	WHERE 
		<cfif isDefined('url.uniqid')>
        uniqueID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.uniqid#">
        <cfelse>
    	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.studentid)#">
        </cfif>
</cfquery>