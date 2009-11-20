<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>General Invoice Created - Summary</title>
</head>

<script>
// -->
// opens letters in a defined format
function OpenInvoice(url) {
	newwindow=window.open(url, 'Invoice', 'height=580, width=790, location=no, scrollbars=yes, menubar=yes, toolbars=yes, resizable=yes'); 
	if (window.focus) {newwindow.focus()}
}
//-->
</script> 

<body>

<cfif NOT IsDefined('url.i')>
	An error has ocurred. Please check the Agent's account to make sure this invoice did not go thru.
	<cfabort>
</cfif>

<cfquery name="get_invoice" datasource="MySql">
	SELECT invoiceid, intrepid, uniqueid
	FROM egom_invoice
	WHERE uniqueid = <cfqueryparam value="#URLDecode(url.i)#" cfsqltype="cf_sql_char">
</cfquery>

<!--- GET AGENT --->
<cfquery name="get_agent" datasource="MySql">
	SELECT userid, businessname
	FROM smg_users
	WHERE userid = <cfqueryparam value="#get_invoice.intrepid#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- SUMMARY OF CHARGES --->
<cfquery name="summary_charges" datasource="MySql">
	SELECT chargeid, egom_charges.invoiceid, amount, description, egom_charges.date, egom_charges.full_paid,
		type.charge,
		egom_invoice.uniqueid
	FROM egom_charges
	INNER JOIN egom_charges_type type ON type.chargetypeid = egom_charges.chargetypeid
	LEFT JOIN egom_invoice ON egom_invoice.invoiceid = egom_charges.invoiceid
	WHERE egom_charges.invoiceid = '#get_invoice.invoiceid#'
</cfquery>

<cfoutput>

<br /><br />
<table width="95%" class="box" bgcolor="##ffffff" align="center" cellpadding="3" cellspacing="0">
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr>
		<td width="100%" valign="top">
			<table border="0" cellpadding="3" cellspacing="0" width="90%" align="center">
				<tr><th colspan="2" bgcolor="##C2D1EF">Invoice ###get_invoice.invoiceid#</th></tr>
				<tr><td colspan="2">
						<table border="0" cellpadding="3" cellspacing="0" width="100%">
							<tr><td><b>Intl. Agent:</b> &nbsp; #get_agent.businessname# (###get_agent.userid#)</td></tr>
						</table>		
					</td>
				</tr>
				<tr><td colspan="2">&nbsp;</td></tr>
				<tr><td width="60%" valign="top">	
						<table border="0" cellpadding="3" cellspacing="0" width="100%">
							<tr><th colspan="3" bgcolor="##C2D1EF">Summary of Charges<th></tr>
							<tr>
								<td width="40%"><b>Charge Type</b></td>
								<td width="20%"><b>Amount US$</b></td>
								<td width="40%"><b>Description</b></td>
							</tr>									
							<cfset total_invoice = '0'>
							<cfloop query="summary_charges">
							<tr>
								<td>#charge#</td>
								<td>#LSCurrencyFormat(amount, 'local')#</td>
								<td>#description#</td>
							</tr>
							<cfset total_invoice = total_invoice + amount>
							</cfloop>
							<tr>
								<td><b>Total Invoice</b></td>
								<td colspan="2"><b>#LSCurrencyFormat(total_invoice, 'local')#</b></td>
							</tr>
						</table>
					</td>
					<td width="40%" valign="top">
						<table border="0" cellpadding="3" cellspacing="0" width="100%">
							<tr><th colspan="2" bgcolor="##C2D1EF">Invoice Tools</th></tr>
							<tr>
								<td width="40%">
									<b><a href="javascript:OpenInvoice('invoice/view_invoice.cfm?i=#summary_charges.uniqueid#')">Print Invoice</a></b>
									&nbsp; <a href="javascript:OpenInvoice('invoice/view_invoice_email.cfm?i=#summary_charges.uniqueid#');" onclick="return confirm ('Invoice ###summary_charges.invoiceid# will be sent to #get_agent.businessname#. Click OK to continue.');"><img src="pics/email.gif" border="0" alt="Email Invoice ###summary_charges.invoiceid# to #get_agent.businessname#."></a>

								</td>
								<td width="60%"><b><a href="?curdoc=invoice/account_details&intrep=#get_agent.userid#">#get_agent.businessname# Account Details</a></b></td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td><b><a href="?curdoc=invoice/invoice_index">Invoicing Menu</a></b></td>
							</tr>									
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
</table>
<br />

