<!----Father and Mother address---->
<cfinclude template="../querys/get_student_info.cfm">

<cfoutput>
<SCRIPT LANGUAGE="JavaScript">
<!-- This script and many more are available free online at -->
<!-- The JavaScript Source!! http://javascript.internet.com -->
<!-- Begin -->
function InitSaveVariables(form) {
}

function copyfatheraddress(form) {
if (form.checkfather.checked) {
form.fathersaddress.value = '#get_student_info.address#';
form.fatheraddress2.value = '#get_student_info.address2#';
form.fathercity.value = '#get_student_info.city#';
form.fathercountry.value = '#get_student_info.country#';
form.fatherzip.value = '#get_student_info.zip#';       
}
else {
form.fathersaddress.value = '';
form.fatheraddress2.value = '';
form.fathercity.value = '';
form.fatherzip.value = '';       
form.fathercountry.value = '';
   }
}

function copymotheraddress(form) {
if (form.checkmother.checked) {
form.mothersaddress.value = '#get_student_info.address#';
form.motheraddress2.value = '#get_student_info.address2#';
form.mothercity.value = '#get_student_info.city#';
form.mothercountry.value = '#get_student_info.country#';
form.motherzip.value = '#get_student_info.zip#';       
}
else {
form.mothersaddress.value = '';
form.motheraddress2.value = '';
form.mothercity.value = '';
form.motherzip.value = '';       
form.mothercountry.value = '';
   }
}
//  End -->
</script>
</cfoutput>

<cfquery name="country_list" datasource="MySQL">
select countryname, countryid
from smg_countrylist
order by countryname
</cfquery>

