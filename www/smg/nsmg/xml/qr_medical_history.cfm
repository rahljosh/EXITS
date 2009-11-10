	<cfquery name="insert_questions" datasource="MySql">
		INSERT INTO smg_student_app_health (studentid) VALUES ('#client.studentid#')
	</cfquery>
	<cfquery name="get_health_id" datasource="MySQL">
	Select healthid
	from smg_student_app_health
	 where studentid = #client.studentid#
	</cfquery>
		
		<cfquery name="update_questions" datasource="MySql">
		UPDATE smg_student_app_health
		SET had_measles = Null,
			had_mumps = Null,
			had_chickenpox = Null,
			had_epilepsy = 0,
			had_rubella = Null,
			had_concussion = 0,
			had_rheumatic_fever = Null,
			had_diabetes = Null,
			had_cancer = 0,
			had_broken_bones = 0,
			had_sexually_disease = Null,
			had_strokes = 0,
			had_tuberculosis =0,
			been_hospitalized = Null, 
			<!----
		    hospitalized_reason = Null,
			---->
			have_eye_disease = 0,
			wear_glasses = 0,
			have_double_vision = 0,
			have_headaches = Null,
			have_glaucoma = 0,
			have_nosebleeds = 0,
			have_sinus = 0,
			have_ear_disease = 0,
			have_impaired_hearing = Null,
			wear_hearing_aids = 0,
			have_dizziness = Null,
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
			have_asthma = Null,
			good_health = 1,
			good_health_reason = 'n/a',
			allergic_to_penicillin = 0,
			allergic_to_morphine = 0,
			allergic_to_aspirin = 0,
			allergic_to_tetanus = 0,
			allergic_to_foods = 0,
			foods_list = 'n/a',
			allergic_to_pets = Null,
			<!----
			pets_list = Null,
			---->
			allergic_to_novocaine = 0,
			allergic_to_sulfa =  0,
			allergic_to_adhesive =  0,
			allergic_to_iodine =  0,
			allergic_to_other_drugs = Null,
			<!----
			other_drugs_list = Null,
			other_allergies = Null,
			other_allergies_list = Null,
			---->
			depression =  0,
			eating_disorders = Null
			<!----
			medical_attention_reason = Null
			---->
		WHERE healthid = #get_health_id.healthid# 
		</cfquery>
