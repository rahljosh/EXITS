
<cfquery name="host_interests" datasource="caseusa">
select interests, interests_other, band, orchestra,comp_sports
from smg_hosts
where hostid=#client.hostid#
</cfquery>

<cfquery name="get_interests" datasource="caseusa">
select *
from smg_interests
order by interest
</cfquery>
<span class="application_section_header">Family activites and interests</span>
<cfinclude template="../family_app_menu.cfm">
<div class=row>
<cfform action="querys/insert_host_interest.cfm" method="post">
<table>

<tR>
<cfoutput query="get_interests"><td><cfinput type="checkbox" name="interest" value=#interestid#></td><td>#interest#</td>
<cfif (get_interests.currentrow MOD 4 ) is 0></tr><tr></cfif>
</cfoutput>
</table>
</div>
<cfoutput query="host_interests">
<div class="row1">
<table>
	<Tr>
		<td align="left">Does anyone play in a Band?</td><td><cfif band is 'yes'><cfinput type="radio" name=band value="yes" checked>Yes <cfinput type="radio" name=band value="no">No
														  <cfelseif band is 'no'><cfinput type="radio" name=band value="yes">Yes <cfinput type="radio" name=band value="no" checked>No  
														  <Cfelse><cfinput type="radio" name=band value="yes">Yes <cfinput type="radio" name=band value="no">No</cfif></td>
	</tr>
		<Tr>
		<td align="left">Does anyone play in an Orchastra?</td><td> <Cfif orchestra is 'yes'><cfinput type="radio" name=orchestra value="yes" checked>Yes  <cfinput type="radio" name=orchestra value="no">No
															   <cfelseif orchestra is 'no'><cfinput type="radio" name=orchestra value="yes">Yes  <cfinput type="radio" name=orchestra value="no" checked>No
															   <cfelse><cfinput type="radio" name=orchestra value="yes">Yes  <cfinput type="radio" name=orchestra value="no">No</cfif></td>
	</tr>
		<Tr>
		<td align="left">Does anyone play in competitive sports?</td><td> <Cfif comp_sports is 'yes'><cfinput type="radio" name=comp_sports value="yes" checked>Yes <cfinput type="radio" name=comp_sports value="no">No
																	  <cfelseif comp_sports is 'no'><cfinput type="radio" name=comp_sports value="yes" checked>Yes <cfinput type="radio" name=comp_sports value="no" checked>No
																	  <cfelse><cfinput type="radio" name=comp_sports value="yes">Yes <cfinput type="radio" name=comp_sports value="no"></cfif></td>
	</tr>
</table>
<br>

Please list any specific interests, hobbies, activities and any awards or commendations:<br>
<textarea cols="50" rows="8" name="specific_interests" wrap="VIRTUAL">#interests_other#</textarea>
</div>
<div class="button"><input type="submit" value="Next"></div>
<br>
</cfoutput>
</cfform>




































