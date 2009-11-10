<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Payment Details</title>
<style type="text/css">
<!--
.style1 {font-size: 12px}
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
</head>

<body>

<link rel="stylesheet" href="../../smg.css" type="text/css">

<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="check_rights.cfm">

<cfoutput>

<cfif not isdefined('url.ref') OR url.ref EQ ''> 
	<table align="center" width="90%" frame="box">
		<tr><th colspan="2">No payment specified, please go back and select a payment. <br>If you received this error from clicking directly on a link, contact the person who sent you the link.</th></tr>
	</table>
	<cfabort>
</cfif>

<cfquery name="payment_Details" datasource="MySQL">
	SELECT *
	FROM smg_payment_received
	WHERE paymentref = <cfqueryparam value="#url.ref#" cfsqltype="cf_sql_integer"> 
		AND agentid = '#client.userid#'
</cfquery>

<cfif payment_Details.recordcount is 0> 
	<table align="center" width="90%" frame="box">
		<tr><th colspan="2">No payment was found with the id: ###url.ref# or you do not have access to view this payment. Please go back and select a different payment. <br>If you received this error from clicking directly on a link, contact the person who sent you the link.</th></tr>
	</table>
	<cfabort>
</cfif>

<!----Calculate amount actually applied; remaining goes towards credit account---->
<cfset amount_received = 0>
	
<Cfloop query="payment_details">
	<cfquery name="payment_Details_applied" datasource="MySQL">
	select sum(amountapplied) as amountapplied
	from smg_payment_charges
	where paymentid = #paymentid#
	</cfquery>
	<cfset amount_received = amount_received + payment_details_applied.amountapplied>
</Cfloop>

<Cfquery name="total_sum" datasource="MySQL">
	SELECT sum(totalreceived) as totalreceived
	FROM smg_payment_received
	WHERE paymentref = <cfqueryparam value="#url.ref#" cfsqltype="cf_sql_integer"> 
		 AND agentid = '#client.userid#'
</Cfquery>

<table cellpadding="4" cellspacing="0" class="thin-border" width="530">
	<th><div class="application_section_header">Payment Details</div></th>
</table><br />

<table cellpadding="4" cellspacing="0" class="thin-border" width="530">
	<th colspan=4>Payment Details for Payment Ref: #url.ref#</th>
	<tr bgcolor="##CCCCCC">
		<td colspan=2 align="right">Total Amount Received:</td>
		<td colspan=2><b>#LSCurrencyFormat(total_sum.totalreceived,'local')#</b></td>
	</tr>
	<tr bgcolor="##CCCCCC">
		<td colspan=2 align="right">Total Amount Applied:</td>
		<Td colspan=2><b>#LSCurrencyFormat(amount_received,'local')#</b></td>
	</tr>
	<cfif amount_received lt total_sum.totalreceived>
		<cfquery name="get_credit_assoc" datasource="MySQL">
			select *
			from smg_credit
			where payref = <cfqueryparam value="#url.ref#" cfsqltype="cf_sql_integer"> 
		</cfquery>
		<tr bgcolor="##CCCCCC">
			<td colspan=2 align="right">Credit(#get_credit_assoc.creditid#):</td>
			<td colspan=2><b>#LSCurrencyFormat(get_credit_assoc.amount,'local')# </b>desc: #get_credit_assoc.description#</td>
		</tr>
	</cfif>
	<tr>
		<td valign="top"><b>Payment Applied</b></td>
		<td valign="top"><b>Payment Type</b></td>
		<td valign="top"><b>Amount Applied</b></td>
		<td valign="top"><b>Company</b> <br /><font size=-2>(payment applied to)</font></Td>
	</tr>
	<cfloop query="payment_details">
		<cfquery name="company" datasource="MySQL">
			select companyshort
			from smg_companies
			where companyid = #companyid#
		</cfquery>
		<cfquery name="get_charge_payments" datasource="MySQL">
			select sum(amountapplied) as amountapplied
			from smg_payment_charges
			where paymentid = #paymentid#
		</cfquery>
		<tr bgcolor="<cfif currentrow mod 2 EQ 0>white<cfelse>##D9D8E2</cfif>">
			<td>#DateFormat(date, 'mm/dd/yyyy')#</td>
			<td>#paymenttype#</td>
			<td>#LSCurrencyFormat(get_charge_payments.amountapplied, 'local')#</td>
			<td>#company.companyshort#</td>
		</tr>
		<cfquery name="get_charge_payments" datasource="MySQL">
			select distinct smg_charges.invoiceid
			from smg_charges left join smg_payment_charges on smg_charges.chargeid = smg_payment_charges.chargeid
			where smg_payment_charges.paymentid = #payment_details.paymentid#
		</cfquery>
		<tr bgcolor="<cfif currentrow mod 2 EQ 0>white<cfelse>##D9D8E2</cfif>">
			<td>&nbsp;</td>
			<td colspan="2">Above amount applied to invoice(s): <cfloop query="get_charge_payments">###invoiceid#<br></cfloop></td>
			<td>&nbsp;</td>
		</tr>
	</cfloop>
</table>
	
</cfoutput>
</body>
</html>
