<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="check_rights.cfm">

<cfquery name="invoices" datasource="MYSQL">
select distinct intrepid as agent
from smg_invoices
</cfquery>

<cfloop query="invoices">
<cfquery name="retrieve_charges" datasource="MySQL">
select * from smg_invoices
where intrepid = #agent# and status <> 'cancel'
</cfquery>

<cfoutput query="retrieve_Charges">
<!----insert charges---->
<cfif inv_type is 'final' and charge lt 0>
<cfelse> 
<cfquery name="input_charges" datasource='mysql'>
insert into smg_charges(agentid, stuid, invoiceid, date, description, amount, companyid, invoicedate)
			values(#intrepid#, #studentid#, #number#, #date#, '#description#', #charge#, #companyid#, #date#)
</cfquery>
<!-----Insert Payment Info---->
<cfquery name="insert_payment" datasource="MySQL">
insert into smg_invoice (invoiceid, agentid, date)
			values(#number#, #intrepid#, #date#)
</cfquery>
</cfif>


</cfoutput>

</cfloop>