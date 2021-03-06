<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>Page [03] - Personal Data</title>
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
	<cflocation url="?curdoc=section1/page3print&id=1&p=3" addtoken="no">
</cfif>

<script language="javascript">
<!--
function CheckLink()
{
  if (document.page3.CheckChanged.value != 0)
  {
    if (confirm("You have made changes on this page that have not been saved.\n\These changes will be lost if you navigate away from this page.\n\Click OK to contine and discard changes, or click cancel and click on save to save your changes."))
      return true;
    else
      return false;
  }
}
function DataChanged()
{
  document.page3.CheckChanged.value = 1
}
function CheckFields() {
   var Counter = 0;
   for (i=0; i<document.page3.interests.length; i++){
      if (document.page3.interests[i].checked){
         Counter++;
      }
   }
   if (Counter > 6){
      alert("You have selected " +Counter+ " interests.\n\You must select at least 3 and no more than 6.");
      return false;
   } else if ((Counter != 0) && (Counter < 3)) {
      alert("You have selected " +Counter+ " interests.\n\You must select at least 3 and no more than 6.");
      return false;
   } 
}
function NextPage() {
	document.page3.action = '?curdoc=section1/qr_page3&next';
	}
//-->
</script>

<cfinclude template="../querys/get_student_info.cfm">

<cfquery name="get_interests" datasource="caseusa">
	SELECT interestid, interest
	FROM smg_interests
	WHERE student_app = 'yes'
	ORDER BY interest
</cfquery>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
  <tr height="33">
    <td width="8" class="tableside"><img src="pics/p_topleft.gif" width="8"></td>
    <td width="26" class="tablecenter"><img src="../pics/students.gif"></td>
    <td class="tablecenter"><h2>Page [03] - Personal Data</h2></td>
    <td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section1/page3print.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></a>&nbsp; &nbsp;</td>
    <td width="42" class="tableside"><img src="pics/p_topright.gif" width="42"></td>
  </tr>
</table>
<cfform action="?curdoc=section1/qr_page3" name="page3" method="post" onSubmit="return CheckFields();">

<cfoutput query="get_student_info">

<cfinput type="hidden" name="studentid" value="#studentid#">
<cfinput type="hidden" name="CheckChanged" value="0">

<div class="section"><br>

<table width="670" border=0 cellpadding=0 cellspacing=0 align="center">
	<tr><td colspan="8"><em>Check any activity in which you participate in your home country (check at least 3 and no more than 6).</em></td></tr>
	<tr><cfloop query="get_interests">	
		<td><input type="checkbox" name="interests" value='#interestid#' onchange="DataChanged();" <cfif ListFind(get_student_info.interests, interestid , ",")>checked</cfif>></td>
		<td>#interest#</td>
			<cfif (get_interests.currentrow MOD 4 ) EQ 0></tr><tr></cfif>
		</cfloop>
	<tr><td colspan="8"><em>Other:</em></td></tr>
	<tr><td colspan="8"><cfinput type="text" name="app_other_interest" size="45" value="#app_other_interest#" onchange="DataChanged();"></td></tr>
	<tr><td>&nbsp;</td></tr>
</table>

<table width="670" border=0 cellpadding=0 cellspacing=0 align="center">
	<tr><td><em>Please list any other specific interests, hobbies and activities and any awards or commendations:</em></td></tr>
	<tr><td>&nbsp;</td></tr>
</table>

