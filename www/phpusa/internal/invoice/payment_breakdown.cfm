<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Payment Break Down</title>
</head>
<body>

<script>
// -->
// opens letters in a defined format
function OpenInvoice(url) {
	newwindow=window.open(url, 'Invoice', 'height=580, width=790, location=no, scrollbars=yes, menubar=yes, toolbars=yes, resizable=yes'); 
	if (window.focus) {newwindow.focus()}
}
//-->
</script> 

<script>
function areYouSure() { 
   if(confirm("You are about to delete this payment. You will not be able to recover this information. Click OK to continue")) { 
     form.submit(); 
        return true; 
   } else { 
        return false; 
   } 
} 
</script>

<cfquery name="get_agent" datasource="MySql">
	SELECT userid, businessname
	FROM smg_users
	WHERE userid = <cfqueryparam value="#url.intrep#" cfsqltype="cf_sql_integer" maxlength="6">
</cfquery>

<cfquery name="get_payments" datasource="MySql">
	SELECT p.paymentid, p.date_applied, p.date_received, 
		p.total_amount, p.description as payment_description,
		ptype.paymenttype,
		u.userid, u.firstname as userfirstname, u.lastname,
		paycharge.chargeid, paycharge.amount_paid,
		charges.invoiceid, charges.amount, charges.description as charge_description,
		stu.studentid, stu.firstname, stu.familylastname,
		program.programname
	FROM egom_payments p
	LEFT JOIN egom_payment_type ptype ON ptype.paymenttypeid = p.paymenttypeid
	LEFT JOIN smg_users u ON u.userid = p.userid
	LEFT JOIN egom_payment_charges paycharge ON paycharge.paymentid = p.paymentid
	LEFT JOIN egom_charges charges ON charges.chargeid = paycharge.chargeid
	LEFT JOIN smg_programs program ON program.programid = charges.programid
	INNER JOIN smg_students stu ON stu.studentid = charges.studentid
	WHERE p.intrepid = <cfqueryparam value="#url.intrep#" cfsqltype="cf_sql_integer" maxlength="6">
		AND p.companyid = '#client.companyid#'
	ORDER BY p.date_received
</cfquery>

<cfset total_payments = 0>

<br />
<table width="95%" class="box" bgcolor="##ffffff" align="center" cellpadding="3" cellspacing="0">
	<cfoutput>
	<tr><th colspan="2" bgcolor="##C2D1EF">#get_agent.businessname# - Payment Break Down</th></tr>
	</cfoutput>
	<tr>
		<td width="100%" valign="top">
			<table border="0" cellpadding="3" cellspacing="0" width="100%">				
				<tr>
                	<td width="10%" align="center"><b>Delete</b></td>
					<td width="10%" align="center"><b>Payment ID</b></td>
					<td width="12%" align="center"><b>Date Received</b></td>
					<td width="12%"><b>Payment Type</b></td>
					<td width="18%"><b>Received By</b></td>
					<td width="16%" align="right"><b>Total Received</b></td>
					<td width="22%">&nbsp;</td>
				</tr>
				<cfoutput query="get_payments" group="paymentid">
					<tr bgcolor="e9ecf1">
                   	  <cfif client.usertype LTE '4'><td bgcolor="##C2D1EF"><div align="center"><a href="?curdoc=invoice/delete_invoice&paymentid=#paymentid#" onClick="return areYouSure(this);"><img src="pics/deletex.gif"  border="0"></img></a></div></td>
			</cfif>	
						<td align="center">#paymentid#</td>
						<td align="center">#DateFormat(date_received, 'mm/dd/yyyy')#</td>
						<td>#paymenttype#</td>
						<td>#userfirstname# #lastname# (###userid#)</td>
						<td align="right"><b>#LSCurrencyFOrmat(total_amount, 'local')#</b></td>
						<td>&nbsp;</td>
					</tr>
					<cfset total_payments = total_payments + total_amount>
					<cfquery name="detail" dbtype="query">
						SELECT chargeid, amount_paid,
							invoiceid, amount, charge_description, 
							studentid, firstname, familylastname,
							programname
						FROM get_payments
						WHERE paymentid = #paymentid#
					</cfquery>	
					<tr><td colspan="6"><b>PAYMENT DETAILS</b></td></tr>
					<tr>
						<td colspan="6">
							<table border="0" cellpadding="3" cellspacing="0" width="100%">	
								<tr>
									<td width="10%" align="center"><b>Invoice ID</b></td>
									<td width="25%"><b>Student</b></td>
									<td width="10%"><b>Program</b></td>
									<td width="10%" align="center"><b>Charge ID</b></td>
									<td width="25%"><b>Description</b></td>
									<td width="10%" align="right"><b>Charged</b></td>
									<td width="10%" align="right"><b>Received</b></td>							
								</tr>
								<cfloop query="detail">
									<tr>
										<td align="center">#invoiceid#</td>
										<td>#firstname# #familylastname# (###studentid#)</td>
										<td>#programname#</td>
										<td align="center">#chargeid#</td>
										<td>#charge_description#</td>
										<td align="right">#LSCurrencyFOrmat(amount, 'local')#</td>
										<td align="right">#LSCurrencyFOrmat(amount_paid, 'local')#</td>							
									</tr>
								</cfloop>
							</table>						</td>
					</tr>
				</cfoutput>
				
				<cfoutput>
				<tr bgcolor="##e9ecf1">
					<td colspan="3">&nbsp;</td>
					<td align="right"><b>Total Received</b></td>
					<td align="right"><b>#LSCurrencyFormat(total_payments, 'local')#</b></td>
					<td>&nbsp;</td>
				</tr>
				</cfoutput>
				<tr><td colspan="6">&nbsp;</td></tr>
			</table>
	  </td>
	</tr>
</table>

<br /><br />

</body>
</html>