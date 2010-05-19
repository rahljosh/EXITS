			<cfdocument format="pdf">
<cfset form.beg_date = #url.beg_date#>
<cfset form.end_date = #url.end_date#>
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
.bold_balance{background-color: #FFFF99; color:#CC3333; font-size:14px;}
-->

    </style>
	<link rel="stylesheet" href="../../smg.css" type="text/css">
</head>

<cfoutput>


<cfset statementmonthbeg = '#form.beg_date#'>
<cfset statementmonthend = '#form.end_date#'>
<Cfset month = #Dateformat(statementmonthbeg, 'mm')#>
<Cfset statementmonth= '#month#/01/05'>
</cfoutput>

<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="check_rights.cfm">

<!----

<Cfquery name="intrep" datasource="mysql">

	select distinct smg_invoices.intrepid, smg_users.businessname, smg_users.userid
	from smg_invoices left join smg_users
	on smg_invoices.intrepid = smg_users.userid
where smg_users.userid = #url.userid#
	order by smg_users.businessname
	
</Cfquery>
---->

	<Cfquery name="intrep" datasource="mysql">

	select smg_users.businessname, smg_users.userid
	from  smg_users
	
where smg_users.userid = #url.userid#
	
	
</Cfquery>

	

		
		
<Cfoutput query="intrep">
			<div class="page-break">
				<table align="center" >
				<Tr>
				<td><img src="http://www.student-management.com/nsmg/pics/ise_banner.jpg" align="Center"></Td>
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
			LEFT JOIN smg_countrylist ON smg_countrylist.countryid = smg_users.country 
			where userid = #url.userid#
			</cfquery>
<table width=90% border=0 cellspacing=0 cellpadding=2 bgcolor="FFFFFF" align="Center">
<Tr>
<td bgcolor="cccccc" class="thin-border" background="../pics/cccccc.gif">From:</td><td>&nbsp;&nbsp;&nbsp;&nbsp;</td><Td bgcolor="cccccc" class="thin-border" >To:</Td><td rowspan=2 valign="top">  
		<table border="0" cellspacing="0" cellpadding="2" class="nav_bar" align="right">
		
		  <tr>
			<td bgcolor="CCCCCC" align="center" class="thin-border-bottom"><h2><b>Statement Dates</FONT></b></td>
			
		  </tr>
		  <tr>
			<td align="center" class="thin-border-bottom" ><B>
<h2>#DateFormat(form.beg_Date, 'M/DD/yy')# - #DateFormat(form.end_Date, 'M/DD/yy')#</h2>

</b></td>
			
		  </tr>
		  		  <tr>
			<td bgcolor="CCCCCC" align="center" class="thin-border-bottom">Date Sent</td>
			
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
		#business_name.city# #business_name.countryname# #business_name.zip#
		<br>
		E: <a href="mailto:#business_name.email#">#business_name.email#</a><br>
		P: #business_name.phone#<br>
		F: #business_name.fax#<br>
		
		
		</td>

</tr>
<cfif business_name.usebilling eq 1>

<tr>
	<td>&nbsp;</td>
</tr>
<Tr>
	<td bgcolor="cccccc" class="thin-border" background="../pics/cccccc.gif">Local Contact:</td>
</tr>
<tr></tr>
	<td valign=top class="thin-border-left-bottom-right">

				#business_name.businessname# (#business_name.userid#)<br>
		#business_name.firstname# #business_name.lastname#<br>
		#business_name.address#<br>
		<cfif #business_name.address2# is ''><cfelse>#business_name.address2#</cfif>
		#business_name.city# #business_name.countryname# #business_name.zip#
		<br>
		E: <a href="mailto:#business_name.email#">#business_name.email#</a><br>
		P: #business_name.phone#<br>
		F: #business_name.fax#<br>
		
		</td>
</Tr>
</cfif>

</table>
<br>

</cfoutput>
<!----Total Outstanding balance---->


<!----Totals from Sept to Current--->
			<cfoutput>
			<table class=nav_bar cellspacing=0 cellpadding=2 width=90% align="center">
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
			where agentid = #url.userid#  and paymenttype not like '%credit%'

			</cfquery>
			<cfquery name="total_Credit" datasource="MySQL">
			select sum(amount) as credit_amount
			from smg_credit
			where agentid = #url.userid# 

			</cfquery>
			<cfif total_credit.credit_amount is ''>
			<cfset total_credit.credit_amount = 0>
			</cfif>
			<cfif total_received.total_received is ''>
			<cfset total_received.total_received = 0>
			</cfif>
			
			<Cfquery name="refunds" datasource="mysql">
				select date,reason, amount, id
				from smg_invoice_refunds
				where agentid = #url.userid# and (date between #CreateODBCDateTime(statementmonthbeg)# and #CreateODBCDateTime(statementmonthend)#)
				
				</Cfquery>
	<cfquery name="total_refund" datasource="mysql">
			select sum(amount) as total_refund
			from smg_invoice_refunds
			where agentid =#url.userid#
</cfquery>
		<cfif total_refund.total_refund is''><cfset total_refund.total_refund = 0></cfif>
			<tr bgcolor="000066">
				<td align="center" colspan=2><font color="white">Total Outstanding Balance</font></td>
			</tr>


			<tr>
				<td align="right"><strong>Total Amount Invoiced:</strong></td><td><strong>#LSCurrencyFormat(total_Due.amount_due, 'local')#</strong></td>
			</tr>
			<tr>
				<td align="right"><strong>(-) Total Amount Received:</strong></td><td><strong> #LSCurrencyFormat(total_received.total_Received, 'local')#</strong></td>
			</tr>
			<tr>
				<td align="right" width=60%><strong>(-) Total Amount Canceled / Credited / Discounted:</strong></td><td><strong>   #LSCurrencyFormat(total_Credit.credit_amount, 'local')#</strong></td>
			</tr>
			<tr>
				<td align="right"><strong>(+) Total amount Refunded:</strong></td><td><strong>   #LSCurrencyFormat(total_refund.total_refund, 'local')#</strong></td>
			</tr>
			<tr>
				<td align="center" colspan=2><div class="bold_balance"><font color="##CC3333">(=) Total Outstanding Balance: <cfset balance_due = #total_due.amount_due# - #total_credit.credit_Amount#- #total_received.total_received#+#total_refund.total_refund#><b>#LSCurrencyFormat(balance_due, 'local')#*</td>
			</tr>


		</table>
		<br>

<!----invoices Issued---->		



			
			<table align="Center" width=90% border=0>
				<Tr>
					<td colspan=2>
		
			
			<!----Totals for month---->
			
			<table class="nav_bar" cellpadding=2 cellspacing=0 width=100%>

			<tr bgcolor="000066">
				<td colspan=6 align="center"><font color="white">

1) Invoices Issued between #form.beg_date# and #form.end_date#


