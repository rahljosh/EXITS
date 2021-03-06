<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>Page [01] - Student's Information</title>
</head>
<body>
<cftry>

<cfif isDefined('url.unqid')>
	<!----Get student id  for office folks linking into the student app---->
	<cfquery name="get_student_id" datasource="caseusa">
	select studentid from smg_students
	where uniqueid = '#url.unqid#'
	</cfquery>
	<cfset client.studentid = #get_student_id.studentid#>
</cfif>

<!--- relocate users if they try to access the edit page without permission --->
<cfinclude template="../querys/get_latest_status.cfm">

<cfif (client.usertype EQ '10' AND (get_latest_status.status GTE '3' AND get_latest_status.status NEQ '4' AND get_latest_status.status NEQ '6'))  <!--- STUDENT ---->
	OR (client.usertype EQ '11' AND (get_latest_status.status GTE '4' AND get_latest_status.status NEQ '6'))  <!--- BRANCH ---->
	OR (client.usertype EQ '8' AND (get_latest_status.status GTE '6' AND get_latest_status.status NEQ '9')) <!--- INTL. AGENT ---->
	OR (client.usertype LTE '4' AND get_latest_status.status GTE '7') <!--- OFFICE USERS --->
	OR (client.usertype GTE '5' AND client.usertype LTE '7' OR client.usertype EQ '9')> <!--- FIELD --->
	<cflocation url="?curdoc=section1/page1print&id=1&p=1" addtoken="no">
</cfif>

<SCRIPT>
<!--
function CheckLink()
{
  if (document.page1.CheckChanged.value != 0)
  {
    if (confirm("You have made changes on this page that have not been saved.\n\These changes will be lost if you navigate away from this page.\n\Click OK to contine and discard changes, or click cancel and click on save to save your changes."))
      return true;
    else
      return false;
  }
}
function DataChanged()
{
  document.page1.CheckChanged.value = 1
}
function NextPage() {
	document.page1.action = '?curdoc=section1/qr_page1&next';
}
function areYouSure() { 
   if(confirm("You are about to delete the passaport photo. Click OK to continue")) { 
     form.submit(); 
        return true; 
   } else { 
        return false; 
   } 
} 
//-->
</script>

<cfinclude template="../querys/get_student_info.cfm">

<cfquery name="get_intrep" datasource="caseusa">
	SELECT userid, businessname
	FROM smg_users 
	WHERE userid = '#get_student_info.intrep#'
</cfquery>

<cfquery name="country_list" datasource="caseusa">
	SELECT countryid, countryname
	FROM smg_countrylist
	ORDER BY Countryname
</cfquery>

<cfquery name="religion_list" datasource="caseusa">
	SELECT religionid, religionname
	FROM smg_religions
	ORDER BY religionname
</cfquery>
 
<cfquery name="app_programs" datasource="caseusa">
	SELECT app_programid, app_program 
	FROM smg_student_app_programs
	WHERE app_type = 'regular'
</cfquery>

<cfquery name="app_other_programs" datasource="caseusa">
	SELECT app_programid, app_program 
	FROM smg_student_app_programs
	WHERE app_type = 'additional'
</cfquery>  

<cfset nsmg_directory = '/var/www/html/case/internal/uploadedfiles/web-students'>
<cfdirectory directory="#nsmg_directory#" name="file" filter="#client.studentid#.*">

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="../pics/students.gif"></td>
		<td class="tablecenter"><h2>Page [01] - Student's Information</h2></td>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section1/page1print.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		<td width="42" class="tableside"><img src="pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<cfform name="page1" action="?curdoc=section1/qr_page1" method="post">

<cfoutput query="get_student_info">

<cfinput type="hidden" name="studentid" value="#studentid#">
<cfinput type="hidden" name="CheckChanged" value="0">

