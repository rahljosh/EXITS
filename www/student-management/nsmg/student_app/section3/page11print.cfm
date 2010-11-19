<cftry>

<cfif IsDefined('url.curdoc') OR IsDefined('url.path')>
	<cfset path = "">
<cfelseif IsDefined('url.exits_app')>
	<cfset path = "nsmg/student_app/">
<cfelse>
	<cfset path = "../">
</cfif>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" <cfoutput>href="#path#app.css"</cfoutput>>
	<title>Page [11] - Health Questionnaire</title>
</head>
<body <cfif not IsDefined('url.curdoc')>onLoad="print()"</cfif>>

<cfinclude template="../querys/get_student_info.cfm">

<cfquery name="get_health" datasource="MySql">
	SELECT *
	FROM smg_student_app_health 
	WHERE studentid = '#get_student_info.studentid#'
</cfquery>

<cfoutput query="get_student_info">

<cfif not IsDefined('url.curdoc')>
<table align="center" width=90% cellpadding=0 cellspacing=0  border=0 > 
<tr><td>
</cfif>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="#path#pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="#path#pics/students.gif"></td>
		<td class="tablecenter"><h2>Page [11] - Health Questionnaire</h2></td>
		<cfif IsDefined('url.curdoc')>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section3/page11print.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		</cfif>
		<td width="42" class="tableside"><img src="#path#pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section"><br>
		
<!--- MEDICAL HISTORY --->
<table width="660" border=0 cellpadding=1 cellspacing=0 align="center">
	<tr><td colspan="4"><b>MEDICAL HISTORY</b> - <em>Have you had?</em></td></tr>
	<tr><td width="90" align="right">
			<cfif get_health.had_measles is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.had_measles is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;
		</td>
		<td width="245"><em>Measles</em></td>
		<td width="90" align="right">
			<cfif get_health.had_diabetes is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.had_diabetes is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;			
		</td>
		<td width="245"><em>Diabetes</em></td>	
	</tr>
	<tr><td align="right">
			<cfif get_health.had_mumps is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.had_mumps is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;
		</td>
		<td><em>Mumps</em></td>
		<td align="right">
			<cfif get_health.had_cancer is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.had_cancer is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;	 
		</td>
		<td><em>Cancer</em></td>	
	</tr>
	<tr><td align="right">
			<cfif get_health.had_chickenpox is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.had_chickenpox is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;		
		</td>
		<td><em>Chickenpox</em></td>	
		<td align="right">
			<cfif get_health.had_broken_bones is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.had_broken_bones is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;		
		</td>
		<td><em>Broken Bones</em></td>		
	</tr>
	<tr><td align="right">
			<cfif get_health.had_epilepsy is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.had_epilepsy is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;		
		</td>
		<td><em>Epilepsy</em></td>	
		<td align="right">
			<cfif get_health.had_sexually_disease is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.had_sexually_disease is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;
		</td>
		<td><em>Sexually Transmitted Disease</em></td>
	</tr>
	<tr><td align="right">
			<cfif get_health.had_rubella is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.had_rubella is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;		
		</td>
		<td><em>Rubella</em></td>
		<td align="right">
			<cfif get_health.had_strokes is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.had_strokes is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;		
		</td>
		<td><em>Strokes</em></td>
	</tr>
	<tr><td align="right">
			<cfif get_health.had_concussion is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.had_concussion is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;
		</td>
		<td><em>Concussion or Head Injuries</em></td>
		<td align="right">
			<cfif get_health.had_tuberculosis is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.had_tuberculosis is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;		
		</td>
		<td><em>Tuberculosis</em></td>		
	</tr>
	<tr><td align="right">
			<cfif get_health.had_rheumatic_fever is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.had_rheumatic_fever is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;
		</td>
		<td><em>Rheumatic Fever or Heart Disease</em></td>
		<td align="right">&nbsp;</td>
		<td>&nbsp;</td>	
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td align="right">
			<cfif get_health.been_hospitalized is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.been_hospitalized is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;		
		</td>
		<td colspan="3"><em>Have you ever been hospitalized, had surgery, or been under extended medical care? </em></td>
	</tr>
	<tr><td>&nbsp;</td>
		<td colspan="3"><em>If yes, for what reason?</em> &nbsp; #get_health.hospitalized_reason#<br><img src="#path#pics/line.gif" width="500" height="1" border="0" align="absmiddle"></td>
	</tr>	
</table><br>

