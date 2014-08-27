<!--- ------------------------------------------------------------------------- ----
	
	File:		familyMembers.cfm
	Author:		Marcus Melo
	Date:		December 12, 2012
	Desc:		Family Member Page

	Updated:	

----- ------------------------------------------------------------------------- --->

<cfsilent>

    <!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="extensions/customTags/gui/" prefix="gui" />	
    
    <!--- PARAM URL Variables --->
    <cfparam name="URL.childID" default="0">
    <cfparam name="URL.deleteChildID" default="0">
    
    <!--- PARAM FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.childID" default="0">
    <cfparam name="FORM.name" default="">
    <cfparam name="FORM.lastName" default="">
    <cfparam name="FORM.middleName" default="">
    <cfparam name="FORM.birthdate" default="">
    <cfparam name="FORM.membertype" default="">
    <cfparam name="FORM.interests" default="">
    <cfparam name="FORM.sex" default="">
    <cfparam name="FORM.liveathome" default="">
    <cfparam name="FORM.liveathomePartTime" default="">
    <cfparam name="FORM.gradeInSchool" default="">
    <cfparam name="FORM.employer" default="">
    <cfparam name="FORM.schoolActivities" default="">
    <cfparam name="FORM.radioSchoolActivities" default="">

	<cfscript>
		if ( VAL(URL.childID) ) {
			FORM.childID = URL.childID;	
		}
		
		// Get Host Family Members
		qGetHostMemberInfo = APPLICATION.CFC.HOST.getHostMemberByID(hostID=APPLICATION.CFC.SESSION.getHostSession().ID,childID=VAL(FORM.childID));		
	</cfscript>

    <cfquery name="qGetAllFamilyMembers" datasource="#APPLICATION.DSN.Source#">
    	SELECT 
        	*, 
            smg_schools.schoolname
        FROM 
        	smg_host_children
        LEFT OUTER JOIN 
        	smg_schools on smg_schools.schoolid = smg_host_children.school
        WHERE
        	hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.CFC.SESSION.getHostSession().ID#">
		AND
        	isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">            
    </cfquery>
    
	<cfscript>
		// Check if member belongs to the current logged in host family
		if ( VAL(FORM.childID) AND NOT qGetHostMemberInfo.recordCount ) {
			FORM.childID = 0;
			SESSION.formErrors.Add("The family member you are trying to edit does not belong to this account.");
		}
	</cfscript>
    
    <cfquery name="qGetHostLocation" datasource="#APPLICATION.DSN.Source#">
        SELECT 	
        	city,
            state,
            zip
        FROM 
        	smg_hosts
        WHERE 
        	hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.CFC.SESSION.getHostSession().ID#">
    </cfquery>
    
    <cfquery name="qGetSchoolList" datasource="#APPLICATION.DSN.Source#">
        SELECT 
        	* 
        FROM 
        	smg_schools
        WHERE 
        	city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetHostLocation.city#">
        AND 
        	state = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetHostLocation.state#">
    </cfquery>

    <!--- Delete Member --->
    <cfif VAL(URL.deleteChildID)>
    
        <cfquery datasource="#APPLICATION.DSN.Source#">
            DELETE FROM
                smg_host_children
            WHERE 
                childID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.deleteChildID)#">
            AND
                hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.CFC.SESSION.getHostSession().ID#">
            LIMIT 1
        </cfquery>
        
        <cfscript>
			// Set Page Message
			SESSION.pageMessages.Add("Family member has been deleted");
			
			// Refresh Page
			location("#CGI.SCRIPT_NAME#?section=#URL.section#", "no");
		</cfscript>
        
    </cfif>

    <!--- Process Form Submission --->
    <cfif VAL(FORM.submitted)>
    
		<cfscript>
			// Calculate Age
			if ( isDate(FORM.birthdate) ) {
				vCalculateAge = Datediff('yyyy',FORM.birthdate, now());
			} else {
				vCalculateAge = 0;
			}
			
			// Data Validation
			
            // First Name
            if ( NOT LEN(TRIM(FORM.name)) ) {
                SESSION.formErrors.Add("Please enter the First Name.");
            }			
            
            // Last Name
            if ( NOT LEN(TRIM(FORM.lastName)) ) {
                SESSION.formErrors.Add("Please enter the Last Name.");
            }			
            
            // Gender
            if ( NOT LEN(TRIM(FORM.sex)) ) {
                SESSION.formErrors.Add("Please select the Gender.");
            }
            
            // Birthdate
            if ( NOT isDate(TRIM(FORM.birthdate)) ) {
                SESSION.formErrors.Add("Please enter a valid Date of Birth.");
				FORM.birthdate = "";
            }			
            
            // Birthdate
            if ( vCalculateAge GT 120 ) {
                SESSION.formErrors.Add("The birthdate indicates the person is over 120 years old.  Please check the birthdate.");				
            }	
            
            // Birthdate
            if ( isDate(FORM.birthdate) AND FORM.birthDate GT now() ) {
                SESSION.formErrors.Add("The birthdate indicates this person has not been born yet.");				
            }	
            
            // Relation
            if ( NOT LEN(TRIM(FORM.membertype)) ) {
                SESSION.formErrors.Add("Please enter the Relation.");
            }	
            
            // Interests
            if ( NOT LEN(TRIM(FORM.interests)) ) {
                SESSION.formErrors.Add("Please enter some interests for this person.");
            }
            
            // Living at home
            if ( NOT LEN(TRIM(FORM.liveathome)) ) {
                SESSION.formErrors.Add("Please indicate if person is living at home.");
            }
            
            // liveathomePartTime
            if ( NOT LEN(TRIM(FORM.liveathomePartTime)) ) {
                SESSION.formErrors.Add("Please indicate if living at home at all durring the exchange period.");
            }	
			
            // School Activities
			if ( FORM.radioSchoolActivities EQ 'n/a' ) {
				FORM.schoolActivities = "n/a";
			}
			
			// School Activities
            if ( NOT LEN(FORM.schoolActivities) ) {
                SESSION.formErrors.Add("Please indicate if the student participates in any sponsored school activities");
            }	
        </cfscript>
        
        <!--- No Errors Found --->
		<cfif NOT SESSION.formErrors.length()>
        
			<!--- Update --->
            <cfif VAL(FORM.childID)>
            	
                <cfquery datasource="#APPLICATION.DSN.Source#">
                    UPDATE 
                        smg_host_children 
                    SET
                        name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(FORM.name)#">,
                        lastName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(FORM.lastName)#">,
                        middleName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(FORM.middleName)#">,                    
                        sex = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.sex#">,
                        birthdate = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.birthdate#">,
                        membertype = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.membertype#">,
                        liveathome = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.liveathome#">,
                        liveathomePartTime = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.liveathomePartTime#">,
                        school = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.school#">,
                        employer = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.employer#">,
                        interests = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.interests#">,
                        gradeInSchool = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.gradeInSchool#">,
                        schoolActivities = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.schoolActivities#">
                    WHERE 
                        childID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.childID#">
                </cfquery>
                
				<cfscript>
                    // Set Page Message
                    SESSION.pageMessages.Add("Family member has been updated");
                </cfscript>
                
            <!--- INSERT --->
            <cfelse>
            
                <cfquery datasource="#APPLICATION.DSN.Source#">
                    INSERT INTO 
                    	smg_host_children 
                    (
                        hostID, 
                        name, 
                        lastName,
                        middleName,
                        sex, 
                        birthdate, 
                        membertype, 
                        liveathome, 
                        liveathomePartTime, 
                        interests, 
                        school, 
                        employer,
                        gradeInSchool,
                        schoolActivities
                    )
                    VALUES 
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.CFC.SESSION.getHostSession().ID#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(FORM.name)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(FORM.lastName)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(FORM.middleName)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.sex#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.birthdate#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.membertype#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.liveathome#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.liveathomePartTime#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.interests#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.school#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.employer#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.gradeInSchool#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.schoolActivities#">
                    )  
                </cfquery>

				<cfscript>
                    // Set Page Message
                    SESSION.pageMessages.Add("Family member has been added");
                </cfscript>
                
            </cfif>

			<cfscript>
				// Refresh Page
				location("#CGI.SCRIPT_NAME#?section=#URL.section#", "no");
            </cfscript>
            
		</cfif> <!--- No Errors Found --->

	<!--- FORM NOT Submitted --->
    <cfelse>
	
		 <cfscript>
            // Set FORM Values   
            FORM.birthdate = qGetHostMemberInfo.birthdate;
            FORM.employer = qGetHostMemberInfo.employer;
            FORM.interests = qGetHostMemberInfo.interests;
            FORM.liveathome = qGetHostMemberInfo.liveathome;
            FORM.liveathomePartTime = qGetHostMemberInfo.liveathomePartTime;
            FORM.memberType = qGetHostMemberInfo.memberType;
            FORM.name = qGetHostMemberInfo.name;
            FORM.lastName = qGetHostMemberInfo.lastName;
            FORM.middleName = qGetHostMemberInfo.middleName;
            FORM.sex = qGetHostMemberInfo.sex;
            FORM.school = qGetHostMemberInfo.school;
            FORM.gradeInSchool = qGetHostMemberInfo.gradeInSchool;
            FORM.schoolActivities = qGetHostMemberInfo.schoolActivities;
        </cfscript>
        
	</cfif>

