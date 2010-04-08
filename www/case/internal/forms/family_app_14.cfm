
<div style="width:500px; background-color: #white; padding: 5px; margin: 0px auto;">
<cfform action="../querys/insert_suggested_families.cfm" method="post">
<span class="application_section_header">Other Host Families</span>
<div class=row1>
Do you know of any other familys who might be interested in hosting a student?  If so, please fill out this form and we will send them information on hosting a student, otherwise, just click next.
</div>
<div class=row>
<Table border=0>
		<Tr>
			<td class="label">Name:</td><td colspan=3> <input type="text" name="name" size="20"">
		</tr>
		<tr>
			<td class="label">Address:</td><td colspan=3> <cfinput type="text" name="address" size="20"></td>
		</tr>
		<tr>
			<td></td><td  colspan=3> <cfinput type="text" name="address2" size="20">
		</tr>
		<tr>			 
			<td class="label">City: </td><td  colspan=3><cfinput type="text" name="city" size="20">
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
	
	</td><td class="zip">Zip: </td><td><cfinput type="text" name="zip" size="5"></td>

			</tr>
		<tr>
	
			<td class="label">Phone:</td><td  colspan=3> <cfinput type="text" name="phone" size=12> nnn-nnn-nnnn 
		</tr>
		<tr>
	</table>
	</div>
<div class="row1">
<br>
	<Table border=0>
		<Tr>
			<td class="label">Name:</td><td colspan=3> <input type="text" name="name2" size="20">
		</tr>
		<tr>
			<td class="label">Address:</td><td colspan=3> <cfinput type="text" name="address_2" size="20"></td>
		</tr>
		<tr>
			<td></td><td  colspan=3> <cfinput type="text" name="address2_2" size="20">
		</tr>
		<tr>			 
			<td class="label">City: </td><td  colspan=3><cfinput type="text" name="city2" size="20">
		</tr>
		<tr>	
			<td class="label" > State: </td><td width=10>
		
 <select name="state2">
	
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
	
	</td><td class="zip">Zip: </td><td><cfinput type="text" name="zip2" size="5"></td>

			</tr>
		<tr>
	
			<td class="label">Phone:</td><td  colspan=3> <cfinput type="text" name="phone2" size=12> nnn-nnn-nnnn 
		</tr>
		<tr>
	</table>
</cfform>

