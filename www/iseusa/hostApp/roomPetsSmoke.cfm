
<Cfif isDefined('form.process')>
<CFIF not isdefined("form.share_room")>
	<CFSET form.share_room = "no">
</cfif>
<cftransaction action="BEGIN" isolation="SERIALIZABLE">
<!----share room---->
<cfif #form.share_room# is "yes">
<cfquery name="insert_room_share" datasource="MySQL">
update smg_host_children
 set shared = "yes"
 where childid = #form.kid_share#
</cfquery>
</cfif>
<!----Smoking & Allergy Preferences---->
<cfquery name="smoking_pref" datasource="MySQL">
update smg_hosts
	set smokes = '#form.smokes#',
		acceptsmoking = '#form.stu_smoke#',
		smokeconditions = '#form.smoke_conditions#',
		pet_allergies = '#form.allergic#',
        famDietRest = '#form.famDietRest#',
        famDietRestDesc = '#form.famDietRestDesc#',
        stuDietRest = '#form.stuDietRest#',
        stuDietRestDesc = '#form.stuDietRestDesc#',
        threesquares = '#form.threesquares#'
        
	where hostid = #client.hostid#
</cfquery>


<!----Add animals to db---->
<cfif isDefined('form.pets_exist')>
	<cfif isdefined('form.animal1')>
	<cfquery name="update_pets" datasource="MySQL">
	Update smg_host_animals
		set animaltype = "#form.animaltype1#",
			indoor = "#form.indoor1#",
			number = "#form.number_pets1#"
		where animalid = #form.animal1#
	</cfquery>
	<cfelse>
	</cfif>
	<cfif isdefined('form.animal2')>
	<cfquery name="update_pets" datasource="MySQL">
	Update smg_host_animals
		set animaltype = "#form.animaltype2#",
			indoor = "#form.indoor2#",
			number = "#form.number_pets2#"
		where animalid = #form.animal2#
	</cfquery>
	<cfelse>
	</cfif>
	<cfif isdefined('form.animal3')>
	<cfquery name="update_pets" datasource="MySQL">
	Update smg_host_animals
		set animaltype = "#form.animaltype3#",
			indoor = "#form.indoor3#",
			number = "#form.number_pets3#"
		where animalid = #form.animal3#
	</cfquery>
	<cfelse>
	</cfif>
	<cfif isdefined('form.animal4')>
	<cfquery name="update_pets" datasource="MySQL">
	Update smg_host_animals
		set animaltype = "#form.animaltype4#",
			indoor = "#form.indoor4#",
			number = "#form.number_pets4#"
		where animalid = #form.animal4#
	</cfquery>
	<cfelse>
	</cfif>
	<cfif isdefined('form.animal5')>
	<cfquery name="update_pets" datasource="MySQL">
	Update smg_host_animals
		set animaltype = "#form.animaltype5#",
			indoor = "#form.indoor5#",
			number = "#form.number_pets5#"
		where animalid = #form.animal5#
	</cfquery>
	<cfelse>
	</cfif>
