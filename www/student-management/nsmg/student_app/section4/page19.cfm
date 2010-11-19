<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>Page [19] - Personal Interview & English Fluency Assessment</title>
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
	<cflocation url="?curdoc=section4/page19print&id=4&p=19" addtoken="no">
</cfif>

<script type="text/javascript">
<!--
function CheckLink()
{
  if (document.page19.CheckChanged.value != 0)
  {
    if (confirm("You have made changes on this page that have not been submited.\n\These changes will be lost if you navigate away from this page.\n\Click OK to contine and discard changes, or click cancel and submit to save your changes."))
      return true;
    else
      return false;
  }
}
function DataChanged()
{
  document.page19.CheckChanged.value = 1;
}
function NextPage() {
	document.page19.action = '?curdoc=section4/qr_page19&next';
	}
//-->
</SCRIPT>

<cfinclude template="../querys/get_student_info.cfm">

<Cfset doc = 'page19'>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="../pics/students.gif"></td>
		<td class="tablecenter"><h2>Page [19] - Personal Interview & English Fluency Assessment</h2></td>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section4/page19print.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		<td width="42" class="tableside"><img src="pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<cfform action="?curdoc=section4/qr_page19" method="post" name="page19">

<cfoutput query="get_student_info">

<cfinput type="hidden" name="studentid" value="#studentid#">
<cfinput type="hidden" name="CheckChanged" value="0">

<cfquery name="intl_agent" datasource="MySql">
	SELECT businessname
	FROM smg_users
	WHERE userid = <cfqueryparam value="#get_student_info.intrep#">
</cfquery>

<div class="section"><br>

<!--- Intl. Representative Documents --->
<cfif client.usertype EQ '8' OR client.usertype EQ '11'>
	<cfset readonly = ''>
	<!--- Check uploaded file - Upload File Button --->
	<cfinclude template="../check_uploaded_file.cfm">
<cfelse>
<cfinclude template="../check_uploaded_file.cfm">
	<cfset readonly = 'disabled'>
	<table width="670" border=0 cellpadding=3 cellspacing=0 align="center">
		<tr><td><h3>Note: This page needs to be completed and uploaded by #intl_agent.businessname#.</h3></td></tr>
	</table><br>
</cfif>

<table width="670" border=0 cellpadding=3 cellspacing=0 align="center">
	<tr><td align="center"><b>Personal Interview & English Fluency Assessment<b></td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td><div align="justify">Please complete this section indicating level of student's English comprehension and communication.
			This form should be completed after the mandatory ten (10) minute English language interview is conducted. No other comments should be
			included other than notes about the oral interview.</div></td></tr>	
</table><br>
	
<table width="670" border=0 cellpadding=3 cellspacing=0 align="center">
	<tr><td><em>In my estimation, this student understands and speaks English at the following level:</em></td>
	<tr><td valign="top">
			<cfif app_interview_english_level is 'Excellent'><input type="radio" name="app_interview_english_level" value="Excellent" checked="yes" onchange="DataChanged();" #readonly#>
			<cfelse><input type="radio" name="app_interview_english_level" value="Excellent" onchange="DataChanged();" #readonly#></cfif> Excellent</td>
	</tr>
	<tr><td valign="top">
			<cfif app_interview_english_level is 'Advanced'><input type="radio" name="app_interview_english_level" value="Advanced" checked="yes" onchange="DataChanged();" #readonly#>
			<cfelse><input type="radio" name="app_interview_english_level" value="Advanced" onchange="DataChanged();" #readonly#></cfif> Advanced</td>
	</tr>
	<tr><td valign="top">
			<cfif app_interview_english_level is 'Intermediate'><input type="radio" name="app_interview_english_level" value="Intermediate" checked="yes" onchange="DataChanged();" #readonly#>
			<cfelse><input type="radio" name="app_interview_english_level" value="Intermediate" onchange="DataChanged();" #readonly#></cfif> Intermediate</td>
	</tr>
	<tr><td valign="top">
			<cfif app_interview_english_level is 'Advanced Beginner'><input type="radio" name="app_interview_english_level" value="Advanced Beginner" checked="yes" onchange="DataChanged();" #readonly#>
			<cfelse><input type="radio" name="app_interview_english_level" value="Advanced Beginner" onchange="DataChanged();" #readonly#></cfif> Advanced Beginner</td>
	</tr>
	<tr><td valign="top">
			<cfif app_interview_english_level is 'Beginner'><input type="radio" name="app_interview_english_level" value="Beginner" checked="yes" onchange="DataChanged();" #readonly#>
			<cfelse><input type="radio" name="app_interview_english_level" value="Beginner" onchange="DataChanged();" #readonly#></cfif> Beginner</td>
	</tr>
</table><br>

<table width="670" border=0 cellpadding=3 cellspacing=0 align="center">
	<tr><td align="center">
		<div align="justify"><em>Please note student's strengths and weaknesses with spoken English: </em></div>
	</td></tr>
	<tr><td align="center"><textarea name="app_interview_strengths" cols="100" rows="14" onchange="DataChanged();" #readonly#>#app_interview_strengths#</textarea></td></tr>
</table><br>
	
<table width="670" border=0 cellpadding=3 cellspacing=0 align="center">
	<tr><td align="center">
		<div align="justify"><em>Please note any other factors that could affect student's ability to communicate in English after his/her arrival in the United States: </em></div>
	</td></tr>
	<tr><td align="center"><textarea name="app_interview_other" cols="100" rows="14" onchange="DataChanged();" #readonly#>#app_interview_other#</textarea></td></tr>
</table><br>
</div>

<!--- Intl. Representative Documents --->
<cfif client.usertype EQ '8' OR client.usertype EQ '11'>
	<!--- PAGE BUTTONS --->
	<cfinclude template="../page_buttons.cfm">
<cfelse>
	<table width=100% border=0 cellpadding=0 cellspacing=0 class="section" align="center">
		<tr>
			<td align="center" valign="bottom" class="buttontop">
				<a href="index.cfm?curdoc=section4/page20&id=4&p=20"><img src="pics/next.gif" border="0"></a>
			</td>
		</tr>
	</table>
</cfif>

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