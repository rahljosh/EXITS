	<cfquery name="insert_questions" datasource="MySql">
		INSERT INTO smg_student_app_health (studentid) VALUES ('#client.studentid#')
	</cfquery>
	<cfquery name="get_health_id" datasource="MySQL">
	Select healthid
	from smg_student_app_health
	 where studentid = #client.studentid#
	</cfquery>
		<cfset numberill = ArrayLen(#StudentXMLFile.applications.application[i].page9.illness.type#)>
		<cfset numberdis = ArrayLen(#StudentXMLFile.applications.application[i].page9.disorders.type#)>
		
		<cfquery name="update_questions1" datasource="MySql">
		UPDATE smg_student_app_health
		SET 
		<!----Set to 0 incase not updated from XML so no errors 
		had_measles = Null,
		had_chickenpox =Null,
		had_mumps = Null,
		had_rheumatic_fever = Null,
		had_rubella = Null,
		had_rubella = Null,
		---->
		<!---Loop through the XML to check these diseases---->
		<cfloop from="1" to=#numberill# index="ill">
			<cfif StudentXMLFile.applications.application[i].page9.illness.type[ill].description.xmltext EQ 'Measles'>
				had_measles =  <cfif #StudentXMLFile.applications.application[i].page9.illness.type[ill].flag.xmltext# is 'yes'>1<cfelse>0</cfif>,
			<cfelseif StudentXMLFile.applications.application[i].page9.illness.type[ill].description.xmltext EQ 'Chicken Pox'>
				had_chickenpox = <cfif #StudentXMLFile.applications.application[i].page9.illness.type[ill].flag.xmltext# is 'yes'>1<cfelse>0</cfif>,
			<cfelseif StudentXMLFile.applications.application[i].page9.illness.type[ill].description.xmltext EQ 'Mumps'>
				had_mumps = <cfif #StudentXMLFile.applications.application[i].page9.illness.type[ill].flag.xmltext# is 'yes'>1<cfelse>0</cfif>,
			<cfelseif StudentXMLFile.applications.application[i].page9.illness.type[ill].description.xmltext EQ 'Rheumatic Fever'>
				had_rheumatic_fever = <cfif #StudentXMLFile.applications.application[i].page9.illness.type[ill].flag.xmltext# is 'yes'>1<cfelse>0</cfif>,
			<cfelseif StudentXMLFile.applications.application[i].page9.illness.type[ill].description.xmltext EQ 'Rubella'>
				had_rubella = <cfif #StudentXMLFile.applications.application[i].page9.illness.type[ill].flag.xmltext# is 'yes'>1<cfelse>0</cfif>,
			<cfelseif StudentXMLFile.applications.application[i].page9.illness.type[ill].description.xmltext EQ 'Scarlett Fever'>
				had_rubella = <cfif #StudentXMLFile.applications.application[i].page9.illness.type[ill].flag.xmltext# is 'yes'>1<cfelse>0</cfif>,
			<cfelseif StudentXMLFile.applications.application[i].page9.illness.type[ill].description.xmltext EQ 'Parasites'>
				had_sexually_disease = <cfif #StudentXMLFile.applications.application[i].page9.illness.type[ill].flag.xmltext# is 'yes'>1<cfelse>0</cfif>,
			</cfif>
		</cfloop>
		
		<cfloop from="1" to=#numberdis# index="dis">
			<cfif StudentXMLFile.applications.application[i].page9.disorders.type[dis].description.xmltext EQ 'Diabetes Militus'>
				had_diabetes =  <cfif #StudentXMLFile.applications.application[i].page9.disorders.type[dis].flag.xmltext# is 'yes'>1<cfelse>0</cfif>,
			<cfelseif StudentXMLFile.applications.application[i].page9.disorders.type[dis].description.xmltext EQ 'Chicken Pox'>
				had_chickenpox = <cfif #StudentXMLFile.applications.application[i].page9.disorders.type[dis].flag.xmltext# is 'yes'>1<cfelse>0</cfif>,
			<cfelseif StudentXMLFile.applications.application[i].page9.disorders.type[dis].description.xmltext EQ 'Headaches (persistent)'>
				have_headaches = <cfif #StudentXMLFile.applications.application[i].page9.disorders.type[dis].flag.xmltext# is 'yes'>1<cfelse>0</cfif>,
			<cfelseif StudentXMLFile.applications.application[i].page9.disorders.type[dis].description.xmltext EQ 'Hearing'>
				have_impaired_hearing = <cfif #StudentXMLFile.applications.application[i].page9.disorders.type[dis].flag.xmltext# is 'yes'>1<cfelse>0</cfif>,
			<cfelseif StudentXMLFile.applications.application[i].page9.disorders.type[dis].description.xmltext EQ 'Vertigo/Dizziness'>
				have_dizziness = <cfif #StudentXMLFile.applications.application[i].page9.disorders.type[dis].flag.xmltext# is 'yes'>1<cfelse>0</cfif>,
			<cfelseif StudentXMLFile.applications.application[i].page9.disorders.type[dis].description.xmltext EQ 'Asthma'>
				have_asthma = <cfif #StudentXMLFile.applications.application[i].page9.disorders.type[dis].flag.xmltext# is 'yes'>1<cfelse>0</cfif>,
			<cfelseif StudentXMLFile.applications.application[i].page9.disorders.type[dis].description.xmltext EQ 'Allergies'>
				other_allergies = <cfif #StudentXMLFile.applications.application[i].page9.disorders.type[dis].flag.xmltext# is 'yes'>1<cfelse>0</cfif>,
			<cfelseif StudentXMLFile.applications.application[i].page9.disorders.type[dis].description.xmltext EQ 'Anorexia Nervosa'>
				eating_disorders = <cfif #StudentXMLFile.applications.application[i].page9.disorders.type[dis].flag.xmltext# is 'yes'>1<cfelse>0</cfif>,
			</cfif>		
		</cfloop>
			other_allergies_list = '#StudentXMLFile.applications.application[i].page9.allergystatement.specificpollens.xmltext#'' , ' 							'#StudentXMLFile.applications.application[i].page9.ohterallergies.specificsubstances.xmltext#',
			allergic_to_pets =  <cfif StudentXMLFile.applications.application[i].page9.ohterallergies.toanimals.xmltext EQ 'NO'>0<cfelse>1</cfif>,
			been_hospitalized = <cfif StudentXMLFile.applications.application[i].page9.medicalcare.hospitalized.xmltext EQ 'Yes'>1<cfelse>0</cfif>,
			hospitalized_reason = '#StudentXMLFile.applications.application[i].page9.medicalcare.whyhospitalized.xmltext#',
			allergic_to_other_drugs = <cfif #StudentXMLFile.applications.application[i].page9.medicalcare.whyhospitalized.xmltext# EQ 'Yes'>1<cfelse>0</cfif>,
			pets_list = '#StudentXMLFile.applications.application[i].page2.animals.allergictoanimals.xmltext#',
			clinical_blood_standing = '#StudentXMLFile.applications.application[i].page9.bloodpressure.xmltext#'
			WHERE healthid = #get_health_id.healthid#  
		</cfquery>
		<cfquery name="update_questions2" datasource="MySql">
		UPDATE smg_student_app_health
		SET 
			had_epilepsy = 0,
			had_concussion = 0,
			had_cancer = 0,
			had_broken_bones = 0,
			had_strokes = 0,
			had_tuberculosis =0,
			have_eye_disease = 0,
			wear_glasses = 0,
			have_double_vision = 0,
			have_glaucoma = 0,
			have_nosebleeds = 0,
			have_sinus = 0,
			have_ear_disease = 0,
			wear_hearing_aids = 0,
			have_unconsciousness = 0,
			have_skin_disease = 0,
			have_jaundice = 0,
			have_infection = 0,
			have_pigmentation = 0,
			have_stiffness = 0,
			have_thyroid_trouble = 0,
			have_enlarged_glands = 0,
			have_spitting_up_blood = 0,
			have_cough = 0,
			clinical_build = 'Average',
			good_health = 1,
			good_health_reason = 'n/a',
			allergic_to_penicillin = 0,
			allergic_to_morphine = 0,
			allergic_to_aspirin = 0,
			allergic_to_tetanus = 0,
			allergic_to_foods = 0,
			foods_list = 'n/a',
			allergic_to_novocaine = 0,
			allergic_to_sulfa =  0,
			allergic_to_adhesive =  0,
			allergic_to_iodine =  0,
			
			<!----
			other_drugs_list = Null,
			
			---->
			depression =  0
			
			<!----
			medical_attention_reason = Null
			---->
		WHERE healthid = #get_health_id.healthid# 
		</cfquery>
		<cfquery name="update_students_all" datasource="mysql">
        update smg_students 
        set animal_allergies = <cfif StudentXMLFile.applications.application[i].page9.ohterallergies.toanimals.xmltext EQ 'No'>'no'<cfelse>'yes'</cfif>,
			app_allergic_animal = '#StudentXMLFile.applications.application[i].page2.animals.allergictoanimals.xmltext#'
            where studentid = #client.studentid#
        </cfquery>