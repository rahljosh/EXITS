<Cfparam name="FORM.school" default="na">
<cfparam name="FORM.schoolWorks" default="3">
<cfparam name="FORM.schoolWorksExpl" default="">
<cfparam name="FORM.schoolCoach" default="3">
<cfparam name="FORM.schoolCoachExpl" default="">
<cfparam name="FORM.schoolTransportation" default="">
<cfparam name="FORM.schoolTransportationother" default="">
<cfparam name="FORM.schoolname" default="">
<cfparam name="FORM.address" default="">
<cfparam name="FORM.address2" default="">
<cfparam name="FORM.city" default="">
<cfparam name="FORM.state" default="">
<cfparam name="FORM.zip" default="">
<Cfparam name="FORM.school" default="na">
<Cfparam name="FORM.principal" default="">
<Cfparam name="FORM.phone" default="">
<Cfparam name="FORM.email" default="">
<Cfparam name="FORM.extraCuricTrans" default="">
<cfparam name="FORM.schoolType" default="">
<cfparam name="FORM.schoolFees" default="">


<cfquery name="local" datasource="#APPLICATION.DSN.Source#">
	select city,state,zip
	from smg_hosts
	where hostID = #APPLICATION.CFC.SESSION.getHostSession().ID#
</cfquery>

<cfquery name="get_local_schools" datasource="#APPLICATION.DSN.Source#">
select * from smg_schools
where (city = <cfqueryparam cfsqltype="cf_sql_varchar" value= "#local.city#"> AND state = <cfqueryparam cfsqltype="cf_sql_varchar" value= "#local.state#">)
order by schoolname
</cfquery>
<cfquery name="get_all_schools" datasource="#APPLICATION.DSN.Source#">
select * from smg_schools
where state = <cfqueryparam cfsqltype="cf_sql_varchar" value= "#local.state#"> and city != <cfqueryparam cfsqltype="cf_sql_varchar" value= "#local.city#">
order by city, schoolname
</cfquery>
<cfquery name="get_host_school" datasource="#APPLICATION.DSN.Source#">
select smg_hosts.schoolid, smg_schools.schoolname, smg_schools.address, smg_schools.address2, smg_schools.principal,smg_schools.city, smg_schools.state, smg_schools.zip, smg_schools.phone, smg_schools.email, smg_schools.tuition, smg_schools.type
from smg_hosts 
left join smg_schools on smg_schools.schoolid = smg_hosts.schoolid
where smg_hosts.hostID = #APPLICATION.CFC.SESSION.getHostSession().ID#
</cfquery>
<cfquery name="qGetHostInfo" datasource="#APPLICATION.DSN.Source#">
select schoolWorks, schoolWorksExpl, schoolCoach, schoolCoachExpl, schooltransportation, schooltransportationother,extraCuricTrans, schoolid
from smg_hosts
where hostID = #APPLICATION.CFC.SESSION.getHostSession().ID#
</cfquery>
<cfquery name="hostKids" datasource="#APPLICATION.DSN.Source#">
select *
from smg_host_children
where hostID = #APPLICATION.CFC.SESSION.getHostSession().ID#
</cfquery>

<!--- Import CustomTag Used for Page Messages and Form Errors --->
<cfimport taglib="extensions/customTags/gui/" prefix="gui" />	