<table width="670" border=0 cellpadding=0 cellspacing=0 align="center">
<tr>
	<td width="48%" valign="top">
		<table width="100%" border=0 cellpadding=0 cellspacing=0>
			<tr><td><em>Do you Play in a band?</em></td></tr>
			<tr>
				<td>
					<cfif band is 'yes'><cfinput type="radio" name="band" value="Yes" checked="yes" onchange="DataChanged();">Yes<cfelse><cfinput type="radio" name="band" value="Yes" onchange="DataChanged();">Yes</cfif>&nbsp; &nbsp;
					<cfif band is 'no'><cfinput type="radio" name="band" value="No" checked="yes" onchange="DataChanged();">No<cfelse><cfinput type="radio" name="band" value="No" onchange="DataChanged();">No</cfif>	
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>Do you play in an orchestra?</em></td></tr>					
			<tr>
				<td>
					<cfif orchestra is 'yes'><cfinput type="radio" name="orchestra" value="Yes" checked="yes" onchange="DataChanged();">Yes<cfelse><cfinput type="radio" name="orchestra" value="Yes" onchange="DataChanged();">Yes</cfif>&nbsp; &nbsp;
					<cfif orchestra is 'no'><cfinput type="radio" name="orchestra" value="No" checked="yes" onchange="DataChanged();">No<cfelse><cfinput type="radio" name="orchestra" value="No" onchange="DataChanged();">No</cfif>	
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>If yes, what instrument(s)?</em></td></tr>
			<tr><td><cfinput type="text" name="app_play_instrument" size="45" value="#app_play_instrument#" onchange="DataChanged();"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>Do you participate in any competitive sports?</em></td></tr>					
			<tr>
				<td>
					<cfif comp_sports is 'yes'><cfinput type="radio" name="comp_sports" value="Yes" checked="yes" onchange="DataChanged();">Yes<cfelse><cfinput type="radio" name="comp_sports" value="Yes" onchange="DataChanged();">Yes</cfif>&nbsp; &nbsp;
					<cfif comp_sports is 'no'><cfinput type="radio" name="comp_sports" value="No" checked="yes" onchange="DataChanged();">No<cfelse><cfinput type="radio" name="comp_sports" value="No" onchange="DataChanged();">No</cfif>													
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>If yes, what sport(s)?</em></td></tr>
			<tr><td><cfinput type="text" name="app_play_sport" size="45" value="#app_play_sport#" onchange="DataChanged();"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>How often do you attend church?</em></td></tr>					
			<tr>
				<td>
					<cfselect name="religious_participation" onchange="DataChanged();">
					<option value=""></option>
					<option value="active" <cfif religious_participation is 'active'>selected</cfif>>Active (1-2x times a week)</option>
					<option value="average" <cfif religious_participation is 'average'>selected</cfif>>Average (1x a week)</option>
					<option value="little interest" <cfif religious_participation is 'little interest'>selected</cfif>>Little Interest (occasionally)</option>
					<option value="inactive" <cfif religious_participation is 'inactive'>selected</cfif>>Inactive (Never attend)</option>
					<option value="no interest" <cfif religious_participation is 'no interest'>selected</cfif>>No Interest</option>
					</cfselect> 
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>Are you active in any church groups?</em></td></tr>					
			<tr><td><cfinput type="text" name="churchgroup" size="45" value="#churchgroup#" onchange="DataChanged();"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>Would you be willing to attend church with your host family?</em></td></tr>					
			<tr>
				<td>
					<cfif churchfam is 'yes'><cfinput type="radio" name="churchfam" value="Yes" checked="yes" onchange="DataChanged();">Yes<cfelse><cfinput type="radio" name="churchfam" value="Yes" onchange="DataChanged();">Yes</cfif>&nbsp; &nbsp;
					<cfif churchfam is 'no'><cfinput type="radio" name="churchfam" value="No" checked="yes" onchange="DataChanged();">No<cfelse><cfinput type="radio" name="churchfam" value="No" onchange="DataChanged();">No</cfif>													
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
		</table>
	</td>
	<td width="4%">&nbsp;</td>
	<td width="48%" valign="top">
		<table width="100%" border=0 cellpadding=0 cellspacing=0>
			<tr><td><em>Do you smoke?</em></td></tr>					
			<tr>
				<td> 
					<cfif smoke is 'yes'><cfinput type="radio" name="smoke" value="Yes" checked="yes" onchange="DataChanged();">Yes<cfelse><cfinput type="radio" name="smoke" value="Yes" onchange="DataChanged();">Yes</cfif>&nbsp; &nbsp;
					<cfif smoke is 'no'><cfinput type="radio" name="smoke" value="No" checked="yes" onchange="DataChanged();">No<cfelse><cfinput type="radio" name="smoke" value="No" onchange="DataChanged();">No</cfif>													
				</td>
			</tr>
			<tr>
				<td><font size="-2" color="FF0000">For your information: </font><i><font size="-2">The purchase and/or smoking of cigarettes for persons under age 18 is illegal in most parts of the USA.  
					Individual host families may have additional rules which must be followed by the student.</font>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>Are you allergic to animals?</em></td></tr>					
			<tr>
				<td>
					<cfif animal_allergies is 'yes'><cfinput type="radio" name="animal_allergies" value="Yes" checked="yes" onchange="DataChanged();">Yes<cfelse><cfinput type="radio" name="animal_allergies" value="Yes" onchange="DataChanged();">Yes</cfif>&nbsp; &nbsp;
					<cfif animal_allergies is 'no'><cfinput type="radio" name="animal_allergies" value="No" checked="yes" onchange="DataChanged();">No<cfelse><cfinput type="radio" name="animal_allergies" value="No" onchange="DataChanged();">No</cfif>									
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>If yes, what animals?</em></td></tr>					
			<tr><td><cfinput type="text" name="app_allergic_animal" size="45" value="#app_allergic_animal#" onchange="DataChanged();"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>If you are allergic, is your allergy controlled by medications?</em></td></tr>					
			<tr>
				<td>
					<cfif app_take_medicine is 'yes'><cfinput type="radio" name="app_take_medicine" value="Yes" checked="yes" onchange="DataChanged();">Yes<cfelse><cfinput type="radio" name="app_take_medicine" value="Yes" onchange="DataChanged();">Yes</cfif>&nbsp; &nbsp;
					<cfif app_take_medicine is 'no'><cfinput type="radio" name="app_take_medicine" value="No" checked="yes" onchange="DataChanged();">No<cfelse><cfinput type="radio" name="app_take_medicine" value="No" onchange="DataChanged();">No</cfif>																
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>Are you allergic to medications?</em></td></tr>					
			<tr>
				<td>
					<cfif med_allergies is 'yes'><cfinput type="radio" name="med_allergies" value="Yes" checked="yes" onchange="DataChanged();">Yes<cfelse><cfinput type="radio" name="med_allergies" value="Yes" onchange="DataChanged();">Yes</cfif>&nbsp; &nbsp;
					<cfif med_allergies is 'no'><cfinput type="radio" name="med_allergies" value="No" checked="yes" onchange="DataChanged();">No<cfelse><cfinput type="radio" name="med_allergies" value="No" onchange="DataChanged();">No</cfif>													
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>If yes, what medication?</em></td></tr>					
			<tr><td><cfinput type="text" name="app_allergic_medication" size="45" value="#app_allergic_medication#" onchange="DataChanged();"></td></tr>			
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>How many years have you studied English?</em></td></tr>					
			<tr><td><cfinput type="text" name="yearsenglish" size="6" value="#yearsenglish#" onchange="DataChanged();" maxlength="2" validate="integer" message="Years of English must be a number."></td></tr>
			<tr><td>&nbsp;</td></tr>
		</table>
	</td>
</tr>
</table>

<table width="670" border=0 cellpadding=0 cellspacing=0 align="center">
	<tr><td><em>List the chores for which you are responsible at home.</em></td></tr>					
	<tr><td><textarea name="chores_list" cols="110" rows="2" onchange="DataChanged();">#chores_list#</textarea></td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td><em>Briefly give reasons for wanting to become an exchange student.</em></td></tr>
	<tr><td><textarea name="app_reasons_student" cols="110" rows="6" onchange="DataChanged();">#app_reasons_student#</textarea></td></tr>
	<tr><td>&nbsp;</td></tr>
</table>

</div>

<!--- PAGE BUTTONS --->
<table width=100% border=0 cellpadding=0 cellspacing=0 class="section" align="center">
	<tr>
		<td align="center" valign="bottom" class="buttontop">
			<input name="Submit" type="image" src="pics/save.gif" border=0 alt="Save and reload this page" onClick="return CheckFields();"> 
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<input name="Submit" type="image" src="pics/save_continue.gif" border=0 alt="Save and go to next Page" onclick="return CheckFields();NextPage();">
		</td>
	</tr>
</table>

<!---
<cfinclude template="../page_buttons.cfm">
--->

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