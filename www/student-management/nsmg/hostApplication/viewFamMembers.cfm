<link href="../linked/css/baseStyle.css" rel="stylesheet" type="text/css" />
<link href="css/hostApp.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="chosen/chosen.css" />
<!--- Import CustomTag Used for Page Messages and Form Errors --->
<cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

<cfinclude template="approveDenyInclude.cfm">

<!--- not defined if not selected. --->
	<cfparam name="form.name" default="">
    <cfparam name="form.birthdate" default="">
    <cfparam name="form.membertype" default="">
    <cfparam name="form.interests" default="">
    <cfparam name="form.sex" default="">
    <cfparam name="form.liveathome" default="">
    <cfparam name="form.liveathomePartTime" default="">
    <cfparam name="form.employer" default="">
    <cfparam name="url.childid" default="">
    <cfparam name="form.gradeInSchool" default="">    

<cfquery name="localInfo" datasource="MySQL">
	select city,state,zip
	from smg_hosts
	where hostid = #client.hostid#
</cfquery>
<cfquery name="get_schools" datasource="MySQL">
select * from smg_schools
where (city = "#localInfo.city#") and (state = "#localInfo.state#")
</cfquery>
<cfquery name="get_host_school" datasource="MySQL">
select smg_hosts.schoolid, smg_schools.schoolname, smg_schools.address, smg_schools.address2, smg_schools.principal,smg_schools.city, smg_schools.state, smg_schools.zip
from smg_hosts 
left join smg_schools on smg_schools.schoolid = smg_hosts.schoolid
where smg_hosts.hostid = #client.hostid#
</cfquery>
<cfquery name="get_local_schools" datasource="MySQL">
select * from smg_schools
where (city = <cfqueryparam cfsqltype="cf_sql_varchar" value= "#localInfo.city#"> AND state = <cfqueryparam cfsqltype="cf_sql_varchar" value= "#localInfo.state#">)
order by schoolname
</cfquery>
<cfquery name="get_all_schools" datasource="MySQL">
select * from smg_schools
where state = <cfqueryparam cfsqltype="cf_sql_varchar" value= "#localInfo.state#"> and city != <cfqueryparam cfsqltype="cf_sql_varchar" value= "#localInfo.city#">
order by city, schoolname
</cfquery>
<Cfif isDefined('url.delete_child')>
	<cfquery datasource="mysql">
    delete from smg_host_children
    where childid = #url.delete_child#
    limit 1
    </cfquery>

</Cfif>
<cfif url.childid EQ "">
	<cfset new = true>
<cfelse>
	<cfquery name="verifyFam" datasource="mysql">
    select hostid
    from smg_host_children
    where childid = #url.childid#
    </cfquery>
   
	<cfif not isNumeric(url.childid)>
        A numeric childid is required to edit a family member.
        <cfabort>
	</cfif>
	<cfset new = false>
</cfif>

<cfoutput>

</cfoutput>
<cfif new>
	<cfparam name="url.hostid" default="#client.hostid#">
	<cfif not isNumeric(url.hostid)>
        a numeric hostid is required to add a new school date.
        <cfabort>
	</cfif>
</cfif>

<cfset field_list = 'name,sex,birthdate,membertype,liveathome,school'>
<cfset errorMsg = ''>

<!--- Process Form Submission --->
<cfif isDefined("form.submitted")>
<Cfif form.birthdate is not ''>
	<cfset bddate = "#Datediff('yyyy',form.birthdate, now())#">
<cfelse>
	<cfset bddate = 0>
