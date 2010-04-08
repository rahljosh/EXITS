

<cfquery name="get_pets" datasource="caseusa">
select *
from smg_host_animals 
where hostid = #client.hostid#
</cfquery>

<cfquery name="get_kids" datasource="caseusa">
select childid, name, shared
from smg_host_children
where hostid = #client.hostid#
</cfquery>
<cfinclude template="../querys/family_info.cfm">
<span class="application_section_header">Room, Smoking & Pets</span>
<cfinclude template="../family_app_menu.cfm">
<cfform action="querys/insert_host_animals.cfm" method="post">
<div class="row">
<cfif get_kids.recordcount is 0>
<div class="get_Attention">Since you don't have any kids or other family memebers living at home, it is assumend the student will not be sharing a room.  If this is wrong, 
you will need to go to <a href="family_app_2.cfm?add=1">add a family member</a>
</div>
<cfelse>
<div class="get_Attention">The student may share a bedroom with one of the same sex and within a reasonable age difference, but must have his/her own bed.</div><br>
<table>
	<tr>
		<td>Will the student share a bedroom?</td><td>  <cfif get_kids.shared is 'yes'><cfinput name="share_room" type="radio" value="yes" checked>Yes <cfinput type="Radio" name="share_room" value="no">No <cfelse><cfinput type="Radio" name="share_room" value="yes">Yes <cfinput type="Radio" name="share_room" value="no" checked>No</cfif></td>
	</tr>
	<tr>
		<td>If so, with whom will they share the room?</td><Td> <select name="kid_share">
			
			<option>
			<cfoutput query="get_kids">
			<Cfif get_kids.shared is 'yes'><option value=#childid# selected>#name#<cfelse><option value=#childid#>#name#</cfif>
			</cfoutput>
			</select>
		</td>
	</tr>
</table>
</cfif>
<span class="spacer"></span>
</div>
<div class="row1">
<table>
	<Tr>
		<td align="left">Does anyone in your family smoke?</td><td> <cfif #family_info.hostsmokes# is 'yes'><cfinput type="radio" name=smoke value="yes" checked>Yes <cfinput type="radio" name=smoke value="no">No <cfelse><cfinput type="radio" name=smoke value="yes">Yes <cfinput type="radio" name=smoke value="no" checked>No </cfif> </td>
	</tr>
		<Tr>
		<td align="left">Would you be willing to host a student who smokes?</td><td><cfif #family_info.acceptsmoking# is 'yes'><cfinput type="radio" name=stu_smoke value="yes" checked>Yes <cfinput type="radio" name=stu_smoke value="no">No<cfelse><cfinput type="radio" name=stu_smoke value="yes">Yes <cfinput type="radio" name=stu_smoke value="no" checked>No</cfif></td>
	</tr>
		<Tr>
		<td align="left" colspan=2 >Under what conditions?<br><textarea cols="50" rows="4" name="smoke_conditions" wrap="VIRTUAL"><Cfoutput>#family_info.smokeconditions#</cfoutput></textarea></td>
	</tr>
</table>
<span cless="spacer"></span>
</div>
<div class="row">
Please list any pets that you have:
<Cfif get_pets.recordcount is 0>

<table width=400>
	<tr>
		<Td align="center">Type of animal</td><td align="Center">Indoor, Outdoor, or Both</td><td>Number</td>
	</tr>
	<tr>
		<Td><cfinput type="text" name="animal1" size=10></td><td><cfinput type="radio" name=indoor value="indoor"> Indoor 
		<cfinput type="radio" name=indoor value="outdoor"> Outdoor <cfinput type="radio" name=indoor value="both">Both</td>
		<td><select name="number_pets"><option selected>
			<option value=1>1
			<option value=2>2
			<option value=3>3
			<option value=4>4
			<option value=5>5
			<option value=6>6
			<option value=7>7
			<option value=8>8
			<option value=9>9
			<option value=10>10
			<option value=11>10+
			</select>
	</tr>
		<tr>
		<Td><cfinput type="text" name="animal2" size=10></td><td><cfinput type="radio" name=indoor2 value="indoor"> Indoor 
		<cfinput type="radio" name=indoor2 value="outdoor"> Outdoor <cfinput type="radio" name=indoor2 value="both">Both</td>
		<td><select name=number_pets2><option selected>
			<option value=1>1
			<option value=2>2
			<option value=3>3
			<option value=4>4
			<option value=5>5
			<option value=6>6
			<option value=7>7
			<option value=8>8
			<option value=9>9
			<option value=10>10
			<option value=11>10+
			</select>
	</tr>
		<tr>
		<Td><cfinput type="text" name="animal3" size=10></td><td><cfinput type="radio" name=indoor3 value="indoor"> Indoor 
		<cfinput type="radio" name=indoor3 value="outdoor"> Outdoor <cfinput type="radio" name=indoor3 value="both">Both</td>
		<td><select name="number_pets3"><option selected>
			<option value=1>1
			<option value=2>2
			<option value=3>3
			<option value=4>4
			<option value=5>5
			<option value=6>6
			<option value=7>7
			<option value=8>8
			<option value=9>9
			<option value=10>10
			<option value=11>10+
			</select>
	</tr>
		<tr>
		<Td><cfinput type="text" name="animal4" size=10></td><td><cfinput type="radio" name=indoor4 value="indoor"> Indoor 
		<cfinput type="radio" name=indoor4 value="outdoor"> Outdoor <cfinput type="radio" name=indoor4 value="both">Both</td>
		<td><select name="number_pets4"><option selected>
			<option value=1>1
			<option value=2>2
			<option value=3>3
			<option value=4>4
			<option value=5>5
			<option value=6>6
			<option value=7>7
			<option value=8>8
			<option value=9>9
			<option value=10>10
			<option value=11>10+
			</select>
	</tr>
		<tr>
		<Td><cfinput type="text" name="animal5" size=10></td><td><cfinput type="radio" name=indoor5 value="indoor"> Indoor 
		<cfinput type="radio" name=indoor5 value="outdoor"> Outdoor <cfinput type="radio" name=indoor5 value="both">Both</td>
		<td><select name="number_pets5"><option selected>
			<option value=1>1
			<option value=2>2
			<option value=3>3
			<option value=4>4
			<option value=5>5
			<option value=6>6
			<option value=7>7
			<option value=8>8
			<option value=9>9
			<option value=10>10
			<option value=11>10+
			</select>
	</tr>
	