<div class="section"><br>
<table width="670" border=0 cellpadding=0 cellspacing=0 align="center">	
	<tr>
		<td width="150" rowspan="11" align="left" valign="top">
			<cfif file.recordcount>
				<img src="../uploadedfiles/web-students/#file.name#" width="130" height="150"><br>
				<a class=nav_bar href="" onClick="javascript: win=window.open('http://upload.student-management.com/form_upload_page1.cfm?studentid=#studentid#', 'Settings', 'height=305, width=636, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><img src="pics/docs.gif" border=0>Upload</a> 
				/<a href="http://upload.case-usa.org/qr_delete_page1.cfm?studentid=#client.studentid#" onClick="return areYouSure(this);"><img src="pics/button_drop.png" border=0>Delete</a>
			<cfelse>
				<a class=nav_bar href="" onClick="javascript: win=window.open('http://upload.case-usa.org/form_upload_page1.cfm?studentid=#studentid#', 'Settings', 'height=305, width=636, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><img src="pics/no_image.gif" border=0></a>
			</cfif>
		</td>
		<td colspan="3"><b>Student's Name</b> &nbsp; <font size="-2">PS: Please do not use any type of accent.</font></td>
	</tr>
	<tr>
		<td><em>Family Name</em></td>
		<td><em>First Name</em></td>
		<td><em>Middle Name</em></td>		
	</tr>
	<tr>
		<td valign="top"><cfinput type="text" name="familylastname" size="22" value="#familylastname#" onchange="DataChanged();"></td>
		<td valign="top"><cfinput type="text" name="firstname" size="22" value="#firstname#" onchange="DataChanged();"></td>
		<td valign="top"><cfinput type="text" name="middlename" size="22" value="#middlename#" onchange="DataChanged();"></td>
	</tr>
	<tr><td colspan="3">&nbsp;</td></tr>
	<tr><td colspan="3">
			<table width="100%" border=0 cellpadding=0 cellspacing=0 align="center">	
				<tr><td colspan="2"><b>Program Information</b></td></tr>
				<tr>
					<td><em>Program</em></td>
					<td><em>Additional Programs</em></td>
				</tr>
				<tr>
					<td valign="top"><cfselect name="app_indicated_program">
						<option value="0">Select a Program</option>
						<cfloop query="app_programs">
							<option value="#app_programid#" <cfif get_student_info.app_indicated_program EQ app_programid>selected</cfif> >#app_program#</option>
						</cfloop>
						</cfselect>
					</td>
					<td valign="top"><cfselect name="app_additional_program">
						<option value="0"></option>
						<cfloop query="app_other_programs">
							<option value="#app_programid#" <cfif get_student_info.app_additional_program EQ app_programid>selected</cfif> >#app_program#</option>
						</cfloop>
						</cfselect>
					</td>
				</tr>
				<tr><td colspan="2">&nbsp;</td></tr>
			</table>
	</td></tr>
	<tr>
		<td colspan="3"><b>International Representative</b></td>
	</tr>
	<tr>
		<td colspan="3">#get_intrep.businessname#<br><img src="pics/line.gif" width="480" height="1" border="0" align="absmiddle"></td>
	</tr>
</table><br>

<hr class="bar"></hr><br>

