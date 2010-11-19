<SCRIPT LANGUAGE="JavaScript">

<!-- This script and many more are available free online at -->
<!-- The JavaScript Source!! http://javascript.internet.com -->

<!-- Begin
var fatherlast = "";
var motherlast = "";


function InitSaveVariables(form) {
fatherlast = form.fatherlast.value;
motherlast = form.motherlast.value;


}

function lastname(form) {

InitSaveVariables(form);
form.fatherlast.value = form.familyname.value;
form.motherlast.value = form.familyname.value;

}

//  End -->
</script>

<cfquery name="country_list" datasource="MySQL">
select countryname, countryid
from smg_countrylist
ORDER BY countryname
</cfquery>

<cfoutput>

<cfform method="post" action="?curdoc=querys/insert_student_info">

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
		<td background="pics/header_background.gif"><h2>Student Information</h2></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table width="100%" border=0 cellpadding=3 cellspacing=0 class="section">
	<tr><td width="80%">
		<table border=0 cellpadding=3 cellspacing=0 align="left" width="100%">
			<tr><td class="label">Family Name:</td><td colspan=3> <input type="text" name="familyname" size="20"></td></tr>
			<tr><td class="label">First Name:</td><td colspan=3> <input type="text" name="firstname" size="20"></td></tr>
			<tr><td class="label">Middle Name:</td><td colspan=3> <input type="text" name="middlename" size="20"></td></tr>
			<tr><td class="label">Address:</td><td colspan=3> <cfinput type="text" name="address" size="20"></td></tr>
			<tr><td></td>
				<td colspan=3><cfinput type="text" name="address2" size="20"></td></tr>
			<tr><td class="label">City: </td><td colspan=3><cfinput type="text" name="city" size="20"></td></tr>
			<tr><td class="label" > Country:</td>
				<td><cfselect name="country">
					<option value="">Country...</option>
					<cfloop query="country_list"><option value="#countryid#">#countryname#</option></cfloop>
					</cfselect></td></tr>
			<tr><td class="zip">Zip: </td><td><cfinput type="text" name="zip" size="10"></td></tr>
			<tr><td class="label">Phone:</td><td  colspan=3> <cfinput type="text" name="phone" size=20></td></tr>
			<tr><td class="label">Fax:</td><td  colspan=3> <cfinput type="text" name="fax" size=20></td></tr>
			<tr><td class="label">Email:</td><td  colspan=3><cfinput type="text" name="email" size=20></td></tr>

			<tr bgcolor="e2efc7">
				<td class="label">Sex:</td><td class="form_text"><cfinput type="radio" name="sex" value="male" required="yes" message="You must specify the students sex.">Male <cfinput type="radio" name="sex" required value="female" message="You must specify the students sex.">Female</td></tr>
			<tr bgcolor="e2efc7">
				<td class="label">Hair Color: </td><td class="form_text"><cfinput type="text" name="haircolor" size="10"></td></tr>
			<tr bgcolor="e2efc7">
				<td class="label">Eye Color: </td><td class="form_text"><cfinput type="text" name="eyecolor" size="10"></td></tr>
			<tr bgcolor="e2efc7">
				<td class="label">Height: </td><td class="form_text"><cfinput type="text" name="heightcm" size="3" value=1>cm or <cfinput type="text" name="heightin" size="3" value=0>feet/inches (5'6")</td></tr>
			<tr bgcolor="e2efc7">
				<td class="label">Weight: </td><td class="form_text">
					<input type="text" name="G" size="3" value="1" onChange="weight.value = 2.2046 * this.value"> kg  or 
					<input type="text" name="weight" size="3" value="1" onChange="G.value = 0.453592 * this.value">lbs </td></tr>
			<tr bgcolor="e2efc7">
				<td class="label">Birthdate: </td><td class="form_text"><cfinput type=text name="dob" size=10 validate="date" maxlength="10" message="Date muse be in this format: mm/dd/yyyy"> mm/dd/yyyy</td></tr>
			<tr bgcolor="e2efc7">
				<td class="label">City of Birth: </td><td class="form_text"><cfinput type=text name="citybirth" size=30></td></tr>

			<tr><td class="label">Country of Birth:</td>
				<td><cfselect name="countrybirth">
						<option value="">Country...</option>
					<cfloop query="country_list"><option value="#countryid#">#countryname#</option></cfloop>
					</cfselect></td></tr>
			<tr><td class="label">Country of Legal Permanent Residence:</td>
				<td><cfselect name="Countryresidence">
					<option value="">Country...</option>
					<cfloop query="country_list">
					  <!--- do not show Serbia and Montenegro SEVIS --->
					  <cfif countryid NEQ 250>						
						<option value="#countryid#">#countryname#</option>
					  </cfif>
					</cfloop>
					</cfselect></td></tr>
			<tr><td class="label">Country of Citizenship:</td>
				<td><cfselect name="countrycitizinship"><br>
					<option value="">Country...</option>
					<cfloop query="country_list">
					  <!--- do not show Serbia and Montenegro SEVIS --->
					  <cfif countryid NEQ 250>
						<option value="#countryid#">#countryname#</option>
					  </cfif>
					</cfloop>
					</cfselect></td></tr>		
			<tr><td class="label">Passport Number: </td><Td><cfinput type="text" name="passport" size=11> (if known)</td></tr>
		</table>
	</td>
	</tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr><td align="center"><input name="Submit" type="image" src="pics/next.gif" border="0" value="  next  "></td></tr>
</table>
<cfset tid = createuuid()>
<input type="hidden" name="uniqueid" value='#tid#'>
<cfinclude template="../table_footer.cfm">
</cfform>

</cfoutput>

</body> 
</html>