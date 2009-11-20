<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Student Information - Page 1</title>
</head>

<body>
<cftry>

<SCRIPT>
<!-- hide script
function calc(val,factor,putin) { 
if (val == "") {
	val = "0"
}
evalstr = "document.form1."+putin+ ".value = "
evalstr = evalstr + Math.round((val * factor)*100)/100;
eval(evalstr)
}
function CheckLink()
{
  if (document.form1.CheckChanged.value != 0)
  {
    if (confirm("You have made changes on this page that have not been saved.\n\These changes will be lost if you navigate away from this page.\n\Click OK to contine and discard changes, or click cancel and click on next to save your changes."))
      return true;
    else
      return false;
  }
}
function DataChanged()
{
  document.form1.CheckChanged.value = 1
}
//-->
</SCRIPT>

<!--- Get Student Info by UniqueID --->
<cfinclude template="../querys/get_student_unqid.cfm">

<cfinclude template="../querys/countrylist.cfm">

<cfoutput query="get_student_unqid">

<cfform method="post" name="form1" action="?curdoc=student/qr_student_form1"><br>
<cfinput type="hidden" name="studentid" value="#get_student_unqid.studentid#">
<cfinput type="hidden" name="unqid" value="#get_student_unqid.uniqueid#">

<table width="95%" align="center">
	<tr><td><h3>S t u d e n t  &nbsp;&nbsp; I n f o r m a t i o n &nbsp;&nbsp; P a g e &nbsp;&nbsp; 1</h3></td>
		<td align="right"><h3>Student: #firstname# #familylastname# (###studentid#)</h3></td>
	</tr>
</table>

