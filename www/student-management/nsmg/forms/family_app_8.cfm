
<cfinclude template="../querys/get_local.cfm">
<cfquery name="get_schools" datasource="MySQL">
select * from smg_Schools
where (city = "#local.city#")and (state = "#local.state#")
</cfquery>
<cfquery name="get_host_school" datasource="MySQL">
select *
from smg_schools, smg_hosts
where smg_schools.schoolid = smg_hosts.schoolid
</cfquery>
<cfform action="querys/insert_school_info.cfm" method="post">
<div class="application_section_header">School Infomation</div>
<Cfinclude template="../family_app_menu.cfm">
<div class=row>

<cfif get_Schools.recordcount is 0>
We do not have any schools in <Cfoutput>#local.city# #local.state#</Cfoutput> in our database.  Please add the following information for the school that the student will be attending.
<cfelse>
The following schools are in your city, if the student will be attending a school from the list, please select it.  If the school is not found, please enter 
the information for the school that the student will be attending.
<Table>
	<tr>
		
			<td class="label">School: </td><td class="form_text"><select name="school">
						<option selected>
						<cfoutput query="get_schools">
						<cfif get_host_school.schoolname is #schoolname#><option value=#schoolid# selected>#schoolname#<cfelse><option value=#schoolid# selected>#schoolname#</cfif>
						</cfoutput>
						<option value=0>Other
						</select></span>
			</tr>
		</table>
</cfif>
</div>
<div class=row1>
<table border=0>
	<tr>
<td class="label">High School:</td><td class="form_text" colspan=3> <cfinput type="text" name="name" size="20" value="#get_host_school.schoolname#"></span>
</tr>
		<tr>
			<td class="label">Address:</td><td colspan=3 class="form_text"> <cfinput type="text" name="address" size="20" value="#get_host_school.address#"></td>
		</tr>
		<tr>
			<td></td ><td  colspan=3 class="form_text"> <cfinput type="text" name="address2" size="20" value="#get_host_school.address2#">
		</tr>
		<tr>			 
			<td class="label">City: </td><td  colspan=3 class="form_text"><cfinput type="text" name="city" size="20" value="#get_host_school.city#">
		</tr> 
		<tr>	
			<td class="label" > State: </td><td width=10 class="form_Text">
		
 <select name="state">
	
	<option selected>
	<option value="AL">AL
	<option value="AK">AK
	<option value="AZ">AZ
	<option value="AR">AR
	<option value="CA">CA
	<option value="CO">CO
	<option value="CT">CT
	<option value="DE">DE
	<option value="FL">FL
	<option value="GA">GA
	<option value="HI">HI
	<option value="ID">ID
	<option value="IL">IL
	<option value="IN">IN
	<option value="IA">IA
	<option value="KS">KS
	<option value="KY">KY
	<option value="LA">LA
	<option value="ME">MA
	<option value="MD">MD
	<option value="MA">MA
	<option value="MI">MI
	<option value="MN">MN
	<option value="MS">MS
	<option value="MO">MO
	<option value="MT">MT
	<option value="NE">NE
	<option value="NV">NV
	<option value="NH">NH
	<option value="NJ">NJ
	<option value="NM">NM
	<option value="NY">NY
	<option value="NC">NC
	<option value="ND">ND
	<option value="OH">OH
	<option value="OK">OK
	<option value="OR">OR
	<option value="PA">PA
	<option value="RI">RI
	<option value="SC">SC
	<option value="SD">SD
	<option value="TN">TN
	<option value="TX">TX
	<option value="UT">UT
	<option value="VT">VT
	<option value="VA">VA
	<option value="WA">WA
	<option value="DC">DC
	<option value="WV">WV
	<option value="WI">WI
	<option value="WY">WY
	</select>
	
	</td><td class="zip" >Zip: </td><td class="form_text"><cfinput type="text" name="zip" size="5" value="#get_host_school.zip#"></td>

		</tr>
		<tr>
			<td class="label">Principal:</td><td class="form_text" colspan=3><cfinput type="text" name="principal" size=20 value="#get_host_school.principal#"></span> 
		</tr>
		<tr>			
		<td class="label">Phone:</td><td class="form_text" colspan=3><cfinput type="text" name="phone" size=20 value="#get_host_school.phone#"> nnn-nnn-nnnn</span>
		</tr>
		<tr>
			<td class="label">Fax:</td><td class="form_text" colspan=3><cfinput type="text" name="fax" size=20 value="#get_host_school.fax#"> nnn-nnn-nnnn</span>
		</tr>
		<tr>
			<td class="label">Contact Email:</td><td class="form_text" colspan=3> <cfinput name="email" size=20 type="text" value="#get_host_school.email#"></span>
		</tr>
		<tr>
			<td class="label">Web Site:</td><td class="form_text" colspan=3> <cfinput name="url" size=20 type="text" value="#get_host_school.url#"> <cfoutput><a href="#get_host_school.url#" target=_blank>Visit Web Site </a> </cfoutput></span>
		</tr>
		<tr>
			<td class="label">Number of Students:</td><td class="form_text" colspan=3> <cfinput name="number_Students" size=5 type="text" value="#get_host_school.numberofstudents#"> College Bound: <cfinput type="text" name="collegebound" size=3 value="#get_host_school.collegebound#">%</span><br>	
	</tr>
</table>
</div>
<div class=row>
<table>
	<Tr>
		
	<td class="label">School Year Begins:</td><td class="form_text"> <cfinput type="Text" name="begins"  size="10" value="#DateFormat(get_host_school.begins, 'yyyy/mm/dd')#"> yyyy/mm/dd</span>
	</tr>
		<tr>
	 <td class="label">2<sup>nd</sup> Semester Begins:</td><td class="form_text"> <cfinput type="Text" name="semester" size="10" value="#DateFormat(get_host_school.semesterbegins, 'yyyy/mm/dd')#"> yyyy/mm/dd</span>
	 </tr>
		<tr>
	 <td class="label">Year Ends:</td><td class="form_text"> <cfinput type="Text" name="ends"  size="10" value="#DateFormat(get_host_school.ends, 'yyyy/mm/dd')#"> yyyy/mm/dd</span>
	 </tr>
		<tr> 
	 <td class="label">Enrollment/Orientation:</td><td class="form_text"> <cfinput type="Text"  name="enroll" size="10" value="#DateFormat(get_host_school.enrollment, 'yyyy/mm/dd')#"> yyyy/mm/dd</span>
</tr>
</table>
</div>

<div class="button"><input type="submit" value='    next    '></div>
</cfform>
</div>