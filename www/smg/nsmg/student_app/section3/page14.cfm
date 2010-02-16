<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>Page [14] - Authorization to Treat a Minor</title>
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
	<cflocation url="?curdoc=section3/page14print&id=3&p=14" addtoken="no">
</cfif>

<script type="text/javascript">
<!--
function CheckLink()
{
  if (document.page14.CheckChanged.value != 0)
  {
    if (confirm("You have made changes on this page that have not been saved.\n\These changes will be lost if you navigate away from this page.\n\Click OK to contine and discard changes, or click cancel and click on save to save your changes."))
      return true;
    else
      return false;
  }
}
function DataChanged()
{
  document.page14.CheckChanged.value = 1;
}
function NextPage() {
	document.page14.action = '?curdoc=section3/qr_page14&next';
	}
//-->
</SCRIPT>

<cfinclude template="../querys/get_student_info.cfm">

<cfset doc = 'page14'>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="../pics/students.gif"></td>
		<td class="tablecenter"><h2>Page [14] - Authorization to Treat a Minor</h2></td>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section3/page14print.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		<td width="42" class="tableside"><img src="pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<cfform action="?curdoc=section3/qr_page14" method="post" name="page14">

<cfoutput query="get_student_info">

<cfinput type="hidden" name="studentid" value="#studentid#">
<cfinput type="hidden" name="CheckChanged" value="0">

<div class="section"><br>

<!--- Check uploaded file - Upload File Button --->
<cfinclude template="../check_uploaded_file.cfm">

<table width="670" border=0 cellpadding=1 cellspacing=0 align="center">
	<tr><td>1. (We) the undersigned parent(s), or legal guardian of:</td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td>
			<div align="justify">
			<u>#get_student_info.firstname# #get_student_info.familylastname#,</u> a minor, do hereby authorize and consent to any x-ray
			examination, anesthetic, or medical or surgical diagnosis rendered under the general or special supervision of any member
			of the medical staff and emergency room staff licensed under the provisions of the Medicine Practice Act, or a dentist
			licensed under the provisions of the Dental Practice Act and on the staff of any acute general hospital holding a current
			license to operate a hospital. It is understood that this authorization is given in advance of any specific diagnosis, 
			treatment, or hospital care being required, but is given to provide authority and power to render care which the
			aforementioned physician in the exercise of his best judgment may deem advisable. It is understood that effort shall be
			made to contact the undersigned prior to rendering treatment to the patient, but that any of the above treatment will not
			be withheld if the undersigned cannot be reached.<br>
			Furthermore, we (parents/guardian) want to assure you that we will reimburse any expenditure not covered by the accident
			and sickness insurance policy of the exchange organization.
			</div>
	</td></tr>
</table><br>

<table width="670" border=0 cellpadding=1 cellspacing=0 align="center">
	<tr><td><em>List any restrictions:</em></td></tr>
	<tr><td><cfinput type="text" name="app_med_restrictions" size="80" value="#app_med_restrictions#" maxlength="100" onchange="DataChanged();"></td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td><em>Allergies to Drugs or Foods:</em></td></tr>
	<tr><td><cfinput type="text" name="other_allergies" size="80" value="#other_allergies#" maxlength="100" onchange="DataChanged();"></td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td><em>List medications taken regularly:</em></td></tr>
	<tr><td><cfinput type="text" name="app_med_take_medication" size="80" value="#app_med_take_medication#" maxlength="100" onchange="DataChanged();"></td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td><em>Special Medications or pertinent information:</em></td></tr>
	<tr><td><cfinput type="text" name="app_med_special_medication" size="80" value="#app_med_special_medication#" maxlength="100" onchange="DataChanged();"></td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td>Date of last tetanus toxide booster</td></tr>
	<tr><td><cfinput type="text" name="app_med_tetanus_shot" size="15" maxlength="10" value="#DateFormat(app_med_tetanus_shot, 'mm/dd/yyyy')#" validate="date" message="Please, enter a valid date." onchange="DataChanged();"> (mm/dd/yyyy)</td></tr>
	<tr><td>&nbsp;</td></tr>
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