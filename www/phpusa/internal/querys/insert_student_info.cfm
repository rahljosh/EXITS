
<cfquery name="check_new_student" datasource="mysql">
SELECT s.studentid, s.firstname, s.familylastname, s.dob
FROM smg_students s
WHERE s.firstname = '#form.firstname#' 
	AND	s.familylastname = '#form.familyname#'
	AND s.dob = '#DateFormat(form.dob, 'yyyy/mm/dd')#'
	AND s.sex = '#form.sex#'
</cfquery>

<cfif check_new_student.recordcount is not 0>
	<br>
	<table width="540" align="center">
	<tr><td align="center"><h3>Sorry, but this student has been entered in the database as follow:</h3></td></tr>
	<tr><td align="center"><cfoutput query="check_new_student">
	<a href="?curdoc=forms/student_info&studentid=#check_new_student.studentid#">#firstname# #familylastname# (#studentid#)</cfoutput></a><br><br></td></tr>
	<tr><td align="center"><input type="image" value="back" src="pics/back.gif" onClick="javascript:history.back()"></td></tr>
	</table>
	<cfabort>
</cfif>
	
	<cfif form.heightcm is 0 and form.heightin is 0>
	<cfset height = #form.heightin#>
	<cfelse>
		<cfif form.heightin is 0>
		<cfset feet = (#form.heightcm# / 30.48)>
		<cfset inches = (#RemoveChars(feet, 1,1)# * 30.48 / 2.54)>
		<cfset height = #Left(feet,1)# & "'" & #Round(inches)# & "'" >
		<Cfelse>
		<cfset height = #form.heightin#>
		</cfif>
	</cfif>
	
	<cftransaction action="BEGIN" isolation="SERIALIZABLE">
	
	<cfquery name="insert_student_app_1" datasource="mysql">
	insert into smg_students(uniqueid, familylastname, firstname, middlename, address, address2, city, country, zip, phone,
							 fax, email, sex,countryresident, countrycitizen,passportnumber, dateapplication, dob, citybirth,countrybirth, eyecolor, haircolor, height, weight)
					values ('#form.uniqueid#', '#form.familyname#',  '#form.firstname#', '#form.middlename#',	'#form.address#', '#form.address2#', '#form.city#', '#form.country#', '#form.zip#', '#form.phone#', 
							'#form.fax#','#form.email#', '#form.sex#',  '#form.Countryresidence#', '#form.countrycitizinship#', '#form.passport#', #now()#, #CreateODBCDate(form.dob)#, '#form.citybirth#', '#form.countrybirth#','#form.eyecolor#','#form.haircolor#','#height#','#form.weight#')
							
	</cfquery>
	<cfquery name="get_student_id" datasource="mysql">
	Select Max(studentid) as studentid
	from students
	</cfquery>
	<cfset client.studentid = #get_Student_id.studentid#>
	</cftransaction>
	<cfoutput>
	
	<cflocation url="index.cfm?curdoc=forms/student_app_2" addtoken="No">
	</cfoutput>
	</body>
	</html>