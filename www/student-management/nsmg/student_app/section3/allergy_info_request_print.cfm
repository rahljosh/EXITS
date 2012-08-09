<cfscript>
	// These are used to set the vStudentAppRelativePath directory for images nsmg/student_app/pics and uploaded files nsmg/uploadedFiles/
	// Param Variables
	param name="vStudentAppRelativePath" default="../";
	param name="vUploadedFilesRelativePath" default="../../";
	
	if ( LEN(URL.curdoc) ) {
		vStudentAppRelativePath = "";
		vUploadedFilesRelativePath = "../";
	}
</cfscript>

<!--- relocate users if they try to access the edit page without permission --->
<cfinclude template="../querys/get_latest_status.cfm">

<cfif (client.usertype EQ '10' AND (get_latest_status.status GTE '3' AND get_latest_status.status NEQ '4' AND get_latest_status.status NEQ '6'))  <!--- STUDENT ---->
	OR (client.usertype EQ '11' AND (get_latest_status.status GTE '4' AND get_latest_status.status NEQ '6'))  <!--- BRANCH ---->
	OR (client.usertype EQ '8' AND (get_latest_status.status GTE '6' AND get_latest_status.status NEQ '9')) <!--- INTL. AGENT ---->
	OR (client.usertype LTE '4' AND get_latest_status.status GTE '7') <!--- OFFICE USERS --->
	OR (client.usertype GTE '5' AND client.usertype LTE '7' OR client.usertype EQ '9')> <!--- FIELD --->
</cfif>

<cfinclude template="../querys/get_student_info.cfm">

<cfquery name="get_health" datasource="MySql">
	SELECT
    	*
	FROM
    	smg_student_app_health 
	WHERE
    	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(get_student_info.studentid)#">
</cfquery>

