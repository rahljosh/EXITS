
<cfquery name="religion" datasource="caseusa">
select *
from smg_religions
</cfquery>
<cfquery name="get_host_religion" datasource="caseusa">
select religion, religious_participation
from smg_hosts
where hostid = #client.hostid#
</cfquery>

<span class="application_section_header">Religious Participation</span>
<cfinclude template="../family_App_menu.cfm">

<cfform action="index.cfm?curdoc=forms/family_app_6">
<div class="row">

<cfif #get_host_religion.religious_participation# is "active"><cfinput type="radio" name="church_Activity" value="active" checked><cfelse><cfinput type="radio" name="church_Activity" value="active"></cfif>Active (2+ times a week)<br>
<cfif #get_host_religion.religious_participation# is "average"> <cfinput type="radio" name="church_Activity" value="average" checked><cfelse><cfinput type="radio" name="church_Activity" value="average"></cfif>Average (1-2x a week) <br>
<cfif #get_host_religion.religious_participation# is "little interest"><cfinput type="radio" name="church_Activity" value="little interest" checked><cfelse><cfinput type="radio" name="church_Activity" value="little interest"></cfif>Little Interest (occasionally)<br>
<cfif #get_host_religion.religious_participation# is "inactive"><cfinput type="radio" name="church_Activity" value="inactive" checked><cfelse><cfinput type="radio" name="church_Activity" value="inactive"></cfif>Inactive (Never attend)<br>
<cfif #get_host_religion.religious_participation# is "no interest"><cfinput type="radio" name="church_Activity" value="no interest" checked><cfelse><cfinput type="radio" name="church_Activity" value="no interest"></cfif>No Interest
</div>
<div class="row1">
<span class="label">Religious Affiliation</span><span class="formw"> <select name="religious_affiliation">
			<option value="00">Non-Religious
			<cfoutput query="religion">
			<cfif #get_host_religion.religion# is #religionid#><option value=#religionid# selected>#religionname#<cfelse><option value=#religionid#>#religionname#</cfif>
			</cfoutput>
			<option value=999999>Other
			</select></span>
			<span class="spacer"></span>
			</div>
<div class="button"><input type="submit" value="    Next    "></div>
</cfform>
