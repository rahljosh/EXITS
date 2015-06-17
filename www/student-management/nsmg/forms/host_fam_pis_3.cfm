<cfparam name="URL.hostID" default="0">

<script>

	$(document).ready(function() {
		$("#addPetRowButton").css('cursor','pointer');					   
	});

	function areYouSurePet() { 
		if(confirm("You are about to delete the pet selected. You will not be able to recover this information. Click OK to continue")) { 
			form.submit(); 
			return true; 
	   	} else { 
			return false; 
	   	} 
	}
	
	function addPetRow(currentRow) {
		var numberPets = $("#numberPets").val();
		numberPets++;
		$("#numberPets").val(numberPets);
		var newRow = "<tr><td width='15%'><input type='hidden' name='animalID"+numberPets+"' value='0'>";
		newRow += "<input type='text' name='animal"+numberPets+"' id='animal"+numberPets+"' size='10' onChange='updateNumber("+numberPets+")' /></td>";
		newRow += "<td width='30%'><input type='radio' name='indoor"+numberPets+"' value='indoor'> Indoor </input>";
		newRow += "<input type='radio' name='indoor"+numberPets+"' value='outdoor'> Outdoor </input>";
		newRow += "<input type='radio' name='indoor"+numberPets+"' value='both'> Both </input></td>";
		newRow += "<td><select name='number_pets"+numberPets+"' id='number_pets"+numberPets+"'><option id='zeroOption"+numberPets+"' value='0' selected='selected'></option>";
		for (var x=1; x<11; x++) {
			newRow += "<option value='"+x+"'>"+x+"</option>";	
		}
		newRow += "<option value='11'>10+</option></select></td></tr>";
		$("#petTable").append(newRow);
	}
	
	function updateNumber(i) {
		if($("#animal"+i).val() == '') {
			var html = $("#number_pets"+i).html();
			$("#number_pets"+i).html("<option id='zeroOption"+i+"' value='0' selected='selected'></option>"+html);
		} else {
			$("#zeroOption"+i).remove();
		}
	}
	
	function validateForm() {
		var errors = 0;
		for (var i=1; i<=$("#numberPets").val(); i++) {
			var name = 'indoor' + i;
			if ( $("input[name="+name+"]:checked").length == 0 && $("#animal"+i).val() != "" ) {
				errors++;
			}
		}
		if (errors) {
			 alert("Please choose where the pets are kept.");
		} else {
			$("#mainForm").submit();
		}
	}
	
</script>

<cfquery name="get_host_religion" datasource="#APPLICATION.DSN#">
	SELECT
    	religion, 
        religious_participation
	FROM
    	smg_hosts
    WHERE
        hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.hostid)#">
</cfquery>

<cfquery name="get_pets" datasource="#APPLICATION.DSN#">
	SELECT
    	*
	FROM
    	smg_host_animals 
	WHERE
    	hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.hostid)#">
</cfquery>

<cfquery name="qGetHostChildren" datasource="#APPLICATION.DSN#">
	SELECT
    	childid,
        name,
        shared,
        roomShareWith
	FROM
    	smg_host_children
	WHERE
    	hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.hostid)#">
  	AND
    	isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
</cfquery>

<cfquery name="qGetPlacedStudents" datasource="#APPLICATION.DSN#">
	SELECT
    	studentID,
        firstName,
        familyLastName,
        double_place_share
 	FROM
    	smg_students
  	WHERE
    	hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.hostid)#">
  	AND
    	active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
</cfquery>


