<cfif isDefined('url.hostid')>
	<cfset client.hostid = #url.hostid#>
<cfelse>
</cfif>

<cfinclude template="../querys/family_info.cfm">

<span class="application_section_header">Host Parents Infomation</span>
<cfinclude template="../family_app_menu.cfm">
<cfform method="post" action="querys/update_host_page_1.cfm">
<cfoutput query="family_info">
<div class="row">

	<Table border=0>
		<Tr>
			<td class="label">Family Name:</td><td colspan=3> <input type="text" name="familyname" size="20"  onBlur="javascript:lastname(this.form);" value="#familylastname#">
		</tr>
		<tr>
			<td class="label">Address:</td><td colspan=3> <cfinput type="text" name="address" size="20" value="#address#"></td>
		</tr>
		<tr>
			<td></td><td  colspan=3> <cfinput type="text" name="address2" size="20" value="#address2#">
		</tr>
		<tr>			 
			<td class="label">City: </td><td  colspan=3><cfinput type="text" name="city" size="20" value="#city#">
		</tr>
		<tr>	
			<td class="label" > State: </td><td width=10>
		
 <select name="state">
	
	<option selected>
	<option value="AL">AL
	<option value="AK">AK
	<option value="AZ">AZ
	<option value="AR">AR
	<option value="CA">CA
	<option value="CO">CO
	<option value="CT">CT
	<option value="DE">DE
	<option value="FL">FL
	<option value="GA">GA
	<option value="HI">HI
	<option value="ID">ID
	<option value="IL">IL
	<option value="IN">IN
	<option value="IA">IA
	<option value="KS">KS
	<option value="KY">KY
	<option value="LA">LA
	<option value="ME">MA
	<option value="MD">MD
	<option value="MA">MA
	<option value="MI">MI
	<option value="MN">MN
	<option value="MS">MS
	<option value="MO">MO
	<option value="MT">MT
	<option value="NE">NE
	<option value="NV">NV
	<option value="NH">NH
	<option value="NJ">NJ
	<option value="NM">NM
	<option value="NY">NY
	<option value="NC">NC
	<option value="ND">ND
	<option value="OH">OH
	<option value="OK">OK
	<option value="OR">OR
	<option value="PA">PA
	<option value="RI">RI
	<option value="SC">SC
	<option value="SD">SD
	<option value="TN">TN
	<option value="TX">TX
	<option value="UT">UT
	<option value="VT">VT
	<option value="VA">VA
	<option value="WA">WA
	<option value="DC">DC
	<option value="WV">WV
	<option value="WI">WI
	<option value="WY">WY
	</select>
	
	</td><td class="zip">Zip: </td><td><cfinput type="text" name="zip" size="5" value="#zip#"></td>

			</tr>
		<tr>
	
			<td class="label">Phone:</td><td  colspan=3> <cfinput type="text" name="phone" size=12 value="#phone#"> nnn-nnn-nnnn 
		</tr>
		<tr>
	
	
			<td class="label">Email:</td><td  colspan=3> <cfinput type="text" name="email" size=20 value="#email#">
			
		</tr>
 </table>
</div>

<div class="row1">
	<table>
		<tr>
			<td class="label">Fathers First Name:</td><td>  <cfinput type="text" name="fatherfirst" size="20" value="#fatherfirstname#">
		</tr>
		<tr>
 			<td class="label">Fathers Last Name:</td><td>  <cfinput type="text" name="fatherlast" size="20" value="#fatherlastname#">

			</tr>
		<tr>
			<td class="label">Date of Birth:</td><td>  <cfinput type="text" name="fatherdob" size="12" value="#DateFormat(fatherbirth, 'yyyy-mm-dd')#"> yyyy-mm-dd

		</tr>
		<tr>
	
			<td class="label">Social Security:</td><td>  <cfinput type="text" size=12 name="fathersocial" value="#fatherssn#"> nnn-nn-nnnn

		</tr>
		<tr>
	
			<td class="label">Occupation:</td><td> <cfinput type="text" size=20 name="fatherocc" value="#fatherworktype#">

		</tr>
		<tr>
	
			<td class="label"> Business Name:</td><td><cfinput type="text" size=20 name="fatherbusiness" value="#fathercompany#">


			</tr>
		<tr>
			<td class="label"> Business Phone:</td><td><cfinput type="text" size=12 name="fatherbusinessphone" value="#fatherworkphone#"> nnn-nnn-nnnn
		</tr>
	</table>
</div>
<div class="row">
	<table>
		<tr>
			<td class="label">Mothers First Name:</span></td><td><span class="formw">  <cfinput type="text" name="motherfirst" size="20" value="#motherfirstname#"></span>
</tr>
<Tr>
			<td class="label">Mothers Last Name:</span></td><td><span class="formw">  <cfinput type="text" name="motherlast" size="20" value="#motherlastname#"></span>
</tr>
<Tr>

	
			<td class="label">Date of Birth:</span></td><td><span class="formw">  <cfinput type="text" name="motherdob" size="12" value="#DateFormat(motherbirth, 'mm/dd/yyyy')#" maxlength="10"> yyyy-mm-dd</span>
</tr>
<Tr>

	
			<td class="label">Social Security:</span></td><td><span class="formw">  <cfinput type="text" size=12 name="mothersocial" value="#motherssn#"> nnn-nn-nnnn</span>
</tr>
<Tr>

	
			<td class="label">Occupation:</span></td><td><span class="formw"> <cfinput type="text" size=20 name="motherocc" value="#motherworktype#"></span>
</tr>
<Tr>

	
			<td class="label"> Business Name:</span></td><td><span class="formw"><cfinput type="text" size=20 name="motherbusiness" value="#mothercompany#"></span>
</tr>
<Tr>

	
			<td class="label"> Business Phone:</span></td><td><span class="formw"><cfinput type="text" size=12 name="motherbusinessphone" value="#motherworkphone#"> nnn-nnn-nnnn</span>
</tr>
</table>

	
				 		
</div>

<input type=submit name=submit value="  next  ">
</cfoutput>
</cfform>


</body> 
</html>
