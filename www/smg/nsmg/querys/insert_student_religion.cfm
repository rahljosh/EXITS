<cftransaction action="BEGIN" isolation="SERIALIZABLE">
<cfquery name="insert_religion" datasource="MySQL">
update smg_students
set religious_participation = "#form.church_activity#",
	religiousaffiliation = #form.religious_affiliation#,
	churchfam = "#form.churchfam#",
	churchgroup = "#form.churchgroup#"
where studentid = #client.studentid#
</cfquery>
</cftransaction>
<cflocation url="../index.cfm?curdoc=forms/student_app_6" addtoken="no">