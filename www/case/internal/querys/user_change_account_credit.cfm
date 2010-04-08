<cfif client.usertype gte 5 or not isDefined('client.usertype')>
You can not perform this funtion
<cfoutput>
#client.usertype#
</cfoutput>
<cfabort>
<cfelse>
<cfquery name="update_account_credit" datasource="caseusa">
update smg_users
set account_credit = #form.account_Credit#
where userid = #url.userid#
</cfquery>
<cfoutput><Cflocation url="../index.cfm?curdoc=user_info&userid=#url.userid#">
</cfoutput>

</cfif>