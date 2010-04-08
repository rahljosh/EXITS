<cftransaction action='BEGIN' isolation='SERIALIZABLE'>
<cfquery name='insert_interests' datasource='caseusa'>
Update smg_students
set interests = '#form.interest#',
    band = '#form.band#',
	orchestra = '#form.orchestra#',
	comp_sports = '#form.comp_sports#',
	interests_other = '#form.specific_interests#'
where studentid = #client.studentid#

</cfquery>
</cftransaction>
 <cflocation url='../index.cfm?curdoc=forms/student_app_5' addtoken='No'>