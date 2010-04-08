<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>Page [09] - Language Evaluation</title>
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
	<cflocation url="?curdoc=section2/page9print&id=2&p=9" addtoken="no">
</cfif>

<SCRIPT>
<!--
function CheckLink()
{
  if (document.page9.CheckChanged.value != 0)
  {
    if (confirm("You have made changes on this page that have not been saved.\n\These changes will be lost if you navigate away from this page.\n\Click OK to contine and discard changes, or click cancel and click on save to save your changes."))
      return true;
    else
      return false;
  }
}
function DataChanged()
{
  document.page9.CheckChanged.value = 1
}
function NextPage() {
	document.page9.action = '?curdoc=section2/qr_page9&next';
	}
//-->
</SCRIPT>

<cfinclude template="../querys/get_student_info.cfm">

<cfset doc = 'page09'>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="../pics/students.gif"></td>
		<td class="tablecenter"><h2>Page [09] - Language Evaluation</h2></td>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section2/page9print.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		<td width="42" class="tableside"><img src="pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<cfform action="?curdoc=section2/qr_page9" method="post" name="page9">

<cfoutput query="get_student_info">

<cfinput type="hidden" name="studentid" value="#studentid#">
<cfinput type="hidden" name="CheckChanged" value="0">

<div class="section"><br>

<!--- Check uploaded file - Upload File Button --->
<cfinclude template="../check_uploaded_file.cfm">

<table width="670" border=0 cellpadding=1 cellspacing=0 align="center">
	<tr><td align="center"><b>Pages 9 and 10 must be completed by Present English teacher</b></td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td align="center">
			<div align="justify">
			The purpose of this form is to help us evaluate this student's reading, writing, and verbal English language skills.
			It is crucial that your evaluation be as accurate as possible. 
			<i><u>Rating a student better than his or her actual ability may result in serious problems for the student 
			and the host school.</u></i>
			We trust you will be conscientious during this interview and will complete our form carefully, 
			accurately and honestly. Thank you.
			</div>
	</td></tr>
</table><br><br>

