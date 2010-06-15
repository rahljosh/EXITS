<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>Page [11] - Health Questionnaire</title>
</head>
<body>

<cftry>

<!--- relocate users if they try to access the edit page without permission --->
<cfinclude template="../querys/get_latest_status.cfm">

<cfif (client.usertype EQ 10 AND (get_latest_status.status GTE 3 AND get_latest_status.status NEQ 4 AND get_latest_status.status NEQ 6))  <!--- STUDENT ---->
	OR (client.usertype EQ 11 AND (get_latest_status.status GTE 4 AND get_latest_status.status NEQ 6))  <!--- BRANCH ---->
	OR (client.usertype EQ 8 AND (get_latest_status.status GTE 6 AND get_latest_status.status NEQ 9)) <!--- INTL. AGENT ---->
	OR (client.usertype GTE 5 AND client.usertype LTE 7 OR client.usertype EQ 9)> <!--- FIELD --->
    <!--- Office users should be able to edit online apps --->
    <!--- OR (client.usertype LTE 4 AND get_latest_status.status GTE 7) <!--- OFFICE USERS ---> --->
	<cflocation url="?curdoc=section3/page11print&id=3&p=11" addtoken="no">
</cfif>

<script type="text/javascript">
<!--
function CheckLink()
{
  if (document.page11.CheckChanged.value != 0)
  {
    if (confirm("You have made changes on this page that have not been saved.\n\These changes will be lost if you navigate away from this page.\n\Click OK to contine and discard changes, or click cancel and click on save to save your changes."))
      return true;
    else
      return false;
  }
}
function DataChanged()
{
  document.page11.CheckChanged.value = 1;
}
function CheckFields() {
   if ((document.page11.been_hospitalized[1].checked) && (document.page11.hospitalized_reason.value == '')) {
		  alert("Please explain why have you been hospitalized?");
		  document.page11.hospitalized_reason.focus();
		  return false;
   } else if ((document.page11.good_health[0].checked) && (document.page11.good_health_reason.value == '')) {
		  alert("Please explain why have you not been in good general health?");
		  document.page11.good_health_reason.focus();
		  return false;
   } else if ((document.page11.allergic_to_foods[1].checked) && (document.page11.foods_list.value == '')) {
		  alert("Please list any food you are allergic of.");
		  document.page11.foods_list.focus();
		  return false;
   }  else if ((document.page11.allergic_to_pets[1].checked) && (document.page11.pets_list.value == '')) {
		  alert("Please list any animals you are allergic of.");
		  document.page11.pets_list.focus();
		  return false;
   }  else if ((document.page11.allergic_to_other_drugs[1].checked) && (document.page11.other_drugs_list.value == '')) {
		  alert("Please list any other drug or medication you are allergic of.");
		  document.page11.other_drugs_list.focus();
		  return false;
   } else if ((document.page11.other_allergies[1].checked) && (document.page11.other_allergies_list.value == '')) {
		  alert("Please list any other allergies.");
		  document.page11.other_allergies_list.focus();
		  return false;
   } else if (((document.page11.eating_disorders[1].checked) || (document.page11.depression[1].checked)) && (document.page11.medical_attention_reason.value == '')) {
		  alert("Please explain any medical attention.");
		  document.page11.medical_attention_reason.focus();
		  return false;
   }
}
function NextPage() {
	document.page11.action = '?curdoc=section3/qr_page11&next';
	}
//-->
</SCRIPT>

<cfinclude template="../querys/get_student_info.cfm">

<cfquery name="get_health" datasource="MySql">
	SELECT *
	FROM smg_student_app_health 
	WHERE studentid = '#get_student_info.studentid#'
</cfquery>

<cfif get_health.recordcount EQ 0>
	<cfquery name="insert_questions" datasource="MySql">
		INSERT INTO smg_student_app_health (studentid) VALUES ('#get_student_info.studentid#')
	</cfquery>
	<cfquery name="get_health" datasource="MySql">
		SELECT *
		FROM smg_student_app_health 
		WHERE studentid = '#get_student_info.studentid#'
	</cfquery>
</cfif> 

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="../pics/students.gif"></td>
		<td class="tablecenter"><h2>Page [11] - Health Questionnaire</h2></td>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section3/page11print.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		<td width="42" class="tableside"><img src="pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<cfform action="?curdoc=section3/qr_page11" name="page11" method="post" onSubmit="return CheckFields();">

