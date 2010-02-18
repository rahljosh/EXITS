<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>Page [10] - Social Skills</title>
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
	<cflocation url="?curdoc=section2/page10print&id=2&p=10" addtoken="no">
</cfif>

<script type="text/javascript">
<!--
function CheckLink()
{
  if (document.page10.CheckChanged.value != 0)
  {
    if (confirm("You have made changes on this page that have not been saved.\n\These changes will be lost if you navigate away from this page.\n\Click OK to contine and discard changes, or click cancel and click on save to save your changes."))
      return true;
    else
      return false;
  }
}
function DataChanged()
{
  document.page10.CheckChanged.value = 1;
}
function NextPage() {
	document.page10.action = '?curdoc=section2/qr_page10&next';
	}
//-->
</SCRIPT>

<cfinclude template="../querys/get_student_info.cfm">

<cfset doc = 'page10'>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="../pics/students.gif"></td>
		<td class="tablecenter"><h2>Page [10] - Social Skills</h2></td>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section2/page10print.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		<td width="42" class="tableside"><img src="pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<cfform action="?curdoc=section2/qr_page10" method="post" name="page10">

<cfoutput query="get_student_info">

<cfinput type="hidden" name="studentid" value="#studentid#">
<cfinput type="hidden" name="CheckChanged" value="0">

<div class="section"><br>

<!--- Check uploaded file - Upload File Button --->
<cfinclude template="../check_uploaded_file.cfm">

<table width="670" border=0 cellpadding=1 cellspacing=0 align="center">
	<tr><td align="center"><b>Pages 9 and 10 must be completed by Present English teacher</b></td></tr>
</table><br><br>

