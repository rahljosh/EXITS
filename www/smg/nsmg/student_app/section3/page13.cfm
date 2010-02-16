<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>Page [13] - Immunization Record</title>
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
	<cflocation url="?curdoc=section3/page13print&id=3&p=13" addtoken="no">
</cfif>

<script type="text/javascript">
<!--
function CheckLink()
{
  if (document.page13.CheckChanged.value != 0)
  {
    if (confirm("You have made changes on this page that have not been saved.\n\These changes will be lost if you navigate away from this page.\n\Click OK to contine and discard changes, or click cancel and click on save to save your changes."))
      return true;
    else
      return false;
  }
}
function DataChanged()
{
  document.page13.CheckChanged.value = 1;
}
function NextPage() {
	document.page13.action = '?curdoc=section3/qr_page13&next';
	}
//-->
</SCRIPT>

<cfinclude template="../querys/get_student_info.cfm">

<cfset doc = 'page13'>

<cfquery name="get_dpt" datasource="MySql">
	SELECT vaccineid, studentid, vaccine, disease, shot1, shot2, shot3, shot4, shot5, booster
	FROM smg_student_app_shots
	WHERE vaccine = 'dpt/dt' AND studentid = '#get_student_info.studentid#'
</cfquery>

<cfquery name="get_topv" datasource="MySql">
	SELECT vaccineid, studentid, vaccine, disease, shot1, shot2, shot3, shot4, shot5, booster
	FROM smg_student_app_shots
	WHERE vaccine = 'topv' AND studentid = '#get_student_info.studentid#'
</cfquery>

<cfquery name="get_measles" datasource="MySql">
	SELECT vaccineid, studentid, vaccine, disease, shot1, shot2, shot3, shot4, shot5, booster
	FROM smg_student_app_shots
	WHERE vaccine = 'measles' AND studentid = '#get_student_info.studentid#'
</cfquery>

<cfquery name="get_mumps" datasource="MySql">
	SELECT vaccineid, studentid, vaccine, disease, shot1, shot2, shot3, shot4, shot5, booster
	FROM smg_student_app_shots
	WHERE vaccine = 'mumps' AND studentid = '#get_student_info.studentid#'
</cfquery>

<cfquery name="get_rubella" datasource="MySql">
	SELECT vaccineid, studentid, vaccine, disease, shot1, shot2, shot3, shot4, shot5, booster
	FROM smg_student_app_shots
	WHERE vaccine = 'rubella' AND studentid = '#get_student_info.studentid#'
</cfquery>

<cfquery name="get_varicella" datasource="MySql">
	SELECT vaccineid, studentid, vaccine, disease, shot1, shot2, shot3, shot4, shot5, booster
	FROM smg_student_app_shots
	WHERE vaccine = 'varicella' AND studentid = '#get_student_info.studentid#'
</cfquery>

<cfquery name="get_hepatitis" datasource="MySql">
	SELECT vaccineid, studentid, vaccine, disease, shot1, shot2, shot3, shot4, shot5, booster
	FROM smg_student_app_shots
	WHERE vaccine = 'hepatitis b' AND studentid = '#get_student_info.studentid#'
</cfquery>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="../pics/students.gif"></td>
		<td class="tablecenter"><h2>Page [13] - Immunization Record</h2></td>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section3/page13print.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		<td width="42" class="tableside"><img src="pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<cfform action="?curdoc=section3/qr_page13" method="post" name="page13">

<cfoutput query="get_student_info">

<cfinput type="hidden" name="studentid" value="#studentid#">
<cfinput type="hidden" name="CheckChanged" value="0">

<div class="section"><br>

<!--- Check uploaded file - Upload File Button --->
<cfinclude template="../check_uploaded_file.cfm">

