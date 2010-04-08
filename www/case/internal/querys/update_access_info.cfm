<Cfquery name="update_access" datasource="caseusa">
update user_access_rights
	set usertype = '#form.new_user_type#', advisorid = '#form.advisorid#'
	where id= #form.id#
</Cfquery>
<cfoutput>
	<cflocation url= "../index.cfm?curdoc=forms/region_access_rights&userid=#url.userid#" addtoken="no">
</cfoutput>