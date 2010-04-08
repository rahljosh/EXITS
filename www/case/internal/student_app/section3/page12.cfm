<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>Page [12] - Clinical Evaluation</title>
</head>
<body>

<cftry>

<!--- relocate users if they try to access the edit page without permission --->
<cfinclude template="../querys/get_latest_status.cfm">

<cfif (client.usertype EQ '10' AND (get_latest_status.status GTE '3' AND get_latest_status.status NEQ '4' AND get_latest_status.status NEQ '6'))  <!--- STUDENT ---->
	OR (client.usertype EQ '11' AND (get_latest_status.status GTE '4' AND get_latest_status.status NEQ '6'))  <!--- BRANCH ---->
	OR (client.usertype EQ '8' AND (get_latest_status.status GTE '6' AND get_latest_status.status NEQ '9')) <!--- INTL. AGENT ---->
	OR (client.usertype LTE '4' AND get_latest_status.status GTE '7') <!--- OFFICE USERS --->
	OR (client.usertype GTE '5' AND client.usertype LTE '7' OR client.usertype EQ '9')> <!--- FIELD --->
	<cflocation url="?curdoc=section3/page12print&id=3&p=12" addtoken="no">
</cfif>

<SCRIPT>
<!-- hide script
function CheckLink()
{
  if (document.page12.CheckChanged.value != 0)
  {
    if (confirm("You have made changes on this page that have not been saved.\n\These changes will be lost if you navigate away from this page.\n\Click OK to contine and discard changes, or click cancel and click on save to save your changes."))
      return true;
    else
      return false;
  }
}
function DataChanged()
{
  document.page12.CheckChanged.value = 1
}

function calc(val,factor,putin) { 
if (val == "") {
	val = "0"
}

evalstr = "document.page12."+putin+ ".value = "
evalstr = evalstr + Math.round((val * factor)*100)/100;
eval(evalstr)
}
function NextPage() {
	document.page12.action = '?curdoc=section3/qr_page12&next';
	}
//-->
</SCRIPT>

<cfinclude template="../querys/get_student_info.cfm">

<cfset doc = 'page12'>

<cfquery name="get_health" datasource="caseusa">
	SELECT *
	FROM smg_student_app_health 
	WHERE studentid = '#get_student_info.studentid#'
</cfquery>

<cfif get_health.recordcount EQ 0>
	<cfquery name="insert_questions" datasource="caseusa">
		INSERT INTO smg_student_app_health (studentid) VALUES ('#get_student_info.studentid#')
	</cfquery>
	<cfquery name="get_health" datasource="caseusa">
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
		<td class="tablecenter"><h2>Page [12] - Clinical Evaluation</h2></td>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section3/page12print.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		<td width="42" class="tableside"><img src="pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<cfform action="?curdoc=section3/qr_page12" method="post" name="page12">

<cfoutput query="get_student_info">

<cfinput type="hidden" name="studentid" value="#studentid#">
<cfinput type="hidden" name="CheckChanged" value="0">
<cfinput type="hidden" name="healthid" value="#get_health.healthid#">

<div class="section"><br>

<!--- Check uploaded file - Upload File Button --->
<cfinclude template="../check_uploaded_file.cfm">

