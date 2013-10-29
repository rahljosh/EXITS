<cftry>

<!--- relocate users if they try to access the edit page without permission --->
<cfinclude template="../querys/get_latest_status.cfm">

<cfif (client.usertype EQ '10' AND (get_latest_status.status GTE '3' AND get_latest_status.status NEQ '4' AND get_latest_status.status NEQ '6'))  <!--- STUDENT ---->
	OR (client.usertype EQ '11' AND (get_latest_status.status GTE '4' AND get_latest_status.status NEQ '6'))  <!--- BRANCH ---->
	OR (client.usertype EQ '8' AND (get_latest_status.status GTE '6' AND get_latest_status.status NEQ '9')) <!--- INTL. AGENT ---->
	OR (client.usertype LTE '4' AND get_latest_status.status GTE '7') <!--- OFFICE USERS --->
	OR (client.usertype GTE '5' AND client.usertype LTE '7' OR client.usertype EQ '9')> <!--- FIELD --->
	
</cfif>

<cfinclude template="../querys/get_student_info.cfm">

<cfquery name="get_health" datasource="#APPLICATION.DSN#">
	SELECT *
	FROM smg_student_app_health 
	WHERE studentid = '#get_student_info.studentid#'
</cfquery>

<SCRIPT>
<!-- hide script
function CheckLink()
{
  if (document.allergyInfo.CheckChanged.value != 0)
  {
    if (confirm("You have made changes on this page that have not been saved.\n\These changes will be lost if you navigate away from this page.\n\Click OK to contine and discard changes, or click cancel and click on save to save your changes."))
      return true;
    else
      return false;
  }
}
function DataChanged()
{
  document.allergyInfo.CheckChanged.value = 1;
}

function NextPage() {
	document.allergyInfo.action = '?curdoc=section3/qr_allergy_info_request&next';
	}
//-->
</SCRIPT>


<cfform method="post" action="?curdoc=section3/qr_allergy_info_request" name="allergyInfo">
<cfinput type="hidden" name="CheckChanged" value="0">
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="../pics/students.gif"></td>
		<td class="tablecenter"><h2>Allergy Information</h2></td>
		<td align="right" class="tablecenter"></td>
		<td width="42" class="tableside"><img src="pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section"><br>
		<cfoutput>
       
<!--- MEDICAL HISTORY --->
<table width="670" border=0 cellpadding=2 cellspacing=0 align="center">
<tr>
	<td colspan="5">
You have indicated that you have allergies.  Please fill out this form with as much information as possible so we can place you with a family to better suite your needs.  Please answer all questions truthfully. <br /><br />
Please make sure you answer all questions.  One wrong answer could hold your application up or have it denied.  Please contact your rep with any questions.
  </td>

