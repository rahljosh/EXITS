<!--- Import CustomTag Used for Page Messages and Form Errors --->
<cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

<!--- Process Form Submission --->
<cfparam name="form.smokes" default="">
<cfparam name="form.stu_smoke" default="">
<cfparam name="form.famDietRest" default="3">
<cfparam name="form.stuDietRest" default="3">
<cfparam name="form.threesquares" default="3">
<cfparam name="form.allergic" default="3">
<cfparam name="form.kid_share" default="0">
<cfparam name="url.animalid" default=''>
<cfparam name="url.hostid" default='#client.hostid#'>
<cfparam name="form.indoor" default="na">
<cfparam name="form.animaltype" default=''>

<!----Delete a Pet---->
<Cfif isDefined('url.delete_animal')>
	<cfquery datasource="mysql">
    delete from smg_host_animals
    where animalid = #url.delete_animal#
    </Cfquery>
</Cfif>
<!---Get host information---->
   <cfquery name="qGetHostInfo" datasource="mysql">
        SELECT  
        	*
        FROM 
        	smg_hosts shl
        LEFT JOIN 
        	smg_states on smg_states.state = shl.state
        WHERE 
        	hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.hostID#">
    </cfquery>
<!----Add a pet---->
 <Cfif isDefined('form.addPet')>
  
         <!---Error Checking---->

         <cfscript>
   		 //Animal 1
			if  ( (LEN(TRIM(FORM.animaltype))) AND (FORM.number_pets eq 0) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("You've indicated you have a(n) #form.animaltype# but didn't indicate how many.");
			 }
			if  ( (LEN(TRIM(FORM.animaltype))) AND (FORM.number_pets neq 0) AND form.indoor is 'na'  ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("You've indicated you have #form.number_pets# #form.animaltype#(s) but didn't indicate if they are indoor, outdoor or both.");
			 } 
			if  ( (NOT LEN(TRIM(FORM.animaltype))) AND (FORM.number_pets eq 0) AND form.indoor is 'na'  ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("You have not indicated any details on a pet, please indicate which type of animal you have, where they live, and how many you have.");
			 }	
			 if  ( (NOT LEN(TRIM(FORM.animaltype))) AND (FORM.number_pets neq 0) AND form.indoor is not 'na'  ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("You have not indicated what type of animal you have, only the number and where it lives.");
			 }
    	</cfscript>
    		<cfif NOT SESSION.formErrors.length()>
                 <cfquery name="addPet" datasource="mysql">
                    insert into smg_host_animals (hostid, animaltype,number, indoor)
                            values(#client.hostid#, '#form.animaltype#','#form.number_pets#','#form.indoor#')
                    </Cfquery>
        	</cfif>
  </Cfif>

<Cfif isDefined('form.process')>

        
 
        
       
       
        <!---Error Checking---->

         <cfscript>
            // Data Validation
			//Play in Band
			 if (( FORM.share_room EQ 1) AND (FORM.kid_share EQ 0))  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("You have indicated that the student will share a room, but have not indicated with whom they will share the room.");
			 }
			
			// Family Smokes
             if(NOT LEN(TRIM(FORM.smokes))) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate if any one in your family smokes.");
			 }
			 
			//Student Smokes
            if  (NOT LEN(TRIM(FORM.stu_smoke))) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate if you would be willing to host a student who smokes.");
			 }	
			 //Student smoke conditions
			 if (( FORM.stu_smoke EQ 1) AND NOT LEN(TRIM(FORM.smoke_conditions)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("You have indicated that you would host a student who smokes, but did not indicate under what conditions.");
			}
			
			 // Family Dietary Restrictions
             if ( FORM.famDietRest EQ 3) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate if your family follows any dietary restrictions.");
			 }
			 if (( FORM.famDietRest EQ 1) AND NOT LEN(TRIM(FORM.famDietRestDesc)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("You have indicated that your family has dietary restrictions, but did not describe them.");
			}
			 
			// Student Dietery Restrictions
            if ( FORM.stuDietRest EQ 3) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate if you expect the student to follow any dietary restrictions.");
			 }
			 if (( FORM.stuDietRest EQ 1) AND NOT LEN(TRIM(FORM.stuDietRestDesc)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("You have indicated that you expect the student to follow certain dietary restrictions, but did not describe them.");
			}
			 
			 // Three Squares
             if ( FORM.threesquares EQ 3) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate if you are prepared to provide three (3) quality meals per day.");
			 }
			
			 
			// Allergies
            if ( FORM.allergic EQ 3) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate if you would be willing to host a student who is allergic to animals.");
			 }
		
		
			
		</cfscript>
        <cfif NOT SESSION.formErrors.length()>
       
       
			<CFIF not isdefined("form.share_room")>
                <CFSET form.share_room = "">
            </cfif>
            <cftransaction action="BEGIN" isolation="SERIALIZABLE">
                    <!----share room---->
                    <cfif #form.share_room# is "yes">
                    <!---_THey answerd yes, but didn't indicate a kid... don't update until question is answerd.---->
                        <Cfif form.kid_share neq 0>
                            <cfquery name="insert_room_share" datasource="MySQL">
                            update smg_host_children
                             set shared = "yes"
                             where childid = #form.kid_share#
                            </cfquery>
                        </Cfif>
                    </cfif>
                    <!----Smoking & Allergy Preferences---->
                    <cfquery name="smoking_pref" datasource="MySQL">
                    update smg_hosts
                        set hostSmokes = '#form.smokes#',
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
                    </cftransaction>
			<cflocation url="index.cfm?page=religionPref" addtoken="no">
        
        </cfif>