<table  width="95%" class="box" bgcolor="ffffff" align="center" cellpadding="3" cellspacing="0">
	<tr>
		<td width="70%">
			<table border="0" cellpadding="3" cellspacing="0" width="100%">
				<tr><td colspan="2" bgcolor="C2D1EF"><b>Student's Name</b></td></tr>
				<tr>
					<td width="30%" align="right">Family Name:</td>
					<td width="70%"><cfinput name="familylastname" value="#familylastname#" size="25" required="yes" message="You must enter a last name in order to continue." maxlength="50" onchange="DataChanged();"></td>
				</tr>
				<tr>
					<td align="right">First Name:</td>
					<td><cfinput name="firstname" value="#firstname#" size="25" required="yes" message="You must enter a first name in order to continue." maxlength="50" onchange="DataChanged();"></td>
				</tr>
				<tr><td align="right">Middle Name:</td><td><cfinput name="middlename" value="#middlename#" size="25" maxlength="50" onchange="DataChanged();"></td></tr>		
				
				<tr><td colspan="2" bgcolor="C2D1EF"><b>Complete Mailing Address</b></td></tr>
				<tr><td align="right">Address:</td><td><cfinput name="address" value="#address#" size="35" maxlength="50" onchange="DataChanged();"></td></tr>		
				<tr><td align="right">Address 2:</td><td><cfinput name="address2" value="#address2#" size="35" maxlength="50" onchange="DataChanged();"></td></tr>		
				<tr><td align="right">City:</td><td><cfinput name="city" size="35" value="#city#" maxlength="50" onchange="DataChanged();"></td></tr>
				<tr>
					<td align="right">Country of Residence:</td>
					<td><cfselect name="country" onchange="DataChanged();">
							<option value="0">Country...</option>
							<cfloop query="countrylist">
							<option value="#countryid#" <cfif get_student_unqid.country EQ countryid>selected</cfif>>#countryname#</option>
							</cfloop>
						</cfselect>
					</td>
				</tr>
				<tr><td align="right">Zip Code:</td><td><cfinput name="zip" value="#zip#" size="10" maxlength="10" onchange="DataChanged();"></td></tr>
				<tr><td align="right">Home Phone:</td><td><cfinput name="phone" value="#phone#" size="16" maxlength="16" onchange="DataChanged();"></td></tr>
				<tr><td align="right">Cell Phone:</td><td><cfinput name="cell_phone" value="#cell_phone#" size="16" maxlength="16" onchange="DataChanged();"></td></tr>
				<tr><td align="right">Additional Phone:</td><td><cfinput name="additional_phone" value="#additional_phone#" size="16" maxlength="16" onchange="DataChanged();"></td></tr>
				<tr><td align="right">Fax:</td><td><cfinput name="fax" value="#fax#" size="16" maxlength="16" onchange="DataChanged();"></td></tr>		
				<tr><td align="right">Email Address:</td><td><cfinput name="email" value="#email#" size="35" maxlength="50" onchange="DataChanged();"></td></tr>			
				<tr>
					<td align="right">Sex:</td>
					<td><cfif sex EQ 'male'><cfinput type="radio" name="sex" value="male" required="yes" message="You must specify the student's sex." checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="sex" value="male" required="yes" message="You must specify the student's sex." onchange="DataChanged();"></cfif>Male
					    <cfif sex EQ 'female'><cfinput type="radio" name="sex" value="female" required="yes" message="You must specify the student's sex." checked="yes" onchange="DataChanged();"><cfelse><cfinput type="radio" name="sex" value="female" required="yes" message="You must specify the student's sex." onchange="DataChanged();"></cfif>Female
					</td>
				</tr>
				<tr><td align="right">Birth Date:</td><td><cfinput type="text" value="#DateFormat(dob,'mm/dd/yyyy')#" name="dob" size="15" maxlength="10" validate="date" onchange="DataChanged();"> (mm/dd/yyyy)</td></tr>
				<tr><td align="right">City of Birth:</td><td><cfinput name="citybirth" value="#citybirth#" size="35" maxlength="50" onchange="DataChanged();"></td></tr>	
				<tr>
					<td align="right">Country of Birth:</td>
					<td><cfselect name="countrybirth" onchange="DataChanged();">
							<option value="0">Country...</option>
							<cfloop query="countrylist">
							<option value="#countryid#" <cfif get_student_unqid.countrybirth EQ countryid>selected</cfif>>#countryname#</option>
							</cfloop>
						</cfselect>
					</td>
				</tr>
				<tr>
					<td align="right">Country of Legal Permanent Residence:</td>
					<td><cfselect name="countryresident" onchange="DataChanged();">
							<option value="0">Country...</option>
							<cfloop query="countrylist">
							<option value="#countryid#" <cfif get_student_unqid.countryresident EQ countryid>selected</cfif>>#countryname#</option>
							</cfloop>
						</cfselect>
					</td>
				</tr>
				<tr>
					<td align="right">Country of Citizenship:</td>
					<td><cfselect name="countrycitizen" onchange="DataChanged();">
							<option value="0">Country...</option>
							<cfloop query="countrylist">
							<option value="#countryid#" <cfif get_student_unqid.countrycitizen EQ countryid>selected</cfif>>#countryname#</option>
							</cfloop>
						</cfselect>
					</td>
				</tr>
				<tr><td align="right">Passport Number:</td><td><cfinput name="passportnumber" value="#passportnumber#" size="15" maxlength="15" onchange="DataChanged();"> (if known)</td></tr>	
				
				<tr><td colspan="2" bgcolor="C2D1EF"><b>Measurements and Other Findings</b></td></tr>
				<tr><td align="right">Height:</td>
					<td><cfinput type="text" name="heightcm" size="7" validate="integer" message="Please, enter only number on Height cm statement" onChange = "calc(this.value,0.032808399,'height')">&nbsp;<em>cm or</em>
						<cfinput type="text" name="height" value="#height#" size="7" maxlength="4" onchange="calc(this.value,30.48,'heightcm')">&nbsp;<em>inches</em>
					</td>
				</tr>		
				<tr><td align="right">Weight:</td>  <!--- DataChanged(); ---->
					<td><cfinput type="text" name="weightkg" size="7" onchange="calc(this.value,2.2046,'weight')">&nbsp;<em>kg or</em>
						<cfinput type="text" name="weight" value="#weight#" size="7" maxlength="6" onchange="calc(this.value,0.453592,'weightkg')">&nbsp;<em>lbs</em>
					</td>
				</tr>		
				<tr><td></td><td><em>Enter only numbers in boxes above eg. 180 for cm and 80 for kg.</em></td></tr>
				<tr><td align="right">Hair Color:</td><td><cfinput name="haircolor" value="#haircolor#" size="10" maxlength="20" onchange="DataChanged();"></td></tr>
				<tr><td align="right">Eye Color:</td><td><cfinput name="eyecolor" value="#eyecolor#" size="10" maxlength="20" onchange="DataChanged();"></td></tr>	
			</table>
		</td>
		<td width="30%" valign="top">
			<table border=0 cellpadding=3 cellspacing=0 align="right">
				<tr><td align="right"><cfinclude template="student_menu.cfm"></td></tr>
			</table> 		
		</td>
	</tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr><td align="center"><br><input name="Submit" type="image" value="  next  " src="pics/next.gif" alt="Next" border="0"><br></td></tr>
</table>

</cfform>
</cfoutput>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>
</body>
</html>