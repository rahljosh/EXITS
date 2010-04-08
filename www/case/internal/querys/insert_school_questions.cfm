<Cfif not isDefined('form.transportation')>
You must indicate how the student will be transported to school.  Click back to make a selection. 
<div class="button"><input name="back" type="image" src="pics/back.gif" align="right" border=0 onClick="history.back()"></div>
<cfabort>
</Cfif>

<Cfif #form.transportation# is "other" and #form.other_Desc# is ''>
You indicated 'Other' as the method of transportation to school, but didn't fill out the Other description box.<br>Use your browsers back button to enter the description.
<div class="button"><input name="back" type="image" src="pics/back.gif" align="right" border=0 onClick="history.back()"></div>
<cfabort>
<cfelseif #form.transportation# is not "other">
<Cfset form.other_desc = ''>
</cfif>
<cftransaction action="BEGIN" isolation="SERIALIZABLE">

<cfquery name="insert_school_questions" datasource="caseusa">
update smg_Schools
set special_programs = "#form.special_programs#",
	grad_policy = "#form.grad_policy#",
	sports = "#form.sports#",
	other_policies = "#form.other_policies#",
	private_School_info = "#form.private_school#",
	
	other_trans = "#form.other_desc#"	
where schoolid = #client.schoolid#
</cfquery>
<cfquery name="insert_transportation" datasource="caseusa">
update smg_hosts
set school_trans = "#form.transportation#"
where hostid = #client.hostid#
</cfquery>
</cftransaction>
<Cflocation url="index.cfm?curdoc=forms/family_App_7_pis" addtoken="no">