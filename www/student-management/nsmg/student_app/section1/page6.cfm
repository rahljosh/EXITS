<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>Page [06] - Parents Letter of Introduction</title>
</head>
<body>

<cftry>

<cfinclude template="../querys/get_student_info.cfm">

<!--- relocate users if they try to access the edit page without permission --->
<cfinclude template="../querys/get_latest_status.cfm">

<cfif (client.usertype EQ 10 AND (get_latest_status.status GTE 3 AND get_latest_status.status NEQ 4 AND get_latest_status.status NEQ 6))  <!--- STUDENT ---->
	OR (client.usertype EQ 11 AND (get_latest_status.status GTE 4 AND get_latest_status.status NEQ 6))  <!--- BRANCH ---->
	OR (client.usertype EQ 8 AND (get_latest_status.status GTE 6 AND get_latest_status.status NEQ 9)) <!--- INTL. AGENT ---->
	OR (client.usertype GTE 5 AND client.usertype LTE 7 OR client.usertype EQ 9)> <!--- FIELD --->
    <!--- Office users should be able to edit online apps --->
    <!--- OR (client.usertype LTE 4 AND get_latest_status.status GTE 7) <!--- OFFICE USERS ---> --->
	<cflocation url="?curdoc=section1/page6print&id=1&p=5" addtoken="no">
</cfif>

<script type="text/javascript">
<!--
function CheckLink() { 
  if (document.page6.CheckChanged.value != 0)
  {
    if (confirm("You have made changes on this page that have not been saved.\n\These changes will be lost if you navigate away from this page.\n\Click OK to contine and discard changes, or click cancel and click on save to save your changes."))
      return true;
    else
      return false;
  }
}
function DataChanged() {
  document.page6.CheckChanged.value = 1;
}
function NextPage() {
	document.page6.action = '?curdoc=section1/qr_page6&next';
}
function areYouSure() { 
   if(confirm("You are about to delete the parent's letter. Click OK to continue")) { 
     form.submit(); 
        return true; 
   } else { 
        return false; 
   } 
} 
//-->
</SCRIPT>

<cfset doc = 'parents'>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="../pics/students.gif"></td>
		<td class="tablecenter"><h2>Page [06] - Parents Letter of Introduction</h2></td>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section1/page6print.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		<td width="42" class="tableside"><img src="pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<cfform action="?curdoc=section1/qr_page6" name="page6" method="post" onSubmit="return CheckFields();">

<cfoutput query="get_student_info">
<cfinput type="hidden" name="studentid" value="#studentid#">
<cfinput type="hidden" name="CheckChanged" value="0">

<div class="section"><br>
<cfset doc = 'parents'>
<!--- Check uploaded letter - Upload File Button --->
<cfinclude template="../check_uploaded_letter.cfm">

<table width="670" border=0 cellpadding=0 cellspacing=0 align="center">	
	<tr><td><em>Please type a letter to the potential host parents of your child.  <b>Please type the letter in english.</b>
			Describe your child's personality and interests, expectations and relationships.  We ask that you be very frank and honest in your letter,
			and that you comment on your child's strength and weaknesses. This will be very helpful to us in finding the best host family for your child.</em></td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td>You can either upload a scanned letter and/or type one in the space provided.</td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td>To upload a scanned letter please use the upload feature on the top of this page.</td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td>Parent's Letter:</td></tr>
	<cfif get_student_info.familyletter NEQ '' AND NOT IsDefined('url.edit')> 
	<tr><td align="center"><h3><a href="?curdoc=section1/page6&id=1&p=6&edit=y">Edit Letter</a> &nbsp; :: &nbsp;
			<a href="?curdoc=section1/qr_page6_del" onClick="return areYouSure();">Delete Letter</a></h3></td>
	</tr>
	<tr><td>
		<table width=670 cellpadding=0 cellspacing=0 border=0 bgcolor="FFFFFF" align="center">
			<tr valign=top>
				<td width=6 style="border-left: 1px solid ##FAF7F1;"><img src="../pics/address_topleft.gif" height=6 width=6></td>
				<td width=650 style="line-height:1px; font-size:2px; border-top: 1px solid ##557aa7;">&nbsp;</td>
				<td width=6><img src="../pics/address_topright.gif" height=6 width=6></td>
			</tr>
			<tr>
				<td width=6 style="border-left: 1px solid ##557aa7;">&nbsp;</td>
				<td width=600 style="padding:5px;">
                	<div style="width:600px;">
                        #familyletter#
                    </div>
               	</td>
				<td width=6 style="border-right: 1px solid ##557aa7;">&nbsp;</td>
			</tr>
			<tr valign="bottom">
				<td width=6 style="border-left: 1px solid ##FAF7F1;"><img src="../pics/address_bottomleft.gif" height=6 width=6></td>
				<td width=201 style="line-height:1px; font-size:2px; border-bottom: 1px solid ##557aa7;">&nbsp;</td>
				<td width=6><img src="../pics/address_bottomright.gif" height=6 width=6></td>
			</tr>
		</table>
		</td>
	</tr>
	<cfelse>
	<tr><td><textarea cols="110" rows="22" name="familyletter" wrap="soft" onchange="DataChanged();">#Replace(familyletter,"<br>","#chr(10)#","all")#</textarea></td></tr>
	</cfif>
</table><br><br>

</div>

<cfif get_student_info.familyletter NEQ '' AND NOT IsDefined('url.edit')>
	<table width=100% border=0 cellpadding=0 cellspacing=0 class="section" align="center">
		<tr>
			<td align="center" valign="bottom" class="buttontop">
				<a href="index.cfm?curdoc=section2&id=2"><img src="pics/next.gif" border="0"></a>
			</td>
		</tr>
	</table>
<cfelse>
	<!--- PAGE BUTTONS --->
	<cfinclude template="../page_buttons.cfm">
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