<table width="670" border=0 cellpadding=2 cellspacing=0 align="center">
	<tr><td colspan="7"><b>MEASUREMENTS AND OTHER FINDINGS</b></td></tr>
	
	<tr><td width="10">&nbsp;</td>
		<td width="80" align="right"><em>Height:</em> </td>
		<td width="130"><cfinput type="text" name="heightcm" size="8" validate="integer" message="Please, enter only number on Height cm statement" onChange = "DataChanged();calc(this.value,0.032808399,'height')">&nbsp;<em>cm or</em></td>
		
		<td width="110" align="right"><em>Weight:</em></td>
		<td width="120"><cfinput type="text" name="weightkg" size="8" onchange="DataChanged();calc(this.value,2.2046,'weight')">&nbsp;<em>kg or</em></td>

		<td width="90" align="right"><em>Build:</em></td>
		<td width="130"><select name="clinical_build" onchange="DataChanged();">
							<option value="0"></option>
							<option value="slender" <cfif get_health.clinical_build EQ 'slender'>selected</cfif> >Slender</option>
							<option value="average" <cfif get_health.clinical_build EQ 'average'>selected</cfif> >Average</option>
							<option value="heavy" <cfif get_health.clinical_build EQ 'heavy'>selected</cfif> >Heavy</option>
						</select></td></tr>
						
	<tr><td colspan="2"></td><td><cfinput type="text" name="height" size="8" value="#get_student_info.height#" maxlength="4" onchange="DataChanged();calc(this.value,30.48,'heightcm');">&nbsp;<em>inches</em></td>
		<td>&nbsp;</td><td colspan="3"><cfinput type="text" name="weight" size="8" value="#get_student_info.weight#" maxlength="6" onchange="DataChanged();calc(this.value,0.453592,'weightkg');">&nbsp;<em>lbs</em></td></tr>
	<tr><td colspan="2"></td><td colspan="5"><em>Enter only numbers in appropriate boxes above eg. 180 for cm and 80 for kg.</em></td></tr>

	<tr><td>&nbsp;</td>
		<td align="right"><em>Color Hair:</em></td> 
		<td><cfinput type="text" name="haircolor" size="11" value="#get_student_info.haircolor#" onchange="DataChanged();" maxlength="11"></td>

		<td align="right"><em>Color Eyes:</em> </td>
		<td><cfinput type="text" name="eyecolor" size="11" value="#get_student_info.eyecolor#" onchange="DataChanged();" maxlength="11"></td>
		
		<td colspan="2">&nbsp;</td>
	</tr>
</table><br>

<hr class="bar"></hr><br>

