<cfquery datasource="MySQL">
    UPDATE 
    	smg_students 
    SET 
    	<cfif client.usertype gte 5>
    	host_fam_approved = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.usertype#">,
        </cfif>
        date_host_fam_approved = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#">
    WHERE 
    	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.studentid#">
</cfquery>

<cfscript>
	// Assign Pre-AYP English Camp based on host family state
	APPLICATION.CFC.STUDENT.assignEnglishCamp(studentID=CLIENT.studentID);
</cfscript>

<cflocation url = "../forms/place_menu.cfm">