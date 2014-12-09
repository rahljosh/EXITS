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

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" <cfoutput>href="#vStudentAppRelativePath#app.css"</cfoutput>>
</head>
<body <cfif NOT LEN(URL.curdoc)>onLoad="print()"</cfif>>

<cfinclude template="../querys/get_student_info.cfm">

<cfquery name="get_health" datasource="#APPLICATION.DSN#">
	SELECT *
	FROM smg_student_app_health 
	WHERE studentid = '#get_student_info.studentid#'
</cfquery>

<cfoutput query="get_student_info">

<cfif NOT LEN(URL.curdoc)>
<table align="center" width=90% cellpadding=0 cellspacing=0  border=0 > 
<tr><td>
</cfif>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="#vStudentAppRelativePath#pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="#vStudentAppRelativePath#pics/students.gif"></td>
		<td class="tablecenter"><h2>Page [11] - Health Questionnaire</h2></td>
		<cfif LEN(URL.curdoc)>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section3/page11print.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		</cfif>
		<td width="42" class="tableside"><img src="#vStudentAppRelativePath#pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section">
		
<!--- MEDICAL HISTORY --->
<table width="660" border=0 cellpadding=1 cellspacing=0 align="center">
	<tr><td colspan="4"><b>MEDICAL HISTORY</b> - <em>Have you had?</em></td></tr>
	<tr>
		<td width="90" align="right">
			<cfif get_health.had_diabetes is 'no'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.had_diabetes is 'yes'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;			
		</td>
		<td width="245"><em>Diabetes</em></td>	
        <td align="right">
			<cfif get_health.had_strokes is 'no'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.had_strokes is 'yes'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;		
		</td>
		<td><em>Strokes / Cerebral Hemorrhage</em></td>
	</tr>
	<tr>
		<td align="right">
			<cfif get_health.had_cancer is 'no'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.had_cancer is 'yes'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;	 
		</td>
		<td><em>Cancer</em></td>	
        <td align="right">
			<cfif get_health.had_concussion is 'no'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.had_concussion is 'yes'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;
		</td>
		<td><em>Concussion or Head Injuries</em></td>
	</tr>
	<tr><td align="right">
			<cfif get_health.had_chickenpox is 'no'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.had_chickenpox is 'yes'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;		
		</td>
		<td><em>Chickenpox</em></td>	
		<td align="right">
			<cfif get_health.had_broken_bones is 'no'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.had_broken_bones is 'yes'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;		
		</td>
		<td><em>Broken Bones</em></td>		
	</tr>
	<tr><td align="right">
			<cfif get_health.had_epilepsy is 'no'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.had_epilepsy is 'yes'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;		
		</td>
		<td><em>Epilepsy</em></td>	
		<td align="right">
			<cfif get_health.had_sexually_disease is 'no'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.had_sexually_disease is 'yes'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;
		</td>
		<td><em>Sexually Transmitted Disease</em></td>
	</tr>
	<tr>
		
	</tr>
	<tr>
		
	</tr>
	<tr>
		<td align="right">&nbsp;</td>
		<td>&nbsp;</td>	
	</tr>
   	<tr>
    	<td align="right">
			<cfif get_health.been_hospitalized is 'no'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.been_hospitalized is 'yes'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;		
		</td>
		<td colspan="3"><em>Have you ever been hospitalized, had surgery or been treated for a chronic medical illness?</em></td>
	</tr>
	<tr><td>&nbsp;</td>
		<td colspan="3"><em>Please Explain:</em> &nbsp; #get_health.hospitalized_reason#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="500" height="1" border="0" align="absmiddle"></td>
	</tr>
  
</table>

