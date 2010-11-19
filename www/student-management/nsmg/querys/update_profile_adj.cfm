<cftransaction action='BEGIN' isolation='SERIALIZABLE'>

<cfquery name='insert_interests' datasource='MySQL'>
UPDATE smg_students
SET interests = '#form.interest#',
    band = '#form.band#',
	orchestra = '#form.orchestra#',
	comp_sports = '#form.comp_sports#',
	interests_other = '#form.specific_interests#',
	grades='#form.grades#',
	yearsenglish='#form.yearsenglish#',
	<cfif client.usertype LTE '4'>
	estgpa='#form.estgpa#',
	slep_score='#form.slep_score#',
	</cfif>
	animal_allergies = "#form.animal_allergies#",
	med_allergies = "#form.med_allergies#",
	other_allergies = "#form.other_allergies#"
WHERE studentid = #client.studentid#
LIMIT 1
</cfquery>
</cftransaction>

<cflocation url='../forms/profile_adjustments.cfm' addtoken='No'>