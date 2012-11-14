<!--- Import CustomTag Used for Page Messages and Form Errors --->
<cfimport taglib="extensions/customTags/gui/" prefix="gui" />	

<!--- Process Form Submission --->
<cfparam name="FORM.smokes" default="">
<cfparam name="FORM.stu_smoke" default="">
<cfparam name="FORM.famDietRest" default="3">
<cfparam name="FORM.stuDietRest" default="3">
<cfparam name="FORM.threesquares" default="3">
<cfparam name="FORM.share_room" default="0">
<cfparam name="FORM.allergic" default="3">
<cfparam name="FORM.kid_share" default="0">
<cfparam name="URL.animalid" default="">
<cfparam name="URL.hostID" default='#APPLICATION.CFC.SESSION.getHostSession().ID#'>
<cfparam name="FORM.indoor" default="na">
<cfparam name="FORM.animaltype" default="">
<cfparam name="FORM.dietaryRestriction" default='3'>
<!----Delete a Pet---->
<cfif isDefined('URL.delete_animal')>
	<cfquery datasource="#APPLICATION.DSN.Source#">
    delete from smg_host_animals
    where animalid = #URL.delete_animal#
    </Cfquery>
</cfif>
<!---Get host information---->
   <cfquery name="qGetHostInfo" datasource="#APPLICATION.DSN.Source#">
        SELECT  
        	*
        FROM 
        	smg_hosts shl
        LEFT JOIN 
        	smg_states on smg_states.state = shl.state
        WHERE 
        	hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.CFC.SESSION.getHostSession().ID#">
    </cfquery>
