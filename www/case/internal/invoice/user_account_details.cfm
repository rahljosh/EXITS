<cfsetting requestTimeOut = "800">

<!----Cookie list for recent agents accessed---->
<cfif isDefined('cookie.intagentlist')>
	<cfset intagentlist = #cookie.intagentlist#>
		<cfif listcontains(intagentlist,#url.userid#, ',')>
			<cfset cookie.intagentlist = #intagentlist#>
		<cfelse>
			<cfif listlen(intagentlist) eq 5>
				<cfset intagentlist = #ListDeleteAt(intagentlist, 1, ',')#>
				<cfset intagentlist = #ListAppend(intagentlist, #url.userid#, ',')#>
				
			<cfelse>
				<cfset intagentlist = #ListAppend(intagentlist, #url.userid#, ',')#>
			</cfif>
		</cfif>
	<cfcookie name=intagentlist value="#intagentlist#" expires="never">
<cfelse>
<cfcookie name=intagentlist value="#url.userid#" expires="never">
</cfif>

<!-------->


<cfif isDefined('url.invall')>
	<Cfset form.view = 'all'>
<cfelse>
	<cfset form.view = #client.companyid#>		
</cfif>


<cfif client.companyid is 5><Cfoutput>
  <div align="center"><a href="?curdoc=invoice/user_account_details&userid=#url.userid#">Show only CASE </a> :: <a href="?curdoc=invoice/user_account_details&userid=#url.userid#&invall">Include all company numbers</a></div>
</Cfoutput></cfif>

<Cfquery name="agent_details" datasource="caseusa">
	select businessname, firstname, lastname, city, smg_countrylist.countryname
	from smg_users
	LEFT JOIN smg_countrylist ON smg_countrylist.countryid = smg_users.country
	where userid = #url.userid#
</Cfquery>
<!----
<cfquery name="received_payments" datasource="caseusa">
SELECT smg_charges.agentid, sum( smg_payment_received.totalreceived ) AS amount_paid
FROM smg_payment_received INNER JOIN ((smg_invoice INNER JOIN smg_charges ON smg_invoice.invoiceid = smg_charges.invoiceid) INNER JOIN smg_payment_charges ON smg_charges.chargeid = smg_payment_charges.chargeid) ON smg_payment_received.paymentid = smg_payment_charges.paymentid
GROUP BY smg_charges.agentid
HAVING (((smg_charges.agentid)=#userid#))
</cfquery>
---->

			<Cfquery name="total_Due" datasource="caseusa">
			select sum(amount_due) as amount_due
			from smg_charges
			where agentid = #URL.userid# 
			<cfif form.view is not 'all'>
			and companyid = #client.companyid#
			</cfif>
			</Cfquery>
			<cfif total_due.amount_due is ''>
			<cfset total_due.amount_due = 0>
			</cfif>
			
			
			<cfquery name="total_received" datasource="caseusa">
			select sum(totalreceived) as total_received
			from smg_payment_received
			where agentid = #url.userid# 			
			<cfif form.view is not 'all'>
			and companyid = #client.companyid#
			</cfif>
			</cfquery>
			<cfif total_received.total_received is ''>
			<cfset total_received.total_received = 0>
			</cfif>
			<!----total credits in system---->
			<cfquery name="total_Credit_amount" datasource="caseusa">
			select sum(amount) as credit_amount
			from smg_credit
			where agentid = #url.userid#
			<cfif form.view is not 'all'>
			and companyid = #client.companyid#
			</cfif>
			and active = 1
			</cfquery>
			<cfif total_Credit_amount.credit_amount is ''>
			<cfset total_Credit_amount.credit_amount = 0>
			</cfif>
			<!----Total credits applied---->
			<cfquery name="total_Credit_applied" datasource="caseusa">
			select sum(amount_applied) as credit_amount
			from smg_credit
			where agentid = #url.userid#
			<cfif form.view is not 'all'>
			and companyid = #client.companyid#
			</cfif>
			and active = 1
			</cfquery>
			<cfif total_Credit_applied.credit_amount is ''>
			<cfset total_Credit_applied.credit_amount = 0>
			</cfif>
			
			<cfset total_credit = #total_credit_amount.credit_amount# - #total_credit_applied.credit_amount#>
			
			<cfquery name="overpayment_credit" datasource="caseusa">
			select sum(amount) as overpayment_amount
			from smg_credit
			where agentid = #url.userid# and payref <> '' and active = 0
			<cfif form.view is not 'all'>
			and companyid = #client.companyid#
			</cfif>
			</cfquery>
			<cfif overpayment_credit.overpayment_amount is ''>
			<cfset overpayment_credit.overpayment_amount = 0>
			</cfif>


			<cfquery name="total_refund" datasource="caseusa">
			select sum(smg_credit.amount) as total_refund
			from smg_invoice_refunds right join smg_credit on smg_invoice_refunds.creditid = smg_credit.creditid
			where smg_invoice_refunds.agentid =#url.userid#
			
				<cfif form.view is not 'all'>
				and smg_invoice_refunds.companyid = #client.companyid#
				</cfif>
			</cfquery>
			<cfif total_refund.total_refund is ''>
				<cfset total_refund.total_refund = 0>
			</cfif>
			
			
			<!----Refund Query not combined---->
			<!----<cfquery name="refunds" datasource="caseusa">
			select *
			from smg_invoice_refunds
			where smg_invoice_refunds.agentid = #url.userid#
			<cfif form.view is not 'all'>
			and smg_invoice_refunds.companyid = #client.companyid#
			</cfif>
			and smg_invoice_refunds.refund_receipt_id = 0
			</cfquery>---->
			<cfquery name="refunds" datasource="caseusa">
			select smg_invoice_refunds.creditid, smg_invoice_refunds.id, smg_invoice_refunds.refund_receipt_id, smg_invoice_refunds.date, smg_invoice_refunds.amount,
			smg_credit.creditid, smg_credit.amount as credit_amount, smg_credit.description
			from smg_invoice_refunds right join smg_credit on smg_invoice_refunds.creditid = smg_credit.creditid
			where smg_invoice_refunds.agentid = #url.userid#
			<cfif form.view is not 'all'>
			and smg_invoice_refunds.companyid = #client.companyid#
			</cfif>
			and smg_invoice_refunds.refund_receipt_id = 0
			</cfquery>
			<!----Refund Query not combined---->
			<cfquery name="refunds1" datasource="caseusa">
			select  distinct smg_invoice_refunds.refund_receipt_id
			from smg_invoice_refunds 
			where smg_invoice_refunds.agentid = #url.userid#
			<cfif form.view is not 'all'>
			and smg_invoice_refunds.companyid = #client.companyid#
			</cfif>
			and smg_invoice_refunds.refund_receipt_id <> 0
			</cfquery>
			
			
<Cfoutput>

<Table width=100% border=0>
	<tr>
		<td width=50% valign="top">
	



<!----Overview---->
					
					<table width=1000% cellpadding=0 cellspacing=0 border=0 height=24>
						<tr valign=middle height=24>
							<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
							<td width=26 background="pics/header_background.gif"><img src="pics/$.gif"><img src="pics/$.gif"><img src="pics/$.gif"></td>
							<td background="pics/header_background.gif"><h2>&nbsp;&nbsp;Overview</td><td background="pics/header_background.gif" width=16></a></td>
							<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
						</tr>
					</table>
					
					
						
					<table width=100% cellpadding=2 cellspacing=0 border=0 class="section">
						<tr>
							<td style="line-height:20px;" valign="top">
							<table width = 100%>
								<tr>
									<td valign="top" width=50%>
									<b>#agent_details.businessname#</b><br>
									Agent ID: #userid#<br>
		#agent_Details.firstname# #agent_details.lastname#<br>
		#agent_details.city#, #agent_details.countryname#

									</td>
									
									<td>&nbsp;</td>
									<td valign="top" align="right">
									<!---Current Balance---->
									<table align="right">
											<tr><strong></strong>
												<td><b>Balance:</b></td><td><cfset balance_due = #total_due.amount_due# - #total_credit#- #total_received.total_received# + #overpayment_credit.overpayment_amount#>
												<b>#LSCurrencyFormat(balance_due, 'local')#</b></td>
											</tr>
										
											<tr>
												<td>Last Payment</td><td>
												<Cfquery name="recent_date" datasource="caseusa">
												select max(date) as recent_pay
												from smg_payment_received
												where agentid = #url.userid#
													<cfif form.view is not 'all'>
													and companyid = #client.companyid#
													</cfif>
												</Cfquery>
												<cfif recent_Date.recent_pay is ''>
												<cfset last_payment.totalreceived = 0>
												<cfelse>
												
												<cfquery name="last_payment" datasource="caseusa">
												select totalreceived from smg_payment_received
												where agentid = #url.userid# and date = #recent_date.recent_pay#
												</cfquery>
												</cfif>
												
												
												
												#LSCurrencyFormat(last_payment.totalreceived, 'local')#
												</td>
											</tr>
											<tr>
												<td>Pay Date:</td><Td><cfif last_payment.totalreceived is not 0>#DateFormat(recent_date.recent_pay, 'mm/dd/yyyy')#</cfif></Td>
											</tr>
											
											<tr>
												<td>Credit</td><td>#LSCurrencyFormat(total_credit, 'local')#</td>
											</tr>
										</table>
									
									</td>
								</tr>
							</table>
							
							
										
								
					
							</td>
						</tr>
						
					</table>
					<!----footer of table---->
								<table width=100% cellpadding=0 cellspacing=0 border=0>
									<tr valign=bottom >
										<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
										<td width=100% background="pics/header_background_footer.gif"></td>
										<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
									</tr>
								</table>
				</td>
				<td></td>
				<td valign="top">
				<!----Account Options---->
				
				<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
						<tr valign=middle height=24>
							<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
							<td width=26 background="pics/header_background.gif"><img src="pics/$.gif"><img src="pics/$.gif"><img src="pics/$.gif"></td>
							<td background="pics/header_background.gif"><h2>&nbsp;&nbsp;Account Tasks</td><td background="pics/header_background.gif" width=16></a></td>
							<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
						</tr>
					</table>
					
					
						
					<table width=100% cellpadding=4 cellspacing=0 border=0 class="section" >
						<tr>
							<td style="line-height:20px;" valign="top">
							<cfif form.view is not 'all'>
						
						<Table  border=0 width=100%>
							
							<tr>
								<td>
								   
								:: <cfif client.userid is 1967><cfelse><a class=nav_bar href="" onClick="javascript: win=window.open('invoice/add_charge.cfm?userid=#url.userid#', 'Charges', 'height=395, width=602, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"></cfif>Add Charge</a>	
								
								</td><td>::<cfif client.userid is 1967><cfelse> <a href="?curdoc=invoice/select_invoice_type&agentid=#url.userid#"></cfif>Create Invoice</a></td>
								<td>:: <a class=nav_bar href="" onClick="javascript: win=window.open('invoice/issue_refund.cfm?userid=#url.userid#', 'Refund', 'height=395, width=622, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Issue Refund</a></td>
							</tr>
							<tr>
								<td>:: <cfif client.userid is 1967><cfelse><a class=nav_bar href="" onClick="javascript: win=window.open('invoice/receive_payment.cfm?userid=#url.userid#', 'Payments', 'height=395, width=602, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"></cfif>Receive Payment</a></td>
								<td>:: <cfif client.userid is 1967><cfelse><a class=nav_bar href="" onClick="javascript: win=window.open('invoice/credit_account.cfm?userid=#url.userid#', 'Payments', 'height=395, width=602, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"></cfif>Credit Account</a></td>
								<td>:: <a class=nav_bar href="" onClick="javascript: win=window.open('invoice/create_refund_receipt.cfm?userid=#url.userid#', 'Refund', 'height=395, width=622, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Create Refund Receipt</a></td>
							</tr>
							<tr>
								<td>:: <a href="?curdoc=invoice/date_range&userid=#url.userid#">Monthly Statement</a></td><td>::<cfif client.userid is 1967><cfelse> <a href="?curdoc=forms/program_discount&userid=#url.userid#"></cfif>Fee Maint.</a></td><td></td>
							</tr>
							
						</Table>
						</cfif>
							
										
								
					
							</td>
						</tr>
						
					</table>
					<!----footer of table---->
								<table width=100% cellpadding=0 cellspacing=0 border=0>
									<tr valign=bottom >
										<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
										<td width=100% background="pics/header_background_footer.gif"></td>
										<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
									</tr>
								</table>
				
				
				
				
			
			
				</td>
			</tr>
		</table>



</cfoutput>
<!----Current Charges not invoiced---->
<cfquery name="current_charges" datasource="caseusa">
select chargeid, stuid, invoiceid, description, date, amount, type
from smg_charges
where agentid = #url.userid# and invoiceID = 0
			<cfif form.view is not 'all'>
			and companyid = #client.companyid#
			</cfif>
</cfquery>
<br>
<!----Sizing table---->
<Table width=100% border=0>
	<tr>
		<td width=50% valign="top">
<!----Recent Charges Not Invoiced---->
		<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
								<tr valign=middle height=24>
									<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
									<td width=26 background="pics/header_background.gif"><img src="pics/$.gif"><img src="pics/$.gif"><img src="pics/$.gif"></td>
									<td background="pics/header_background.gif"><h2>&nbsp;&nbsp;Recent Charges Not Yet Invoiced</td><td background="pics/header_background.gif" width=16></a></td>
									<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
								</tr>
							</table>
							
		
								
							<table width=100% cellpadding=2 cellspacing=0 border=0 class="section" >
								
			<tr>
				<td></td><td>Student</td><td>Description</td><td>Type</td><td>Amount</td>
			</tr>
			<cfif current_charges.recordcount eq 0>
				<tr>
					<td colspan=5 align="center">No open charges.</td>
				</tr>
			<cfelse>
						<cfoutput query="current_charges">
			
					<cfquery name="student_name" datasource="caseusa">
					select firstname, familylastname
					from smg_students
					where studentid = #stuid#
					</cfquery>
					<Tr <cfif current_charges.currentrow mod 2>bgcolor="ededed"</cfif>>
					
					
						<td>E D</td><td>#student_name.firstname# #student_name.familylastname# <cfif stuid is 0><Cfelse>(#stuid#)</cfif></td><td>#description#</td><Td>#type#</Td><td>#LSCurrencyFormat(amount,'local')#</td>
					</Tr>
					
					</cfoutput>
			</cfif>
			
		</table>
		

		<!----foter table---->
		<table width=100% cellpadding=0 cellspacing=0 border=0>
									<tr valign=bottom >
										<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
										<td width=100% background="pics/header_background_footer.gif"></td>
										<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
									</tr>
								</table>
		
	</td>
	
	<td></td>
	<td>
			<!----Refunds---->
			<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
								<tr valign=middle height=24>
									<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
									<td width=26 background="pics/header_background.gif"><img src="pics/$.gif"><img src="pics/$.gif"><img src="pics/$.gif"></td>
									<td background="pics/header_background.gif"><h2>&nbsp;&nbsp;Refunds </td><td background="pics/header_background.gif" align="right">
	
			<!----<cfif refunds.recordcount eq 0 and refunds1.recordcount eq 0 >
			<cfelse>
			<cfoutput>
			<h2>Total: #LSCurrencyFormat(total_refund.total_refund,'local')#</h2>
			</cfoutput>
			</cfif>---->
									</td>
									<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
								</tr>
							</table>
							
		
								
							<table width=100% cellpadding=2 cellspacing=0 border=0 class="section" >
								
			<tr>
				<td>ID</td><td>Date</td><td>Description</td><td>Amount</td>
			</tr>
			<cfif refunds.recordcount eq 0 and refunds1.recordcount eq 0>
			<tr>
				<td colspan=3>No refunds have been issued.</td>
			</tr>
			<cfelse>
			<cfoutput>
			<cfloop query="refunds">
			<!----<cfquery name="refund_sent" datasource="caseusa">
						select amount 
						from smg_invoice_refunds
						where id = #refund_receipts_id#
						</cfquery>---->
			<tr>
				<td><a href="invoice/refund_receipt.cfm?id=#id#&userid=#url.userid#" target="_top">#creditid#</td><td>#DateFormat(date, 'mm/dd/yyyy')#</td><td>#description#</td><td>#LSCurrencyFormat(refunds.amount,'local')#</td>
			</tr>
			</cfloop>
			<cfloop query="refunds1">
						<cfquery name="refunds1_date" datasource="caseusa">
						select  distinct date 
						from smg_invoice_refunds 
						where refund_receipt_id = #refund_receipt_id#
						</cfquery>
						<cfquery name="refund_total" datasource="caseusa">
						select sum(smg_credit.amount) as total_amount
						from smg_invoice_refunds right join smg_credit on smg_invoice_refunds.creditid = smg_credit.creditid
						where smg_invoice_refunds.agentid =#url.userid#
						and smg_invoice_refunds.refund_receipt_id = #refund_receipt_id#
						</cfquery>
						<!----<cfquery name="refund_sent" datasource="caseusa">
						select amount 
						from smg_invoice_refunds
						where id = #refund_receipts_id#
						</cfquery>---->
				<tr>
				<td><a href="invoice/view_refund_receipt.cfm?id=#refund_receipt_id#&userid=#url.userid#" target="_top">#refund_receipt_id#</td><td>#DateFormat(refunds1_date.date, 'mm/dd/yyyy')#</td><td><a href="invoice/view_refund_receipt.cfm?id=#refund_receipt_id#&userid=#url.userid#" target="_top">Click to see detailsls</td><td><!----#LSCurrencyFormat(refund_sent.amount,'local')#----></td>
			</tr>
			</cfloop>
	
			</cfoutput>
			</cfif>
			
			<!----
			<cfquery name="refunds" datasource="caseusa">
			
			</cfquery>
						<cfif current_charges.recordcount eq 0>
				<tr>
					<td colspan=5 align="center">No refunds issued.</td>
				</tr>
			<cfelse>
						<cfoutput query="refunds">
			
					<cfquery name="student_name" datasource="caseusa">
					select firstname, familylastname
					from smg_students
					where studentid = #stuid#
					</cfquery>
					<Tr <cfif current_charges.currentrow mod 2>bgcolor="ededed"</cfif>>
					
					
						<td><a class=nav_bar href="" onClick="javascript: win=window.open('invoice/edit_charge.cfm?chargeid=#chargeid#', 'Charges', 'height=395, width=602, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">	#DateFormat(date, 'mm-dd-yyyy')#</a></td><td>#student_name.firstname# #student_name.familylastname# <cfif stuid is 0><Cfelse>(#stuid#)</cfif></td><td>#description#</td><Td>#type#</Td><td>#LSCurrencyFormat(amount,'local')#</td>
					</Tr>
					
					</cfoutput>
					
			</cfif>
			---->
		</table>
		<!----foter table---->
		<table width=100% cellpadding=0 cellspacing=0 border=0>
									<tr valign=bottom >
										<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
										<td width=100% background="pics/header_background_footer.gif"></td>
										<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
									</tr>
								</table>
			
	</td>
	
</tr>
</table>






<style type="text/css">
<!--
div.scroll {
	height: 200px;
	width: 99.8%;
	overflow: auto;
	border-left: 2px solid #c6c6c6; background: #Ffffe6;
}
-->
</style>



<!----Invoices this Month---->
<cfquery name="current_invoices" datasource="caseusa">
select distinct invoiceid, invoicedate, companyid
from smg_charges
where agentid = #url.userid#
and invoiceid <> 0
			<cfif form.view is not 'all'>
			and companyid = #client.companyid#
			</cfif>
			
order by invoicedate
</cfquery>

<br>
<table width=100% align="center">
	<tr>
		<td>
		


				<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
						<tr valign=middle height=24>
							<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
							<td width=26 background="pics/header_background.gif"></td>
							<td background="pics/header_background.gif"><h2>Invoices</td><td background="pics/header_background.gif" width=16></td>
							<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
						</tr>
					</table>

<div class=scroll>
		<table width=98% cellpadding=4 cellspacing =0>
			<tr>
				<Td></Td><td>Invoice</td><td>Date Created</td><td>Amount</td><td>Payments</td><td>C/C/R</td><td>Balance</td><cfif form.view is 'all'><td>Comp</td></cfif>
			</tr>
			<cfoutput query="current_invoices">
				<cfquery name="invoice_totals" datasource="caseusa">
					select sum(amount_due) as invoice_due
					from smg_charges
					where invoiceid = #invoiceid#
					
				</cfquery>
				
				<cfquery name="invoice_charge_id" datasource="caseusa">
				select smg_charges.chargeid
				from smg_charges where invoiceid = #invoiceid#
				</cfquery>
				
				<cfset total_invoice_amount_received =0>
				<cfquery name="invoice_totals" datasource="caseusa">
					select sum(amount_due) as invoice_due
					from smg_charges
					where invoiceid = #invoiceid#
				</cfquery>
				
				<cfquery name="invoice_charge_id" datasource="caseusa">
				select smg_charges.chargeid 
				from smg_charges 
				where smg_charges.invoiceid = #invoiceid#
				</cfquery>
				
				<Cfloop query="invoice_charge_id">
					<cfquery name=get_applied_amount datasource="caseusa">
					select amountapplied
					from smg_payment_charges
					where chargeid = #invoice_charge_id.chargeid#
					
					</cfquery>
						<cfloop query=get_applied_amount>
							<cfset total_invoice_amount_received = #total_invoice_amount_received# + #get_applied_amount.amountapplied#>
						</cfloop>
				</Cfloop>
						
				
				<Cfset payref.paymentref = ''>
				
				
		
			<Tr <cfif current_invoices.currentrow mod 2>bgcolor="ededed"</cfif>>
				<Td>#current_invoices.currentrow#</Td><td><a href="invoice/invoice_view.cfm?id=#invoiceid#" target="top">#invoiceid#</a></td><td>#DateFormat(current_invoices.invoicedate, 'mm-dd-yyyy')#</td><td>#LSCurrencyFormat(invoice_totals.invoice_due, 'local')#</td><td>#LSCurrencyFormat(total_invoice_amount_received, 'local')# <font size=-2>#payref.paymentref#</font></td><td></td><td><cfset inv_balance = #invoice_totals.invoice_due# - #total_invoice_amount_received#>#LSCurrencyFormat(inv_balance, 'local')#</td><cfif form.view is 'all'><td>#companyid#</td></cfif>
			</Tr>
			</cfoutput>
		</table>
	</div>
				<table width=100% cellpadding=0 cellspacing=0 border=0>
					<tr valign=bottom >
						<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
						<td width=100% background="pics/header_background_footer.gif"></td>
						<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
					</tr>
				</table>
</td>
<td>&nbsp;</td>
<td width = 50%>

				<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
						<tr valign=middle height=24>
							<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
							<td width=26 background="pics/header_background.gif"></td>
							<td background="pics/header_background.gif"><h2>Payments Received - <font size=-2>payments from / applied from all companies</font></h2></td><td background="pics/header_background.gif" width=16></td>
							<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
						</tr>
					</table>
					<div class=scroll>
<table width=98% cellpadding=4 cellspacing =0>


	<tr>
		<Td></Td><td>Payment Ref</td><td>Payment Type</td><td>Date Applied</td><td>Amount</td>
	</tr>
	
<Cfquery name="payments_received" datasource="caseusa">
select distinct paymentref
from smg_payment_received
where agentid = #url.userid#
			<cfif form.view is not 'all'>
			and companyid = #client.companyid#
			</cfif>
			
</Cfquery>
	
<cfoutput query=payments_received>
	<cfquery name="totals" datasource="caseusa">
	select agentid, paymenttype, date, paymentref, paymenttype, sum(totalreceived) as payment_total
	from smg_payment_received
	where paymentref = '#paymentref#' and agentid = #url.userid#
	group by agentid
	</cfquery>

	<cfloop query=totals>
		<cfquery name="agent_details" datasource="caseusa">
		select businessname
		from smg_users
		where userid = #agentid#
		</cfquery>
	
		<Tr <cfif payments_received.currentrow mod 2>bgcolor="ededed"</cfif>>
			<td>#payments_received.currentrow#</td><td><a class=nav_bar href="" onClick="javascript: win=window.open('invoice/payment_details.cfm?ref=#paymentref#&userid=#url.userid#', 'Payment_Details', 'height=395, width=602, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">#paymentref#</a></td><td>#paymenttype#</td><td>#DateFormat(date, 'mm-dd-yyyy')#</td><td>#LSCurrencyFormat(payment_total, 'local')#</td><cfif form.view is 'all'><td></td></cfif>
		</Tr>
	</cfloop>
</cfoutput>
</table>
</div>
				<table width=100% cellpadding=0 cellspacing=0 border=0>
					<tr valign=bottom >
						<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
						<td width=100% background="pics/header_background_footer.gif"></td>
						<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
					</tr>
				</table>
		</td>
	</tr>
	<tr>
		<td colspan=3>
		
		<br>

		
		

<!----Unapplied Credits---->
				
<Cfquery name="credits_active" datasource="caseusa">
select date, type, description, stuid, invoiceid, amount, creditid, amount_applied, c.companyshort, credit_type
from smg_credit
LEFT JOIN smg_companies c ON c.companyid = smg_credit.companyid
where agentid = #url.userid# <!--- <cfif form.view is not 'all'>
								and smg_credit.companyid = #client.companyid# 
							 </cfif>   --->
and  active = 1
</Cfquery>

<table width=1000% cellpadding=0 cellspacing=0 border=0 height=24>
						<tr valign=middle height=24>
							<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
							<td width=26 background="pics/header_background.gif"></td>
							<td background="pics/header_background.gif"><h2>Credits & Cancellations Unapplied</h2></td><td background="pics/header_background.gif" width=16></td>
							<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
						</tr>
					</table>
					<div class=scroll>
<table width=100% cellpadding=4 cellspacing =0>

<tr>
		<Td>ID</Td><td></td><td>Date</td><td>Type</td><td></td><td>Desc.</td><td>Student</td><td>Inv</td><td>Amount</td><td>Applid</td><td>Remaining</td>
	</tr>
<Cfoutput>

	
<cfif credits_active.recordcount is 0>
	<tr>
		<td colspan=8 align="center">No credits, refunds or discounts applied to your account.</td>
	</tr>
<cfelse>
<cfloop query=credits_active>
		<Tr <cfif credits_active.currentrow mod 2>bgcolor="ededed"</cfif>>
			<td><a href="invoice/credit_note.cfm?creditid=#creditid#" target="_blank">#credits_active.creditid#</a></td><td>#companyshort#</td><td>#DateFormat(date, 'mm-dd-yyyy')#</td><td>#type#</td><td>#credit_type#</td><td>#description#</td><td><Cfif stuid is 0 or stuid is ''>N/A<cfelse>#stuid#</Cfif></td><td><Cfif invoiceid is 0 or invoiceid is ''>N/A<cfelse>#invoiceid#</Cfif></td><td>#LSCurrencyFormat(amount,'local')#</td><td>#LSCurrencyFormat(amount_applied,'local')#</td><td><cfset bal=#amount# - #amount_applied#>#LSCurrencyFormat(bal,'local')#</td>
		</Tr>
	</cfloop>
</cfif>
</Cfoutput>	
</table>
</div>
<!----Footer of Credits Table---->
		<table width=100% cellpadding=0 cellspacing=0 border=0>
									<tr valign=bottom >
										<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
										<td width=100% background="pics/header_background_footer.gif"></td>
										<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
									</tr>
								</table>
								
</td>
</tr>
<tr><td colspan=3>

<br>
<!----Applied Credits---->

<Cfquery name="credits" datasource="caseusa">
select date, type, description, stuid, invoiceid, amount, creditid, c.companyshort, credit_type
from smg_credit
LEFT OUTER JOIN smg_companies c ON c.companyid = smg_credit.companyid
where agentid = #url.userid# <!--- <cfif form.view is not 'all'>
								and smg_credit.companyid = #client.companyid# 
							 </cfif>   --->
and active = 0

</Cfquery>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
						<tr valign=middle height=24>
							<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
							<td width=26 background="pics/header_background.gif"></td>
							<td background="pics/header_background.gif"><h2>Credits & Cancellations Applied</h2></td><td background="pics/header_background.gif" width=16></td>
							<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
						</tr>
					</table>
					<div class=scroll>
<table width=98% cellpadding=4 cellspacing =0>

	<tr>
		<Td>ID</Td><td></td><td>Date</td><td>Type</td><td></td><td>Desc.</td><td>Student</td><td>Inv</td><td>Amount</td>
	</tr>
<Cfoutput>

	
<cfif credits.recordcount is 0>
	<tr>
		<td colspan=8 align="center">No credits, refunds or discounts applied to your account.</td>
	</tr>
<cfelse>
<cfloop query=credits>
		<Tr <cfif credits.currentrow mod 2>bgcolor="ededed"</cfif>>
			<td><a href="invoice/credit_note.cfm?creditid=#creditid#" target="_blank">#credits.creditid#</a></td><td>#companyshort#</td><td>#DateFormat(date, 'mm-dd-yyyy')#</td><td>#type#</td><td>#credit_type#</td><td>#description#</td><td><Cfif stuid is 0 or stuid is ''>N/A<cfelse>#stuid#</Cfif></td><td><Cfif invoiceid is 0 or invoiceid is ''>N/A<cfelse>#invoiceid#</Cfif></td><td>#LSCurrencyFormat(amount,'local')#</td>
		</Tr>
	</cfloop>
</cfif>
</Cfoutput>	
</table>
</div>
<!----Footer of Credits Table---->
		<table width=100% cellpadding=0 cellspacing=0 border=0>
									<tr valign=bottom >
										<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
										<td width=100% background="pics/header_background_footer.gif"></td>
										<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
									</tr>
								</table>




</td>
	</tr>
</table>