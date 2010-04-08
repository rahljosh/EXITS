<cfquery name="account_info_ok" datasource="caseusa">
update smg_users
set firstlogin = 1
where userid = #client.userid#
</cfquery>
<cflocation url="../index.cfm?curdoc=initial_welcome">