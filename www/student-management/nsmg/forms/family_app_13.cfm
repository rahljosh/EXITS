<cfquery name="references" datasource="MySQL">
select *
from smg_family_references
where referencefor = #client.hostid#
</cfquery>
<cfform action="querys/insert_family_references.cfm" method="post">
<span class="application_section_header">References</span>
<cfinclude template="../family_app_menu.cfm">
<div class=row1>
Please list two (2) people who are <u>not</u> relatives and <u>have visited with you in your home.</u>  All information received shall remain confidential.
</div>
<Cfif references.recordcount is 0>
<div class=row>
	<Table border=0>
		<Tr>
			<td class="label">Name:</td><td colspan=3> <input type="text" name="name" size="20">
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
	</div>
	<cfelse>
	
	
	
	
	<cfoutput query="references">
	<cfif references.currentrow mod 2><div class=row1><cfelse><div class=row></cfif>
	<Table border=1>
		<Tr>
			<td class="label">Name:</td><td colspan=3> <input type="text" name="name" size="20"" value="#name#>
		</tr>
		<tr>
			<td class="label">Address:</td><td colspan=3> <cfinput type="text" name="address_#references.currentrow#" size="20" value="#address#"></td>
		</tr>
		<tr>
			<td></td><td  colspan=3> <cfinput type="text" name="address2_#references.currentrow#" size="20" value="#address2#">
		</tr>
		<tr>			 
			<td class="label">City: </td><td  colspan=3><cfinput type="text" name="city_#references.currentrow#" size="20" value="#city#">
		</tr>
		<tr>	
			<td class="label" > State: </td><td width=10>
		
 <select name="state_#references.currentrow#">
	
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
	
	</td><td class="zip">Zip: </td><td><cfinput type="text" name="zip_#references.currentrow#" size="5" value="#zip#"></td>

			</tr>
		<tr>
	
			<td class="label">Phone:</td><td  colspan=3> <cfinput type="text" name="phone_#references.currentrow#" size=12 value="#phone#"> nnn-nnn-nnnn 
		</tr>
		<tr>
	</table>
	</div>
	</cfoutput>
	</Cfif>

	 <div class="button"><input type="submit" value="    next    "></div>
</cfform>