<cfelse>

		 <cfscript>
			 // Set FORM Values   
			FORM.smokes = qGetHostInfo.hostsmokes;
			// Father --->
			FORM.stu_smoke = qGetHostInfo.acceptsmoking;
			FORM.smoke_conditions = qGetHostInfo.smokeconditions;
			FORM.allergic = qGetHostInfo.pet_allergies;
			FORM.famDietRest = qGetHostInfo.famDietRest;
			FORM.famDietRestDesc = qGetHostInfo.famDietRestDesc;
			FORM.stuDietRest = qGetHostInfo.stuDietRest;
			FORM.stuDietRestDesc = qGetHostInfo.stuDietRestDesc;
			FORM.threesquares = qGetHostInfo.threesquares;
			
		</cfscript>

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
<!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="section"
        />

<div class="row">

<h3>Current Pets</h3>
<cfquery name="qPets" datasource="mysql">
select *
from smg_host_animals
where hostid = #client.hostid#
</cfquery>
<Cfif qPets.recordcount eq 0>
	No pets have been added.
</cfif>
<cfoutput>
<table width=100% cellspacing=0 cellpadding=2 class="border">
   <Tr>
   	<Th>Type</Th><Th>Indoor / Outdoor</Th><th>How many?</th><th></th>
    </Tr>
   <Cfif qPets.recordcount eq 0>
    <tr>
    	<td>Currently, no pets are indicated as living in your home.</td>
    </tr>
    <cfelse>
    <Cfloop query="qPets">
    <tr <Cfif currentrow mod 2> bgcolor="##deeaf3"</cfif>>
    	<Td><h3><p class=p_uppercase>#animaltype#</h3></Td>
        <td><h3><p class=p_uppercase>#indoor#</h3></td>
        <Td><h3>#number#</h3></Td>
        <Td><a href="index.cfm?page=roomPetsSmoke&delete_animal=<cfoutput>#animalid#&hostid=#url.hostid#</cfoutput>" onClick="return confirm('Are you sure you want to delete this pet?')"> DELETE</a></Td>
    </tr>
    </Cfloop>
    </cfif>
   </table>
	
</cfoutput>

<cfform action="index.cfm?page=roomPetsSmoke&animalid=#url.animalid#&hostid=#url.hostid#" method="post" preloader="no">
<input type="hidden" name="addPet" value="1">


<h3>Pets </h3>
Please include all animals that live in or outside your home.<br /><span class="redtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Required fields</span>

<table width=100% cellspacing=0 cellpadding=2 class="border">
    <tr bgcolor="#deeaf3">
    	<td class="label"><h3>Type of Animal<span class="redtext">*</span></h3></td>	
        <td class="label"><h3>Where do they live?<span class="redtext">*</span></h3></td>
        <td class="label"><h3>How Many? <span class="redtext">*</span></h3></td>
    </tr>
    <tr>    
        <td><cfinput type="text" name="animaltype" size=15></td>

    
        <td>
        	<cfinput type="radio" name=indoor value="indoor"> Indoor 
		<cfinput type="radio" name=indoor value="outdoor"> Outdoor <cfinput type="radio" name=indoor value="both">Both
        </td>

    	
        <td><select name="number_pets"><option value=0 selected>
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
			<option value='10+'>10+
			</select>
         </td>
        
    </tr>
   
</table>

	</td>
	</tr>
</table>
 <table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
    <tr>
       
        <td align="right">
       
        <input type="image" src="../images/addPet.png" /></td>
    </tr>
</table>
</cfform>
<br />
	<hr width="50%" align="Center"/>
 <br />
 <cfform action="index.cfm?page=roomPetsSmoke" method="post">
<h3>Room Sharing</h3>
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
		<td id="shareBedroom" width=50%>Will the student share a bedroom?<span class="redtext">*</span></td>
        <td>
        <cfquery name="whoShare" dbtype="query">
        select *
        from get_kids
        where shared = 'yes'
        </cfquery>
        <cfif whoShare.recordcount eq 0>
        	<cfset roomShare=0>
        <cfelse>
        	<cfset roomShare=1>
        </cfif>
    		 <label>
            <cfinput type="radio" name="share_room" value="1"
            onclick="document.getElementById('showname').style.display='table-row';" checked="#roomShare eq 1#" />
           
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" 
            name="share_room" 
            value="0"
            onclick="document.getElementById('showname').style.display='none';" 
            checked="#roomShare eq 0#" />

            No
            </label>
      	
        </td>
	</tr>

	<tr id="showname" <cfif roomShare eq 0>style="display: none;"</cfif>  >
		<td width=50%> Who will they share a room with?</td><Td> 
        	<select name="kid_share">
            	<option value=0> </option>
            <cfoutput query="get_kids">
				 <option value=#childid# <cfif get_kids.shared is 'yes'> selected</cfif>>#name#</option>
             </cfoutput>
             </select>
             </td>
	</tr>