</Cfif>
 <cfscript>
			// Name of School
            if ( NOT LEN(TRIM(FORM.name)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter the Name.");
            }			
        	
			// Address
            if ( NOT LEN(TRIM(FORM.sex)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please select the Sex.");
            }	
			// Name of School
            if ( NOT LEN(TRIM(FORM.birthdate)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter a valid Date of Birth.");
            }			
        	
			// Address
            if ( NOT LEN(TRIM(FORM.membertype)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter the Relation.");
            }	
			// Address
            if ( NOT LEN(TRIM(FORM.interests)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter some interests for this person.");
            }
			// Name of School
            if ( NOT LEN(TRIM(FORM.liveathome)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate if person is living at home.");
            }	
					// Name of School
            if ( NOT LEN(TRIM(FORM.liveathomePartTime)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate if living at home at all durring the exchange period.");
            }	
			// Birthdate
            if (bddate gt 120 ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("The birthdate indicates the person is over 120 years old.  Please check the birthdate.");				
            }	
		// Birthdate
            if (bddate lte 0 ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("The birthdate indicates this person has not been born yet.");				
            }	
			// Address
            if ( NOT LEN(TRIM(FORM.birthdate)) OR FORM.birthdate eq 0) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter the birthdate.");				
            }
</cfscript>

	
    
	
	
<cfif NOT SESSION.formErrors.length()>
		<cfif new>
       
            <cfquery datasource="mysql">
                INSERT INTO smg_host_children (hostid, name, sex, birthdate, membertype, liveathome, liveathomePartTime, interests, school, employer, gradeInSchool)
                VALUES (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#url.hostid#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.name#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.sex#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#form.birthdate#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.membertype#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.liveathome#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.liveathomePartTime#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.interests#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#form.school#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.employer#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.gradeInSchool#">
                
                )  
            </cfquery>
		<!--- edit --->
		<cfelse>
			<cfquery datasource="mysql">
				UPDATE smg_host_children SET
                name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.name#">,
                sex = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.sex#">,
                birthdate = <cfqueryparam cfsqltype="cf_sql_date" value="#form.birthdate#">,
                membertype = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.membertype#">,
                liveathome = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.liveathome#">,
                liveathomePartTime = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.liveathomePartTime#">,
                school = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.school#">,
                employer = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.employer#">,
                interests = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.interests#">,
                gradeInSchool = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.gradeInSchool#">
				WHERE childid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.childid#">
			</cfquery>
		</cfif>
        
     
	</cfif>

<!--- add --->
<cfelseif new>

	<cfloop list="#field_list#" index="counter">
    	<cfset "form.#counter#" = "">
	</cfloop>
        
<!--- edit --->
<cfelseif not new>

	<cfquery name="get_record" datasource="mysql">
		SELECT *, smg_schools.schoolname
		FROM smg_host_children
        LEFT JOIN smg_schools on smg_schools.schoolid = smg_host_children.school
		WHERE childid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.childid#">
	</cfquery>
	
     <cfscript>
			 // Set FORM Values   
			
			FORM.birthdate = get_record.birthdate;
			FORM.employer = get_record.employer;
			FORM.interests = get_record.interests;
			FORM.liveathome = get_record.liveathome;
			FORM.liveathomePartTime = get_record.liveathomePartTime;
			FORM.memberType = get_record.memberType;
			FORM.name = get_record.name;
			FORM.sex = get_record.sex;
			FORM.school = get_record.school;
			FORM.gradeInSchool = get_record.gradeInSchool;
			
	</cfscript>
    
    <!--- hostid is passed in the url for a new date, but set it for edit. --->
    <cfset url.hostid = get_record.hostid>

</cfif>

<cfif errorMsg NEQ ''>
	<script language="JavaScript">
        alert('<cfoutput>#errorMsg#</cfoutput>');
    </script>
</cfif>






<h2>Current Family Members</h2>
<cfquery name="qFamilyMembers" datasource="mysql">
select *, smg_schools.schoolname
from smg_host_children
LEFT JOIN smg_schools on smg_schools.schoolid = smg_host_children.school
where hostid = #client.hostid#
</cfquery>
<Cfif qFamilyMembers.recordcount eq 0>
	No Members added.
</cfif>
<cfoutput>
	<!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="tableSection"
        />
<table width=100% cellspacing=0 cellpadding=2 class="border">
   <Tr>
   	<Th align="left">Name</Th>
   	<Th align="left">Gender</Th><Th align="left">Date of Birth</th><Th align="left">Relation</Th><Th align="left">At Home?</th><Th align="left">School</th><th align="left">Grade</th><th></th>
    </Tr>
   <Cfif qFamilyMembers.recordcount eq 0>
    <tr>
    	<td colspan=8>Currently, no other family members are indicated as living in your home.</td>
    </tr>
    <cfelse>
    <Cfloop query="qFamilyMembers">
    <tr <Cfif currentrow mod 2> bgcolor="##deeaf3"</cfif>>
    	<Td><h3><p class=p_uppercase>#name#</h3></Td>
        <td><h3><p class=p_uppercase>#sex#</h3></td>
        <Td><h3>#DateFormat(birthdate, 'mmm d, yyyy')#</h3></Td>
        <td><h3><p class=p_uppercase>#membertype#</h3></td>
        <td><h3><p class=p_uppercase> <cfif liveathome is 'yes'>Yes<cfelseif liveathome is 'no' and liveathomePartTime is 'yes'>Part Time<cfelse>No</cfif> </h3></td>
        <td><h3><p class=p_uppercase>#schoolname#</h3></td>
        <td><h3><p class=p_uppercase>#gradeInSchool#</h3></td>
        <Td><a href="viewFamMembers.cfm?childid=#childid#&itemid=#url.itemid#"><img src="../pics/buttons/pencilBlue23x29.png" border=0 height=20/></a> <a href="viewFamMembers.cfm?childid=#qFamilyMembers.childid#&hostid=#url.hostid#&itemid=#url.itemid#&delete_child=#qFamilyMembers.childid#" onClick="return confirm('Are you sure you want to delete this Family Member?')"> <img src="../pics/buttons/delete23x28.png" height=20 border=0/></a></Td>
    </tr>
    </Cfloop>
    </cfif>
   </table>
	
</cfoutput>
<cfset gradeList = 'n/a,1st,2nd,3rd,4th,5th,6th,7th,8th,9th,10th,11th,12th'>
<cfform action="viewFamMembers.cfm?childid=#url.childid#&hostid=#url.hostid#&itemid=#url.itemid#" method="post" preloader="no">
<input type="hidden" name="submitted" value="1">
<br><br>
<table width=100%>
	<Tr>
    	<td>
<h2>Family Members </h2>
		</td>
        <td align="right">
   
        </td>
</table>

<table width=100% cellspacing=0 cellpadding=2 class="border">
    <tr>
    	<td class="label"><h3>Name<span class="redtext">*</span></h3></td>
        <td><cfinput type="text" name="name" value="#form.name#" size="20" maxlength="50" message="Please enter the Name."></td>
    </tr>
    <tr bgcolor="#deeaf3">
    	<td class="label"><h3>Gender <span class="redtext">*</span></h3></td>
        <td>
        	<cfinput type="radio" name="sex" value="Male" checked="#yesNoFormat(form.sex EQ 'Male')#">Male
            <cfinput type="radio" name="sex" value="Female" checked="#yesNoFormat(form.sex EQ 'Female')#">Female
        </td>
    </tr>
    <tr>
    	<td class="label"><h3>Date of Birth <span class="redtext">*</span></h3></td>
        <td><cfinput type="text" name="birthdate" value="#dateFormat(form.birthdate, 'mm/dd/yyyy')#" size="12" maxlength="10" placeholder="MM/DD/YYYY" mask="99/99/9999"></td>
    </tr>
    <tr bgcolor="#deeaf3">
    	<td class="label"><h3>Relation<span class="redtext">*</span></h3> </td>
        <td><cfinput type="text" name="membertype" value="#form.membertype#" size="20" maxlength="150"></td>
    </tr>
    <tr>
    	<td class="label"><h3>Living at Home <span class="redtext">*</span></h3></td>
        <td>
           <label>
            <cfinput type="radio" name="liveathome" value="Yes" checked="#yesNoFormat(form.liveathome EQ 'Yes')#"/>Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="liveathome" value="No" checked="#yesNoFormat(form.liveathome EQ 'No')#"/>No
            </label> 
        </td>    
    </tr>
    <tr bgcolor="#deeaf3" >
    	<td class="label"><h3>Will this person live at the home at any<br /> 
    	time during the exchange period?<br />
        <font size=-1> (i.e. college students home for holiday, etc)</font> <span class="redtext">*</span></h3></td>
        <td>
        	<cfinput type="radio" name="liveathomePartTime" value="Yes" checked="#yesNoFormat(form.liveathomePartTime EQ 'Yes')#" > Yes &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <cfinput type="radio" name="liveathomePartTime" value="No" checked="#yesNoFormat(form.liveathomePartTime EQ 'No')#">No 

        </td>
        
    </tr>
        <tr >
    	<td class="label"><h3>Current School Attending</h3></td>
        <td>
        <!----
        <cfoutput>
        	<select name="school">
            	
                <option value='-1' selected>Not Applicable</option>
                <option value=0>Other</option>
                <cfloop query="get_schools">
                    <option value=#schoolid#<cfif form.school eq #get_schools.schoolid#> selected</cfif>>#schoolname#</option>
                </cfloop>
                
               
			</select>
         </cfoutput>
		 ---->
         <cfoutput>
            <select data-placeholder="Start typing your school name..." class="chzn-select" style="width:350px;" tabindex="2" name="school" onchange="this.form.submit(closeCity);">
               <option value=""></option>
                    <option value="">-----Schools in your city-----</option>
                <Cfloop query="get_local_schools">
                    <option value="#schoolid#" <cfif form.school is #get_local_schools.schoolid#>selected</cfif>>#schoolname# - #city#, #state#</option>
                </Cfloop>
                <option value="">-----All other schools-----</option>
                   <Cfloop query="get_all_schools">
                    <option value="#schoolid#" <cfif form.school is #get_all_schools.schoolid#>selected</cfif>>#schoolname# - #city#, #state#</option>
                </Cfloop> 
                </select> 
          </cfoutput>
        </td>
        
    </tr>
     <tr  bgcolor="#deeaf3" >
    	<td class="label"><h3>Grade in School</h3></td>
        <td>
        <Cfoutput>
        <select name="gradeInSchool">
        
        <cfloop list="#gradeList#" index=i>
        <option value='#i#' <cfif form.gradeInSchool eq #i#>selected</cfif>>#i#</option>
        </cfloop>
        </select> 
        </Cfoutput>   
        </td>
        
    </tr>
            <tr>
    	<td class="label"><h3>Current Employer</h3></td>
        <td>
        <cfoutput>
       <cftextarea name="employer" rows="3" cols="25" placeholder="Name, Title, Contact Info">#form.employer#</cftextarea>
       </cfoutput>
            
        </td>
        
    </tr>
    <tr  bgcolor="#deeaf3">
    	<td class="label" valign="top" ><h3>Interests <span class="redtext">*</span></h3></td>
        <td>
       <cfoutput>
       <cftextarea name="interests" rows="5" cols="25" placeholder="Mountain biking, swimming, theatre, music, movies">#form.interests#</cftextarea>
       </cfoutput>
        </td>
        
    </tr>
</table>

	</td>
	</tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100%>
	<tr>
    	<cfif not new>
			<td></td>
        </cfif>
		<td align="right">
		<Cfif url.childid is not ''><a href="?page=familyMembers">
        	<img src="../pics/buttons/goBack_44.png" border=0/></a> 
            <input name="Submit" type="image" src="../pics/buttons/update_44.png" border=0> 
        <cfelse>
        	<input name="Submit" type="image" src="../pics/buttons/addMember.png" border=0>
        </Cfif> 
        <!----
        <br />
        
         <a onclick="ShowHide2(); return false;" href="##">
         I am finished entering family members.</a>
<div id="slidingDiv2" display:"none">
        <A href="index.cfm?page=familyQuestionInterupt"><img src="../images/buttons/Next.png" border="0" /></A>	</div>
		----->
		</td>
	</tr>
</table>

</cfform>

<cfinclude template="approveDenyButtonsInclude.cfm">
 <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js" type="text/javascript"></script>
  <script src="chosen/chosen.jquery.js" type="text/javascript"></script>
  <script type="text/javascript"> $(".chzn-select").chosen(); $(".chzn-select-deselect").chosen({allow_single_deselect:true}); </script>



