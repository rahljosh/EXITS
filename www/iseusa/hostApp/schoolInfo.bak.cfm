<Cfif isDefined('form.process')>
	<!---_Transportation doesn't make sense---->
	<Cfif #form.transportation# is "other" and #form.other_Desc# is ''>
    You indicated 'Other' as the method of transportation to school, but didn't fill out the Other description box.<br>Use your browsers back button to enter the description.
    <div class="button"><input name="back" type="image" src="pics/back.gif" align="right" border=0 onClick="history.back()"></div>
    <cfabort>
    <cfelseif #form.transportation# is not "other">
    <Cfset form.other_desc = ''>
    </cfif>
	<!----Insert transportion, relationships---->
    <cfquery name="insert_transportation" datasource="MySQL">
    update smg_hosts
    set school_trans = "#form.transportation#",
    schoolWorks = "#form.schoolWorks#",
    schoolWorksExpl = "#form.schoolWorksExpl#",
    schoolCoach = "#form.schoolCoach#",
    schoolCoachExpl = "#form.schoolCoachExpl#"
    where hostid = #client.hostid#
    </cfquery>

	<!----Insert School Information---->
    <cfif form.school is 'na'>
    <cfquery name="insert_school" datasource="MySQL">
				INSERT INTO smg_Schools
					(schoolname,address,address2,city,state,zip<!----,phone,fax,email,url,principal---->)								
				VALUES ("#form.name#", "#form.address#", "#form.address2#", "#form.city#", "#form.state#", "#form.zip#"<!----, "#form.phone#",
						"#form.fax#", "#form.email#", "#form.url#", "#form.principal#"---->)
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
    <Cflocation url="index.cfm?page=familyRules">
</Cfif>

<Cfoutput>

<cfform method="post" action="index.cfm?page=schoolInfo">
<input type="hidden" name="process" />
<cfparam name="form.schoolWorks" default="">
<cfparam name="form.schoolWorksExpl" default="">
<cfparam name="form.schoolCoach" default="">
<cfparam name="form.schoolCoachExpl" default="">
<cfparam name="form.transportation" default="">
<cfparam name="form.name" default="">
<cfparam name="form.address" default="">
<cfparam name="form.address2" default="">
<cfparam name="form.city" default="">
<cfparam name="form.state" default="">
<cfparam name="form.zip" default="">
<!----
<cfparam name="form.phone" default="">
<cfparam name="form.fax" default="">
<cfparam name="form.email" default="">
<cfparam name="form.url" default="">
<cfparam name="form.principal" default="">
---->
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
select smg_hosts.schoolid, smg_schools.schoolname, smg_schools.address, smg_schools.address2, smg_schools.principal,smg_schools.city, smg_schools.state, smg_schools.zip
from smg_hosts 
left join smg_schools on smg_schools.schoolid = smg_hosts.schoolid
where smg_hosts.hostid = #client.hostid#
</cfquery>
<cfquery name="hostInfo" datasource="MySQL">
select schoolWorks, schoolWorksExpl, schoolCoach, schoolCoachExpl
from smg_hosts
where hostid = #client.hostid#
</cfquery>
<div class="application_section_header">School Infomation</div>


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
						<cfif get_host_school.schoolid eq #get_schools.schoolid#>
                        	<option value=#schoolid# selected>#schoolname#
                        <cfelse>
                        	<option value=#schoolid#>#schoolname#
                        </cfif>
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
        <td class="label"><h3>High School</h3></td><td class="form_text" colspan=3> <cfinput type="text" name="name" size="20" value="#get_host_school.schoolname#"></span>
