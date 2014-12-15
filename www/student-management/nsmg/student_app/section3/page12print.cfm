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

<cfset doc = 'page12'>

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
		<td class="tablecenter"><h2>Page [12] - Clinical Evaluation</h2></td>
		<cfif LEN(URL.curdoc)>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section3/page12print.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		</cfif>
		<td width="42" class="tableside"><img src="#vStudentAppRelativePath#pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section"><br>

<cfif LEN(URL.curdoc)>
	<cfinclude template="../check_upl_print_file.cfm">
</cfif>

<table width="660" border=0 cellpadding=1 cellspacing=0 align="center">
	<tr><td align="center" colspan="7"><b>To Be Filled Out by Family Physician</b></td></tr>

	<tr><td colspan="7"><b>MEASUREMENTS AND OTHER FINDINGS</b></td></tr>
	
	<tr><td width="10">&nbsp;</td>
		<td width="80" align="right"><em>Height:</em> </td>
		<td width="130">#get_student_info.height# &nbsp;<em>feet/inches</em><br><img src="#vStudentAppRelativePath#pics/line.gif" width="120" height="1" border="0" align="absmiddle"></td>
		
		<td width="110" align="right"><em>Weight:</em></td>
		<td width="120">#get_student_info.weight# &nbsp;<em>lbs</em><br><img src="#vStudentAppRelativePath#pics/line.gif" width="110" height="1" border="0" align="absmiddle"></td>

		<td width="90" align="right"><em>Build:</em></td>
		<td width="130">#get_health.clinical_build#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="120" height="1" border="0" align="absmiddle"></td>
	</tr>
	<tr><td>&nbsp;</td>
		<td align="right"><em>Color Hair:</em></td> 
		<td>#get_student_info.haircolor#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="120" height="1" border="0" align="absmiddle"></td>

		<td align="right"><em>Color Eyes:</em> </td>
		<td>#get_student_info.eyecolor#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="110" height="1" border="0" align="absmiddle"></td>
		
		<td colspan="2">&nbsp;</td>
	</tr>
</table><br>

