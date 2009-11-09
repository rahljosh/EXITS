<cftransaction action="begin" isolation="SERIALIZABLE" >
<cfquery name="delete_user" datasource="MySQL">
delete from smg_users
where userid = #client.deleteuser#
</cfquery>
</cftransaction>
<cfoutput>
<cflock timeout="30" name="delete_user" type="exclusive">
	<cfset structdelete(session, 'deleteuser')>
</cflock>
</cfoutput>

User has been successfully removed.