<cfoutput query="get_student_info">

<cfinput type="hidden" name="studentid" value="#studentid#">
<cfinput type="hidden" name="CheckChanged" value="0">
<cfinput type="hidden" name="healthid" value="#get_health.healthid#">

<div class="section"><br>
		
<!--- MEDICAL HISTORY --->
<table width="670" border=0 cellpadding=2 cellspacing=0 align="center">
	<tr><td colspan="4"><b>MEDICAL HISTORY</b> - <em>Have you had?</em></td></tr>
	<tr><td width="90" align="right">
			<cfif get_health.had_measles EQ '0'><cfinput type="radio" name="had_measles" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="had_measles" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.had_measles EQ '1'><cfinput type="radio" name="had_measles" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="had_measles" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;
		</td>
		<td width="245"><em>Measles</em></td>
		<td width="90" align="right">
			<cfif get_health.had_diabetes EQ '0'><cfinput type="radio" name="had_diabetes" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="had_diabetes" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.had_diabetes EQ '1'><cfinput type="radio" name="had_diabetes" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="had_diabetes" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;			
		</td>
		<td width="245"><em>Diabetes</em></td>	
	</tr>
	<tr><td align="right">
			<cfif get_health.had_mumps EQ '0'><cfinput type="radio" name="had_mumps" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="had_mumps" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.had_mumps EQ '1'><cfinput type="radio" name="had_mumps" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="had_mumps" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;
		</td>
		<td><em>Mumps</em></td>
		<td align="right">
			<cfif get_health.had_cancer EQ '0'><cfinput type="radio" name="had_cancer" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="had_cancer" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.had_cancer EQ '1'><cfinput type="radio" name="had_cancer" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="had_cancer" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;	 
		</td>
		<td><em>Cancer</em></td>	
	</tr>
	<tr><td align="right">
			<cfif get_health.had_chickenpox EQ '0'><cfinput type="radio" name="had_chickenpox" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="had_chickenpox" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.had_chickenpox EQ '1'><cfinput type="radio" name="had_chickenpox" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="had_chickenpox" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;		
		</td>
		<td><em>Chickenpox</em></td>	
		<td align="right">
			<cfif get_health.had_broken_bones EQ '0'><cfinput type="radio" name="had_broken_bones" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="had_broken_bones" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.had_broken_bones EQ '1'><cfinput type="radio" name="had_broken_bones" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="had_broken_bones" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;		
		</td>
		<td><em>Broken Bones</em></td>		
	</tr>
	<tr><td align="right">
			<cfif get_health.had_epilepsy EQ '0'><cfinput type="radio" name="had_epilepsy" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="had_epilepsy" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.had_epilepsy EQ '1'><cfinput type="radio" name="had_epilepsy" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="had_epilepsy" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;		
		</td>
		<td><em>Epilepsy</em></td>	
		<td align="right">
			<cfif get_health.had_sexually_disease EQ '0'><cfinput type="radio" name="had_sexually_disease" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="had_sexually_disease" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.had_sexually_disease EQ '1'><cfinput type="radio" name="had_sexually_disease" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="had_sexually_disease" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;
		</td>
		<td><em>Sexually Transmitted Disease</em></td>
	</tr>
	<tr><td align="right">
			<cfif get_health.had_rubella EQ '0'><cfinput type="radio" name="had_rubella" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="had_rubella" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.had_rubella EQ '1'><cfinput type="radio" name="had_rubella" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="had_rubella" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;		
		</td>
		<td><em>Rubella</em></td>
		<td align="right">
			<cfif get_health.had_strokes EQ '0'><cfinput type="radio" name="had_strokes" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="had_strokes" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.had_strokes EQ '1'><cfinput type="radio" name="had_strokes" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="had_strokes" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;		
		</td>
		<td><em>Strokes / Cerebral Hemorrhage</td>
	</tr>
	<tr><td align="right">
			<cfif get_health.had_concussion EQ '0'><cfinput type="radio" name="had_concussion" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="had_concussion" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.had_concussion EQ '1'><cfinput type="radio" name="had_concussion" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="had_concussion" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;
		</td>
		<td><em>Concussion or Head Injuries</em></td>
		<td align="right">
			<cfif get_health.had_tuberculosis EQ '0'><cfinput type="radio" name="had_tuberculosis" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="had_tuberculosis" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.had_tuberculosis EQ '1'><cfinput type="radio" name="had_tuberculosis" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="had_tuberculosis" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;		
		</td>
		<td><em>Tuberculosis</em></td>		
	</tr>
	<tr><td align="right">
			<cfif get_health.had_rheumatic_fever EQ '0'><cfinput type="radio" name="had_rheumatic_fever" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="had_rheumatic_fever" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.had_rheumatic_fever EQ '1'><cfinput type="radio" name="had_rheumatic_fever" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="had_rheumatic_fever" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;
		</td>
		<td><em>Rheumatic Fever or Heart Disease</em></td>
		<td align="right">&nbsp;</td>
		<td>&nbsp;</td>	
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td align="right">
			<cfif get_health.been_hospitalized EQ '0'><cfinput type="radio" name="been_hospitalized" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="been_hospitalized" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.been_hospitalized EQ '1'><cfinput type="radio" name="been_hospitalized" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="been_hospitalized" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;		
		</td>
		<td colspan="3"><em>Have you ever been hospitalized, had surgery, or been under extended medical / psychological care? </em></td>
	</tr>
	<tr><td>&nbsp;</td>
		<td colspan="3"><em>If yes, please provide details and dates:</em> &nbsp; <cfinput type="text" name="hospitalized_reason" size="50" value="#get_health.hospitalized_reason#" onchange="DataChanged();"></td>
	</tr>	
