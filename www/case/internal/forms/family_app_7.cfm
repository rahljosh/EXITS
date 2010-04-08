


<cfquery name="select_prev_rules" datasource="caseusa">
select smokeconditions, religious_participation, churchtrans, churchfam, acceptsmoking,houserules_smoke,houserules_curfewweeknights,houserules_curfewweekends,houserules_chores,houserules_church,
houserules_other
from smg_hosts
where hostid = #client.hostid#
</cfquery>
<Cfif select_prev_rules.religious_participation is "active">
	<cfset religious_part = "We attend church more then two times a week and">
<cfelseif select_prev_rules.religious_participation is "average">
	<cfset religious_part = "We attend church 1-2 times a week and">
<cfelseif select_prev_rules.religious_participation is "little interest">
	<cfset religious_part = "We attend church occasionally and">
<cfelseif select_prev_rules.religious_participation is "inactive">
	<cfset religious_part = "We never attend church and">
<cfelseif select_prev_rules.religious_participation is "no interest">
	<cfset religious_part = "We have no interest in church attendance and">
<cfelse>
	<cfset religious_part = "">
</cfif>
<cfif select_prev_rules.churchfam is "yes">
	<cfset churchwithfam = " we expect our student to attend with us">
<cfelseif select_prev_rules.churchfam is "no">
	<cfset churchwithfam = " we do not expect our student to attend with us">
<cfelse>
	<cfset churchwithfam = "">
</cfif>
<Cfif select_prev_rules.churchtrans is "yes">
	<cfset trans = " but we will transport the student to there church if they so desire.">
<cfelseif select_prev_rules.churchtrans is "no">
	<cfset trans = " but the student will be required to find there own transprotation if they want to go to their own church.">
</cfif>
<Cfif select_prev_rules.acceptsmoking is "no" and select_prev_rules.acceptsmoking is ''>
	<cfset smoke="We will not accept a student who smokes.">
<Cfelseif select_prev_rules.acceptsmoking is "no" and select_prev_rules.acceptsmoking is not  ''>
	<cfset smoke="We will not accept a student who smokes unless">
<cfelseif select_prev_rules.acceptsmoking is "yes" and select_prev_rules.acceptsmoking is not ''>
	<cfset smoke="We will accept a student who smokes with the following exceptions," >
<cfelseif select_prev_rules.acceptsmoking is "yes" and select_prev_rules.acceptsmoking is ''>
	<cfset smoke="We will accept a student who smokes.">
<cfelse>
	<cfset smoke="">
</cfif>
<div class="application_section_header">House Rules</div><br>
<cfinclude template="../family_app_menu.cfm">
In addition to the information supplied with Host Family Application, we ask that you
explain to the student your household rules and personal expectations. It is very important
that your student be treated as a member of your family. We will share this information with
the student you select.
<div class="get_Attention">Some responses were automatically populated 
based on answers to previous questions, please make sure the answeres reflect your expectations.</div>
<cfform action="querys/insert_rules.cfm" method="post">
<cfoutput>
<div class="row">
Smoking:<br>
<textarea cols="50" rows="4" name="houserules_smoking" wrap="VIRTUAL"><cfif select_prev_rules.houserules_smoke is ''>#smoke# #select_prev_rules.smokeconditions#<cfelse>#select_prev_rules.houserules_smoke#</cfif> </textarea>
<span class="spacer"></span>
</div>
<div class="row1">
Curfew (school nights):<br>
<textarea cols="50" rows="4" name="houserules_curfewweeknights" wrap="VIRTUAL">#select_prev_rules.houserules_curfewweeknights#</textarea><br>
Curfew (weekends):<br>
<textarea cols="50" rows="4" name="houserules_curfewweekends" wrap="VIRTUAL">#select_prev_rules.houserules_curfewweekends#</textarea><br>
<span class="spacer"></span>
</div>
<div class="row">
Chores:<br>
<textarea cols="50" rows="4" name="houserules_chores" wrap="VIRTUAL">#select_prev_rules.houserules_chores#</textarea><br>
<span class="spacer"></span>
</div>
<div class="row1">
Church:<br> <i>include number of times/hours per week attendance will be expected</i><br>
<textarea cols="50" rows="4" name="houserules_church" wrap="VIRTUAL"><cfif select_prev_rules.houserules_church is ''>#religious_part##churchwithfam##trans#<cfelse>#select_prev_rules.houserules_church#</cfif></textarea><br>
<span class="spacer"></span>
</div>
<div class="row">
Other:<br> <i>please include any other rules or expectations you will have of your exchange student</i><br>
<textarea cols="50" rows="4" name="houserules_other" wrap="VIRTUAL">#select_prev_rules.houserules_other#</textarea><br>
<span class="spacer"></span>
</div>
</cfoutput> 

<div class="button"><input type="submit" value='    next    '>
</cfform>
</div>