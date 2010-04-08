<cftransaction action="BEGIN" isolation="SERIALIZABLE">
<!----<cfif not isdefined('form.assignedrep')
	<Cfset form.assignedrep = 0 >
</cfif>---->
<cfquery name="update_student_app_1" datasource="caseusa">
update smg_students
	set familylastname= '#form.familyname#',
	    firstname = '#form.firstname#',
		middlename= '#form.middlename#',
		address= '#form.address#',
		address2= '#form.address2#',
		city= '#form.city#',
		country= '#form.country#',
		zip= '#form.zip#',
		phone= '#form.phone#',
		fax= '#form.fax#',
		email= '#form.email#',
		sex= '#form.sex#',
		countryresident= '#form.Countryresidence#',
		countrycitizen= '#form.countrycitizinship#',
		passportnumber= '#form.passport#',
		dateapplication=  #now()#,
		dob= '#form.dob#',
		citybirth='#form.citybirth#',
		countrybirth='#form.countrybirth#',
		regionassigned = '#form.assignedrep#'
	where studentid = #client.studentid#
						
</cfquery>

<cfoutput>
<cflocation url="index.cfm?curdoc=forms/student_app_2.cfm" addtoken="No">
</cfoutput>
</body>
</html>