<cfelse>
	<cfif #form.animal1# is not ''>
	<cfquery name="add_animal" datasource="MySQL">
	insert into smg_host_animals (hostid, animaltype, number, indoor)
				values(#client.hostid#, "#form.animal1#", #form.number_pets#, "#form.indoor#")
	</cfquery>
	</cfif>
	<cfif #form.animal2# is not ''>
	<cfquery name="add_animal" datasource="MySQL">
	insert into smg_host_animals (hostid, animaltype, number, indoor)
				values(#client.hostid#, "#form.animal2#", #form.number_pets2#, "#form.indoor2#")
	</cfquery>
	</cfif>
	<cfif #form.animal3# is not ''>
	<cfquery name="add_animal3" datasource="MySQL">
	insert into smg_host_animals (hostid, animaltype, number, indoor)
				values(#client.hostid#, "#form.animal3#", #form.number_pets3#, "#form.indoor3#")
	</cfquery>
	</cfif><br>
	<cfif #form.animal4# is not ''>
	<cfquery name="add_animal4" datasource="MySQL">
	insert into smg_host_animals (hostid, animaltype, number, indoor)
				values(#client.hostid#, "#form.animal4#", #form.number_pets4#, "#form.indoor4#")
	</cfquery>
	</cfif>
	<cfif #form.animal5# is not ''>
	<cfquery name="add_animal5" datasource="MySQL">
	insert into smg_host_animals (hostid, animaltype, number, indoor)
				values(#client.hostid#, "#form.animal5#", #form.number_pets5#, "#form.indoor5#")
	</cfquery>
	</cfif>
</cfif>
</cftransaction>
<cflocation url="index.cfm?page=religionPref" addtoken="no">
</Cfif>
<!----script to hide kids names if they are not going to share a room---->

<cfquery name="get_pets" datasource="MySQL">
select *
from smg_host_animals 
where hostid = #client.hostid#
</cfquery>

<cfquery name="get_kids" datasource="MySQL">
select childid, name, shared
from smg_host_children
where hostid = #client.hostid#
</cfquery>
<cfquery name="family_info" datasource="mysql">
select *
from smg_hosts
where hostid = #client.hostid#
</cfquery>
<h2>Hosting Environment</h2>

<cfform action="index.cfm?page=roomPetsSmoke" method="post">
<div class="row">


<h3>Room Sharring</h3>
<div class="get_Attention">The student may share a bedroom with one of the same sex and within a reasonable age difference, but must have his/her own bed.<sup>&dagger;</sup></div>
<table width=100% cellspacing=0 cellpadding=2 class="border">
<cfif get_kids.recordcount is 0>
	<Tr>
    	<td colspan=4 bgcolor="#deeaf3">
<div class="get_Attention">Since you don't have any kids or other family memebers living at home, it is assumend the student will not be sharing a room.  If this is wrong, 
you will need to <a href="index.cfm?page=familyMembers">add a family member</a>.
</div>
		</td>
     </Tr>
<cfelse>

	<tr bgcolor="#deeaf3">
		<td id="shareBedroom" width=50%>Will the student share a bedroom?</td>
        <td>
        <cfquery name="whoShare" dbtype="query">
        select *
        from get_kids
        where shared = 'yes'
        </cfquery>
        <cfif whoShare.recordcount eq 'no'>
        	<cfset roomShare=0>
        <cfelse>
        	<cfset roomShare=1>
        </cfif>
    		 <label>
            <cfinput type="radio" name="share_room" value="1"
            onclick="document.getElementById('showname').style.display='table-row';" required="yes" message="Please answer: Will the student share a bedroom?" checked="#roomShare eq 1#" />
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" 
            name="share_room" 
            value="0"
            onclick="document.getElementById('showname').style.display='none';" 			required="yes" 
            message="Please answer: Will the student share a bedroom?" 
            checked="#roomShare eq 0#" />

            No
            </label>
      	
        </td>
	</tr>

	<tr id="showname" <cfif roomShare eq 0>style="display: none;"</cfif>  >
		<td width=50%> Who will they share a room with?</td><Td>
          
         <select name="kid_share">
			<option>
			<cfoutput query="get_kids">
			<Cfif get_kids.shared is 'yes'><option value=#childid# selected>#name#<cfelse><option value=#childid#>#name#</cfif>
			</cfoutput>
		</select>
       
		</td>
	</tr>
</cfif>
</table>



<h3>Smoking</h3>
<table width=100% cellspacing=0 cellpadding=2 class="border" border=0>
	<Tr>
		<td align="left" width=50%>Does anyone in your family smoke?</td><td>
            <label>
            <cfinput type="radio" name="smokes" value="1"
            checked="#family_info.smokes eq 1#" required="yes" message="Please answer: Does anyone in your family smoke?" />
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="smokes" value="0"
           checked="#family_info.smokes eq 0#" required="yes" message="Please answer: Does anyone in your family smoke?" />
            No
            </label>
		 
 </td>
	</tr>
		<Tr bgcolor="#deeaf3">
		<td align="left">Would you be willing to host a student who smokes?</td><td>
		        <label>
            <cfinput type="radio" name="stu_smoke" value="1"
            onclick="document.getElementById('showsmoke').style.display='table-row';" checked="#family_info.acceptsmoking eq 0#" required="yes" message="Please answer: Would you be willing to host a student who smokes?" />
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="stu_smoke" value="0"
            onclick="document.getElementById('showsmoke').style.display='none';" checked="#family_info.acceptsmoking eq 0#" required="yes" message="Please answer: Would you be willing to host a student who smokes?" />
            No
            </label>
		
</td>
	</tr>
		<Tr>
		<td align="left" colspan="2" id="showsmoke" style="display: none;">Under what conditions?<br><textarea cols="50" rows="4" name="smoke_conditions" wrap="VIRTUAL"><Cfoutput>#family_info.smokeconditions#</cfoutput></textarea></td>
	</tr>
</table>
<span cless="spacer"></span>
<h3>Pets</h3>
Do you have any pets? 
Please list any pets that you have:
<Cfif get_pets.recordcount is 0>

<table width=100% cellspacing=0 cellpadding=2 class="border">
	<tr>
		<Th>What type of animal?</th><th >Where do they live?</th><th>How many?</th>
	</tr>
	<tr bgcolor="#deeaf3">
		<Td><cfinput type="text" name="animal1" size=15></td><td><cfinput type="radio" name=indoor value="indoor"> Indoor 
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
		<Td><cfinput type="text" name="animal2" size=15></td><td><cfinput type="radio" name=indoor2 value="indoor"> Indoor 
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
		<tr bgcolor="#deeaf3">
		<Td><cfinput type="text" name="animal3" size=15></td><td><cfinput type="radio" name=indoor3 value="indoor"> Indoor 
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
		<Td><cfinput type="text" name="animal4" size=15></td><td><cfinput type="radio" name=indoor4 value="indoor"> Indoor 
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
		<tr bgcolor="#deeaf3">
		<Td><cfinput type="text" name="animal5" size=15></td><td><cfinput type="radio" name=indoor5 value="indoor"> Indoor 
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

<table width=100% cellspacing=0 cellpadding=2 class="border">
	<tr>
		<Td>Type of animal</td><td>Indoor, Outdoor, or Both</td><td>Number</td>
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
 <h3>Dietary Needs</h3>
<table width=100% cellspacing=0 cellpadding=2 class="border">
	<Tr bgcolor="#deeaf3">
    	<Td>
		Does anyone in your family follow any dietary restrictions?
	</Td>
    <td>
   <label>
            <cfinput type="radio" name="famDietRest" value="1" onclick="document.getElementById('famDietRestDesc').style.display='table-row';"
             checked="#family_info.famDietRest eq 0#" required="yes" message="Please answer: Does anyone in your family follow any dietary restrictions?" />
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="famDietRest" value="0"  onclick="document.getElementById('famDietRestDesc').style.display='none';"
             checked="#family_info.famDietRest eq 0#" required="yes" message="Please answer: Does anyone in your family follow any dietary restrictions?" />
            No
            </label>
     </td>
     </Tr>
     <Tr id="famDietRestDesc"  style="display: none;" bgcolor="#deeaf3">
     	<td>Please describe</td>
        <td><textarea cols=30 rows=5 name="famDietRestDesc"><Cfoutput>#family_info.famDietRestDesc#</Cfoutput></textarea></td>
     </Tr>
     <Tr>
    	<Td>
			Do you expect the student to follow any dietary restrictions?
		</Td>
        <td>
   		<label>
            <cfinput type="radio" name="stuDietRest" value="1" onclick="document.getElementById('stuDietRestDesc').style.display='table-row';"
             checked="#family_info.famDietRest eq 0#" required="yes" message="Please answer: Does anyone in your family follow any dietary restrictions?" />
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="stuDietRest" value="0" onclick="document.getElementById('stuDietRestDesc').style.display='none';"
             checked="#family_info.famDietRest eq 0#" required="yes" message="Please answer: Does anyone in your family follow any dietary restrictions?" />
            No
        </label>
     	</td>
     </Tr>
      <Tr id="stuDietRestDesc"  style="display: none;">
     	<td>Please describe</td>
        <td><textarea cols=30 rows=5 name="stuDietRestDesc"><cfoutput>#family_info.stuDietRestDesc#</cfoutput></textarea></td>
     </Tr>
     <Tr  bgcolor="#deeaf3">
    	<Td>
			Are you prepared to provide three (3) quality meals per day?<br /> (students are expected to provide and/or pay for school lunches)
		</Td>
        <td>
   		<label>
            <cfinput type="radio" name="threesquares" value="1" 
             checked="#family_info.threesquares eq 1#" required="yes" message="Please answer: Are you prepared to provide three (3) quality meals per day?" />
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="threesquares" value="0" 
             checked="#family_info.threesquares eq 0#" required="yes" message="Please answer: Are you prepared to provide three (3) quality meals per day?" />
            No
        </label>
     	</td>
     </Tr>
 </table>

<h3>Allergies</h3>
<table width=100% cellspacing=0 cellpadding=2 class="border">
	<Tr bgcolor="#deeaf3">
    	<Td>
Would you be willing to host a student who is allergic to animals?<Br /> (If they are able to handle the allergy with medication)
		</Td>
        <Td>

   <label>
            <cfinput type="radio" name="allergic" value="1"
             checked="#family_info.pet_allergies eq 1#" required="yes" message="Please answer: Would you be willing to host a student who is allergic to animals?" />
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="allergic" value="0"
             checked="#family_info.pet_allergies eq 0#" required="yes" message="Please answer: Would you be willing to host a student who is allergic to animals?" />
            No
            </label>
     </Tr>
 </table>

 <table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
    <tr>
       
        <td align="right">
        <input type="hidden" name="process">
        <input name="Submit" type="image" src="../images/buttons/Next.png" border=0></td>
    </tr>
</table>
<span class="spacer"></span>
</div>
<h3><u>Department Of State Regulations</u></h3>
<p>&dagger;<strong><a href="http://ecfr.gpoaccess.gov/cgi/t/text/text-idx?c=ecfr&sid=bfef5f6152d538eed70ad639c221a216&rgn=div8&view=text&node=22:1.0.1.7.37.2.1.6&idno=22" target="_blank" class=external>CFR Title 22, Part 62, Subpart B, &sect;62.25 (j)(4)</a></strong><br />
       <em>Ensure that the host family is capable of providing a comfortable and nurturing home environment and that the home is clean and sanitary; that the exchange student's bedroom contains a separate bed for the student that is neither convertible nor inflatable in nature; and that the student has adequate storage space for clothes and personal belongings, reasonable access to bathroom facilities, study space if not otherwise available in the house and reasonable, unimpeded access to the outside of the house in the event of a fire or similar emergency. An exchange student may share a bedroom, but with no more than one other individual of the same sex.</em></p>

</cfform>
