<cfquery name="delete_fam_members" datasource="caseusa">
delete from smg_user_family
where id = #url.id#
</cfquery>
<cflocation url="../index.cfm?curdoc=forms/edit_family_members&userid=#url.userid#">