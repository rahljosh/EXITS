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

<cfif (client.usertype EQ 10 AND (get_latest_status.status GTE 3 AND get_latest_status.status NEQ 4 AND get_latest_status.status NEQ 6))  <!--- STUDENT ---->
	OR (client.usertype EQ 11 AND (get_latest_status.status GTE 4 AND get_latest_status.status NEQ 6))  <!--- BRANCH ---->
	OR (client.usertype EQ 8 AND (get_latest_status.status GTE 6 AND get_latest_status.status NEQ 9)) <!--- INTL. AGENT ---->
	OR (client.usertype GTE 5 AND client.usertype LTE 7 OR client.usertype EQ 9)> <!--- FIELD --->
    <!--- Office users should be able to edit online apps --->
    <!--- OR (client.usertype LTE 4 AND get_latest_status.status GTE 7) <!--- OFFICE USERS ---> --->
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
				<u>#get_student_info.firstname# #get_student_info.familylastname#,</u> a minor (hereafter "Exchange Student"), do hereby authorize and consent to the following:
				<br/><br/>
				AUTHORIZATION AND CONSENT OF PARENT(S) OR LEGAL GUARDIAN(S) 
 				<br/><br/>
				I do hereby state that I have legal custody of the aforementioned Minor. I grant my authorization and consent for #CLIENT.companyName# (#CLIENT.companyShort#), it's officers, staff, regional managers , Area Representatives and Host Families (hereafter “Designated Adults”) to administer general first aid treatment for any minor injuries or illnesses experienced by the Exchange Student. If the injury or illness is life threatening or in need of professional medical treatment treatment, I authorize the Designated Adults to summon any and all professional emergency personnel to attend, transport, and treat the minor and to issue consent for any X-ray, anesthetic, blood transfusion, medication, or other medical diagnosis, treatment, or hospital care deemed advisable by, and to be rendered under the general supervision of, any licensed physician, surgeon, dentist, hospital, or other medical professional or institution duly licensed to practice in 
the state in which such treatment is to occur. I agree to assume financial responsibility for all expenses of such care. 
				<br/><br/>
				I also understand that certain vaccinations may be required for the Exchange Student to participate in certain schools and that the vaccination requirements vary across each state in the United States.  If the documentation of these vaccinations has not been included in the student application submitted to #CLIENT.companyShort#, I authorize the Designated Adults to have the required vaccines administered to the Exchange Student.  I agree to assume financial responsibility for all expenses related to the administration of these vaccines.
 				<br/><br/>
				It is understood that this authorization is given in advance of any such medical treatment, but is given to provide authority and power on the part of the Designated Adult in the exercise of his or her best judgment upon the advice of any such medical or emergency personnel.
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