<!--- SYSTEMIC REVIEW --->
<table width="660" border=0 cellpadding=1 cellspacing=0 align="center">
	<tr><td colspan="4"><b>SYSTEMIC REVIEW</b> - <em>Do you have the following?</em></td></tr>
	<tr><td colspan="2" align="left"><b>Eyes-Ears-Nose-Throat:</b></td>
		
	</tr>
	<tr><td width="90" align="right">
			<cfif get_health.have_eye_disease is 'no'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.have_eye_disease is 'yes'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;
		</td>
		<td width="245"><em>Eye disease or injury</em></td>
        <td align="right">
			<cfif get_health.wear_glasses is 'no'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.wear_glasses is 'yes'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;		
		</td>
		<td><em>Do you wear glasses?</em></td>	
		</tr>
	
	<tr><td align="right">
			<cfif get_health.have_double_vision is 'no'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.have_double_vision is 'yes'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;		
		</td>
		<td><em>Double Vision</em></td>
		<td align="right">
			<cfif get_health.have_headaches is 'no'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.have_headaches is 'yes'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;		
		</td>
		<td><em>Cronic Headaches</em></td>	
	</tr>

	<tr>
	</tr>
	<tr><td align="right">
			<cfif get_health.have_sinus is 'no'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.have_sinus is 'yes'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;		
		</td>
		<td><em>Chronic sinus trouble</em></td>
		<td align="right">
			<cfif get_health.have_ear_disease is 'no'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.have_ear_disease is 'yes'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;		
		</td>
		<td><em>Ear Disease</em></td>
	</tr>
	
	
	<tr><td align="right">
			<cfif get_health.have_impaired_hearing is 'no'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.have_impaired_hearing is 'yes'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;
		</td>
		<td><em>Impaired Hearing</em></td>
		<td align="right">
			<cfif get_health.have_dizziness is 'no'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.have_dizziness is 'yes'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;			
		</td>
		<td><em>Dizziness</em></td>
	</tr>
<tr>
		<td align="right">
			<cfif get_health.have_unconsciousness is 'no'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.have_unconsciousness is 'yes'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;	 
		</td>
		<td><em>Episodes of unconsciousness</em></td>
		<td align="right">
			<cfif get_health.have_nosebleeds is 'no'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.have_nosebleeds is 'yes'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;		
		</td>
		<td><em>Nosebleeds</em></td>
		
	</tr>
    <Tr>
    	<td colspan="2" align="left"><b>Skin</b></td>
    </Tr>
	<tr>
    <td width="90" align="right">
			<cfif get_health.have_skin_disease is 'no'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.have_skin_disease is 'yes'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> >Yes <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;		
		</td>
		<td width="245"><em>Skin disease, hives, eczema</em></td>	
        <td align="right">
			<cfif get_health.have_jaundice is 'no'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.have_jaundice is 'yes'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;		
		</td>
		<td><em>Jaundice</em></td>
        
    
		
	</tr>
	<tr><td align="right">
			<cfif get_health.good_health is 'no'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.good_health is 'yes'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;		
		</td>
		<td colspan="5"><em>Have you been in good general health most of your life? </em></td>
	</tr>
	<tr><td>&nbsp;</td>
		<td colspan="5"><em>If not, please explain.</em> &nbsp; #get_health.good_health_reason#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="500" height="1" border="0" align="absmiddle"></td>
	</tr>
</table>

<!--- ALLERGIES AND SENSITIVITIES --->
<table width="660" border=0 cellpadding=1 cellspacing=0 align="center">
	<tr><td colspan="6"><b>ALLERGIES AND SENSITIVITIES</b> - <em>Is there a history of skin or other reaction or sickness following injections or oral administration of:</em></td></tr>
	<tr><td width="90" align="right">
			<cfif get_health.allergic_to_penicillin is 'no'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.allergic_to_penicillin is 'yes'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;
		</td>
		<td width="245"><em>Penicillin or other antibiotics</em></td>
		
		<td width="90" align="right">
			<cfif get_health.allergic_to_novocaine is 'no'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.allergic_to_novocaine is 'yes'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;
		</td>
		<td width="245"><em>Novocaine or other anesthetics</em></td>
	</tr>
	
	<tr><td align="right">
			<cfif get_health.allergic_to_aspirin is 'no'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.allergic_to_aspirin is 'yes'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;
		</td>
		<td><em>Aspirin, empirin or other pain remedies</em></td>
		
		
	</tr>
	
	<tr><td align="right">
			<cfif get_health.allergic_to_foods is 'no'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.allergic_to_foods is 'yes'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;
		</td>
		<td><em>Any foods, such as egg, milk or chocolate</em></td>
		
		<td align="right">
			<cfif get_health.allergic_to_other_drugs is 'no'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.allergic_to_other_drugs is 'yes'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;
		</td>
		<td><em>Any other drug or medication</em></td>
	</tr>
	<tr><td colspan="2"> &nbsp; <em>List: </em> &nbsp; #get_health.foods_list#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
		<td colspan="2"> &nbsp; <em>List: </em> &nbsp; #get_health.other_drugs_list#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
	</tr>
	<tr><td align="right">
			<cfif get_health.allergic_to_pets is 'no'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.allergic_to_pets is 'yes'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;
		</td>
		<td><em>Pets/Animals</em></td>
		
		<td align="right">
			<cfif get_health.other_allergies is 'no'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.other_allergies is 'yes'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;
		</td>
		<td><em>Any other allergies?</em></td>
	</tr>
	<tr><td colspan="2"> &nbsp; <em>Please explain.</em> &nbsp; #get_health.pets_list#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
		<td colspan="2"> &nbsp; <em>If yes, please list: </em> &nbsp; #get_health.other_allergies_list#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
	</tr>	