</cfsilent>

<cfoutput>
	
    <h2>Family Members</h2>
    
    <h3>Current Family Members</h3>

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
                
    <table width="100%" cellspacing="0" cellpadding="4" class="border">
        <tr bgcolor="##deeaf3">
            <th style="border-bottom:1px solid ##000;">Name</th>
            <th style="border-bottom:1px solid ##000;">Gender</th>
            <th style="border-bottom:1px solid ##000;">Date of Birth</th>
            <th style="border-bottom:1px solid ##000;">Relation</th>
            <th style="border-bottom:1px solid ##000;">At Home?</th>
            <th style="border-bottom:1px solid ##000;">School</th>
            <th style="border-bottom:1px solid ##000;" width="50px"></th>
        </tr>
        
        <cfif NOT qGetAllFamilyMembers.recordcount>
            <tr>
            	<td colspan="7">Currently, no other family members are indicated as living in your home.</td>
            </tr>
        </cfif>
        
        <cfloop query="qGetAllFamilyMembers">
            <tr <cfif qGetAllFamilyMembers.currentRow MOD 2 EQ 0> bgcolor="##deeaf3"</cfif>>
                <th>#qGetAllFamilyMembers.name# #qGetAllFamilyMembers.lastName#</th>
                <td>#qGetAllFamilyMembers.sex#</td>
                <td>#DateFormat(qGetAllFamilyMembers.birthdate, 'mmm d, yyyy')#</td>
                <td>#qGetAllFamilyMembers.membertype#</td>
                <td><cfif qGetAllFamilyMembers.liveathome is 'yes'>Yes<cfelseif qGetAllFamilyMembers.liveathomePartTime is 'yes'>Part Time<cfelse>No</cfif></td>
                <td>#qGetAllFamilyMembers.schoolname#</td>
                <td>
					<!--- Check if FORM submission is allowed --->
                    <cfif APPLICATION.CFC.UDF.allowFormSubmission(section=URL.section)>                    
                        <a href="index.cfm?section=familyMembers&childID=#qGetAllFamilyMembers.childID#" title="Click to edit this family member" style="padding-right:5px;"><img src="images/buttons/pencilBlue23x29.png" border="0" height="15"/></a> 
                        <a href="index.cfm?section=familyMembers&deleteChildID=#qGetAllFamilyMembers.childID#" title="Click to delete this family member" onClick="return confirm('Are you sure you want to delete #qGetAllFamilyMembers.name# #qGetAllFamilyMembers.lastName# from Family Members?')"> <img src="images/buttons/deleteRedX.png" border="0"/></a>
					</cfif>
                </td>
            </tr>
        </cfloop>
        
    </table> <br />
        
    <cfform action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" preloader="no">
    	<input type="hidden" name="submitted" value="1" />
        <input type="hidden" name="childID" value="#FORM.childID#" /> 

        <h3>Add a Family Members</h3>
	
        Please include all college age or younger children, whether they are living at home or not, and <span style="background-color:##FF0; padding: 3px;"><strong> any other persons</strong></span> 
        who live with you on a regular basis. After adding a family member's information, select the <strong><em>Add Member</em></strong> button at the bottom to save their information.<br /><br />
        
        <span class="required">* Required fields</span>
        
        <table width="100%" cellspacing="0" cellpadding="2" class="border">
            <tr>
                <td class="label"><h3>First Name <span class="required">*</span></h3></td>
                <td><cfinput type="text" name="name" value="#FORM.name#" class="largeField" maxlength="50" message="Please enter the First Name."></td>
            </tr>
            <tr bgcolor="##deeaf3">
                <td class="label"><h3>Last Name <span class="required">*</span></h3></td>
                <td><cfinput type="text" name="lastName" value="#FORM.lastName#" class="largeField" maxlength="50" message="Please enter the Name."></td>
            </tr>
            <tr>
                <td class="label"><h3>Middle Name</h3></td>
                <td><cfinput type="text" name="middleName" value="#FORM.middleName#" class="largeField" maxlength="50"></td>
            </tr>
            <tr bgcolor="##deeaf3">
                <td class="label"><h3>Gender <span class="required">*</span></h3></td>
                <td>
                    <cfinput type="radio" name="sex" id="sexMale" value="Male" checked="#yesNoFormat(FORM.sex EQ 'Male')#"> <label for="sexMale">Male</label>
                    <cfinput type="radio" name="sex" id="sexFemale" value="Female" checked="#yesNoFormat(FORM.sex EQ 'Female')#"> <label for="sexFemale">Female</label>
                </td>
            </tr>
            <tr>
                <td class="label"><h3>Date of Birth <span class="required">*</span></h3></td>
                <td><cfinput type="text" name="birthdate" value="#dateFormat(FORM.birthdate, 'mm/dd/yyyy')#" class="mediumField" maxlength="10" placeholder="MM/DD/YYYY" mask="99/99/9999"></td>
            </tr>
            <tr bgcolor="##deeaf3">
                <td class="label"><h3>Relation <span class="required">*</span></h3> </td>
                <td><cfinput type="text" name="membertype" value="#FORM.membertype#" class="largeField" maxlength="150"></td>
            </tr>
            <tr>
                <td class="label"><h3>Living at Home <span class="required">*</span></h3></td>
                <td>
                    <cfinput type="radio" name="liveathome" id="liveAtHomeYes" value="Yes" checked="#yesNoFormat(FORM.liveathome EQ 'Yes')#"/> <label for="liveAtHomeYes">Yes</label>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <cfinput type="radio" name="liveathome" id="liveAtHomeNo" value="No" checked="#yesNoFormat(FORM.liveathome EQ 'No')#"/> <label for="liveAtHomeNo">No</label>
                </td>
            </tr>
            <tr bgcolor="##deeaf3" >
                <td class="label">
                	<h3>Will this person live at the home at any<br /> 
                	time during the exchange period?<br />
                	<font size=-1> (i.e. college students home for holiday, etc)</font> <span class="required">*</span></h3>
                </td>
                <td>
                    <cfinput type="radio" name="liveathomePartTime" id="liveAtHomePartTimeYes" value="Yes" checked="#yesNoFormat(FORM.liveathomePartTime EQ 'Yes')#" > <label for="liveAtHomePartTimeYes">Yes</label>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <cfinput type="radio" name="liveathomePartTime" id="liveAtHomePartTimeNo" value="No" checked="#yesNoFormat(FORM.liveathomePartTime EQ 'No')#"> <label for="liveAtHomePartTimeNo">No</label>
                </td>
            </tr>
            <tr>
                <td class="label"><h3>Current School Attending</h3></td>
                <td>
                	<input type="text" class="largeField" name="school" maxlength="45" value="#FORM.school#"/>
                </td>
            </tr>
            <tr  bgcolor="##deeaf3" >
                <td class="label"><h3>Grade in School</h3></td>
                <td>
                    <select name="gradeInSchool" id="gradeInSchool" class="mediumField">
                        <option value=""></option>
                        <option value="Not-Applicable" <cfif FORM.gradeInSchool EQ "Not-Applicable"> selected</cfif>>Not Applicable</option>
                        <option value="Pre-Kindergarten" <cfif FORM.gradeInSchool EQ "Pre-Kindergarten"> selected</cfif> >Pre-Kindergarten</option>
                        <option value="Kindergarten" <cfif FORM.gradeInSchool EQ "Kindergarten"> selected</cfif>>Kindergarten</option>
                        <cfloop from="1" to="12" index="i">
                            <option value="#i#" <cfif FORM.gradeInSchool EQ i> selected</cfif>>
                                <cfswitch expression="#i#">
                                    <cfcase value="1">
                                        #i#st
                                    </cfcase>
                                    
                                    <cfcase value="2">
                                        #i#nd
                                    </cfcase>
                                    
                                    <cfcase value="3">
                                        #i#rd
                                    </cfcase>
                                    
                                    <cfdefaultcase>
                                        #i#th
                                    </cfdefaultcase>                        
                                </cfswitch>
                            </option>
                        </cfloop>
                        <option value="college" <cfif FORM.gradeInSchool EQ "college"> selected</cfif>>College</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="label"><h3>Current Employer</h3></td>
                <td><cftextarea name="employer" rows="3" cols="30" placeholder="Name, Title, Contact Info">#FORM.employer#</cftextarea></td>
            </tr>
            <tr  bgcolor="##deeaf3">
                <td class="label" valign="top" ><h3>Interests <span class="required">*</span></h3></td>
                <td><cftextarea name="interests" rows="5" cols="30" placeholder="Mountain biking, swimming, theatre, music, movies">#FORM.interests#</cftextarea></td>
            </tr>
            <tr>
                <td class="label" valign="top"><h3>Does this family member participate in any school sponsored activities? <span class="required">*</span></h3></td>
                <td>
                    <input type="radio" name="radioSchoolActivities" id="radioSchoolActivitiesYes" value="1" <cfif LEN(FORM.schoolActivities)> checked="checked" </cfif> onclick="document.getElementById('schoolActivitiesExplanation').style.display='table-row';" />
                    <label for="radioSchoolActivitiesYes">Yes</label>
               		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="radioSchoolActivities" id="radioSchoolActivitiesNo" value="n/a" <cfif FORM.schoolActivities EQ 'n/a'> checked="checked" </cfif> onclick="document.getElementById('schoolActivitiesExplanation').style.display='none';" />
                	<label for="radioSchoolActivitiesNo">No</label>
                </td>
            </tr>
            <tr id="schoolActivitiesExplanation" <cfif NOT LEN(FORM.schoolActivities) OR FORM.schoolActivities EQ 'n/a'>class="displayNone"</cfif> >
                <td colspan="2">
                	Please explain <span class="required">*</span><br />
            		<textarea name="schoolActivities" cols="70" rows="4">#FORM.schoolActivities#</textarea>
                </td>
            </tr>
        </table>

        <!--- Check if FORM submission is allowed --->
        <cfif APPLICATION.CFC.UDF.allowFormSubmission(section=URL.section)>
            <table border="0" cellpadding="4" cellspacing="0" width="100%" class="section">
                <tr>
                    <td align="right">
                        <!--- Finished with this page --->
                        <div style="margin:5px 25px 0 0; float:left;">
                            <a href="index.cfm?section=cbcAuthorization">No <cfif qGetAllFamilyMembers.recordcount neq 0>other</cfif> family members to add</a>
                        </div>
                    
                        <cfif VAL(qGetHostMemberInfo.childID)>
                            <a href="?section=familyMembers">
                            <img src="images/buttons/goBack_44.png" border="0"/></a> 
                            <input name="Submit" type="image" src="images/buttons/update_44.png" border="0"> 
                        <cfelse>
                            <input name="Submit" type="image" src="images/buttons/addMember.png" border="0">
                        </cfif> 
                    </td>
                </tr>
            </table>
		</cfif>
        
	</cfform>

</cfoutput>