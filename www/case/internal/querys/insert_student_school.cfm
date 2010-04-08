<cftransaction action="BEGIN" isolation="SERIALIZABLE">

<cfquery name="insert_student_school" datasource="caseusa">
update smg_students
set convalidation_needed= '#form.convalidation_needed#',
	grades='#form.grades#',
	<cfif IsDefined('form.app_completed_school')>app_completed_school = '#form.app_completed_school#',</cfif>			
	estgpa='#form.estgpa#',
	yearsenglish='#form.yearsenglish#',
	slep_score='#form.slep_score#'
	where studentid  = #client.studentid#		
</cfquery>

<cflocation url="../index.cfm?curdoc=forms/student_app_8" addtoken="No">

</body>
</html>