</tr>
<Tr >
    	<Th colspan=5><br>Animal Allergies</Th>
    </Tr>
	<tr>
    	<td colspan=5>Please indicate which animals, if any, you are allergic to:</td>
    </tr>
    
    <Tr>
    	<td><input type="checkbox" name="allergic_dogs" value="dogs" onchange="DataChanged();" <cfif get_health.allergic_dogs eq 1>checked</cfif>> Dogs </td>
        <td><input type="checkbox" name="allergic_cats" value="cats" onchange="DataChanged();" <cfif get_health.allergic_cats eq 1>checked</cfif>> Cats </td>
        <td><input type="checkbox" name="allergic_horses" value="horses" onchange="DataChanged();" <cfif get_health.allergic_horses eq 1>checked</cfif>> Horses </td>
        <td><input type="checkbox" name="allergic_rabbits" value="rabbits" onchange="DataChanged();" <cfif get_health.allergic_rabbits eq 1>checked</cfif>> Rabbits</td>
        <td><input type="checkbox" name="allergic_birds" value="birds" onchange="DataChanged();" <cfif get_health.allergic_birds eq 1>checked</cfif>> Birds</td>
    </Tr>
	
    <Tr>
    	<td colspan=5>
    	    What breeds of dogs/cats are you allergic to?<Br />
    	    <textarea cols=50 rows=5 onchange="DataChanged();" name="pets_list">#get_health.pets_list#</textarea>
  	    </p></td>
	</Tr>
   <!----<tr>
    	<Td colspan=5 >What breeds of dogs/cats are you allergic to?<br />
         <textarea cols=50 rows=5 name="dogs_cats_allergic"></textarea></Td>
    </tr>---->
   <tr>
   		<td colspan=5>Please answer Yes or No for the following questions:</td>
   </tr>
   <tr>
   		<Td colspan=5>Can you live in a home with a dog, which lives indoors? 
        <input type="radio" name="allergy_dog_indoors" value=1 onchange="DataChanged();" <cfif get_health.allergy_dog_indoors eq 1>checked</cfif>>Yes 
        <input type="radio" name="allergy_dog_indoors" value=0 onchange="DataChanged();" <cfif get_health.allergy_dog_indoors eq 0>checked</cfif>>No
        <br> 
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;How about outdoors? 
        <input type="radio" name="allergy_dog_outdoors" value=1 onchange="DataChanged();" <cfif get_health.allergy_dog_outdoors eq 1>checked</cfif>>Yes 
        <input type="radio" name="allergy_dog_outdoors" value=0 onchange="DataChanged();" <cfif get_health.allergy_dog_outdoors eq 0>checked</cfif>>No
   		 </Td>
       </tr>
   <tr>
    		<Td colspan=5>Can you live in a home with a cat, which lives indoors? 
            <input type="radio" name="allergy_cat_indoors" value=1 onchange="DataChanged();" <cfif get_health.allergy_cat_indoors eq 1>checked</cfif>>Yes 
            <input type="radio" name="allergy_cat_indoors" value=0 onchange="DataChanged();" <cfif get_health.allergy_cat_indoors eq 0>checked</cfif>>No <br>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;How about outdoors? 
            <input type="radio" name="allergy_cat_outdoors" value=1 onchange="DataChanged();" <cfif get_health.allergy_cat_outdoors eq 1>checked</cfif>>Yes 
            <input type="radio" name="allergy_cat_outdoors" value=0 onchange="DataChanged();" <cfif get_health.allergy_cat_outdoors eq 0>checked</cfif>>No
   		 </Td>
        </tr>
   <tr>  
         <Td colspan=5>Can you live in a home with animals if the animal is not permitted in your bedroom?
         <input type="radio" name="allergy_animal_not_bedroom" value=1 onchange="DataChanged();" <cfif get_health.allergy_animal_not_bedroom eq 1>checked</cfif>>Yes 
         <input type="radio" name="allergy_animal_not_bedroom" value=0 onchange="DataChanged();" <cfif get_health.allergy_animal_not_bedroom eq 0>checked</cfif>>No
     
   		 </Td>
       </tr>
   <tr>   
         <Td colspan=5>If placed in a home with animals, can medication control your symptoms?
         <input type="radio" name="allergy_animal_med_control" value=1 onchange="DataChanged();" <cfif get_health.allergy_animal_med_control eq 1>checked</cfif>>Yes 
         <input type="radio" name="allergy_animal_med_control" value=0 onchange="DataChanged();" <cfif get_health.allergy_animal_med_control eq 0>checked</cfif>>No
   		 </Td>
  	</tr>
  </Table>
  <br>
  <!---Living Conditions---->