<table width="670" border=0 cellpadding=0 cellspacing=0 align="center">
	<tr><td valign="top"><em>Ability to express oneself</em></td>
		<td>
			<cfif app_social_skills1 is 'Excellent'><cfinput type="radio" name="app_social_skills1" value="Excellent" checked="yes" onchange="DataChanged();">
			<cfelse><cfinput type="radio" name="app_social_skills1" value="Excellent" onchange="DataChanged();"></cfif> Excellent
		</td>
		<td>
			<cfif app_social_skills1 is 'Very Good'><cfinput type="radio" name="app_social_skills1" value="Very Good" checked="yes" onchange="DataChanged();">
			<cfelse><cfinput type="radio" name="app_social_skills1" value="Very Good" onchange="DataChanged();"></cfif> Very Good
		</td>
		<td>
			<cfif app_social_skills1 is 'Good'><cfinput type="radio" name="app_social_skills1" value="Good" checked="yes" onchange="DataChanged();">
			<cfelse><cfinput type="radio" name="app_social_skills1" value="Good" onchange="DataChanged();"></cfif> Good
		</td>
		<td>
			<cfif app_social_skills1 is 'Fair'><cfinput type="radio" name="app_social_skills1" value="Fair" checked="yes" onchange="DataChanged();">
			<cfelse><cfinput type="radio" name="app_social_skills1" value="Fair" onchange="DataChanged();"></cfif> Fair
		</td>
		<td>
			<cfif app_social_skills1 is 'Poor'><cfinput type="radio" name="app_social_skills1" value="Poor" checked="yes" onchange="DataChanged();">
			<cfelse><cfinput type="radio" name="app_social_skills1" value="Poor" onchange="DataChanged();"></cfif> Poor
		</td>
		<td>
			<cfif app_social_skills1 is 'Inadequate'><cfinput type="radio" name="app_social_skills1" value="Inadequate" checked="yes" onchange="DataChanged();">
			<cfelse><cfinput type="radio" name="app_social_skills1" value="Inadequate" onchange="DataChanged();"></cfif> Inadequate
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	
	<tr><td valign="top"><em>Emotional stability and maturity</em></td>
		<td>
			<cfif app_social_skills2 is 'Excellent'><cfinput type="radio" name="app_social_skills2" value="Excellent" checked="yes" onchange="DataChanged();">
			<cfelse><cfinput type="radio" name="app_social_skills2" value="Excellent" onchange="DataChanged();"></cfif> Excellent
		</td>
		<td>
			<cfif app_social_skills2 is 'Very Good'><cfinput type="radio" name="app_social_skills2" value="Very Good" checked="yes" onchange="DataChanged();">
			<cfelse><cfinput type="radio" name="app_social_skills2" value="Very Good" onchange="DataChanged();"></cfif> Very Good
		</td>
		<td>
			<cfif app_social_skills2 is 'Good'><cfinput type="radio" name="app_social_skills2" value="Good" checked="yes" onchange="DataChanged();">
			<cfelse><cfinput type="radio" name="app_social_skills2" value="Good" onchange="DataChanged();"></cfif> Good
		</td>
		<td>
			<cfif app_social_skills2 is 'Fair'><cfinput type="radio" name="app_social_skills2" value="Fair" checked="yes" onchange="DataChanged();">
			<cfelse><cfinput type="radio" name="app_social_skills2" value="Fair" onchange="DataChanged();"></cfif> Fair
		</td>
		<td>
			<cfif app_social_skills2 is 'Poor'><cfinput type="radio" name="app_social_skills2" value="Poor" checked="yes" onchange="DataChanged();">
			<cfelse><cfinput type="radio" name="app_social_skills2" value="Poor" onchange="DataChanged();"></cfif> Poor
		</td>
		<td>
			<cfif app_social_skills2 is 'Inadequate'><cfinput type="radio" name="app_social_skills2" value="Inadequate" checked="yes" onchange="DataChanged();">
			<cfelse><cfinput type="radio" name="app_social_skills2" value="Inadequate" onchange="DataChanged();"></cfif> Inadequate
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>

	<tr><td valign="top"><em>Self-reliance and independence</em></td>
		<td>
			<cfif app_social_skills3 is 'Excellent'><cfinput type="radio" name="app_social_skills3" value="Excellent" checked="yes" onchange="DataChanged();">
			<cfelse><cfinput type="radio" name="app_social_skills3" value="Excellent" onchange="DataChanged();"></cfif> Excellent
		</td>
		<td>
			<cfif app_social_skills3 is 'Very Good'><cfinput type="radio" name="app_social_skills3" value="Very Good" checked="yes" onchange="DataChanged();">
			<cfelse><cfinput type="radio" name="app_social_skills3" value="Very Good" onchange="DataChanged();"></cfif> Very Good
		</td>
		<td>
			<cfif app_social_skills3 is 'Good'><cfinput type="radio" name="app_social_skills3" value="Good" checked="yes" onchange="DataChanged();">
			<cfelse><cfinput type="radio" name="app_social_skills3" value="Good" onchange="DataChanged();"></cfif> Good
		</td>
		<td>
			<cfif app_social_skills3 is 'Fair'><cfinput type="radio" name="app_social_skills3" value="Fair" checked="yes" onchange="DataChanged();">
			<cfelse><cfinput type="radio" name="app_social_skills3" value="Fair" onchange="DataChanged();"></cfif> Fair
		</td>
		<td>
			<cfif app_social_skills3 is 'Poor'><cfinput type="radio" name="app_social_skills3" value="Poor" checked="yes" onchange="DataChanged();">
			<cfelse><cfinput type="radio" name="app_social_skills3" value="Poor" onchange="DataChanged();"></cfif> Poor
		</td>
		<td>
			<cfif app_social_skills3 is 'Inadequate'><cfinput type="radio" name="app_social_skills3" value="Inadequate" checked="yes" onchange="DataChanged();">
			<cfelse><cfinput type="radio" name="app_social_skills3" value="Inadequate" onchange="DataChanged();"></cfif> Inadequate
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>

	<tr><td valign="top"><em>Effectiveness with people</em></td>
		<td>
			<cfif app_social_skills4 is 'Excellent'><cfinput type="radio" name="app_social_skills4" value="Excellent" checked="yes" onchange="DataChanged();">
			<cfelse><cfinput type="radio" name="app_social_skills4" value="Excellent" onchange="DataChanged();"></cfif> Excellent
		</td>
		<td>
			<cfif app_social_skills4 is 'Very Good'><cfinput type="radio" name="app_social_skills4" value="Very Good" checked="yes" onchange="DataChanged();">
			<cfelse><cfinput type="radio" name="app_social_skills4" value="Very Good" onchange="DataChanged();"></cfif> Very Good
		</td>
		<td>
			<cfif app_social_skills4 is 'Good'><cfinput type="radio" name="app_social_skills4" value="Good" checked="yes" onchange="DataChanged();">
			<cfelse><cfinput type="radio" name="app_social_skills4" value="Good" onchange="DataChanged();"></cfif> Good
		</td>
		<td>
			<cfif app_social_skills4 is 'Fair'><cfinput type="radio" name="app_social_skills4" value="Fair" checked="yes" onchange="DataChanged();">
			<cfelse><cfinput type="radio" name="app_social_skills4" value="Fair" onchange="DataChanged();"></cfif> Fair
		</td>
		<td>
			<cfif app_social_skills4 is 'Poor'><cfinput type="radio" name="app_social_skills4" value="Poor" checked="yes" onchange="DataChanged();">
			<cfelse><cfinput type="radio" name="app_social_skills4" value="Poor" onchange="DataChanged();"></cfif> Poor
		</td>
		<td>
			<cfif app_social_skills4 is 'Inadequate'><cfinput type="radio" name="app_social_skills4" value="Inadequate" checked="yes" onchange="DataChanged();">
			<cfelse><cfinput type="radio" name="app_social_skills4" value="Inadequate" onchange="DataChanged();"></cfif> Inadequate
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>

	<tr><td valign="top"><em>General knowledge</em></td>
		<td>
			<cfif app_social_skills5 is 'Excellent'><cfinput type="radio" name="app_social_skills5" value="Excellent" checked="yes" onchange="DataChanged();">
			<cfelse><cfinput type="radio" name="app_social_skills5" value="Excellent" onchange="DataChanged();"></cfif> Excellent
		</td>
		<td>
			<cfif app_social_skills5 is 'Very Good'><cfinput type="radio" name="app_social_skills5" value="Very Good" checked="yes" onchange="DataChanged();">
			<cfelse><cfinput type="radio" name="app_social_skills5" value="Very Good" onchange="DataChanged();"></cfif> Very Good
		</td>
		<td>
			<cfif app_social_skills5 is 'Good'><cfinput type="radio" name="app_social_skills5" value="Good" checked="yes" onchange="DataChanged();">
			<cfelse><cfinput type="radio" name="app_social_skills5" value="Good" onchange="DataChanged();"></cfif> Good
		</td>
		<td>
			<cfif app_social_skills5 is 'Fair'><cfinput type="radio" name="app_social_skills5" value="Fair" checked="yes" onchange="DataChanged();">
			<cfelse><cfinput type="radio" name="app_social_skills5" value="Fair" onchange="DataChanged();"></cfif> Fair
		</td>
		<td>
			<cfif app_social_skills5 is 'Poor'><cfinput type="radio" name="app_social_skills5" value="Poor" checked="yes" onchange="DataChanged();">
			<cfelse><cfinput type="radio" name="app_social_skills5" value="Poor" onchange="DataChanged();"></cfif> Poor
		</td>
		<td>
			<cfif app_social_skills5 is 'Inadequate'><cfinput type="radio" name="app_social_skills5" value="Inadequate" checked="yes" onchange="DataChanged();">
			<cfelse><cfinput type="radio" name="app_social_skills5" value="Inadequate" onchange="DataChanged();"></cfif> Inadequate
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>

	<tr><td valign="top"><em>Impression he/she will make abroad</em></td>
		<td>
			<cfif app_social_skills6 is 'Excellent'><cfinput type="radio" name="app_social_skills6" value="Excellent" checked="yes" onchange="DataChanged();">
			<cfelse><cfinput type="radio" name="app_social_skills6" value="Excellent" onchange="DataChanged();"></cfif> Excellent
		</td>
		<td>
			<cfif app_social_skills6 is 'Very Good'><cfinput type="radio" name="app_social_skills6" value="Very Good" checked="yes" onchange="DataChanged();">
			<cfelse><cfinput type="radio" name="app_social_skills6" value="Very Good" onchange="DataChanged();"></cfif> Very Good
		</td>
		<td>
			<cfif app_social_skills6 is 'Good'><cfinput type="radio" name="app_social_skills6" value="Good" checked="yes" onchange="DataChanged();">
			<cfelse><cfinput type="radio" name="app_social_skills6" value="Good" onchange="DataChanged();"></cfif> Good
		</td>
		<td>
			<cfif app_social_skills6 is 'Fair'><cfinput type="radio" name="app_social_skills6" value="Fair" checked="yes" onchange="DataChanged();">
			<cfelse><cfinput type="radio" name="app_social_skills6" value="Fair" onchange="DataChanged();"></cfif> Fair
		</td>
		<td>
			<cfif app_social_skills6 is 'Poor'><cfinput type="radio" name="app_social_skills6" value="Poor" checked="yes" onchange="DataChanged();">
			<cfelse><cfinput type="radio" name="app_social_skills6" value="Poor" onchange="DataChanged();"></cfif> Poor
		</td>
		<td>
			<cfif app_social_skills6 is 'Inadequate'><cfinput type="radio" name="app_social_skills6" value="Inadequate" checked="yes" onchange="DataChanged();">
			<cfelse><cfinput type="radio" name="app_social_skills6" value="Inadequate" onchange="DataChanged();"></cfif> Inadequate
		</td>
	</tr>
