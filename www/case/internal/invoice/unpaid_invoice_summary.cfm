<cfset beg = '01/01/2004'>
<cfset end = '08/31/2005'>

<cfquery name="invoices" datasource="caseusa">
select invoiceid, agentid, date 
from smg_invoice
where (date between #CreateODBCDateTime(beg)# and #CreateODBCDateTime(end)#) 

order by agentid
</cfquery>

<cfoutput>

Agent ID -- Agent Name -- Amount Invoiced -- Amount Received -- Amount Due<br>
	<cfloop query = invoices>
	#agentid#
	<cfquery name="agent_name" datasource="caseusa">
	select businessname
	from smg_users where userid =#agentid#
	</cfquery>
	#agent_name.businessname#
	 #invoiceid# 

		<!----Get amount due on invoices and individual charges so can calcualte amount received---->
		<cfquery name="balancedue" datasource="caseusa">
			select sum(amount_due) as amount_due
			from smg_charges
			where invoiceid = #invoiceid#
			
		</cfquery>
		#LSCurrencyFormat(balancedue.amount_due,'local')#
		
		<!----get total charges paid---->
		<cfquery name="charges" datasource="caseusa">
		select chargeid
		from smg_charges
		where invoiceid = #invoiceid#
		</cfquery>
		<cfset amount_paid = 0>
		<cfloop query=charges>
		<!----loop through and figure how much was paid on each charge---->
			<cfquery name="paid" datasource="caseusa">
				select amountapplied
				from smg_payment_charges
				where chargeid = #chargeid#
			</cfquery>
			<cfif #paid.recordcount# eq 0>
				<cfset amount_paid_now = 0>
			<cfelse>
				<cfset amount_paid_now = #paid.amountapplied#>
			</cfif>
			<cfset amount_paid_now = #amount_paid# + #amount_paid_now#>
		</cfloop>
	<cfset total_balance = 0>
				#LSCurrencyFormat(amount_paid,'local')#
				<cfset balance = #balancedue.amount_due# - #amount_paid#>
				#balance#
				<!----
				<cfset total_balance = total_balance +  #balance#>
				#total_balance#
				---->
				<br>
	
				
	
	</cfloop>

</cfoutput>