</table>
<cfelse>

<input type="hidden" name="pets_exist">

<table width=400>
	<tr>
		<Td align="center">Type of animal</td><td align="Center">Indoor, Outdoor, or Both</td><td>Number</td>
	</tr>
	<cfoutput query="get_pets">
	<tr>
		<Td><input type="hidden" name="animal#get_pets.currentrow#" value=#animalid#><cfinput type="text" name="animaltype#get_pets.currentrow#" size=10 value="#animaltype#"></td>
		<td><Cfif #indoor# is 'indoor'><cfinput type="radio" name="indoor#get_pets.currentrow#" value="indoor" checked> Indoor <cfinput type="radio" name="indoor#get_pets.currentrow#" value="outdoor"> Outdoor <cfinput type="radio" name="indoor#get_pets.currentrow#" value="both">Both
		<cfelseif #indoor# is 'outdoor'><cfinput type="radio" name="indoor#get_pets.currentrow#" value="indoor"> Indoor <cfinput type="radio" name="indoor#get_pets.currentrow#" value="outdoor" checked> Outdoor <cfinput type="radio" name="indoor#get_pets.currentrow#" value="both">Both
		<cfelseif #indoor# is 'both'><cfinput type="radio" name="indoor#get_pets.currentrow#" value="indoor"> Indoor <cfinput type="radio" name="indoor#get_pets.currentrow#" value="outdoor"> Outdoor <cfinput type="radio" name="indoor#get_pets.currentrow#" value="both" checked>Both
		<cfelse><cfinput type="radio" name="indoor#get_pets.currentrow#" value="indoor"> Indoor <cfinput type="radio" name="indoor#get_pets.currentrow#" value="outdoor"> Outdoor <cfinput type="radio" name="indoor#get_pets.currentrow#" value="both">Both</cfif></td>
		<td><select name="number_pets#get_pets.currentrow#"><option>
			<cfif #number# is 1><option value=1 selected>1<cfelse><option value=1>1</cfif>
			<cfif #number# is 2><option value=2 selected>2<cfelse><option value=2>2</cfif>
			<cfif #number# is 3><option value=3 selected>3<cfelse><option value=3>3</cfif>
			<cfif #number# is 4><option value=4 selected>4<cfelse><option value=4>4</cfif>
			<cfif #number# is 5><option value=5 selected>5<cfelse><option value=5>5</cfif>
			<cfif #number# is 6><option value=6 selected>6<cfelse><option value=6>6</cfif>
			<cfif #number# is 7><option value=7 selected>7<cfelse><option value=7>7</cfif>
			<cfif #number# is 8><option value=8 selected>8<cfelse><option value=8>8</cfif>
			<cfif #number# is 9><option value=9 selected>9<cfelse><option value=9>9</cfif>
			<cfif #number# is 10><option value=10 selected>10<cfelse><option value=10>10</cfif>
			<cfif #number# is 11><option value=11 selected>10+<cfelse><option value=11>10+</cfif>
			</select>
		</td>
	</tr>

</cfoutput>
</table>
</Cfif>
</div>
<div class="row1">
Would you be willing to host a student who is allergic to animals? <cfif #family_info.pet_Allergies# is 'yes'><cfinput type="Radio" name="allergic" value="yes" checked>Yes <cfinput type="Radio" name="allergic" value="no">No<cfelse><cfinput type="Radio" name="allergic" value="yes">Yes <cfinput type="Radio" name="allergic" value="no" checked>No</cfif>
<span class="spacer"></span>
</div>

<div class="button"><input type="submit" value="Next"></div>
</cfform>