<!----Add a pet---->
 <cfif isDefined('FORM.addPet')>
  
         <!---Error Checking---->

         <cfscript>
   		 //Animal 1
			if  ( (LEN(TRIM(FORM.animaltype))) AND (FORM.number_pets eq 0) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("You've indicated you have a(n) #FORM.animaltype# but didn't indicate how many.");
			 }
			if  ( (LEN(TRIM(FORM.animaltype))) AND (FORM.number_pets neq 0) AND FORM.indoor is 'na'  ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("You've indicated you have #FORM.number_pets# #FORM.animaltype#(s) but didn't indicate if they are indoor, outdoor or both.");
			 } 
			if  ( (NOT LEN(TRIM(FORM.animaltype))) AND (FORM.number_pets eq 0) AND FORM.indoor is 'na'  ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("You have not indicated any details on a pet, please indicate which type of animal you have, where they live, and how many you have.");
			 }	
			 if  ( (NOT LEN(TRIM(FORM.animaltype))) AND (FORM.number_pets neq 0) AND FORM.indoor is not 'na'  ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("You have not indicated what type of animal you have, only the number and where it lives.");
			 }
    	</cfscript>
    		<cfif NOT SESSION.formErrors.length()>
                 <cfquery name="addPet" datasource="#APPLICATION.DSN.Source#">
                    insert into smg_host_animals (hostID, animaltype,number, indoor)
                            values(#APPLICATION.CFC.SESSION.getHostSession().ID#, '#FORM.animaltype#','#FORM.number_pets#','#FORM.indoor#')
                    </Cfquery>
        	</cfif>
  </cfif>

<cfif isDefined('FORM.process')>

        
 
        
       
       
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
					 // Family Dietary Restrictions
             if ( FORM.dietaryRestriction EQ 3) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate if you would have problems hosting a student with dietary restrictions.");
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
       
       
			<CFIF not isdefined("FORM.share_room")>
                <CFSET FORM.share_room = "">
            </cfif>
            <cftransaction action="BEGIN" isolation="SERIALIZABLE">
                    <!----share room---->
                    <cfif #FORM.share_room# is "yes">
                    <!---_THey answerd yes, but didn't indicate a kid... don't update until question is answerd.---->
                        <cfif FORM.kid_share neq 0>
                            <cfquery name="insert_room_share" datasource="#APPLICATION.DSN.Source#">
                            update smg_host_children
                             set shared = "yes"
                             where childid = #FORM.kid_share#
                            </cfquery>
                        </cfif>
                    </cfif>
                    <!----Smoking & Allergy Preferences---->
                    <cfquery name="smoking_pref" datasource="#APPLICATION.DSN.Source#">
                    update smg_hosts
                        set hostSmokes = '#FORM.smokes#',
                           
                            smokeconditions = '#FORM.smoke_conditions#',
                            pet_allergies = '#FORM.allergic#',
                            famDietRest = '#FORM.famDietRest#',
                            famDietRestDesc = '#FORM.famDietRestDesc#',
                            stuDietRest = '#FORM.stuDietRest#',
                            stuDietRestDesc = '#FORM.stuDietRestDesc#',
                            threesquares = '#FORM.threesquares#',
                            dietaryRestriction = '#FORM.dietaryRestriction#'
                            
                        where hostID = #APPLICATION.CFC.SESSION.getHostSession().ID#
                    </cfquery>
                    </cftransaction>
			<cflocation url="index.cfm?section=religiousPreference" addtoken="no">
        
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
			FORM.dietaryRestriction = qGetHostInfo.dietaryRestriction;
			
		</cfscript>

</cfif>
<!----script to hide kids names if they are not going to share a room---->

<cfquery name="get_pets" datasource="#APPLICATION.DSN.Source#">
select *
from smg_host_animals 
where hostID = #APPLICATION.CFC.SESSION.getHostSession().ID#
</cfquery>

<cfquery name="get_kids" datasource="#APPLICATION.DSN.Source#">
select childid, name, shared
from smg_host_children
where hostID = #APPLICATION.CFC.SESSION.getHostSession().ID#
</cfquery>
<cfquery name="family_info" datasource="#APPLICATION.DSN.Source#">
select *
from smg_hosts
where hostID = #APPLICATION.CFC.SESSION.getHostSession().ID#
</cfquery>
<h2>Hosting Environment</h2>
	
	<!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="section"
        />
        
<div class="row">

<h3>Current Pets</h3>
<cfquery name="qPets" datasource="#APPLICATION.DSN.Source#">
select *
from smg_host_animals
where hostID = #APPLICATION.CFC.SESSION.getHostSession().ID#
</cfquery>
<cfif qPets.recordcount eq 0>
	No pets have been added.
</cfif>
<cfoutput>
<table width="100%" cellspacing="0" cellpadding="2" class="border">
   <tr>
   	<th>Type</th><th>Indoor / Outdoor</th><th>How many?</th><th></th>
    </tr>
   <cfif qPets.recordcount eq 0>
    <tr>
    	<td>Currently, no pets are indicated as living in your home.</td>
    </tr>
    <cfelse>
    <cfloop query="qPets">
    <tr <cfif currentrow mod 2> bgcolor="##deeaf3"</cfif>>
    	<td><h3><p class="p_uppercase">#animaltype#</h3></td>
        <td><h3><p class="p_uppercase">#indoor#</h3></td>
        <td><h3>#number#</h3></td>
        <td><a href="index.cfm?section=hostingEnvironment&delete_animal=<cfoutput>#animalid#&hostID=#APPLICATION.CFC.SESSION.getHostSession().ID#</cfoutput>" onClick="return confirm('Are you sure you want to delete this pet?')"><img src="/images/buttons/delete23x28.png" title="Click to delete this pet" height=20 border="0"/></a></td>
    </tr>
    </cfloop>
    </cfif>
   </table>
	
</cfoutput>

<cfform action="index.cfm?section=hostingEnvironment&animalid=#URL.animalid#&hostID=#APPLICATION.CFC.SESSION.getHostSession().ID#" method="post" preloader="no">
<input type="hidden" name="addPet" value="1">


<h3>Pets </h3>
Please include all animals that live in or outside your home.<br />
<span class="redtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Required fields</span>
(if submitting animals)
<table width="100%" cellspacing="0" cellpadding="2" class="border">
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
 <table border="0" cellpadding="4" cellspacing="0" width="100%" class="section">
    <tr>
       
        <td align="right">
       
        <input type="image" src="/images/buttons/addPet.png" /></td>
    </tr>
</table>
</cfform>
<br />
	<hr width="50%" align="center"/>
 <br />
 
 <cfform action="index.cfm?section=hostingEnvironment" method="post">
<h3>Allergies</h3>
<table width="100%" cellspacing="0" cellpadding="2" class="border">
	<Tr bgcolor="#deeaf3">
    	<td>
Would you be willing to host a student who is allergic to animals?<span class="redtext">*</span><Br /> (If they are able to handle the allergy with medication)
		</td>
        <td>

   <label>
            <cfinput type="radio" name="allergic" value="1"
             checked="#FORM.allergic eq 1#"  />
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="allergic" value="0"
             checked="#FORM.allergic eq 0#" />
            No
            </label>
     </tr>
 </table>
 <br />
<h3>Room Sharing</h3>
<div class="get_Attention">The student may share a bedroom with someone of the same sex and within a reasonable age difference, but must have his/her own bed.</div>
<table width="100%" cellspacing="0" cellpadding="2" class="border">
<cfif get_kids.recordcount is 0>
	<tr>
    	<td colspan=4 bgcolor="#deeaf3">
<div class="get_Attention">Since you don't have any kids or other family members living at home, it is assumend the student will not be sharing a room.  If this is wrong, 
you will need to <a href="index.cfm?section=familyMembers">add a family member</a>.
</div>
		</td>
     </tr>
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
		<td width=50%> Who will they share a room with?</td><td> 
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
<table width="100%" cellspacing="0" cellpadding="2" class="border" border="0">
	<tr>
		<td align="left" width=50%>Does anyone in your family smoke?<span class="redtext">*</span></td><td>
            <label>
            <cfinput type="radio" name="smokes" value="yes"
            checked="#FORM.smokes eq 'yes'#"  onclick="document.getElementById('showsmoke').style.display='table-row';" />
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="smokes" value="no"
           checked="#FORM.smokes eq 'no'#" onclick="document.getElementById('showsmoke').style.display='none';" />
            No
            </label>
		 
 </td>
	</tr>
		
		<tr>
		<td align="left" colspan="2" id="showsmoke" <cfif FORM.stu_smoke neq 1>style="display: none;"</cfif>>Under what conditions?<br><textarea cols="50" rows="4" name="smoke_conditions" wrap="VIRTUAL" placeholder="inside, outside, etc"><Cfoutput>#FORM.smoke_conditions#</cfoutput></textarea></td>
	</tr>
</table>
<span cless="spacer"></span>

<h3>Dietary Needs</h3>
<table width="100%" cellspacing="0" cellpadding="2" class="border">
	<Tr bgcolor="#deeaf3">
    	<td>
		Does anyone in your family follow any dietary restrictions?<span class="redtext">*</span>
	</td>
    <td>
   <label>
            <cfinput type="radio" name="famDietRest" value="1" onclick="document.getElementById('famDietRestDesc').style.display='table-row';"
             checked="#FORM.famDietRest eq 1#" />
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="famDietRest" value="0"  onclick="document.getElementById('famDietRestDesc').style.display='none';"
             checked="#FORM.famDietRest eq 0#"  />
            No
            </label>
     </td>
     </tr>
     <Tr id="famDietRestDesc"  <cfif FORM.famDietRest neq 1>style="display: none;"</cfif> bgcolor="#deeaf3">
     	<td>Please describe</td>
        <td><textarea cols=30 rows=5 name="famDietRestDesc"><Cfoutput>#FORM.famDietRestDesc#</Cfoutput></textarea></td>
     </tr>
     <tr>
    	<td>
			Do you expect the student to follow any dietary restrictions?<span class="redtext">*</span>
		</td>
        <td>
   		<label>
            <cfinput type="radio" name="stuDietRest" value="1" onclick="document.getElementById('stuDietRestDesc').style.display='table-row';"
             checked="#FORM.stuDietRest eq 1#" />
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="stuDietRest" value="0" onclick="document.getElementById('stuDietRestDesc').style.display='none';"
             checked="#FORM.stuDietRest eq 0#"  />
            No
        </label>
     	</td>
     </tr>
      <Tr id="stuDietRestDesc"   <cfif FORM.stuDietRest neq 1>style="display: none;"</cfif>>
     	<td>Please describe</td>
        <td><textarea cols=30 rows=5 name="stuDietRestDesc"><cfoutput>#FORM.stuDietRestDesc#</cfoutput></textarea></td>
     </tr>
     <Tr  bgcolor="#deeaf3">
    	<td>
			Would you feel comfortable hosting a student with a dietary restriction?<span class="redtext">*</span><br /> (vegetarian, vegan, etc.)
		</td>
        <td>
   		<label>
            <cfinput type="radio" name="dietaryRestriction" value="1" 
             checked="#FORM.dietaryRestriction eq 1#"  />
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="dietaryRestriction" value="0" 
             checked="#FORM.dietaryRestriction eq 0#"  />
            No
        </label>
     	</td>
     </tr>
     <tr>
    	<td>
			Are you prepared to provide three (3) quality meals per day?<span class="redtext">*</span><br /> (students are expected to provide and/or pay for school lunches)
		</td>
        <td>
   		<label>
            <cfinput type="radio" name="threesquares" value="1" 
             checked="#FORM.threesquares eq 1#"  />
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="threesquares" value="0" 
             checked="#FORM.threesquares eq 0#"  />
            No
        </label>
     	</td>
     </tr>
 </table>



 <table border="0" cellpadding="4" cellspacing="0" width="100%" class="section">
    <tr>
       
        <td align="right">
        <input type="hidden" name="process">
        <input name="Submit" type="image" src="/images/buttons/Next.png" border="0"></td>
    </tr>
</table>
<span class="spacer"></span>
</div>

</cfform>
