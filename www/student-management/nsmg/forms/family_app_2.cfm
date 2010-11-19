
<CFIF not isdefined("url.add")>
	<CFSET url.add = "">
</cfif>
<cfinclude template="../querys/family_info.cfm">
<cfform method="post" action="querys/insert_host_kids.cfm?add=#url.add#">

<cfquery name="children" datasource="MySQL">
select *
from smg_host_children
where hostid = #client.hostid#
</cfquery>

<span class="application_section_header">Other family members at home</span>
<cfinclude template="../family_app_menu.cfm">

<cfif #children.recordcount# is 0>


	<div class="row">
			<Table border=0>
				<tr>
				<td class="label">Name: </td><td class="form_text"> <cfinput type="text" name="name1" size="20"> <cfinput type="radio" name="sex1" value="male">Male <cfinput type="radio" name="sex1" value="female">Female</span>
	</tr>
<tr>
				<td class="label">Date of Birth: </td><td class="form_text"> <cfinput type="text" name="dob1" size="20"> yyyy-mm-dd</span>
	</tr>
<tr>
				<td class="label">Relation: </td><td class="form_text"> <cfinput type="text" name="membertype1" size="20">		</span>		
	
	
		</tr>
</table>
	</div>
	<div class="row1">
				<Table border=0>
				<tr>
		
				<td class="label">Name: </td><td class="form_text"> <cfinput type="text" name="name2" size="20"><cfinput type="radio" name="sex2" value="male">Male <cfinput type="radio" name="sex2" value="female">Female </span>
	
	</tr>
<tr>
		
				<td class="label">Date of Birth: </td><td class="form_text"> <cfinput type="text" size=20 name="dob2"> yyyy-mm-dd</span>
					</tr>
<tr>
				<td class="label">Relation: </td><td class="form_text"> <cfinput type="text" name="membertype2" size="20">	</span>
			

					</tr>
</table>
	</div>
	
	<div class="row">
	
					<Table border=0>
				<tr>
				<td class="label">Name: </td><td class="form_text"><cfinput type="text" size=20 name="name3"> <cfinput type="radio" name="sex3" value="male">Male <cfinput type="radio" name="sex3" value="female">Female</span>
	
		</tr>
<tr>
				<td class="label"> Date of Birth: </td><td class="form_text"><cfinput type="text" size=20 name="dob3"> yyyy-mm-dd</span>
					</tr>
<tr>
				<td class="label">Relation: </td><td class="form_text"> <cfinput type="text" name="membertype3" size="20">	</span>
				<span class="spacer"></span>
		</tr>
</table>
	</div>
	
	<div class="row1">
				<Table border=0>
				<tr>
		
				<td class="label"> Name: </td><td class="form_text"><cfinput type="text" size=20 name="name4"> <cfinput type="radio" name="sex4" value="male">Male <cfinput type="radio" name="sex4" value="female">Female</span>
	</tr>
<tr>
	
				<td class="label"> Date Of Birth: </td><td class="form_text"><cfinput type="text" size=20 name="dob4"> yyyy-mm-dd</span>
					</tr>
<tr>
				<td class="label">Relation: </td><td class="form_text"> <cfinput type="text" name="membertype4" size="20">	</span>
				<span class="spacer"></span>
						 		
		</tr>
</table>
	</div>
		<div class="row">
				<Table border=0>
				<tr>
		
				<td class="label">Name: </td><td class="form_text"><cfinput type="text" size=20 name="name5"> <cfinput type="radio" name="sex5" value="male">Male <cfinput type="radio" name="sex5" value="female">Female</span>
	
		</tr>
<tr>
				<td class="label"> Date of Birth: </td><td class="form_text"><cfinput type="text" size=20 name="dob5"> yyyy-mm-dd</span>
					</tr>
<tr>
				<td class="label">Relation: </td><td class="form_text"> <cfinput type="text" name="membertype5" size="20">	</span>
				<span class="spacer"></span>
			</tr>
		</table>
	</div>


	<cfelse>
	<input type="hidden" name="update" value="update">
		<cfoutput query="children">
			<Cfif #children.currentrow# mod 2><div class="row"><cfelse><div class="row1"></cfif>
			<Table border=0>
			<tr>
				<td class="label"><input type="hidden" name="childid#children.currentrow#" value=#childid#>Name: </td><td class="form_text"> <cfinput type="text" name="name#children.currentrow#" size="20" value="#name#"> <Cfif sex is 'male'><cfinput type="radio" name="sex#children.currentrow#" value="male" checked>Male <cfinput type="radio" name="sex#children.currentrow#" value="female">Female
																																			 <cfelseif sex is 'female'><cfinput type="radio" name="sex#children.currentrow#" value="male">Male <cfinput type="radio" name="sex#children.currentrow#" value="female" checked>Female
																																			 <cfelse><cfinput type="radio" name="sex#children.currentrow#" value="male">Male <cfinput type="radio" name="sex#children.currentrow#" value="female">Female</cfif></span>
			</tr>
			<tr>
				<td class="label">Date of Birth: </td><td class="form_text"> <cfinput type="text" name="dob#children.currentrow#" size="20" value="#DateFormat(birthdate,'yyyy-mm-dd')#"> yyyy-mm-dd</span>
			</tr>
			<tr>
				<td class="label">Relation: </td><td class="form_text"><cfinput type="text" name="membertype#children.currentrow#" size="20" value="#membertype#">
			</tr>
			</table>
			</div>
			</cfoutput>
			</cfif>
		
		<div class="button"><input type="submit" value="Next"></div>
</cfform>