<cfform method="post" action="querys/insert_stu_family_info.cfm"> 
<cfoutput query="get_student_info">

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
		<td background="pics/header_background.gif"><h2>Family Information</h2></td>
		<td align="right" background="pics/header_background.gif"> Student: #firstname# #familylastname# (#studentid#) &nbsp; <span class="edit_link">[ <a href="?curdoc=student_info&studentid=#studentid#">overview</a> ]</span></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table width="100%" border=0 cellpadding=3 cellspacing=0 class="section">
	<tr><td width="80%">
		<table border=0 cellpadding=3 cellspacing=0 align="left" width="100%">
			<!--- FATHER --->
			<tr><td class="label">Fathers Name:</td>
				<td><cfinput type="text" name="fathersname" size="20" value="#fathersname#"></td></tr>
			<tr><td class="label">Address:</td>
				<td><cfinput type="text" name="fathersaddress" size="20" value="#fatheraddress#"> 
					<input type="checkbox" name="checkfather" OnClick="javascript:copyfatheraddress(this.form);" value="checkbox"> Same as Student</td></tr>
			<tr><td></td>
				<td colspan=3><cfinput type="text" name="fatheraddress2" size="20" value="#fatheraddress2#"></td></tr>
			<tr><td class="label">City: </td>
				<td colspan=3><cfinput type="text" name="fathercity" size="20" value="#fathercity#"></td></tr>
			<tr><td class="label"> Country: </td>
				<td><cfselect name="fathercountry">
					<option value="0">Country...</option>
					<cfloop query="country_list">
					  <option value="#countryid#" <cfif #get_student_info.fathercountry# is #countryid#>selected</cfif>>#countryname#</option>
					</cfloop>
					</cfselect></td></tr>
			<tr><td class="zip">Zip: </td><td><cfinput type="text" name="fatherzip" size="10" value="#fatherzip#"></td></tr>
			<tr><td class="zip">Speaks English: </td>
				<td><cfif fatherenglish is 'yes'><cfinput type="radio" name="fatherenglish" size="10" value="yes" checked>Yes <cfinput type="radio" name="fatherenglish" size="10" value="no">No</cfif>
					<cfif fatherenglish is 'no'><cfinput type="radio" name="fatherenglish" size="10" value="yes">Yes <cfinput type="radio" name="fatherenglish" size="10" value="no" checked>No </cfif>
					<cfif fatherenglish is ''><cfinput type="radio" name="fatherenglish" size="10" value="yes">Yes <cfinput type="radio" name="fatherenglish" size="10" value="no">No </cfif></td></tr>
			<tr><td class="label">Year of Birth:</td>
				<td><cfinput type="text" name="fatherdob" size="4" value="#fatherbirth#" maxlength="4"> yyyy</td></tr>
			<tr><td class="label">Occupation:</td>
				<td><cfinput type="text" size=20 name="fatherocc" value="#fatherworkposition#"></td></tr>
			<tr><td class="label">Employed by:</td>
				<td><cfinput type="text" size=20 name="fatherbusiness" value="#fathercompany#"></td></tr>
			<tr><td class="label">Business Phone:</td>
				<td><cfinput type="text" size=20 name="fatherbusinessphone" value="#fatherworkphone#"></td></tr>
			<!--- MOTHER --->
			<tr bgcolor="e2efc7">
				<td class="label">Mothers Name:</td>
				<td><cfinput type="text" name="Mothersname" size="20" value="#mothersname#"></td></tr>
			<tr bgcolor="e2efc7">
				<td class="label">Address:</td>
				<td><cfinput type="text" name="mothersaddress" size="20" value="#motheraddress#"> 
					<input type="checkbox" name="checkmother" value="checkbox" OnClick="javascript:copymotheraddress(this.form);"> Same as Student</td></tr>
			<tr bgcolor="e2efc7">
				<td></td>
				<td colspan=3><cfinput type="text" name="motheraddress2" size="20" value="#motheraddress2#"></td></tr>
			<tr bgcolor="e2efc7">			 
				<td class="label">City:</td>
				<td  colspan=3><cfinput type="text" name="mothercity" size="20" value="#mothercity#"></td></tr>
			<tr bgcolor="e2efc7">	
				<td class="label" >Country: </td>
				<td><cfselect name="mothercountry">
					<option value="0">Country...</option>
					<cfloop query="country_list">
						<option value="#countryid#" <cfif #get_student_info.mothercountry# is #countryid#>selected</cfif>>#countryname#</option>
					</cfloop>
					</cfselect></td></tr>
			<tr bgcolor="e2efc7">
				<td class="zip">Zip: </td>
				<td><cfinput type="text" name="motherzip" size="10" value="#motherzip#"></td></tr>
			<tr bgcolor="e2efc7">
				<td class="zip">Speaks English: </td>
				<td><cfif motherenglish is 'yes'><cfinput type="radio" name="motherenglish" size="10" value="yes" checked>Yes <cfinput type="radio" name="motherenglish" size="10" value="no">No</cfif>
					<cfif motherenglish is 'no'><cfinput type="radio" name="motherenglish" size="10" value="yes">Yes <cfinput type="radio" name="motherenglish" size="10" value="no" checked>No</cfif>
					<cfif motherenglish is ''><cfinput type="radio" name="motherenglish" size="10" value="yes">Yes <cfinput type="radio" name="motherenglish" size="10" value="no">No</cfif></td></tr>
			<tr bgcolor="e2efc7">
				<td class="label">Year of Birth:</td>
				<td><cfinput type="text" name="Motherdob" size="4" value="#motherbirth#" maxlength="4"> yyyy</td></tr>
			<tr bgcolor="e2efc7">
				<td class="label">Occupation:</td>
				<td><cfinput type="text" size=20 name="motherocc" value="#motherworkposition#"></td></tr>
			<tr bgcolor="e2efc7">
				<td class="label">Employed by:</td>
				<td><cfinput type="text" size=20 name="mothercompany" value="#mothercompany#"></td></tr>
			<tr bgcolor="e2efc7">
				<td class="label"> Business Phone:</td>
				<td><cfinput type="text" size=20 name="motherbusinessphone" value="#motherworkphone#"></td></tr>			
			<!--- EMERGENCY CONTACT --->
			<tr><td class="label">Emergency Contact</td><td></td></tr>
			<tr><td class="label">Phone:</td><td><cfinput type="text" name="emergency_phone" size="20" value="#emergency_phone#"></td></tr>
			<tr><td class="label">Name:</td><td><cfinput type="text" name="emergency_name" size="20" value="#emergency_name#"></td></tr>
			<tr><td class="label">Address:</td><td><cfinput type="text" name="emergency_address" size="20" value="#emergency_address#"></td></tr>
			<tr><td class="label">Country:</td>
				<td><cfselect name="emergency_country">
						<option value="">Country...</option>
						<cfloop query="country_list">
						<option value="#countryid#" <cfif #get_student_info.emergency_country# is #countryid#>selected</cfif>>#countryname#</option>
						</cfloop>
					</cfselect></td></tr>		
		</table>
	</td>
	<td width="20%" align="right" valign="top">
		<table border=0 cellpadding=3 cellspacing=0 align="right">
			<tr><td align="right"><cfinclude template="../student_app_menu.cfm"></td></tr>
		</table> 		
	</td>
	</tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr><td align="center"><input name="Submit" type="image" src="pics/next.gif" border="0" value="  next  "></td></tr>
</table>

<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>
</cfoutput>
</cfform>