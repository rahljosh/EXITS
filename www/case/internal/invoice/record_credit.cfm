<cfif form.stuid is ''>
<cfset form.stuid = 0>
</cfif>
<cfif form.orig_inv is ''>
<cfset form.orig_inv = 0>
</cfif>
<cfquery name="insert_Credit" datasource="caseusa">
insert into smg_credit (agentid, stuid, invoiceid, description, amount, date, type, companyid, credit_type)
			values(#url.agentid#, #form.stuid#, #form.orig_inv#, '#form.description#', #form.amount#, #now()#, '#form.type#', #client.companyid#, '#form.credit_type#')
</cfquery>

<cflocation url = "credit_confirmation.cfm">