<table width="670" border=0 cellpadding=2 cellspacing=0 align="center">
	<tr><td align="center" colspan="3"><b>To Be Filled Out by Family Physician</b></td></tr>
	<tr>
		<td width="48%" valign="top">
			<table border=1 cellpadding=2 cellspacing=0 width="100%">
				<tr><td width="180" align="center"><em>Check each item</em></td>
					<td width="70" align="center"><em>Normal</em></td>
					<td width="70" align="center"><em>Abnormal</em></td></tr>
				<tr><td>&nbsp; Head, Face, Neck, Scalp</td>
					<td align="center"><cfif get_health.clinical_head is 'normal'><cfinput type="radio" name="clinical_head" value="Normal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_head" value="Normal" onchange="DataChanged();"></cfif></td>
					<td align="center"><cfif get_health.clinical_head is 'abnormal'><cfinput type="radio" name="clinical_head" value="Abnormal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_head" value="Abnormal" onchange="DataChanged();"></cfif></td></tr>
				<tr><td>&nbsp; Nose</td>
					<td align="center"><cfif get_health.clinical_nose is 'normal'><cfinput type="radio" name="clinical_nose" value="Normal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_nose" value="Normal" onchange="DataChanged();"></cfif></td>
					<td align="center"><cfif get_health.clinical_nose is 'abnormal'><cfinput type="radio" name="clinical_nose" value="Abnormal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_nose" value="Abnormal" onchange="DataChanged();"></cfif></td></tr>
				<tr><td>&nbsp; Sinuses</td>
					<td align="center"><cfif get_health.clinical_sinuses is 'normal'><cfinput type="radio" name="clinical_sinuses" value="Normal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_sinuses" value="Normal" onchange="DataChanged();"></cfif></td>
					<td align="center"><cfif get_health.clinical_sinuses is 'abnormal'><cfinput type="radio" name="clinical_sinuses" value="Abnormal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_sinuses" value="Abnormal" onchange="DataChanged();"></cfif></td>
				<tr><td>&nbsp; Mouth and Throat</td>
					<td align="center"><cfif get_health.clinical_mouth is 'normal'><cfinput type="radio" name="clinical_mouth" value="Normal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_mouth" value="Normal" onchange="DataChanged();"></cfif></td>
					<td align="center"><cfif get_health.clinical_mouth is 'abnormal'><cfinput type="radio" name="clinical_mouth" value="Abnormal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_mouth" value="Abnormal" onchange="DataChanged();"></cfif></td>
				<tr><td>&nbsp; Ears - General (int. & ext.)</td>
					<td align="center"><cfif get_health.clinical_ears is 'normal'><cfinput type="radio" name="clinical_ears" value="Normal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_ears" value="Normal" onchange="DataChanged();"></cfif></td>
					<td align="center"><cfif get_health.clinical_ears is 'abnormal'><cfinput type="radio" name="clinical_ears" value="Abnormal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_ears" value="Abnormal" onchange="DataChanged();"></cfif></td>
				<tr><td>&nbsp; Drums (perforated)</td>
					<td align="center"><cfif get_health.clinical_drums is 'normal'><cfinput type="radio" name="clinical_drums" value="Normal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_drums" value="Normal" onchange="DataChanged();"></cfif></td>
					<td align="center"><cfif get_health.clinical_drums is 'abnormal'><cfinput type="radio" name="clinical_drums" value="Abnormal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_drums" value="Abnormal" onchange="DataChanged();"></cfif></td>
				<tr><td>&nbsp; Eyes</td>
					<td align="center"><cfif get_health.clinical_eyes is 'normal'><cfinput type="radio" name="clinical_eyes" value="Normal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_eyes" value="Normal" onchange="DataChanged();"></cfif></td>
					<td align="center"><cfif get_health.clinical_eyes is 'abnormal'><cfinput type="radio" name="clinical_eyes" value="Abnormal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_eyes" value="Abnormal" onchange="DataChanged();"></cfif></td>
				<tr><td>&nbsp; Ophthalmoscopic</td>
					<td align="center"><cfif get_health.clinical_ophthal is 'normal'><cfinput type="radio" name="clinical_ophthal" value="Normal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_ophthal" value="Normal" onchange="DataChanged();"></cfif></td>
					<td align="center"><cfif get_health.clinical_ophthal is 'abnormal'><cfinput type="radio" name="clinical_ophthal" value="Abnormal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_ophthal" value="Abnormal" onchange="DataChanged();"></cfif></td>
				<tr><td>&nbsp; Pupils</td>
					<td align="center"><cfif get_health.clinical_pupils is 'normal'><cfinput type="radio" name="clinical_pupils" value="Normal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_pupils" value="Normal" onchange="DataChanged();"></cfif></td>
					<td align="center"><cfif get_health.clinical_pupils is 'abnormal'><cfinput type="radio" name="clinical_pupils" value="Abnormal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_pupils" value="Abnormal" onchange="DataChanged();"></cfif></td>
				<tr><td>&nbsp; Ocular Motility</td>
					<td align="center"><cfif get_health.clinical_ocular is 'normal'><cfinput type="radio" name="clinical_ocular" value="Normal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_ocular" value="Normal" onchange="DataChanged();"></cfif></td>
					<td align="center"><cfif get_health.clinical_ocular is 'abnormal'><cfinput type="radio" name="clinical_ocular" value="Abnormal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_ocular" value="Abnormal" onchange="DataChanged();"></cfif></td>
				<tr><td>&nbsp; Lungs and Chest</td>
					<td align="center"><cfif get_health.clinical_lungs is 'normal'><cfinput type="radio" name="clinical_lungs" value="Normal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_lungs" value="Normal" onchange="DataChanged();"></cfif></td>
					<td align="center"><cfif get_health.clinical_lungs is 'abnormal'><cfinput type="radio" name="clinical_lungs" value="Abnormal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_lungs" value="Abnormal" onchange="DataChanged();"></cfif></td>
				<tr><td>&nbsp; Heart</td>
					<td align="center"><cfif get_health.clinical_heart is 'normal'><cfinput type="radio" name="clinical_heart" value="Normal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_heart" value="Normal" onchange="DataChanged();"></cfif></td>
					<td align="center"><cfif get_health.clinical_heart is 'abnormal'><cfinput type="radio" name="clinical_heart" value="Abnormal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_heart" value="Abnormal" onchange="DataChanged();"></cfif></td>
				<tr><td>&nbsp; Vascular System</td>
					<td align="center"><cfif get_health.clinical_vascular is 'normal'><cfinput type="radio" name="clinical_vascular" value="Normal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_vascular" value="Normal" onchange="DataChanged();"></cfif></td>
					<td align="center"><cfif get_health.clinical_vascular is 'abnormal'><cfinput type="radio" name="clinical_vascular" value="Abnormal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_vascular" value="Abnormal" onchange="DataChanged();"></cfif></td>
				<tr><td>&nbsp; Abdomen and Viscera</td>
					<td align="center"><cfif get_health.clinical_abdomen is 'normal'><cfinput type="radio" name="clinical_abdomen" value="Normal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_abdomen" value="Normal" onchange="DataChanged();"></cfif></td>
					<td align="center"><cfif get_health.clinical_abdomen is 'abnormal'><cfinput type="radio" name="clinical_abdomen" value="Abnormal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_abdomen" value="Abnormal" onchange="DataChanged();"></cfif></td>
			</table>	
		</td>
		<td width="4%">&nbsp;</td>
		<td width="48%" valign="top" align="left">
			<table border=1 cellpadding=2 cellspacing=0 width="100%">
				<tr><td width="180" align="center"><em>Check each item</em></td>
					<td width="70" align="center"><em>Normal</em></td>
					<td width="70" align="center"><em>Abnormal</em></td></tr>
				<tr><td>&nbsp; Anus and Rectum</td>
					<td align="center"><cfif get_health.clinical_anus is 'normal'><cfinput type="radio" name="clinical_anus" value="Normal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_anus" value="Normal" onchange="DataChanged();"></cfif></td>
					<td align="center"><cfif get_health.clinical_anus is 'abnormal'><cfinput type="radio" name="clinical_anus" value="Abnormal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_anus" value="Abnormal" onchange="DataChanged();"></cfif></td>
				<tr><td>&nbsp; Endocrine System</td>
					<td align="center"><cfif get_health.clinical_endocrine is 'normal'><cfinput type="radio" name="clinical_endocrine" value="Normal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_endocrine" value="Normal" onchange="DataChanged();"></cfif></td>
					<td align="center"><cfif get_health.clinical_endocrine is 'abnormal'><cfinput type="radio" name="clinical_endocrine" value="Abnormal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_endocrine" value="Abnormal" onchange="DataChanged();"></cfif></td>
				<tr><td>&nbsp; G - U System</td>
					<td align="center"><cfif get_health.clinical_gusystem is 'normal'><cfinput type="radio" name="clinical_gusystem" value="Normal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_gusystem" value="Normal" onchange="DataChanged();"></cfif></td>
					<td align="center"><cfif get_health.clinical_gusystem is 'abnormal'><cfinput type="radio" name="clinical_gusystem" value="Abnormal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_gusystem" value="Abnormal" onchange="DataChanged();"></cfif></td>
				<tr><td>&nbsp; Upper Extremities</td>
					<td align="center"><cfif get_health.clinical_upper is 'normal'><cfinput type="radio" name="clinical_upper" value="Normal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_upper" value="Normal" onchange="DataChanged();"></cfif></td>
					<td align="center"><cfif get_health.clinical_upper is 'abnormal'><cfinput type="radio" name="clinical_upper" value="Abnormal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_upper" value="Abnormal" onchange="DataChanged();"></cfif></td>
				<tr><td>&nbsp; Feet</td>
					<td align="center"><cfif get_health.clinical_feet is 'normal'><cfinput type="radio" name="clinical_feet" value="Normal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_feet" value="Normal" onchange="DataChanged();"></cfif></td>
					<td align="center"><cfif get_health.clinical_feet is 'abnormal'><cfinput type="radio" name="clinical_feet" value="Abnormal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_feet" value="Abnormal" onchange="DataChanged();"></cfif></td>
				<tr><td>&nbsp; Lower Extremities</td>
					<td align="center"><cfif get_health.clinical_lower is 'normal'><cfinput type="radio" name="clinical_lower" value="Normal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_lower" value="Normal" onchange="DataChanged();"></cfif></td>
					<td align="center"><cfif get_health.clinical_lower is 'abnormal'><cfinput type="radio" name="clinical_lower" value="Abnormal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_lower" value="Abnormal" onchange="DataChanged();"></cfif></td>
				<tr><td>&nbsp; Spine, other Musculoskeletal</td>
					<td align="center"><cfif get_health.clinical_spine is 'normal'><cfinput type="radio" name="clinical_spine" value="Normal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_spine" value="Normal" onchange="DataChanged();"></cfif></td>
					<td align="center"><cfif get_health.clinical_spine is 'abnormal'><cfinput type="radio" name="clinical_spine" value="Abnormal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_spine" value="Abnormal" onchange="DataChanged();"></cfif></td>
				<tr><td>&nbsp; Body Marks, Scars, Tatoos</td>
					<td align="center"><cfif get_health.clinical_body is 'normal'><cfinput type="radio" name="clinical_body" value="Normal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_body" value="Normal" onchange="DataChanged();"></cfif></td>
					<td align="center"><cfif get_health.clinical_body is 'abnormal'><cfinput type="radio" name="clinical_body" value="Abnormal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_body" value="Abnormal" onchange="DataChanged();"></cfif></td>
				<tr><td>&nbsp; Skin, Lymphatics</td>
					<td align="center"><cfif get_health.clinical_skin is 'normal'><cfinput type="radio" name="clinical_skin" value="Normal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_skin" value="Normal" onchange="DataChanged();"></cfif></td>
					<td align="center"><cfif get_health.clinical_skin is 'abnormal'><cfinput type="radio" name="clinical_skin" value="Abnormal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_skin" value="Abnormal" onchange="DataChanged();"></cfif></td>
				<tr><td>&nbsp; Neurologic</td>
					<td align="center"><cfif get_health.clinical_neurology is 'normal'><cfinput type="radio" name="clinical_neurology" value="Normal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_neurology" value="Normal" onchange="DataChanged();"></cfif></td>
					<td align="center"><cfif get_health.clinical_neurology is 'abnormal'><cfinput type="radio" name="clinical_neurology" value="Abnormal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_neurology" value="Abnormal" onchange="DataChanged();"></cfif></td>
				<tr><td>&nbsp; Psychiatric</td>
					<td align="center"><cfif get_health.clinical_psychiatric is 'normal'><cfinput type="radio" name="clinical_psychiatric" value="Normal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_psychiatric" value="Normal" onchange="DataChanged();"></cfif></td>
					<td align="center"><cfif get_health.clinical_psychiatric is 'abnormal'><cfinput type="radio" name="clinical_psychiatric" value="Abnormal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_psychiatric" value="Abnormal" onchange="DataChanged();"></cfif></td>
				<tr><td>&nbsp; Pelvic (female only)<br> &nbsp;  &nbsp; check how done <br> &nbsp; &nbsp;
						<cfif get_health.clinical_pelvic_type is 'vaginal'><cfinput type="radio" name="clinical_pelvic_type" value="Vaginal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_pelvic_type" value="Vaginal" onchange="DataChanged();"></cfif>  vaginal &nbsp;  
						<cfif get_health.clinical_pelvic_type is 'vaginal'><cfinput type="radio" name="clinical_pelvic_type" value="Rectal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_pelvic_type" value="Vaginal" onchange="DataChanged();"></cfif>  rectal <br><br></td>
					<td align="center"><cfif get_health.clinical_pelvic is 'normal'><cfinput type="radio" name="clinical_pelvic" value="Normal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_pelvic" value="Normal" onchange="DataChanged();"></cfif></td>
					<td align="center"><cfif get_health.clinical_pelvic is 'abnormal'><cfinput type="radio" name="clinical_pelvic" value="Abnormal" checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="clinical_pelvic" value="Abnormal" onchange="DataChanged();"></cfif></td>
			</table>	
		</td>
	</tr>	