</table><br>

<hr class="bar"></hr><br>

<table width="670" border=0 cellpadding=3 cellspacing=0 align="center">
	<tr><td align="center">
		<div align="justify">
		<em>Please briefly comment about this student's motivation, reason for wanting to be an exchange student, 
		potential for success, study habits, and any other information you think will assist us in evaluating this individual.</em>
		</div>
	</td></tr>
	<tr><td align="center"><textarea name="app_social_reason" cols="100" rows="14" onchange="DataChanged();">#app_social_reason#</textarea></td></tr>
</table><br>

<hr class="bar"></hr><br>

<table width="670" border=0 cellpadding=0 cellspacing=0 align="center">
	<tr><td colspan="2"><em>English Teacher's</em></td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td width="315"><em>Name</em></td><td width="40">&nbsp;</td><td width="315">&nbsp;</td></tr>
	<tr>
		<td colspan="3"><cfinput type="text" name="app_teacher_name" size="45" value="#app_teacher_name#" maxlength="100" onchange="DataChanged();"></td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td colspan="3"><em>School</em></td></tr>
	<tr>
		<td colspan="3"><cfinput type="text" name="app_teacher_school" size="45" value="#app_teacher_school#" maxlength="100" onchange="DataChanged();"></td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td><em>Address</em></td><td>&nbsp;</td><td><em>Phone Number</em></td></tr>
	<tr>
		<td><cfinput type="text" name="app_teacher_address" size="45" value="#app_teacher_address#" maxlength="100" onchange="DataChanged();"></td>
		<td>&nbsp;</td>
		<td><cfinput type="text" name="app_teacher_phone" size="16" value="#app_teacher_phone#" maxlength="20" onchange="DataChanged();"></td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td><em>Date of Interview (mm/dd/yyyy)</em></td><td>&nbsp;</td><td><em>Date of Evaluation (mm/dd/yyyy)</em></td></tr>
	<tr>
		<td><cfinput type="text" name="app_interview_date" size="15" maxlength="10" validate="date" value="#DateFormat(app_interview_date, 'mm/dd/yyyy')#" onchange="DataChanged();" validateat="onsubmit,onserver" message="Date of Interview - Please enter a valid date in the MM/DD/YYYY format."></td>
		<td>&nbsp;</td>
		<td><cfinput type="text" name="app_evaluation_date" size="15" maxlength="10" validate="date" value="#DateFormat(app_evaluation_date, 'mm/dd/yyyy')#" onchange="DataChanged();" validateat="onsubmit,onserver" message="Date of Evaluation - Please enter a valid date in the MM/DD/YYYY format."></td>
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