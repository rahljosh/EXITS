		<!----calculated variable from xml---->
		<cfset calcmotherbirth = (#DatePart('yyyy','#now()#')#  - #StudentXMLFile.applications.application[i].page1.family.mother.age.XmlText#) >
		<cfset calcfatherbirth = (#DatePart('yyyy','#now()#')#  - #StudentXMLFile.applications.application[i].page1.family.father.age.XmlText#) >
		<cfquery name="c_birth" datasource="mysql">
		select countryid from 
		smg_countrylist
		where countrycode = '#StudentXMLFile.applications.application[i].page1.student.countryofbirth.XmlText#'
		</cfquery>
		<cfquery name="c_citizen" datasource="mysql">
		select countryid from 
		smg_countrylist
		where countrycode = '#StudentXMLFile.applications.application[i].page1.student.countryofcitizenship.XmlText#'
		</cfquery>
		<cfquery name="c_resident" datasource="mysql">
		select countryid from 
		smg_countrylist
		where countrycode = '#StudentXMLFile.applications.application[i].page1.student.countryoflegalresidence.XmlText#'
		</cfquery>
		<cfquery name="c_address" datasource="mysql">
		select countryid from 
		smg_countrylist
		where countrycode = '#StudentXMLFile.applications.application[i].page1.student.country.XmlText#'
		</cfquery>
		<cfquery name="religious_id" datasource="mysql">
		select religionid
		from smg_religions
		where religionname = '#StudentXMLFile.applications.application[i].page2.religion.religiousaffiliation.XmlText#'
		</cfquery>

	
<!----Actual insert query---->
<cfquery name="update_student" datasource="MySql">
UPDATE smg_students
	SET	familylastname = '#removeAccent(StudentXMLFile.applications.application[i].page1.student.lastname.XmlText)#',
		firstname = '#removeAccent(StudentXMLFile.applications.application[i].page1.student.firstname.XmlText)#',
		middlename = '#removeAccent(StudentXMLFile.applications.application[i].page1.student.middlenames.XmlText)#',
		<!----
		app_indicated_program = <cfif form.app_indicated_program EQ '0'>null,<cfelse>'#form.app_indicated_program#',</cfif>  
		app_additional_program = <cfif form.app_additional_program EQ '0'>null,<cfelse> '#form.app_additional_program#',</cfif>  
		----->
		address = '#removeAccent(StudentXMLFile.applications.application[i].page1.student.street.XmlText)#',
		city = '#StudentXMLFile.applications.application[i].page1.student.city.XmlText#',
		zip = '#StudentXMLFile.applications.application[i].page1.student.zip.XmlText#',
		country = #c_address.countryid#,
		phone = '#StudentXMLFile.applications.application[i].page1.student.phone.XmlText#',
		fax = '#StudentXMLFile.applications.application[i].page1.student.fax.XmlText#',
		email = '#StudentXMLFile.applications.application[i].page1.student.email.XmlText#',
		sex = '#StudentXMLFile.applications.application[i].page1.student.sex.XmlText#',
		dob = #CreateODBCDate(StudentXMLFile.applications.application[i].page1.student.dateofbirth.XmlText)#,
		citybirth = '#removeAccent(StudentXMLFile.applications.application[i].page1.student.placeofbirth.XmlText)#',
		countrybirth = #c_birth.countryid#,
		countrycitizen = #c_citizen.countryid#,
		countryresident = #c_resident.countryid#,
		<cfif religious_id.religionid is not ''>
		religiousaffiliation = '#religious_id.religionid#',
		</cfif>
		<!----passportnumber = '#form.passportnumber#',---->
		
		<!--- father ---->
		fathersname = '#removeAccent(StudentXMLFile.applications.application[i].page1.family.father.firstname.XmlText)# #removeAccent(StudentXMLFile.applications.application[i].page1.family.father.lastname.XmlText)#',
		<!----
		fatheraddress = '#form.fatheraddress#',
		fathercountry = '#form.fathercountry#',
		--->
		fatherbirth =#calcfatherbirth#,
			
		fatherenglish = '#StudentXMLFile.applications.application[i].page1.family.father.speaksenglish.XmlText#',
		fatherworkphone = '#StudentXMLFile.applications.application[i].page1.family.father.phonebusinessormobile.XmlText#',
		<!----
		fathercompany = '#form.fathercompany#',
		---->
		fatherworkposition = '#StudentXMLFile.applications.application[i].page1.family.mother.occupation.XmlText#',
		<!--- mother --->
		mothersname = '#removeAccent(StudentXMLFile.applications.application[i].page1.family.mother.firstname.XmlText)# #removeAccent(StudentXMLFile.applications.application[i].page1.family.mother.lastname.XmlText)# ',
		<!----
		motheraddress = '#StudentXMLFile.applications.application[i].page1.family.mother.firstname.XmlText#',
		
		mothercountry = '#form.mothercountry#'	---->
		
		motherbirth = #calcmotherbirth#,
		
		motherenglish = '#StudentXMLFile.applications.application[i].page1.family.mother.speaksenglish.XmlText#',
		motherworkphone = '#StudentXMLFile.applications.application[i].page1.family.mother.phonebusinessormobile.XmlText#',
		<!----
		mothercompany = '#form.mothercompany#',
		---->
		motherworkposition = '#StudentXMLFile.applications.application[i].page1.family.mother.occupation.XmlText#',
		emergency_name = '#removeAccent(StudentXMLFile.applications.application[i].page1.emergencycontact.firstname.XmlText)# #removeAccent(StudentXMLFile.applications.application[i].page1.emergencycontact.lastname.XmlText)#',
		<!----emergency_address = '#form.emergency_address#',---->
		emergency_phone = '#StudentXMLFile.applications.application[i].page1.emergencycontact.phonebusinessormobile.XmlText#',
		<!----emergency_country = '#form.emergency_country#'--->
		
		<!----default values---->
		app_interview_english_level = 'Intermediate', 
		app_interview_strengths = 'Good level',
		app_interview_other = 'None',
		privateschool = 0,
			app_reading_skills = 'Good',
		app_writing_skills = 'Good', 
		app_verbal_skills = 'Good'
	
WHERE soid = '#StudentXMLFile.applications.application[i].XmlAttributes.studentid#'
LIMIT 1
</cfquery>

<!----State Choice----->

<cfquery name="insert_state" datasource="MySql">
	INSERT INTO smg_student_app_state_requested
		(studentid, state1, state2, state3)
	VALUES ('#client.studentid#', 0, 0, 0)
</cfquery>
				