</table>

<!--- Psychological Issues --->
<table width="670" border=0 cellpadding=2 cellspacing=0 align="center">
	<tr><td colspan="6"><b>PSYCHOLOGICAL ISSUES</b> - <em>Have you ever suffered from and/or received treatment for any of the following psychological issues:</em></td></tr>
	
    <tr>
    	<!--- ADHD --->
    	<td width="90" align="right">
			<input type="radio" disabled="disabled" name="psychological_adhd" value="0" <cfif get_health.psychological_adhd EQ '0'>checked="yes"</cfif> onchange="DataChanged();">No
            <input type="radio" disabled="disabled" name="psychological_adhd" value="1" <cfif get_health.psychological_adhd EQ '1'>checked="yes"</cfif> onchange="DataChanged();">Yes 
         	&nbsp;
        </td>
        <td width="245"><em>Attention Deficit Hyperactivity Disorder (ADHD)</em></td>
        <!--- Impulse-control disorders --->
        <td width="90" align="right">
			<input type="radio" disabled="disabled" name="psychological_impulseControl" value="0" <cfif get_health.psychological_impulseControl EQ '0'>checked="yes"</cfif> onchange="DataChanged();">No
            <input type="radio" disabled="disabled" name="psychological_impulseControl" value="1" <cfif get_health.psychological_impulseControl EQ '1'>checked="yes"</cfif> onchange="DataChanged();">Yes 
         	&nbsp;
        </td>
        <td width="245"><em>Impulse-control disorders</em></td>
    </tr>
    <tr>
    	<!--- Anxiety disorders --->
    	<td width="90" align="right">
			<input type="radio" disabled="disabled" name="psychological_anxiety" value="0" <cfif get_health.psychological_anxiety EQ '0'>checked="yes"</cfif> onchange="DataChanged();">No
            <input type="radio" disabled="disabled" name="psychological_anxiety" value="1" <cfif get_health.psychological_anxiety EQ '1'>checked="yes"</cfif> onchange="DataChanged();">Yes 
         	&nbsp;
        </td>
        <td width="245"><em>Anxiety disorders</em></td>
        <!--- Dissociative disorders --->
    	<td width="90" align="right">
			<input type="radio" disabled="disabled" name="psychological_dissociative" value="0" <cfif get_health.psychological_dissociative EQ '0'>checked="yes"</cfif> onchange="DataChanged();">No
            <input type="radio" disabled="disabled" name="psychological_dissociative" value="1" <cfif get_health.psychological_dissociative EQ '1'>checked="yes"</cfif> onchange="DataChanged();">Yes 
         	&nbsp;
        </td>
        <td width="245"><em>Dissociative disorders</em></td>
    </tr>
  
    <tr>
    	<!--- Eating disorders --->
    	<td width="90" align="right">
			<input type="radio" disabled="disabled" name="eating_disorders" value="0" <cfif get_health.eating_disorders EQ '0'>checked="yes"</cfif> onchange="DataChanged();">No
            <input type="radio" disabled="disabled" name="eating_disorders" value="1" <cfif get_health.eating_disorders EQ '1'>checked="yes"</cfif> onchange="DataChanged();">Yes 
         	&nbsp;
        </td>
        <td width="245"><em>Eating disorders</em></td>
      <!--- Cutting disorders --->
    	<td width="90" align="right">
			<input type="radio" disabled="disabled" name="psychological_cutting" value="0" <cfif get_health.psychological_cutting EQ '0'>checked="yes"</cfif> onchange="DataChanged();">No
            <input type="radio" disabled="disabled" name="psychological_cutting" value="1" <cfif get_health.psychological_cutting EQ '1'>checked="yes"</cfif> onchange="DataChanged();">Yes 
         	&nbsp;
        </td>
        <td width="245"><em>Cutting behavior (Factitious disorders)</em></td>
    </tr>
 
    <tr>
    	<!--- Depression --->
    	<td width="90" align="right">
			<input type="radio" disabled="disabled" name="depression" value="0" <cfif get_health.depression EQ '0'>checked="yes"</cfif> onchange="DataChanged();">No
            <input type="radio" disabled="disabled" name="depression" value="1" <cfif get_health.depression EQ '1'>checked="yes"</cfif> onchange="DataChanged();">Yes 
         	&nbsp;
        </td>
        <td width="245"><em>Depression</em></td>
        <!--- Substance Abuse --->
        <td width="90" align="right">
			<input type="radio" disabled="disabled" name="psychological_substance" value="0" <cfif get_health.psychological_substance EQ '0'>checked="yes"</cfif> onchange="DataChanged();">No
            <input type="radio" disabled="disabled" name="psychological_substance" value="1" <cfif get_health.psychological_substance EQ '1'>checked="yes"</cfif> onchange="DataChanged();">Yes 
         	&nbsp;
        </td>
        <td width="245"><em>Substance Abuse</em></td>
    </tr>
     <tr>
    	<!--- Factitious disorders --->
    	<td width="90" align="right">
			<input type="radio" disabled="disabled" name="other_psycho" value="0" <cfif get_health.other_psycho EQ '0'>checked="yes"</cfif> onchange="DataChanged();">No
            <input type="radio" disabled="disabled" name="other_psycho" value="1" <cfif get_health.other_psycho EQ '1'>checked="yes"</cfif> onchange="DataChanged();">Yes 
         	&nbsp;
        </td>
        <td width="245"><em>Other</em></td>
        <td width="90"  colspan="3" ></td>
    </tr>
    <tr><td colspan="4"><em>If you answered yes to any of these, please provide a detailed explanation:</em></td></tr>
    <tr><td colspan="4">#get_health.medical_attention_reason#&nbsp;</td></tr>
    <tr><td colspan="4"><img src="#vStudentAppRelativePath#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>