<!--- SYSTEMIC REVIEW --->
<table width="660" border=0 cellpadding=1 cellspacing=0 align="center">
	<tr><td colspan="4"><b>SYSTEMIC REVIEW</b> - <em>Do you have the following?</em></td></tr>
	<tr><td colspan="2" align="left"><b>Eyes-Ears-Nose-Throat:</b></td>
		<td colspan="2" align="left"><b>Skin</b></td>
	</tr>
	<tr><td width="90" align="right">
			<cfif get_health.have_eye_disease is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.have_eye_disease is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;
		</td>
		<td width="245"><em>Eye disease or injury</em></td>
		<td width="90" align="right">
			<cfif get_health.have_skin_disease is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.have_skin_disease is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> >Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;		
		</td>
		<td width="245"><em>Skin disease, hives, eczema</em></td>	</tr>
	<tr><td align="right">
			<cfif get_health.wear_glasses is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.wear_glasses is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;		
		</td>
		<td><em>Do you wear glasses?</em></td>		
		<td align="right">
			<cfif get_health.have_jaundice is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.have_jaundice is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;		
		</td>
		<td><em>Jaundice</em></td>
	</tr>
	<tr><td align="right">
			<cfif get_health.have_double_vision is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.have_double_vision is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;		
		</td>
		<td><em>Double Vision</em></td>
		<td align="right">
			<cfif get_health.have_infection is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.have_infection is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;		
		</td>
		<td><em>Frequent infection or boils</em></td>
	</tr>
	<tr><td align="right">
			<cfif get_health.have_headaches is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.have_headaches is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;		
		</td>
		<td><em>Headaches</em></td>	
		<td align="right">
			<cfif get_health.have_pigmentation is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.have_pigmentation is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;		
		</td>
		<td><em>Abnormal pigmentation</em></td>	
	</tr>
	<tr><td align="right">
			<cfif get_health.have_glaucoma is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.have_glaucoma is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;		
		</td>
		<td><em>Glaucoma</em></td>
		<td colspan="2" align="left"><b>Neck:</b></td>
	</tr>
	<tr><td align="right">
			<cfif get_health.have_nosebleeds is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.have_nosebleeds is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;		
		</td>
		<td><em>Nosebleeds</em></td>
		<td align="right">
			<cfif get_health.have_stiffness is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.have_stiffness is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;		
		</td>
		<td><em>Stiffness</em></td>	
	</tr>
	<tr><td align="right">
			<cfif get_health.have_sinus is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.have_sinus is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;		
		</td>
		<td><em>Chronic sinus trouble</em></td>
		<td align="right">
			<cfif get_health.have_thyroid_trouble is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.have_thyroid_trouble is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;		
		</td>
		<td><em>Thyroid Trouble</em></td>

	</tr>
	<tr><td align="right">
			<cfif get_health.have_ear_disease is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.have_ear_disease is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;		
		</td>
		<td><em>Ear Disease</em></td>
		<td align="right">
			<cfif get_health.have_enlarged_glands is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.have_enlarged_glands is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;		
		</td>
		<td><em>Enlarged glands</em></td>	
	</tr>
	<tr><td align="right">
			<cfif get_health.have_impaired_hearing is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.have_impaired_hearing is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;
		</td>
		<td><em>Impaired hearing</em></td>
		<td colspan="2" align="left"><b>Respiratory: </b></td>
	</tr>
	<tr><td align="right">
			<cfif get_health.wear_hearing_aids is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.wear_hearing_aids is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;
		</td>
		<td><em>Do you wear hearing aids?</em></td>
		<td align="right">
			<cfif get_health.have_spitting_up_blood is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.have_spitting_up_blood is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;		
		</td>
		<td><em>Spitting up blood</em></td>	
	</tr>
	<tr><td align="right">
			<cfif get_health.have_dizziness is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.have_dizziness is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;			
		</td>
		<td><em>Dizziness</em></td>
		<td align="right">
			<cfif get_health.have_cough is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.have_cough is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;		
		</td>
		<td><em>Chronic or frequent cough</em></td>	
	</tr>
	<tr><td align="right">
			<cfif get_health.have_unconsciousness is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.have_unconsciousness is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;	 
		</td>
		<td><em>Episodes of unconsciousness</em></td>
		<td align="right">
			<cfif get_health.have_asthma is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.have_asthma is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;				
		</td>
		<td><em>Asthma</em></td>	
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td align="right">
			<cfif get_health.good_health is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.good_health is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;		
		</td>
		<td colspan="5"><em>Have you been in good general health most of your life? </em></td>
	</tr>
	<tr><td>&nbsp;</td>
		<td colspan="5"><em>If not, please explain.</em> &nbsp; #get_health.good_health_reason#<br><img src="#path#pics/line.gif" width="500" height="1" border="0" align="absmiddle"></td>
	</tr>