<cfif isDefined('FORM.process')>
	<cfif not val(FORM.school)>
	
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
            if ( FORM.schoolWorks EQ 3 ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate if any member of your household works for the high school.");
            }		
			
			// Explanation of who works at school
            if ( (FORM.schoolWorks EQ 1) AND (NOT LEN(TRIM(FORM.schoolWorksExpl))) ) {
              // Get all the missing items in a list
                SESSION.formErrors.Add("You have indicated that someone works with the school, but didn't explain.  Please provide details regarding the posistion.");
            }	
			//Been contacted by coach
			if ( FORM.schoolCoach EQ 3 ) {
               // Get all the missing items in a list
               SESSION.formErrors.Add("Please indicate if a coach has contacted you about hosting an exchange student.");
            }		
			
			// Coach explanation
            if ( (FORM.schoolCoach EQ 1) AND (NOT LEN(TRIM(FORM.schoolCoachExpl))) ) {
              // Get all the missing items in a list
                SESSION.formErrors.Add("You have indicated that a coach contacted you, but didn't explain.  Please provide details regarding this contact.");
            }	
			
			
			// Other Transportation 
            if ( (FORM.schooltransportation is 'other') AND (NOT LEN(TRIM(FORM.other_desc))) ) {
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
                <cfquery name="insert_transportation" datasource="#APPLICATION.DSN.Source#">
                update smg_hosts
                set 
                schoolWorks = "#FORM.schoolWorks#",
                schoolWorksExpl = "#FORM.schoolWorksExpl#",
                schoolCoach = "#FORM.schoolCoach#",
                schoolCoachExpl = "#FORM.schoolCoachExpl#",
                schooltransportation = "#FORM.schoolTransportation#",
                schooltransportationother = "#FORM.other_desc#",
                extraCuricTrans = "#FORM.extraCuricTrans#"
                where hostID = #APPLICATION.CFC.SESSION.getHostSession().ID#
                </cfquery>
 			<!----Insert School Information---->
           
           
   			<cfif FORM.school is 'na'>
           			 <cfquery name="insert_school" datasource="#APPLICATION.DSN.Source#">
                        INSERT INTO smg_schools
                            (schoolname,address,address2,city,state,zip,phone,email,principal,type, tuition <!----,url,---->)								
                        VALUES ("#FORM.schoolname#", "#FORM.address#", "#FORM.address2#", "#FORM.city#", "#FORM.state#", "#FORM.zip#", "#FORM.phone#",
                                 "#FORM.email#", "#FORM.principal#", "#FORM.schoolType#", "#FORM.schoolFees#"<!---- "#FORM.url#",---->)
                    </cfquery>
                
                    <cfquery name="schoolid" datasource="#APPLICATION.DSN.Source#"> <!--- get the newest school --->
                        SELECT MAX(schoolid) as newschoolid
                        FROM smg_schools
                    </cfquery>
                    
                    <cfquery name="add_School" datasource="#APPLICATION.DSN.Source#">
                    update smg_hosts
                    set schoolid = '#schoolid.newschoolid#'
                    where hostID = '#APPLICATION.CFC.SESSION.getHostSession().ID#'
                    LIMIT 1 
                    </cfquery>	
            <cfelse>
                <cfquery name="add_School" datasource="#APPLICATION.DSN.Source#">
                update smg_hosts
                set schoolid = '#FORM.school#'
                where hostID = '#APPLICATION.CFC.SESSION.getHostSession().ID#'
                LIMIT 1 
                </cfquery>	
                
            </cfif>

        
          <cflocation url="index.cfm?section=communityProfile" addtoken="no">
       
  		</cfif>
<cfelse>	
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

<cfform method="post" action="index.cfm?section=schoolInfo">
<input type="hidden" name="process" />

<!----
<cfparam name="FORM.phone" default="">
<cfparam name="FORM.fax" default="">
<cfparam name="FORM.email" default="">
<cfparam name="FORM.url" default="">
<cfparam name="FORM.principal" default="">
---->

<div class="application_section_header"><h2>School Infomation</h2></div>
	
	<!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="section"
        />
        



The following schools are in your state.  The top of the list are schools in your city, followed by schools with in the state.  If you start typing in your school name, the list will filter.  If your school is not in the list, please lick the link "Our school is not listed above, I need to add it." and enter your school.
  <table width="100%" cellspacing="0" cellpadding="2" class="border">
    <tr>
        <td class="label">School: </td><td class="form_text">
                        
                         <select data-placeholder="Start typing your school name..." class="chzn-select" style="width:350px;" tabindex="2" name="school" onchange="this.form.submit(closeCity);">
               <option value=""></option>
                    <option value="">-----Schools in your city-----</option>
                <cfloop query="get_local_schools">
                    <option value="#schoolid#" <cfif FORM.school is #get_local_schools.schoolid#>selected</cfif>>#schoolname# - #city#, #state#</option>
                </cfloop>
                <option value="">-----All other schools-----</option>
                   <cfloop query="get_all_schools">
                    <option value="#schoolid#" <cfif FORM.school is #get_all_schools.schoolid#>selected</cfif>>#schoolname# - #city#, #state#</option>
                </cfloop> 
                </select>
               
			</tr>
		</table>
 <a onclick="ShowHide(); return false;" href="##">+/- Our school is not listed above, I need to add it.</a>
<div id="slidingDiv" display:"none">       

  <h2>School Information</h2>
  <table width="100%" cellspacing="0" cellpadding="2" class="border">
    <tr bgcolor="##deeaf3">
        <td class="label"><h3>High School<span class="redtext">*</span></h3></td><td class="form_text" colspan=3> <input type="text" name="schoolname" size="20" value="#FORM.schoolname#"></span>
</tr>
		<tr>
			<td class="label"><h3>Address<span class="redtext">*</span></h3></td><td colspan=3 class="form_text"> <input type="text" name="address" size="20" value="#FORM.address#"></td>
		</tr>
		<tr>
			<td></td ><td  colspan=3 class="form_text"> <input type="text" name="address2" size="20" value="#FORM.address2#">
		</tr>
		<tr bgcolor="##deeaf3">			 
			<td class="label"><h3>City<span class="redtext">*</span></h3> </td><td  colspan=3 class="form_text"><input type="text" name="city" size="20" value="#FORM.city#">
		</tr> 
		<tr>	
			<td class="label" > <h3>State<span class="redtext">*</span></h3> </td><td width=10 class="form_Text">
		
   			 <cfquery name="get_states" datasource="#APPLICATION.DSN.Source#">
                SELECT state, statename
                FROM smg_states
                ORDER BY id
            </cfquery>
			<cfselect NAME="state" query="get_states" value="state" display="statename" selected="#FORM.state#" queryPosition="below">
				<option></option>
			</cfselect>
	
	</td><td class="zip" ><h3>Zip<span class="redtext">*</span></h3> </td><td class="form_text"><input type="text" name="zip" size="5" value="#FORM.zip#"></td>

		</tr>
      
		<tr bgcolor="##deeaf3">
			<td class="label"><h3>Contact</h3></td><td class="form_text" colspan=3><cfinput type="text" name="principal" size=20 value="#FORM.principal#"></span> 
		</tr>
		<tr>			
		<td class="label"><h3>Phone</h3></td><td class="form_text" colspan=3><cfinput type="text" name="phone" size=20 value="#FORM.phone#" placeholder="(208) 867-5309" mask='(999) 999-9999'></span>
		</tr>
		
		<tr  bgcolor="##deeaf3">
			<td class="label"><h3>Contact Email</h3></td><td class="form_text" colspan=3> <cfinput name="email" size=20 type="text" value="#FORM.email#" placeholder="contact@school.edu"></span>
		</tr>
        <tr>
        	<td class="label"><h3>School Type</h3></td>
            <td  colspan=3><input type="radio" value="public" name="schoolType" <cfif FORM.schooltype is 'public'>checked</cfif> /> Public &nbsp;&nbsp; <input type="radio" value="private" name="schoolType" <cfif FORM.schooltype is 'private'>checked</cfif>   /> Private </td>
        </tr>
        <Tr  bgcolor="##deeaf3">
        	<td class="label"><h3>School Fees</h3></td><td  colspan=3><input type="text" name="schoolFees" size=25 placeholder="amount of tution or fees" value="#FORM.schoolFees#" /> </td>
        </tr>
        <!----
        <tr bgcolor="##deeaf3">
			<td class="label"><h3>Distance from Home</h3></td><td class="form_text" colspan=3> <cfinput name="distnaceFromHome" size=10 type="text" value="#FORM. placeholder="25 miles"></span>
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

</div>

 <h2>Relationships</h2>
 <table width="100%" cellspacing="0" cellpadding="2" class="border" border="0">
    <tr bgcolor="##deeaf3">
        <td class="label">Does any member of your household work for the high<br /> school in a coaching/teaching/administrative capacity?<span class="redtext">*</span></td>
        <td>
            <label>
            <cfinput type="radio" name="schoolWorks" value="1"
            checked="#FORM.schoolWorks eq 1#" onclick="document.getElementById('showSchoolWorks').style.display='table-row';" 
             />
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="schoolWorks" value="0"
           checked="#FORM.schoolWorks eq 0#" onclick="document.getElementById('showSchoolWorks').style.display='none';" 
           />
            No
            </label>
		 </td>
	</tr>
    <tr>
	     <td align="left" colspan=2 id="showSchoolWorks" <cfif FORM.schoolWorks eq 0> style="display: none;"</cfif>><Br /><strong>Job Title & Duties<span class="redtext">*</span></strong><br><textarea cols="50" rows="4" name="schoolWorksExpl" wrap="VIRTUAL"><Cfoutput>#FORM.schoolWorksExpl#</cfoutput></textarea></td>
	</tr>   
    <tr>
        <td class="label">Has any member of your household had contact with a coach<Br /> regarding the hosting of an exchange student with a particular athletic ability?<span class="redtext">*</span></td>
        <td>
            <label>
            <cfinput type="radio" name="schoolCoach" value="1"
            checked="#FORM.schoolCoach eq 1#" onclick="document.getElementById('showCoachExpl').style.display='table-row';" 
             />
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="schoolCoach" value="0"
           checked="#FORM.schoolCoach eq 0#" onclick="document.getElementById('showCoachExpl').style.display='none';" 
           />
            No
            </label>
		 </td>
	</tr>
    <tr>
	     <td align="left" colspan=2 id="showCoachExpl" <cfif FORM.schoolCoach eq 0>style="display: none;"</cfif>><br /><strong>Please describe<span class="redtext">*</span></strong><br><textarea cols="50" rows="4" name="schoolCoachExpl" wrap="VIRTUAL"><Cfoutput>#FORM.schoolCoachExpl#</cfoutput></textarea></td>
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
<table width="100%" cellspacing="0" cellpadding="2" class="border">
    <tr bgcolor="##deeaf3">
        <td class="label"><cfinput type="radio" name="schoolTransportation"  value="School Bus"  checked="#FORM.schoolTransportation eq 'School Bus'#" >School Bus</td>
        <td class="form_text"><cfinput type="radio" name="schoolTransportation" value="Car" checked="#FORM.schoolTransportation eq 'Car'#">Car  </td>
        <td class="form_text"><cfinput type="radio" name="schoolTransportation" value="Walk" checked="#FORM.schoolTransportation eq 'Walk'#">Walk</td>
	</tr>
    <tr>
    	<td class="label"> <cfinput type="radio" name="schoolTransportation" value="Public Transportation" checked="#FORM.schoolTransportation eq 'Public Transportation'#">Public Transportation<br></td>
        <td><cfinput type="radio" name="schoolTransportation" value="Other" checked="#FORM.schoolTransportation eq 'Other'#" >Other: <cfinput type="text" name="other_desc" size=10 value="#FORM.schoolTransportationother#"> </td>
        <td> </td>
    </tr>
	<tr bgcolor="##deeaf3">
        <td class="label" colspan=2>Will you provide transportation for extracurricular activities?<span class="redtext">*</span></td>
        <td>
            <label>
            <cfinput type="radio" name="extraCuricTrans" value="1"
            checked="#FORM.extraCuricTrans eq 1#"
             />
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="extraCuricTrans" value="0"
           checked="#FORM.extraCuricTrans eq 0#" 
           />
            No
            </label>
		 </td>
	</tr>
</table>

<!----These questions are global to school, rep should answer.
<h2>Policies</h2>
Policy regarding graduation of exchange students and/or granting of diploma
<table width="100%" cellspacing="0" cellpadding="2" class="border">
    <tr bgcolor="##deeaf3" >
    	<td colspan=2>
<textarea cols="50" rows="4" name="grad_policy" wrap="VIRTUAL"></textarea>
		</td>
     </tr>
 </table>
 <br />
Other policies related to exchange students
<table width="100%" cellspacing="0" cellpadding="2" class="border">
    <tr bgcolor="##deeaf3" >
    	<td colspan=2>
<textarea cols="50" rows="4" name="other_policy" wrap="VIRTUAL"></textarea>
		</td>
     </tr>
 </table>
<h2>Extracuricular Activities & Sports</h2>
Extracurricular activities and sports available to exchange students
<table width="100%" cellspacing="0" cellpadding="2" class="border">
    <tr bgcolor="##deeaf3" >
    	<td colspan=2>
<textarea cols="50" rows="4" name="extracuricular" wrap="VIRTUAL"></textarea>
		</td>
     </tr>
     <tr>
     	<Td class="lable">Will you provide transportation to these activities, if necessary?</td>
        <td><cfinput type="radio" name="extra_tras" value=1 />Yes <cfinput type="radio" name="extra_tras" value=0 />No</td>
        
     </tr>
 </table>

<h2>Special Programs</h2>
Special programs, unique features or electives available to foreign students
<table width="100%" cellspacing="0" cellpadding="2" class="border">
    <tr bgcolor="##deeaf3">
    	<td>
<textarea cols="50" rows="4" name="special_programs" wrap="VIRTUAL"></textarea>
		</td>
     </tr>
 </table>
 ---->
<table border="0" cellpadding="4" cellspacing="0" width="100%" class="section">
    <tr>
       
        <td align="right"><input name="Submit" type="image" src="/images/buttons/Next.png" border="0"></td>
    </tr>
</table>

</cfform>
</cfoutput>
 <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js" type="text/javascript"></script>
  <script src="linked/chosen/chosen.jquery.js" type="text/javascript"></script>
  <script type="text/javascript"> $(".chzn-select").chosen(); $(".chzn-select-deselect").chosen({allow_single_deselect:true}); </script>