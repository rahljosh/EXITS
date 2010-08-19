<script>
function areYouSurePet() { 
   if(confirm("You are about to delete the pet selected. You will not be able to recover this information. Click OK to continue")) { 
     form.submit(); 
        return true; 
   } else { 
        return false; 
   } 
} 
</script>

<cfquery name="get_host_religion" datasource="mysql">
select religion, religious_participation
from smg_hosts
where hostid = #CLIENT.hostID#
</cfquery>

<cfquery name="get_pets" datasource="mysql">
select *
from smg_host_animals 
where hostid = #CLIENT.hostID#
</cfquery>

<cfquery name="check_placed" datasource="mysql">
select studentid 
from smg_students
where hostid = #CLIENT.hostID# and active = 1
</cfquery>

<cfquery name="get_kids" datasource="mysql">
select childid, name, shared
from smg_host_children
where hostid = #CLIENT.hostID#
</cfquery>

<cfinclude template="../querys/family_info.cfm">
<cfform action="querys/insert_pis_3.cfm" method="post">
<cfoutput>
<h2>&nbsp;&nbsp;&nbsp;&nbsp;R o o m,  &nbsp;&nbsp;&nbsp; S m o k i n g  &nbsp;&nbsp;&nbsp;  &&nbsp;&nbsp;&nbsp; p e t s  <font size=-2>[ <cfoutput><a href="?curdoc=host_fam_info&hostid=#CLIENT.hostID#">overview</a></cfoutput> ] </font></h2>

