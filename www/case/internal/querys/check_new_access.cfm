<cfoutput>

<Cfif form.new_access_region eq 0 and form.new_access_type eq 0>
	<cflocation url="../index.cfm?curdoc=user_info&userid=#url.userid#">
<cfelseif form.new_access_region neq 0 and form.new_access_type eq 0>
	<cflocation url="../index.cfm?curdoc=forms/region_access_rights&userid=#url.userid#&error=#form.new_access_region#">
<cfelseif form.new_access_region eq 0 and form.new_access_type neq 0>
	<cflocation url="../index.cfm?curdoc=forms/region_access_rights&userid=#url.userid#&error1=#form.new_access_type#">
<cfelseif form.new_access_region neq 0 and form.new_access_type neq 0>
	<Cfquery name="check_for_curent_access" datasource="caseusa">
	select regionid, userid
	from user_Access_rights
	where regionid = #form.new_access_region# and userid = #url.userid#
	</Cfquery>
	<cfif check_for_curent_access.recordcount gt 0>
	<cflocation url="../index.cfm?curdoc=forms/region_access_rights&userid=#url.userid#&error1=#form.new_access_type#&error=#form.new_access_region#&error2=">
	<cfelse>
	<cfquery name="insert_new_access" datasource="caseusa">
	insert into user_access_rights (userid, companyid, regionid, usertype)
		values (#url.userid#, #client.companyid#, #form.new_access_Region#, #form.new_access_type#)
	</cfquery>
	<cflocation url="../index.cfm?curdoc=forms/region_access_rights&userid=#url.userid#">
	</cfif>
</Cfif>
</cfoutput>
