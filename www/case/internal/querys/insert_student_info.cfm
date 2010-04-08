<cfquery name="check_new_student" datasource="caseusa">
SELECT s.studentid, s.firstname, s.familylastname, s.dob,
	c.companyshort
FROM smg_students s
INNER JOIN smg_companies c ON c.companyid = s.companyid
WHERE s.firstname = '#form.firstname#' 
	AND	s.familylastname = '#form.familyname#'
	AND s.dob = '#DateFormat(form.dob, 'yyyy/mm/dd')#'
	AND s.sex = '#form.sex#'
</cfquery>

<cfif check_new_student.recordcount NEQ 0>
	<br>
	<table width="540" align="center">
	<tr><td align="center" colspan="2"><h3>Sorry, but this student has been entered in the database as follow:</h3><br></td></tr>
	<cfoutput query="check_new_student">
	<tr>
		<td align="center"><img src="uploadedfiles/web-students/#studentid#.jpg" width=133></td>
		<td valign="top"><a href="?curdoc=student_info&studentid=#check_new_student.studentid#">#firstname# #familylastname# (#studentid#) - #companyshort#</a><br><br></td>
	</tr>
	</cfoutput>
	<tr><td align="center" colspan="2"><input type="image" value="back" src="pics/back.gif" onClick="javascript:history.back()"></td></tr>
	</table>
	<cfabort>
</cfif>
	
	<cfif form.heightcm is 0 and form.heightin is 0>
	<cfset height = #form.heightin#>
	<cfelse>
		<cfif form.heightin is 0>
			<cfset feet = (#form.heightcm# / 30.48)>
			<cfset inches = (#RemoveChars(feet, 1,1)# * 30.48 / 2.54)>
			<cfset height = #Left(feet,1)# & "'" & #Round(inches)# & "''" >
		<Cfelse>
			<cfset height = #form.heightin#>
		</cfif>
	</cfif>
	
	<cftransaction action="begin" isolation="SERIALIZABLE">
		<cfquery name="insert_student_app_1" datasource="caseusa">
			insert into smg_students(uniqueid, familylastname, firstname, middlename, address, address2, city, country, zip, phone,
									 fax, email, sex,countryresident, countrycitizen, passportnumber, dateapplication, entered_by, dob, citybirth,countrybirth, eyecolor, haircolor, height, weight, companyid)
				values ('#form.uniqueid#', '#form.familyname#',  '#form.firstname#', '#form.middlename#',	'#form.address#', '#form.address2#', '#form.city#', '#form.country#', '#form.zip#', '#form.phone#', 
					'#form.fax#','#form.email#', '#form.sex#',  '#form.Countryresidence#', '#form.countrycitizinship#', '#form.passport#', #now()#, '#client.userid#', #CreateODBCDate(form.dob)#, '#form.citybirth#', '#form.countrybirth#','#form.eyecolor#', '#form.haircolor#', '#height#', '#Round(form.weight)#', #client.companyid#)				
		</cfquery>
		<cfquery name="get_student_id" datasource="caseusa">
		Select Max(studentid) as studentid
		from smg_students
		</cfquery> 
		<cfset client.studentid = #get_Student_id.studentid#>
	</cftransaction>
	<cfoutput>
	
	<cflocation url="index.cfm?curdoc=forms/student_app_2" addtoken="No">
	</cfoutput>
	</body>
	</html>