</table><br>
<hr class="bar">
</hr><br>

<!--- SYSTEMIC REVIEW --->
<table width="670" border=0 cellpadding=2 cellspacing=0 align="center">
	<tr><td colspan="4"><b>SYSTEMIC REVIEW</b> - <em>Do you have the following?</em></td></tr>
	<tr><td colspan="2" align="left"><b>Eyes-Ears-Nose-Throat:</b></td>
		<td colspan="2" align="left"><b>Skin</b></td>
	</tr>
	<tr><td width="90" align="right">
			<cfif get_health.have_eye_disease EQ '0'><cfinput type="radio" name="have_eye_disease" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="have_eye_disease" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.have_eye_disease EQ '1'><cfinput type="radio" name="have_eye_disease" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="have_eye_disease" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;
		</td>
		<td width="245"><em>Eye disease or injury</em></td>
		<td width="90" align="right">
			<cfif get_health.have_skin_disease EQ '0'><cfinput type="radio" name="have_skin_disease" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="have_skin_disease" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.have_skin_disease EQ '1'><cfinput type="radio" name="have_skin_disease" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="have_skin_disease" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;		
		</td>
		<td width="245"><em>Skin disease, hives, eczema</em></td>	</tr>
	<tr><td align="right">
			<cfif get_health.wear_glasses EQ '0'><cfinput type="radio" name="wear_glasses" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="wear_glasses" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.wear_glasses EQ '1'><cfinput type="radio" name="wear_glasses" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="wear_glasses" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;		
		</td>
		<td><em>Do you wear glasses?</em></td>		
		<td align="right">
			<cfif get_health.have_jaundice EQ '0'><cfinput type="radio" name="have_jaundice" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="have_jaundice" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.have_jaundice EQ '1'><cfinput type="radio" name="have_jaundice" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="have_jaundice" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;		
		</td>
		<td><em>Jaundice</em></td>
	</tr>
	<tr><td align="right">
			<cfif get_health.have_double_vision EQ '0'><cfinput type="radio" name="have_double_vision" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="have_double_vision" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.have_double_vision EQ '1'><cfinput type="radio" name="have_double_vision" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="have_double_vision" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;		
		</td>
		<td><em>Double Vision</em></td>
		<td align="right">
			<cfif get_health.have_infection EQ '0'><cfinput type="radio" name="have_infection" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="have_infection" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.have_infection EQ '1'><cfinput type="radio" name="have_infection" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="have_infection" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;		
		</td>
		<td><em>Frequent infection or boils</em></td>
	</tr>
	<tr><td align="right">
			<cfif get_health.have_headaches EQ '0'><cfinput type="radio" name="have_headaches" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="have_headaches" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.have_headaches EQ '1'><cfinput type="radio" name="have_headaches" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="have_headaches" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;		
		</td>
		<td><em>Chronic Headaches</em></td>	
		<td align="right">
			<cfif get_health.have_pigmentation EQ '0'><cfinput type="radio" name="have_pigmentation" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="have_pigmentation" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.have_pigmentation EQ '1'><cfinput type="radio" name="have_pigmentation" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="have_pigmentation" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;		
		</td>
		<td><em>Abnormal pigmentation</em></td>	
	</tr>
	<tr><td align="right">
			<cfif get_health.have_glaucoma EQ '0'><cfinput type="radio" name="have_glaucoma" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="have_glaucoma" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.have_glaucoma EQ '1'><cfinput type="radio" name="have_glaucoma" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="have_glaucoma" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;		
		</td>
		<td><em>Glaucoma</em></td>
		<td colspan="2" align="left"><b>Neck:</b></td>
	</tr>
	<tr><td align="right">
			<cfif get_health.have_nosebleeds EQ '0'><cfinput type="radio" name="have_nosebleeds" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="have_nosebleeds" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.have_nosebleeds EQ '1'><cfinput type="radio" name="have_nosebleeds" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="have_nosebleeds" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;		
		</td>
		<td><em>Chronic Nosebleeds</em></td>
		<td align="right">
			<cfif get_health.have_stiffness EQ '0'><cfinput type="radio" name="have_stiffness" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="have_stiffness" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.have_stiffness EQ '1'><cfinput type="radio" name="have_stiffness" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="have_stiffness" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;		
		</td>
		<td><em>Stiffness</em></td>	
	</tr>
	<tr><td align="right">
			<cfif get_health.have_sinus EQ '0'><cfinput type="radio" name="have_sinus" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="have_sinus" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.have_sinus EQ '1'><cfinput type="radio" name="have_sinus" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="have_sinus" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;		
		</td>
		<td><em>Chronic sinus trouble</em></td>
		<td align="right">
			<cfif get_health.have_thyroid_trouble EQ '0'><cfinput type="radio" name="have_thyroid_trouble" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="have_thyroid_trouble" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.have_thyroid_trouble EQ '1'><cfinput type="radio" name="have_thyroid_trouble" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="have_thyroid_trouble" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;		
		</td>
		<td><em>Thyroid Trouble</em></td>
	</tr>
	<tr><td align="right">
			<cfif get_health.have_ear_disease EQ '0'><cfinput type="radio" name="have_ear_disease" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="have_ear_disease" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.have_ear_disease EQ '1'><cfinput type="radio" name="have_ear_disease" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="have_ear_disease" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;		
		</td>
		<td><em>Ear Disease</em></td>
		<td align="right">
			<cfif get_health.have_enlarged_glands EQ '0'><cfinput type="radio" name="have_enlarged_glands" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="have_enlarged_glands" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.have_enlarged_glands EQ '1'><cfinput type="radio" name="have_enlarged_glands" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="have_enlarged_glands" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;		
		</td>
		<td><em>Enlarged glands</em></td>	
	</tr>
	<tr><td align="right">
			<cfif get_health.have_impaired_hearing EQ '0'><cfinput type="radio" name="have_impaired_hearing" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="have_impaired_hearing" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.have_impaired_hearing EQ '1'><cfinput type="radio" name="have_impaired_hearing" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="have_impaired_hearing" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;
		</td>
		<td><em>Impaired hearing</em></td>
		<td colspan="2" align="left"><b>Respiratory: </b></td>
	</tr>
	<tr><td align="right">
			<cfif get_health.wear_hearing_aids EQ '0'><cfinput type="radio" name="wear_hearing_aids" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="wear_hearing_aids" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.wear_hearing_aids EQ '1'><cfinput type="radio" name="wear_hearing_aids" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="wear_hearing_aids" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;
		</td>
		<td><em>Do you wear hearing aids?</em></td>
		<td align="right">
			<cfif get_health.have_spitting_up_blood EQ '0'><cfinput type="radio" name="have_spitting_up_blood" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="have_spitting_up_blood" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.have_spitting_up_blood EQ '1'><cfinput type="radio" name="have_spitting_up_blood" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="have_spitting_up_blood" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;		
		</td>
		<td><em>Spitting up blood</em></td>	
	</tr>
	<tr><td align="right">
			<cfif get_health.have_dizziness EQ '0'><cfinput type="radio" name="have_dizziness" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="have_dizziness" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.have_dizziness EQ '1'><cfinput type="radio" name="have_dizziness" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="have_dizziness" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;			
		</td>
		<td><em>Dizziness</em></td>
		<td align="right">
			<cfif get_health.have_cough EQ '0'><cfinput type="radio" name="have_cough" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="have_cough" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.have_cough EQ '1'><cfinput type="radio" name="have_cough" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="have_cough" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;		
		</td>
		<td><em>Chronic or frequent cough</em></td>	
	</tr>
	<tr><td align="right">
			<cfif get_health.have_unconsciousness EQ '0'><cfinput type="radio" name="have_unconsciousness" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="have_unconsciousness" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.have_unconsciousness EQ '1'><cfinput type="radio" name="have_unconsciousness" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="have_unconsciousness" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;	 
		</td>
		<td><em>Episodes of unconsciousness</em></td>
		<td align="right">
			<cfif get_health.have_asthma EQ '0'><cfinput type="radio" name="have_asthma" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="have_asthma" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.have_asthma EQ '1'><cfinput type="radio" name="have_asthma" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="have_asthma" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;				
		</td>
		<td><em>Asthma</em></td>	
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td align="right">
			<cfif get_health.good_health EQ '0'><cfinput type="radio" name="good_health" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="good_health" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.good_health EQ '1'><cfinput type="radio" name="good_health" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="good_health" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;		
		</td>
		<td colspan="5"><em>Have you been in good general health most of your life? </em></td>
	</tr>
	<tr><td>&nbsp;</td>
		<td colspan="5"><em>If not, please explain.</em> &nbsp; <cfinput type="text" name="good_health_reason" size="50" value="#get_health.good_health_reason#" onchange="DataChanged();"></td>
	</tr>
