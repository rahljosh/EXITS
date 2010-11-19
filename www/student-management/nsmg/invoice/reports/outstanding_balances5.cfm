<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="../check_rights.cfm">

<cfsetting requesttimeout="1000">

<cfif not isDefined('form.beg_date')>
	<cfset form.beg_date = '09/01/2005'>
</cfif>

<cfif not isDefined('form.end_date')>
	<cfset form.end_date = '01/04/2006'>
</cfif>

<cfquery name="agents" datasource="MySQL">
select userid, businessname
from smg_users 
where usertype = 8
order by businessname
</cfquery>

<!---
<table border="1" cellpadding="2" cellspacing="2">
	<tr>
		<td>Agent</td><td>ISE</td><td>INTO</td><td>ASA</td><td>DMD</td><td>SMG</td><td>Total</td>
	</tr>
<tr>
<cfset get_total = 0>
<cfoutput query=agents>
<td>#businessname#</td>
<cfloop list='1,2,3,4,5,12' index="x" >
	
	<cfquery name="charges_unpaid" datasource="mysql">
		SELECT sum(smg_charges.amount_due) as amount_due
		FROM smg_charges
		INNER JOIN smg_users ON smg_users.userid = smg_charges.agentid
		LEFT JOIN smg_payment_charges ON smg_payment_charges.chargeid = smg_charges.chargeid
		WHERE smg_payment_charges.chargeid IS NULL AND smg_charges.agentid = #userid# 
		AND (date between #CreateODBCDateTime(form.beg_Date)# and #CreateODBCDateTime(form.end_date)#) and smg_charges.companyid = #x#
	</cfquery>
	
	<cfif charges_unpaid.recordcount eq 0><cfset amount_due = 0><cfelse><cfset amount_due=#charges_unpaid.amount_due#></cfif>
			<td>#LsCurrencyFormat(amount_due,'local')#</td> <cfif #x# eq 5>
			<cfquery name="agent_total" datasource="mysql">
				SELECT sum(smg_charges.amount_due) as amount_due
				FROM smg_charges
				INNER JOIN smg_users ON smg_users.userid = smg_charges.agentid
				LEFT JOIN smg_payment_charges ON smg_payment_charges.chargeid = smg_charges.chargeid
				WHERE smg_payment_charges.chargeid IS NULL AND smg_charges.agentid = #userid# 
				AND (date between #CreateODBCDateTime(form.beg_Date)# and #CreateODBCDateTime(form.end_date)#)	
			</cfquery>
			<td>#LsCurrencyFormat(agent_total.amount_due,'local')# &nbsp;</td>
			</tr><tr></tr></cfif>
</cfloop>
</cfoutput> 
Total for all Companies #LsCurrencyFormat(agent_total.get_total,'local')#
</table>
 --->

<cfoutput>
Current Date Range: #form.beg_date# thru #form.end_date#
</cfoutput>
<cfform method="post" action="outstanding_balances5.cfm">
<cfoutput>
Date Range to include: <input type="text" value='#form.beg_date#' name=beg_date> thru <input type="text" name="end_date" value=#form.end_date#> 
</cfoutput>
<br>
<input type="submit" name="Update Dates">
</cfform>


<hr width="100%"><br><br>
<table width=100%>
<tr>
	<td>Agent</td><td>ISE</td><TD>INTO</TD><td>ASA</td><td>DMD</td><td>SMG</td><TD>Total</TD>
</tr>
<cfoutput query="agents">
<tr <cfif agents.currentrow mod 2>bgcolor="ededed"</cfif>><td>#businessname#</td>
<cfset total_agent_due = 0>
<cfloop list ='1,2,3,4,5,12' index=x>

	<cfquery name="current_invoices" datasource="mysql">
		select distinct invoiceid, invoicedate, companyid
		from smg_charges
		where agentid = #agents.userid#
		and invoiceid <> 0
		and companyid = #x#
		AND (date between #CreateODBCDateTime(form.beg_Date)# and #CreateODBCDateTime(form.end_date)#)				
		order by invoicedate
	</cfquery>
		<cfset agent_company_total_charged = 0>
		<cfset agent_company_paid = 0>
		<cfset agent_company_bal = 0>
		
	<cfloop query="current_invoices">
		<cfquery name="invoice_totals" datasource="mysql">
			select sum(amount_due) as invoice_due
			from smg_charges
			where invoiceid = #invoiceid#
		</cfquery>

		<cfquery name="invoice_charge_id" datasource="MySQL">
		select smg_charges.chargeid
		from smg_charges where invoiceid = #invoiceid#
		</cfquery>
		
		<cfset total_invoice_amount_received =0>
		<cfquery name="invoice_totals" datasource="mysql">
			select sum(amount_due) as invoice_due
			from smg_charges
			where invoiceid = #invoiceid#
		</cfquery>
		
		<cfquery name="invoice_charge_id" datasource="MySQL">
		select smg_charges.chargeid 
		from smg_charges 
		where smg_charges.invoiceid = #invoiceid#
		</cfquery>
		
		<Cfloop query="invoice_charge_id">
			<cfquery name="get_applied_amount" datasource="mysql">
			select amountapplied
			from smg_payment_charges
			where chargeid = #invoice_charge_id.chargeid#
			</cfquery>
				<cfloop query=get_applied_amount>
					<cfset total_invoice_amount_received = #total_invoice_amount_received# + #get_applied_amount.amountapplied#>
				</cfloop>
		</Cfloop>
				
					
		<cfset inv_balance = #invoice_totals.invoice_due# - #total_invoice_amount_received#>

				
		<!----
		<Cfset payref.paymentref = ''>

	<Tr <cfif current_invoices.currentrow mod 2>bgcolor="ededed"</cfif>>
		<Td>#current_invoices.currentrow#</Td><td>#invoiceid#</a></td><td>#DateFormat(current_invoices.invoicedate, 'mm-dd-yyyy')#</td><td>#LSCurrencyFormat(invoice_totals.invoice_due, 'local')#</td><td>#LSCurrencyFormat(total_invoice_amount_received, 'local')# <font size=-2>#payref.paymentref#</font></td><td><cfset inv_balance = #invoice_totals.invoice_due# - #total_invoice_amount_received#>#LSCurrencyFormat(inv_balance, 'local')#</td><td>#companyid#</td>
	</Tr>
	---->
	

<cfset agent_company_total_charged = #agent_company_total_charged# + #invoice_totals.invoice_due#>
<cfset agent_company_paid = #agent_company_paid# + #total_invoice_amount_received#>


	</cfloop>
	<cfset agent_company_bal = #agent_company_total_charged # - #agent_company_paid#>
	<cfset total_agent_due = #total_agent_due# + #agent_company_bal#>
	<td>#LSCurrencyFormat(agent_company_bal,'local')#</td><cfif #x# eq 5><td>#LSCurrencyFormat(total_agent_due,'local')#</td></tr><tr></cfif>
</cfloop>
</cfoutput>

</table>
