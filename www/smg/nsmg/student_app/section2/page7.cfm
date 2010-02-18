<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>Page [07] - School Information</title>
</head>
<BODY >

<cftry>

<!--- relocate users if they try to access the edit page without permission --->
<cfinclude template="../querys/get_latest_status.cfm">

<cfif (client.usertype EQ 10 AND (get_latest_status.status GTE 3 AND get_latest_status.status NEQ 4 AND get_latest_status.status NEQ 6))  <!--- STUDENT ---->
	OR (client.usertype EQ 11 AND (get_latest_status.status GTE 4 AND get_latest_status.status NEQ 6))  <!--- BRANCH ---->
	OR (client.usertype EQ 8 AND (get_latest_status.status GTE 6 AND get_latest_status.status NEQ 9)) <!--- INTL. AGENT ---->
	OR (client.usertype GTE 5 AND client.usertype LTE 7 OR client.usertype EQ 9)> <!--- FIELD --->
    <!--- Office users should be able to edit online apps --->
    <!--- OR (client.usertype LTE 4 AND get_latest_status.status GTE 7) <!--- OFFICE USERS ---> --->
	<cflocation url="?curdoc=section2/page7print&id=2&p=7" addtoken="no">
</cfif>

<script type="text/javascript">
<!--
function CheckLink()
{
  if (document.page7.CheckChanged.value != 0)
  {
    if (confirm("You have made changes on this page that have not been submited.\n\These changes will be lost if you navigate away from this page.\n\Click OK to contine and discard changes, or click cancel and submit to save your changes."))
      return true;
    else
      return false;
  }
}
function DataChanged()
{
  document.page7.CheckChanged.value = 1;
}
function NextPage() {
	document.page7.action = '?curdoc=section2/qr_page7&next';
	}
//-->
</SCRIPT>
<SCRIPT>
<!--
function change(href)

{

	window.location.href = href;

}
<cfinclude template="../querys/get_student_info.cfm">
//-->
</SCRIPT>
<cfset doc = 'page07'>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="../pics/students.gif"></td>
		<td class="tablecenter"><h2>Page [07] - School Information</h2></td>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section2/page7print.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		<td width="42" class="tableside"><img src="pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<cfform action="?curdoc=section2/qr_page7" method="post" name="page7">

<cfoutput query="get_student_info">

<cfinput type="hidden" name="studentid" value="#studentid#">
<cfinput type="hidden" name="CheckChanged" value="0">

<div class="section"><br>

<!--- Check uploaded file - Upload File Button --->
<cfinclude template="../check_uploaded_file.cfm">

<table width="670" border=0 cellpadding=1 cellspacing=0 align="center">
	<tr><td align="center"><b>SCHOOL INFORMATION</b></td></tr>
	<tr><td>&nbsp;</td></tr>
</table>

<table width="670" border=0 cellpadding=3 cellspacing=0 align="center">
	<tr><td width="120"><em>School's Name</em></td>
		<td><cfinput type="text" name="app_school_name" size="45" value="#app_school_name#" onchange="DataChanged();"></td></tr>
	<tr><td><em>Address</em></td>
		<td><cfinput type="text" name="app_school_add" size="45" value="#app_school_add#" onchange="DataChanged();"></td></tr>	
	<tr><td><em>Telephone</em></td>
		<td><cfinput type="text" name="app_school_phone" size="45" value="#app_school_phone#" onchange="DataChanged();"></td></tr>
	<tr><td><em>Public or Private</em></td>
		<td>
			<cfif app_school_type is 'Public'><cfinput type="radio" name="app_school_type" value="Public" checked="yes" onchange="DataChanged();">Public<cfelse><cfinput type="radio" name="app_school_type" value="Public" onchange="DataChanged();">Public</cfif>&nbsp; &nbsp;
			<cfif app_school_type is 'Private'><cfinput type="radio" name="app_school_type" value="Private" checked="yes" onchange="DataChanged();">Private<cfelse><cfinput type="radio" name="app_school_type" value="Private" onchange="DataChanged();">Private</cfif>	
		</td>
	</tr>
	<tr><td><em>Administrator's Name</em></td>
		<td><cfinput type="text" name="app_school_person" size="45" value="#app_school_person#" onchange="DataChanged();"></td></tr>
	<tr><td>&nbsp;</td></tr>
</table>

<hr class="bar"></hr><br>

