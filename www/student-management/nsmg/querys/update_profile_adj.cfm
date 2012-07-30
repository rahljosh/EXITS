<cftransaction action='BEGIN' isolation='SERIALIZABLE'>

<cfquery name='insert_interests' datasource='#APPLICATION.DSN#'>

	UPDATE
    	smg_students
	SET
    	interests = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.interest#">,
    	band = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.band#">,
		orchestra = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.orchestra#">,
		comp_sports = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.comp_sports#">,
		interests_other = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.specific_interests#">,
		grades = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.grades#">,
		yearsenglish = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.yearsenglish#">,
		<cfif client.usertype LTE '4'>
			estgpa = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.estgpa#">,
			slep_score = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.slep_score#">,
		</cfif>
		animal_allergies = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.animal_allergies#">,
		med_allergies = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.med_allergies#">,
		other_allergies = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.other_allergies#">
	WHERE
    	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.studentid#">
	LIMIT 1
</cfquery>
</cftransaction>

<cflocation url='../forms/profile_adjustments.cfm' addtoken='No'>