<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="../check_rights.cfm">

<cfif not isDefined('form.beg_date')>
	<cfset form.beg_date = '09/01/2004'>
</cfif>
<cfset form.end_date = '08/31/2005'>
<cfif not isDefined('form.end_date')>
	<cfset form.end_date = #DateFormat(now(), 'mm/dd/yyyy')#>
</cfif>

<cfset agentid = 6442 >
<cfquery name="charges_paid" datasource="mysql">
select smg_payment_charges.amountapplied, smg_payment_charges.chargeid
from smg_payment_charges right join smg_charges on smg_payment_charges.chargeid = smg_charges.chargeid
where smg_charges.agentid = #agentid#
and (date between #CreateODBCDateTime(form.beg_Date)# and #CreateODBCDateTime(form.end_date)#)
</cfquery>
<cfset totalamount = 0>
<cfoutput query=charges_paid>
<cfif amountapplied is ''><cfset amount = 0><cfelse><cfset amount = #amountapplied#></cfif>
<cfset totalamount = #totalamount# + #amount#>
#chargeid# #amount#<br>
</cfoutput>

<cfoutput>
t:#totalamount#
</cfoutput>
<br><br>
<cfquery name="charges_unpaid" datasource="mysql">
select smg_charges.amount_due, smg_charges.chargeid, smg_payment_charges.amountapplied  
from smg_payment_charges left join smg_charges on smg_payment_charges.chargeid = smg_charges.chargeid  
where smg_payment_charges.chargeid = NULL AND smg_charges.agentid = #agentid#  
and (date between #CreateODBCDateTime(form.beg_Date)# and #CreateODBCDateTime(form.end_date)#)
and companyid = 1
</cfquery>

<!----
<cfquery name="charges_unpaid" datasource="mysql">
select smg_charges.amount_due, smg_charges.chargeid, smg_payment_charges.amountapplied
from smg_payment_charges right outer join smg_charges on smg_payment_charges.chargeid = smg_charges.chargeid
where smg_charges.agentid = #agentid#
and (date between #CreateODBCDateTime(form.beg_Date)# and #CreateODBCDateTime(form.end_date)#)
</cfquery>
---->
sdfsdf
<cfoutput query=charges_unpaid>

#chargeid# #amount_due# <br>
</cfoutput>
<!----
<cfquery name="payments" datasource="mysql">
select sum(totalreceived) as totalreceived
from smg_payment_received
where agentid = #agentid#
(date between #CreateODBCDateTime(form.beg_Date)# and #CreateODBCDateTime(form.end_date)#)
</cfquery>
<cfoutput> #payments.totalreceived#</cfoutput>
---->