<table width="670" border=0 cellpadding=3 cellspacing=0 align="center">
	<tr><td><b>IMMUNIZATIONS REQUIRED FOR SCHOOL ADMITTANCE</b></td></tr>
	<tr><td><div align="justify">
			Pupils enrolled in kindergarten through grade 12 (in the United States) are required to have written proof on file at their
			public or nonpublic school that they have been immunized against DPT (diphtheria, pertussis, tetanus), poliomyelitis, measles,
			mumps, rubella, hepatitis B and varicella. Failure to do so is cause for exclusion from school. Required immunizations may
			vary from state to state.
			</div>
	</td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td><b>MINIMUM IMMUNIZATION REQUIREMENTS:</b></td></tr>
	<tr><td>Five or more doses of DPT, DT (Pediatric), TD (Adult) vaccine or a combination thereof.</td></tr>
	<tr><td>Three or more doses of trivalent oral polio vaccine (TOPV).</td></tr>
	<tr><td>Two doses measles vaccine.</td></tr>
	<tr><td>Two doses mumps vaccine.</td></tr>
	<tr><td>Two doses rubella vaccine.</td></tr>
	<tr><td>Three doses of Hepatitis B vaccine.</td></tr>
	<tr><td>Two doses of Varicella vaccine (Two doses required if first dose issued after thirteenth birthday).</td></tr>
	<tr><td>If the final dose of any of the above vaccines occurs before the third birthday, a booster shot is required.</td></tr>
</table><br>

