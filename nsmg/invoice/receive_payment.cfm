<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="check_rights.cfm">

<link rel="stylesheet" href="../../smg.css" type="text/css">
<head>
<title>Receive Payments</title>
<div class="application_section_header">Receive Payment</div><br>
</head>
<table width=100% cellpadding =4 cellspacing =0>
	<tr bgcolor="#FFFFCC">
		<td bgcolor="#FF8080"><b><span class="edit_link">Enter Payment Info</b></td><td><span class="edit_link">Apply Payment to...</span></td><td><span class="edit_link">Over / Under Payment</td><td><span class="edit_link">Finalize</td>
	</tr>

</table>
<br>
<cfform method="post" action="receive_payment_2.cfm">
<cfoutput>
<input type="hidden" name="agent" value=#url.userid#>
</cfoutput>
<cfquery name="get_credits" datasource="MySQL">
select creditid,SUM(amount) AS amount,companyid, SUM(amount_applied) AS amount_applied from smg_credit
where agentid = #url.userid# and active =1
GROUP BY creditid
</cfquery>
<table>
	<tr>
		<td>Payment Method:</td><td> <cfselect name=payment_method message="Please Select a Payment Type" required="yes">
									<option></option>
									<option value='wire transfer'>Wire Transfer</option>
									<option value='visa'>Visa</option>
									<option value='mastercard'>MasterCard</option>
									<option value='american express'>American Express</option>
									<option value='check'>Check</option>
									<option value='travelers check'>Travelers Check</option>
									<option value='cash'>Cash</option>
									<option value='money order'>Money Order</option>
									<option value='other cc'>Other Credit Card</option>
									<option value='apply credit'>Apply Account Credit</option>
									<option value='Direct Deposit'>Direct Deposit</option>
									</cfselect>
									
 								 </td><td></td>
	</tr>
	<Cfif get_credits.recordcount gt 0>
	
	<Tr>
		<Td>Credit Available to Apply:</Td><td><cfoutput query="get_credits">
		<cfquery name="companyname" datasource="mysql">
	select companyshort from smg_companies where companyid = #get_credits.companyid#
	</cfquery>
		<input type="radio" name="credit" value=#creditid#> #creditid# -<cfset amount_avail = #amount# - #amount_applied#> #amount_avail# #companyname.companyshort#<br></cfoutput></td>
	</Tr>
	</Cfif>
	<tr>
		<td>Amount Received:</td><td><input type="text" name="amount_received"></td><td> <font size=-2>(for apply credit, leave blank)</font></td>
	</tr>
		<tr>
		<td>Payment Refrence:</td><td><input type="text" name="pay_ref"></td><td>Check Number, Wire Trans #, etc <font size=-2>(for apply credit, leave blank)</font> </td>
	</tr>
</table>
<br><br>
<div class="button"><input name="back" type="image" src="../pics/next.gif" align="right" border=0></div>

</cfform>