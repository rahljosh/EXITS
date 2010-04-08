<cftransaction action="BEGIN" isolation="SERIALIZABLE">
<cfquery name="insert_religion" datasource="caseusa">
update smg_students
set smoke = "#form.smoke#",
	animal_allergies = "#form.animal_allergies#",
	med_allergies = "#form.med_allergies#",
	other_allergies = "#form.other_allergies#",
	chores = "#form.chores#",
	chores_list = "#form.chores_list#",
	<cfif #form.weekday_curfew# is ''>
   	 	weekday_curfew = null, 
	<cfelse> 
		weekday_curfew = #CreateODBCTime(form.weekday_curfew)#,
    </cfif>
	
	<Cfif #form.weekend_curfew# is ''>
		weekend_curfew = null
	<cfelse> 
		weekend_curfew = #CreateODBCTime(form.weekend_curfew)#
	</Cfif>
	
	where studentid = #client.studentid#
</cfquery>
</cftransaction>
<cflocation url="../index.cfm?curdoc=forms/student_app_7" addtoken="no">