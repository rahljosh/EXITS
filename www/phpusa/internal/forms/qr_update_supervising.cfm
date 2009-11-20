<cfdump var="#form#">

<cfquery name="qr_update_supervising" datasource="mysql">
update smg_users
set php_superviser = #form.super_rep#
where userid = #form.userid#
</cfquery>
<cfoutput>
<cflocation url="../index.cfm?curdoc=users/user_info&userid=#form.userid#">
</cfoutput>