<cfquery datasource="MySQL">
	UPDATE 
    	smg_students
	SET 
        convalidation_needed = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.convalidation_needed#">,
        grades = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.grades#">,
        <cfif IsDefined('FORM.app_completed_school')>
        	app_completed_school = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.app_completed_school#">,
		</cfif>			
        estgpa = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.estgpa#">,
        yearsenglish = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.yearsenglish#">,
        slep_score = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.slep_score#">
	WHERE 
    	studentid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.studentid#">	
</cfquery>

<cflocation url="../index.cfm?curdoc=student_info&studentid=#FORM.studentid#" addtoken="No">