<Table width=670 align="center">
	<Tr >
    	<Th colspan=5>Living Conditions</Th>
    </Tr>
	<tr>
   	  <td colspan=5>Please indicate if you are allergicto the following:</td>
    </tr>
    <Tr>
    	<td><input type="checkbox" name="allergic_dust" value="1" onchange="DataChanged();" <cfif get_health.allergic_dust eq 1>checked</cfif>> Dust </td>
        <td><input type="checkbox" name="allergic_grass" value="1" onchange="DataChanged();" <cfif get_health.allergic_grass eq 1>checked</cfif>> Grass </td>
        <td><input type="checkbox" name="allergic_pollen" value="1" onchange="DataChanged();" <cfif get_health.allergic_pollen eq 1>checked</cfif>> Pollen </td>
        <td><input type="checkbox" name="allergic_mold" value="1" onchange="DataChanged();" <cfif get_health.allergic_mold eq 1>checked</cfif>> Mold</td>
        <td><input type="checkbox" name="allergic_cigs" value="1" onchange="DataChanged();" <cfif get_health.allergic_cigs eq 1>checked</cfif>> Cigarette Smoke</td>
    </Tr>
    <Tr>
    	<td colspan=5>Please describe your syptoms:<Br />
        <textarea cols=50 rows=5 name="allergy_living_conditions">#get_health.allergy_living_conditions#</textarea></td>
	</Tr>
    <tr>
   		<Td colspan=5>Can your symptoms be controlled with medication? 
        <input type="radio" name="allergy_living_conditions_symptoms" onchange="DataChanged();" value=1 <cfif get_health.allergy_living_conditions_symptoms eq 1>checked</cfif>>Yes 
        <input type="radio" name="allergy_living_conditions_symptoms" onchange="DataChanged();" value=0 <cfif get_health.allergy_living_conditions_symptoms eq 0>checked</cfif>>No 
	  </Td>
  </tr>
   
</Table>
    <!---Food Allergies----><br>
<Table width=670 align="center">
	<Tr >
    	<Th colspan=5>Food Allergies</Th>
    </Tr>

    <Tr>
    	<td colspan=5>Please list all foods that you are allergic to:<Br />
        <textarea cols=50 rows=5 onchange="DataChanged();" name="foods_list">#get_health.foods_list#</textarea></td>
	</Tr>
    <tr>
   		<Td colspan=5>Please describe your symptoms?<br /> <textarea cols=50 rows=5 name="allergy_food_symptoms" onchange="DataChanged();">#get_health.allergy_food_symptoms#</textarea>
	  </Td>
  </tr>
    <tr>
   		<Td colspan=5>Can you prepare your own foor to accommodate your allergy? 
        <input type="radio" name="allergy_prep_food" value=1 onchange="DataChanged();" <cfif get_health.allergy_prep_food eq 1>checked</cfif> >Yes 
        <input type="radio" name="allergy_prep_food" value=0 onchange="DataChanged();"  <cfif get_health.allergy_prep_food eq 0>checked</cfif>>No
	  </Td>
  </tr>
   
  </Table>
   <!---Drug Allergies----><br>
<Table width=670 align="center">
	<Tr >
    	<Th colspan=5>Drug Allergies</Th>
    </Tr>

    <Tr>
    	<td colspan=5>Please list any medications that you have allergies to.<Br />
        <textarea cols=50 rows=5 name="other_drugs_list" onchange="DataChanged();">#get_health.other_drugs_list#</textarea></td>
	</Tr>
   
   
</Table>
 <!---Other Allergies----><br>
<Table width=670 align="center">
	<Tr >
    	<Th colspan=5>Other Allergies</Th>
    </Tr>

    <Tr>
    	<td colspan=5>Please list any other allergies you have, and if each can be controlled by medication.<Br />
        <textarea cols=50 rows=5 name="other_allergies_list" onchange="DataChanged();">#get_health.other_allergies_list#</textarea></td>
	</Tr>

</Table>
<br>

</div>
	
<!--- PAGE BUTTONS --->
<cfinclude template="../page_buttons.cfm">

</cfoutput>
</cfform>

<!--- FOOTER OF TABLE --->
<cfinclude template="../footer_table.cfm">

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>

</cftry>