</table><br>

<!--- ALLERGIES AND SENSITIVITIES --->
<table width="660" border=0 cellpadding=1 cellspacing=0 align="center">
	<tr><td colspan="6"><b>ALLERGIES AND SENSITIVITIES</b> - <em>Is there a history of skin or other reaction or sickness following injections or oral administration of:</em></td></tr>
	<tr><td width="90" align="right">
			<cfif get_health.allergic_to_penicillin is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.allergic_to_penicillin is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;
		</td>
		<td width="245"><em>Penicillin or other antibiotics</em></td>
		
		<td width="90" align="right">
			<cfif get_health.allergic_to_novocaine is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.allergic_to_novocaine is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;
		</td>
		<td width="245"><em>Novocaine or other anesthetics</em></td>
	</tr>
	<tr><td align="right">
			<cfif get_health.allergic_to_morphine is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.allergic_to_morphine is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;
		</td>
		<td><em>Morphine, Codeine, Demerol, other narcotics</em></td>
		
		<td align="right">
			<cfif get_health.allergic_to_sulfa is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.allergic_to_sulfa is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;
		</td>
		<td><em>Sulfa drugs</em></td>
	</tr>
	<tr><td align="right">
			<cfif get_health.allergic_to_aspirin is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.allergic_to_aspirin is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;
		</td>
		<td><em>Aspirin, empirin or other pain remedies</em></td>
		
		<td align="right">
			<cfif get_health.allergic_to_adhesive is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.allergic_to_adhesive is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;
		</td>
		<td><em>Adhesive tape or latex</em></td>
	</tr>
	<tr><td align="right">
			<cfif get_health.allergic_to_tetanus is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.allergic_to_tetanus is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;
		</td>
		<td><em>Tetanus, antitoxin or other serums</em></td>
		
		<td align="right">
			<cfif get_health.allergic_to_iodine is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.allergic_to_iodine is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;
		</td>
		<td><em>Iodine or merthiolate</em></td>
	</tr>
	<tr><td align="right">
			<cfif get_health.allergic_to_foods is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.allergic_to_foods is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;
		</td>
		<td><em>Any foods, such as egg, milk or chocolate</em></td>
		
		<td align="right">
			<cfif get_health.allergic_to_other_drugs is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.allergic_to_other_drugs is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;
		</td>
		<td><em>Any other drug or medication</em></td>
	</tr>
	<tr><td colspan="2"> &nbsp; <em>List: </em> &nbsp; #get_health.foods_list#<br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
		<td colspan="2"> &nbsp; <em>List: </em> &nbsp; #get_health.other_drugs_list#<br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
	</tr>
	<tr><td align="right">
			<cfif get_health.allergic_to_pets is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.allergic_to_pets is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;
		</td>
		<td><em>Pets/Animals</em></td>
		
		<td align="right">
			<cfif get_health.other_allergies is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.other_allergies is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;
		</td>
		<td><em>Any other allergies?</em></td>
	</tr>
	<tr><td colspan="2"> &nbsp; <em>Please explain.</em> &nbsp; #get_health.pets_list#<br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
		<td colspan="2"> &nbsp; <em>If yes, please list: </em> &nbsp; #get_health.other_allergies_list#<br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
	</tr>	
	<tr><td>&nbsp;</td></tr>
	<tr><td colspan="4"><em>Have you ever received any medical attention or counseling for: </em></td></tr>
	<tr><td align="right">
			<cfif get_health.depression is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.depression is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;
		</td>
		<td><em>Depression</em></td>
		<td align="right">
			<cfif get_health.eating_disorders is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<cfif get_health.eating_disorders is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif> &nbsp;
		</td>
		<td><em>Eating Disorders</em></td>
	</tr>
	<tr><td colspan="4"> &nbsp; <em>Please explain if yes.</em> &nbsp; #get_health.medical_attention_reason#<br><img src="#path#pics/line.gif" width="660" height="1" border="0" align="absmiddle"></td>
	</tr>	
</table><br><br>

</div>

<!--- FOOTER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="8">
		<td width="8"><img src="#path#pics/p_bottonleft.gif" width="8"></td>
		<td width="100%" class="tablebotton"><img src="#path#pics/p_spacer.gif"></td>
		<td width="42"><img src="#path#pics/p_bottonright.gif" width="42"></td>
	</tr>
</table>

</cfoutput>

<cfif not IsDefined('url.curdoc')>
</td></tr>
</table>
</cfif>

</body>
</html>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>