</table><br>

<hr class="bar"></hr><br>

<table width="670" border=0 cellpadding=2 cellspacing=0 align="center">
	<tr><td colspan="7"><b>BLOOD PRESSURE</b></td></tr>
	<tr><td width="10">&nbsp;</td>
		<td width="80" align="right"><em>Sitting:</em></td>
		<td width="130"><cfinput type="text" name="clinical_blood_sitting" size="11" value="#get_health.clinical_blood_sitting#" maxlength="30" onchange="DataChanged();"></td>
		
		<td width="110" align="right"><em>Recumbent:</em></td>
		<td width="120" ><cfinput type="text" name="clinical_blood_recumbent" size="11" value="#get_health.clinical_blood_recumbent#" maxlength="30" onchange="DataChanged();"></td>
		
		<td width="90" align="right"><em>Standing:</em></td>
		<td width="130"><cfinput type="text" name="clinical_blood_standing" size="11" value="#get_health.clinical_blood_standing#" maxlength="30" onchange="DataChanged();"></td></tr>
	
	<tr><td colspan="7">&nbsp;</td></tr>
	
	<tr><td colspan="7"><b>PULSE</b> (arm at heart level)</td></tr>
	<tr><td>&nbsp;</td>
		<td align="right"><em>Sitting: </em></td>
		<td><cfinput type="text" name="clinical_pulse_sitting" size="11" value="#get_health.clinical_pulse_sitting#" maxlength="30" onchange="DataChanged();"></td>
		
		<td align="right"><em>After Exercise:</em></td>
		<td><cfinput type="text" name="clinical_pulse_exercise" size="11" value="#get_health.clinical_pulse_exercise#" maxlength="30" onchange="DataChanged();"></td>

		<td align="right"><em>2 Minutes After:</em></td>
		<td><cfinput type="text" name="clinical_pulse_2min" size="11" value="#get_health.clinical_pulse_2min#" maxlength="30" onchange="DataChanged();"></td></tr>

	<tr><td>&nbsp;</td>
		<td align="right"><em>Recumbent: </em> </td>
		<td><cfinput type="text" name="clinical_pulse_recumbent" size="11" value="#get_health.clinical_pulse_recumbent#" maxlength="30" onchange="DataChanged();"></td>
		
		<td align="right"><em>After Standing 3 Minutes: </em></td>
		<td colspan="3"><cfinput type="text" name="clinical_pulse_3min" size="11" value="#get_health.clinical_pulse_3min#" maxlength="30" onchange="DataChanged();"></td></tr>