</cfoutput></font></td>
			</tr>
	<tr>
		<Td></Td><td>Invoice</td><td>Date Created</td><td>Amount</td><!----<td>Payments</td><td>Invoice Balance</td>---->
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
		<Td>#current_invoices.currentrow#</Td><td>#invoiceid#</td><td>#DateFormat(current_invoices.invoicedate, 'mm-dd-yyyy')#</td><td>#LSCurrencyFormat(invoice_totals.invoice_due, 'local')#</td><!----<td>#LSCurrencyFormat(paid_Amount, 'local')# </td><td><cfset inv_balance = #invoice_totals.invoice_due# - #paid_Amount#>#LSCurrencyFormat(inv_balance, 'local')#</td>---->
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
				<td colspan=6 align="center"><font color="white" ><cfoutput>

2) Payments Applied between #form.beg_date# and #form.end_date#


</cfoutput></font></td>
			</tr>
				<tr>
		<Td></Td><td>Payment Ref</td><td>Payment Type</td><td>Date Applied</td><td>Amount</td>
	</tr>
	
<Cfquery name="payments_received" datasource="mysql">
select distinct paymentref, date
from smg_payment_received
where agentid = #url.userid# and (date_applied between #CreateODBCDateTime(statementmonthbeg)# and #CreateODBCDateTime(statementmonthend)#)
			
</Cfquery>
	<Cfset grand_total_received = 0>
