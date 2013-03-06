<!--- ------------------------------------------------------------------------- ----
	
	File:		hostingEnvironment.cfm
	Author:		Marcus Melo
	Date:		November 19, 2012
	Desc:		Community Profile Page

	Updated:	

----- ------------------------------------------------------------------------- --->

<cfsilent>

    <!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="extensions/customTags/gui/" prefix="gui" />	

    <!--- Param FORM Variables --->
    <cfparam name="URL.animalID" default="0">
    <cfparam name="URL.deleteAnimalID" default="0">
    
    <!--- Param FORM Variables --->
    <cfparam name="FORM.action" default="">
	<!--- Add Pet --->
    <cfparam name="FORM.animalID" default="">
    <cfparam name="FORM.animalType" default="">
    <cfparam name="FORM.number" default="">
    <cfparam name="FORM.indoor" default="">
	<!--- Form --->
    <cfparam name="FORM.pet_allergies" default="">
    <cfparam name="FORM.isStudentSharingBedroom" default="">
    <cfparam name="FORM.sharingWithID" default="">
    <cfparam name="FORM.hostSmokes" default="">
    <cfparam name="FORM.smokeConditions" default="">
    <cfparam name="FORM.famDietRest" default="">
    <cfparam name="FORM.famDietRestDesc" default="">
    <cfparam name="FORM.stuDietRest" default="">
    <cfparam name="FORM.stuDietRestDesc" default="">
    <cfparam name="FORM.dietaryRestriction" default="">
    <cfparam name="FORM.threesquares" default="">

	<cfscript>
		if ( VAL(URL.animalID) ) {
			FORM.animalID = URL.animalID;	
		}

		// Get Host Pets
		qGetPetsList = APPLICATION.CFC.HOST.getHostPets(hostID=APPLICATION.CFC.SESSION.getHostSession().ID);

		// Get Host Pets
		qGetPetDetails = APPLICATION.CFC.HOST.getHostPets(hostID=APPLICATION.CFC.SESSION.getHostSession().ID,animalID=VAL(FORM.animalID));

		// Get Host Members
		qGetHostMembers = APPLICATION.CFC.HOST.getHostMemberByID(hostID=APPLICATION.CFC.SESSION.getHostSession().ID);
	</cfscript>
    
    <cfquery name="qGetWhoIsSharingRoom" dbtype="query">
        SELECT 
        	*
        FROM 
        	qGetHostMembers
        WHERE 
        	shared = <cfqueryparam cfsqltype="cf_sql_varchar" value="yes">
    </cfquery>
    
	<!--- Delete a Pet --->
    <cfif VAL(URL.deleteAnimalID)>
    
        <cfquery datasource="#APPLICATION.DSN.Source#">
            DELETE FROM 
            	smg_host_animals
            WHERE 
            	animalid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.deleteAnimalID)#">
            AND
            	hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.CFC.SESSION.getHostSession().ID#">
        </cfquery>

		<cfscript>
            // Set Page Message
            SESSION.pageMessages.Add("Pet has been deleted");
			// Refresh Page
			location("#CGI.SCRIPT_NAME#?section=#URL.section#", "no");
        </cfscript>
        
    </cfif>
    
    <!--- Insert Pet --->    
    <cfif FORM.action EQ "submitPetForm">
    
		<cfscript>
            // Data Validation 
            
            // Animal Type
            if ( NOT LEN(TRIM(FORM.animalType)) ) {
                SESSION.formErrors.Add("Please indicate which type of animal you have");
            }
            
            // Where do they live
            if ( NOT LEN(FORM.indoor) ) {
                SESSION.formErrors.Add("Please indicate if they are indoor, outdoor or both");
            }
            
            // How Many
            if ( NOT LEN(FORM.number) ) {
                SESSION.formErrors.Add("Please indicate how many animals you have");
            }
        </cfscript>
        
        <!--- No Errors found --->
        <cfif NOT SESSION.formErrors.length()>
            
			<!--- Update --->
            <cfif VAL(FORM.animalID)>
            
                <cfquery datasource="#APPLICATION.DSN.Source#">
                    UPDATE
                        smg_host_animals 
                    SET
                    	animalType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.animalType#">,
                        number = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.number#">,
                        indoor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.indoor#">
                    WHERE
                    	animalID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.animalID)#">
                    AND
                    	hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.CFC.SESSION.getHostSession().ID#">
                </cfquery>
                
                <cfscript>
                    // Set Page Message
                    SESSION.pageMessages.Add("Pet has been updated");
                </cfscript>
            
            <!--- Insert --->
            <cfelse>
            
                <cfquery datasource="#APPLICATION.DSN.Source#">
                    INSERT INTO 
                        smg_host_animals 
                    (
                        hostID, 
                        animalType,
                        number, 
                        indoor
                    )
                    VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.CFC.SESSION.getHostSession().ID#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.animalType#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.number#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.indoor#">
                    )
                </cfquery>
                
                <cfscript>
                    // Set Page Message
                    SESSION.pageMessages.Add("Pet has been added");
                </cfscript>
            
            </cfif>
            
        </cfif>
		
        <cfscript>    
            // Refresh Page
            location("#CGI.SCRIPT_NAME#?section=#URL.section#", "no");
        </cfscript>

	<!--- Form Submitted --->
	<cfelseif FORM.action EQ "submitted">
    
		<cfscript>
			// Data Validation

			// Allergies
			if ( NOT LEN(FORM.pet_allergies) ) {
				SESSION.formErrors.Add("Please indicate if you would be willing to host a student who is allergic to animals");
			}

			// Room Sharing
			if ( qGetHostMembers.recordcount AND NOT LEN(FORM.isStudentSharingBedroom) ) {
				SESSION.formErrors.Add("Please indicate if the student is going to share a bedroom");
			}

			// Room Sharing
			if ( FORM.isStudentSharingBedroom EQ 1 AND NOT VAL(FORM.sharingWithID) )  {
				SESSION.formErrors.Add("You have indicated that the student will share a room, but have not indicated with whom they will share the room");
			}
			
			// Family Smokes
			if ( NOT LEN(TRIM(FORM.hostSmokes)) ) {
				SESSION.formErrors.Add("Please indicate if any one in your family smokes");
			}
			
			// Family Smokes Conditions
			if ( FORM.hostSmokes EQ "yes" AND NOT LEN(TRIM(FORM.smokeConditions)) ) {
				SESSION.formErrors.Add("Please indicate under what conditions someone in your family smokes");
			}
			
			// Family Dietary Restrictions
			if ( NOT LEN(FORM.famDietRest) ) {
				SESSION.formErrors.Add("Please indicate if your family follows any dietary restrictions");
			}
			
			// Family Dietary Description
			if ( FORM.famDietRest EQ 1 AND NOT LEN(FORM.famDietRestDesc) ) {
				SESSION.formErrors.Add("You have indicated that someone in your family follows a dietary restriction but have not describe it");
			}

			// Student Follow Dietary Restrictions
			if ( NOT LEN(FORM.stuDietRest) ) {
				SESSION.formErrors.Add("Please indicate if the student is to follow any dietary restrictions");
			}

			// Student Follow Dietary Description
			if ( FORM.stuDietRest EQ 1 AND NOT LEN(FORM.stuDietRestDesc) ) {
				SESSION.formErrors.Add("You have indicated the student is to follow a dietary restriction but have not describe it");
			}

			// Hosting a student with dietary resctriction
			if ( NOT LEN(FORM.dietaryRestriction) ) {
				SESSION.formErrors.Add("Please indicate if you would have problems hosting a student with dietary restrictions");
			}

			// Three Squares
			if ( NOT LEN(FORM.threesquares) ) {
				SESSION.formErrors.Add("Please indicate if you are prepared to provide three (3) quality meals per day");
			}
        </cfscript>
        
        <!--- No Errors found --->
        <cfif NOT SESSION.formErrors.length()>
        	
            <cfscript>
				// Reset Hidden Fields
				if ( FORM.hostSmokes EQ "no" ) {
					FORM.smokeConditions = "";
				}
				
				if ( NOT VAL(FORM.isStudentSharingBedroom) ) {
					FORM.sharingWithID = "";
				}

				if ( NOT VAL(FORM.famDietRest) ) {
					FORM.famDietRestDesc = "";
				}
				
				if ( NOT VAL(FORM.stuDietRest) ) {
					FORM.stuDietRestDesc = "";
				}
			</cfscript>
            
			<!--- share room --->
            <cfif VAL(FORM.isStudentSharingBedroom) AND VAL(FORM.sharingWithID)>
            
                <cfquery datasource="#APPLICATION.DSN.Source#">
                    UPDATE 
                        smg_host_children
                    SET
                        shared = <cfqueryparam cfsqltype="cf_sql_varchar" value="yes">
                    WHERE
                        childid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.sharingWithID)#">
                    AND
                        hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.CFC.SESSION.getHostSession().ID#">
                </cfquery>
            
            <cfelse>
            
                <cfquery datasource="#APPLICATION.DSN.Source#">
                    UPDATE 
                        smg_host_children
                    SET
                        shared = <cfqueryparam cfsqltype="cf_sql_varchar" value="no">
                    WHERE
                        hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.CFC.SESSION.getHostSession().ID#">
                </cfquery>
                
            </cfif>
            
            <cfquery datasource="#APPLICATION.DSN.Source#">
                UPDATE 
                	smg_hosts
                SET
                	pet_allergies = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.pet_allergies#">,
                    isStudentSharingBedroom = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.isStudentSharingBedroom#" null="#yesNoFormat(NOT LEN(FORM.isStudentSharingBedroom))#">,
                	hostSmokes = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.hostSmokes#">,
                    smokeconditions = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.smokeConditions#">,
                    famDietRest = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.famDietRest#">,
                    famDietRestDesc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LEFT(FORM.famDietRestDesc, 300)#">,
                    stuDietRest = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.stuDietRest#">,
                    stuDietRestDesc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LEFT(FORM.stuDietRestDesc, 300)#">,
                    dietaryRestriction = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.dietaryRestriction#">,
                    threesquares = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.threesquares#">
                WHERE 
                	hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.CFC.SESSION.getHostSession().ID#">
            </cfquery>
            
            <cfscript>
				// Successfully Updated - Set navigation page
				Location(APPLICATION.CFC.UDF.setPageNavigation(section=URL.section), "no");
			</cfscript>
        
		</cfif> <!--- No Errors found --->
        
	<cfelse>

		<cfscript>
            // Set Default Values
			FORM.animalID = qGetPetDetails.animalID;
			FORM.animalType = qGetPetDetails.animalType;
			FORM.number = qGetPetDetails.number;
			FORM.indoor = qGetPetDetails.indoor;

			FORM.pet_allergies = qGetHostFamilyInfo.pet_allergies;
            FORM.hostSmokes = qGetHostFamilyInfo.hostSmokes;
            FORM.smokeConditions = qGetHostFamilyInfo.smokeconditions;
            FORM.famDietRest = qGetHostFamilyInfo.famDietRest;
            FORM.famDietRestDesc = qGetHostFamilyInfo.famDietRestDesc;
            FORM.stuDietRest = qGetHostFamilyInfo.stuDietRest;
            FORM.stuDietRestDesc = qGetHostFamilyInfo.stuDietRestDesc;
            FORM.dietaryRestriction = qGetHostFamilyInfo.dietaryRestriction;
            FORM.threesquares = qGetHostFamilyInfo.threesquares;

			if ( qGetWhoIsSharingRoom.recordcount ) {
				FORM.isStudentSharingBedroom = 1;
				FORM.sharingWithID = qGetWhoIsSharingRoom.childID;
			} else {
				FORM.isStudentSharingBedroom = qGetHostFamilyInfo.isStudentSharingBedroom;
			}
        </cfscript>
    
    </cfif>

