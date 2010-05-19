<cfquery name="get_int_Reps" datasource="MySQL">
select smg_users.userid
from smg_users
where usertype = 8
order by businessname
</cfquery>

<cfloop query="get_int_reps">
<div class="page-break">
<cfset url.userid = #userid#>
<!----monthly statement---->
<head>
<style type="text/css" media="print">
	.page-break {page-break-after: always}
</style>
<style type="text/css">
table{font-size:10px;}
table.nav_bar {  background-color: #ffffff; border: 1px solid #000000; }

.thin-border{ border: 1px solid #000000;}
.thin-border-right{ border-right: 1px solid #000000;}
.thin-border-left{ border-left: 1px solid #000000;}
.thin-border-right-bottom{ border-right: 1px solid #000000; border-bottom: 1px solid #000000;}
.thin-border-bottom{  border-bottom: 1px solid #000000;}
.thin-border-left-bottom{ border-left: 1px solid #000000; border-bottom: 1px solid #000000;}
.thin-border-right-bottom-top{ border-right: 1px solid #000000; border-bottom: 1px solid #000000; border-top: 1px solid #000000;}
.thin-border-left-bottom-top{ border-left: 1px solid #000000; border-bottom: 1px solid #000000; border-top: 1px solid #000000;}
.thin-border-left-bottom-right{ border-left: 1px solid #000000; border-bottom: 1px solid #000000; border-right: 1px solid #000000;}
.thin-border-left-top-right{ border-left: 1px solid #000000; border-top: 1px solid #000000; border-right: 1px solid #000000;}
-->

    </style>
	<link rel="stylesheet" href="../../smg.css" type="text/css">
</head>

<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="check_rights.cfm">

<cfoutput>
<Cfset month = #Dateformat(url.begindate, 'mm')#>
<Cfset statementmonth= '#month#/01/05'>
<cfset statementmonthbeg = #url.begindate#>
<cfset statementmonthend = #url.enddate#>

</cfoutput>
<Cfquery name="intrep" datasource="mysql">

	select distinct smg_invoices.intrepid, smg_users.businessname, smg_users.userid
	from smg_invoices left join smg_users
	on smg_invoices.intrepid = smg_users.userid
where smg_users.userid = #url.userid#
	order by smg_users.businessname
	
</Cfquery>

<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="check_rights.cfm">
	
			<table width=90% align="center">
				<Tr>
					<td>
			
			
			<Cfoutput>
			
			<table align="center" >
			<Tr>
			<td><img src="../../pics/ise_banner.jpg" align="Center"></Td>
			</Tr>
			<tr>
				<td align="center"><h1>Summary Statement</h1></td>
			</tr>
			</table>
			<br>
			<br>
						<cfquery name="business_name" datasource="MySQL">
						select *
						from smg_users 
						where userid = #url.userid#
						</cfquery>
			<table width=90% border=0 cellspacing=0 cellpadding=2 bgcolor="FFFFFF" align="Center">
			<Tr>
			<td bgcolor="cccccc" class="thin-border" background="../pics/cccccc.gif">From:</td><td>&nbsp;&nbsp;&nbsp;&nbsp;</td><Td bgcolor="cccccc" class="thin-border" >To:</Td><td rowspan=2 valign="top">  
					<table border="0" cellspacing="0" cellpadding="2" class="nav_bar" align="right">
					
					  <tr>
						<td bgcolor="CCCCCC" align="center" class="thin-border-bottom"><b><FONT size="+1">Statement</FONT></b></td>
						
					  </tr>
					  <tr>
						<td align="center" class="thin-border-bottom" ><B><font size=+1> 
						#DateFormat(statementmonth, 'MMMM')# 
						
						</b></td>
						
					  </tr>
							  <tr>
						<td bgcolor="CCCCCC" align="center" class="thin-border-bottom">Date</td>
						
					  </tr>
					  <tr>
						<td  align="center" class="thin-border-bottom">#DateFormat(now(), 'mm/dd/yyyy')#</td>
						
					  </tr>
			
					
					</table>
			</td>
			</Tr>
				<tr>
				
				
				<td  valign="top" class="thin-border-left-bottom-right">
					Student Management Group<br>
					119 Cooper St.<br>
					Babylon, NY 11702<br>
				</td>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td valign=top class="thin-border-left-bottom-right">
					#business_name.businessname# (#business_name.userid#)<br>
					#business_name.firstname# #business_name.lastname#<br>
					#business_name.address#<br>
					<cfif #business_name.address2# is ''><cfelse>#business_name.address2#</cfif>
					#business_name.city# #business_name.country# #business_name.zip#
					<!----<br>
					E: #business_name.email#<br>
					P: #business_name.phone#<br>
					F: #business_name.fax#<br>---->
					
					
					</td>
			
			</tr>
			</table>
			</cfoutput>





			

			
			<!----Totals for month---->
			
			<table class="nav_bar" cellpadding=2 cellspacing=0 width=100%>

			<tr bgcolor="000066">
				<td colspan=6><font color="white"><cfoutput>

			Invoices Sent for the month of #DateFormat(statementmonth, 'MMMM')# 
			
			
			</cfoutput></font></td>
			</tr>
			<tr>
				<Td></Td><td>Invoice</td><td>Date Created</td><td>Amount</td><td>Payments</td><td>Invoice Balance</td>
			</tr>
					<cfquery name="current_invoices" datasource="mysql">
					select distinct invoiceid, invoicedate, companyid
					from smg_charges
					where agentid = #url.userid#
					and invoiceid <> 0 and (invoicedate between #CreateODBCDateTime(statementmonthbeg)# and #CreateODBCDateTime(statementmonthend)#) 
					group by invoiceid
								
					</cfquery>
				<cfset total_due_all_invoices = 0>
					<cfoutput query="current_invoices">
						<cfquery name="invoice_totals" datasource="mysql">
							select sum(amount_due) as invoice_due
							from smg_charges
							where invoiceid = #invoiceid#
						</cfquery>
				
						<cfquery name="charges_paid" datasource="MySQL">
						select smg_charges.chargeid, smg_payment_charges.chargeid, smg_payment_charges.amountapplied, smg_payment_charges.paymentid
						from smg_charges right join smg_payment_charges on (smg_charges.chargeid = smg_payment_charges.chargeid)
						where smg_charges.invoiceid = #invoiceid#
						</cfquery>
						
						<cfif charges_paid.recordcount is 0>
						<Cfset payref.paymentref = ''>
						<cfelse>
						<cfquery name="payref" datasource="MySQL">
						select paymentref from smg_payment_received
						where paymentid = #charges_paid.paymentid#
						</cfquery>
						</cfif>
						
						<cfset paid_amount =0>
						<cfloop query="charges_paid">
						<cfset paid_amount = #paid_amount# + #charges_paid.amountapplied#> 
						
						</cfloop>
		
					<Tr <cfif current_invoices.currentrow mod 2>bgcolor="ededed"</cfif>>
						<Td>#current_invoices.currentrow#</Td><td>#invoiceid#</td><td>#DateFormat(current_invoices.invoicedate, 'mm-dd-yyyy')#</td><td>#LSCurrencyFormat(invoice_totals.invoice_due, 'local')#</td><td>#LSCurrencyFormat(paid_Amount, 'local')# </td><td><cfset inv_balance = #invoice_totals.invoice_due# - #paid_Amount#>#LSCurrencyFormat(inv_balance, 'local')#</td>
					</Tr>
				<cfset total_due_all_invoices = #total_due_all_invoices# + #invoice_totals.invoice_due#>
				
								</cfoutput>
								
									<Tr>
						<td colspan=6 align="center"><b>Total Amount Invoiced: <cfoutput>#LSCurrencyFormat(total_due_all_invoices, 'local')#</b></cfoutput></td>
					</Tr>	
				</table>
				<br>
				<table class="nav_bar" cellpadding=2 cellspacing=0 width=100%>
				
							<tr bgcolor="000066">
								<td colspan=6><font color="white"><cfoutput>
				
				Payments Received for the month of #DateFormat(statementmonth, 'MMMM')# 
				
				
				</cfoutput></font></td>
							</tr>
								<tr>
						<Td></Td><td>Payment Ref</td><td>Payment Type</td><td>Date Applied</td><td>Amount</td>
					</tr>
					
				<Cfquery name="payments_received" datasource="mysql">
				select distinct paymentref, date
				from smg_payment_received
				where agentid = #url.userid# and (date between #CreateODBCDateTime(statementmonthbeg)# and #CreateODBCDateTime(statementmonthend)#)
							
				</Cfquery>
					<Cfset grand_total_received = 0>
				<cfoutput query=payments_received>
					<cfquery name="totals" datasource="MySQL">
					select agentid, paymenttype, date, paymentref, paymenttype, sum(totalreceived) as payment_total
					from smg_payment_received
					where paymentref = '#paymentref#' and agentid = #url.userid#
					group by agentid
					</cfquery>
				
					<cfloop query=totals>
				
					
						<Tr <cfif payments_received.currentrow mod 2>bgcolor="ededed"</cfif>>
							<td>#payments_received.currentrow#</td><td>#paymentref#</td><td>#paymenttype#</td><td>#DateFormat(date, 'mm-dd-yyyy')#</td><td>#LSCurrencyFormat(payment_total, 'local')#</td>
						</Tr>
						<Cfset grand_total_received = #grand_total_received# + #payment_total#>
					</cfloop>
						
				</cfoutput>
									<Tr>
						<td colspan=5 align="center"><b>Total Amount Received: <cfoutput>#LSCurrencyFormat(grand_total_received, 'local')#</b></cfoutput></td>
					</Tr>	
				</table>
<br>
<!----Credit Section of Invoice---->
				<table class="nav_bar" cellpadding=2 cellspacing=0 width=100%>
				
							<tr bgcolor="000066">
								<td colspan=7><font color="white"><cfoutput>
				
				Credits, Refunds, and Discounts applied to account for the month of #DateFormat(statementmonth, 'MMMM')# 
				
				
				</cfoutput></font></td>
							</tr>
								<tr>
						<Td></Td><td>Date Applied</td><td>Type</td><td>Description</td><td>Student Refund for</td><td>Inv Charge Appeard On</td><td>Amount</td>
					</tr>
					
				<Cfquery name="credits" datasource="mysql">
				select date, type, description, stuid, invoiceid, amount
				from smg_credit
				where agentid = #url.userid# and (date between #CreateODBCDateTime(statementmonthbeg)# and #CreateODBCDateTime(statementmonthend)#)
				
				</Cfquery>
					
				
				<Cfoutput>
					
				<cfif credits.recordcount is 0>
					<tr>
						<td colspan=7 align="center">No credits, refunds or discounts applied to your account.</td>
					</tr>
				<cfelse>
				<cfset total_credit=0>
				<cfloop query=credits>
					
						<Tr <cfif credits.currentrow mod 2>bgcolor="ededed"</cfif>>
							<td>#credits.currentrow#</td><td>#DateFormat(date, 'mm-dd-yyyy')#</td><td>#type#</td><td>#description#</td><td><Cfif stuid is 0 or stuid is ''>N/A<cfelse>#stuid#</Cfif></td><td><Cfif invoiceid is 0 or invoiceid is ''>N/A<cfelse>#invoiceid#</Cfif></td><td>#LSCurrencyFormat(amount,'local')#</td>
						</Tr>
						<cfset total_credit = #total_credit# + #amount#>
					</cfloop>
				
						
					<Tr>
						<td colspan=7 align="center"><b>Total Amount Credited: #LSCurrencyFormat(total_credit, 'local')#</b></td>
					</Tr>	
				</cfif>
				</Cfoutput>	
				</table>
			<br>
			<Table width=100%>
			
				<tr>
				
				<td valign="top"> This is the current status of your account. <br><br>
				This is not a bill, it is only to inform you of amount due, and payments received.<br><br>
				If you have a Credit Amount - Please indicate which invoice you would like it applied to.<br><Br>
				Any time you make a payment, please indicate which invoice you are paying.</td><td valign="top" align="right" width=50%>
						<!----Totals from Sept to Current--->
						<cfoutput>
						<table class=nav_bar cellspacing=0 cellpadding=4>
						<Cfquery name="total_Due" datasource="MySQL">
						select sum(amount_due) as amount_due
						from smg_charges
						where agentid = #URL.userid# 
						
						</Cfquery>
						<cfif total_due.amount_due is ''>
						<cfset total_due.amount_due = 0>
						</cfif>
						<cfquery name="total_received" datasource="mysql">
						select sum(totalreceived) as total_received
						from smg_payment_received
						where agentid = #url.userid# 			
			
						</cfquery>
						<cfquery name="total_Credit" datasource="MySQL">
						select sum(amount) as credit_amount
						from smg_credit
						where agentid = #url.userid# and active = 1
			
						</cfquery>
						<cfif total_credit.credit_amount is ''>
						<cfset total_credit.credit_amount = 0>
						</cfif>
						<cfif total_received.total_received is ''>
						<cfset total_received.total_received = 0>
						</cfif>
						<tr bgcolor="000066">
							<td colspan=2><font color="white">Total Account Summary from September to Present</font></td>
						</tr>
			
			
						<tr>
							<td><strong>Total Amount Invoiced</strong></td><td><strong>#LSCurrencyFormat(total_Due.amount_due, 'local')#</strong></td>
						</tr>
						<tr>
							<td><strong>Total Amount Received</strong></td><td><strong> #LSCurrencyFormat(total_received.total_Received, 'local')#</strong></td>
						</tr>
						<tr>
							<td><strong>Credit</strong></td><td><strong>   #LSCurrencyFormat(total_Credit.credit_amount, 'local')#</strong></td>
						</tr>
						<tr>
							<td bgcolor="FFFF99"><strong>*Total Open Balance</strong></td><td bgcolor="FFFF99"><strong><cfset balance_due = #total_due.amount_due# - #total_credit.credit_Amount#- #total_received.total_received#><b>#LSCurrencyFormat(balance_due, 'local')#</strong></td>
						</tr>
						<tr>
							<td colspan=2><font size=-2>*A 'Total Open Balance' statement is available upon request.</font></td>
						</tr>
			
					</table>
				</td>
					</Tr>
				</table>
			</cfoutput>
			<font size=-2>**Due to a system upgrade in our billing system the statement format has changed.  If you request a 'Total Open Balance' any payments made prior to March 3rd will show
			as a wire transfer and the reference number will show 'migrate' regardless of how you paid.  We appologize for any inconvenience this may cause.** </font>
			


</td>
				</Tr>
			</table>

</div>
</cfloop>