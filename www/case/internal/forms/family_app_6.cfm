


<!----Conditional Things---->
	<cfform method="post" action="querys/insert_host_religion.cfm"> 

	<cfoutput>
	<input type="hidden" name="religion" value="#form.religious_Affiliation#">
	<input type="hidden" name="church_activity" value="#form.church_Activity#">
	</cfoutput>

	<!----Querys for needed info---->

	<cfinclude template="../querys/get_local.cfm">
	<cfquery name="churches" datasource="caseusa">
	select *
	from smg_churches
	where (religionaffiliation= #form.religious_affiliation#) and (city = "#local.city#") and (state = "#local.state#")
	</cfquery>
	<cfquery name="church_name" datasource="caseusa">
	select religionname
	from smg_religions
	where religionid = #form.religious_affiliation#
	</cfquery>
	<cfquery name="host_church" datasource="caseusa">
	select smg_hosts.churchid, smg_churches.churchid, smg_churches.churchname, smg_churches.address, smg_churches.address1,smg_churches.city, smg_churches.state,smg_churches.zip, smg_churches.pastorname,smg_churches.phone
	from smg_hosts, smg_churches
	where smg_hosts.hostid = #client.hostid# and smg_churches.churchid = smg_hosts.churchid
	</cfquery>
	<cfquery name="host_trans" datasource="caseusa">
	select churchfam, churchtrans
	from smg_hosts
	where hostid = #client.hostid#
	</cfquery>
	<!----Webpage Output---->
	
<span class="application_section_header">Religious Information</span>
<cfinclude template="../family_App_menu.cfm">
<cfif form.religious_affiliation is 00>
	<div class="row">
	You have indicated that you are non-religious.<br>If this is wrong, please use your browsers back button and indicate a religious affiliation.
	<br><br>
<cfelseif form.church_activity is "inactive" or form.church_activity is "no interest">
	<div class="row">
	You have indicated that you do not attend church but do have a religious affiliation.  
	<span class="spacer"></span>
<cfelse>
	
	
	<div class="row">

	<cfif form.religious_affiliation is 999999>
		<span class="label">Religion </span><span class="formw"><cfinput type=text name="new_religion" size="20"></span>
		
	<cfelse>
		<cfif churches.recordcount is 0>
		
			<cfoutput>
			Currently, there are no #church_name.religionname# churches in our system from #local.city# #local.state#. Please add your church below.
			</cfoutput>
		
		<cfelse>
		
			<Cfoutput>
			The following #church_name.religionname# churches in #local.city# #local.state# are in our system.  If your church is in the list, please select it. If it isn't, please select "Other" and enter the information below.</cfoutput>
			</div>
			<div class="row">
			<table>
				<Tr>
			<td class="label">Church </td><td><select name="church">
						<option>
						<cfoutput query="churches">
						<cfif host_church.churchname is #churchname#><option value=#churchid# selected>#churchname#<cfelse><option value=#churchid#>#churchname#</cfif>
						</cfoutput>
						<option value=0>Other
						</select></span>
			
			</td>
		</table>
		</cfif>
	</cfif>
		</div>
		
		<div class="row1">
		<Table border=0>
			<tr>
				
			<td class="label">Name of Church:</td><td class="form_text" colspan=3><cfinput name="church_name" size=20 type="text" value="#host_church.churchname#"></span>
		</tr>
		<tr>
			<td class="label">Address:</td><td class="form_text" colspan=3><cfinput name="address" size=20 type="text" value="#host_church.address#"></span>
		</tr>
		<tr>
			<td></td><td colspan=3 class="form_text"><cfinput name="address2" size=20 type="text" value="#host_church.address1#"></span>
		</tr>			 
		<tr>
			<td class="label">City: </td><td  colspan=3 class="form_text"><cfinput type="text" name="city" size="20" value="#host_church.city#">
		</tr>
		<tr>	
			<td class="label" > State: </td><td width=10 class="form_text">
		
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
	
	</td><td class="zip">Zip: </td><td class="form_text"><cfinput type="text" name="zip" size="5" value="#host_church.zip#"></td>

			</tr>
		<tr>
			<td class="label">Pastors Name:</td><td class="form_text" colspan=3><cfinput name="pastor_name" size=20 type="text" value="#host_church.pastorname#"></span>
		</tr>
		<tr>
			<td class="label">Phone:</td><td class="form_text" colspan=3><cfinput name="phone" size=20 type="text" value="#host_church.phone#"> nnn-nnn-nnnn</span>
				</tr>
			</table>			
			
		</div>
	</cfif>	
		<div class=row>
	

		
				<table><cfif form.church_activity is not "No Interest" and form.church_activity is not "Inactive" and form.religious_affiliation is not 00>
					<tr>
						<Td>Would you expect your exchange student to attend services with your family?</td>
					</tr>
					<tr>
						<td><cfif host_trans.churchfam is 'yes'><cfinput type="radio" name=stu_attend value="yes" checked>Yes <cfinput type="radio" name=stu_attend value="no">No<cfelse>
						<cfinput type="radio" name=stu_attend value="yes">Yes <cfinput type="radio" name=stu_attend value="no" checked>No</cfif></td>
					</tr>
					</cfif>
				<tr>
					<Td>Would you provide transportaion to your exchange student's religious services<cfif form.church_activity is "No Interest">?<cfelseif form.church_activity is "Inactive" >?<cfelse> if they are not <cfoutput>#church_name.religionname#</cfoutput>?</cfif></td>
				</tr>
				<tr>
					<td><cfif host_trans.churchtrans is 'yes'><cfinput type="radio" name=stu_trans value="yes" checked>Yes <cfinput type="radio" name=stu_trans value="no">No<cfelse>
					<cfinput type="radio" name=stu_trans value="yes">Yes <cfinput type="radio" name=stu_trans value="no" checked>No</cfif></td>
				</tr>
			</table>
		</div>
	</div>
	<div class="button"><input type="submit" value="    next   "></div>
	</cfform>
 

</body>
</html>