<table width="670" border=0 cellpadding=0 cellspacing=0 align="center">
<tr><td colspan="3"><b>Complete Mailing Address</b></td></tr>
<tr>
	<td width="48%" valign="top">
		<table border=0 cellpadding=0 cellspacing=0>
			<tr><td colspan="2"><em>Street Address</em></td></tr>
			<tr><td colspan="2"><cfinput type="text" name="address" size="46" value="#address#" onchange="DataChanged();"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>City</em></td></tr>
			<tr><td colspan="2"><cfinput type="text" name="city" size="46" value="#city#" onchange="DataChanged();"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>Zip Code</em></td><td><em>Country</em></td></tr>
			<tr>
				<td><cfinput type="text" name="zip" size="15" value="#zip#" onchange="DataChanged();"></td>			
				<td>
				<cfselect name="country" onchange="DataChanged();">
					<option value="0"></option>
					<cfloop query="country_list">
					<option value="#countryid#" <cfif get_student_info.country is countryid>selected</cfif>>#countryname#</option>
					</cfloop>
				</cfselect></td>
			</tr>	
			<tr><td>&nbsp;</td></tr>	
			<tr><td><em>Telephone No.</em></td><td><em>Fax No.</em></td></tr>
			<tr>
				<td><cfinput type="text" name="phone" size="16" value="#phone#" onchange="DataChanged();"></td>
				<td><cfinput type="text" name="fax" size="16" value="#fax#" onchange="DataChanged();"></td>				
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>E-Mail * (username)</em></td></tr>
			<tr><td colspan="2"><cfinput type="text" name="email" size="46" validate="email" value="#email#" onchange="DataChanged();" required="yes" validateat="onserver,onsubmit" message="Email address is also your username. It must not be blank. Please enter an e-mail address"></td></tr>
			<tr><td>&nbsp;</td></tr>	
			<tr><td ><em>Sex</em></td><td>&nbsp;&nbsp;<em>Date of Birth <font size="-2">(mm/dd/yyyy)</font></em></td></tr>
			<tr>
				<td>
					<cfif sex is 'male'><cfinput type="radio" name="sex" value="male" checked="yes" onchange="DataChanged();">Male<cfelse><cfinput type="radio" name="sex" value="male" onchange="DataChanged();">Male</cfif>&nbsp; 
					<cfif sex is 'female'><cfinput type="radio" name="sex" value="female" checked="yes" onchange="DataChanged();">Female<cfelse><cfinput type="radio" name="sex" value="female" onchange="DataChanged();">Female</cfif>
				</td>
				<td>&nbsp;&nbsp;<cfinput type="text" name="dob" size="15" maxlength="10" validate="date" value="#DateFormat(dob, 'mm/dd/yyyy')#" onchange="DataChanged();" validateat="onsubmit,onserver" message="Date of Birth - Please enter a valid date in the MM/DD/YYYY format."></td>
			</tr>
			<tr><td>&nbsp;</td></tr>						
		</table>	
	</td>
	<td width="4%">&nbsp;</td>
	<td width="48%" valign="top" align="left">
		<table border=0 cellpadding=0 cellspacing=0>
			<tr><td colspan="2"><em>Place of Birth</em></td></tr>
			<tr><td colspan="2"><cfinput type="text" name="citybirth" size="46" value="#citybirth#" onchange="DataChanged();"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>Country of Birth</em></td></tr>
			<tr><td colspan="2">
				<cfselect name="countrybirth" onchange="DataChanged();">
					<option value="0"></option>
					<cfloop query="country_list">
					<option value="#countryid#" <cfif get_student_info.countrybirth is countryid>selected</cfif>>#countryname#</option>
					</cfloop>
				</cfselect></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>Country of Citizenship</em></td></tr>
			<tr><td colspan="2">
				<cfselect name="countrycitizen" onchange="DataChanged();">
					<option value="0"></option>
					<cfloop query="country_list">
					<!--- do not show Serbia and Montenegro SEVIS --->
					<cfif countryid NEQ 250>		
					<option value="#countryid#" <cfif get_student_info.countrycitizen is countryid>selected</cfif>>#countryname#</option>
					</cfif>
					</cfloop>
				</cfselect></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>Country of Legal Permanent Residence</em></td></tr>
			<tr><td colspan="2">
				<cfselect name="countryresident" onchange="DataChanged();">
					<option value="0"></option>
					<cfloop query="country_list">
					<!--- do not show Serbia and Montenegro SEVIS --->
					<cfif countryid NEQ 250>		
					<option value="#countryid#" <cfif get_student_info.countryresident is countryid>selected</cfif>>#countryname#</option>
					</cfif>
					</cfloop>
				</cfselect></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>Religious Affiliation</em></td></tr>
			<tr><td colspan="2">
				<cfselect name="religiousaffiliation" onchange="DataChanged();">
					<option value="0"></option>
					<cfloop query="religion_list">
					<option value="#religionid#" <cfif get_student_info.religiousaffiliation is religionid>selected</cfif>>#religionname#</option>
					</cfloop>
				</cfselect></td>
			</tr>
			<tr><td>&nbsp;</td></tr>			
			<tr><td colspan="2"><em>Passport Number (if known)</em></td></tr>
			<tr><td colspan="2"><cfinput type="text" name="passportnumber" size="20" value="#passportnumber#" onchange="DataChanged();"></td></tr>
			<tr><td>&nbsp;</td></tr>			
		</table>	
	</td>
</tr>
</table>

<hr class="bar"></hr><br>

