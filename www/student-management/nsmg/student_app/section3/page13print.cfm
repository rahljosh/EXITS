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
	<title>Page [13] - Immunization Record</title>
</head>
<body <cfif not IsDefined('url.curdoc')>onLoad="print()"</cfif>>

<cfinclude template="../querys/get_student_info.cfm">

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

<cfset doc = 'page13'>

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
		<td class="tablecenter"><h2>Page [13] - Immunization Record</h2></td>
		<cfif IsDefined('url.curdoc')>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section3/page13print.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		</cfif>
		<td width="42" class="tableside"><img src="#path#pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section"><br>

<cfif IsDefined('url.curdoc')>
	<cfinclude template="../check_upl_print_file.cfm">
</cfif>

<table width="660" border=0 cellpadding=3 cellspacing=0 align="center">
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

<table width="660" border=1 cellpadding=3 cellspacing=0  bordercolor="CCCCCC" align="center">
	<tr><td align="center"><b>IMMUNIZATIONS</b></td><td colspan="6" align="center"><b>DATES (mm/dd/yyyy)</b></td></tr>
	<!--- DPT/DT --->
	<tr>
		<td align="center" width="130" valign="top"><b>DPT/DT</b></td>
		<td align="center" width="90" valign="top">#DateFormat(get_dpt.shot1, 'mm/dd/yyyy')#<br> <small>1st </small></td>
		<td align="center" width="90" valign="top">#DateFormat(get_dpt.shot2, 'mm/dd/yyyy')#<br> <small>2nd </small></td>
		<td align="center" width="90" valign="top">#DateFormat(get_dpt.shot3, 'mm/dd/yyyy')#<br> <small>3rd </small></td>
		<td align="center" width="90" valign="top">#DateFormat(get_dpt.shot4, 'mm/dd/yyyy')#<br> <small>4th </small></td>
		<td align="center" width="90" valign="top">#DateFormat(get_dpt.shot5, 'mm/dd/yyyy')#<br> <small>5th </small></td>
		<td align="center" width="90" valign="top">#DateFormat(get_dpt.booster, 'mm/dd/yyyy')#<br> <small>6th <br> Booster, if required </small></td>				
	</tr>
	
	<!--- TOPV --->
	<tr>
		<td align="center" width="130" valign="top"><b>TOPV</b></td>
		<td align="center" width="90" valign="top">#DateFormat(get_topv.disease, 'mm/dd/yyyy')#<br> <small>date of disease </small></td>
		<td align="center" width="90" valign="top">#DateFormat(get_topv.shot1, 'mm/dd/yyyy')#<br> <small>1st </small></td>
		<td align="center" width="90" valign="top">#DateFormat(get_topv.shot2, 'mm/dd/yyyy')#<br> <small>2nd</small></td>
		<td align="center" width="90" valign="top">#DateFormat(get_topv.shot3, 'mm/dd/yyyy')#<br> <small>3rd</small></td>
		<td align="center" width="90" valign="top">#DateFormat(get_topv.booster, 'mm/dd/yyyy')#<br> <small>4th <br> Booster, if required <small></td>
		<td align="center" width="90" valign="top">&nbsp;</td>				
	</tr>
	
	<!--- MEASLES --->	
	<tr>
		<td align="center" width="130" valign="top"><b>Measles</b></td>
		<td align="center" width="90" valign="top">#DateFormat(get_measles.disease, 'mm/dd/yyyy')#<br> <small>date of disease </small></td>
		<td align="center" width="90" valign="top">#DateFormat(get_measles.shot1, 'mm/dd/yyyy')#<br> <small>1st </small></td>
		<td align="center" width="90" valign="top">#DateFormat(get_measles.shot2, 'mm/dd/yyyy')#<br> <small>2nd</small></td>
		<td align="center" width="90" valign="top">#DateFormat(get_measles.booster, 'mm/dd/yyyy')#<br> <small>3rd <br> Booster, if required <small></td>
		<td align="center" width="90" valign="top">&nbsp;</td>
		<td align="center" width="90" valign="top">&nbsp;</td>				
	</tr>
	
	<!--- MUMPS --->
	<tr>
		<td align="center" width="130" valign="top"><b>Mumps</b></td>
		<td align="center" width="90" valign="top">#DateFormat(get_mumps.disease, 'mm/dd/yyyy')#<br> <small>date of disease </small></td>
		<td align="center" width="90" valign="top">#DateFormat(get_mumps.shot1, 'mm/dd/yyyy')#<br> <small>1st </small></td>
		<td align="center" width="90" valign="top">#DateFormat(get_mumps.shot2, 'mm/dd/yyyy')#<br> <small>2nd</small></td>
		<td align="center" width="90" valign="top">#DateFormat(get_mumps.booster, 'mm/dd/yyyy')#<br> <small>3rd <br> Booster, if required <small></td>
		<td align="center" width="90" valign="top">&nbsp;</td>
		<td align="center" width="90" valign="top">&nbsp;</td>				
	</tr>	
	
	<!--- RUBELLA --->
	<tr>
		<td align="center" width="130" valign="top"><b>Rubella</b></td>
		<td align="center" width="90" valign="top">#DateFormat(get_rubella.disease, 'mm/dd/yyyy')#<br> <small>date of disease </small></td>
		<td align="center" width="90" valign="top">#DateFormat(get_rubella.shot1, 'mm/dd/yyyy')#<br> <small>1st </small></td>
		<td align="center" width="90" valign="top">#DateFormat(get_rubella.shot2, 'mm/dd/yyyy')#<br> <small>2nd</small></td>
		<td align="center" width="90" valign="top">#DateFormat(get_rubella.booster, 'mm/dd/yyyy')#<br> <small>3rd <br> Booster, if required <small></td>
		<td align="center" width="90" valign="top">&nbsp;</td>
		<td align="center" width="90" valign="top">&nbsp;</td>				
	</tr>
	
	<!--- VARICELLA --->
	<tr>
		<td align="center" width="130" valign="top"><b>Varicella</b> <br> <small>(chickenpox)</small></td>
		<td align="center" width="90" valign="top">#DateFormat(get_varicella.disease, 'mm/dd/yyyy')#<br> <small>date of disease </small></td>
		<td align="center" width="90" valign="top">#DateFormat(get_varicella.shot1, 'mm/dd/yyyy')#<br> <small>1st </small></td>
		<td align="center" width="90" valign="top">#DateFormat(get_varicella.shot2, 'mm/dd/yyyy')#<br> <small>2nd</small></td>
		<td align="center" width="90" valign="top">#DateFormat(get_varicella.booster, 'mm/dd/yyyy')#<br> <small>3rd <br> Booster, if required <small></td>
		<td align="center" width="90" valign="top">&nbsp;</td>
		<td align="center" width="90" valign="top">&nbsp;</td>				
	</tr>
							
	<!--- HEPATITIS --->
	<tr>
		<td align="center" width="130" valign="top"><b>Hepatitis B</b></td>
		<td align="center" width="90" valign="top">#DateFormat(get_hepatitis.shot1, 'mm/dd/yyyy')#<br> <small>1st </small><br><br></td>
		<td align="center" width="90" valign="top">#DateFormat(get_hepatitis.shot2, 'mm/dd/yyyy')#<br> <small>2nd </small><br><br></td>
		<td align="center" width="90" valign="top">#DateFormat(get_hepatitis.shot3, 'mm/dd/yyyy')#<br> <small>3rd </small><br><br></td>
		<td align="center" width="90" valign="top">&nbsp;</td>
		<td align="center" width="90" valign="top">&nbsp;</td>
		<td align="center" width="90" valign="top">&nbsp;</td>				
	</tr>
</table><br>

<table width="660" border=0 cellpadding=3 cellspacing=0 align="center">
<tr>
	<td>
		<div align="justify">Any immunizations not available in your country are available here, but they are expensive and are not
		covered by insurance. The student must be prepared to pay for any immunizations they receive in the USA. Please make every
		effort to obtain all immunizations before your departure from your home country.</div>
	</td>
</tr>
</table><br><br>

<table width="660" border=0 cellpadding=3 cellspacing=0 align="center">
	<tr><td width="315"><em>Signature of Physician</em></td><td width="40">&nbsp;</td><td width="315"><em>Date</em></td></tr>
	<tr>
		<td><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
		<td>&nbsp;</td>
		<td><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
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
<cfinclude template="../print_include_file.cfm">
</cfif>

</body>
</html>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>