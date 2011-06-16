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
		
		<!---Figure out Regional Guarantee---->
	
		<cfif Left(#StudentXMLFile.applications.application[i].page1.program.regionalwishusa.XmlText#,  8) is 'Region 1'>
			<cfset app_region_guarantee = 1>
		<cfelseif Left(#StudentXMLFile.applications.application[i].page1.program.regionalwishusa.XmlText#,  8) is 'Region 2'>
			<cfset app_region_guarantee = 2>
		<cfelseif Left(#StudentXMLFile.applications.application[i].page1.program.regionalwishusa.XmlText#,  8) is 'Region 3'>
			<cfset app_region_guarantee = 3>
		<cfelseif Left(#StudentXMLFile.applications.application[i].page1.program.regionalwishusa.XmlText#,  8) is 'Region 4'>
			<cfset app_region_guarantee = 4>
		<cfelseif Left(#StudentXMLFile.applications.application[i].page1.program.regionalwishusa.XmlText#,  8) is 'Region 5'>
			<cfset app_region_guarantee = 5>
		<cfelse>
			<cfset app_region_guarantee = 0>
		</cfif>
		<cfif Left(#StudentXMLFile.applications.application[i].page1.program.duration.XmlText#, 4) is '2T-W'>
			<cfset indicated_prog = 3>
		<cfelseif Left(#StudentXMLFile.applications.application[i].page1.program.duration.XmlText#, 4) is '4T-W'>
			<cfset indicated_prog = 4>
		<cfelseif Left(#StudentXMLFile.applications.application[i].page1.program.duration.XmlText#, 4) is '4T-S'>
			<cfset indicated_prog = 1>
		<cfelseif Left(#StudentXMLFile.applications.application[i].page1.program.duration.XmlText#, 4) is '2T-S'>
			<cfset indicated_prog = 2>
		<cfelse>
			<cfset indicated_prog = ''>
		</cfif>
		
		<!----Religious Participation---->
		<cfif #StudentXMLFile.applications.application[i].page2.religion.howoftenattendchurch..XmlText# is 'Weekly'>
			<Cfset ind_religious_part = 'average'>
		<cfelseif #StudentXMLFile.applications.application[i].page2.religion.howoftenattendchurch..XmlText# is 'Never'>
			<cfset ind_religious_part = 'no interest'>
		<cfelse>
			<cfset ind_religious_part = 'little interest'>
		</cfif>	
		<!----Religious Affiliation---->
        <cfquery name="religion" datasource="mysql">
        select religionid
        from smg_religions 
        where religionname = '#StudentXMLFile.applications.application[i].page2.religion.religiousaffiliation.XmlText#'
        </cfquery>		
		<!----Years Studied English---->
		<cfset countEnglish = ArrayLen(#StudentXMLFile.applications.application[i].page2.languages.language#)>
		<cfloop index="yreng" from="1" to="#countEnglish#">
			<cfif #StudentXMLFile.applications.application[i].page2.languages.language[yreng].xmltext# is 'English'>
				<cfset yrs_study_english = #StudentXMLFile.applications.application[i].page2.languages.yearsofstudy[yreng].xmltext# >
			</cfif>
		</cfloop>
        <!----Other Interests---->
        <!----Years Studied English---->
       
		<cfset list_participate_activities =' '>
        <cfif #Len(StudentXMLFile.applications.application[i].page2.participates)# gt 150> 
			<cfset countInterests = ArrayLen(#StudentXMLFile.applications.application[i].page2.participates.participate#)>
            <cfloop index="CountI" from="1" to="#countInterests#">
                <cfset list_participate_activities = #ListAppend(list_participate_activities, '#StudentXMLFile.applications.application[i].page2.participates.participate[CountI].XmlText#')#>
            </cfloop>
      	</cfif>
        
<!----Actual insert query---->


<cfquery name="update_student" datasource="MySql">
UPDATE smg_students
	SET	familylastname = '#APPLICATION.CFC.UDF.removeAccent(StudentXMLFile.applications.application[i].page1.student.lastname.XmlText)#',
		firstname = '#APPLICATION.CFC.UDF.removeAccent(StudentXMLFile.applications.application[i].page1.student.firstname.XmlText)#',
		middlename = '#APPLICATION.CFC.UDF.removeAccent(StudentXMLFile.applications.application[i].page1.student.middlenames.XmlText)#',
		
		app_indicated_program = #indicated_prog#,
		<!----
		app_additional_program = <cfif form.app_additional_program EQ '0'>null,<cfelse> '#form.app_additional_program#',</cfif>  
		----->
		address = '#APPLICATION.CFC.UDF.removeAccent(StudentXMLFile.applications.application[i].page1.student.street.XmlText)#',
		city = '#StudentXMLFile.applications.application[i].page1.student.city.XmlText#',
		zip = '#StudentXMLFile.applications.application[i].page1.student.zip.XmlText#',
		country = #c_address.countryid#,
		phone = '#StudentXMLFile.applications.application[i].page1.student.phone.XmlText#',
		fax = '#StudentXMLFile.applications.application[i].page1.student.fax.XmlText#',
		email = '#StudentXMLFile.applications.application[i].page1.student.email.XmlText#',
		sex = '#StudentXMLFile.applications.application[i].page1.student.sex.XmlText#',
		dob = #CreateODBCDate(StudentXMLFile.applications.application[i].page1.student.dateofbirth.XmlText)#,
		citybirth = '#APPLICATION.CFC.UDF.removeAccent(StudentXMLFile.applications.application[i].page1.student.placeofbirth.XmlText)#',
		countrybirth = #c_birth.countryid#,
		countrycitizen = #c_citizen.countryid#,
		countryresident = #c_resident.countryid#,
		
        <cfif religion.recordcount gt 0>
		religiousaffiliation = #religion.religionid#,
        </cfif>
        <!----
		passportnumber = '#form.passportnumber#',
		---->
		<!--- father ---->
		fathersname = '#APPLICATION.CFC.UDF.removeAccent(StudentXMLFile.applications.application[i].page1.family.father.firstname.XmlText)# #APPLICATION.CFC.UDF.removeAccent(StudentXMLFile.applications.application[i].page1.family.father.lastname.XmlText)#',
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
		fatherworkposition = '#StudentXMLFile.applications.application[i].page1.family.father.occupation.XmlText#',
		<!--- mother --->
		mothersname = '#APPLICATION.CFC.UDF.removeAccent(StudentXMLFile.applications.application[i].page1.family.mother.firstname.XmlText)# #APPLICATION.CFC.UDF.removeAccent(StudentXMLFile.applications.application[i].page1.family.mother.lastname.XmlText)# ',
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
		emergency_name = '#APPLICATION.CFC.UDF.removeAccent(StudentXMLFile.applications.application[i].page1.emergencycontact.firstname.XmlText)# #APPLICATION.CFC.UDF.removeAccent(StudentXMLFile.applications.application[i].page1.emergencycontact.lastname.XmlText)#',
		<!----emergency_address = '#form.emergency_address#',---->
		emergency_phone = '#StudentXMLFile.applications.application[i].page1.emergencycontact.phonebusinessormobile.XmlText#',
		<!----emergency_country = '#form.emergency_country#'--->
		height = '#StudentXMLFile.applications.application[i].page9.height.XmlText#',
		weight = '#StudentXMLFile.applications.application[i].page9.weight.XmlText#',
		app_reasons_student = '#StudentXMLFile.applications.application[i].page2.feelaboutlearningdifferentcultureandlanguage.XmlText#',
		app_interview_english_level = 'Intermediate',
		app_interview_strengths = 'Good',
		dateapplication = #now()#,
		app_interview_other =  'None',
		privateschool = 0,
        <cfif #StudentXMLFile.applications.application[i].page2.musicalinstrument.XmlText# is not ''>
        app_play_instrument = '#StudentXMLFile.applications.application[i].page2.musicalinstrument.XmlText#',
        </cfif>
        band = <cfif #StudentXMLFile.applications.application[i].page2.musicalinstrument.XmlText# is ''>'no'<cfelse>'yes'</cfif>,
		chores_list = '#StudentXMLFile.applications.application[i].page2.householdresponsibilities.XmlText#',
		yearsenglish = <cfif yrs_study_english is not ''> #yrs_study_english#<cfelse>null</cfif>,
		religious_participation = '#ind_religious_part#',
		app_region_guarantee = #app_region_guarantee#,
        app_other_interest = '#list_participate_activities#'
	
WHERE soid = '#StudentXMLFile.applications.application[i].XmlAttributes.studentid#'
LIMIT 1
</cfquery>

<!----state choice---->
	<cfquery name="insert_state" datasource="MySql">
		INSERT INTO smg_student_app_state_requested
			(studentid, state1, state2, state3)
		VALUES (#client.studentid#, 0, 0, 0)
	</cfquery>