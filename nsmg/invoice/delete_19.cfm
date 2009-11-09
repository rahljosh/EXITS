<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="check_rights.cfm">

<Cfquery name="get_payments" datasource="MySQL">
select * 
from smg_payment_received
where agentid = 19
</Cfquery>

<cfloop query="get_payments">
<cfquery name="ind_charges" datasource="MySQL">
delete from smg_payment_charges 
where paymentid = #paymentid#
</cfquery>
</cfloop>