<cfinclude template="../querys/family_info.cfm">
<cfform id="mainForm" action="querys/insert_pis_3.cfm" method="post">
<cfoutput>
	<input type="hidden" name="numberPets" id="numberPets" value="#get_pets.recordCount#" />    
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/family.gif"></td>
		<td background="pics/header_background.gif"><h2>Room, Smoking & Pets</h2></td>
		<td align="right" background="pics/header_background.gif"><span class="edit_link">[ <a href="?curdoc=host_fam_info&hostid=#URL.hostID#">overview</a> ]</span></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
	<tr>
    	<td width="80%">
			<table border=0 cellpadding=4 cellspacing=0 align="left">
				<tr>
                	<td colspan="3">
                    	<div class="get_Attention">
                        	<cfif qGetHostChildren.recordcount is 0>
                            	Since you don't have any kids or other family members living at home, it is assumend the student will not be sharing a room.  If this is wrong, you will need to go to 
                    			<a href="index.cfm?curdoc=forms/host_fam_mem_form&hostid=#URL.hostID#&add=1">add a family member</a>
                            <cfelse>
                            	The student may share a bedroom with one of the same sex and within a reasonable age difference, but must have his/her own bed.
                            </cfif>
                        </div>
					</td>
              	</tr>
                
                <cfquery name="check_share" datasource="#APPLICATION.DSN#">
                    SELECT
                        *
                    FROM
                        smg_host_children
                    WHERE
                        hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.hostid)#">
                    AND
                        shared = <cfqueryparam cfsqltype="cf_sql_varchar" value="yes">
                    AND 
                        isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                </cfquery>
                
				<cfif qGetPlacedStudents.recordcount is 0>
                    
                    <tr>
                        <td colspan="2">Will the student share a bedroom?</td>
                        <td>
                            <select name="kid_share" id="kid_share">
                                <option value="0" <cfif NOT VAL(check_share.recordCount)>selected="selected"</cfif>>No</option>
                                <cfloop query="qGetHostChildren">
                                    <option value='#childid#' <cfif shared is 'yes'>selected="selected"</cfif>>Yes, with #name#</option>
                                </cfloop>
                            </select>
                    	</td>
					</tr>
                    
				<cfelse>
                                	
                    <input type="hidden" name="stuListID" value="#ValueList(qGetPlacedStudents.studentid)#">    
                                    
					<cfloop query="qGetPlacedStudents">
						<tr>
                    		<td colspan="2">
                                Will #qGetPlacedStudents.firstname# #qGetPlacedStudents.familylastname# (###qGetPlacedStudents.studentID#) share a bedroom? 
                       		</td>
							<td>
                        		<select name="#qGetPlacedStudents.studentid#_siblingIDSharingRoom" class="xLargeField"> 
                            		<option value='no' <cfif NOT VAL(check_share.recordCount)>selected="selected"</cfif>>No</option>
                                    
                                    <!--- List Host Children --->
                                    <cfloop query="qGetHostChildren">
                                    	<option value="sibling_#childID#" <cfif qGetHostChildren.roomsharewith EQ qGetPlacedStudents.studentid>selected="selected"</cfif>>Yes, with #name#</option> 
                                    </cfloop>
                                    
                                    <cfquery name="qGetDoublePlacement" dbtype="query">
                                    	SELECT 
                                        	*
                                        FROM
                                    		qGetPlacedStudents
                                        WHERE
                                        	studentID != <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetPlacedStudents.studentID)#">
                                    </cfquery>
                                    
                                    <!--- List Host Students - Double Placements --->
                                    <cfloop query="qGetDoublePlacement">
                                        <option value="student_#qGetDoublePlacement.studentID#" <cfif qGetPlacedStudents.double_place_share EQ qGetDoublePlacement.studentID>selected="selected"</cfif>>Yes, with student #qGetDoublePlacement.firstName# #qGetDoublePlacement.familyLastName#</option>
                                    </cfloop>
                                
								</select>
                      	</td>
					</tr>
				</cfloop> <!--- qGetPlacedStudents --->
				
			</cfif> <!--- qGetPlacedStudents.recordcount --->
			<!--- RELIGIOUS --->
			<tr bgcolor="e2efc7">
				<td colspan="2">Does the Family attend church?</td>
				<td><cfif #family_info.attendchurch# is 'yes'><input type=radio name="attend_church" value="yes" checked>Yes <input type="radio" name="attend_church" value="no" >No<cfelse><input type=radio name="attend_church" value="yes">Yes <input type="radio" name="attend_church" value="no" checked>No</cfif></td>
			</tr>
			<tr bgcolor="e2efc7">
				<td colspan="2">To what extent do they attend church?</td>
				<td><select name="religious_participation">
						<cfif #get_host_religion.religious_participation# is "active" or #get_host_religion.religious_participation# is "4"  ><option value=active selected>Active (2+ times a week)</option><cfelse><option value=active>Active (2+ times a week)</option></cfif>
						<cfif #get_host_religion.religious_participation# is "average" or #get_host_religion.religious_participation# is "3"><option value=average selected>Average (1-2x a week)</option><cfelse><option value=average>Average (1-2x a week)</option></cfif>
						<cfif #get_host_religion.religious_participation# is "little interest" or #get_host_religion.religious_participation# is "2"><option value="little interest" selected>Little Interest (occasionally)</option><cfelse><option value="little interest">Little Interest (occasionally)</option></cfif>
						<cfif #get_host_religion.religious_participation# is "inactive" or #get_host_religion.religious_participation# is "1"><option value=inactive selected>Inactive (never attend)</option><cfelse><option value=inactive>Inactive (never attend)</option></cfif>
						<cfif #get_host_religion.religious_participation# is "no interest" or #get_host_religion.religious_participation# is "0"><option value="no interest" selected>No Interest</option><cfelse><option value="no interest">No Interest</option></cfif>
						</select></td> 
			</tr>			
			<tr bgcolor="e2efc7">
				<td colspan="2">Students choice to attend with host family?</td>
				<td><cfif #family_info.churchfam# is 'yes'><cfinput type=radio name="churchfam" value="yes" checked>Yes <cfinput type=radio name="churchfam" value="no">No<cfelse><cfinput type=radio name="churchfam" value="yes">Yes <cfinput type=radio name="churchfam" value="no" checked>No</cfif></td></tr>
			<tr bgcolor="e2efc7">
				<td colspan="2">Will family transport to Student's church?</td>
				<td><cfif #family_info.churchtrans# is 'yes'><cfinput type=radio name="churchtrans" value="yes" checked>Yes <cfinput type=radio name="churchtrans" value="no">No<cfelse><cfinput type=radio name="churchtrans" value="yes">Yes <cfinput type=radio name="churchtrans" value="no" checked>No</cfif></td></tr>
			<Tr bgcolor="e2efc7">
				<td align="left" colspan="2">Would you be willing to host a student who smokes?</td>
				<td><cfif #family_info.acceptsmoking# is 'yes'><cfinput type="radio" name=stu_smoke value="yes" checked>Yes <cfinput type="radio" name=stu_smoke value="no">No<cfelse><cfinput type="radio" name=stu_smoke value="yes">Yes <cfinput type="radio" name=stu_smoke value="no" checked>No</cfif></td></tr>
			<Tr bgcolor="e2efc7">
				<td align="left" colspan="3">Under what conditions?<br><textarea cols="50" rows="4" name="smoke_conditions" wrap="VIRTUAL">#family_info.smokeconditions#</textarea></td></tr>

			<!--- PETS --->
			<tr>
            	<td colspan="3">Please list any pets that you have:</td>
          	</tr>
			<tr>
            	<td align="center" width="15%">Type of animal</td>
                <td align="Center" width="30%">Indoor, Outdoor, or Both</td>
                <td>Number</td>
          	</tr>
            <tr>
            	<td colspan="3">
                	<table id="petTable" width="100%">
                        <cfloop query="get_pets">
                            <tr>
                                <td width="15%">
                                    <input type="hidden" name="animalID#get_pets.currentrow#" value='#animalid#'>
                                    <input type="text" name="animal#get_pets.currentrow#" size=10 value="#animaltype#">
                                </td>
                                <td width="30%">
                                    <input type="radio" name="indoor#get_pets.currentRow#" value="indoor" <cfif indoor EQ 'indoor'>checked="checked"</cfif> /> Indoor
                                    <input type="radio" name="indoor#get_pets.currentRow#" value="outdoor" <cfif indoor EQ 'outdoor'>checked="checked"</cfif> /> Outdoor
                                    <input type="radio" name="indoor#get_pets.currentRow#" value="both" <cfif indoor EQ 'both'>checked="checked"</cfif> /> Both
                                </td>
                                <td>
                                    <select name="number_pets#get_pets.currentrow#">
                                        <option id="zeroOption#get_pets.currentrow#" value="0"></option>	
                                        <cfloop from="1" to="10" index="i">
                                            <cfif number is i>
                                                <option value="#i#" selected='selected'>#i#</option>
                                            <cfelse>
                                                <option value="#i#">#i#</option>
                                            </cfif>
                                        </cfloop>
                                        <cfif number is 11>
                                            <option value=11 selected='selected'>10+</option>
                                        <cfelse>
                                            <option value=11>10+</option>
                                        </cfif>
                                    </select>
                                    &nbsp; &nbsp; &nbsp;
                                    <a href="?curdoc=querys/delete_host_pet&petid=#animalid#" onClick="return areYouSurePet(this);"><img src="pics/deletex.gif" border="0" align="middle"></img></a>
                                </td>
                            </tr>
                        </cfloop>
                   	</table>
               	</td>
           	</tr>
            <tr>
            	<td></td>
            	<td align="center"><img src="pics/plus.png" id="addPetRowButton" onclick="addPetRow()" /></td>
                <td></td>
            </tr>
		</table>
	</td>
	<td width="20%" align="right" valign="top">
		<table border=0 cellpadding=3 cellspacing=0 align="right">
			<tr><td align="right"><cfinclude template="../family_pis_menu.cfm"></td></tr>
		</table> 		
	</td>		
</tr>
</table>			

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr><td align="center"><img src="pics/next.gif" align="middle" border=0 onclick="validateForm()"></td></tr>
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