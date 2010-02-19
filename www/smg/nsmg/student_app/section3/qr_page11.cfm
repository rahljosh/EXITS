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


		

            

	<cftry>

	<!--- UPDATE ROW --->
	<cfif IsDefined('form.healthid')>
		<cfquery name="update_questions" datasource="MySql">
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
			
			allergic_to_novocaine = <cfif IsDefined('form.allergic_to_novocaine')>'#form.allergic_to_novocaine#',<cfelse>NULL,</cfif>
			allergic_to_sulfa = <cfif IsDefined('form.allergic_to_sulfa')>'#form.allergic_to_sulfa#',<cfelse>NULL,</cfif>
			allergic_to_adhesive = <cfif IsDefined('form.allergic_to_adhesive')>'#form.allergic_to_adhesive#',<cfelse>NULL,</cfif>
			allergic_to_iodine = <cfif IsDefined('form.allergic_to_iodine')>'#form.allergic_to_iodine#',<cfelse>NULL,</cfif>
			allergic_to_other_drugs = <cfif IsDefined('form.allergic_to_other_drugs')>'#form.allergic_to_other_drugs#',<cfelse>NULL,</cfif>
			
			other_allergies = <cfif IsDefined('form.other_allergies')>'#form.other_allergies#',<cfelse>NULL,</cfif>
			other_allergies_list = <cfqueryparam value="#form.other_allergies_list#" cfsqltype="cf_sql_char">,
			depression = <cfif IsDefined('form.depression')>'#form.depression#',<cfelse>NULL,</cfif>
			eating_disorders = <cfif IsDefined('form.eating_disorders')>'#form.eating_disorders#',<cfelse>NULL,</cfif>
            has_an_allergy = #allergies_details#,
			medical_attention_reason = <cfqueryparam value="#form.medical_attention_reason#" cfsqltype="cf_sql_char">
            
		WHERE healthid = <cfqueryparam value="#form.healthid#" cfsqltype="cf_sql_integer"> 
		</cfquery>
        
	</cfif>
	<cfif allergies_details eq 1>
    	<cflocation url="index.cfm?curdoc=section3/allergy_info_request">
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

	<cfcatch type="any">
		<cfinclude template="../email_error.cfm">
	</cfcatch>
	</cftry>
