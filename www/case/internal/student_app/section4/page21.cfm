<cftry>

<cfquery name="check_state" datasource="caseusa">
	SELECT statechoiceid, studentid, state1, state2, state3
	FROM smg_student_app_state_requested
	WHERE studentid =  <cfqueryparam value="#client.studentid#" cfsqltype="cf_sql_integer">
</cfquery>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>Page [21] - State Guarantee</title>
</head>
<body <cfif check_state.recordcount GT '0' AND check_state.state1 GT '0'>onLoad="hideAll(); changeDiv('1','block');"</cfif>>

<!--- relocate users if they try to access the edit page without permission --->
<cfinclude template="../querys/get_latest_status.cfm">

<cfif (client.usertype EQ '10' AND (get_latest_status.status GTE '3' AND get_latest_status.status NEQ '4' AND get_latest_status.status NEQ '6'))  <!--- STUDENT ---->
	OR (client.usertype EQ '11' AND (get_latest_status.status GTE '4' AND get_latest_status.status NEQ '6'))  <!--- BRANCH ---->
	OR (client.usertype EQ '8' AND (get_latest_status.status GTE '6' AND get_latest_status.status NEQ '9')) <!--- INTL. AGENT ---->
	OR (client.usertype LTE '4' AND get_latest_status.status GTE '7') <!--- OFFICE USERS --->
	OR (client.usertype GTE '5' AND client.usertype LTE '7' OR client.usertype EQ '9')> <!--- FIELD --->
	<cflocation url="?curdoc=section4/page21print&id=4&p=21" addtoken="no">
</cfif>

<!-----Script to show certain fileds---->
<script type="text/javascript">
<!--
function changeDiv(the_div,the_change)
{
  var the_style = getStyleObject(the_div);
  if (the_style != false)
  {
    the_style.display = the_change;
  }
}
function hideAll()
{
  changeDiv("1","none");
  changeDiv("2","none");
}
function getStyleObject(objectId) {
  if (document.getElementById && document.getElementById(objectId)) {
    return document.getElementById(objectId).style;
  } else if (document.all && document.all(objectId)) {
    return document.all(objectId).style;
  } else {
    return false;
  }
}
function CheckLink()
{
  if (document.page21.CheckChanged.value != 0)
  {
    if (confirm("You have made changes on this page that have not been submited.\n\These changes will be lost if you navigate away from this page.\n\Click OK to contine and discard changes, or click cancel and submit to save your changes."))
      return true;
    else
      return false;
  }
}
function DataChanged() {
  document.page21.CheckChanged.value = 1
}
function CheckStates() {
	if ((document.page21.state_select[0].checked) && ((document.page21.state1.value == '0') || (document.page21.state2.value == '0') ||  (document.page21.state3.value == '0'))) {
	 	alert("If you would like a State Guarantee, you must select three options.");
		  return false; }			  	
}
function NextPage() {
	document.page21.action = '?curdoc=section4/qr_page21&next';
	}
//-->
</script>
<!--- 
	if ( (document.page21.state_select[0].checked) && ((document.page21.state1.value == document.page21.state2.value) || (document.page21.state1.value == document.page21.state3.value) ||  (document.page21.state2.value == document.page21.state3.value))) {
	 	alert("You must select 3 different states, please review your choices and submit this page again.");
		  return false; }
	alert("If you would like a State Guarantee, you must select three different options."); 
--->

<Cfset doc = 'page21'>

<cfinclude template="../querys/get_student_info.cfm">

<!---- International Rep - EF ACCOUNTS ---->
<cfquery name="int_agent" datasource="caseusa">
	SELECT u.businessname, u.userid, u.master_account, u.master_accountid
	FROM smg_users u
	WHERE u.userid = <cfif get_student_info.branchid EQ '0'>'#get_student_info.intrep#'<cfelse>'#get_student_info.branchid#'</cfif>
</cfquery>

<cfquery name="states" datasource="caseusa">
	SELECT id, statename
	FROM smg_states
	WHERE id != 2 AND id != 11
</cfquery>

<cfquery name="check_if_answered" datasource="caseusa">
	SELECT smg_students.regionalguarantee, smg_students.regionguar, smg_regions.regionname
	FROM smg_students, smg_regions
	WHERE studentid = <cfqueryparam value="#client.studentid#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="states_requested" datasource="caseusa">
	SELECT state1, sta1.statename as statename1, state2, sta2.statename as statename2, state3, sta3.statename as statename3
	FROM smg_student_app_state_requested 
	LEFT JOIN smg_states sta1 ON sta1.id = state1
	LEFT JOIN smg_states sta2 ON sta2.id = state2
	LEFT JOIN smg_states sta3 ON sta3.id = state3
	WHERE studentid = <cfqueryparam value="#client.studentid#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="../pics/students.gif"></td>
		<td class="tablecenter"><h2>Page [21] - State Guarantee</h2></td>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section4/page21print.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		<td width="42" class="tableside"><img src="pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<cfoutput>
