<cftry>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>Page [02] - Siblings</title>
</head>
<body>

<!--- relocate users if they try to access the edit page without permission --->
<cfinclude template="../querys/get_latest_status.cfm">

<cfif (client.usertype EQ '10' AND (get_latest_status.status GTE '3' AND get_latest_status.status NEQ '4' AND get_latest_status.status NEQ '6'))  <!--- STUDENT ---->
	OR (client.usertype EQ '11' AND (get_latest_status.status GTE '4' AND get_latest_status.status NEQ '6'))  <!--- BRANCH ---->
	OR (client.usertype EQ '8' AND (get_latest_status.status GTE '6' AND get_latest_status.status NEQ '9')) <!--- INTL. AGENT ---->
	OR (client.usertype LTE '4' AND get_latest_status.status GTE '7') <!--- OFFICE USERS --->
	OR (client.usertype GTE '5' AND client.usertype LTE '7' OR client.usertype EQ '9')> <!--- FIELD --->
	<cflocation url="?curdoc=section1/page2print&id=1&p=2" addtoken="no">
</cfif>

<SCRIPT>
<!--
function CheckLink()
{
  if (document.page2.CheckChanged.value != 0)
  {
    if (confirm("You have made changes on this page that have not been saved.\n\These changes will be lost if you navigate away from this page.\n\Click OK to contine and discard changes, or click cancel and click on save to save your changes."))
      return true;
    else
      return false;
  }
}
function DataChanged()
{
  document.page2.CheckChanged.value = 1
}
function areYouSure() { 
   if(confirm("You are about to delete this sibling. Click OK to continue")) { 
     form.submit(); 
        return true; 
   } else { 
        return false; 
   } 
} 
function NextPage() {
	document.page2.action = '?curdoc=section1/qr_page2&next';
	}
//-->
</script>

<cfinclude template="../querys/get_student_info.cfm">

<cfquery name="get_siblings" datasource="MySql">
	SELECT childid, name, birthdate, sex, liveathome
	FROM smg_student_siblings
	WHERE studentid = <cfqueryparam value="#client.studentid#" cfsqltype="cf_sql_integer">
	ORDER BY childid
</cfquery>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="../pics/students.gif"></td>
		<td class="tablecenter"><h2>Page [02] - Siblings</h2></td>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section1/page2print.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		<td width="42" class="tableside"><img src="pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<cfform action="?curdoc=section1/qr_page2" method="post" name="page2">

<cfoutput query="get_student_info">

<cfinput type="hidden" name="studentid" value="#studentid#">
<cfinput type="hidden" name="CheckChanged" value="0">

<div class="section"><br>
<table width="670" border=0 cellpadding=0 cellspacing=0 align="center">
	<tr><td colspan="5"><b>BROTHERS and/or SISTERS</b></td></tr>
	<tr>
		<td><em>Name</em></td>
		<td><em>Date of Birth <font size="-5">(mm/dd/yyyy)</font></em></td>
		<td><em>Sex</em></td>
		<td><em>Living at home?</em></td>
		<td>&nbsp;</td>
	</tr>

	<cfif get_siblings.recordcount NEQ 0>	<!--- load siblings ---> 
		<cfinput type="hidden" name="count" value='#get_siblings.recordcount#'>
		<cfloop query="get_siblings">
		<tr>
			<cfinput type="hidden" name="childid#get_siblings.currentrow#" value="#get_siblings.childid#">
			<td width="210" valign="top"><cfinput type="text" name="name#get_siblings.currentrow#" size="30" value="#name#" onchange="DataChanged();"><br><br></td>
			<td width="145" valign="top"><cfinput type="text" name="birthdate#get_siblings.currentrow#" size="14" maxlength="10" value="#DateFormat(birthdate, 'mm/dd/yyyy')#" onchange="DataChanged();" validate="date" validateat="onsubmit,onserver" message="Please re-check the date of birth for the #name#. The format must be mm/dd/yyyy."><br><br></td>
			<td width="150" valign="top">
				<cfif sex is 'male'><cfinput type="radio" name="sex#get_siblings.currentrow#" value="male" checked="yes" onchange="DataChanged();">Male<cfelse><cfinput type="radio" name="sex#get_siblings.currentrow#" value="male" onchange="DataChanged();">Male</cfif>&nbsp; &nbsp;
				<cfif sex is 'female'><cfinput type="radio" name="sex#get_siblings.currentrow#" value="female" checked="yes" onchange="DataChanged();">Female<cfelse><cfinput type="radio" name="sex#get_siblings.currentrow#" value="female" onchange="DataChanged();">Female</cfif>
			</td>
			<td width="150" valign="top">
				<cfif liveathome is 'yes'><cfinput type="radio" name="liveathome#get_siblings.currentrow#" value="Yes" checked="yes" onchange="DataChanged();">Yes<cfelse><cfinput type="radio" name="liveathome#get_siblings.currentrow#" value="Yes" onchange="DataChanged();">Yes</cfif>&nbsp; &nbsp;
				<cfif liveathome is 'no'><cfinput type="radio" name="liveathome#get_siblings.currentrow#" value="No" checked="yes" onchange="DataChanged();">No<cfelse><cfinput type="radio" name="liveathome#get_siblings.currentrow#" value="No" onchange="DataChanged();">No</cfif>
			</td>
			<td width="45" align="center" valign="top"><a href="?curdoc=section1/qr_page2_del&childid=#get_siblings.childid#&studentid=#get_student_info.studentid#" onClick="return areYouSure(this);"><img src="pics/delete.gif" border="0" alt="Delete sibling #name#"></img></a></td>
		</tr>
		</cfloop>
	</cfif>
	
	<!--- new siblings --->
	<cfset newsiblings = 5 - get_siblings.recordcount>
	<cfinput type="hidden" name="newcount" value="#newsiblings#">
	<cfloop from="1" to="#newsiblings#" index="i">
	<tr>
		<td width="210" valign="top"><cfinput type="text" name="newname#i#" size="30" onchange="DataChanged();"><br><br></td>
		<td width="145" valign="top"><cfinput type="text" name="newbirthdate#i#" size="14" maxlength="10" onchange="DataChanged();" validate="date" validateat="onsubmit,onserver" message="Date of Birth - Please enter a valid date in the MM/DD/YYYY for the sibling #i#."><br><br></td>
		<td width="150" valign="top"><cfinput type="radio" name="newsex#i#" value="male">Male &nbsp; &nbsp;<cfinput type="radio" name="newsex#i#" value="female" onchange="DataChanged();">Female<br><br></td>
		<td width="150" valign="top"><cfinput type="radio" name="newliveathome#i#" value="Yes">Yes &nbsp; &nbsp;<cfinput type="radio" name="newliveathome#i#" value="no" onchange="DataChanged();">No</em><br></td>	
		<td width="45">&nbsp;</td>
	</tr>
	</cfloop>		
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
</body></html></cftry>


