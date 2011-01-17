<cfquery name="insert_allergy_info" datasource="#application.dsn#">
UPDATE smg_student_app_health
		SET allergy_dog_indoors = <cfif IsDefined('form.allergy_dog_indoors')>#form.allergy_dog_indoors#,<cfelse>NULL,</cfif>         
allergy_dog_outdoors =    <cfif IsDefined('form.allergy_dog_outdoors')>#form.allergy_dog_outdoors#,<cfelse>NULL,</cfif>        
allergy_cat_indoors =   <cfif IsDefined('form.allergy_cat_indoors')>#form.allergy_cat_indoors#,<cfelse>NULL,</cfif>           
allergy_cat_outdoors =   <cfif IsDefined('form.allergy_cat_outdoors')>#form.allergy_cat_outdoors#,<cfelse>NULL,</cfif>            
allergy_animal_not_bedroom =    <cfif IsDefined('form.allergy_animal_not_bedroom')>#form.allergy_animal_not_bedroom#,<cfelse>NULL,</cfif>        
allergy_animal_med_control =  <cfif IsDefined('form.allergy_animal_med_control')>#form.allergy_animal_med_control#,<cfelse>NULL,</cfif>allergy_living_conditions = <cfif IsDefined('form.allergy_living_conditions')>'#form.allergy_living_conditions#',<cfelse>NULL,</cfif>  
allergy_living_conditions_symptoms = <cfif IsDefined('form.allergy_living_conditions_symptoms')>#form.allergy_living_conditions_symptoms#,<cfelse>NULL,</cfif>
pets_list = <cfqueryparam value="#form.pets_list#" cfsqltype="cf_sql_char">,            
allergy_living_medication = <cfif IsDefined('form.allergy_living_medication')>#form.allergy_living_medication#,<cfelse>NULL,</cfif>              
allergy_living_treated_doctor = <cfif IsDefined('form.allergy_living_treated_doctor')>'#form.allergy_living_treated_doctor#',<cfelse>NULL,</cfif>     foods_list = <cfqueryparam value="#form.foods_list#" cfsqltype="cf_sql_char">,        
allergy_food_symptoms =<cfif IsDefined('form.allergy_food_symptoms')>'#form.allergy_food_symptoms#',<cfelse>NULL,</cfif>                  
allergy_prep_food = <cfif IsDefined('form.allergy_prep_food')>#form.allergy_prep_food#,<cfelse>NULL,</cfif>           
allergy_controlled_med =  <cfif IsDefined('form.allergy_controlled_med')>#form.allergy_controlled_med#,<cfelse>NULL,</cfif>            
allergy_other_drugs = <cfif IsDefined('form.allergy_other_drugs')>#form.allergy_other_drugs#,<cfelse>NULL,</cfif>
other_drugs_list = <cfqueryparam value="#form.other_drugs_list#" cfsqltype="cf_sql_char">,
allergic_dogs = <cfif IsDefined('form.allergic_dogs')>1,<cfelse>0,</cfif>
allergic_cats = <cfif IsDefined('form.allergic_cats')>1,<cfelse>0,</cfif>
allergic_horses = <cfif IsDefined('form.allergic_horses')>1,<cfelse>0,</cfif>
allergic_rabbits = <cfif IsDefined('form.allergic_rabbits')>1,<cfelse>0,</cfif>
allergic_birds = <cfif IsDefined('form.allergic_birds')>1,<cfelse>0,</cfif>
allergic_dust = <cfif IsDefined('form.allergic_dust')>1,<cfelse>0,</cfif>
allergic_grass = <cfif IsDefined('form.allergic_grass')>1,<cfelse>0,</cfif>
allergic_pollen = <cfif IsDefined('form.allergic_pollen')>1,<cfelse>0,</cfif>
allergic_mold = <cfif IsDefined('form.allergic_mold')>1,<cfelse>0,</cfif>
other_allergies_list = <cfqueryparam value="#form.other_allergies_list#" cfsqltype="cf_sql_char">,
allergic_cigs = <cfif IsDefined('form.allergic_cigs')>1<cfelse>0</cfif>
where studentid = #client.studentid#
</cfquery>

<cfif client.need_add_info is not ''>
	<cflocation url="?curdoc=section3/additional_health_answers">
</cfif>

<script language="JavaScript">
<!-- 
alert("You have successfully updated this page. Thank You.");
<cfif NOT IsDefined('url.next')>
	location.replace("?curdoc=section3/allergy_info_request&id=3&p=allergy_info_request");
<cfelse>
	location.replace("?curdoc=section3/page12&id=3&p=12");
</cfif>
//-->
</script>