<table width="660" border=0 cellpadding=1 cellspacing=0 align="center">
	<tr>
		<td width="48%" valign="top">
			<table border=1 cellpadding=1 cellspacing=0 width="100%">
				<tr><td width="180" align="center"><em>Check each item</em></td>
					<td width="70" align="center"><em>Normal</em></td>
					<td width="70" align="center"><em>Abnormal</em></td></tr>
				<tr><td>&nbsp; Head, Face, Neck, Scalp</td>
					<td align="center"><cfif get_health.clinical_head is 'normal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
					<td align="center"><cfif get_health.clinical_head is 'abnormal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td></tr>
				<tr><td>&nbsp; Nose</td>
					<td align="center"><cfif get_health.clinical_nose is 'normal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
					<td align="center"><cfif get_health.clinical_nose is 'abnormal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td></tr>
				<tr><td>&nbsp; Sinuses</td>
					<td align="center"><cfif get_health.clinical_sinuses is 'normal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
					<td align="center"><cfif get_health.clinical_sinuses is 'abnormal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
				<tr><td>&nbsp; Mouth and Throat</td>
					<td align="center"><cfif get_health.clinical_mouth is 'normal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
					<td align="center"><cfif get_health.clinical_mouth is 'abnormal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
				<tr><td>&nbsp; Ears - General (int. & ext.)</td>
					<td align="center"><cfif get_health.clinical_ears is 'normal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
					<td align="center"><cfif get_health.clinical_ears is 'abnormal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
				<tr><td>&nbsp; Drums (perforated)</td>
					<td align="center"><cfif get_health.clinical_drums is 'normal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
					<td align="center"><cfif get_health.clinical_drums is 'abnormal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
				<tr><td>&nbsp; Eyes</td>
					<td align="center"><cfif get_health.clinical_eyes is 'normal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
					<td align="center"><cfif get_health.clinical_eyes is 'abnormal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
				<tr><td>&nbsp; Ophthalmoscopic</td>
					<td align="center"><cfif get_health.clinical_ophthal is 'normal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
					<td align="center"><cfif get_health.clinical_ophthal is 'abnormal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
				<tr><td>&nbsp; Pupils</td>
					<td align="center"><cfif get_health.clinical_pupils is 'normal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
					<td align="center"><cfif get_health.clinical_pupils is 'abnormal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
				<tr><td>&nbsp; Ocular Motility</td>
					<td align="center"><cfif get_health.clinical_ocular is 'normal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
					<td align="center"><cfif get_health.clinical_ocular is 'abnormal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
				<tr><td>&nbsp; Lungs and Chest</td>
					<td align="center"><cfif get_health.clinical_lungs is 'normal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
					<td align="center"><cfif get_health.clinical_lungs is 'abnormal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
				<tr><td>&nbsp; Heart</td>
					<td align="center"><cfif get_health.clinical_heart is 'normal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
					<td align="center"><cfif get_health.clinical_heart is 'abnormal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
				<tr><td>&nbsp; Vascular System</td>
					<td align="center"><cfif get_health.clinical_vascular is 'normal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
					<td align="center"><cfif get_health.clinical_vascular is 'abnormal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
				<tr><td>&nbsp; Abdomen and Viscera</td>
					<td align="center"><cfif get_health.clinical_abdomen is 'normal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
					<td align="center"><cfif get_health.clinical_abdomen is 'abnormal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
			</table>	
		</td>
		<td width="4%">&nbsp;</td>
		<td width="48%" valign="top" align="left">
			<table border=1 cellpadding=1 cellspacing=0 width="100%">
				<tr><td width="180" align="center"><em>Check each item</em></td>
					<td width="70" align="center"><em>Normal</em></td>
					<td width="70" align="center"><em>Abnormal</em></td></tr>
				<tr><td>&nbsp; Anus and Rectum</td>
					<td align="center"><cfif get_health.clinical_anus is 'normal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
					<td align="center"><cfif get_health.clinical_anus is 'abnormal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
				<tr><td>&nbsp; Endocrine System</td>
					<td align="center"><cfif get_health.clinical_endocrine is 'normal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
					<td align="center"><cfif get_health.clinical_endocrine is 'abnormal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
				<tr><td>&nbsp; G - U System</td>
					<td align="center"><cfif get_health.clinical_gusystem is 'normal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
					<td align="center"><cfif get_health.clinical_gusystem is 'abnormal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
				<tr><td>&nbsp; Upper Extremities</td>
					<td align="center"><cfif get_health.clinical_upper is 'normal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
					<td align="center"><cfif get_health.clinical_upper is 'abnormal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
				<tr><td>&nbsp; Feet</td>
					<td align="center"><cfif get_health.clinical_feet is 'normal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
					<td align="center"><cfif get_health.clinical_feet is 'abnormal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
				<tr><td>&nbsp; Lower Extremities</td>
					<td align="center"><cfif get_health.clinical_lower is 'normal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
					<td align="center"><cfif get_health.clinical_lower is 'abnormal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
				<tr><td>&nbsp; Spine, other Musculoskeletal</td>
					<td align="center"><cfif get_health.clinical_spine is 'normal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
					<td align="center"><cfif get_health.clinical_spine is 'abnormal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
				<tr><td>&nbsp; Body Marks, Scars, Tatoos</td>
					<td align="center"><cfif get_health.clinical_body is 'normal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
					<td align="center"><cfif get_health.clinical_body is 'abnormal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
				<tr><td>&nbsp; Skin, Lymphatics</td>
					<td align="center"><cfif get_health.clinical_skin is 'normal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
					<td align="center"><cfif get_health.clinical_skin is 'abnormal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
				<tr><td>&nbsp; Neurologic</td>
					<td align="center"><cfif get_health.clinical_neurology is 'normal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
					<td align="center"><cfif get_health.clinical_neurology is 'abnormal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
				<tr><td>&nbsp; Psychiatric</td>
					<td align="center"><cfif get_health.clinical_psychiatric is 'normal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
					<td align="center"><cfif get_health.clinical_psychiatric is 'abnormal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
				<tr><td>&nbsp; Pelvic (female only) &nbsp;  &nbsp;&nbsp; &nbsp;
						<cfif get_health.clinical_pelvic_type is 'vaginal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif>  vaginal or 
						<cfif get_health.clinical_pelvic_type is 'vaginal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif>  rectal <br><br></td>
					<td align="center"><cfif get_health.clinical_pelvic is 'normal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
					<td align="center"><cfif get_health.clinical_pelvic is 'abnormal'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif></td>
			</table>	
		</td>
	</tr>	
</table>
<table width="660" border=0 cellpadding=2 cellspacing=0 align="center">
  <tr >
    <td width="20%" align="left" colspan="0"><span class="style3">Medical Notes:</span></td>
    <td width="100%">#get_health.med_notes#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="400" height="1" border="0" align="absmiddle"></td>
  </tr>
  </table><br>


<table width="660" border=0 cellpadding=1 cellspacing=0 align="center">
	<tr><td colspan="7"><b>BLOOD PRESSURE</b></td></tr>
	<tr><td width="">&nbsp;</td>
		<td width="" align="right"><em>Sitting:</em></td>
		<td width="">#get_health.clinical_blood_sitting#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="50" height="1" border="0" align="absmiddle"></td>
		
		<td width="" align="right"><em>Recumbent:</em></td>
		<td width="" >#get_health.clinical_blood_recumbent#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="50" height="1" border="0" align="absmiddle"></td>
		
		<td width="" align="right"><em>Standing:</em></td>
		<td width="">#get_health.clinical_blood_standing#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="50" height="1" border="0" align="absmiddle"></td></tr>
	
	
	
	<tr><td colspan="7"><b>PULSE</b> (arm at heart level)</td></tr>
	<tr><td>&nbsp;</td>
		<td align="right"><em>Sitting: </em></td>
		<td>#get_health.clinical_pulse_sitting#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="50" height="1" border="0" align="absmiddle"></td>
		
		<td align="right"><em>After Exercise:</em></td>
		<td>#get_health.clinical_pulse_exercise#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="50" height="1" border="0" align="absmiddle"></td>

		<td align="right"><em>2 Minutes After:</em></td>
		<td>#get_health.clinical_pulse_2min#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="50" height="1" border="0" align="absmiddle"></td></tr>

	<tr><td>&nbsp;</td>
		<td align="right"><em>Recumbent: </em> </td>
		<td>#get_health.clinical_pulse_recumbent#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="50" height="1" border="0" align="absmiddle"></td>
		
		<td  align="right" width=200><em>After Standing 3 Minutes: </em></td><td>#get_health.clinical_pulse_3min#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="50" height="1" border="0" align="absmiddle"></td></tr>
