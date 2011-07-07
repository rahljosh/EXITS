<cfquery name="update_household_member" datasource="MYSQL">
	update smg_user_family
	set firstname = '#form.firstname#',
		lastname = '#form.lastname#',
		middlename = '#form.middlename#',
		relationship = '#form.relationship#',
		dob = #CreateODBCDate(form.dob)#
	where id = #form.edit#
</cfquery>

<cflocation url="../index.cfm?curdoc=forms/edit_family_members&userid=#url.userid#">