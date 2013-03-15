<!--- ------------------------------------------------------------------------- ----
	
	File:		schoolInfo.cfm
	Author:		Marcus Melo
	Date:		November 6, 2012
	Desc:		Host Family Album

	Updated:	

----- ------------------------------------------------------------------------- --->

<cfsilent>

    <!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="extensions/customTags/gui/" prefix="gui" />	

	<!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <!--- School Dropdown --->
    <cfparam name="FORM.schoolID" default="">
    <!--- New School --->
    <cfparam name="FORM.newSchool" default="0">    
    <cfparam name="FORM.schoolname" default="">
    <cfparam name="FORM.address" default="">
    <cfparam name="FORM.address2" default="">
    <cfparam name="FORM.city" default="">
    <cfparam name="FORM.state" default="">
    <cfparam name="FORM.zip" default="">
    <cfparam name="FORM.principal" default="">
    <cfparam name="FORM.phone" default="">
    <cfparam name="FORM.email" default="">
    <cfparam name="FORM.type" default="">
    <cfparam name="FORM.tuition" default="">
    <cfparam name="FORM.numberofstudents" default="">
	<!--- School Details --->
    <cfparam name="FORM.schoolDistance" default="">
    <cfparam name="FORM.schoolWorks" default="">
    <cfparam name="FORM.schoolWorksExpl" default="">
    <cfparam name="FORM.schoolCoach" default="">
    <cfparam name="FORM.schoolCoachExpl" default="">
    <cfparam name="FORM.schoolTransportation" default="">
    <cfparam name="FORM.schoolTransportationOther" default="">
    <cfparam name="FORM.extraCuricTrans" default="">
	
    <cfscript>
		// Get States
		qGetStateList = APPLICATION.CFC.LOOKUPTABLES.getState();
	</cfscript>
    <cfset vSchoolSize = '0 - 200,200 - 500,500 - 1000,1000 - 2000, 2000 +'>
    
    <cfquery name="qGetLocalSchools" datasource="#APPLICATION.DSN.Source#">
        SELECT 
        	* 
        FROM 
        	smg_schools
        WHERE 
        	city = <cfqueryparam cfsqltype="cf_sql_varchar" value= "#qGetHostFamilyInfo.city#"> 
        AND 
        	state = <cfqueryparam cfsqltype="cf_sql_varchar" value= "#qGetHostFamilyInfo.state#">
        ORDER BY
        	schoolname
    </cfquery>
    
    <cfquery name="qGetAllSchools" datasource="#APPLICATION.DSN.Source#">
        SELECT 
        	* 
        FROM 
        	smg_schools
        WHERE 
        	state = <cfqueryparam cfsqltype="cf_sql_varchar" value= "#qGetHostFamilyInfo.state#"> 
        AND	
        	city != <cfqueryparam cfsqltype="cf_sql_varchar" value= "#qGetHostFamilyInfo.city#">
        ORDER BY 
        	city, 
            schoolname
    </cfquery>
    
	<cfif VAL(FORM.submitted)>
    
		<cfscript>
			// New School - Check for these fields
			if ( VAL(FORM.newSchool) ) {
				
				// Name of School
				if ( NOT LEN(TRIM(FORM.schoolname)) ) {
					SESSION.formErrors.Add("Please enter the name of the school.");
				}			
				// Number of students
				if ( NOT LEN(TRIM(FORM.numberofstudents)) ) {
					SESSION.formErrors.Add("Please indicate the size of this school.");
				}	
				// Address
				if ( NOT LEN(TRIM(FORM.address)) ) {
					SESSION.formErrors.Add("Please enter the address of the school.");
				}	
				
				// City
				if ( NOT LEN(TRIM(FORM.city)) ) {
					SESSION.formErrors.Add("Please enter the city the school is located in.");
				}			
				
				// State
				if ( NOT LEN(FORM.state) ) {
					SESSION.formErrors.Add("Please enter the state the school is located in.");
				}		
				
				// Zip
				if ( NOT LEN(TRIM(FORM.zip)) )  {
					SESSION.formErrors.Add("Please enter the school's zip code.");
				}	
				
				// type
				if ( NOT LEN(TRIM(FORM.type) ) )  {
					SESSION.formErrors.Add("Please indicate if this is a public or private school.");
				}
				
			} // New School - Check for these fields
		
			// School
			if ( NOT VAL(FORM.schoolID) AND NOT VAL(FORM.newSchool) ) {
				SESSION.formErrors.Add("You must select a school from the drop down list, if school is not listed, please click on +/- Our school is not listed above, I need to add it.");
			}
			
			// Works at School
			if ( NOT LEN(FORM.schoolWorks) ) {
				SESSION.formErrors.Add("Please indicate if any member of your household works for the high school.");
			}		
			
			// Explanation of who works at school
			if ( VAL(FORM.schoolWorks)  AND NOT LEN(TRIM(FORM.schoolWorksExpl)) ) {
				SESSION.formErrors.Add("You have indicated that someone works with the school, but didn't explain.  Please provide details regarding the posistion.");
			}	
			
			//Been contacted by coach
			if ( NOT LEN(FORM.schoolCoach) ) {
				SESSION.formErrors.Add("Please indicate if a coach has contacted you about hosting an exchange student.");
			}		
			
			// Coach explanation
			if ( VAL(FORM.schoolCoach) AND NOT LEN(TRIM(FORM.schoolCoachExpl)) ) {
				SESSION.formErrors.Add("You have indicated that a coach contacted you, but didn't explain.  Please provide details regarding this contact.");
			}	

			// School Distance
			if ( NOT LEN(TRIM(FORM.schoolDistance)) )  {
				SESSION.formErrors.Add("Please indicate how far is the school from your home.");
			}

			// Transportaion
			if ( NOT LEN(TRIM(FORM.schoolTransportation)) )  {
				SESSION.formErrors.Add("Please indicate how the student will get to school.");
			}

			// Other Transportation 
			if ( FORM.schooltransportation is 'other' AND NOT LEN(TRIM(FORM.schoolTransportationOther)) ) {
				SESSION.formErrors.Add("You indicated that the student will get to school but Other, but didn't specify what that other method would be.");
			}	
			
			// Extra Curricular Transportaion
			if ( NOT LEN(TRIM(FORM.extraCuricTrans)) )  {
				SESSION.formErrors.Add("Please indicate if you will provide transportation to extracuricular activities.");
			}
        </cfscript>
    	
        <!--- No Errors Found --->
		<cfif NOT SESSION.formErrors.length()>
        
            <!----Insert School Information---->
			<cfif VAL(FORM.newSchool)>
            
                <cfquery datasource="#APPLICATION.DSN.Source#" result="newRecord">
                    INSERT INTO 
                    	smg_schools
                    (
                    	schoolname,
                        address,
                        address2,
                        city,
                        state,
                        zip,
                        phone,
                        email,
                        principal,
                        type, 
                        tuition,
                        numberofstudents
					)								
                    VALUES 
                    (
                    	<cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.schoolname)#">, 
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.address)#">, 
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.address2)#">, 
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.city)#">, 
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.state)#">, 
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.zip)#">, 
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.phone)#">,
                    	<cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.email)#">, 
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.principal)#">, 
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.type)#">, 
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.tuition)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.numberofstudents)#">
                    )
                </cfquery>
            	
                <!--- Set School ID --->
                <cfset FORM.schoolID = newRecord.GENERATED_KEY>
            
            </cfif>

			<!--- Update School ID, transportation, relationships --->
            <cfquery datasource="#APPLICATION.DSN.Source#">
                UPDATE 
                	smg_hosts
                SET                 	
                    schoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.schoolID)#">,
                    schoolDistance = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.schoolDistance)#">,
                    schoolWorks = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.schoolWorks)#">,
                    schoolWorksExpl = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LEFT(TRIM(FORM.schoolWorksExpl), 300)#">,
                    schoolCoach = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.schoolCoach)#">,
                    schoolCoachExpl = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LEFT(TRIM(FORM.schoolCoachExpl), 300)#">,
                    schooltransportation = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.schoolTransportation)#">,
                    schoolTransportationOther = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.schoolTransportationOther)#">,
                    extraCuricTrans = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.extraCuricTrans)#">
                WHERE 
                	hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.CFC.SESSION.getHostSession().ID#">
            </cfquery>
    
            <cfscript>
				// Successfully Updated - Set navigation page
				Location(APPLICATION.CFC.UDF.setPageNavigation(section=URL.section), "no");
			</cfscript>
    
    	</cfif>
        
    <cfelse>	
    
		<cfscript>
			// Set FORM Values 
			FORM.schoolID = qGetHostFamilyInfo.schoolID;
			FORM.schoolDistance = qGetHostFamilyInfo.schoolDistance;
			FORM.schoolWorks = qGetHostFamilyInfo.schoolWorks;
			FORM.schoolWorksExpl = qGetHostFamilyInfo.schoolWorksExpl;
			FORM.schoolCoach = qGetHostFamilyInfo.schoolCoach;
			FORM.schoolCoachExpl = qGetHostFamilyInfo.schoolCoachExpl;
			FORM.schooltransportation = qGetHostFamilyInfo.schooltransportation;
			FORM.schoolTransportationOther = qGetHostFamilyInfo.schoolTransportationOther;
			FORM.extraCuricTrans = qGetHostFamilyInfo.extraCuricTrans;
        </cfscript>

    </cfif> 
	<cfquery name="qNumberOfStudents" datasource="#APPLICATION.DSN.Source#">
    	select numberofstudents
        from smg_schools
        where schoolid = <cfqueryparam cfsqltype="integer" value="#FORM.schoolID#">
    </cfquery>
    
