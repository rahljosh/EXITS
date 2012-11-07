<Cfparam name="form.school" default="na">
<cfparam name="form.schoolWorks" default="3">
<cfparam name="form.schoolWorksExpl" default="">
<cfparam name="form.schoolCoach" default="3">
<cfparam name="form.schoolCoachExpl" default="">
<cfparam name="form.schoolTransportation" default="">
<cfparam name="form.schoolTransportationother" default="">
<cfparam name="form.schoolname" default="">
<cfparam name="form.address" default="">
<cfparam name="form.address2" default="">
<cfparam name="form.city" default="">
<cfparam name="form.state" default="">
<cfparam name="form.zip" default="">
<Cfparam name="form.school" default="na">
<Cfparam name="form.principal" default="">
<Cfparam name="form.phone" default="">
<Cfparam name="form.email" default="">
<Cfparam name="form.extraCuricTrans" default="">
<cfparam name="form.schoolType" default="">
<cfparam name="form.schoolFees" default="">


<cfquery name="local" datasource="MySQL">
	select city,state,zip
	from smg_hosts
	where hostid = #client.hostid#
</cfquery>

<cfquery name="get_schools" datasource="MySQL">
select * from smg_schools
where (city = "#local.city#")and (state = "#local.state#")
</cfquery>
<cfquery name="get_host_school" datasource="MySQL">
select smg_hosts.schoolid, smg_schools.schoolname, smg_schools.address, smg_schools.address2, smg_schools.principal,smg_schools.city, smg_schools.state, smg_schools.zip, smg_schools.phone, smg_schools.email, smg_schools.tuition, smg_schools.type
from smg_hosts 
left join smg_schools on smg_schools.schoolid = smg_hosts.schoolid
where smg_hosts.hostid = #client.hostid#
</cfquery>
<cfquery name="qGetHostInfo" datasource="MySQL">
select schoolWorks, schoolWorksExpl, schoolCoach, schoolCoachExpl, schooltransportation, schooltransportationother,extraCuricTrans, schoolid
from smg_hosts
where hostid = #client.hostid#
</cfquery>
<cfquery name="hostKids" datasource="MySQL">
select *
from smg_host_children
where hostid = #client.hostid#
</cfquery>

<!--- Import CustomTag Used for Page Messages and Form Errors --->
<cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	


