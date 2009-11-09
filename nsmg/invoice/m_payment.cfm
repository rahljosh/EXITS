

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Payments</title>
<style type="text/css">

	table.frame 
	{
	border-style:solid;
	border-width:thin;
	border-color:#004080;
	border-collapse:collapse;
	background-color:#FFFFE1;
	padding:2px;
	}
	
	td.right
	{
	font:Arial, Helvetica, sans-serif;
	font-style:normal;
	font-size:small;
	color:#FFFFFF;
	font-weight:bold;
	border-right-style:solid;
	border-right-width:thin;
	border-right-color:#004080;
	border-right-collapse:collapse;
	padding:4px;
	}
	
	td.two
	{
	font:Arial, Helvetica, sans-serif;
	font-style:normal;
	font-size:small;
	border-right-style:solid;
	border-right-width:thin;
	border-right-color:#004080;
	border-right-collapse:collapse;
	padding:4px;
	}
	
	.box
	{
	border-style:solid;
	border-width:thin;
	border-color:#004080;
	border-collapse:collapse;
	background-color:#FFFFFF;
	}
	
	tr.darkBlue
	{
	background-color:#0052A4;
	}

.style1 {color: #FF0000}
</style>
</head>

<!--- CHECK INVOICE RIGHTS  --->
<cfinclude template="check_rights.cfm">

<body>

<cfquery name="qAgents" datasource="MySQL">
SELECT userid, businessname
FROM smg_users
WHERE usertype = 8
ORDER BY businessname
</cfquery>

<cfparam name="form.chooseAgent" default="0">
<cfparam name="form.selectInvoice" default="0">
<cfparam name="form.amount_received" default="0">
<cfparam name="variables.totalReceived" default="0">
<cfparam name="form.creditId" default="0">
<cfparam name="variables.confirm" default="0">

<cfif form.amount_received EQ #variables.totalReceived#>
	<cfform name="one" method="post">
		<table>
			<tr>
				<h3>Select International Agent</h3>
			</tr>
			<tr>
			<select name="chooseAgent" size="1" onChange="javaScript:this.form.submit();">
				<option></option>
				<cfoutput query="qAgents">
					<option value="#qAgents.userid#">#qAgents.businessname# (#qAgents.userid#)</option>
				</cfoutput>
			</select>
			</tr>
		</table>
	</cfform>
		</br></br></br>
		
		<cfif form.chooseAgent NEQ 0>
		
			<cfquery name="qAgent" datasource="MySQL">
			SELECT userid, businessname
			FROM smg_users
			WHERE userid = #form.chooseAgent#
			</cfquery>
			
			<cfquery name="get_credits" datasource="MySQL">
			select creditid,SUM(amount) AS amount,companyid, SUM(amount_applied) AS amount_applied from smg_credit
			where agentid = #form.chooseAgent# and active =1
			GROUP BY creditid
			</cfquery>
			
			<cfform method="post">	
				
				<cfinput name="agentId" type="hidden" value="#form.chooseAgent#">
			
				<table>
					<tr>
					<h3><cfoutput><a href="index.cfm?curdoc=invoice/user_account_details&userid=#qAgent.userid#" target="_blank">#qAgent.businessname# (#qAgent.userid#)</a></cfoutput></h3>
					</tr>
					<tr>
						<td>
						Payment Method:
						</td>
						<td>
						<cfselect name="payment_method" message="Please Select a Payment Type" required="yes">
							<option value='wire transfer'>Wire Transfer</option>
							<option value='check'>Check</option>
							<option value='travelers check'>Travelers Check</option>
							<option value='cash'>Cash</option>
							<option value='money order'>Money Order</option>
							<option value='Direct Deposit'>Direct Deposit</option>
						</cfselect>
						</td>
						<td></td>
					</tr>
					
					<Cfif get_credits.recordcount gt 0>
						<Tr>
							<Td>
							Credit Available to Apply:
							</Td>
							<td>
							<cfoutput query="get_credits">
								<cfquery name="companyname" datasource="mysql">
								select companyshort from smg_companies where companyid = #get_credits.companyid#
								</cfquery>
							
								<cfinput type="radio" name="creditId" value="#creditid#">
								#creditid# -
								<cfset amount_avail = #amount# - #amount_applied#> 
								#amount_avail# #companyname.companyshort#<br>
							</cfoutput>
							</td>
						</Tr>
					</Cfif>
					<tr>
						<td>
						Date Received:
						</td>
						<td>
						<input type="text" name="date_received"></td><td> <font size=-2>(for apply credit, leave blank)</font>
						</td>
					</tr>
					<tr>
						<td>
						Amount Received:
						</td>
						<td>
						<input type="text" name="amount_received"></td><td> <font size=-2>(for apply credit, leave blank)</font>
						</td>
					</tr>
						<tr>
						<td>Payment Reference:
						</td>
						<td>
						<input type="text" name="pay_ref">
						</td>
						<td>Check Number, Wire Trans #, etc <font size=-2>(for apply credit, leave blank)</font>
						</td>
					</tr>
				</table>
				<br><br>
					
				<cfquery name="qInvBalance" datasource="MySQL"> 
				SELECT t.invoiceid, t.companyid, SUM( t.total ) AS totalPerInvoice
				FROM (
				SELECT sch.invoiceid, sch.companyid, IFNULL( SUM( sch.amount_due ) , 0 ) AS total
				FROM smg_charges sch
				WHERE sch.agentid = #form.chooseAgent#
				GROUP BY sch.invoiceid
				UNION ALL
				SELECT sch.invoiceid, sch.companyid, IFNULL( SUM( spc.amountapplied ) * -1, 0 ) AS total
				FROM smg_payment_charges spc
				LEFT JOIN smg_charges sch ON sch.chargeid = spc.chargeid
				WHERE sch.agentid = #form.chooseAgent#
				GROUP BY sch.invoiceid
				) t
				GROUP BY t.invoiceid HAVING totalPerInvoice > 0
				ORDER BY t.invoiceid DESC    
				</cfquery>
				
				<cfif qInvBalance.recordCount EQ 0>
					<h3>There are no outstanding invoices</h3>
					<cfabort>
				</cfif>
				
				<table class="frame">
					<tr class="darkBlue">
						<td class="right">
						</td>
						<td class="right">Comp</td>
						<td class="right">Invoice</td>
						<td class="right">Balance</td>
						<td class="right">Paying</td>
					</tr>
					<cfoutput query="qInvBalance">
					<tr>
						<td class="two">
						<cfinput name="selectInvoice" value="#qInvBalance.invoiceid#" type="checkbox">
						</td>
						<td class="two">
						#qInvBalance.companyid#
						</td>
						<td class="two">
						<a href="invoice/invoice_view.cfm?id=#qInvBalance.invoiceid#" target="_blank">#qInvBalance.invoiceid#</a>
						</td>
						<td class="two">
						#LSCurrencyFormat(qInvBalance.totalPerInvoice,'local')#
						</td>
						<td class="two">
						<cfinput name="payInv#qInvBalance.invoiceid#" type="text" value="#LSCurrencyFormat(qInvBalance.totalPerInvoice,'local')#" size="6">
						</td>
					</tr>
					</cfoutput>
				</table>
				<br/><br/>
				<cfinput type="image" src="../pics/submit.gif" name="submit">	
			
			</cfform>
				
		</cfif>

</cfif>

<cfif form.selectInvoice NEQ 0>

	<cfloop list="#form.selectInvoice#" index="iInvoiceNumber">
		<cfset totalReceived = #variables.totalReceived# + #LSPARSECURRENCY(EVALUATE('form.payInv' & '#iInvoiceNumber#'))#>
	</cfloop>
	
	<cfif form.creditId NEQ 0>
		<cfset form.date_received = #now()#>
		<cfset form.pay_ref = #form.creditId#>
		<cfset form.payment_method = 'apply credit'>
		<cfset form.amount_received = #variables.totalReceived#>
		
		<cfquery name="get_bal" datasource="mysql">
			select id, amount_applied, amount 
			from smg_credit
			where creditid = #form.pay_ref#
			and active = 1
			</cfquery>
			
			<cfparam name="appliedNow" default="0">
			<cfparam name="totalApplied" default="0">
		
			<cfloop query="get_bal">
				
				<cfset totalAppliedBefore = #variables.totalApplied#>
				<cfset amountToApply = #form.amount_received# - #variables.totalAppliedBefore#>
				<cfset credBal = #get_bal.amount# - #get_bal.amount_applied#>
				
				<cfif variables.amountToApply GTE variables.credBal>
					<cfset new_amount_received = #variables.credBal#>
					<cfelse>
						<cfset new_amount_received = #variables.amountToApply#>
				</cfif>
				
				<cfset newTotalApplied = #get_bal.amount_applied# + #variables.new_amount_received#> 
				
				<cfif variables.amountToApply GT 0>
				
					<cfquery name="update_amount_applied" datasource="MySQL">
					update smg_credit
					set amount_applied = #variables.newTotalApplied#
					where id = #get_bal.id#
					</cfquery>
					
					<cfif variables.credBal eq variables.new_amount_received>
						<cfquery name="deactivate_credit" datasource="MySQL">
						update smg_credit
						set active = 0
						where id = #get_bal.id#
						</cfquery>
					</cfif>
					
					<cfset appliedNow = #variables.new_amount_received#>
					<cfset totalApplied = #variables.totalAppliedBefore# + #variables.appliedNow#>
				
				</cfif>
			
			</cfloop>
	</cfif>
	
	<cfset difference = #form.amount_received# - #variables.totalReceived#>
	<cfif variables.difference LT 0>
		<cfoutput>
		<h1 align="center">The total amount assigned to invoice(s) is greater than the amount received.<br/>
		Please take #LSCurrencyFormat(-1*variables.difference,'local')# off of any checked invoice(s) (Hit "Back" on your browser).</h1>
		</cfoutput>
		<cfabort>
	</cfif>
	<cfif variables.difference GT 0> 
		<cfoutput>
		<h1 align="center">The amount received is greater than the total amount assigned to invoice(s).<br/>
		Please assign addicional #LSCurrencyFormat(variables.difference,'local')# to any invoice(s) (Hit "Back" on your browser).</h1>
		</cfoutput>
		<cfabort>
	</cfif>
	
	<cfif client.companyid LT 5>
		<cfset compId = 1>
		<cfelse>
			<cfset compId = #client.companyid#>
	</cfif>
	
	<cfquery name="payment_Details" datasource="MySQL">
	insert into smg_payment_received (date, date_applied, paymentref, paymenttype, totalreceived, agentid, companyid)
					values(#CreateODBCDate(form.date_received)#, #CreateODBCDate(now())#, '#form.pay_ref#', '#form.payment_method#', #form.amount_received#, #form.agentId#, #variables.compId#)
	</cfquery>
	
	<cfquery name="paymentid" datasource="mysql">
	select max(paymentid) as payid from smg_payment_received
	</cfquery>
			
	<cfloop list="#form.selectInvoice#" index="iInvoiceNumber">
	
		<cfset paymBalance = #LSPARSECURRENCY(EVALUATE('form.payInv' & '#iInvoiceNumber#'))#>
	
		<cfquery name="qChargeBalance" datasource="MySQL"> 
		SELECT t.invoiceid, t.chargeid, t.companyid, SUM( t.total ) AS totalPerCharge
		FROM (
		SELECT sch.invoiceid, sch.chargeid, sch.companyid, IFNULL( SUM( sch.amount_due ) , 0 ) AS total
		FROM smg_charges sch
		WHERE sch.invoiceid = #iInvoiceNumber#
		GROUP BY sch.chargeid
		UNION ALL
		SELECT sch.invoiceid, sch.chargeid, sch.companyid, IFNULL( SUM( spc.amountapplied ) * -1, 0 ) AS total
		FROM smg_payment_charges spc
		LEFT JOIN smg_charges sch ON sch.chargeid = spc.chargeid
		WHERE sch.invoiceid = #iInvoiceNumber#
		GROUP BY sch.chargeid
		) t
		GROUP BY t.chargeid HAVING totalPerCharge > 0
		ORDER BY t.invoiceid DESC    
		</cfquery>
		
		<cfloop query="qChargeBalance">
			
				<cfif qChargeBalance.totalPerCharge LTE variables.paymBalance>
					<cfset insertAmount = #qChargeBalance.totalPerCharge#>
				<cfelse>
					<cfset insertAmount = #variables.paymBalance#>
				</cfif>
				
				<cfif variables.paymBalance GT 0>
			
					<cfquery name="pay_charges" datasource="MySQL">
					insert into smg_payment_charges (paymentid, chargeid, amountapplied)
									values(#paymentid.payid#, #qChargeBalance.chargeid#, #variables.insertAmount#)
					</cfquery>
					
					<cfset paymBalance = #variables.paymBalance# - #qChargeBalance.totalPerCharge#>
				
				</cfif>
			
		</cfloop>
		
	</cfloop>
	
	<cfoutput>
		<script type="text/javascript">
		window.open('../invoice/payment_details.cfm?ref=#form.pay_ref#&userid=#form.agentId#', 'Payment_Details', 'height=600, width=600, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); 
		
		window.location="../invoice/m_payment.cfm"  
		</script>
	</cfoutput>
	
</cfif>

</body>
</html>