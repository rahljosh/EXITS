<link rel="stylesheet" href="../../smg.css" type="text/css">
<head>
<title>Receive Payments</title>
<div class="application_section_header">Receive Payment</div><br>
</head>
<table width=100% cellpadding =4 cellspacing =0>
	<tr bgcolor="#FFFFCC">
		<td><b><span class="edit_link">Enter Payment Info</b></td><td  bgcolor="#FF8080"><span class="edit_link">Apply Payment to...</span></td><td><span class="edit_link">Over / Under Payment</td><td><span class="edit_link">Finalize</td>
	</tr>

</table>
<br>
<cfform method="post" action="receive_payment_3.cfm">
<cfoutput>
<input type="hidden" name="agent" value=#form.agent#>
<input type="hidden" name="payment_method" value='#form.payment_method#' >
<cfif form.payment_method is 'apply credit'>
<cfquery name="get_credits" datasource="caseusa">
select creditid,amount, amount_applied from smg_credit
where creditid = #form.credit# 
</cfquery>
<input type="hidden" name="amount_received" value=#get_credits.amount#>
<cfelse>

<input type="hidden" name="amount_received" value=#form.amount_received#>
</cfif>

<cfif form.payment_method is 'apply credit'>
<input type="hidden" name="pay_ref" value=#form.credit#>
<input type="hidden" name="apply_credit_id" value=#form.credit#>
<cfelse>
<input type="hidden" name="pay_ref" value='#form.pay_ref#'>
</cfif>
</cfoutput>
<!----Open Invoices ---->

Apply Payment to an Invoice<br>
Enter the invoice number to apply payment to:<br>
Invoice Number: <input type="text" size=6 name=invoice><br><br>
<cfoutput>
<Cfif form.payment_method is 'apply credit'>
<cfset avail_amount = #get_credits.amount# - #get_credits.amount_applied#>
Amount of Credit your applying: <input type="text" name="amount_applied" value=#avail_amount# size=8>
<input name="orig_credit_amount" value=#get_credits.amount# type="hidden">
</Cfif>
</cfoutput>
<div class="button"><input name="back" type="image" src="../pics/next.gif" align="right" border=0></div>
<br><br>

<hr width=40%>
<br>
<!----
Apply payment to specific items...<br>
<!----Individual Items---->
<cfquery name="open_charges" datasource="caseusa">
select smg_charges.chargeid, smg_charges.amount, smg_payment_charges.paymentid
from smg_charges left join smg_payment_charges on (smg_charges.chargeid = smg_payment_charges.chargeid)
where smg_charges.agentid = #form.agent# and companyid = #client.companyid# and invoiceid <> 0 
</cfquery>
<cfoutput>


<br><br>

Apply Payment to individual Items<br>
<table>
	<tr>
		<td></td><td>Student</td><td>Type</td><td>Description</td><td>Amount</td>
	</tr>
	<cfloop query="open_charges">
	<cfquery name="charge_details" datasource="caseusa">
	select * from smg_charges
	where chargeid = #chargeid#
	</cfquery>
	<tr>
		<td><input type="checkbox" value=#chargeid# name="charges"></td><td>#charge_details.stuid#</td><td>#charge_details.type#</td><td>#charge_details.description#</td><td>#charge_details.amount#</td>
	</tr>
	</cfloop>
</table>
</cfoutput>


<div class="button"><input name="back" type="image" src="../../pics/next.gif" align="right" border=0></div>
---->
</cfform>