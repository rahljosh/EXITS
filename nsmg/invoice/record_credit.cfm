<cfif form.stuid is ''>
<cfset form.stuid = 0>
</cfif>
<cfif form.orig_inv is ''>
<cfset form.orig_inv = 0>
</cfif>

<cfquery name="getLastCredit" datasource="MySQL">
SELECT MAX(creditid) AS creditid
FROM smg_credit
</cfquery>

<cfset creditNumber = getLastCredit.creditid + 1>

<cfquery name="insert_Credit" datasource="MySQL">
insert into smg_credit (creditid, agentid, stuid, invoiceid, description, amount, date, type, companyid)
			values(#creditNumber#, #url.agentid#, #form.stuid#, #form.orig_inv#, '#form.description#', #form.amount#, #now()#, '#form.type#', #client.companyid#)
</cfquery>

<cflocation url = "credit_confirmation.cfm">