<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="../pics/students.gif"></td>
		<td class="tablecenter"><h2>Allergy Information</h2></td>
		<td align="right" class="tablecenter"></td>
		<td width="42" class="tableside"><img src="pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section">

	<br />
    
	<cfoutput>
    
        <!--- MEDICAL HISTORY --->
        <table width="670" border=0 cellpadding=2 cellspacing=0 align="center">
            <tr>
                <td colspan="5">
                    You have indicated that you have allergies.  Please fill out this form with as much information as possible so we can place you with a family to better suite your needs.  Please answer all questions truthfully. 
                    <br />
                    <br />
                    Please make sure you answer all questions.  One wrong answer could hold your application up or have it denied.  Please contact your rep with any questions.
                </td>
            </tr>
            <tr>
                <th colspan="5">
                    <br />
                    Animal Allergies
                </th>
            </tr>
            <tr>
                <td colspan=5>Please indicate which animals, if any, you are allergic to:</td>
            </tr>
            <tr>
                <td><cfif get_health.allergic_dogs eq 1><img src="../pics/check.jpg"></cfif> Dogs </td>
                <td><cfif get_health.allergic_cats eq 1><img src="../pics/check.jpg"></cfif> Cats </td>
                <td><cfif get_health.allergic_horses eq 1><img src="../pics/check.jpg"></cfif> Horses </td>
                <td><cfif get_health.allergic_rabbits eq 1><img src="../pics/check.jpg"></cfif> Rabbits</td>
                <td><cfif get_health.allergic_birds eq 1><img src="../pics/check.jpg"></cfif> Birds</td>
            </tr>
            <tr>
                <td colspan="5">
                    <br />
                    What breeds of dogs/cats are you allergic to?
                    <br />
                    &nbsp;#get_health.pets_list#
                </td>
            </tr>
            <tr>
                <td colspan="5">
                    <img src="#vStudentAppRelativePath#pics/line.gif" width="650" height="1" border="0" align="absmiddle">
                </td>
            </tr>
            <tr>
                <td colspan="5">
                    <br />
                    Please answer Yes or No for the following questions:
                </td>
            </tr>
            <tr>
                <td colspan="5">
                    Can you live in a home with a dog, which lives indoors? 
                    <cfif get_health.allergy_dog_indoors eq 1>
                        <strong>Yes</strong>
                    <cfelseif get_health.allergy_dog_indoors eq 0>
                        <strong>No</strong>
                    <cfelse>
                        <strong>N/A</strong>
                    </cfif>
                    <br /> 
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;How about outdoors? 
                    <cfif get_health.allergy_dog_outdoors eq 1>
                        <strong>Yes</strong>
                    <cfelseif get_health.allergy_dog_outdoors eq 0>
                        <strong>No</strong>
                    <cfelse>
                        <strong>N/A</strong>
                    </cfif>
                </td>
            </tr>
            <tr>
                <td colspan=5>
                    Can you live in a home with a cat, which lives indoors? 
                    <cfif get_health.allergy_cat_indoors eq 1>
                        <strong>Yes</strong>
                    <cfelseif get_health.allergy_cat_indoors eq 0>
                        <strong>No</strong>
                    <cfelse>
                        <strong>N/A</strong>
                    </cfif>
                    <br>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;How about outdoors? 
                    <cfif get_health.allergy_cat_outdoors eq 1>
                        <strong>Yes</strong>
                    <cfelseif get_health.allergy_cat_outdoors eq 0>
                        <strong>No</strong>
                    <cfelse>
                        <strong>N/A</strong>
                    </cfif>
                </td>
            </tr>
            <tr>  
                <td colspan=5>
                    Can you live in a home with animals if the animal is not permitted in your bedroom?
                    <cfif get_health.allergy_animal_not_bedroom eq 1>
                        <strong>Yes</strong> 
                    <cfelseif get_health.allergy_animal_not_bedroom eq 0>
                        <strong>No</strong>
                    <cfelse>
                        <strong>N/A</strong>
                    </cfif>
                </td>
            </tr>
            <tr>   
                <td colspan=5>If placed in a home with animals, can medication control your symptoms?
                    <cfif get_health.allergy_animal_med_control eq 1>
                        <strong>Yes</strong> 
                    <cfelseif get_health.allergy_animal_med_control eq 0>
                        <strong>No</strong>
                    <cfelse>
                        <strong>N/A</strong>
                    </cfif>
                </td>
            </tr>
        </table>

        <!---Living Conditions---->
        <br />
        <table width=670 align="center">
            <tr>
                <th colspan="5">Living Conditions</th>
            </tr>
            <tr>
                <td colspan="5">
                    Please indicate if you are allergicto the following:
                </td>
            </tr>
            <tr>
                <td><cfif get_health.allergic_dust eq 1><img src="../pics/check.jpg"></cfif> Dust </td>
                <td><cfif get_health.allergic_grass eq 1><img src="../pics/check.jpg"></cfif> Grass </td>
                <td><cfif get_health.allergic_pollen eq 1><img src="../pics/check.jpg"></cfif>Pollen </td>
                <td><cfif get_health.allergic_mold eq 1><img src="../pics/check.jpg"></cfif> Mold</td>
                <td><cfif get_health.allergic_cigs eq 1><img src="../pics/check.jpg"></cfif> Cigarette Smoke</td>
            </tr>
            <tr>
                <td colspan=5>
                    <br />
                    Please describe your syptoms:
                    <br />
                    &nbsp;#get_health.allergy_living_conditions#
                </td>
            </tr>
            <tr>
                <td colspan="5">
                    <img src="#vStudentAppRelativePath#pics/line.gif" width="650" height="1" border="0" align="absmiddle">
                </td>
            </tr>
            <tr>
                <td colspan=5>
                    <br />
                    Can your symptoms be controlled with medication? 
                    <cfif get_health.allergy_living_conditions_symptoms eq 1>
                        <strong>Yes</strong>
                    <cfelseif get_health.allergy_living_conditions_symptoms eq 0>
                        <strong>No</strong>
                    <cfelse>
                        <strong>N/A</strong>
                    </cfif>
                </td>
            </tr>   
        </table>
    
        <!---Food Allergies---->
        <br />
        <table width=670 align="center">
            <tr>
                <th colspan=5>Food Allergies</th>
            </tr>
            <tr>
                <td colspan="5">
                    Please list all foods that you are allergic to:
                    <br />
                    &nbsp;#get_health.foods_list#
                </td>
            </tr>
            <tr>
                <td colspan="5">
                    <img src="#vStudentAppRelativePath#pics/line.gif" width="650" height="1" border="0" align="absmiddle">
                </td>
            </tr>
            <tr>
                <td colspan="5">
                    <br />
                    Please describe your symptoms?
                    <br />
                    &nbsp;#get_health.allergy_food_symptoms#
                </td>
            </tr>
            <tr>
                <td colspan="5">
                    <img src="#vStudentAppRelativePath#pics/line.gif" width="650" height="1" border="0" align="absmiddle">
                </td>
            </tr>
            <tr>
                <td colspan=5>
                    <br />
                    Can you prepare your own foor to accommodate your allergy? 
                    <cfif get_health.allergy_prep_food eq 1>
                        <strong>Yes</strong>
                    <cfelseif get_health.allergy_prep_food eq 0>
                        <strong>No</strong>
                    <cfelse>
                        <strong>N/A</strong>
                    </cfif>
                </td>
            </tr>
        </table>
        
        <!---Drug Allergies---->
        <br />
        <table width=670 align="center">
            <tr>
                <th colspan="5">Drug Allergies</th>
            </tr>
            <tr>
                <td colspan="5">
                    Please list any medications that you have allergies to.
                    <br />
                    &nbsp;#get_health.other_drugs_list#
                </td>
            </tr>
            <tr>
                <td colspan="5">
                    <img src="#vStudentAppRelativePath#pics/line.gif" width="650" height="1" border="0" align="absmiddle">
                </td>
            </tr>
        </table>
        
        <!---Other Allergies---->
        <br />
        <table width=670 align="center">
            <tr >
                <th colspan="5">Other Allergies</th>
            </tr>
            <tr>
                <td colspan="5">
                    Please list any other allergies you have, and if each can be controlled by medication.
                    <br />
                    &nbsp;#get_health.other_allergies_list#
                </td>
            </tr>
            <tr>
                <td colspan="5">
                    <img src="#vStudentAppRelativePath#pics/line.gif" width="650" height="1" border="0" align="absmiddle">
                </td>
            </tr>
        </table>
        
        <br />
        
	</cfoutput>

</div>

<!--- FOOTER OF TABLE --->
<cfinclude template="../footer_table.cfm">