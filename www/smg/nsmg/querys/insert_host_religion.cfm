<CFIF not isdefined("form.stu_attend")>
	<CFSET form.stu_Attend = "no">
</cfif>
<CFIF not isdefined("form.religious_affiliation")>
	<CFSET form.religious_affiliation = "999999">
</cfif>
<cftransaction action="BEGIN" isolation="SERIALIZABLE">
<CFQUERY name="selectdb" datasource="MySQL">
USE smg
</CFQUERY>
<!----Insert New Religion into Religions---->
<CFIF isdefined("form.new_religion")>
<cfquery name="add_religion" datasource="MySQL">
insert into smg_religions (religionname)
					values('#form.new_religion#')
</cfquery>
<cfquery name="get_religion_id" datasource="MySQL">
select max(religionid) as religion
from smg_Religions
</cfquery>
<cfset form.religion = #get_religion_id.religion#>
</cfif>

<!----Insert Religion into Hosts---->
<cfquery name="insert_religion" datasource="MySQL">
update smg_hosts
set religious_participation = "#form.church_activity#",
	religion = #form.religion#,
	churchfam = "#form.stu_attend#",
	churchtrans = "#form.stu_trans#"
where hostid = #client.hostid#
</cfquery>

<!----Insert Church Information---->
<cfif form.religion is not 00>
	<cfif form.church_activity is "No Interest" or form.church_activity is "Inactive">
	<cfelse>
		<cfquery name="insert_church" datasource="MySQL">
		insert into smg_churches (churchname, address, address1, city, state, zip, pastorname, phone, religionaffiliation)
					values ("#form.church_name#", "#form.address#", "#form.address2#", "#form.city#", "#form.state#",
					 "#form.zip#", "#form.pastor_name#", "#phone#", #form.religion#)
		</cfquery>

		<cfquery name="insert_church_in_fam" datasource="MySQL">
		update smg_hosts
		set churchid = #form.church#
		where hostid = #client.hostid#
		</cfquery>
	</cfif>
</cfif>



</cftransaction> 

<cflocation url="../index.cfm?curdoc=forms/family_app_7" addtoken="No">
