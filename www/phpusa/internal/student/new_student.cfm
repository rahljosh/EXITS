<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>New Student</title>
</head>

<body>
<cftry>

<SCRIPT>
<!-- hide script
function calc(val,factor,putin) { 
if (val == "") {
	val = "0"
}
evalstr = "document.new_student."+putin+ ".value = "
evalstr = evalstr + Math.round((val * factor)*100)/100;
eval(evalstr)
}
//-->
</SCRIPT>

<cfinclude template="../querys/countrylist.cfm">

<cfoutput>

<cfform method="post" name="new_student" action="?curdoc=student/qr_new_student"><br>
<cfset tid = createuuid()>
<input type="hidden" name="uniqueid" value='#tid#'>

<table width="95%" align="center">
	<tr><td><h3>S t u d e n t  &nbsp;&nbsp; I n f o r m a t i o n </h3></td></tr>
</table>

<table  width="95%" class="box" bgcolor="ffffff" align="center" cellpadding="3" cellspacing="0">
	<tr>
		<td width="70%">
			<table border="0" cellpadding="3" cellspacing="0" width="100%">
				<tr><td colspan="2" bgcolor="C2D1EF"><b>Student's Name</b></td></tr>
				<tr>
					<td width="30%" align="right">Family Name:</td>
					<td width="70%"><cfinput name="familylastname" size="25" required="yes" message="You must enter a last name in order to continue." maxlength="50"></td>
				</tr>
				<tr>
					<td align="right">First Name:</td>
					<td><cfinput name="firstname" size="25" required="yes" message="You must enter a first name in order to continue." maxlength="50"></td>
				</tr>
				<tr><td align="right">Middle Name:</td><td><cfinput name="middlename" size="25" maxlength="50"></td></tr>		
				
				<tr><td colspan="2" bgcolor="C2D1EF"><b>Complete Mailing Address</b></td></tr>
				<tr><td align="right">Address:</td><td><cfinput name="address" size="35" maxlength="50"></td></tr>		
				<tr><td align="right">Address 2:</td><td><cfinput name="address2" size="35" maxlength="50"></td></tr>		
				<tr><td align="right">City:</td><td><cfinput name="city" size="35" maxlength="50"></td></tr>
				<tr>
					<td align="right">Country of Residence:</td>
					<td><cfselect name="country">
							<option value="0">Country...</option>
							<cfloop query="countrylist">
							<option value="#countryid#">#countryname#</option>
							</cfloop>
						</cfselect>
					</td>
				</tr>
				<tr><td align="right">Zip Code:</td><td><cfinput name="zip" size="10" maxlength="10"></td></tr>
				<tr><td align="right">Home Phone:</td><td><cfinput name="phone" size="16" maxlength="16"></td></tr>
				<tr><td align="right">Fax:</td><td><cfinput name="fax" size="16" maxlength="16"></td></tr>		
				<tr><td align="right">Email Address:</td><td><cfinput name="email" size="35" maxlength="50"></td></tr>			
				<tr>
					<td align="right">Sex:</td>
					<td><cfinput type="radio" name="sex" value="male" required="yes" message="You must specify the student's sex.">Male
					    <cfinput type="radio" name="sex" value="female" required="yes" message="You must specify the student's sex.">Female
					</td>
				</tr>
				<tr><td align="right">Birth Date:</td><td><cfinput type="text" name="dob" size="15" maxlength="10" validate="date"> (mm/dd/yyyy)</td></tr>
				<tr><td align="right">City of Birth:</td><td><cfinput name="citybirth" size="35" maxlength="50"></td></tr>	
				<tr>
					<td align="right">Country of Birth:</td>
					<td><cfselect name="countrybirth" required="yes" message="You must select a country of birth.">
							<option value="0">Country...</option>
							<cfloop query="countrylist">
							<option value="#countryid#">#countryname#</option>
							</cfloop>
						</cfselect>
					</td>
				</tr>
				<tr>
					<td align="right">Country of Legal Permanent Residence:</td>
					<td><cfselect name="countryresident" required="yes" message="You must select a country of residence.">
							<option value="0">Country...</option>
							<cfloop query="countrylist">
							<option value="#countryid#">#countryname#</option>
							</cfloop>
						</cfselect>
					</td>
				</tr>
				<tr>
					<td align="right">Country of Citizenship:</td>
					<td><cfselect name="countrycitizen" required="yes" message="You must select a country of residence.">
							<option value="0">Country...</option>
							<cfloop query="countrylist">
							<option value="#countryid#">#countryname#</option>
							</cfloop>
						</cfselect>
					</td>
				</tr>
				<tr><td align="right">Passport Number:</td><td><cfinput name="passportnumber" size="15" maxlength="15"> (if known)</td></tr>	
				
				<tr><td colspan="2" bgcolor="C2D1EF"><b>Measurements and Other Findings</b></td></tr>
				<tr><td align="right">Height:</td>
					<td><cfinput type="text" name="heightcm" size="7" validate="integer" message="Please, enter only number on Height cm statement" onChange = "calc(this.value,0.032808399,'height')">&nbsp;<em>cm or</em>
						<cfinput type="text" name="height" size="7" maxlength="4" onchange="calc(this.value,30.48,'heightcm');">&nbsp;<em>inches</em>
					</td>
				</tr>		
				<tr><td align="right">Weight:</td>
					<td><cfinput type="text" name="weightkg" size="7" onchange="calc(this.value,2.2046,'weight')">&nbsp;<em>kg or</em>
						<cfinput type="text" name="weight" size="7" maxlength="6" onchange="calc(this.value,0.453592,'weightkg');">&nbsp;<em>lbs</em>
					</td>
				</tr>		
				<tr><td></td><td><em>Enter only numbers in boxes above eg. 180 for cm and 80 for kg.</em></td></tr>
				<tr><td align="right">Hair Color:</td><td><cfinput name="haircolor" size="10" maxlength="20"></td></tr>
				<tr><td align="right">Eye Color:</td><td><cfinput name="eyecolor" size="10" maxlength="20"></td></tr>	
			</table>
		</td>
		<td width="30%">&nbsp;</td>
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