<!--- CANCEL CHARGES --->
<cfquery name="get_charges" datasource="MySql">
	SELECT chargeid, egom_charges.invoiceid, amount, description, egom_charges.date, egom_charges.full_paid,
		type.charge,
		egom_invoice.uniqueid
	FROM egom_charges
	INNER JOIN egom_charges_type type ON type.chargetypeid = egom_charges.chargetypeid
	LEFT JOIN egom_invoice ON egom_invoice.invoiceid = egom_charges.invoiceid
	WHERE egom_charges.invoiceid = '#get_invoice.invoiceid#'
		AND egom_charges.chargetypeid != '13' <!--- cancelation --->
</cfquery>

<table width="95%" class="box" bgcolor="##ffffff" align="center" cellpadding="3" cellspacing="0">
	<tr>
		<td width="100%" valign="top">
			<table border="0" cellpadding="3" cellspacing="0" width="90%" align="center">
				<!--- CANCEL UNPAID CHARGE --->
				<cfform name="cancel_invoice" action="?curdoc=invoice/qr_cancel_general_invoice" method="post"><br />
				<cfinput type="hidden" name="i" value="#get_invoice.uniqueid#">
				<tr bgcolor="##C2D1EF"><th colspan="4"><b>CANCEL UNPAID CHARGES</b></th></tr>
				<tr>
					<td width="12%"><b>Include Charge</b></td>
					<td width="48%"><b>Charge Type</b></td>
					<td width="15%"><b>Amount US$</b></td>
					<td width="25%"><b>Description</b></td>
				</tr>								
				<cfinput type="hidden" name="total_cancelbox" value="#get_charges.recordcount#">
				
				<cfloop query="get_charges">
					<cfinput type="hidden" name="chargeid#currentrow#" value="#chargeid#">						
					<cfquery name="total_received" datasource="MySql">
						SELECT sum(amount_paid) as amount_paid
						FROM egom_payment_charges
						INNER JOIN egom_charges ON egom_charges.chargeid = egom_payment_charges.chargeid
						WHERE egom_charges.chargeid = '#chargeid#'
					</cfquery>
					
					<cfif total_received.amount_paid EQ ''>
						<cfquery name="check_cancelation" datasource="MySql">
							SELECT chargeid, invoiceid, chargetypeid, studentid, programid, amount, description 
							FROM egom_charges
							WHERE chargetypeid = '13'
								AND amount = '-#amount#'
								AND invoiceid = '#invoiceid#'
						</cfquery>
						<cfif check_cancelation.recordcount EQ 0>
						<tr>
							<td align="center"><cfinput type="checkbox" name="cancel_box#currentrow#"></td>
							<td>Cancel #charge# on invoice ###invoiceid#</td>
							<td>(#LSCurrencyFormat(amount, 'local')#)</td>
							<td><cfinput type="text" name="cancel_reason#currentrow#" size="24" value="Cancelation #description#"></td>
						</tr>
						</cfif>
					</cfif>	
				</cfloop>
				<tr bgcolor="##C2D1EF"><th colspan="5"><a href="?curdoc=invoice/invoice_index"><img src="pics/back.gif" border="0" /></a> &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp; <cfinput type="image" name="next" value=" Submit " src="pics/submit.gif" submitOnce></th></tr>
				</cfform>
			</table>
		</td>
	</tr>
</table><br /><br />

</cfoutput>

</body>
</html>