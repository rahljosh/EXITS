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

<cfquery name="get_host_religion" datasource="MySql">
	SELECT
    	religion,
        religious_participation
  	FROM
    	smg_hosts
   	WHERE
    	hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.hostID#">
</cfquery>

<cfquery name="get_pets" datasource="MySql">
	SELECT
    	*
  	FROM
    	smg_host_animals
   	WHERE
    	hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.hostID#">
</cfquery>

<cfquery name="check_placed" datasource="MySql">
	SELECT
    	studentID
   	FROM
    	smg_students
  	WHERE
    	hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.hostID#">
  	AND
    	active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
</cfquery>

<cfquery name="get_kids" datasource="MySql">
	SELECT
    	childID,
        name,
        shared
  	FROM
    	smg_host_children
  	WHERE
    	hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.hostID#">
</cfquery>

<cfinclude template="../querys/family_info.cfm">

<cfform action="querys/insert_pis_3.cfm" method="post">
	<cfoutput>
		<h2>
        	&nbsp;&nbsp;&nbsp;&nbsp;R o o m,  &nbsp;&nbsp;&nbsp; S m o k i n g  &nbsp;&nbsp;&nbsp;  &&nbsp;&nbsp;&nbsp; p e t s  
        	<font size=-2>[ <a href="?curdoc=host_fam_info&hostid=#CLIENT.hostID#">overview</a> ]</font>
     	</h2>

		<table width="90%" border=1 align="center" cellpadding=8 cellspacing=8 bordercolor="##C7CFDC" bgcolor="##FFFFFF" class="section">
			<tr>
            	<td width="80%" class="box">
					<table border=0 cellpadding=4 cellspacing=0 align="left">
						<tr>
                        	<td colspan="3">
                                <div class="get_Attention">
                                    <cfif get_kids.recordcount is 0>
                                        Since you don't have any kids or other family memebers living at home, it is assumend the student will not be sharing a room.  If this is wrong, 
                                        you will need to go to <a href="index.cfm?curdoc=forms/host_fam_pis_2&add=1">add a family member</a>
                                    <cfelse>
                                        The student may share a bedroom with one of the same sex and within a reasonable age difference, but must have his/her own bed.
                                    </cfif>
                                </div>
							</td>
                     	</tr>
						<cfif check_placed.recordcount is 0> <!--- check placed --->
                            <cfquery name="check_share" datasource="MySql">
                                SELECT
                                    shared
                                FROM
                                    smg_host_children
                                WHERE
                                    hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.hostID#">
                                AND
                                    shared = <cfqueryparam cfsqltype="cf_sql_varchar" value="yes">
                            </cfquery>
                            <tr>
                            	<td colspan="2">Will the student share a bedroom?</Td>
								<td>
                                    <input type="Radio" name="share_room" value="yes" <cfif check_share.recordcount GT 0>checked='checked'</cfif>>Yes 
                                    <input type="Radio" name="share_room" value="no" <cfif check_share.recordcount EQ 0>checked='checked'</cfif>>No
                              	</td>
							</tr>
							<tr>
                            	<td colspan="2">If so, with whom will they share the room?</td>
								<td>
                                	<select name="kid_share">
                                    	<option></option>
										<cfloop query="get_kids">
											<option value=#childid# <cfif shared is 'yes'>selected</cfif>>#name#</option>
										</cfloop>
									</select>
								</td>
							</tr>
						<cfelse><!--- check_placed.recordcount --->
                            <cfquery name="get_students_hosting_if_double" datasource="MySql">
                            	SELECT
                                	studentID,
                                    firstName,
                                    familyLastName
                              	FROM
                                	smg_students
                               	WHERE
                                	hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.hostID#">
                              	AND
                                	active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                            </cfquery>
                            <cfset stulist =''>
							<cfloop query="get_students_hosting_if_double">
								<cfset stulist = ListAppend(stulist, #studentid#)>
                                <tr>
                                    <td colspan="2">Will #firstname# #familylastname# share a bedroom? <input type="hidden" name="#studentid#_studentidsharing" value='#studentid#'></td>
                                    <td>
                                        <!----Check if sharing with a host child---->
                                        <cfquery name="check_sharing" datasource="MySql">
                                            SELECT
                                                shared,
                                                roomsharewith,
                                                childID
                                            FROM
                                                smg_host_children
                                            WHERE
                                                roomsharewith = <cfqueryparam cfsqltype="cf_sql_integer" value="#studentID#">
                                        </cfquery>
                                        <!----Check if sharing with a double placement---->
                                        <cfquery name="check_share_double" datasource="MySql">
                                            SELECT
                                                double_place_share
                                            FROM
                                                smg_students
                                            WHERE
                                                studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#studentID#">
                                        </cfquery>
                                        <cfif check_share_double.double_place_share neq 0 or check_sharing.recordcount neq 0>
                                            <input name="#studentid#_share_room" type="radio" value="yes" checked='checked'>Yes 
                                            <input type="Radio" name="#studentid#_share_room" value="no">No 
                                        <cfelse>
                                            <input type="Radio" name="#studentid#_share_room" value="yes">Yes 
                                            <input type="Radio" name="#studentid#_share_room" value="no" checked='checked'>No
                                        </cfif>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">If so, with whom will they share the room?</td>
                                    <td>
                                        <select name="#studentid#_kid_share">
                                            <option></option>
                                            <cfloop query="get_kids">
                                                <cfif check_sharing.childid is childid>
                                                    <option value=#childid# selected>#name#</option>
                                                <cfelse>
                                                    <option value=#childid#>#name#</option>
                                                </cfif>
                                            </cfloop>
                                            <cfif check_placed.recordcount gt 0>
                                                <cfquery name="check_double" datasource="MySql">
                                                    SELECT
                                                        doubleplace,
                                                        double_place_share
                                                    FROM
                                                        smg_students
                                                    WHERE
                                                        studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#studentID#">
                                                </cfquery>
                                                <cfif check_double.doubleplace neq 0>
                                                    <option value=00 <cfif check_double.double_place_share gt 0>selected</cfif>>Double Place</option>
                                                </cfif>
                                            </cfif>
                                        </select>
                                    </td>
                                </tr>
							</cfloop> <!--- get_students_hosting_if_double --->
							<input type="hidden" name=stulist value=#stulist# />
                       	</cfif> <!--- check_placed.recordcount --->
						<!--- RELIGIOUS --->
						<tr bgcolor="e2efc7">
							<td colspan="2" bgcolor="C2D1EF">Does the Family attend church?</td>
                            <td bgcolor="C2D1EF">
                                <input type=radio name="attend_church" value="yes" <cfif #family_info.attendchurch# IS 'yes'>checked='checked'</cfif>>Yes 
                                <input type="radio" name="attend_church" value="no" <cfif #family_info.attendchurch# IS NOT 'yes'>checked='checked'</cfif>>No 
                            </td>
						</tr>
						<tr bgcolor="e2efc7">
							<td colspan="2" bgcolor="C2D1EF">To what extend do they attend church?</td>
							<td bgcolor="C2D1EF">
                            	<select name="religious_participation">
									<option value='active' <cfif #get_host_religion.religious_participation# is "active">selected='selected'</cfif>>Active (2+ times a week)</option>
									<option value='average' <cfif #get_host_religion.religious_participation# is "average">selected='selected'</cfif>>Average (1-2x a week)</option>
									<option value="little interest" <cfif #get_host_religion.religious_participation# is "little interest">selected='selected'</cfif>>Little Interest (occasionally)</option>
									<option value=inactive <cfif #get_host_religion.religious_participation# is "inactive">selected='selected'</cfif>>Inactive (never attend)</option>
                                    <option value="no interest" <cfif #get_host_religion.religious_participation# is "no interest">selected='selected'</cfif>>No Interest</option>
                             	</select>
                         	</td> 
						</tr>			
						<tr bgcolor="e2efc7">
							<td colspan="2" bgcolor="C2D1EF">Students choice to attend with host family?</td>
							<td bgcolor="C2D1EF">
								<cfif #family_info.churchfam# is 'yes'>
                                	<cfinput type=radio name="churchfam" value="yes" checked>Yes 
                                    <cfinput type=radio name="churchfam" value="no">No 
								<cfelse>
                                	<cfinput type=radio name="churchfam" value="yes">Yes 
                                    <cfinput type=radio name="churchfam" value="no" checked>No
								</cfif>
                          	</td>
                      	</tr>
          				<tr bgcolor="e2efc7">
                            <td align="left" colspan="2" bgcolor="C2D1EF">Would you be willing to host a student who smokes?</td>
                            <td bgcolor="C2D1EF">
                                <input type="radio" name=stu_smoke value="yes" <cfif #family_info.acceptsmoking# IS 'yes'>checked='checked'</cfif>>Yes 
                                <input type="radio" name=stu_smoke value="no" <cfif #family_info.acceptsmoking# IS NOT 'yes'>checked='checked'</cfif>>No
                        	</td>
                    	</tr>
						<!--- PETS --->
						<tr>
                        	<td colspan="4">Please list any pets that you have:</td>
                     	</tr>
						<tr>
                        	<td align="center" width="15%">Type of animal</td>
                            <td align="Center" width="30%">Indoor, Outdoor, or Both</td>
                            <td>Number</td>
                     	</tr>
						<cfif get_pets.recordcount is 0> <!--- new pets --->
							<cfloop from="1" to="5" index="i">
								<tr>
									<td><cfinput type="text" name="animal#i#" size=10></td>
									<td align="center">
                                    	<cfinput type="radio" name="indoor#i#" value="indoor"> Indoor 
										<cfinput type="radio" name="indoor#i#" value="outdoor"> Outdoor 
                                        <cfinput type="radio" name="indoor#i#" value="both"> Both 
                                 	</td>
									<td>
                                    	<select name="number_pets#i#">
                                        	<option selected='selected'></option>
											<cfloop from="1" to="10" index="x">
												<option value="#x#">#x#</option>
											</cfloop>
											<option value=11>10+</option>
										</select>
                                 	</td>
								</tr>
							</cfloop>
						<cfelse> <!--- get_pets.recordcount --->
							<input type="hidden" name="pets_exist" />
							<cfloop query="get_pets">
								<tr>
									<td>
                                    	<input type="hidden" name="animal#get_pets.currentrow#" value='#animalid#' />
                                        <cfinput type="text" name="animaltype#get_pets.currentrow#" size=10 value="#animaltype#">
                                 	</td>
									<td>
                                        <input type="radio" name="indoor#get_pets.currentrow#" value="indoor" <cfif #indoor# is 'indoor'>checked='checked'</cfif>> Indoor 
                                        <input type="radio" name="indoor#get_pets.currentrow#" value="outdoor" <cfif #indoor# is 'outdoor'>checked='checked'</cfif>> Outdoor 
                                        <input type="radio" name="indoor#get_pets.currentrow#" value="both" <cfif #indoor# is 'both'>checked='checked'</cfif>> Both 
                                 	</td>
									<td>
                                    	<select name="number_pets#get_pets.currentrow#">
                                        	<option></option>		
											<cfloop from="1" to="10" index="i">
                                       			<option value="#i#" <cfif #number# is #i#>selected='selected'</cfif>>#i#</option>
											</cfloop>
											<option value=11 <cfif #number# is 11>selected='selected'</cfif>>10+</option>
										</select>
										&nbsp; &nbsp; &nbsp;
										<a href="?curdoc=querys/delete_host_pet&hostID=#CLIENT.hostID#&petid=#animalID#" onClick="return areYouSurePet(this);">
                                        	<img src="pics/deletex.gif" border="0" align="middle" />
                                      	</a>
									</td>
									<td align="left"></td>
								</tr>
							</cfloop> <!--- get_pets --->
						</cfif> <!--- get_pets.recordcount --->
					</table>
				</td>
				<td width="20%" align="right" valign="top" class="box">
					<table border=0 cellpadding=3 cellspacing=0 align="right">
						<tr>
                        	<td align="right">
                            	<cfinclude template="../family_pis_menu.cfm">
                           	</td>
                      	</tr>
					</table> 		
				</td>		
			</tr>
		</table>
		<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
			<tr>
            	<td align="center">
                	<input name="Submit" type="image" src="pics/next.gif" align="middle" border=0 alt="next" />
              	</td>
          	</tr>
		</table>
	</cfoutput>
</cfform>