<cfquery name="update_congrats" datasource="mysql">
update smg_users
	set congrats_email = #form.congrats_email#
	where userid = #client.userid#
</cfquery>
<cflocation url="../index.cfm?curdoc=intrep/email_welcome&ce=u">