<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="../check_rights.cfm">

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>SMG Statement</title>
<style type="text/css">
<!--
.style1 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 11px;
}
-->
</style>
</head>

<body>

<script language="JavaScript" type="text/JavaScript">
<!--
var newwindow;
function OpenInvoice(url)
{
	newwindow=window.open(url, 'Invoice', 'height=580, width=790, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); 
	if (window.focus) {newwindow.focus()}
}
function OpenPayment(url)
{
	newwindow=window.open(url, 'Payment', 'height=350, width=550, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); 
	if (window.focus) {newwindow.focus()}
}
function OpenCredit(url)
{
	newwindow=window.open(url, 'Credit', 'height=580, width=790, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); 
	if (window.focus) {newwindow.focus()}
}
function OpenRefund(url)
{
	newwindow=window.open(url, 'Refund', 'height=580, width=790, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); 
	if (window.focus) {newwindow.focus()}
}
//-->
</script>

<Cfquery name="get_intl_rep" datasource="caseusa">
	SELECT userid, businessname
	FROM smg_users
	WHERE usertype = '8'
		AND active = '1'
		<cfif client.usertype GT '4'>
			AND userid = <cfqueryparam value="#client.userid#" cfsqltype="cf_sql_integer">
		</cfif>
	ORDER BY businessname
</Cfquery>

<cfquery name="get_companyname" datasource="caseusa">
	SELECT companyid, companyname
	FROM smg_companies
	WHERE companyid = '5'
</cfquery>

<cfoutput>

<cfif NOT IsDefined('form.userid')>
	<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
		<tr valign=middle height=24>
			<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
			<td width=26 background="pics/header_background.gif"><img src="pics/$.gif"></td>
			<td background="pics/header_background.gif"><h2>SMG Detailed Statement</h2></td>
			<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
		</tr>
	</table>
	
	<table border=0 cellpadding=8 cellspacing=2 width=100% class="section">
		<tr>
			<td width="100%" valign="top" align="center">
				<cfform action="invoice/reports/statement_detailed.cfm" method="POST" target="blank">
					<Table class="nav_bar" cellpadding=6 cellspacing="0" width="60%" align="center">
						<tr><th colspan="2" bgcolor="##e2efc7">SMG Detailed Statement</th></tr>
						<tr align="left">
							<td>Intl. Rep:</td>
							<td><select name="userid" size="1">
								<cfloop query="get_intl_rep">
									<option value="#userid#">#businessname#</option>
								</cfloop>
								</select>
							</td>
						</tr>
						<tr>
							<td>From : </td>
							<td><cfinput type="text" name="date1" size="8" maxlength="10" validate="date"> mm-dd-yyyy</td>
						</tr>
						<tr>
							<td>To : </td>
							<td><cfinput type="text" name="date2" size="8" maxlength="10" validate="date"> mm-dd-yyyy</td>
						</tr>			
						<tr><td>* Dates are not required.</td></tr>
						<tr><td>&nbsp;</td></tr>	
						<tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
					</table>
				</cfform>
			</td>
		</tr>
	</table>
<cfinclude template="../../table_footer.cfm">	

<!--- REPORT --->
<cfelse>

	<Cfquery name="get_intl_rep" datasource="caseusa">
		SELECT businessname, firstname, lastname, city, smg_countrylist.countryname
		FROM smg_users
		LEFT JOIN smg_countrylist ON smg_countrylist.countryid = smg_users.country
		WHERE userid = <cfqueryparam value="#form.userid#" cfsqltype="cf_sql_integer">
	</Cfquery>

	<!--- RUNNING BALANCE --->
	<cfquery name="get_statement" datasource="caseusa">
		SELECT 'invoice', 'paymenttype', smg_users.businessname, SUM( smg_charges.amount_due ) AS total_amount, smg_charges.invoicedate as orderdate, invoiceid, 'paymentref', 'creditid', 'description' 
		FROM smg_charges
		INNER JOIN smg_users ON smg_charges.agentid = smg_users.userid
		WHERE smg_users.userid = '#form.userid#'
			<cfif form.date1 NEQ '' AND form.date2 NEQ ''>
				AND (smg_charges.invoicedate BETWEEN #CreateODBCDateTime(form.date1)# AND #CreateODBCDateTime(form.date2)#)
			</cfif>
		GROUP BY smg_users.userid, smg_charges.invoiceid
		UNION
		SELECT 'payments', paymenttype, smg_users.businessname, SUM( pay.totalreceived ) AS total_amount, pay.date as orderdate, '0', paymentref, 'creditid', 'description'
		FROM smg_payment_received pay
		INNER JOIN smg_users ON pay.agentid = smg_users.userid
		WHERE smg_users.userid = '#form.userid#'
			AND pay.paymenttype != 'apply credit'
			<cfif form.date1 NEQ '' AND form.date2 NEQ ''>
				AND (pay.date BETWEEN #CreateODBCDateTime(form.date1)# AND #CreateODBCDateTime(form.date2)#)
			</cfif>
		GROUP BY smg_users.userid, pay.paymentref
		UNION
		SELECT 'credits', type, smg_users.businessname, smg_credit.amount AS total_amount, smg_credit.date as orderdate, invoiceid, 'paymentref', smg_credit.creditid, CAST(CONCAT('stu id: ', smg_credit.stuid, ' inv: ',  smg_credit.invoiceid, '. ', smg_credit.description) as CHAR) as description
		FROM smg_credit
		INNER JOIN smg_users ON smg_credit.agentid = smg_users.userid
		WHERE smg_users.userid = '#form.userid#'
			<cfif form.date1 NEQ '' AND form.date2 NEQ ''>
				AND (smg_credit.date BETWEEN #CreateODBCDateTime(form.date1)# AND #CreateODBCDateTime(form.date2)#)
			</cfif>
		UNION
		SELECT 'refund', 'paymenttype', smg_users.businessname, SUM(ref.amount) AS total_amount, ref.date as orderdate, refund_receipt_id, 'paymentref', 'creditid', 'description'
		FROM smg_invoice_refunds ref
		INNER JOIN smg_users ON ref.agentid = smg_users.userid
		WHERE smg_users.userid = '#form.userid#'
			<cfif form.date1 NEQ '' AND form.date2 NEQ ''>
				AND (ref.date BETWEEN #CreateODBCDateTime(form.date1)# AND #CreateODBCDateTime(form.date2)#)
			</cfif>	
		GROUP BY smg_users.userid, refund_receipt_id	
		ORDER BY orderdate DESC
	</cfquery>
	<!--- END OF RUNNING BALANCE --->

	<!--- BEGINNING BALANCE --->
	<cfset beg_invoiced = 0>
	<cfset beg_payments = 0>
	<cfset beg_balance = 0>
	<cfset beg_refund = 0>

	<!--- ONLY IF DATES ARE FILLED --->
	<cfif form.date1 NEQ '' AND form.date2 NEQ ''>
	
		<cfquery name="beginning_balance" datasource="caseusa">
			SELECT 'invoice', smg_users.businessname, SUM( smg_charges.amount_due ) AS total_amount, smg_charges.invoicedate as orderdate
			FROM smg_charges
			INNER JOIN smg_users ON smg_charges.agentid = smg_users.userid
			WHERE smg_users.userid = '#form.userid#'
				<cfif form.date1 NEQ '' AND form.date2 NEQ ''>
					AND smg_charges.invoicedate < #CreateODBCDateTime(form.date1)#
				</cfif>
			GROUP BY smg_users.userid, smg_charges.invoicedate
			UNION
			SELECT 'payments', smg_users.businessname, SUM( pay.totalreceived ) AS total_amount, pay.date as orderdate
			FROM smg_payment_received pay
			INNER JOIN smg_users ON pay.agentid = smg_users.userid
			WHERE smg_users.userid = '#form.userid#'
				AND pay.paymenttype != 'apply credit'
				<cfif form.date1 NEQ '' AND form.date2 NEQ ''>
					AND pay.date < #CreateODBCDateTime(form.date1)#
				</cfif>
			GROUP BY smg_users.userid, pay.date
			UNION
			SELECT 'credits', smg_users.businessname, SUM( smg_credit.amount ) AS total_amount, smg_credit.date as orderdate
			FROM smg_credit
			INNER JOIN smg_users ON smg_credit.agentid = smg_users.userid
			WHERE smg_users.userid = '#form.userid#'
				<cfif form.date1 NEQ '' AND form.date2 NEQ ''>
					AND smg_credit.date < #CreateODBCDateTime(form.date1)#
				</cfif>
			GROUP BY smg_users.userid, smg_credit.date
			UNION 
			SELECT 'refund', smg_users.businessname, SUM(ref.amount) AS total_amount, ref.date as orderdate
			FROM smg_invoice_refunds ref
			INNER JOIN smg_users ON ref.agentid = smg_users.userid
			WHERE smg_users.userid = '#form.userid#'
				<cfif form.date1 NEQ '' AND form.date2 NEQ ''>
					AND ref.date < #CreateODBCDateTime(form.date1)#
				</cfif>
			GROUP BY smg_users.userid, refund_receipt_id				
			ORDER BY orderdate
		</cfquery>
		
		<cfloop query="beginning_balance">
			<cfif invoice EQ 'invoice'>
				<cfset beg_invoiced = beg_invoiced + total_amount>			
			</cfif>
			<cfif invoice EQ 'payments'>
				<cfset beg_payments = beg_payments + total_amount>
			</cfif>
			<cfif invoice EQ 'credits'>
				<cfset beg_payments = beg_payments + total_amount>					
			</cfif>	
			<cfif invoice EQ 'refund'>
				<cfset beg_refund = beg_refund + total_amount>					
			</cfif>	
			<cfset beg_balance = beg_invoiced - beg_payments + beg_refund>	
		</cfloop>
	
	</cfif>
	<!--- END OF BEGINNING BALANCE --->

	<!--- OUTSTANDING BALANCE ---->
	<cfquery name="outstanding_balance" datasource="caseusa">
		SELECT 'invoice', smg_users.businessname, SUM( smg_charges.amount_due ) AS total_amount, smg_charges.invoicedate as orderdate
		FROM smg_charges
		INNER JOIN smg_users ON smg_charges.agentid = smg_users.userid
		WHERE smg_users.userid = '#form.userid#'
			<cfif form.date1 NEQ '' AND form.date2 NEQ ''>
				AND (smg_charges.invoicedate BETWEEN #CreateODBCDateTime(form.date1)# AND #CreateODBCDateTime(form.date2)#)
			</cfif>
		GROUP BY smg_users.userid, smg_charges.invoicedate
		UNION
		SELECT 'payments', smg_users.businessname, SUM( pay.totalreceived ) AS total_amount, pay.date as orderdate
		FROM smg_payment_received pay
		INNER JOIN smg_users ON pay.agentid = smg_users.userid
		WHERE smg_users.userid = '#form.userid#'
			AND pay.paymenttype != 'apply credit'
			<cfif form.date1 NEQ '' AND form.date2 NEQ ''>
				AND (pay.date BETWEEN #CreateODBCDateTime(form.date1)# AND #CreateODBCDateTime(form.date2)#)
			</cfif>
		GROUP BY smg_users.userid, pay.date
		UNION
		SELECT 'credits', smg_users.businessname, SUM( smg_credit.amount ) AS total_amount, smg_credit.date as orderdate
		FROM smg_credit
		INNER JOIN smg_users ON smg_credit.agentid = smg_users.userid
		WHERE smg_users.userid = '#form.userid#'
			<cfif form.date1 NEQ '' AND form.date2 NEQ ''>
				AND (smg_credit.date BETWEEN #CreateODBCDateTime(form.date1)# AND #CreateODBCDateTime(form.date2)#)
			</cfif>
		GROUP BY smg_users.userid, smg_credit.date
		UNION
		SELECT 'refund', smg_users.businessname, SUM(ref.amount) AS total_amount, ref.date as orderdate
		FROM smg_invoice_refunds ref
		INNER JOIN smg_users ON ref.agentid = smg_users.userid
		WHERE smg_users.userid = '#form.userid#'
			<cfif form.date1 NEQ '' AND form.date2 NEQ ''>
				AND (ref.date BETWEEN #CreateODBCDateTime(form.date1)# AND #CreateODBCDateTime(form.date2)#)
			</cfif>
		GROUP BY smg_users.userid, refund_receipt_id					
		ORDER BY orderdate
	</cfquery>

	<cfset out_invoiced = 0>
	<cfset out_payments = 0>
	<cfset out_refund = 0>
	
	<cfloop query="outstanding_balance">
		<cfif invoice EQ 'invoice'>
			<cfset out_invoiced = out_invoiced + total_amount>
		</cfif>
		<cfif invoice EQ 'payments'>
			<cfset out_payments = out_payments + total_amount>
		</cfif>
		<cfif invoice EQ 'credits'>
			<cfset out_payments = out_payments + total_amount>
		</cfif>
		<cfif invoice EQ 'refund'>
			<cfset out_refund = out_refund + total_amount>					
		</cfif>			
	</cfloop>
	
	<cfset outstanding = beg_balance + (out_invoiced - out_payments + out_refund)>
	<!--- END OF OUTSTANDING BALANCE --->

	<cfset total_invoiced = 0>
	<cfset total_payments = 0>
	<cfset total_refund = 0>
	<cfset running_balance = outstanding>

	<table width="650" cellpadding="2" cellspacing="0" border="1" align="center">
		<tr><th colspan="5">
				<table width="100%">
					<tr>
						<th width="100"><img src="../../pics/logos/#get_companyname.companyid#.gif" border="0" /></th>
						<th width="450" valign="top">#get_companyname.companyname# <br /><br /> Account Statement</th>
					</tr>
				</table>
			</th>
		</tr>
		<tr>
			<th colspan="5">
				Intl. Agent: &nbsp; #get_intl_rep.businessname#<br /> <br />
				OUTSTANDING BALANCE: #LSCurrencyFormat(outstanding, 'local')#<br />
				<cfif form.date1 NEQ '' AND form.date2 NEQ ''>
				<br /> From &nbsp; #DateFormat(form.date1, 'mm/dd/yyyy')# &nbsp; to &nbsp; #DateFormat(form.date2, 'mm/dd/yyyy')#
				</cfif>
			</th>
		</tr>

		<!--- RUNNING BALANCE --->
		<tr class="style1">
			<th>Date</th><th>Type</th><th>Description / Reference number</th><th>Amount</th><th>Running <br /> Balance</th>
		</tr>				
		<cfloop query="get_statement">
		<tr class="style1" <cfif currentrow MOD 2 EQ 0>bgcolor="##E0E0E0"<cfelse>bgcolor="##FFFFFF"</cfif>>
			<td align="center">#DateFormat(orderdate, 'mm/dd/yyyy')#</td>
			<td align="center">
				<cfif invoice EQ 'invoice'>#invoice#</cfif>
				<cfif invoice EQ 'payments'>#paymenttype#</cfif>
				<cfif invoice EQ 'credits'>#paymenttype#</cfif>
				<cfif invoice EQ 'refund'>#invoice#</cfif>
			</td>
			<td>
				<cfif invoice EQ 'invoice'><a href="javascript:OpenInvoice('../invoice_view.cfm?id=#invoiceid#');">###invoiceid#</a></cfif>
				<cfif invoice EQ 'payments'><a href="javascript:OpenPayment('../payment_details.cfm?ref=#paymentref#&userid=#form.userid#');">###paymentref#</a></cfif>
				<cfif invoice EQ 'credits'><a href="javascript:OpenCredit('../credit_note.cfm?creditid=#creditid#');">###creditid#</a> &nbsp; #description#</cfif>
				<cfif invoice EQ 'refund'><a href="javascript:OpenCredit('../view_refund_receipt.cfm?id=#invoiceid#&userid=#form.userid#');">###invoiceid#</a></cfif>
			</td>
			<td align="right">
				<cfif invoice EQ 'invoice'>
					#LSCurrencyFormat(total_amount, 'local')#
					<cfset total_invoiced = total_invoiced + total_amount>				
				</cfif>
				<cfif invoice EQ 'payments'>
					<font color="##FF0000">(#LSCurrencyFormat(total_amount, 'local')#)</font>
					<cfset total_payments = total_payments + total_amount>	
				</cfif>
				<cfif invoice EQ 'credits'>
					<font color="##FF0000">(#LSCurrencyFormat(total_amount, 'local')#)</font>
					<cfset total_payments = total_payments + total_amount>					
				</cfif>
				<cfif invoice EQ 'refund'>
					#LSCurrencyFormat(total_amount, 'local')#
					<cfset total_refund = total_refund + total_amount>					
				</cfif>
			</td>
			<td align="right">
				<cfset last_balance = running_balance>
				<cfset running_balance = outstanding - (total_invoiced - total_payments + total_refund)>
				<cfif last_balance LT 0>
					<font color="##FF0000">#LSCurrencyFormat(last_balance, 'local')#</font>
				<cfelse>
					#LSCurrencyFormat(last_balance, 'local')#
				</cfif>
			</td>
		</tr>
		</cfloop>
		<!--- END OF RUNNING BALANCE --->

		<!--- BEGINNING BALANCE --->
		<cfif form.date1 NEQ '' AND form.date2 NEQ ''>
			<tr class="style1">
				<th>Date</th><th>Type</th><th>Description / Reference number</th><th>Amount</th><th>Running <br /> Balance</th>
			</tr>		
			<tr class="style1">
				<td align="center"><b> < </b> &nbsp; #DateFormat(form.date1, 'mm/dd/yyyy')#</td>
				<td align="center">beginning balance</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td align="right">#LSCurrencyFormat(beg_balance, 'local')#</td>
			</tr>
		</cfif>
		<!--- END OF BEGINNING BALANCE --->
	</table><br />
</cfif>

</cfoutput>
</body>
</html>