<Cfif isDefined('form.process')>
	<cfif not val(form.school)>
	
    <cfscript>
			// Name of School
            if ( NOT LEN(TRIM(FORM.schoolname)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter the name of the school.");
            }			
        	
			// Address
            if ( NOT LEN(TRIM(FORM.address)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter the address of the school.");
            }	
			
			// City
            if ( NOT LEN(TRIM(FORM.city)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter the city the school is located in.");
            }			
        	
        	// State
            if ( NOT LEN(TRIM(FORM.state)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter the state the school is located in.");
            }		
			
			// Zip
            if ( NOT LEN(TRIM(FORM.zip)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter the school's zip code.");
            }	
				// type
            if (NOT LEN(TRIM(FORM.schoolType)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate if this is a public or private school.");
            }
			
	   </cfscript>
   </cfif>
       <cfscript>
        	// Works at School
            if ( form.schoolWorks EQ 3 ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate if any member of your household works for the high school.");
            }		
			
			// Explanation of who works at school
            if ( (form.schoolWorks EQ 1) AND (NOT LEN(TRIM(FORM.schoolWorksExpl))) ) {
              // Get all the missing items in a list
                SESSION.formErrors.Add("You have indicated that someone works with the school, but didn't explain.  Please provide details regarding the posistion.");
            }	
			//Been contacted by coach
			if ( form.schoolCoach EQ 3 ) {
               // Get all the missing items in a list
               SESSION.formErrors.Add("Please indicate if a coach has contacted you about hosting an exchange student.");
            }		
			
			// Coach explanation
            if ( (form.schoolCoach EQ 1) AND (NOT LEN(TRIM(FORM.schoolCoachExpl))) ) {
              // Get all the missing items in a list
                SESSION.formErrors.Add("You have indicated that a coach contacted you, but didn't explain.  Please provide details regarding this contact.");
            }	
			
			
			// Other Transportation 
            if ( (form.schooltransportation is 'other') AND (NOT LEN(TRIM(FORM.other_desc))) ) {
              // Get all the missing items in a list
                SESSION.formErrors.Add("You indicated that the student will get to school but Other, but didn't specify what that other method would be.");
            }	
     	   // Transportaion
            if (NOT LEN(TRIM(FORM.schoolTransportation)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate how the student will get to school.");
            }
			// Extra Curricular Transportaion
            if (NOT LEN(TRIM(FORM.extraCuricTrans)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate if you will provide transportation to extracuricular activities.");
            }
		
        </cfscript>
        
        <cfif NOT SESSION.formErrors.length()>
        		<!----Insert transportion, relationships---->
                <cfquery name="insert_transportation" datasource="MySQL">
                update smg_hosts
                set 
                schoolWorks = "#form.schoolWorks#",
                schoolWorksExpl = "#form.schoolWorksExpl#",
                schoolCoach = "#form.schoolCoach#",
                schoolCoachExpl = "#form.schoolCoachExpl#",
                schooltransportation = "#form.schoolTransportation#",
                schooltransportationother = "#form.other_desc#",
                extraCuricTrans = "#form.extraCuricTrans#"
                where hostid = #client.hostid#
                </cfquery>
 			<!----Insert School Information---->
           
           
   			<cfif form.school is 'na'>
           			 <cfquery name="insert_school" datasource="MySQL">
                        INSERT INTO smg_schools
                            (schoolname,address,address2,city,state,zip,phone,email,principal,type, tuition <!----,url,---->)								
                        VALUES ("#form.schoolname#", "#form.address#", "#form.address2#", "#form.city#", "#form.state#", "#form.zip#", "#form.phone#",
                                 "#form.email#", "#form.principal#", "#form.schoolType#", "#form.schoolFees#"<!---- "#form.url#",---->)
                    </cfquery>
                
                    <cfquery name="schoolid" datasource="MySQL"> <!--- get the newest school --->
                        SELECT MAX(schoolid) as newschoolid
                        FROM smg_schools
                    </cfquery>
                    
                    <cfquery name="add_School" datasource="MySQL">
                    update smg_hosts
                    set schoolid = '#schoolid.newschoolid#'
                    where hostid = '#client.hostid#'
                    LIMIT 1 
                    </cfquery>	
            <cfelse>
                <cfquery name="add_School" datasource="MySQL">
                update smg_hosts
                set schoolid = '#form.school#'
                where hostid = '#client.hostid#'
                LIMIT 1 
                </cfquery>	
                
            </cfif>

        
          <Cflocation url="index.cfm?page=communityProfile">
       
  		</cfif>
<Cfelse>	
<!----The first time the page is loaded, pass in current values, if they exist.---->
	 <cfscript>
			// Set FORM Values   
			FORM.schoolName = get_host_school.schoolName;
			FORM.address = get_host_school.address;
			FORM.address2 = get_host_school.address2;
			FORM.city = get_host_school.city;
			FORM.state = get_host_school.state;
			FORM.zip = get_host_school.zip;
			FORM.schoolWorks = qGetHostInfo.schoolWorks;
			FORM.schoolWorksExpl = qGetHostInfo.schoolWorksExpl;
			FORM.schoolCoach = qGetHostInfo.schoolCoach;
			FORM.schoolCoachExpl = qGetHostInfo.schoolCoachExpl;
			FORM.schooltransportation = qGetHostInfo.schooltransportation;
			FORM.schooltransportationother = qGetHostInfo.schooltransportationother;
			FORM.extraCuricTrans = qGetHostInfo.extraCuricTrans;
			FORM.school = qGetHostInfo.schoolid;
			FORM.principal = get_host_school.principal;
			FORM.phone = get_host_school.phone;
			FORM.email = get_host_school.email;
			FORM.schoolType = get_host_school.type;
			FORM.schoolFees = get_host_school.tuition;
	 </cfscript>
</cfif> 
 

<Cfoutput>

<cfform method="post" action="index.cfm?page=schoolInfo">
<input type="hidden" name="process" />

<!----
<cfparam name="form.phone" default="">
<cfparam name="form.fax" default="">
<cfparam name="form.email" default="">
<cfparam name="form.url" default="">
<cfparam name="form.principal" default="">
---->

<div class="application_section_header"><h2>School Infomation</h2></div>
	<!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="section"
        />


<cfif get_Schools.recordcount is 0>
We do not have any schools in <Cfoutput>#local.city# #local.state#</Cfoutput> in our database.  Please add the following information for the school that the student will be attending.
<cfelse>
The following schools are in your city, if the student will be attending a school from the list, please select it.  If the school is not found, please enter 
the information for the school that the student will be attending.
  <table width=100% cellspacing=0 cellpadding=2 class="border">
    <tr>
        <td class="label">School: </td><td class="form_text"><select name="school">
						<option value='na' selected>
						<cfloop query="get_schools">
						   	<option value=#schoolid#<cfif form.school eq #get_schools.schoolid#> selected</cfif>>#schoolname#
                     	</cfloop>
						<option value=0>Other
						</select></span>
			</tr>
		</table>
 <a onclick="ShowHide(); return false;" href="##">+/- Our school is not listed above, I need to add it.</a>
<div id="slidingDiv" display:"none">       
</cfif>
  <h2>School Information</h2>
  <table width=100% cellspacing=0 cellpadding=2 class="border">
    <tr bgcolor="##deeaf3">
        <td class="label"><h3>High School<span class="redtext">*</span></h3></td><td class="form_text" colspan=3> <input type="text" name="schoolname" size="20" value="#form.schoolname#"></span>
</tr>
		<tr>
			<td class="label"><h3>Address<span class="redtext">*</span></h3></td><td colspan=3 class="form_text"> <input type="text" name="address" size="20" value="#form.address#"></td>
		</tr>
		<tr>
			<td></td ><td  colspan=3 class="form_text"> <input type="text" name="address2" size="20" value="#form.address2#">
		</tr>
		<tr bgcolor="##deeaf3">			 
			<td class="label"><h3>City<span class="redtext">*</span></h3> </td><td  colspan=3 class="form_text"><input type="text" name="city" size="20" value="#form.city#">
		</tr> 
		<tr >	
			<td class="label" > <h3>State<span class="redtext">*</span></h3> </td><td width=10 class="form_Text">
		
   			 <cfquery name="get_states" datasource="mysql">
                SELECT state, statename
                FROM smg_states
                ORDER BY id
            </cfquery>
			<cfselect NAME="state" query="get_states" value="state" display="statename" selected="#form.state#" queryPosition="below">
				<option></option>
			</cfselect>
	
	</td><td class="zip" ><h3>Zip<span class="redtext">*</span></h3> </td><td class="form_text"><input type="text" name="zip" size="5" value="#form.zip#"></td>

		</tr>
      
		<tr bgcolor="##deeaf3">
			<td class="label"><h3>Contact</h3></td><td class="form_text" colspan=3><cfinput type="text" name="principal" size=20 value="#form.principal#"></span> 
		</tr>
		<tr>			
		<td class="label"><h3>Phone</h3></td><td class="form_text" colspan=3><cfinput type="text" name="phone" size=20 value="#form.phone#" placeholder="(208) 867-5309" mask='(999) 999-9999'></span>
		</tr>
		
		<tr  bgcolor="##deeaf3">
			<td class="label"><h3>Contact Email</h3></td><td class="form_text" colspan=3> <cfinput name="email" size=20 type="text" value="#form.email#" placeholder="contact@school.edu"></span>
		</tr>
        <Tr>
        	<td class="label"><h3>School Type</h3></td>
            <td  colspan=3><input type="radio" value="public" name="schoolType" <Cfif form.schooltype is 'public'>checked</cfif> /> Public &nbsp;&nbsp; <input type="radio" value="private" name="schoolType" <Cfif form.schooltype is 'private'>checked</cfif>   /> Private </td>
        </Tr>
        <Tr  bgcolor="##deeaf3">
        	<td class="label"><h3>School Fees</h3></td><td  colspan=3><input type="text" name="schoolFees" size=25 placeholder="amount of tution or fees" value="#form.schoolFees#" /> </td>
        </Tr>
        <!----
        <tr bgcolor="##deeaf3">
			<td class="label"><h3>Distance from Home</h3></td><td class="form_text" colspan=3> <cfinput name="distnaceFromHome" size=10 type="text" value="#form. placeholder="25 miles"></span>
		</tr>
       
		<tr>
			<td class="label"><h3>Number of Students</h3></td>
            <td class="form_text" colspan=3> <cfinput name="numberStudents" size=10 type="text" placeholder="1200"></span>
		</tr>
    	<tr>
			<td class="label" bgcolor="##deeaf3"><h3>School Year Starts</h3></td>
            <td class="form_text" colspan=3> <cfinput name="schoolStars" size=10 type="text" placeholder="08/28/2012"></span>
		</tr>
		 ---->
			
	</tr>
</table>
<br />
<cfif get_Schools.recordcount is not 0>
</div>
</cfif>
 <h2>Relationships</h2>
 <table width=100% cellspacing=0 cellpadding=2 class="border" border=0>
    <tr bgcolor="##deeaf3">
        <td class="label">Does any member of your household work for the high<br /> school in a coaching/teaching/administrative capacity?<span class="redtext">*</span></td>
        <td>
            <label>
            <cfinput type="radio" name="schoolWorks" value="1"
            checked="#form.schoolWorks eq 1#" onclick="document.getElementById('showSchoolWorks').style.display='table-row';" 
             />
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="schoolWorks" value="0"
           checked="#form.schoolWorks eq 0#" onclick="document.getElementById('showSchoolWorks').style.display='none';" 
           />
            No
            </label>
		 </td>
	</tr>
    <Tr>
	     <td align="left" colspan=2 id="showSchoolWorks" <cfif form.schoolWorks eq 0> style="display: none;"</cfif>><Br /><strong>Job Title & Duties<span class="redtext">*</span></strong><br><textarea cols="50" rows="4" name="schoolWorksExpl" wrap="VIRTUAL"><Cfoutput>#form.schoolWorksExpl#</cfoutput></textarea></td>
	</tr>   
    <tr>
        <td class="label">Has any member of your household had contact with a coach<Br /> regarding the hosting of an exchange student with a particular athletic ability?<span class="redtext">*</span></td>
        <td>
            <label>
            <cfinput type="radio" name="schoolCoach" value="1"
            checked="#form.schoolCoach eq 1#" onclick="document.getElementById('showCoachExpl').style.display='table-row';" 
             />
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="schoolCoach" value="0"
           checked="#form.schoolCoach eq 0#" onclick="document.getElementById('showCoachExpl').style.display='none';" 
           />
            No
            </label>
		 </td>
	</tr>
    <Tr>
	     <td align="left" colspan=2 id="showCoachExpl" <cfif form.schoolCoach eq 0>style="display: none;"</cfif>><br /><strong>Please describe<span class="redtext">*</span></strong><br><textarea cols="50" rows="4" name="schoolCoachExpl" wrap="VIRTUAL"><Cfoutput>#form.schoolCoachExpl#</cfoutput></textarea></td>
	</tr>
    <Tr bgcolor="##deeaf3">
	     <td align="left" colspan=2 >Please check any children that attend this school<br>
         <cfloop query="hostKids">
         <input type="checkbox" value="#childid#" /> #name# &nbsp;&nbsp;&nbsp;
         </cfloop>
         </td>
	</tr>
</table>

  <h2>Transportation</h2>
  How will the student get to school?<span class="redtext">*</span>
<table width=100% cellspacing=0 cellpadding=2 class="border">
    <tr bgcolor="##deeaf3">
        <td class="label"><cfinput type="radio" name="schoolTransportation"  value="School Bus"  checked="#form.schoolTransportation eq 'School Bus'#" >School Bus</td>
        <td class="form_text"><cfinput type="radio" name="schoolTransportation" value="Car" checked="#form.schoolTransportation eq 'Car'#">Car  </td>
        <td class="form_text"><cfinput type="radio" name="schoolTransportation" value="Walk" checked="#form.schoolTransportation eq 'Walk'#">Walk</td>
	</tr>
    <tr>
    	<td class="label"> <cfinput type="radio" name="schoolTransportation" value="Public Transportation" checked="#form.schoolTransportation eq 'Public Transportation'#">Public Transportation<br></td>
        <Td><cfinput type="radio" name="schoolTransportation" value="Other" checked="#form.schoolTransportation eq 'Other'#" >Other: <cfinput type="text" name="other_desc" size=10 value="#form.schoolTransportationother#"> </Td>
        <td> </td>
    </tr>
	<tr bgcolor="##deeaf3">
        <td class="label" colspan=2>Will you provide transportation for extracurricular activities?<span class="redtext">*</span></td>
        <td>
            <label>
            <cfinput type="radio" name="extraCuricTrans" value="1"
            checked="#form.extraCuricTrans eq 1#"
             />
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="extraCuricTrans" value="0"
           checked="#form.extraCuricTrans eq 0#" 
           />
            No
            </label>
		 </td>
	</tr>
</table>

<!----These questions are global to school, rep should answer.
<h2>Policies</h2>
Policy regarding graduation of exchange students and/or granting of diploma
<table width=100% cellspacing=0 cellpadding=2 class="border">
    <tr bgcolor="##deeaf3" >
    	<td colspan=2>
<textarea cols="50" rows="4" name="grad_policy" wrap="VIRTUAL"></textarea>
		</td>
     </tr>
 </table>
 <br />
Other policies related to exchange students
<table width=100% cellspacing=0 cellpadding=2 class="border">
    <tr bgcolor="##deeaf3" >
    	<td colspan=2>
<textarea cols="50" rows="4" name="other_policy" wrap="VIRTUAL"></textarea>
		</td>
     </tr>
 </table>
<h2>Extracuricular Activities & Sports</h2>
Extracurricular activities and sports available to exchange students
<table width=100% cellspacing=0 cellpadding=2 class="border">
    <tr bgcolor="##deeaf3" >
    	<td colspan=2>
<textarea cols="50" rows="4" name="extracuricular" wrap="VIRTUAL"></textarea>
		</td>
     </tr>
     <tr>
     	<Td class="lable">Will you provide transportation to these activities, if necessary?</Td>
        <td><cfinput type="radio" name="extra_tras" value=1 />Yes <cfinput type="radio" name="extra_tras" value=0 />No</td>
        
     </tr>
 </table>

<h2>Special Programs</h2>
Special programs, unique features or electives available to foreign students
<table width=100% cellspacing=0 cellpadding=2 class="border">
    <tr bgcolor="##deeaf3">
    	<td>
<textarea cols="50" rows="4" name="special_programs" wrap="VIRTUAL"></textarea>
		</td>
     </tr>
 </table>
 ---->
<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
    <tr>
       
        <td align="right"><input name="Submit" type="image" src="../images/buttons/Next.png" border=0></td>
    </tr>
</table>

</cfform>
</cfoutput>