<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Student Information - Page 2</title>

<cftry>

<!--- Get Student Info by UniqueID --->
<cfinclude template="../querys/get_student_unqid.cfm">

<cfoutput>
<script language="JavaScript">
<!--
function CheckLink()
{
  if (document.form2.CheckChanged.value != 0)
  {
    if (confirm("You have made changes on this page that have not been saved.\n\These changes will be lost if you navigate away from this page.\n\Click OK to contine and discard changes, or click cancel and click on next to save your changes."))
      return true;
    else
      return false;
  }
}
function DataChanged()
{
  document.form2.CheckChanged.value = 1
}
function copyfatheraddress() {
if (form2.checkfather.checked) {
form2.fatheraddress.value = '#get_student_unqid.address#';
form2.fatheraddress2.value = '#get_student_unqid.address2#';
form2.fathercity.value = '#get_student_unqid.city#';
form2.fathercountry.value = '#get_student_unqid.country#';
form2.fatherzip.value = '#get_student_unqid.zip#';       
}
else {
form2.fatheraddress.value = '';
form2.fatheraddress2.value = '';
form2.fathercity.value = '';
form2.fatherzip.value = '';       
form2.fathercountry.value = '0';
   }
}
function copymotheraddress(form) {
if (form2.checkmother.checked) {
form2.motheraddress.value = '#get_student_unqid.address#';
form2.motheraddress2.value = '#get_student_unqid.address2#';
form2.mothercity.value = '#get_student_unqid.city#';
form2.mothercountry.value = '#get_student_unqid.country#';
form2.motherzip.value = '#get_student_unqid.zip#';       
}
else {
form2.motheraddress.value = '';
form2.motheraddress2.value = '';
form2.mothercity.value = '';
form2.motherzip.value = '';       
form2.mothercountry.value = '0';
   }
}
//  End -->
</script>
</cfoutput>
</head>

<body>
<cfinclude template="../querys/countrylist.cfm">

<cfoutput query="get_student_unqid">
<cfform method="post" name="form2" action="?curdoc=student/qr_student_form2"><br>
<cfinput type="hidden" name="studentid" value="#get_student_unqid.studentid#">

<table width="95%" align="center">
	<tr><td><h3>S t u d e n t  &nbsp;&nbsp; I n f o r m a t i o n &nbsp;&nbsp; P a g e &nbsp;&nbsp; 2</h3></td>
		<td align="right"><h3>Student: #firstname# #familylastname# (###studentid#)</h3></td>
	</tr>
</table>