<cfform method="post" name="page21" action="?curdoc=section4/qr_page21" onSubmit="return CheckStates();">

<!--- PROGRAM TYPES 1 = AYP 10 AUG / 2 = AYP 5 AUG / 3 = AYP 5 JAN / 4 = AYP 12 JAN --->
<cfif (DateFormat(now(), 'mm') EQ 4 OR dateFormat(now(), 'mm') EQ 5) AND (get_student_info.app_indicated_program EQ '1' OR get_student_info.app_indicated_program EQ '2')> 
	<div class="section"><br><br>
	<table width="670" cellpadding=2 cellspacing=0 align="center">
		<tr>
			<td>State Guarantees are no longer available.</td>
		</tr>
	</table><br><br>
	</div>
	<!--- FOOTER OF TABLE --->
	<cfinclude template="../footer_table.cfm">
	<cfabort>	
</cfif>

<cfinput type="hidden" name="studentid" value="#get_student_info.studentid#">
<cfinput type="hidden" name="CheckChanged" value="0">

<!--- HIDE GUARANTEE FOR EF AND INTERSTUDIES 8318 --->
<cfif IsDefined('client.usertype') AND client.usertype EQ 10 AND (int_agent.master_accountid EQ 10115 OR int_agent.userid EQ 10115 OR int_agent.userid EQ 8318)>
	<div class="section"><br><br>
	<table width="670" cellpadding=2 cellspacing=0 align="center">
		<tr>
			<td>Currently, you are unable to request a State Guarantee online.  You are still able to request them, you just need to contact your
			#int_agent.businessname# Representative.  Contact information is listed above.  
			</td>
		</tr>
	</table><br><br>
	</div>
	<!--- FOOTER OF TABLE --->
	<cfinclude template="../footer_table.cfm">
	<cfabort>
</cfif>

<div class="section"><br>

<!--- Check uploaded file - Upload File Button --->
<cfinclude template="../check_uploaded_file.cfm">

<table width="670" border=0 cellpadding=3 cellspacing=0 align="center">
	<tr>
		<td>
			<div align="justify"><cfinclude template="state_guarantee_text.cfm"></div>
			<table>
				<tr><td>46 State Guarantee</td><td>=</td><td>$500</td></tr>
				<tr><td align="right">Florida</td><td>=</td><td>$600</td></tr>
				<tr><td align="right">California</td><td>=</td><td>$700</td></tr>
			</table>
			<img src="pics/usa-map.gif"><br>
			<a href="?curdoc=section4/page20&id=4&p=20">Regional Guarantees</a> are still available starting at $300<br><Br>
			<input type="radio" name="state_select" value="yes" onClick="hideAll(); changeDiv('1','block'); DataChanged();" <cfif check_state.recordcount GT '0' AND check_state.state1 GT '0'>checked</cfif> >Yes, submit my choices as indicated below. 
			<input type="radio" name="state_select" value="no" onClick="hideAll(); changeDiv('2','block'); DataChanged();" <cfif check_state.recordcount NEQ '0' AND check_state.state1 EQ '0'>checked</cfif> >No, I am not interested in a state guarantee.
			<div id ="1" style="display:none"><br>
			<table>
				<tr>
				<td>1st Choice:</td>
				<td><cfselect name="state1" onClick="DataChanged();">
						<option value="0"></option>
						<cfloop query="states"><option value="#id#" <cfif states_requested.state1 EQ id> selected </cfif> >#statename#</option></cfloop>
					</cfselect>
				</td>
				<td>&nbsp; 2nd Choice:</td>
				<td><cfselect name="state2" onClick="DataChanged();">
						<option value="0"></option>
						<cfloop query="states"><option value="#id#" <cfif states_requested.state2 EQ id> selected </cfif> >#statename#</option></cfloop>
					</cfselect>
				</td>
				<td>&nbsp; 3rd Choice:</td>
				<td><cfselect name="state3" onClick="DataChanged();">
						<option value="0"></option>
						<cfloop query="states"><option value="#id#" <cfif states_requested.state3 EQ id> selected </cfif> >#statename#</option></cfloop>
					</cfselect>
				</td>							
			</table>
			</div>
			<div id=2 style="display:none"><br>
			Assign me to any state in the United States, do NOT put me down for a State Guarantee.
			</div>
		</td>
	</tr>
</table><br><br>
</div>
		 
<!--- PAGE BUTTONS --->
<cfinclude template="../page_buttons.cfm">
</cfform>
</cfoutput>

<!--- FOOTER OF TABLE --->
<cfinclude template="../footer_table.cfm">

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>

</body>
</html>

</cftry>