<CFIF not isdefined("form.school")>
	<CFSET form.school = "0">
</cfif>

<cftransaction>
<CFQUERY name="selectdb" datasource="MySQL">
USE smg
</CFQUERY>
<cfif form.school is 0>
<cfquery name="insert_school" datasource="MySQL">
insert into smg_Schools
			(schoolname,address,address2,city,state,zip,phone,fax,email,url,principal,numberofstudents,collegebound,begins,semesterbegins,ends, enrollment)
			values ("#form.name#","#form.address#","#form.address2#","#form.city#","#form.state#","#form.zip#","#form.phone#","#form.fax#","#form.email#","#form.url#","#form.principal#","#form.number_students#","#form.collegebound#","#form.begins#","#form.semester#","#form.ends#","#form.enroll#")
</cfquery>
<cfquery name="schoolid" datasource="MySQL">
Select MAX(schoolid) as newschoolid
from smg_schools
</cfquery>
<cfset client.schoolid= #schoolid.newschoolid#>
<cfquery name="add_School" datasource="MySQL">
update smg_hosts
set schoolid = #form.school#
where hostid = #client.hostid#
</cfquery>
<Cflocation url="../index.cfm?curdoc=forms/family_app_9" addtoken="no">
<cfelse>
<cfquery name="add_School" datasource="MySQL">
update smg_hosts
set schoolid = #form.school#
where hostid = #client.hostid#
</cfquery>
<cfset client.schoolid= #form.school#>

<Cflocation url="../index.cfm?curdoc=forms/family_app_9_confirm" addtoken="no">
</cfif>

</cftransaction>