</cfsilent>

<cfoutput>

    <h2>Hosting Environment</h2>
	
	<!--- Page Messages --->
    <gui:displayPageMessages 
        pageMessages="#SESSION.pageMessages.GetCollection()#"
        messageType="section"
        />
	
	<!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="section"
        />

    <h3>Current Pets</h3>
    
    <table width="100%" cellspacing="0" cellpadding="4" class="border">
        <tr bgcolor="##deeaf3">
            <th style="border-bottom:1px solid ##000;">Type</th>
            <th style="border-bottom:1px solid ##000;">Indoor / Outdoor</th>
            <th style="border-bottom:1px solid ##000;">How many?</th>
            <th style="border-bottom:1px solid ##000;" width="50px"></th>
        </tr>        
        
        <cfloop query="qGetPetsList">
            <tr <cfif qGetPetsList.currentRow MOD 2 EQ 0> bgcolor="##deeaf3"</cfif>>
                <th>#qGetPetsList.animalType#</th>
                <td>#qGetPetsList.indoor#</td>
                <td><cfif qGetPetsList.number EQ 11>10+<cfelse>#qGetPetsList.number#</cfif></td>
                <td>
	                <a href="index.cfm?section=hostingEnvironment&animalID=#qGetPetsList.animalID#" title="Click to edit this pet" style="padding-right:5px;"><img src="images/buttons/pencilBlue23x29.png" border="0" height="15"/></a> 
                	<a href="index.cfm?section=hostingEnvironment&deleteAnimalID=#qGetPetsList.animalid#" title="Click to delete this pet" onClick="return confirm('Are you sure you want to delete this pet?')"><img src="images/buttons/deleteRedX.png" border="0"/></a>
				</td>
            </tr>
        </cfloop>
        
        <cfif qGetPetsList.recordcount EQ 0>
        	<tr>
        		<td>Currently, no pets are indicated as living in your home.</td>
        	</tr>
        </cfif>
    </table> <br />
	
    <form action="index.cfm?section=hostingEnvironment" method="post" preloader="no">
        <input type="hidden" name="action" value="submitPetForm">
        <input type="hidden" name="animalID" value="#FORM.animalID#">
    
        <h3>Pets </h3>
        
    	Please include all animals that live in or outside your home.<br />
    	<span class="required">* Required fields</span> (if submitting pets)
        
        <table width="100%" cellspacing="0" cellpadding="2" class="border">
            <tr bgcolor="##deeaf3">
                <td class="label"><h3>Type of Animal <span class="required">*</span></h3></td>	
                <td class="label"><h3>Where do they live? <span class="required">*</span></h3></td>
                <td class="label"><h3>How Many?  <span class="required">*</span></h3></td>
            </tr>
            <tr>    
                <td><input type="text" name="animalType" value="#FORM.animalType#" class="largeField" maxlength="150"></td>
                <td>
                    <input type="radio" name="indoor" id="indoor" value="indoor" <cfif FORM.indoor EQ "indoor">checked="checked"</cfif> > <label for="indoor">Indoor</label>
                    <input type="radio" name="indoor" id="outdoor" value="outdoor" <cfif FORM.indoor EQ "outdoor">checked="checked"</cfif> > <label for="outdoor">Outdoor</label> 
                    <input type="radio" name="indoor" id="both" value="both" <cfif FORM.indoor EQ "both">checked="checked"</cfif> > <label for="both">Both</label>
            	</td>
                <td>
                    <select name="number" class="smallField">
                        <option value="" <cfif NOT LEN(FORM.number)>selected="selected"</cfif> ></option>	
                        <cfloop from="1" to="10" index="i">
                            <option value="#i#" <cfif FORM.number EQ i>selected="selected"</cfif> >#i#</option>
                        </cfloop>
                        <option value="11" <cfif FORM.number EQ "10+">selected="selected"</cfif> >10+
                    </select>
                </td>
            </tr>
        </table> <br />
    
        <table border="0" cellpadding="4" cellspacing="0" width="100%" class="section">
            <tr>
            	<td align="right">
                    <cfif VAL(FORM.animalID)>
                        <input name="Submit" type="image" src="images/buttons/update_44.png" border="0"> 
                    <cfelse>
                        <input type="image" src="images/buttons/addPet.png" />
                    </cfif> 
				</td>
            </tr>
        </table>
        
    </form>
    
    <br /><hr width="80%" align="center"/><br />
    
    <cfform action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
    	<input type="hidden" name="action" value="submitted" />
    
    	<h3>Allergies</h3>
    
        <table width="100%" cellspacing="0" cellpadding="2" class="border">
            <tr bgcolor="##deeaf3">
                <td>
                	Would you be willing to host a student who is allergic to animals? <span class="required">*</span>
                    <br /> (If they are able to handle the allergy with medication)
                </td>
                <td>
                    <cfinput type="radio" name="pet_allergies" id="pet_allergies1" value="1" checked="#FORM.pet_allergies EQ 1#"/>
                    <label for="pet_allergies1">Yes</label>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <cfinput type="radio" name="pet_allergies" id="pet_allergies0" value="0" checked="#FORM.pet_allergies EQ 0#"/>
                    <label for="pet_allergies0">No</label>
				</td>          
            </tr>
        </table> <br />
        
        <h3>Room Sharing</h3>
        
        <div class="get_Attention">The student may share a bedroom with someone of the same sex and within a reasonable age difference, but must have his/her own bed.</div>
        
        <table width="100%" cellspacing="0" cellpadding="2" class="border">
			<cfif NOT qGetHostMembers.recordcount>
                <tr>
                    <td colspan="4" bgcolor="##deeaf3">
                        <div class="get_Attention">
                        	Since you don't have any kids or other family members living at home, it is assumend the student will not be sharing a room. If this is wrong, 
                        	you will need to <a href="index.cfm?section=familyMembers">add a family member</a>.
                		</div>
                	</td>
                </tr>
            <cfelse>
                <tr bgcolor="##deeaf3">
                    <td id="shareBedroom" width="50%">Will the student share a bedroom? <span class="required">*</span></td>
                    <td>
                        <cfinput type="radio" name="isStudentSharingBedroom" id="isStudentSharingBedroom1" value="1" onclick="document.getElementById('showname').style.display='table-row';" checked="#FORM.isStudentSharingBedroom EQ 1#" />
                        <label for="isStudentSharingBedroom1">Yes</label>
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <cfinput type="radio" name="isStudentSharingBedroom" id="isStudentSharingBedroom0" value="0" onclick="document.getElementById('showname').style.display='none';" checked="#FORM.isStudentSharingBedroom EQ 0#" />
                        <label for="isStudentSharingBedroom0">No</label>
                    </td>
                </tr>
                
                <tr id="showname" <cfif FORM.isStudentSharingBedroom NEQ 1>class="displayNone"</cfif> >
                    <td width="50%">Who will they share a room with? <span class="required">*</span></td>
                    <td> 
                        <select name="sharingWithID" class="largeField">
                            <option value=""></option>
                            <cfloop query="qGetHostMembers">
                                <option value="#qGetHostMembers.childid#" <cfif qGetHostMembers.childID EQ FORM.sharingWithID> selected</cfif> >#qGetHostMembers.name#</option>
                            </cfloop>
                        </select>
                    </td>
                </tr>
            </cfif>
        </table> <br />
    
    	<h3>Smoking</h3>
        
        <table width="100%" cellspacing="0" cellpadding="2" class="border" border="0">
            <tr>
                <td align="left" width="50%">Does anyone in your family smoke? <span class="required">*</span></td>
                <td>
                    <cfinput type="radio" name="hostSmokes" id="hostSmokesYes" value="yes" checked="#FORM.hostSmokes eq 'yes'#"  onclick="document.getElementById('showsmoke').style.display='table-row';" />
                    <label for="hostSmokesYes">Yes</label>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <cfinput type="radio" name="hostSmokes" id="hostSmokesNo" value="no" checked="#FORM.hostSmokes eq 'no'#" onclick="document.getElementById('showsmoke').style.display='none';" />
                    <label for="hostSmokesNo">No</label>
            	</td>
            </tr>
            <tr>
            	<td align="left" colspan="2" id="showsmoke" <cfif FORM.hostSmokes NEQ 1>class="displayNone"</cfif>>
                	Under what conditions? <span class="required">*</span>
                    <br />
                    <textarea name="smokeConditions" placeholder="inside, outside, etc" class="largeTextArea">#FORM.smokeConditions#</textarea>
				</td>
            </tr>
        </table> <br />
    
        <h3>Dietary Needs</h3>
        
        <table width="100%" cellspacing="0" cellpadding="2" class="border">
            <tr bgcolor="##deeaf3">
                <td>Does anyone in your family follow any dietary restrictions? <span class="required">*</span></td>
            	<td>
                    <cfinput type="radio" name="famDietRest" id="famDietRest1" value="1" onclick="document.getElementById('famDietRestDesc').style.display='table-row';" checked="#FORM.famDietRest eq 1#" />
                    <label for="famDietRest1">Yes</label>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <cfinput type="radio" name="famDietRest" id="famDietRest0" value="0"  onclick="document.getElementById('famDietRestDesc').style.display='none';" checked="#FORM.famDietRest eq 0#"  />
                    <label for="famDietRest0">No</label>
            	</td>
            </tr>
            <tr id="famDietRestDesc" bgcolor="##deeaf3" <cfif FORM.famDietRest NEQ 1>class="displayNone"</cfif>>
                <td>Please describe</td>
                <td><textarea name="famDietRestDesc" class="largeTextArea">#FORM.famDietRestDesc#</textarea></td>
            </tr>
            <tr>
                <td>Do you expect the student to follow any dietary restrictions? <span class="required">*</span></td>
                <td>
                    <cfinput type="radio" name="stuDietRest" id="stuDietRest1" value="1" onclick="document.getElementById('stuDietRestDesc').style.display='table-row';" checked="#FORM.stuDietRest eq 1#" />
                    <label for="stuDietRest1">Yes</label>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <cfinput type="radio" name="stuDietRest" id="stuDietRest0" value="0" onclick="document.getElementById('stuDietRestDesc').style.display='none';" checked="#FORM.stuDietRest eq 0#"  />
                    <label for="stuDietRest0">No</label>
                </td>
            </tr>
            <tr id="stuDietRestDesc" <cfif FORM.stuDietRest NEQ 1>class="displayNone"</cfif>>
                <td>Please describe</td>
                <td><textarea name="stuDietRestDesc" class="largeTextArea">#FORM.stuDietRestDesc#</textarea></td>
            </tr>
            <tr bgcolor="##deeaf3">
                <td>
                    Would you feel comfortable hosting a student with a dietary restriction? <span class="required">*</span>
                    <br /> (vegetarian, vegan, etc.)
                </td>
                <td>
                    <cfinput type="radio" name="dietaryRestriction" id="dietaryRestriction1" value="1" checked="#FORM.dietaryRestriction eq 1#" />
                    <label for="dietaryRestriction1">Yes</label>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <cfinput type="radio" name="dietaryRestriction" id="dietaryRestriction0" value="0" checked="#FORM.dietaryRestriction eq 0#"  />
                    <label for="dietaryRestriction0">No</label>
                </td>
            </tr>
            <tr>
                <td>
                	Are you prepared to provide three (3) quality meals per day? <span class="required">*</span>
                    <br /> (students are expected to provide and/or pay for school lunches)
                </td>
                <td>
                    <cfinput type="radio" name="threesquares" id="threesquares1" value="1" checked="#FORM.threesquares eq 1#" />
                    <label for="threesquares1">Yes</label>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <cfinput type="radio" name="threesquares" id="threesquares0" value="0" checked="#FORM.threesquares eq 0#" />
                    <label for="threesquares0">No</label>
                </td>
            </tr>
        </table>

        <!--- Check if FORM submission is allowed --->
        <cfif APPLICATION.CFC.UDF.allowFormSubmission(section=URL.section)>
            <table border="0" cellpadding="4" cellspacing="0" width="100%" class="section">
                <tr>
                    <td align="right">
                        <input name="submit" type="image" src="images/buttons/Next.png" border="0">
                    </td>
                </tr>
            </table>
		</cfif>
        
	</cfform>
    
</cfoutput>