</table><br>

<table width="670" border=0 cellpadding=2 cellspacing=0 align="center">
	<tr><td colspan="5"><b>LABORATORY FINDINGS</b></td></tr>
	<tr><td width="40">&nbsp;</td>
		<td width="300"><em>Urinalysis (A.Specific Gravity):</em></td>	
		<td width="170"><em>Albumin: &nbsp;</em> <cfinput type="text" name="clinical_lab_albumin" size="11" value="#get_health.clinical_lab_albumin#" maxlength="30" onchange="DataChanged();"></td>
		<td width="160"><em>Sugar: &nbsp; </em><cfinput type="text" name="clinical_lab_sugar" size="11" value="#get_health.clinical_lab_sugar#" maxlength="30" onchange="DataChanged();"></td>
	</tr>
	<tr><td>&nbsp;</td>
		<td><em>Serology &nbsp;(Specify Test): &nbsp;</em> <cfinput type="text" name="clinical_lab_serology" size="11" value="#get_health.clinical_lab_serology#" maxlength="30" onchange="DataChanged();"></td>
		<td colspan="2"><em>Blood Type & RH Factor: &nbsp;</em> <cfinput type="text" name="clinical_lab_blood" size="11" value="#get_health.clinical_lab_blood#" maxlength="30" onchange="DataChanged();"></td>
	</tr>
	<tr><td>&nbsp;</td>
		<td><em>Tuberculosis (Clearance must be within 6 months)</em></td>
		<td colspan="2"><em>BCG (TB Vaccine) Date: &nbsp; </em> <cfinput type="text" name="clinical_lab_bcg" size="11" value="#DateFormat(get_health.clinical_lab_bcg, 'mm/dd/yyyy')#" maxlength="10" validate="date" message="Please enter a valid date for the BCG vaccine" onchange="DataChanged();"></td></tr>
	</tr>
	<tr><td>&nbsp;</td>
		<td><em>Skin Test Date: &nbsp;</em><cfinput type="text" name="clinical_lab_skin_test" size="11" value="#DateFormat(get_health.clinical_lab_skin_test, 'mm/dd/yyyy')#" maxlength="10" validate="date" message="Please enter a valid date for the TB Tine skin test" onchange="DataChanged();"> <em>(mm/dd/yyyy)</em></td>
		<td colspan="2"><em>Result: &nbsp;</em>
						<cfif get_health.clinical_lab_skin_result is 'positive'><cfinput type="radio" name="clinical_lab_skin_result" value="Positive" checked="yes" onchange="DataChanged();">Positive <cfelse><cfinput type="radio" name="clinical_lab_skin_result" value="Positive" onchange="DataChanged();">Positive</cfif>
						<cfif get_health.clinical_lab_skin_result is 'negative'><cfinput type="radio" name="clinical_lab_skin_result" value="Negative" checked="yes" onchange="DataChanged();">Negative <cfelse><cfinput type="radio" name="clinical_lab_skin_result" value="Negative" onchange="DataChanged();">Negative</cfif> &nbsp;</td>
	</tr>
	<tr><td>&nbsp;</td>
		<td><em>Chest X-Ray Date: &nbsp;</em><cfinput type="text" name="clinical_lab_xray" size="11" value="#DateFormat(get_health.clinical_lab_xray, 'mm/dd/yyyy')#" maxlength="10" validate="date" message="Please enter a valid date for the Chest X-Ray" onchange="DataChanged();"> <em>(mm/dd/yyyy)</em></td>
		<td colspan="2"><em>Result: &nbsp;</em>
						<cfif get_health.clinical_lab_xray_result is 'positive'><cfinput type="radio" name="clinical_lab_xray_result" value="Positive" checked="yes" onchange="DataChanged();">Positive <cfelse><cfinput type="radio" name="clinical_lab_xray_result" value="Positive" onchange="DataChanged();">Positive</cfif>
						<cfif get_health.clinical_lab_xray_result is 'negative'><cfinput type="radio" name="clinical_lab_xray_result" value="Negative" checked="yes" onchange="DataChanged();">Negative <cfelse><cfinput type="radio" name="clinical_lab_xray_result" value="Negative" onchange="DataChanged();">Negative</cfif> &nbsp;	</td>
	</tr>
	<tr><td colspan="2">&nbsp;</td>
		<td colspan="2"><small>(NB! if positive, chest x-ray information mandatory)</small></td></tr>
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