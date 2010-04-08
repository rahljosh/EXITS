<cfquery name="confirm_school" datasource="caseusa">
select *
from smg_schools
where schoolid = #client.schoolid#
</cfquery>
<cfquery name="get_trans" datasource="caseusa">
select schooltransportation, school_trans
from smg_hosts
where hostid = #client.hostid#
</cfquery>
<cfoutput query="confirm_School">
<cfform action="querys/insert_School_trans.cfm" method="post">
<div class="application_section_header">School Information</div>
<cfinclude template="../family_App_menu.cfm">
<div class=row>
Transportation to school:<br>
<cfif get_trans.schooltransportation is 'School Bus'><cfinput type="radio" name="transportation" value="School Bus" checked>School Bus<cfelse><cfinput type="radio" name="transportation" value="School Bus" selected>School Bus</cfif>
<cfif get_trans.schooltransportation is 'Car'> <cfinput type="radio" name="transportation" value="Car" checked>Car<cfelse><cfinput type="radio" name="transportation" value="Car">Car</cfif>
 <cfif get_trans.schooltransportation is 'Public Transportation'><cfinput type="radio" name="transportation" value="Public Transportation" checked>Public Transportation<cfelse><cfinput type="radio" name="transportation" value="Public Transportation">Public Transportation</cfif><br>
 <cfif get_trans.schooltransportation is 'Walk'><cfinput type="radio" name="transportation" value="Walk" checked>Walk <cfelse><cfinput type="radio" name="transportation" value="Walk">Walk</cfif>
  <cfif get_trans.schooltransportation is 'Other'><cfinput type="radio" name="transportation" value="Other" checked>Other: <cfinput type="text" name="other_desc" size=10 value="#get_trans.school_trans#"><cfelse><cfinput type="radio" name="transportation" value="Other">Other:<cfinput type="text" name="other_desc" size=10></cfif> 

<span class=spacer></span>
</div>
<div class="row1">You selected #schoolname# as the school your exchange student will attend. Please review the information below to confirm that it is correct. 
<div class="get_Attention">If this information is not correct, please use your browsers back button, select 'Other' from the drop down list, and enter your school information.</div></div>

	<div class="row">
	<b>School Name & Address</b>
	<Table>
		<Tr>
	<td class="label">School Name: </td><td class="form_text">#schoolname#</span>
	</tr>
	<tr>
	<td  class="label">Address:</td><td class="form_text">#address#</span>
	</tr>
	<tr>
	<cfif #address2# is ''><cfelse><td  class="label"></td><td class="form_text">#schoolname#</span>#address2#</span></cfif>
	</tr>
	<tr>
	<td  class="label"></td><td class="form_text">#city# #state#, #zip#</span>
	</tr>
	<tr>
	<td  class="label">Principal:</td><td class="form_text">#principal#</span>	 
	</tr>
	<tr>
	<td  class="label">Phone: </td><td class="form_text">#phone#</span>
	</tr>
	<tr>
	<td  class="label">Fax: </td><td class="form_text">#fax#</span>
	</tr>
	<tr>
	<td  class="label">Email: </td><td class="form_text">#email#</span>
	</tr>
	<tr>
	<td  class="label">Website: </td><td class="form_text"><a href="#url#" target=_blank>#url#</a></span>
	</tr>
	<tr>
	<td  class="label">Email: </td><td class="form_text">#email#</span>
	</tr>
	<tr>
	<td class="label">Number of Students: </td><td class="form_text">#numberofstudents# College Bound: #collegebound#%</span><br>
</tr>
</table>
	</div>
	<div class="row1">
<table>
	<Tr>
	<td class="label">School Year Begins: </td><td class="form_text">#DateFormat(begins, "yyyy/mm/dd")#</span><br>
	</tr>
	<tr>
	<td class="label">2nd Semester Begins: </td><td class="form_text">#DateFormat(semesterbegins, "yyyy/mm/dd")#</span>
		</tr>
	<tr>
	<td class="label">Year Ends: </td><td class="form_text">#DateFormat(ends, "yyyy/mm/dd")#</a></span><br>
		</tr>
	<tr>
	<td class="label">Enroll/Orientation: </td><td class="form_text">#DateFormat(enrollment, "yyyy/mm/dd")#</span>
	</tr>
	</table>
	</div>
	<div class="row1">
	<b>Special programs, unique features or electives available to foreign students:</b><br>
	#special_programs#<br><br>
	
	<b>High school policy regarding graduation of exchange students and granting of diploma:</b><br>
	#grad_policy#<br><br>
	
	<b>Extra curricular activities and sports available to exchange students:</b><br>
	#sports#<br><br>
	
	<b>Other school policies related to exchange students:</b><br>
	#other_policies#<br><br>
	
	</div>
	<div class=row1>
	<b>Private High School information. if applicable (tuition policy, uniform required, fees, etc):</b><br>
	#private_school_info#<br>
	<span class=spacer></span>
	</div>
</div>

<div class="button"><input type="submit" value="    confirm    "></div>
</div>

</cfform>
</cfoutput>
</body>
</html>