</table>

<table width="660" border=0 cellpadding=1 cellspacing=0 align="center">
	<tr><td colspan="5"><b>LABORATORY FINDINGS</b></td></tr>
	<tr><td width="40">&nbsp;</td>
		<td width="300"><em>Urinalysis (A.Specific Gravity):</em></td>	
		<td width="170"><em>Albumin: &nbsp;</em> #get_health.clinical_lab_albumin# <br><img src="#vStudentAppRelativePath#pics/line.gif" width="160" height="1" border="0" align="absmiddle"></td>
		<td width="160"><em>Sugar: &nbsp; </em> #get_health.clinical_lab_sugar# <br><img src="#vStudentAppRelativePath#pics/line.gif" width="150" height="1" border="0" align="absmiddle"></td>
	</tr>
	<tr><td>&nbsp;</td>
		<td><em>Serology &nbsp;(Specify Test): &nbsp;</em> #get_health.clinical_lab_serology#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="290" height="1" border="0" align="absmiddle"></td>
		<td colspan="2"><em>Blood Type & RH Factor: &nbsp;</em> #get_health.clinical_lab_blood#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="320" height="1" border="0" align="absmiddle"></td>
	</tr>
	<tr><td>&nbsp;</td>
		<td><em>Tuberculosis (Clearance must be within 6 months)</em></td>
		<td colspan="2"><em>BCG (TB Vaccine) Date: &nbsp; </em> #DateFormat(get_health.clinical_lab_bcg, 'mm/dd/yyyy')#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="320" height="1" border="0" align="absmiddle"></td></tr>
	</tr>
	<tr><td>&nbsp;</td>
		<td><em>Skin Test Date: &nbsp;</em>#DateFormat(get_health.clinical_lab_skin_test, 'mm/dd/yyyy')# <br><img src="#vStudentAppRelativePath#pics/line.gif" width="290" height="1" border="0" align="absmiddle"></td>
		<td colspan="2"><em>Result: &nbsp;</em>
						<cfif get_health.clinical_lab_skin_result is 'positive'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> Positive <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> Positive</cfif>
						<cfif get_health.clinical_lab_skin_result is 'negative'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> Negative <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> Negative</cfif> &nbsp;
						<br><img src="#vStudentAppRelativePath#pics/line.gif" width="320" height="1" border="0" align="absmiddle"></td>
	</tr>
	<tr><td>&nbsp;</td>
		<td><em>Chest X-Ray Date: &nbsp;</em>#DateFormat(get_health.clinical_lab_xray, 'mm/dd/yyyy')#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="290" height="1" border="0" align="absmiddle"></td>
		<td colspan="2"><em>Result: &nbsp;</em>
						<cfif get_health.clinical_lab_xray_result is 'positive'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> Positive <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> Positive</cfif>
						<cfif get_health.clinical_lab_xray_result is 'negative'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> Negative <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> Negative</cfif> &nbsp;
						<br><img src="#vStudentAppRelativePath#pics/line.gif" width="320" height="1" border="0" align="absmiddle"></td>
	</tr>
	<tr><td colspan="2">&nbsp;</td>
		<td colspan="2"><small>(NB! if positive, chest x-ray information mandatory)</small></td></tr>
</table>

<br/>

<table width="660" border=0 cellpadding=1 cellspacing=0 align="center">
	<tr>
    	<td colspan="3">
        	Are you aware on any physical or psychological condition that the student may have that would impact their ability to travel to the United States to participate in a high school exchange program ?
        </td>
    </tr>
    <tr>
    <td width="40"><input type="checkbox"> No </td><td width="140"><input type="checkbox"> Yes (please explain):</td><Td><br><img src="#vStudentAppRelativePath#pics/line.gif" width="480" height="1" border="0" align="absmiddle"></td>
   
    <tr><td>&nbsp;</td></tr>
</table>
<table width="660" border=0 cellpadding=1 cellspacing=0 align="center">
	<tr>
    	<td width="315"><em>Physician's Name</em><img src="#vStudentAppRelativePath#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
    	<td width="40">&nbsp;</td>
        <td width="315"><em>Date</em> <img src="#vStudentAppRelativePath#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
    </tr>
	<tr>
    	<td>&nbsp;</td>
   </tr>
	<tr>
    	<td width="315"><em>Physician's Signature</em><img src="#vStudentAppRelativePath#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
        <td width="40">&nbsp;</td>
        <td width="315"><em>Date</em> <img src="#vStudentAppRelativePath#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
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
<cfinclude template="../print_include_file.cfm">
</cfif>

</body>
</html>