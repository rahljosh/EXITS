<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="check_rights.cfm">

<cfoutput>
<cflocation url="index.cfm?curdoc=invoice/user_account_details&userid=#form.userid#">
</cfoutput>