<table width="670" border=1 cellpadding=3 cellspacing=0  bordercolor="CCCCCC" align="center">
	<tr><td align="center"><b>IMMUNIZATIONS</b></td><td colspan="6" align="center"><b>DATES (mm/dd/yyyy)</b></td></tr>
	<!--- DPT/DT --->
	<cfif get_dpt.recordcount EQ 0> <!--- DPT/DT has not been entered --->
		<cfinput type="hidden" name="new_dpt" value="DPT/DT">
	<cfelse>
		<cfinput type="hidden" name="upd_dpt" value="#get_dpt.vaccineid#">
	</cfif>
	<tr>
		<td align="center" width="130" valign="top"><b>DPT/DT</b></td>
		<td align="center" width="90" valign="top"><cfinput type="text" name="dpt1" size="11" value="#DateFormat(get_dpt.shot1, 'mm/dd/yyyy')#" maxlength="10" validate="date" message="Please enter a valid date for the 1st DPT/DT shot" onchange="DataChanged();"><br> <small>1st </small></td>
		<td align="center" width="90" valign="top"><cfinput type="text" name="dpt2" size="11" value="#DateFormat(get_dpt.shot2, 'mm/dd/yyyy')#" maxlength="10" validate="date" message="Please enter a valid date for the 2ndt DPT/DT shot"  onchange="DataChanged();"><br> <small>2nd </small></td>
		<td align="center" width="90" valign="top"><cfinput type="text" name="dpt3" size="11" value="#DateFormat(get_dpt.shot3, 'mm/dd/yyyy')#" maxlength="10" validate="date" message="Please enter a valid date for the 3rd DPT/DT shot"  onchange="DataChanged();"><br> <small>3rd </small></td>
		<td align="center" width="90" valign="top"><cfinput type="text" name="dpt4" size="11" value="#DateFormat(get_dpt.shot4, 'mm/dd/yyyy')#" maxlength="10" validate="date" message="Please enter a valid date for the 4th DPT/DT shot"  onchange="DataChanged();"><br> <small>4th </small></td>
		<td align="center" width="90" valign="top"><cfinput type="text" name="dpt5" size="11" value="#DateFormat(get_dpt.shot5, 'mm/dd/yyyy')#" maxlength="10" validate="date" message="Please enter a valid date for the 5th DPT/DT shot"  onchange="DataChanged();"><br> <small>5th </small></td>
		<td align="center" width="90" valign="top"><cfinput type="text" name="dpt_booster" size="11" value="#DateFormat(get_dpt.booster, 'mm/dd/yyyy')#" maxlength="10" validate="date" message="Please enter a valid date for the 6th DPT/DT shot"  onchange="DataChanged();"><br> <small>6th <br> Booster, if required </small></td>				
	</tr>
	
	<!--- TOPV --->
	<cfif get_topv.recordcount EQ 0>  <!--- TOPV has not been entered --->
		<cfinput type="hidden" name="new_topv" value="TOPV">
	<cfelse>
		<cfinput type="hidden" name="upd_topv" value="#get_topv.vaccineid#">	
	</cfif>
	<tr>
		<td align="center" width="130" valign="top"><b>TOPV</b></td>
		<td align="center" width="90" valign="top"><cfinput type="text" name="topv_disease" size="11" value="#DateFormat(get_topv.disease, 'mm/dd/yyyy')#" maxlength="10" validate="date" message="Please enter a valid date for the TOPV date of disease" onchange="DataChanged();"><br> <small>date of disease </small></td>
		<td align="center" width="90" valign="top"><cfinput type="text" name="topv1" size="11" value="#DateFormat(get_topv.shot1, 'mm/dd/yyyy')#" maxlength="10" validate="date" message="Please enter a valid date for the 1st TOPV shot" onchange="DataChanged();"><br> <small>1st </small></td>
		<td align="center" width="90" valign="top"><cfinput type="text" name="topv2" size="11" value="#DateFormat(get_topv.shot2, 'mm/dd/yyyy')#" maxlength="10" validate="date" message="Please enter a valid date for the 2nd TOPV shot" onchange="DataChanged();"><br> <small>2nd</small></td>
		<td align="center" width="90" valign="top"><cfinput type="text" name="topv3" size="11" value="#DateFormat(get_topv.shot3, 'mm/dd/yyyy')#" maxlength="10" validate="date" message="Please enter a valid date for the 3rd TOPV shot" onchange="DataChanged();"><br> <small>3rd</small></td>
		<td align="center" width="90" valign="top"><cfinput type="text" name="topv_booster" size="11" value="#DateFormat(get_topv.booster, 'mm/dd/yyyy')#" maxlength="10" validate="date" message="Please enter a valid date for the 4th (booster) TOPV shot" onchange="DataChanged();"><br> <small>4th <br> Booster, if required <small></td>
		<td align="center" width="90" valign="top">&nbsp;</td>				
	</tr>
	
	<!--- MEASLES --->	
	<cfif get_measles.recordcount EQ 0>  <!--- MEASLES has not been entered --->
		<cfinput type="hidden" name="new_measles" value="MEASLES">
	<cfelse>
		<cfinput type="hidden" name="upd_measles" value="#get_measles.vaccineid#">	
	</cfif>
	<tr>
		<td align="center" width="130" valign="top"><b>Measles</b></td>
		<td align="center" width="90" valign="top"><cfinput type="text" name="measles_disease" size="11" value="#DateFormat(get_measles.disease, 'mm/dd/yyyy')#" maxlength="10" validate="date" message="Please, enter a valid date for the Measles date of disease" onchange="DataChanged();"><br> <small>date of disease </small></td>
		<td align="center" width="90" valign="top"><cfinput type="text" name="measles1" size="11" value="#DateFormat(get_measles.shot1, 'mm/dd/yyyy')#" maxlength="10" validate="date" message="Please enter a valid date for the 1st Measles shot" onchange="DataChanged();"><br> <small>1st </small></td>
		<td align="center" width="90" valign="top"><cfinput type="text" name="measles2" size="11" value="#DateFormat(get_measles.shot2, 'mm/dd/yyyy')#" maxlength="10" validate="date" message="Please enter a valid date for the 2nd Measles shot" onchange="DataChanged();"><br> <small>2nd</small></td>
		<td align="center" width="90" valign="top"><cfinput type="text" name="measles_booster" size="11" value="#DateFormat(get_measles.booster, 'mm/dd/yyyy')#" maxlength="10" validate="date" message="Please enter a valid date for the 3rd (booster) Measles shot" onchange="DataChanged();"><br> <small>3rd <br> Booster, if required <small></td>
		<td align="center" width="90" valign="top">&nbsp;</td>
		<td align="center" width="90" valign="top">&nbsp;</td>				
	</tr>
	
	<!--- MUMPS --->
	<cfif get_mumps.recordcount EQ 0>  <!--- MUMPS has not been entered --->
		<cfinput type="hidden" name="new_mumps" value="MUMPS">
	<cfelse>
		<cfinput type="hidden" name="upd_mumps" value="#get_mumps.vaccineid#">		
	</cfif>
	<tr>
		<td align="center" width="130" valign="top"><b>Mumps</b></td>
		<td align="center" width="90" valign="top"><cfinput type="text" name="mumps_disease" size="11" value="#DateFormat(get_mumps.disease, 'mm/dd/yyyy')#" maxlength="10" validate="date" message="Please, enter a valid date for the Mumps date of disease" onchange="DataChanged();"><br> <small>date of disease </small></td>
		<td align="center" width="90" valign="top"><cfinput type="text" name="mumps1" size="11" value="#DateFormat(get_mumps.shot1, 'mm/dd/yyyy')#" maxlength="10" validate="date" message="Please enter a valid date for the 1st Mumps shot" onchange="DataChanged();"><br> <small>1st </small></td>
		<td align="center" width="90" valign="top"><cfinput type="text" name="mumps2" size="11" value="#DateFormat(get_mumps.shot2, 'mm/dd/yyyy')#" maxlength="10" validate="date" message="Please enter a valid date for the 2nd Mumps shot" onchange="DataChanged();"><br> <small>2nd</small></td>
		<td align="center" width="90" valign="top"><cfinput type="text" name="mumps_booster" size="11" value="#DateFormat(get_mumps.booster, 'mm/dd/yyyy')#" maxlength="10" validate="date" message="Please enter a valid date for the 3rd (booster) Mumps shot" onchange="DataChanged();"><br> <small>3rd <br> Booster, if required <small></td>
		<td align="center" width="90" valign="top">&nbsp;</td>
		<td align="center" width="90" valign="top">&nbsp;</td>				
	</tr>	
	
	<!--- RUBELLA --->
	<cfif get_rubella.recordcount EQ 0>  <!--- RUBELLA has not been entered --->
		<cfinput type="hidden" name="new_rubella" value="RUBELLA">	
	<cfelse>
		<cfinput type="hidden" name="upd_rubella" value="#get_rubella.vaccineid#">	
	</cfif>
	<tr>
		<td align="center" width="130" valign="top"><b>Rubella</b></td>
		<td align="center" width="90" valign="top"><cfinput type="text" name="rubella_disease" size="11" value="#DateFormat(get_rubella.disease, 'mm/dd/yyyy')#" maxlength="10" validate="date" message="Please, enter a valid date for the Rubella date of disease" onchange="DataChanged();"><br> <small>date of disease </small></td>
		<td align="center" width="90" valign="top"><cfinput type="text" name="rubella1" size="11" value="#DateFormat(get_rubella.shot1, 'mm/dd/yyyy')#" maxlength="10" validate="date" message="Please enter a valid date for the 1st Rubella shot" onchange="DataChanged();"><br> <small>1st </small></td>
		<td align="center" width="90" valign="top"><cfinput type="text" name="rubella2" size="11" value="#DateFormat(get_rubella.shot2, 'mm/dd/yyyy')#" maxlength="10" validate="date" message="Please enter a valid date for the 2nd Rubella shot" onchange="DataChanged();"><br> <small>2nd</small></td>
		<td align="center" width="90" valign="top"><cfinput type="text" name="rubella_booster" size="11" value="#DateFormat(get_rubella.booster, 'mm/dd/yyyy')#" maxlength="10" validate="date" message="Please enter a valid date for the 3rd (booster) Rubella shot" onchange="DataChanged();"><br> <small>3rd <br> Booster, if required <small></td>
		<td align="center" width="90" valign="top">&nbsp;</td>
		<td align="center" width="90" valign="top">&nbsp;</td>				
	</tr>
	
	<!--- VARICELLA --->
	<cfif get_varicella.recordcount EQ 0>  <!--- VARICELLA has not been entered --->
		<cfinput type="hidden" name="new_varicella" value="VARICELLA">
	<cfelse>
		<cfinput type="hidden" name="upd_varicella" value="#get_varicella.vaccineid#">	
	</cfif>
	<tr>
		<td align="center" width="130" valign="top"><b>Varicella</b> <br> <small>(chickenpox)</small></td>
		<td align="center" width="90" valign="top"><cfinput type="text" name="varicella_disease" size="11" value="#DateFormat(get_varicella.disease, 'mm/dd/yyyy')#" maxlength="10" validate="date" message="Please, enter a valid date for the Varicella date of disease" onchange="DataChanged();"><br> <small>date of disease </small></td>
		<td align="center" width="90" valign="top"><cfinput type="text" name="varicella1" size="11" value="#DateFormat(get_varicella.shot1, 'mm/dd/yyyy')#" maxlength="10" validate="date" message="Please enter a valid date for the 1st Varicella shot" onchange="DataChanged();"><br> <small>1st </small></td>
		<td align="center" width="90" valign="top"><cfinput type="text" name="varicella2" size="11" value="#DateFormat(get_varicella.shot2, 'mm/dd/yyyy')#" maxlength="10" validate="date" message="Please enter a valid date for the 2nd Varicella shot" onchange="DataChanged();"><br> <small>2nd</small></td>
		<td align="center" width="90" valign="top"><cfinput type="text" name="varicella_booster" size="11" value="#DateFormat(get_varicella.booster, 'mm/dd/yyyy')#" maxlength="10" validate="date" message="Please enter a valid date for the 3rd (booster) Varicella shot" onchange="DataChanged();"><br> <small>3rd <br> Booster, if required <small></td>
		<td align="center" width="90" valign="top">&nbsp;</td>
		<td align="center" width="90" valign="top">&nbsp;</td>				
	</tr>
							
	<!--- HEPATITIS --->
	<cfif get_hepatitis.recordcount EQ 0>  <!--- HEPATITIS has not been entered --->
		<cfinput type="hidden" name="new_hepatitis" value="HEPATITIS B">	
	<cfelse>
		<cfinput type="hidden" name="upd_hepatitis" value="#get_hepatitis.vaccineid#">	
	</cfif>	
	<tr>
		<td align="center" width="130" valign="top"><b>Hepatitis B</b></td>
		<td align="center" width="90" valign="top"><cfinput type="text" name="hepatitis1" size="11" value="#DateFormat(get_hepatitis.shot1, 'mm/dd/yyyy')#" maxlength="10" validate="date" message="Please enter a valid date for the 1st Hepatitis B shot" onchange="DataChanged();"><br> <small>1st </small><br><br></td>
		<td align="center" width="90" valign="top"><cfinput type="text" name="hepatitis2" size="11" value="#DateFormat(get_hepatitis.shot2, 'mm/dd/yyyy')#" maxlength="10" validate="date" message="Please enter a valid date for the 2nd Hepatitis B shot" onchange="DataChanged();"><br> <small>2nd </small><br><br></td>
		<td align="center" width="90" valign="top"><cfinput type="text" name="hepatitis3" size="11" value="#DateFormat(get_hepatitis.shot3, 'mm/dd/yyyy')#" maxlength="10" validate="date" message="Please enter a valid date for the 3rd Hepatitis B shot" onchange="DataChanged();"><br> <small>3rd </small><br><br></td>
		<td align="center" width="90" valign="top">&nbsp;</td>
		<td align="center" width="90" valign="top">&nbsp;</td>
		<td align="center" width="90" valign="top">&nbsp;</td>				
	</tr>
</table><br>

<table width="670" border=0 cellpadding=3 cellspacing=0 align="center">
<tr>
	<td>
		<div align="justify">Any immunizations not available in your country are available here, but they are expensive and are not
		covered by insurance. The student must be prepared to pay for any immunizations they receive in the USA. Please make every
		effort to obtain all immunizations before your departure from your home country.</div>
	</td>
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