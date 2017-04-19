<cfif not IsDefined('form.studentid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>
<cfset allergies_details = 0>
<!----Check for Allergies---->
<cfif IsDefined('form.allergic_to_penicillin')><cfif form.allergic_to_penicillin eq 1><cfset allergies_details = 1></cfif></cfif>
<cfif IsDefined('form.allergic_to_morphine')><cfif form.allergic_to_morphine eq 1><cfset allergies_details = 1></cfif></cfif>
<cfif IsDefined('form.allergic_to_aspirin')><cfif form.allergic_to_aspirin eq 1><cfset allergies_details = 1></cfif></cfif>
<cfif IsDefined('form.allergic_to_tetanus')><cfif form.allergic_to_tetanus eq 1><cfset allergies_details = 1></cfif></cfif>
<cfif IsDefined('form.allergic_to_foods')><cfif form.allergic_to_foods eq 1><cfset allergies_details = 1></cfif></cfif>
<cfif IsDefined('form.allergic_to_pets')><cfif form.allergic_to_pets eq 1><cfset allergies_details = 1></cfif></cfif>
<cfif IsDefined('form.allergic_to_novocaine')><cfif form.allergic_to_novocaine eq 1><cfset allergies_details = 1></cfif></cfif>
<cfif IsDefined('form.allergic_to_sulfa')><cfif form.allergic_to_sulfa eq 1><cfset allergies_details = 1></cfif></cfif>
<cfif IsDefined('form.allergic_to_adhesive')><cfif form.allergic_to_adhesive eq 1><cfset allergies_details = 1></cfif></cfif>
<cfif IsDefined('form.allergic_to_iodine')><cfif form.allergic_to_iodine eq 1><cfset allergies_details = 1></cfif></cfif>
<cfif IsDefined('form.allergic_to_other_drugs')><cfif form.allergic_to_other_drugs eq 1><cfset allergies_details = 1></cfif></cfif>
<cfif IsDefined('form.other_allergies')><cfif form.other_allergies eq 1><cfset allergies_details = 1></cfif></cfif>


		
<!----Set variables for health issues, if any are Yes, require more info. ---->

		
		<cfset need_add_info = ''>
        <cfif IsDefined('form.had_epilepsy')><cfif form.had_epilepsy eq 1><cfset need_add_info = ListAppend(need_add_info, 'Epilepsy')></cfif></cfif>        
        <cfif IsDefined('form.had_diabetes')><cfif form.had_diabetes eq 1><cfset need_add_info = ListAppend(need_add_info, 'Diabetes')></cfif></cfif> 
        <cfif IsDefined('form.had_cancer')><cfif form.had_cancer eq 1><cfset need_add_info = ListAppend(need_add_info, 'Cancer')></cfif></cfif> 
        <cfif IsDefined('form.had_broken_bones')><cfif form.had_broken_bones eq 1><cfset need_add_info = ListAppend(need_add_info, 'Broken Bones')></cfif></cfif> 
        <cfif IsDefined('form.had_sexually_disease')><cfif form.had_sexually_disease eq 1><cfset need_add_info = ListAppend(need_add_info, 'Sexually Transmitted Disease')></cfif></cfif> 
        <cfif IsDefined('form.had_strokes')><cfif form.had_strokes eq 1><cfset need_add_info = ListAppend(need_add_info, 'Strokes')></cfif></cfif> 
        <cfif IsDefined('form.had_concussion')><cfif form.had_concussion eq 1><cfset need_add_info = ListAppend(need_add_info, 'Concussion')></cfif></cfif>
        <cfif IsDefined('form.had_tuberculosis')><cfif form.had_tuberculosis eq 1><cfset need_add_info = ListAppend(need_add_info, 'Tuberculosis')></cfif></cfif> 
        <cfif IsDefined('form.had_rheumatic_fever')><cfif form.had_rheumatic_fever eq 1><cfset need_add_info = ListAppend(need_add_info, 'Rheumatic Fever')></cfif></cfif> 
        <!----ENT Stuff---->
        <cfif IsDefined('form.have_eye_disease')><cfif form.have_eye_disease eq 1><cfset need_add_info = ListAppend(need_add_info, 'Eye Disease or Injury')></cfif></cfif> 
        <cfif IsDefined('form.have_skin_disease')><cfif form.have_skin_disease eq 1><cfset need_add_info = ListAppend(need_add_info, 'Skin Disease, hove, exzama')></cfif></cfif> 
		<cfif IsDefined('form.have_jaundice')><cfif form.have_jaundice eq 1><cfset need_add_info = ListAppend(need_add_info, 'Jaundice')></cfif></cfif> 
        <cfif IsDefined('form.have_double_vision')><cfif form.have_double_vision eq 1><cfset need_add_info = ListAppend(need_add_info, 'Double Vision')></cfif></cfif> 
        <cfif IsDefined('form.have_infection')><cfif form.have_infection eq 1><cfset need_add_info = ListAppend(need_add_info, 'Frequent infection or boils')></cfif></cfif>
        <cfif IsDefined('form.have_headahes')><cfif form.have_headahes eq 1><cfset need_add_info = ListAppend(need_add_info, 'Chronic headaches')></cfif></cfif> 
        <cfif IsDefined('form.have_pigmentation')><cfif form.have_pigmentation eq 1><cfset need_add_info = ListAppend(need_add_info, 'Abnormal pigmentation')></cfif></cfif> 
        <cfif IsDefined('form.have_glaucoma')><cfif form.have_glaucoma eq 1><cfset need_add_info = ListAppend(need_add_info, 'Glaucoma')></cfif></cfif> 
        <cfif IsDefined('form.have_nosebleeds')><cfif form.have_nosebleeds eq 1><cfset need_add_info = ListAppend(need_add_info, 'Chronic nosebleeds')></cfif></cfif> 
        <cfif IsDefined('form.have_stiffness')><cfif form.have_stiffness eq 1><cfset need_add_info = ListAppend(need_add_info, 'Stiffness')></cfif></cfif> 
        <cfif IsDefined('form.have_sinus')><cfif form.have_sinus eq 1><cfset need_add_info = ListAppend(need_add_info, 'Chronic sinus trouble')></cfif></cfif> 
        <cfif IsDefined('form.have_thyroid_trouble')><cfif form.have_thyroid_trouble eq 1><cfset need_add_info = ListAppend(need_add_info, 'Thyroid Trouble')></cfif></cfif> 
        <cfif IsDefined('form.have_ear_disease')><cfif form.have_ear_disease eq 1><cfset need_add_info = ListAppend(need_add_info, 'Ear Disease')></cfif></cfif> 
        <cfif IsDefined('form.have_enlarged_gland')><cfif form.have_enlarged_gland eq 1><cfset need_add_info = ListAppend(need_add_info, 'Enlarged Glands')></cfif></cfif> 
        <cfif IsDefined('form.have_impaired_hearing')><cfif form.have_impaired_hearing eq 1><cfset need_add_info = ListAppend(need_add_info, 'Impaired hearing')></cfif></cfif> 
        <cfif IsDefined('form.wear_hearing_aids')><cfif form.wear_hearing_aids eq 1><cfset need_add_info = ListAppend(need_add_info, 'Do you wear hearing aids?')></cfif></cfif>
        <cfif IsDefined('form.have_spitting_up_blood')><cfif form.have_spitting_up_blood eq 1><cfset need_add_info = ListAppend(need_add_info, 'Spitting up blood')></cfif></cfif> 
        <cfif IsDefined('form.have_dizziness')><cfif form.have_dizziness eq 1><cfset need_add_info = ListAppend(need_add_info, 'Dizziness')></cfif></cfif> 
        <cfif IsDefined('form.have_cough')><cfif form.have_cough eq 1><cfset need_add_info = ListAppend(need_add_info, 'Cronic or frequent cough')></cfif></cfif> 
        <cfif IsDefined('form.have_unconsciousness')><cfif form.have_unconsciousness eq 1><cfset need_add_info = ListAppend(need_add_info, 'Episodes of unconsciousness')></cfif></cfif> 
        <cfif IsDefined('form.have_asthma')><cfif form.have_asthma eq 1><cfset need_add_info = ListAppend(need_add_info, 'Asthma')></cfif></cfif> 
<cfset client.need_add_info = '#need_add_info#'>

	<!--- UPDATE ROW --->
	<cfif IsDefined('form.healthid')>
		<cfquery name="update_questions" datasource="#APPLICATION.DSN#">
		UPDATE smg_student_app_health
		SET had_measles = <cfif IsDefined('form.had_measles')>'#form.had_measles#',<cfelse>NULL,</cfif>
			had_mumps = <cfif IsDefined('form.had_mumps')>'#form.had_mumps#',<cfelse>NULL,</cfif>
			had_chickenpox = <cfif IsDefined('form.had_chickenpox')>'#form.had_chickenpox#',<cfelse>NULL,</cfif>
			had_epilepsy = <cfif IsDefined('form.had_epilepsy')>'#form.had_epilepsy#',<cfelse>NULL,</cfif>
			had_rubella = <cfif IsDefined('form.had_rubella')>'#form.had_rubella#',<cfelse>NULL,</cfif>
			had_concussion = <cfif IsDefined('form.had_concussion')>'#form.had_concussion#',<cfelse>NULL,</cfif>
			had_rheumatic_fever = <cfif IsDefined('form.had_rheumatic_fever')>'#form.had_rheumatic_fever#',<cfelse>NULL,</cfif>
			had_diabetes = <cfif IsDefined('form.had_diabetes')>'#form.had_diabetes#',<cfelse>NULL,</cfif>
			had_cancer = <cfif IsDefined('form.had_cancer')>'#form.had_cancer#',<cfelse>NULL,</cfif>
			had_broken_bones = <cfif IsDefined('form.had_broken_bones')>'#form.had_broken_bones#',<cfelse>NULL,</cfif>
			had_sexually_disease = <cfif IsDefined('form.had_sexually_disease')>'#form.had_sexually_disease#',<cfelse>NULL,</cfif>
			had_strokes = <cfif IsDefined('form.had_strokes')>'#form.had_strokes#',<cfelse>NULL,</cfif>
			had_tuberculosis = <cfif IsDefined('form.had_tuberculosis')>'#form.had_tuberculosis#',<cfelse>NULL,</cfif> 
			been_hospitalized = <cfif IsDefined('form.been_hospitalized')>'#form.been_hospitalized#',<cfelse>NULL,</cfif> 
		    hospitalized_reason = <cfqueryparam value="#form.hospitalized_reason#" cfsqltype="cf_sql_char">,
			have_eye_disease = <cfif IsDefined('form.have_eye_disease')>'#form.have_eye_disease#',<cfelse>NULL,</cfif>
			wear_glasses = <cfif IsDefined('form.wear_glasses')>'#form.wear_glasses#',<cfelse>NULL,</cfif>
			have_double_vision = <cfif IsDefined('form.have_double_vision')>'#form.have_double_vision#',<cfelse>NULL,</cfif>
			have_headaches = <cfif IsDefined('form.have_headaches')>'#form.have_headaches#',<cfelse>NULL,</cfif>
			have_glaucoma = <cfif IsDefined('form.have_glaucoma')>'#form.have_glaucoma#',<cfelse>NULL,</cfif>
			have_nosebleeds = <cfif IsDefined('form.have_nosebleeds')>'#form.have_nosebleeds#',<cfelse>NULL,</cfif>
			have_sinus = <cfif IsDefined('form.have_sinus')>'#form.have_sinus#',<cfelse>NULL,</cfif>
			have_ear_disease = <cfif IsDefined('form.have_ear_disease')>'#form.have_ear_disease#',<cfelse>NULL,</cfif>
			have_impaired_hearing = <cfif IsDefined('form.have_impaired_hearing')>'#form.have_impaired_hearing#',<cfelse>NULL,</cfif>
			wear_hearing_aids = <cfif IsDefined('form.wear_hearing_aids')>'#form.wear_hearing_aids#',<cfelse>NULL,</cfif>
			have_dizziness = <cfif IsDefined('form.have_dizziness')>'#form.have_dizziness#',<cfelse>NULL,</cfif>
			have_unconsciousness = <cfif IsDefined('form.have_unconsciousness')>'#form.have_unconsciousness#',<cfelse>NULL,</cfif>
			have_skin_disease = <cfif IsDefined('form.have_skin_disease')>'#form.have_skin_disease#',<cfelse>NULL,</cfif>
			have_jaundice = <cfif IsDefined('form.have_jaundice')>'#form.have_jaundice#',<cfelse>NULL,</cfif>
			have_infection = <cfif IsDefined('form.have_infection')>'#form.have_infection#',<cfelse>NULL,</cfif>
			have_pigmentation = <cfif IsDefined('form.have_pigmentation')>'#form.have_pigmentation#',<cfelse>NULL,</cfif>
			have_stiffness = <cfif IsDefined('form.have_stiffness')>'#form.have_stiffness#',<cfelse>NULL,</cfif>
			have_thyroid_trouble = <cfif IsDefined('form.have_thyroid_trouble')>'#form.have_thyroid_trouble#',<cfelse>NULL,</cfif>
			have_enlarged_glands = <cfif IsDefined('form.have_enlarged_glands')>'#form.have_enlarged_glands#',<cfelse>NULL,</cfif>
			have_spitting_up_blood = <cfif IsDefined('form.have_spitting_up_blood')>'#form.have_spitting_up_blood#',<cfelse>NULL,</cfif>
			have_cough = <cfif IsDefined('form.have_cough')>'#form.have_cough#',<cfelse>NULL,</cfif>
			have_asthma = <cfif IsDefined('form.have_asthma')>'#form.have_asthma#',<cfelse>NULL,</cfif>
			good_health = <cfif IsDefined('form.good_health')>'#form.good_health#',<cfelse>NULL,</cfif>
			good_health_reason = <cfqueryparam value="#form.good_health_reason#" cfsqltype="cf_sql_char">,
			allergic_to_penicillin = <cfif IsDefined('form.allergic_to_penicillin')>'#form.allergic_to_penicillin#',<cfelse>NULL,</cfif>
			allergic_to_morphine = <cfif IsDefined('form.allergic_to_morphine')>'#form.allergic_to_morphine#',<cfelse>NULL,</cfif>
			allergic_to_aspirin = <cfif IsDefined('form.allergic_to_aspirin')>'#form.allergic_to_aspirin#',<cfelse>NULL,</cfif>
			allergic_to_tetanus = <cfif IsDefined('form.allergic_to_tetanus')>'#form.allergic_to_tetanus#',<cfelse>NULL,</cfif>
			allergic_to_foods = <cfif IsDefined('form.allergic_to_foods')>'#form.allergic_to_foods#',<cfelse>NULL,</cfif>
			foods_list = <cfqueryparam value="#form.foods_list#" cfsqltype="cf_sql_char">,
			allergic_to_pets = <cfif IsDefined('form.allergic_to_pets')>'#form.allergic_to_pets#',<cfelse>NULL,</cfif>
			pets_list = <cfif IsDefined('form.pets_list')>'#form.pets_list#',<cfelse>NULL,</cfif>
			allergic_to_novocaine = <cfif IsDefined('form.allergic_to_novocaine')>'#form.allergic_to_novocaine#',<cfelse>NULL,</cfif>
			allergic_to_sulfa = <cfif IsDefined('form.allergic_to_sulfa')>'#form.allergic_to_sulfa#',<cfelse>NULL,</cfif>
			allergic_to_adhesive = <cfif IsDefined('form.allergic_to_adhesive')>'#form.allergic_to_adhesive#',<cfelse>NULL,</cfif>
			allergic_to_iodine = <cfif IsDefined('form.allergic_to_iodine')>'#form.allergic_to_iodine#',<cfelse>NULL,</cfif>
			allergic_to_other_drugs = <cfif IsDefined('form.allergic_to_other_drugs')>'#form.allergic_to_other_drugs#',<cfelse>NULL,</cfif>
			other_allergies = <cfif IsDefined('form.other_allergies')>'#form.other_allergies#',<cfelse>NULL,</cfif>
			other_allergies_list = <cfqueryparam value="#form.other_allergies_list#" cfsqltype="cf_sql_char">,
			has_an_allergy = #allergies_details#,
            <!--- Psychological section --->
            depression = <cfif IsDefined('form.depression')><cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.depression#"><cfelse>NULL</cfif>,
			eating_disorders = <cfif IsDefined('form.eating_disorders')><cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.eating_disorders#"><cfelse>NULL</cfif>,
            psychological_adhd = <cfif IsDefined('form.psychological_adhd')><cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.psychological_adhd)#"><cfelse>NULL</cfif>,
            psychological_anxiety = <cfif IsDefined('form.psychological_anxiety')><cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.psychological_anxiety)#"><cfelse>NULL</cfif>,
            psychological_dissociative = <cfif IsDefined('form.psychological_dissociative')><cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.psychological_dissociative)#"><cfelse>NULL</cfif>,
            psychological_cutting = <cfif IsDefined('form.psychological_cutting')><cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.psychological_cutting)#"><cfelse>NULL</cfif>,
            psychological_impulseControl = <cfif IsDefined('form.psychological_impulseControl')><cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.psychological_impulseControl)#"><cfelse>NULL</cfif>,
            psychological_substance = <cfif IsDefined('form.psychological_substance')><cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.psychological_substance)#"><cfelse>NULL</cfif>,
			medical_attention_reason = <cfif IsDefined('form.medical_attention_reason')><cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.medical_attention_reason#"><cfelse>NULL</cfif>,
          
            other_psycho = <cfif IsDefined('form.other_psycho')><cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.other_psycho#"><cfelse>NULL</cfif>
            
		WHERE healthid = <cfqueryparam value="#form.healthid#" cfsqltype="cf_sql_integer"> 
		</cfquery>
        
	</cfif>
	<cfif allergies_details eq 1>
    	<cflocation url="index.cfm?curdoc=section3/allergy_info_request" addtoken="no">
    </cfif>

  
		<cfif client.need_add_info is not ''>
        	<cflocation url="index.cfm?curdoc=section3/additional_health_answers" addtoken="no">
        </cfif>
      

    
	<html>
	<head>
	<script language="JavaScript">
	<!-- 
	alert("You have successfully updated this page. Thank You.");
	<cfif NOT IsDefined('url.next')>
		location.replace("?curdoc=section3/page11&id=3&p=11");
	<cfelse>
		location.replace("?curdoc=section3/page12&id=3&p=12");
	</cfif>
	//-->
	</script>
	</head>
	</html>