<table width="670" border=0 cellpadding=0 cellspacing=0 align="center">
<tr><td colspan="2"><b>FAMILY INFORMATION</b></td></tr>
<tr>
	<td width="48%" valign="top">
		<table width="100%" border=0 cellpadding=0 cellspacing=0>
			<tr><td colspan="2"><em>Father's Name</em></td></tr>
			<tr><td colspan="2"><cfinput type="text" name="fathersname" size="46" value="#fathersname#" onchange="DataChanged();"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>Address</em></td></tr>					
			<tr><td colspan="2"><cfinput type="text" name="fatheraddress" size="46" value="#fatheraddress#" onchange="DataChanged();"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>Country</em></td></tr>
			<tr><td colspan="2">
				<cfselect name="fathercountry" onchange="DataChanged();">
					<option value="0"></option>
					<cfloop query="country_list">
					<option value="#countryid#" <cfif get_student_info.fathercountry is countryid>selected</cfif>>#countryname#</option>
					</cfloop>
				</cfselect></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>Year of Birth (yyyy)</em></td><td><em>Speaks English</em></td></tr>	
			<tr>
				<td><cfinput type="text" name="fatherbirth" size="10" maxlength="4" value="#fatherbirth#" onchange="DataChanged();"></td>
				<td>
					<cfif fatherenglish is 'yes'><cfinput type="radio" name="fatherenglish" value="Yes" checked="yes" onchange="DataChanged();">Yes<cfelse><cfinput type="radio" name="fatherenglish" value="Yes" onchange="DataChanged();">Yes</cfif>&nbsp; &nbsp;
					<cfif fatherenglish is 'no'><cfinput type="radio" name="fatherenglish" value="No" checked="yes" onchange="DataChanged();">No<cfelse><cfinput type="radio" name="fatherenglish" value="No" onchange="DataChanged();">No</cfif> 
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>Business Phone</em></td><td><em>Employed By</em></td></tr>
			<tr>
				<td><cfinput type="text" name="fatherworkphone" size="16" value="#fatherworkphone#" onchange="DataChanged();"></td>
				<td><cfinput type="text" name="fathercompany" size="23" value="#fathercompany#" onchange="DataChanged();"></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>Occupation</em></td></tr>
			<tr><td colspan="2"><cfinput type="text" name="fatherworkposition" size="46" value="#fatherworkposition#" onchange="DataChanged();"></td></tr>
			<tr><td>&nbsp;</td></tr>		
		</table>
	</td>
	<td width="4%">&nbsp;</td>
	<td width="48%" valign="top">
		<table width="100%" border=0 cellpadding=0 cellspacing=0>
			<tr><td colspan="2"><em>Mother's Name</em></td></tr>
			<tr><td colspan="2"><cfinput type="text" name="mothersname" size="46" value="#mothersname#" onchange="DataChanged();"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>Address</em></td></tr>
			<tr><td colspan="2"><cfinput type="text" name="motheraddress" size="46" value="#motheraddress#" onchange="DataChanged();"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>Country</em></td></tr>
			<tr><td colspan="2">
				<cfselect name="mothercountry" onchange="DataChanged();"> 
					<option value="0"></option>
					<cfloop query="country_list">
					<option value="#countryid#" <cfif get_student_info.mothercountry is countryid>selected</cfif>>#countryname#</option>
					</cfloop>
				</cfselect></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>Year of Birth (yyyy)</em></td><td><em>Speaks English</em></td></tr>	
			<tr>
				<td><cfinput type="text" name="motherbirth" size="10" maxlength="4" value="#motherbirth#" onchange="DataChanged();"></td>
				<td>
					<cfif motherenglish is 'yes'><cfinput type="radio" name="motherenglish" value="Yes" checked="yes" onchange="DataChanged();">Yes<cfelse><cfinput type="radio" name="motherenglish" value="Yes" onchange="DataChanged();">Yes</cfif>&nbsp; &nbsp;
					<cfif motherenglish is 'no'><cfinput type="radio" name="motherenglish" value="No" checked="yes" onchange="DataChanged();">No<cfelse><cfinput type="radio" name="motherenglish" value="No" onchange="DataChanged();">No</cfif>	
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>Business Phone</em></td><td><em>Employed By</em></td></tr>
			<tr>
				<td><cfinput type="text" name="motherworkphone" size="16" value="#motherworkphone#" onchange="DataChanged();"></td>
				<td><cfinput type="text" name="mothercompany" size="23" value="#mothercompany#" onchange="DataChanged();"></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>Occupation</em></td></tr>
			<tr><td colspan="2"><cfinput type="text" name="motherworkposition" size="46" value="#motherworkposition#" onchange="DataChanged();"></td></tr>
			<tr><td>&nbsp;</td></tr>
		</table>
	</td>
</tr>
</table>

<hr class="bar"></hr><br>

<table width="670" border=0 cellpadding=0 cellspacing=0 align="center">
<tr><td colspan="2"><b>EMERGENCY CONTACT</b></td></tr>
<tr>
	<td width="48%" valign="top">
		<table width="100%" border=0 cellpadding=0 cellspacing=0>
			<tr><td colspan="2"><em>Name</em></td></tr>
			<tr><td colspan="2"><cfinput type="text" name="emergency_name" size="46" value="#emergency_name#" onchange="DataChanged();"></td></tr>
			<tr><td colspan="2"><em>Address</em></td></tr>
			<tr><td colspan="2"><cfinput type="text" name="emergency_address" size="46" value="#emergency_address#" onchange="DataChanged();"></td></tr>	
		</table>	
	</td>
	<td width="4%">&nbsp;</td>
	<td width="48%" valign="top">
		<table width="100%" border=0 cellpadding=0 cellspacing=0>
			<tr><td><em>Phone Number</em></td></tr>
			<tr><td><cfinput type="text" name="emergency_phone" size="16" value="#emergency_phone#" onchange="DataChanged();"></td></tr>
			<tr><td><em>Country</em></td></tr>
			<tr><td>
				<cfselect name="emergency_country" onchange="DataChanged();"> 
					<option value="0"></option>
					<cfloop query="country_list">
					<option value="#countryid#" <cfif get_student_info.emergency_country is countryid>selected</cfif>>#countryname#</option>
					</cfloop>
				</cfselect></td>
			</tr>
		</table>
	</td>
</tr>
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