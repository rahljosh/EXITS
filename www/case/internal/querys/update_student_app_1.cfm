<cftransaction action="BEGIN" isolation="SERIALIZABLE">
<cfif #form.heightcm# is ''>
<Cfset height = #form.height#>
<cfelse>
<cfset feet = (#form.heightcm# / 30.48)>
<cfset inches = (#RemoveChars(feet, 1,1)# * 30.48 / 2.54)>
<cfset height = #Left(feet,1)# & "'" & #Round(inches)# & "''" >
</cfif>
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
		<cfif IsDefined('form.sex')>sex = '#form.sex#',</cfif> 
		countryresident= '#form.Countryresidence#',
		countrycitizen= '#form.countrycitizinship#',
		passportnumber= '#form.passport#',
		dob= #CreateODBCDate(form.dob)#,
		citybirth='#form.citybirth#',
		countrybirth='#form.countrybirth#',
		haircolor = '#form.haircolor#',
		eyecolor= '#form.eyecolor#',
        height = '#height#',
		weight = '#form.weight#'
	where studentid = #client.studentid#
						
</cfquery>

<cfoutput>
<cflocation url="../index.cfm?curdoc=forms/student_App_2" addtoken="No">
</cfoutput>
</body>
</html>
