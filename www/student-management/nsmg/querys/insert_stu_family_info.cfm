<cftransaction action="BEGIN" isolation="SERIALIZABLE">

<cfquery name="insert_student_app_2" datasource="MySQL">
update smg_students
set fathersname= '#form.fathersname#',
	fatheraddress='#form.fathersaddress#',
	fatheraddress2='#form.fatheraddress2#',
	fathercity='#form.fathercity#',
	fathercountry='#form.fathercountry#',
	fatherzip = '#form.fatherzip#',
	fatherbirth= '#form.fatherdob#',
	fathercompany='#form.fatherbusiness#',
	fatherworkphone='#form.fatherbusinessphone#',
	fatherworkposition='#form.fatherocc#',
	fatheraddress='#form.fathersaddress#',
	fatheraddress2= '#form.fatheraddress2#',
	fathercity = '#form.fathercity#',
	fathercountry = '#form.fathercountry#',
	fatherzip='#form.fatherzip#',
	fatherenglish='#form.fatherenglish#',
	mothersname='#form.mothersname#',
	motherbirth='#form.motherdob#',
	mothercompany='#form.mothercompany#',
	motherworkphone='#form.motherbusinessphone#',
	motherworkposition='#form.motherocc#',
	motheraddress='#form.mothersaddress#',
	motheraddress2='#form.motheraddress2#',
	mothercity='#form.mothercity#',
	mothercountry='#form.mothercountry#',
	motherzip = '#form.motherzip#',
	motherenglish = '#form.motherenglish#',
	emergency_phone = '#form.emergency_phone#',
	emergency_name = '#form.emergency_name#',
	emergency_address = '#form.emergency_address#',
	emergency_country = '#form.emergency_country#'
where studentid  = #client.studentid#		
</cfquery>
</cftransaction>
<cfoutput>

<cflocation url="../index.cfm?curdoc=forms/student_app_3" addtoken="No">
</cfoutput>