</table><br>

<hr class="bar"></hr><br>

<!--- ALLERGIES AND SENSITIVITIES --->
<table width="670" border=0 cellpadding=2 cellspacing=0 align="center">
	<tr><td colspan="6"><b>ALLERGIES AND SENSITIVITIES</b> - <em>Is there a history of skin or other reaction or sickness following injections or oral administration of:</em></td></tr>
	<tr><td width="90" align="right">
			<cfif get_health.allergic_to_penicillin EQ '0'><cfinput type="radio" name="allergic_to_penicillin" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="allergic_to_penicillin" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.allergic_to_penicillin EQ '1'><cfinput type="radio" name="allergic_to_penicillin" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="allergic_to_penicillin" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;
		</td>
		<td width="245"><em>Penicillin or other antibiotics</em></td>
		
		<td width="90" align="right">
			<cfif get_health.allergic_to_novocaine EQ '0'><cfinput type="radio" name="allergic_to_novocaine" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="allergic_to_novocaine" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.allergic_to_novocaine EQ '1'><cfinput type="radio" name="allergic_to_novocaine" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="allergic_to_novocaine" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;
		</td>
		<td width="245"><em>Novocaine or other anesthetics</em></td>
	</tr>
	<tr><td align="right">
			<cfif get_health.allergic_to_morphine EQ '0'><cfinput type="radio" name="allergic_to_morphine" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="allergic_to_morphine" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.allergic_to_morphine EQ '1'><cfinput type="radio" name="allergic_to_morphine" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="allergic_to_morphine" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;
		</td>
		<td><em>Morphine, Codeine, Demerol, other narcotics</em></td>
		
		<td align="right">
			<cfif get_health.allergic_to_sulfa EQ '0'><cfinput type="radio" name="allergic_to_sulfa" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="allergic_to_sulfa" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.allergic_to_sulfa EQ '1'><cfinput type="radio" name="allergic_to_sulfa" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="allergic_to_sulfa" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;
		</td>
		<td><em>Sulfa drugs</em></td>
	</tr>
	<tr><td align="right">
			<cfif get_health.allergic_to_aspirin EQ '0'><cfinput type="radio" name="allergic_to_aspirin" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="allergic_to_aspirin" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.allergic_to_aspirin EQ '1'><cfinput type="radio" name="allergic_to_aspirin" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="allergic_to_aspirin" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;
		</td>
		<td><em>Aspirin, empirin or other pain remedies</em></td>
		
		<td align="right">
			<cfif get_health.allergic_to_adhesive EQ '0'><cfinput type="radio" name="allergic_to_adhesive" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="allergic_to_adhesive" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.allergic_to_adhesive EQ '1'><cfinput type="radio" name="allergic_to_adhesive" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="allergic_to_adhesive" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;
		</td>
		<td><em>Adhesive tape or latex</em></td>
	</tr>
	<tr><td align="right">
			<cfif get_health.allergic_to_tetanus EQ '0'><cfinput type="radio" name="allergic_to_tetanus" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="allergic_to_tetanus" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.allergic_to_tetanus EQ '1'><cfinput type="radio" name="allergic_to_tetanus" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="allergic_to_tetanus" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;
		</td>
		<td><em>Tetanus, antitoxin or other serums</em></td>
		
		<td align="right">
			<cfif get_health.allergic_to_iodine EQ '0'><cfinput type="radio" name="allergic_to_iodine" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="allergic_to_iodine" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.allergic_to_iodine EQ '1'><cfinput type="radio" name="allergic_to_iodine" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="allergic_to_iodine" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;
		</td>
		<td><em>Iodine or merthiolate</em></td>
	</tr>
	<tr><td align="right">
			<cfif get_health.allergic_to_foods EQ '0'><cfinput type="radio" name="allergic_to_foods" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="allergic_to_foods" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.allergic_to_foods EQ '1'><cfinput type="radio" name="allergic_to_foods" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="allergic_to_foods" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;
		</td>
		<td><em>Any foods, such as egg, milk or chocolate</em></td>
		
		<td align="right">
			<cfif get_health.allergic_to_other_drugs EQ '0'><cfinput type="radio" name="allergic_to_other_drugs" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="allergic_to_other_drugs" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.allergic_to_other_drugs EQ '1'><cfinput type="radio" name="allergic_to_other_drugs" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="allergic_to_other_drugs" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;
		</td>
		<td><em>Any other drug or medication</em></td>
	</tr>
	<tr><td colspan="2"> &nbsp; <em>List: </em> &nbsp; <cfinput type="text" name="foods_list" size="40" value="#get_health.foods_list#" onchange="DataChanged();"></td>
		<td colspan="2"> &nbsp; <em>List: </em> &nbsp; <cfinput type="text" name="other_drugs_list" size="40" value="#get_health.other_drugs_list#" onchange="DataChanged();"></td>
	</tr>
	<tr><td align="right">
			<cfif get_health.allergic_to_pets EQ '0'><cfinput type="radio" name="allergic_to_pets" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="allergic_to_pets" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.allergic_to_pets EQ '1'><cfinput type="radio" name="allergic_to_pets" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="allergic_to_pets" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;
		</td>
		<td><em>Pets/Animals</em></td>
		
		<td align="right">
			<cfif get_health.other_allergies EQ '0'><cfinput type="radio" name="other_allergies" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="other_allergies" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.other_allergies EQ '1'><cfinput type="radio" name="other_allergies" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="other_allergies" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;
		</td>
		<td><em>Any other allergies?</em></td>
	</tr>
	<tr><td colspan="2"> &nbsp; <em>Please explain.</em> &nbsp; <cfinput type="text" name="pets_list" size="30" value="#get_health.pets_list#" onchange="DataChanged();"></td>
		<td colspan="2"> &nbsp; <em>If yes, please list: </em> &nbsp; <cfinput type="text" name="other_allergies_list" size="30" value="#get_health.other_allergies_list#" onchange="DataChanged();"></td>
	</tr>	
	<tr><td>&nbsp;</td></tr>
	<tr><td colspan="4"><em>Have you ever received any medical attention or counseling for: </em></td></tr>
	<tr><td align="right">
			<cfif get_health.depression EQ '0'><cfinput type="radio" name="depression" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="depression" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.depression EQ '1'><cfinput type="radio" name="depression" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="depression" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;
		</td>
		<td><em>Depression</em></td>
		<td align="right">
			<cfif get_health.eating_disorders EQ '0'><cfinput type="radio" name="eating_disorders" value="0" checked="yes" onchange="DataChanged();">No <cfelse><cfinput type="radio" name="eating_disorders" value="0" onchange="DataChanged();">No</cfif>
			<cfif get_health.eating_disorders EQ '1'><cfinput type="radio" name="eating_disorders" value="1" checked="yes" onchange="DataChanged();">Yes <cfelse><cfinput type="radio" name="eating_disorders" value="1" onchange="DataChanged();">Yes</cfif> &nbsp;
		</td>
		<td><em>Eating Disorders</em></td>
	</tr>
	<tr><td colspan="4"> &nbsp; <em>Please explain if yes.</em> &nbsp; <cfinput type="text" name="medical_attention_reason" size="60" value="#get_health.medical_attention_reason#" onchange="DataChanged();"></td>
	</tr>	
</table><br>

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

</body>
</html>