</tr>
		<tr>
			<td class="label"><h3>Address</h3></td><td colspan=3 class="form_text"> <cfinput type="text" name="address" size="20" value="#get_host_school.address#"></td>
		</tr>
		<tr bgcolor="##deeaf3">
			<td></td ><td  colspan=3 class="form_text"> <cfinput type="text" name="address2" size="20" value="#get_host_school.address2#">
		</tr>
		<tr>			 
			<td class="label"><h3>City</h3> </td><td  colspan=3 class="form_text"><cfinput type="text" name="city" size="20" value="#get_host_school.city#">
		</tr> 
		<tr bgcolor="##deeaf3">	
			<td class="label" > <h3>State</h3> </td><td width=10 class="form_Text">
		
    <cfquery name="get_states" datasource="mysql">
                SELECT state, statename
                FROM smg_states
                ORDER BY id
            </cfquery>
			<cfselect NAME="state" query="get_states" value="state" display="statename" selected="#get_host_school.state#" queryPosition="below">
				<option></option>
			</cfselect>
	
	</td><td class="zip" ><h3>Zip</h3> </td><td class="form_text"><cfinput type="text" name="zip" size="5" value="#get_host_school.zip#"></td>

		</tr>
        <!----
		<tr>
			<td class="label"><h3>Principal</h3></td><td class="form_text" colspan=3><cfinput type="text" name="principal" size=20 value="#get_host_school.principal#"></span> 
		</tr>
		<tr bgcolor="##deeaf3">			
		<td class="label"><h3>Phone</h3></td><td class="form_text" colspan=3><cfinput type="text" name="phone" size=20 value="#get_host_school.phone#"> nnn-nnn-nnnn</span>
		</tr>
		<tr>
			<td class="label"><h3>Fax</h3></td><td class="form_text" colspan=3><cfinput type="text" name="fax" size=20 value="#get_host_school.fax#"> nnn-nnn-nnnn</span>
		</tr>
		<tr bgcolor="##deeaf3">
			<td class="label"><h3>Contact Email</h3></td><td class="form_text" colspan=3> <cfinput name="email" size=20 type="text" value="#get_host_school.email#"></span>
		</tr>
		<tr>
			<td class="label"><h3>Web Site</h3></td><td class="form_text" colspan=3> <cfinput name="url" size=20 type="text" value="#get_host_school.url#"></span>
		</tr>
		<tr bgcolor="##deeaf3">
			<td class="label"><h3>Number of Students</h3></td><td class="form_text" colspan=3> <cfinput name="number_Students" size=5 type="text" value="#get_host_school.numberofstudents#"> College Bound: <cfinput type="text" name="collegebound" size=3 value="#get_host_school.collegebound#">%</span><br>	
			
	</tr>---->
</table>
<br />
<cfif get_Schools.recordcount is not 0>
</div>
</cfif>
 <h2>Relationships</h2>
 <table width=100% cellspacing=0 cellpadding=2 class="border" border=0>
    <tr bgcolor="##deeaf3">
        <td class="label">Does any member of your household work for the high<br /> school in a coaching/teaching/administrative capacity?</td>
        <td>
            <label>
            <cfinput type="radio" name="schoolWorks" value="1"
            checked="#hostInfo.schoolWorks eq 1#" onclick="document.getElementById('showSchoolWorks').style.display='table-row';" 
            required="yes" message="Does any member of your household work for the high school in a coaching/teaching/administrative capacity?" />
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="schoolWorks" value="0"
           checked="#hostInfo.schoolWorks eq 0#" onclick="document.getElementById('showSchoolWorks').style.display='none';" 
           required="yes" message="Please answer: Does any member of your household work for the high school in a coaching/teaching/administrative capacity?" />
            No
            </label>
		 </td>
	</tr>
    <Tr>
	     <td align="left" colspan=2 id="showSchoolWorks" <cfif hostInfo.schoolWorks eq 0> style="display: none;"</cfif>><Br /><strong>Job Title & Duties</strong><br><textarea cols="50" rows="4" name="schoolWorksExpl" wrap="VIRTUAL"><Cfoutput>#hostInfo.schoolWorksExpl#</cfoutput></textarea></td>
	</tr>   
    <tr>
        <td class="label">Has any member of your household had contact with a coach<Br /> regarding the hosting of an exchange student with a particular athletic ability?</td>
        <td>
            <label>
            <cfinput type="radio" name="schoolCoach" value="1"
            checked="#hostInfo.schoolCoach eq 1#" onclick="document.getElementById('showCoachExpl').style.display='table-row';" 
            required="yes" message="Does any member of your household work for the high school in a coaching/teaching/administrative capacity?" />
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="schoolCoach" value="0"
           checked="#hostInfo.schoolCoach eq 0#" onclick="document.getElementById('showCoachExpl').style.display='none';" 
           required="yes" message="Please answer: Does any member of your household work for the high school in a coaching/teaching/administrative capacity?" />
            No
            </label>
		 </td>
	</tr>
    <Tr>
	     <td align="left" colspan=2 id="showCoachExpl" <cfif hostInfo.schoolCoach eq 0>style="display: none;"</cfif>><br /><strong>Please describe</strong><br><textarea cols="50" rows="4" name="schoolCoachExpl" wrap="VIRTUAL"><Cfoutput>#hostInfo.schoolCoachExpl#</cfoutput></textarea></td>
	</tr>
</table>

  <h2>Transportation</h2>
  How will the student get to school?
<table width=100% cellspacing=0 cellpadding=2 class="border">
    <tr bgcolor="##deeaf3">
        <td class="label"><cfinput type="radio" name="transportation" message="Please indicate the type of transportation student will use to get to school." required="yes" value="School Bus">School Bus</td>
        <td class="form_text"><cfinput type="radio" name="transportation" value="Car">Car  </td>
        <td class="form_text"><cfinput type="radio" name="transportation" value="Walk">Walk</td>
	</tr>
    <tr>
    	<td class="label"> <cfinput type="radio" name="transportation" value="Public Transportation">Public Transportation<br></td>
        <Td><cfinput type="radio" name="transportation" value="Other">Other: <cfinput type="text" name="other_desc" size=10> </Td>
        <td> </td>
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