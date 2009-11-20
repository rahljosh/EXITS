<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Student Information - Page 6</title>

<script language="JavaScript">
<!--
function CheckLink()
{
  if (document.form6.CheckChanged.value != 0)
  {
    if (confirm("You have made changes on this page that have not been saved.\n\These changes will be lost if you navigate away from this page.\n\Click OK to contine and discard changes, or click cancel and click on next to save your changes."))
      return true;
    else
      return false;
  }
}
function DataChanged()
{
  document.form6.CheckChanged.value = 1
}
//  End -->
</script>

</head>

<body>
<!----
<cftry>
---->
<!--- Get Student Info by UniqueID --->
<cfinclude template="../querys/get_student_unqid.cfm">

<cfquery name="get_religions" datasource="mysql">
	SELECT *
	FROM smg_religions
	ORDER BY religionname
</cfquery>

<cfoutput query="get_student_unqid">
<cfform method="post" name="form6" action="?curdoc=student/qr_student_form6"><br>
<cfinput type="hidden" name="studentid" value="#get_student_unqid.studentid#">

<table width="95%" align="center">
	<tr><td><h2>S t u d e n t  &nbsp;&nbsp; I n f o r m a t i o n &nbsp;&nbsp; P a g e &nbsp;&nbsp; 6</h2></td></tr>
</table>

<table  width="95%" class="box" bgcolor="ffffff" align="center" cellpadding="3" cellspacing="0">
	<tr>
		<td width="70%" valign="top">
			<table border="0" cellpadding="3" cellspacing="0" width="100%">
				<tr><td colspan="2" bgcolor="C2D1EF"><b>Smoking</b></td></tr>
				<tr><td>Do you smoke?</td>
					<td><cfif smoke EQ 'yes'><cfinput type="radio" name="smoke" value="yes" checked><cfelse><cfinput type="radio" name="smoke" value="yes"></cfif>Yes
						<cfif smoke EQ 'no'><cfinput type="radio" name="smoke" value="no" checked><cfelse><cfinput type="radio" name="smoke" value="no"></cfif>No					
					</td>
				</tr>										
				<tr><td colspan="2"><font size="-12">For your information: <i>The purchase and/or smoking of cigarettes for persons under age 18 is illegal in most parts of the USA.  
						Individual host families may have additional rules which must be followed by their student.</i></font>
					</td>
				</tr>
				<tr><td colspan="2" bgcolor="C2D1EF"><b>Allergies</b></td></tr>
				<tr><td>Are you allergic to:</td></tr>
				<tr><td>Animals?</td>		
					<td><cfif animal_allergies EQ 'yes'><cfinput type="radio" name="animal_allergies" value="yes" checked><cfelse><cfinput type="radio" name="animal_allergies" value="yes"></cfif>Yes
						<cfif animal_allergies EQ 'no'><cfinput type="radio" name="animal_allergies" value="no" checked><cfelse><cfinput type="radio" name="animal_allergies" value="no"></cfif>No
					</td>
				</tr>
				<tr><td>Medications?</td>	
					<td><cfif med_allergies EQ 'yes'><cfinput type="radio" name="med_allergies" value="yes" checked><cfelse><cfinput type="radio" name="med_allergies" value="yes"></cfif>Yes
						<cfif med_allergies EQ 'no'><cfinput type="radio" name="med_allergies" value="no" checked><cfelse><cfinput type="radio" name="med_allergies" value="no"></cfif>No
					</td>
				</tr>
				<tr><td colspan="2">Other (please specify):</td></tr>
				<tr><td><cfinput type="text" name="other_allergies" size=30 value="#other_allergies#"></td></tr>
				<tr><td colspan="2" bgcolor="C2D1EF"><b>Chores</b></td></tr>
				<tr><td>Do you usually help with household chores?</td>
					<td><cfif chores EQ 'yes'><cfinput type="radio" name="chores" value="yes" checked><cfelse><cfinput type="radio" name="chores" value="yes"></cfif>Yes
						<cfif chores EQ 'no'><cfinput type="radio" name="chores" value="no" checked><cfelse><cfinput type="radio" name="chores" value="no"></cfif>No
					</td>
				</tr>
				<tr><td colspan="2">If yes, list the chores for which you are responsible:</td></tr>
				<tr><td colspan="2"><textarea cols="70" rows="1" name="chores_list">#chores_list#</textarea></td></tr>
				<tr><td colspan="2" bgcolor="C2D1EF"><b>Curfew</b></td></tr>
				<tr><td colspan="2">If your parents require you to be home at a certain time in the evening, please specify that time:</td></tr>
				<tr><Td colspan="2">Weekdays: &nbsp; <cfif weekday_curfew EQ 'no'> <cfinput type="text" size="6" name="weekday_curfew" value=""> <cfelse> <cfinput type="text" size="6" name="weekday_curfew" value="#TimeFormat(weekday_curfew, 'h:mm tt')#"> </cfif> &nbsp; hh-mm am/pm</td></tr>
				<tr><td colspan="2">Weekends: &nbsp; <cfif weekend_curfew EQ 'no'> <cfinput type="text" size="6" name="weekend_curfew" value=""> <cfelse>  <cfinput type="text" size="6" name="weekend_curfew" value="#TimeFormat(weekend_curfew, 'h:mm tt')#"> </cfif> &nbsp; hh-mm am/pm</td></tr>
				<tr><td>&nbsp;</td></tr>
			</table>			
		</td>
		<td width="30%" valign="top">
			<table border=0 cellpadding=3 cellspacing=0 align="right">
				<tr><td align="right"><cfinclude template="student_menu.cfm"></td></tr>
			</table> 		
		</td>
	</tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr><td align="center"><br><input name="Submit" type="image" value="  next  " src="pics/next.gif" alt="Next" border="0"><br></td></tr>
</table>

</cfform>
</cfoutput>
<!----
<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>

</cftry>
---->
</body>
</html>