</cfsilent>

<script type="text/javascript">
	$(document).ready(function(){
		$(".chzn-select").chosen(); 
		$(".chzn-select-deselect").chosen({allow_single_deselect:true}); 
	});
	
	function showSchoolInfo() {
		// Check if current state is visible
		var isVisible = $('#newSchoolDiv').is(':visible');
			
		if ( isVisible ) {
			// handle visible state
			$("#newSchool").val(0);
			$("#newSchoolDiv").fadeOut("slow");
		} else {
			// handle non visible state
			$("#newSchool").val(1);
			$("#newSchoolDiv").fadeIn("slow");
		}

	}
</script>

<cfoutput>

	<h2>School Infomation</h2>
	
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
        
    <cfform action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
        <input type="hidden" name="submitted" value="1" />
        <input type="hidden" name="newSchool" id="newSchool" value="#FORM.newSchool#" />

        The following schools are in your state. The top of the list are schools in your city, followed by schools with in the state.  
        If you start typing in your school name, the list will filter.  
        If your school is not in the list, please lick the link "Our school is not listed above, I need to add it." and enter your school. <br /><br />

		<span class="required">* Required fields</span>
                
        <table width="100%" cellspacing="0" cellpadding="2" class="border">
            <tr>
                <td class="label">School: <span class="required">*</span></td>
                <td class="form_text">
                    <select name="schoolID" id="schoolID" data-placeholder="Start typing your school name..." class="chzn-select" style="width:350px;" tabindex="2" onchange="this.form.submit(closeCity);">
                        <option value="" <cfif NOT LEN(FORM.schoolID)> selected="selected" </cfif> ></option>
                        <option value="">-----Schools in your city-----</option>
                        <cfloop query="qGetLocalSchools">
                            <option value="#qGetLocalSchools.schoolID#" <cfif FORM.schoolID EQ qGetLocalSchools.schoolID>selected</cfif>>#qGetLocalSchools.schoolname# - #qGetLocalSchools.city#, #qGetLocalSchools.state#</option>
                        </cfloop>
                        <option value="">-----All other schools-----</option>
                        <cfloop query="qGetAllSchools">
                            <option value="#qGetAllSchools.schoolID#" <cfif FORM.schoolID EQ qGetAllSchools.schoolID>selected</cfif>>#qGetAllSchools.schoolname# - #qGetAllSchools.city#, #qGetAllSchools.state#</option>
                        </cfloop> 
                    </select>
				</td>  
                <td>Number of Students: <Cfif qNumberOfStudents.numberofstudents eq 0><em>Not Available</em><Cfelse>#qNumberOfStudents.numberofstudents#</Cfif></td>                  
            </tr>
        </table> <br />
        
        <a onclick="showSchoolInfo();" href="##">+/- Our school is not listed above, I need to add it.</a> <br /><br />
        
        <div id="newSchoolDiv" <cfif NOT VAL(FORM.newSchool)> class="displayNone" </cfif> >  
             
            <h2>School Information</h2>
            
            <table width="100%" cellspacing="0" cellpadding="2" class="border">
                <tr bgcolor="##deeaf3">
                	<td class="label"><h3>School Name <span class="required">*</span></h3></td>
                    <td class="form_text" colspan="3"><input type="text" name="schoolname" class="largeField" value="#FORM.schoolname#" maxlength="100"></td>
                    
                </tr>
                 <tr>
                	<td class="label"><h3>School Size <span class="required">*</span></h3></td>
                    <td  colspan="3">
                    	<select name="numberofstudents">
                    	<option value=""></option>
                        <Cfloop list="#vSchoolSize#" index=i>
                        	 <option value="#i#" <cfif form.numberofstudents is #i#>selected</cfif>>#i#</option>
                        </Cfloop>
                        </select>
                    </td>
                </tr>
                <tr bgcolor="##deeaf3">
                	<td class="label" ><h3>Address <span class="required">*</span></h3></td>
                    <td colspan="3" class="form_text"><input type="text" name="address" class="largeField" value="#FORM.address#" maxlength="100"></td>
                </tr>
                <tr bgcolor="##deeaf3">
                	<td></td>
                    <td colspan="3" class="form_text"> <input type="text" name="address2" class="largeField" value="#FORM.address2#" maxlength="100"></td>
                </tr>
                <tr>			 
                	<td class="label"><h3>City <span class="required">*</span></h3></td>
                    <td colspan="3" class="form_text"><input type="text" name="city" class="largeField" value="#FORM.city#" maxlength="100"></td>
                </tr> 
                <tr  bgcolor="##deeaf3">	
               		<td class="label"><h3>State <span class="required">*</span></h3></td>
                    <td width="10" class="form_Text">
                		<select name="state" id="state" class="mediumField">
                        	<option value=""></option>
                            <cfloop query="qGetStateList">
                            	<option value="#qGetStateList.state#" <cfif FORM.state EQ qGetStateList.state> selected="selected" </cfif> >#qGetStateList.statename#</option>
                            </cfloop>
                        </select>
                	</td>
                    <td class="zip"><h3>Zip <span class="required">*</span></h3></td>
                    <td class="form_text"><input type="text" name="zip" class="smallField" value="#FORM.zip#" maxlength="10"></td>
                </tr>
                <tr>
                    <td class="label"><h3>Contact</h3></td>
                    <td class="form_text" colspan="3"><input type="text" name="principal" class="largeField" value="#FORM.principal#" maxlength="100"></td>
                </tr>
                <tr  bgcolor="##deeaf3"> 			
                	<td class="label"><h3>Phone</h3></td>
                    <td class="form_text" colspan="3"><cfinput type="text" name="phone" class="largeField" value="#FORM.phone#" placeholder="(999) 999-9999" mask='(999) 999-9999' maxlength="14"></td>
                </tr>
                <tr>
                	<td class="label"><h3>Contact Email</h3></td>
                    <td class="form_text" colspan="3"> <input name="email" class="largeField" type="text" value="#FORM.email#" placeholder="contact@school.edu" maxlength="100"></td>
                </tr>
                <tr  bgcolor="##deeaf3">
                	<td class="label"><h3>School Type <span class="required">*</span></h3></td>
                	<td  colspan="3">
                    	<input type="radio" value="public" name="type" id="typePublic" <cfif FORM.type EQ 'public'>checked</cfif> /> <label for="typePublic">Public</label>
                        &nbsp;&nbsp; 
                        <input type="radio" value="private" name="type" id="typePrivate" <cfif FORM.type EQ 'private'>checked</cfif>   /> <label for="typePrivate">Private</label>  
                    </td>
                </tr>
                <tr>
                	<td class="label"><h3>School Fees</h3></td>
                    <td  colspan="3"><input type="text" name="tuition" class="largeField" placeholder="amount of tution or fees" value="#FORM.tuition#" maxlength="45" /></td>
                </tr>
                
            </table> 
            
            <br />
        </div>
        
        <h3>Relationships</h3>
        
        <table width="100%" cellspacing="0" cellpadding="2" class="border">
            <tr bgcolor="##deeaf3">
            	<td class="label">Does any member of your household work for the high<br /> school in a coaching/teaching/administrative capacity? <span class="required">*</span></td>
                <td>
                    <cfinput type="radio" name="schoolWorks" id="schoolWorks1" value="1" checked="#FORM.schoolWorks EQ 1#" onclick="document.getElementById('showSchoolWorks').style.display='table-row';" />
                    <label for="schoolWorks1">Yes</label>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <cfinput type="radio" name="schoolWorks" id="schoolWorks0" value="0" checked="#FORM.schoolWorks EQ 0#" onclick="document.getElementById('showSchoolWorks').style.display='none';" />
                    <label for="schoolWorks0">No</label>
                </td>
            </tr>
            <tr>
                <td align="left" colspan="2" id="showSchoolWorks" <cfif FORM.schoolWorks NEQ 1>class="displayNone"</cfif>>
					 <br /> <strong>Job Title & Duties <span class="required">*</span></strong> <br />
                    <textarea name="schoolWorksExpl" class="xLargeTextArea">#FORM.schoolWorksExpl#</textarea>
				</td>
            </tr>   
            <tr>
                <td class="label">Has any member of your household had contact with a coach<br /> regarding the hosting of an exchange student with a particular athletic ability? <span class="required">*</span></td>
                <td>
                    <cfinput type="radio" name="schoolCoach" id="schoolCoach1" value="1" checked="#FORM.schoolCoach EQ 1#" onclick="document.getElementById('showCoachExpl').style.display='table-row';" />
                    <label for="schoolCoach1">Yes</label>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <cfinput type="radio" name="schoolCoach" id="schoolCoach0" value="0" checked="#FORM.schoolCoach EQ 0#" onclick="document.getElementById('showCoachExpl').style.display='none';" />
                    <label for="schoolCoach0">No</label>
                </td>
            </tr>
            <tr>
            	<td align="left" colspan="2" id="showCoachExpl" <cfif FORM.schoolCoach NEQ 1>class="displayNone"</cfif>>
                	<br /> <strong>Please describe <span class="required">*</span></strong> <br />
                    <textarea name="schoolCoachExpl" class="xLargeTextArea">#FORM.schoolCoachExpl#</textarea>
               	</td>
            </tr>
        </table> <br />
        
        <h3>Transportation</h3>
        
        <table width="100%" cellspacing="0" cellpadding="4" class="border">
            <tr bgcolor="##deeaf3">
                <td class="label">How far is the school from your home? <span class="required">*</span></td>
                <td colspan="2"><input type="text" name="schoolDistance" id="schoolDistance" class="smallField" value="#FORM.schoolDistance#" /> (miles)</td>
            </tr>
            <tr>
            	<td colspan="3">
                	<strong>How will the student get to school? </strong> <span class="required">*</span>
                </td>
			</tr>                
            <tr bgcolor="##deeaf3">
                <td class="label"><cfinput type="radio" name="schoolTransportation" id="schoolTransportation1"  value="School Bus"  checked="#FORM.schoolTransportation EQ 'School Bus'#"><label for="schoolTransportation1">School Bus</label></td>
                <td class="form_text"><cfinput type="radio" name="schoolTransportation" id="schoolTransportation2" value="Car" checked="#FORM.schoolTransportation EQ 'Car'#"><label for="schoolTransportation2">Car</label></td>
                <td class="form_text"><cfinput type="radio" name="schoolTransportation" id="schoolTransportation3" value="Walk" checked="#FORM.schoolTransportation EQ 'Walk'#"><label for="schoolTransportation3">Walk</label></td>
            </tr>
            <tr>
                <td class="label"><cfinput type="radio" name="schoolTransportation" value="Public Transportation" checked="#FORM.schoolTransportation EQ 'Public Transportation'#">Public Transportation<br /></td>
                <td>
                	<cfinput type="radio" name="schoolTransportation" value="Other" checked="#FORM.schoolTransportation EQ 'Other'#" > 
                    Other: <cfinput type="text" name="schoolTransportationOther" class="mediumField" value="#FORM.schoolTransportationOther#" maxlength="100"> 
                </td>
                <td>&nbsp;</td>
            </tr>
            <tr bgcolor="##deeaf3">
                <td class="label" colspan="2">Will you provide transportation for extracurricular activities? <span class="required">*</span></td>
                <td>
                    <cfinput type="radio" name="extraCuricTrans" id="extraCuricTrans1" value="1" checked="#FORM.extraCuricTrans EQ 1#" />
                    <label for="extraCuricTrans1">Yes</label>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <cfinput type="radio" name="extraCuricTrans" id="extraCuricTrans0" value="0" checked="#FORM.extraCuricTrans EQ 0#" />
                    <label for="extraCuricTrans0">No</label>
                </td>
            </tr>
        </table>

        <!--- Check if FORM submission is allowed --->
        <cfif APPLICATION.CFC.UDF.allowFormSubmission(section=URL.section)>
            <table border="0" cellpadding="4" cellspacing="0" width="100%" class="section">
                <tr>
                    <td align="right"><input name="Submit" type="image" src="images/buttons/Next.png" border="0"></td>
                </tr>
            </table>
		</cfif>
                
	</cfform>

</cfoutput>