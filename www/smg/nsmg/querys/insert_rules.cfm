<CFQUERY name="selectdb" datasource="MySQL">
USE smg
</CFQUERY>
<cftransaction action="BEGIN" isolation="SERIALIZABLE">
<cfquery name="insert_rules" datasource="MySQL">
update smg_hosts
	set
		houserules_smoke = "#form.houserules_smoking#",
		houserules_curfewweeknights = "#form.houserules_curfewweeknights#",
		houserules_curfewweekends = "#form.houserules_curfewweekends#",
		houserules_chores = "#form.houserules_chores#",
		houserules_church = "#form.houserules_church#",
		houserules_other = "#form.houserules_other#"
	where
		hostid = #client.hostid#
</cfquery>
</cftransaction>
<cflocation url="../index.cfm?curdoc=forms/family_app_8" addtoken="No">