<table width="90%" border=1 align="center" cellpadding=8 cellspacing=8 bordercolor="##C7CFDC" bgcolor="##FFFFFF" class="section">
<tr><td width="80%" class="box">
		<table border=0 cellpadding=4 cellspacing=0 align="left">
			<tr><td colspan="3">
			<cfif get_kids.recordcount is 0> <!--- host family kids --->
				<div class="get_Attention">Since you don't have any kids or other family memebers living at home, it is assumend the student will not be sharing a room.  If this is wrong, 
											you will need to go to <a href="index.cfm?curdoc=forms/host_fam_pis_2&add=1">add a family member</a></div>
			<cfelse> <!--- host family kids --->
				<div class="get_Attention">The student may share a bedroom with one of the same sex and within a reasonable age difference, but must have his/her own bed.</div>
			</cfif> <!--- host family kids --->
			</td></tr>
			<cfif check_placed.recordcount is 0> <!--- check placed --->
				<cfquery name="check_share" datasource="mysql">
				select shared
				from smg_host_children
				where hostid = #CLIENT.hostID# and shared = 'yes'
				</cfquery>
			<tr><Td colspan="2">Will the student share a bedroom?</Td>
				<td><cfif check_share.recordcount gt 0>
					<cfinput type="Radio" name="share_room" value="yes" checked>Yes <cfinput type="Radio" name="share_room" value="no">No
					<cfelse>
					<cfinput type="Radio" name="share_room" value="yes" >Yes <cfinput type="Radio" name="share_room" value="no"checked>No
					</cfif></td>
			</tr>
			<tr><td colspan="2">If so, with whom will they share the room?</td>
				<Td><select name="kid_share"><option>
					<cfloop query="get_kids">
						<option value=#childid# <cfif shared is 'yes'>selected</cfif>>#name#</option>
					</cfloop>
					</select>
				</td>
			</tr>
			<cfelse> <!--- check_placed.recordcount --->
				<cfquery name="get_students_hosting_if_double" datasource="mysql">
				select studentid, firstname, familylastname from smg_students
				where hostid = #CLIENT.hostID# and active = 1
				</cfquery>
				<cfset stulist =''>
				<cfloop query="get_students_hosting_if_double">
					<cfset stulist = ListAppend(stulist, #studentid#)>
					<tr><td colspan="2">Will #firstname# #familylastname# share a bedroom? <input type="hidden" name="#studentid#_studentidsharing" value=#studentid#></td>
						<td><!----Check if sharing with a host child---->
							<Cfquery name="check_sharing" datasource="mysql">
							select shared, roomsharewith, childid
							from smg_host_children
							where roomsharewith = #studentid#
							</Cfquery>
							<!----Check if sharing with a double placement---->
							<Cfquery name="check_share_double" datasource="mysql">
							select double_place_share
							from smg_students where studentid = #studentid#
							</Cfquery>
							<cfif check_share_double.double_place_share neq 0 or check_sharing.recordcount neq 0>
								 <cfinput name="#studentid#_share_room" type="radio" value="yes" checked>Yes <cfinput type="Radio" name="#studentid#_share_room" value="no">No 
							<cfelse>
								<cfinput type="Radio" name="#studentid#_share_room" value="yes">Yes <cfinput type="Radio" name="#studentid#_share_room" value="no" checked>No
							</cfif></td>
					</tr>
					<tr><td colspan="2">If so, with whom will they share the room?</td>
						<Td><select name="#studentid#_kid_share">
							<option>
							<cfloop query="get_kids">
								<Cfif check_sharing.childid is childid><option value=#childid# selected>#name#<cfelse><option value=#childid#>#name#</cfif>
							</cfloop>
								<cfif check_placed.recordcount gt 0>
									<Cfquery name="check_double" datasource="mysql">
									select doubleplace, double_place_share
									from smg_students
									where studentid = #studentid#
									</Cfquery>
									<cfif check_double.doubleplace neq 0>
									<option value=00 <cfif check_double.double_place_share gt 0>selected</cfif>>Double Place</option>
									</cfif>
								</cfif>
							</select></td>
					</tr>
				</cfloop> <!--- get_students_hosting_if_double --->
				<input type="hidden" name=stulist value=#stulist#></input>
			</cfif> <!--- check_placed.recordcount --->
			<!--- RELIGIOUS --->
			<tr bgcolor="e2efc7">
				<td colspan="2" bgcolor="C2D1EF">Does the Family attend church?</td>
				<td bgcolor="C2D1EF"><cfif #family_info.attendchurch# is 'yes'><input type=radio name="attend_church" value="yes" checked>Yes <input type="radio" name="attend_church" value="no" >No<cfelse><input type=radio name="attend_church" value="yes">Yes <input type="radio" name="attend_church" value="no" checked>No</cfif></td>
			</tr>
			<tr bgcolor="e2efc7">
				<td colspan="2" bgcolor="C2D1EF">To what extend do they attend church?</td>
				<td bgcolor="C2D1EF"><select name="religious_participation">
						<cfif #get_host_religion.religious_participation# is "active"><option value=active selected>Active (2+ times a week)</option><cfelse><option value=active>Active (2+ times a week)</option></cfif>
						<cfif #get_host_religion.religious_participation# is "average"><option value=average selected>Average (1-2x a week)</option><cfelse><option value=average>Average (1-2x a week)</option></cfif>
						<cfif #get_host_religion.religious_participation# is "little interest"><option value="little interest" selected>Little Interest (occasionally)</option><cfelse><option value="little interest">Little Interest (occasionally)</option></cfif>
						<cfif #get_host_religion.religious_participation# is "inactive"><option value=inactive selected>Inactive (never attend)</option><cfelse><option value=inactive>Inactive (never attend)</option></cfif>
						<cfif #get_host_religion.religious_participation# is "no interest"><option value="no interest" selected>No Interest</option><cfelse><option value="no interest">No Interest</option></cfif>
			  </select></td> 
			</tr>			
			<tr bgcolor="e2efc7">
				<td colspan="2" bgcolor="C2D1EF">Students choice to attend with host family?</td>
				<td bgcolor="C2D1EF"><cfif #family_info.churchfam# is 'yes'><cfinput type=radio name="churchfam" value="yes" checked>Yes <cfinput type=radio name="churchfam" value="no">No<cfelse><cfinput type=radio name="churchfam" value="yes">Yes <cfinput type=radio name="churchfam" value="no" checked>No</cfif></td></tr>
			<!----
			<tr bgcolor="e2efc7">
				<td colspan="2">Will family transport to Student's church?</td>
				<td><cfif #family_info.churchtrans# is 'yes'><cfinput type=radio name="churchtrans" value="yes" checked>Yes <cfinput type=radio name="churchtrans" value="no">No<cfelse><cfinput type=radio name="churchtrans" value="yes">Yes <cfinput type=radio name="churchtrans" value="no" checked>No</cfif></td></tr>
			<Tr bgcolor="e2efc7">
				<td align="left" colspan="2">Would you be willing to host a student who smokes?</td>
				<td><cfif #family_info.acceptsmoking# is 'yes'><cfinput type="radio" name=stu_smoke value="yes" checked>Yes <cfinput type="radio" name=stu_smoke value="no">No<cfelse><cfinput type="radio" name=stu_smoke value="yes">Yes <cfinput type="radio" name=stu_smoke value="no" checked>No</cfif></td></tr>
			<Tr bgcolor="e2efc7">
				<td align="left" colspan="3">Under what conditions?<br><textarea cols="50" rows="4" name="smoke_conditions" wrap="VIRTUAL">#family_info.smokeconditions#</textarea></td></tr>
---->
			<!--- PETS --->
			<tr><td colspan="4">Please list any pets that you have:</td></tr>
			<tr><Td align="center" width="15%">Type of animal</td><td align="Center" width="30%">Indoor, Outdoor, or Both</td><td>Number</td></tr>
			<Cfif get_pets.recordcount is 0> <!--- new pets --->
				<cfloop from="1" to="5" index="i">
				<tr>
					<Td><cfinput type="text" name="animal#i#" size=10></td>
					<td align="center"><cfinput type="radio" name="indoor#i#" value="indoor"> Indoor 
						<cfinput type="radio" name="indoor#i#" value="outdoor"> Outdoor <cfinput type="radio" name="indoor#i#" value="both">Both</td>
					<td><select name="number_pets#i#"><option selected>
						<cfloop from="1" to="10" index="x">
						<option value="#x#">#x#
						</cfloop>
						<option value=11>10+
						</select></td>
				</tr>
				</cfloop>
			<cfelse> <!--- get_pets.recordcount --->
			<input type="hidden" name="pets_exist">
				<cfloop query="get_pets">
				<tr>
					<Td><input type="hidden" name="animal#get_pets.currentrow#" value=#animalid#><cfinput type="text" name="animaltype#get_pets.currentrow#" size=10 value="#animaltype#"></td>
					<td><Cfif #indoor# is 'indoor'><cfinput type="radio" name="indoor#get_pets.currentrow#" value="indoor" checked> Indoor <cfinput type="radio" name="indoor#get_pets.currentrow#" value="outdoor"> Outdoor <cfinput type="radio" name="indoor#get_pets.currentrow#" value="both">Both
						<cfelseif #indoor# is 'outdoor'><cfinput type="radio" name="indoor#get_pets.currentrow#" value="indoor"> Indoor <cfinput type="radio" name="indoor#get_pets.currentrow#" value="outdoor" checked> Outdoor <cfinput type="radio" name="indoor#get_pets.currentrow#" value="both">Both
						<cfelseif #indoor# is 'both'><cfinput type="radio" name="indoor#get_pets.currentrow#" value="indoor"> Indoor <cfinput type="radio" name="indoor#get_pets.currentrow#" value="outdoor"> Outdoor <cfinput type="radio" name="indoor#get_pets.currentrow#" value="both" checked>Both
						<cfelse><cfinput type="radio" name="indoor#get_pets.currentrow#" value="indoor"> Indoor <cfinput type="radio" name="indoor#get_pets.currentrow#" value="outdoor"> Outdoor <cfinput type="radio" name="indoor#get_pets.currentrow#" value="both">Both</cfif></td>
					<td><select name="number_pets#get_pets.currentrow#"><option>		
						<cfloop from="1" to="10" index="i">
							<cfif #number# is #i#><option value="#i#" selected>#i#<cfelse><option value="#i#">#i#</cfif>
						</cfloop>
							<cfif #number# is 11><option value=11 selected>10+<cfelse><option value=11>10+</cfif>
						</select>
						&nbsp; &nbsp; &nbsp;
						<a href="?curdoc=querys/delete_host_pet&hostID=#CLIENT.hostID#&petid=#animalID#" onClick="return areYouSurePet(this);"><img src="pics/deletex.gif" border="0" align="middle"></img></a>
					</td>
					<td align="left"></td>
				</tr>
				</cfloop> <!--- get_pets --->
			</Cfif> <!--- get_pets.recordcount --->
		</table>
	</td>
	<td width="20%" align="right" valign="top" class="box">
		<table border=0 cellpadding=3 cellspacing=0 align="right">
			<tr><td align="right"><cfinclude template="../family_pis_menu.cfm"></td></tr>
		</table> 		
	</td>		
</tr>
</table>			

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr><td align="center"><input name="Submit" type="image" src="pics/next.gif" align="middle" border=0 alt="next"></td></tr>
</table>


</cfoutput>
</cfform>