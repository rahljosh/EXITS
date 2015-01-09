<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Student Information - Page 7</title>

<script language="JavaScript">
<!--
function CheckLink()
{
  if (document.form7.CheckChanged.value != 0)
  {
    if (confirm("You have made changes on this page that have not been saved.\n\These changes will be lost if you navigate away from this page.\n\Click OK to contine and discard changes, or click cancel and click on next to save your changes."))
      return true;
    else
      return false;
  }
}
function DataChanged()
{
  document.form7.CheckChanged.value = 1
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
<cfform method="post" name="form7" action="?curdoc=student/qr_student_form7"><br>
<cfinput type="hidden" name="studentid" value="#get_student_unqid.studentid#">


<table width="95%" align="center">
	<tr><td><h2>S t u d e n t  &nbsp;&nbsp; I n f o r m a t i o n &nbsp;&nbsp; P a g e &nbsp;&nbsp; 7</h2></td></tr>
</table>

<table  width="95%" class="box" bgcolor="ffffff" align="center" cellpadding="3" cellspacing="0">
	<tr>
		<td width="70%" valign="top">
			<table border="0" cellpadding="3" cellspacing="0" width="100%">
				<tr><td colspan="2" bgcolor="C2D1EF"><b>School Information</b></td></tr>
				<tr><td>Convalidation needed:</td>
					<td><cfif convalidation_needed EQ 'yes'><cfinput type="radio" name="convalidation_needed" value="yes" checked><cfelse><cfinput type="radio" name="convalidation_needed" value="yes"></cfif>Yes
						<cfif convalidation_needed EQ 'no'><cfinput type="radio" name="convalidation_needed" value="no" checked><cfelse><cfinput type="radio" name="convalidation_needed" value="no"></cfif>No					
					</td>
				</tr>	
				<tr><td>Convalidation Completed:</td>
					<td><cfif convalidation_completed EQ 'yes'><cfinput type="radio" name="convalidation_completed" value="yes" checked><cfelse><cfinput type="radio" name="convalidation_completed" value="yes"></cfif>Yes
						<cfif convalidation_completed EQ 'no'><cfinput type="radio" name="convalidation_completed" value="no" checked><cfelse><cfinput type="radio" name="convalidation_completed" value="no"></cfif>No					
					</td>
				</tr>											
				<tr><td colspan="2"><font size="-12">For your information: <i>Students from Brazil, Ecuador, Italy, Mexico and Spain.</i></font>
					</td>
				</tr>
				<tr><td colspan="2" bgcolor="C2D1EF"><b>Academic</b></td></tr>
				<tr><td>Last Grade completed:</td>
					<td><cfselect name="grades">
							<option value="0"></option>
							<cfloop from="7" to="12" index="i">
							<option value="#i#"<cfif grades EQ i>selected</cfif>>#i#th</option>
							</cfloop>
						</cfselect>
					</td>					
				</tr>										
				<tr><td>Upon arrival, will the student have completed secondary school in his/her home country?</td>
					<td><cfif app_completed_school EQ 'yes'><cfinput type="radio" name="app_completed_school" value="yes" checked><cfelse><cfinput type="radio" name="app_completed_school" value="yes"></cfif>Yes
						<cfif app_completed_school EQ 'no'><cfinput type="radio" name="app_completed_school" value="no" checked><cfelse><cfinput type="radio" name="app_completed_school" value="no"></cfif>No					
					</td>
				</tr>
				<tr><td>Student wishes to graduate: </td>
					<td><cfif php_wishes_graduate EQ 'yes'><cfinput type="radio" name="php_wishes_graduate" value="yes" checked><cfelse><cfinput type="radio" name="php_wishes_graduate" value="yes"></cfif>Yes
						<cfif php_wishes_graduate EQ 'no'><cfinput type="radio" name="php_wishes_graduate" value="no" checked><cfelse><cfinput type="radio" name="php_wishes_graduate" value="no"></cfif>No					
					</td>
				</tr>										
				<tr><td>Grade student wishes to apply:</td>
					<td><cfselect name="php_grade_student">
							<option value="0"></option>
							<cfloop from="7" to="12" index="i">
							<option value="#i#"<cfif php_grade_student EQ i>selected</cfif>>#i#th</option>
							</cfloop>
						</cfselect>
					</td>
				</tr>																								
				<tr><td colspan="2" bgcolor="C2D1EF"><b>GPA & English Skills</b></td></tr>
				<tr><td>Estimated GPA:</td>
					<td><cfinput type="text" name="estgpa" size=6 value="#estgpa#"></td>
				</tr>										
				<tr><td>Years of English:</td>
					<td><cfinput type="text" name="yearsenglish" size=6 value="#yearsenglish#"></td>
				</tr>										
				<tr>
				  <td>SLEP/ELTiS Test Score:</td>
					<td><cfinput type="text" name="slep_score" size=6 value="#slep_score#"></td>
				</tr>	
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