<cfoutput query=payments_received>
	<cfquery name="totals" datasource="MySQL">
	select agentid, paymenttype, date, paymentref, paymenttype, paymentid, sum(totalreceived) as payment_total
	from smg_payment_received
	where paymentref = '#paymentref#' and agentid = #url.userid# and paymenttype <> 'apply credit'
	group by agentid
	</cfquery>
	<!----
	<cfquery name="credit_description" datasource="MySQL">
	select description, creditid
	from smg_credit
	where creditid = #
	</cfquery>
	---->
	<cfloop query=totals>

	
		<Tr <cfif payments_received.currentrow mod 2>bgcolor="ededed"</cfif>>
			<td></td><td>#paymentref#</td><td>#paymenttype#</td><td>#DateFormat(date, 'mm-dd-yyyy')#</td><td>#LSCurrencyFormat(payment_total, 'local')#</td>
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
				<td colspan=8 align="center"><font color="white"><cfoutput>

3) Cancellations, Credits & Discounts applied between #form.beg_date# and #form.end_date#


</cfoutput></font></td>
			</tr>
				<tr>
		<td>ID</td><td>Date Applied</td><td>Type</td><td>Description</td><td>Student Refund for</td><td>Inv Charge Appeard On</td><td>Amount</td>
	</tr>
	
<Cfquery name="credits" datasource="mysql">
select date, type, description, stuid, invoiceid, amount, creditid
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
			<td>#credits.creditid#</td><td>#DateFormat(date, 'mm-dd-yyyy')#</td><td>#type#</td><td>#description#</td><td><Cfif stuid is 0 or stuid is ''>N/A<cfelse>#stuid#</Cfif></td><td><Cfif invoiceid is 0 or invoiceid is ''>N/A<cfelse>#invoiceid#</Cfif></td><td>#LSCurrencyFormat(amount,'local')#</td>
		</Tr>
		<cfset total_credit = #total_credit# + #amount#>
	</cfloop>

		
	<Tr>
		<td colspan=7 align="center"><b>Total Amount Canceled / Credited / Discounted: #LSCurrencyFormat(total_credit, 'local')#</b></td>
	</Tr>	
</cfif>
</Cfoutput>	
</table>
<br>
<!----Refund Section of Invoice---->
<table class="nav_bar" cellpadding=2 cellspacing=0 width=100%>

			<tr bgcolor="000066">
				<td colspan=8 align="center"><font color="white"><cfoutput>

4) Refunds applied between #form.beg_date# and #form.end_date#


</cfoutput></font></td>
			</tr>
				<tr>
		<td>ID</td><td>Date Applied</td><td>Reason</td><td>Amount</td>
	</tr>
	
<Cfquery name="refunds" datasource="mysql">
select date,reason, amount, id
from smg_invoice_refunds
where agentid = #url.userid# and (date between #CreateODBCDateTime(statementmonthbeg)# and #CreateODBCDateTime(statementmonthend)#)

</Cfquery>
	<cfquery name="total_refund" datasource="mysql">
			select sum(amount) as total_refund
			from smg_invoice_refunds
			where agentid =#url.userid#
</cfquery>
		<cfif total_refund.total_refund is''><cfset total_refund.total_refund = 0></cfif>

<Cfoutput>
	
<cfif refunds.recordcount is 0>
	<tr>
		<td colspan=7 align="center">No refunds were applied to your account.</td>
	</tr>
<cfelse>
<cfset total_credit=0>
<cfloop query=refunds>
	
		<Tr <cfif refunds.currentrow mod 2>bgcolor="ededed"</cfif>>
			<td>#id#</td><td>#DateFormat(date, 'mm/dd/yyyy')#</td><td>#reason#</td><td>#LSCurrencyFormat(amount, 'local')#</td>
		</Tr>
		
	</cfloop>

	<Tr>
		<td colspan=7 align="center"><b>Total Amount Refunded: #LSCurrencyFormat(total_refund.total_refund, 'local')#</b></td>
	</Tr>	
</cfif>
</Cfoutput>	
</table><br>
<div align="center">*Any time you  make a payment <strong><u>always</u></strong> indicate the invoice number and respective amount you're paying.</div>

	</cfdocument>

