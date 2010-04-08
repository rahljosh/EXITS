<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Payments</title>
</head>

<body>
<cfif isDefined('url.invall')>
	<Cfset form.view = 'all'>
<cfelse>
	<cfset form.view = #client.companyid#>		
</cfif>
<cfset url.userid = #client.userid#>



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
			
<cfform method="post" action="?curdoc=intrep/payments/payment_step_2">
<cfoutput>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
						<tr valign=middle height=24>
							<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
							<td width=26 background="pics/header_background.gif"><img src="pics/$.gif"><img src="pics/$.gif"><img src="pics/$.gif"></td>
							<td background="pics/header_background.gif"><h2>&nbsp;&nbsp;Make a Payment </td><td background="pics/header_background.gif" align="right"><img src="intrep/payments/images/logo_ccVisa.gif"><img src="intrep/payments/images/logo_ccMC.gif"><img src="intrep/payments/images/logo_ccAmex.gif"><img src="intrep/payments/images/logo_ccDiscover.gif"><img src="intrep/payments/images/logo_ccEcheck.gif"><img src="intrep/payments/images/PayPal_mark_37x23.gif"></td>
							<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
						</tr>
					</table>
					
					<cfset balance_due = #total_due.amount_due# - #total_credit#- #total_received.total_received# + #overpayment_credit.overpayment_amount#>
												
						
					<table width=100% cellpadding=2 cellspacing=0 border=0 class="section">
						<tr>
							<td colspan="3" align="center">
								<img src="intrep/payments/images/amount.gif" align="center">
								<br>
								<br>
							</td>
						</tr>
						<tr>
							<td style="line-height:20px;" valign="top" width=40% align="right">
							
							<table class="box">
								<tr>
									<td bgcolor="##f4992D">Please indicate payment amount:</td>
								</tr>
								<tr>
									<td>
								<cfinput type="radio" name="pay_amount" value="full" message="Please indicate your payment amount." required="yes"><input type="hidden" name="full_payment" value="#balance_due#">Pay Full Balance Due (<b>#LSCurrencyFormat(balance_due, 'local')#</b>) <br>
							<cfinput type="radio" name="pay_amount" value="partial" message="Please indicate your payment amount." required="yes">Other Amount <input type="text" name="amount" size=10><br>
							
									</td>
								</tr>
							</table>
							</td>
							<td width=15>&nbsp;
							</td>
							<td >
							Please Note: If you specify an amount other then the full balance, you will be asked to assign the payments towards specific students on the next screen.
							

							</td>
						
							
							
							
						</tr>
						<tr>
							<td colspan=3 align="center"><input type="image" src="pics/next.gif" alt="next"></td>
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
	</cfoutput>
	</cfform>
</body>
</html>