<table width="670" border=0 cellpadding=3 cellspacing=0 align="center">
	<tr><td valign="top"><b>Reading:</b></td>
		<td colspan="2"><div align="justify"><em>When asked to read aloud in English from a book, magazine, or newspaper, the student is able to:</em></div></td></tr>
	<tr><td>&nbsp;</td>
		<td valign="top" width="90">
			<cfif app_reading_skills is 'Excellent'><cfinput type="radio" name="app_reading_skills" value="Excellent" checked="yes" onchange="DataChanged();">
			<cfelse><cfinput type="radio" name="app_reading_skills" value="Excellent" onchange="DataChanged();"></cfif> Excellent</td>
		<td><div align="justify">Read with few errors and can easily explain its meaning.</div></td></tr>
	<tr><td>&nbsp;</td>
		<td valign="top" width="90">
			<cfif app_reading_skills is 'Good'><cfinput type="radio" name="app_reading_skills" value="Good" checked="yes" onchange="DataChanged();">
			<cfelse><cfinput type="radio" name="app_reading_skills" value="Good" onchange="DataChanged();"></cfif> Good</td>
		<td><div align="justify">Read well except for very difficult terms and can explain most of the ideas.</div></td></tr>
	<tr><td>&nbsp;</td>
		<td valign="top" width="90">
			<cfif app_reading_skills is 'Fair'><cfinput type="radio" name="app_reading_skills" value="Fair" checked="yes" onchange="DataChanged();">
			<cfelse><cfinput type="radio" name="app_reading_skills" value="Fair" onchange="DataChanged();"></cfif> Fair</td>
		<td><div align="justify">Read most of the vocabulary and explain the basic idea.</div></td></tr>
	<tr><td>&nbsp;</td>
		<td valign="top" width="90">
			<cfif app_reading_skills is 'Poor'><cfinput type="radio" name="app_reading_skills" value="Poor" checked="yes" onchange="DataChanged();">
			<cfelse><cfinput type="radio" name="app_reading_skills" value="Poor" onchange="DataChanged();"></cfif> Poor</td>
		<td><div align="justify">Read and understand only the simplest words, and can explain little or none of the meaning.</div></td></tr>	

	<tr><td>&nbsp;</td></tr>	<tr><td>&nbsp;</td></tr>
	
	<tr><td valign="top"><b>Writing:</b></td>
		<td colspan="2"><div align="justify"><em>When asked to write a short essay in English stating what he or she hopes to gain from being an 
			exchange student, the student:</em></div></td></tr>
	<tr><td>&nbsp;</td>
		<td valign="top">
			<cfif app_writing_skills is 'Excellent'><cfinput type="radio" name="app_writing_skills" value="Excellent" checked="yes" onchange="DataChanged();">
			<cfelse><cfinput type="radio" name="app_writing_skills" value="Excellent" onchange="DataChanged();"></cfif> Excellent</td>
		<td><div align="justify">Writes fluently using lengthy sentences and abstract terms, with a good English vocabulary and sentence structure.</div></td></tr>
	<tr><td>&nbsp;</td>
		<td valign="top" width="90">
			<cfif app_writing_skills is 'Good'><cfinput type="radio" name="app_writing_skills" value="Good" checked="yes" onchange="DataChanged();">
			<cfelse><cfinput type="radio" name="app_writing_skills" value="Good" onchange="DataChanged();"></cfif> Good</td>
		<td><div align="justify">May use irregular grammar, but uses fair vocabulary in lengthy sentences. </div><br></td></tr>
	<tr><td>&nbsp;</td>
		<td valign="top" width="90">
			<cfif app_writing_skills is 'Fair'><cfinput type="radio" name="app_writing_skills" value="Fair" checked="yes" onchange="DataChanged();">
			<cfelse><cfinput type="radio" name="app_writing_skills" value="Fair" onchange="DataChanged();"></cfif> Fair</td>
		<td><div align="justify">Writes only simple sentences with elementary vocabulary. Grammar is extremely irregular, but understandable.</div></td></tr>
	<tr><td>&nbsp;</td>
		<td valign="top" width="90">
			<cfif app_writing_skills is 'Poor'><cfinput type="radio" name="app_writing_skills" value="Poor" checked="yes" onchange="DataChanged();">
			<cfelse><cfinput type="radio" name="app_writing_skills" value="Poor" onchange="DataChanged();"></cfif> Poor</td>
		<td><div align="justify">Uses very limited vocabulary and is difficult to understand.</div></td></tr>	
			
	<tr><td>&nbsp;</td></tr>	<tr><td>&nbsp;</td></tr>
	
	<tr><td valign="top"><b>Verbal:</b></td>
		<td colspan="2"><div align="justify"><em>Estimate the student's ability to understand and speak English after engaging the student in English-only 
			conversation about current events.</em></div></td></tr>
	<tr><td>&nbsp;</td>
		<td valign="top">
			<cfif app_verbal_skills is 'Excellent'><cfinput type="radio" name="app_verbal_skills" value="Excellent" checked="yes" onchange="DataChanged();">
			<cfelse><cfinput type="radio" name="app_verbal_skills" value="Excellent" onchange="DataChanged();"></cfif> Excellent</td>
		<td><div align="justify">Student is nearly fluent and can understand and respond to difficult questions including abstract terms. 
			Will have no problem communicating upon arrival.</div></td></tr>	
	<tr><td>&nbsp;</td>
		<td valign="top" width="90">
			<cfif app_verbal_skills is 'Good'><cfinput type="radio" name="app_verbal_skills" value="Good" checked="yes" onchange="DataChanged();">
			<cfelse><cfinput type="radio" name="app_verbal_skills" value="Good" onchange="DataChanged();"></cfif> Good</td>
		<td><div align="justify">Student can understand most conversation. Responds slowly at times, but with appropriate answers. 
			Is inquisitive and is able to pose necessary questions correctly.</div></td></tr>
	<tr><td>&nbsp;</td>
		<td valign="top" width="90">
			<cfif app_verbal_skills is 'Fair'><cfinput type="radio" name="app_verbal_skills" value="Fair" checked="yes" onchange="DataChanged();">
			<cfelse><cfinput type="radio" name="app_verbal_skills" value="Fair" onchange="DataChanged();"></cfif> Fair</td>
		<td><div align="justify">Student's speaking ability is limited to a few basic words or phrases. Comprehension is limited. 
			Student gets frustrated and easily reverts to his/her native language.</div></td></tr>
	<tr><td>&nbsp;</td>
		<td valign="top" width="90">
			<cfif app_verbal_skills is 'Poor'><cfinput type="radio" name="app_verbal_skills" value="Poor" checked="yes" onchange="DataChanged();">
			<cfelse><cfinput type="radio" name="app_verbal_skills" value="Poor" onchange="DataChanged();"></cfif> Poor</td>
		<td><div align="justify">Student can understand basic English, but is translating. Makes mistakes, but can be understood.</div></td></tr>	

</table><br><br>

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