<table  width="95%" class="box" bgcolor="ffffff" align="center" cellpadding="3" cellspacing="0">
	<tr>
		<td width="70%">
			<table border="0" cellpadding="3" cellspacing="0" width="100%">
				<tr><td colspan="2" bgcolor="C2D1EF"><b>Father Information</b></td></tr>
				<tr>
					<td width="30%" align="right">Fathers Name:</td>
					<td width="70%"><cfinput name="fathersname" value="#fathersname#" size="25" maxlength="50" onchange="DataChanged();"></td>
				</tr>
				<tr><td align="right">Address:</td>
					<td><cfinput name="fatheraddress" value="#fatheraddress#" size="35" maxlength="50" onchange="DataChanged();"> &nbsp; 
						<cfinput type="checkbox" name="checkfather" OnClick="javascript:copyfatheraddress();" value="checkbox"> Same as Student
					</td>
				</tr>		
				<tr><td align="right">Address 2:</td><td><cfinput name="fatheraddress2" value="#fatheraddress2#" size="35" maxlength="50" onchange="DataChanged();"></td></tr>		
				<tr><td align="right">City:</td><td><cfinput name="fathercity" value="#fathercity#" size="35" maxlength="50" onchange="DataChanged();"></td></tr>
				<tr>
					<td align="right">Country of Residence:</td>
					<td><cfselect name="fathercountry" onchange="DataChanged();">
							<option value="0">Country...</option>
							<cfloop query="countrylist">
							<option value="#countryid#" <cfif get_student_unqid.fathercountry EQ countryid>selected</cfif>>#countryname#</option>
							</cfloop>
						</cfselect>
					</td>
				</tr>
				<tr><td align="right">Zip Code:</td><td><cfinput name="fatherzip" value="#fatherzip#" size="10" maxlength="10" onchange="DataChanged();"></td></tr>
				<tr>
					<td align="right">Speaks English:</td>
					<td><cfif fatherenglish EQ 'yes'><cfinput type="radio" name="fatherenglish" value="Yes" checked="yes" onchange="DataChanged();">Yes<cfelse><cfinput type="radio" name="fatherenglish" value="Yes" onchange="DataChanged();">Yes</cfif>&nbsp; &nbsp;
						<cfif fatherenglish EQ 'no'><cfinput type="radio" name="fatherenglish" value="No" checked="yes" onchange="DataChanged();">No<cfelse><cfinput type="radio" name="fatherenglish" value="No" onchange="DataChanged();">No</cfif>	
					</td>
				</tr>
				<tr><td align="right">Year of Birth:</td><td><cfinput type="text" name="fatherbirth" size="4" value="#fatherbirth#" maxlength="4" onchange="DataChanged();"> (yyyy)</td></tr>
				<tr><td align="right">Occupation:</td><td><cfinput type="text" name="fatherworkposition" size="35" value="#fatherworkposition#" maxlength="50" onchange="DataChanged();"></td></tr>
				<tr><td align="right">Employed By:</td><td><cfinput type="text" name="fathercompany" size="35" value="#fathercompany#" maxlength="50" onchange="DataChanged();"></td></tr>
				<tr><td align="right">Business Phone:</td><td><cfinput name="fatherworkphone" value="#fatherworkphone#" size="16" maxlength="16" onchange="DataChanged();"></td></tr>
				<tr><td colspan="2" bgcolor="C2D1EF"><b>Mother Information</b></td></tr>
				<tr>
					<td width="30%" align="right">Mothers Name:</td>
					<td width="70%"><cfinput name="mothersname" value="#mothersname#" size="25" maxlength="50" onchange="DataChanged();"></td>
				</tr>
				<tr><td align="right">Address:</td>
					<td><cfinput name="motheraddress" value="#motheraddress#" size="35" maxlength="50" onchange="DataChanged();"> &nbsp;
						<cfinput type="checkbox" name="checkmother" value="checkbox" OnClick="javascript:copymotheraddress();"> Same as Student
					</td>
				</tr>		
				<tr><td align="right">Address 2:</td><td><cfinput name="motheraddress2" value="#motheraddress2#" size="35" maxlength="50" onchange="DataChanged();"></td></tr>		
				<tr><td align="right">City:</td><td><cfinput name="mothercity" value="#mothercity#" size="35" maxlength="50" onchange="DataChanged();"></td></tr>
				<tr>
					<td align="right">Country of Residence:</td>
					<td><cfselect name="mothercountry" onchange="DataChanged();">
							<option value="0">Country...</option>
							<cfloop query="countrylist">
							<option value="#countryid#" <cfif get_student_unqid.mothercountry EQ countryid>selected</cfif>>#countryname#</option>
							</cfloop>
						</cfselect>
					</td>
				</tr>
				<tr><td align="right">Zip Code:</td><td><cfinput name="motherzip" value="#motherzip#" size="10" maxlength="10" onchange="DataChanged();"></td></tr>
				<tr>
					<td align="right">Speaks English:</td>
					<td><cfif motherenglish EQ 'yes'><cfinput type="radio" name="motherenglish" value="Yes" checked="yes" onchange="DataChanged();">Yes<cfelse><cfinput type="radio" name="motherenglish" value="Yes" onchange="DataChanged();">Yes</cfif>&nbsp; &nbsp;
						<cfif motherenglish EQ 'no'><cfinput type="radio" name="motherenglish" value="No" checked="yes" onchange="DataChanged();">No<cfelse><cfinput type="radio" name="motherenglish" value="No" onchange="DataChanged();">No</cfif>	
					</td>
				</tr>
				<tr><td align="right">Year of Birth:</td><td><cfinput type="text" name="motherbirth" size="4" value="#motherbirth#" maxlength="4" onchange="DataChanged();"> (yyyy)</td></tr>
				<tr><td align="right">Occupation:</td><td><cfinput type="text" name="motherworkposition" size="35" value="#motherworkposition#" maxlength="50" onchange="DataChanged();"></td></tr>
				<tr><td align="right">Employed By:</td><td><cfinput type="text" name="mothercompany" size="35" value="#mothercompany#" maxlength="50" onchange="DataChanged();"></td></tr>
				<tr><td align="right">Business Phone:</td><td><cfinput name="motherworkphone" value="#motherworkphone#" size="16" maxlength="16" onchange="DataChanged();"></td></tr>
				<tr><td colspan="2" bgcolor="C2D1EF"><b>Emergency Contact Information</b></td></tr>
				<tr><td align="right">Name:</td><td><cfinput name="emergency_name" value="#emergency_name#" size="25" ></td></tr>
				<tr><td align="right">Phone:</td><td><cfinput name="emergency_phone" value="#emergency_phone#" size="16"></td></tr>

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