<table width="670" border=0 cellpadding=1 cellspacing=0 align="center">
	<tr><td colspan="4" align="center"><b>GRADE CONVERSION CHART</b></td></tr>
	<tr><td colspan="4" align="center"><em>Please explain your grading system.</em></td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td width="130"><em>American Grades</em></td>
		<td width="100">&nbsp;</td>
		<td width="180"><em>Country Equivalent</em></td>
		<td width="260"><em>Comments or explanations</em></td>
	</tr>		
	<tr>
		<td>Superior</td>
		<td>A+</td>
		<td><cfinput type="text" name="app_grade_1" size="20" value="#app_grade_1#" maxlength="20" onchange="DataChanged();"></td>
		<td><cfinput type="text" name="app_grade_1_com" size="35" value="#app_grade_1_com#" maxlength="50" onchange="DataChanged();"></td>
	</tr>
	<tr>
		<td>Excellent</td>
		<td>A</td>
		<td><cfinput type="text" name="app_grade_2" size="20" value="#app_grade_2#" maxlength="20" onchange="DataChanged();"></td>
		<td><cfinput type="text" name="app_grade_2_com" size="35" value="#app_grade_2_com#" maxlength="50" onchange="DataChanged();"></td>
	</tr>
	<tr>
		<td>Very Good</td>
		<td>A- or B+</td>
		<td><cfinput type="text" name="app_grade_3" size="20" value="#app_grade_3#" maxlength="20" onchange="DataChanged();"></td>
		<td><cfinput type="text" name="app_grade_3_com" size="35" value="#app_grade_3_com#" maxlength="50" onchange="DataChanged();"></td>		
	</tr>
	<tr>
		<td>Good</td>
		<td>B or B-</td>
		<td><cfinput type="text" name="app_grade_4" size="20" value="#app_grade_4#" maxlength="20" onchange="DataChanged();"></td>
		<td><cfinput type="text" name="app_grade_4_com" size="35" value="#app_grade_4_com#" maxlength="50" onchange="DataChanged();"></td>
	</tr>
	<tr>
		<td>Average</td>
		<td>C</td>
		<td><cfinput type="text" name="app_grade_5" size="20" value="#app_grade_5#" maxlength="20" onchange="DataChanged();"></td>
		<td><cfinput type="text" name="app_grade_5_com" size="35" value="#app_grade_5_com#" maxlength="50" onchange="DataChanged();"></td>
	</tr>
	<tr>
		<td>Sufficient</td>
		<td>C-</td>
		<td><cfinput type="text" name="app_grade_6" size="20" value="#app_grade_6#" maxlength="20" onchange="DataChanged();"></td>
		<td><cfinput type="text" name="app_grade_6_com" size="35" value="#app_grade_6_com#" maxlength="50" onchange="DataChanged();"></td>
	</tr>
	<tr>
		<td>Poor</td>
		<td>D</td>
		<td><cfinput type="text" name="app_grade_7" size="20" value="#app_grade_7#" maxlength="20" onchange="DataChanged();"></td>
		<td><cfinput type="text" name="app_grade_7_com" size="35" value="#app_grade_7_com#" maxlength="50" onchange="DataChanged();"></td>
	</tr>
	<tr>
		<td>Fail</td>
		<td>F</td>
		<td><cfinput type="text" name="app_grade_8" size="20" value="#app_grade_8#" maxlength="20" onchange="DataChanged();"></td>
		<td><cfinput type="text" name="app_grade_8_com" size="35" value="#app_grade_8_com#" maxlength="50" conchange="DataChanged();"></td>
	</tr>
	<tr><td>&nbsp;</td></tr>
</table>                

<table width="670" border=0 cellpadding=0 cellspacing=0 align="center">
	<tr>
		<td><em>What grade level will student have completed upon arrival in the USA?</em></td>
		<td>
			<cfif grades is '9'> <cfinput type="radio" name="grades" value="9" checked="yes" onchange="DataChanged();"> <cfelse> <cfinput type="radio" name="grades" value="9" onchange="DataChanged();"> </cfif>  9<sup>th</sup> 
			<cfif grades is '10'><cfinput type="radio" name="grades" value="10" checked="yes" onchange="DataChanged();"> <cfelse> <cfinput type="radio" name="grades" value="10" onchange="DataChanged();"> </cfif> 10<sup>th</sup>
			<cfif grades is '11'><cfinput type="radio" name="grades" value="11" checked="yes" onchange="DataChanged();"> <cfelse> <cfinput type="radio" name="grades" value="11" onchange="DataChanged();"> </cfif> 11<sup>th</sup>
			<cfif grades is '12'><cfinput type="radio" name="grades" value="12" checked="yes" onchange="DataChanged();"> <cfelse> <cfinput type="radio" name="grades" value="12" onchange="DataChanged();"> </cfif> 12<sup>th</sup>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td><em>Upon arrival, will the student have completed secondary school in his/her home country?</em></td>
		<td>
			<cfif app_completed_school is 'Yes'><cfinput type="radio" name="app_completed_school" value="Yes" checked="yes" onchange="DataChanged();">Yes<cfelse><cfinput type="radio" name="app_completed_school" value="Yes" onchange="DataChanged();">Yes</cfif>&nbsp; &nbsp;
			<cfif app_completed_school is 'No'><cfinput type="radio" name="app_completed_school" value="No" checked="yes" onchange="DataChanged();">No<cfelse><cfinput type="radio" name="app_completed_school" value="No" onchange="DataChanged();">No</cfif>	
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>	
	<tr>
		<td><em>Does the student need to have his/her transcript convalidated?</em></td>
		<td>
			<cfif convalidation_needed is 'Yes'><cfinput type="radio" name="convalidation_needed" value="Yes" checked="yes" onchange="DataChanged();">Yes<cfelse><cfinput type="radio" name="convalidation_needed" value="Yes" onchange="DataChanged();">Yes</cfif>&nbsp; &nbsp;
			<cfif convalidation_needed is 'No'><cfinput type="radio" name="convalidation_needed" value="No" checked="yes" onchange="DataChanged();">No<cfelse><cfinput type="radio" name="convalidation_needed" value="No" onchange="DataChanged();">No</cfif>	
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
</table>

<table width="670" border=0 cellpadding=0 cellspacing=0 align="center">
	<tr>
		<td width="48%"><div align="justify">
				<u>Enrollment in the exchange program is primarily for a cultural exchange.
				A high school diploma or graduation is not guaranteed to any student.</u>
				Credit for academic achievements earned while abroad shall be determined solely 
				by the student's native school upon the completion of the program. While the
				program cannot guarantee specific courses will be available for this student, 
				please list any	courses you recommend this student be enrolled in while partipating
				in the exchange program, especially for those who need to convalidate their grades.</div>
		</td>
		<td width="4%">&nbsp;</td>
		<td width="48%" valign="top"><textarea name="app_extra_courses" onchange="DataChanged();" cols="43" rows="9">#app_extra_courses#</textarea></td>
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