</cfif>
</table>



<h3>Smoking</h3>
<table width=100% cellspacing=0 cellpadding=2 class="border" border=0>
	<Tr>
		<td align="left" width=50%>Does anyone in your family smoke?<span class="redtext">*</span></td><td>
            <label>
            <cfinput type="radio" name="smokes" value="yes"
            checked="#form.smokes eq 'yes'#" />
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="smokes" value="no"
           checked="#form.smokes eq 'no'#" />
            No
            </label>
		 
 </td>
	</tr>
		<Tr bgcolor="#deeaf3">
		<td align="left">Would you be willing to host a student who smokes?<span class="redtext">*</span></td><td>
		        <label>
            <cfinput type="radio" name="stu_smoke" value="yes"
            onclick="document.getElementById('showsmoke').style.display='table-row';" checked="#form.stu_smoke is 'yes'#" />
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="stu_smoke" value="no"
            onclick="document.getElementById('showsmoke').style.display='none';" checked="#form.stu_smoke is 'no'#"  />
            No
            </label>
		
</td>
	</tr>
		<Tr>
		<td align="left" colspan="2" id="showsmoke" <Cfif form.stu_smoke neq 1>style="display: none;"</cfif>>Under what conditions?<br><textarea cols="50" rows="4" name="smoke_conditions" wrap="VIRTUAL"><Cfoutput>#form.smoke_conditions#</cfoutput></textarea></td>
	</tr>
</table>
<span cless="spacer"></span>

<h3>Dietary Needs</h3>
<table width=100% cellspacing=0 cellpadding=2 class="border">
	<Tr bgcolor="#deeaf3">
    	<Td>
		Does anyone in your family follow any dietary restrictions?<span class="redtext">*</span>
	</Td>
    <td>
   <label>
            <cfinput type="radio" name="famDietRest" value="1" onclick="document.getElementById('famDietRestDesc').style.display='table-row';"
             checked="#form.famDietRest eq 1#" />
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="famDietRest" value="0"  onclick="document.getElementById('famDietRestDesc').style.display='none';"
             checked="#form.famDietRest eq 0#"  />
            No
            </label>
     </td>
     </Tr>
     <Tr id="famDietRestDesc"  <Cfif form.famDietRest neq 1>style="display: none;"</cfif> bgcolor="#deeaf3">
     	<td>Please describe</td>
        <td><textarea cols=30 rows=5 name="famDietRestDesc"><Cfoutput>#form.famDietRestDesc#</Cfoutput></textarea></td>
     </Tr>
     <Tr>
    	<Td>
			Do you expect the student to follow any dietary restrictions?<span class="redtext">*</span>
		</Td>
        <td>
   		<label>
            <cfinput type="radio" name="stuDietRest" value="1" onclick="document.getElementById('stuDietRestDesc').style.display='table-row';"
             checked="#form.stuDietRest eq 1#" />
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="stuDietRest" value="0" onclick="document.getElementById('stuDietRestDesc').style.display='none';"
             checked="#form.stuDietRest eq 0#"  />
            No
        </label>
     	</td>
     </Tr>
      <Tr id="stuDietRestDesc"   <Cfif form.stuDietRest neq 1>style="display: none;"</cfif>>
     	<td>Please describe</td>
        <td><textarea cols=30 rows=5 name="stuDietRestDesc"><cfoutput>#form.stuDietRestDesc#</cfoutput></textarea></td>
     </Tr>
     <Tr  bgcolor="#deeaf3">
    	<Td>
			Are you prepared to provide three (3) quality meals per day?<span class="redtext">*</span><br /> (students are expected to provide and/or pay for school lunches)
		</Td>
        <td>
   		<label>
            <cfinput type="radio" name="threesquares" value="1" 
             checked="#form.threesquares eq 1#"  />
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="threesquares" value="0" 
             checked="#form.threesquares eq 0#"  />
            No
        </label>
     	</td>
     </Tr>
 </table>

<h3>Allergies</h3>
<table width=100% cellspacing=0 cellpadding=2 class="border">
	<Tr bgcolor="#deeaf3">
    	<Td>
Would you be willing to host a student who is allergic to animals?<span class="redtext">*</span><Br /> (If they are able to handle the allergy with medication)
		</Td>
        <Td>

   <label>
            <cfinput type="radio" name="allergic" value="1"
             checked="#form.allergic eq 1#"  />
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="allergic" value="0"
             checked="#form.allergic eq 0#" />
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