</table>
<br><table width="660" border=0 cellpadding=1 cellspacing=0 align="center">
	<tr>
		<td colspan="3"><div align="justify">We certify that the information supplied is true and complete to the best or our knowledge.</div>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td width="315"><em>Signature of Student</em></td>
		<td width="40">&nbsp;</td>
		<td width="315"><em>Date</em></td>
	</tr>
	<tr>
		<td><br><img src="#vStudentAppRelativePath#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
		<td>&nbsp;</td>
		<td><br><img src="#vStudentAppRelativePath#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
	</tr>
	<tr>
		<td><em>Signature of Parent</em></td>
		<td>&nbsp;</td>
		<td><em>Date</em></td>
	</tr>	
	<tr>
		<td><br><img src="#vStudentAppRelativePath#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
		<td>&nbsp;</td>
		<td><br><img src="#vStudentAppRelativePath#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
	</tr>	
</table><br>
</div>

<!--- FOOTER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="8">
		<td width="8"><img src="#vStudentAppRelativePath#pics/p_bottonleft.gif" width="8"></td>
		<td width="100%" class="tablebotton"><img src="#vStudentAppRelativePath#pics/p_spacer.gif"></td>
		<td width="42"><img src="#vStudentAppRelativePath#pics/p_bottonright.gif" width="42"></td>
	</tr>
</table>

</cfoutput>

<cfif NOT LEN(URL.curdoc)>
</td></tr>
</table>
</cfif>

</body>
</html>