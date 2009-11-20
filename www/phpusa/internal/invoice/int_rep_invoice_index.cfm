<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Invoicing</title>
</head>

<!---
www.phpusa.com/?i=uniqueid for an external link to the invoice.
s = for statement
---->

<style type="text/css">
<!--
div.scroll {
	height: 250px;
	width:auto;
	overflow:auto;
	left:auto;
}
</style>

<body>

<cfsetting requesttimeout="300">
<!----Query to get Students---->
<cfquery name="students" datasource="MySql"> <!--- cachedwithin="#CreateTimeSpan(0,0,60,0)#" --->
	SELECT s.studentid, s.firstname, s.familylastname, php.programid,  
		u.accepts_sevis_fee, u.businessname,
		p.programname,
		programtype.programtypeid,
		php_schools.tuition_semester, php_schools.tuition_year
	FROM php_students_in_program php
	INNER JOIN smg_students s ON php.studentid = s.studentid
	INNER JOIN smg_users u ON  u.userid = s.intrep
	LEFT JOIN smg_programs p ON p.programid = php.programid
	LEFT JOIN php_schools ON php_schools.schoolid = php.schoolid
	LEFT JOIN smg_program_type programtype ON programtype.programtypeid = p.type
	WHERE php.companyid = <cfqueryparam value="#client.companyid#" cfsqltype="cf_sql_integer">
		AND php.active = '1'
		<cfif client.usertype eq 8>
			and s.intrep = #client.userid#
		</cfif>
	ORDER BY u.businessname, familylastname
</cfquery>
<cfset daysago = #now()# - 30>
<!----Recent Payments---->
<cfquery name="payments_received" datasource="mysql">
select sum(total_amount) as payments_received
from egom_payments
where intrepid = #client.userid#
and companyid = #client.companyid#
and (date_applied between #CreateODBCDateTime(daysago)# and #CreateODBCDateTime(now())#)
</cfquery>


<!----Amount Due---->
<cfquery name="amount_due" datasource="mysql">
select sum(amount) as total_Due
from egom_charges
LEFT JOIN egom_invoice on egom_invoice.invoiceid = egom_charges.invoiceid
where egom_invoice.intrepid = #client.userid#
and egom_charges.full_paid = 0
and egom_invoice.companyid = #client.companyid#
</cfquery>


<cfoutput>

<br />
<table width="95%" class="box" bgcolor="##ffffff" align="center" cellpadding="3" cellspacing="0">
	
	<tr>
		<td width="50%" valign="top">
			<table border="0" cellpadding="3" cellspacing="0" width="100%">
				<tr><td colspan="2" bgcolor="##C2D1EF"><img src="pics/$.gif"><img src="pics/$.gif"><img src="pics/$.gif"> <b>Account Overview</b></td></tr>
				<tr><td width="60%" valign="top">	
						<table border="0" cellpadding="3" cellspacing="0" width="100%">
							<tr>
								<td valign="top">Account Balance</td><td>Recent Payments</td>
							</tr>
							<tr>
								<td valign="top"><b><cfif amount_due.total_due is ''>$0.00<cfelse>#LSCurrencyFormat(amount_due.total_due, 'local')#</a></cfif></b></td>
								<td valign="top"><b><A href="?curdoc=invoice/int_rep_account_activity">  <cfif payments_received.payments_received is ''>$0.00<cfelse>#LSCurrencyFormat(payments_received.payments_received, 'local')#</cfif></A></b><br /><font size="-2">Last 30 days, <A href="?curdoc=invoice/int_rep_account_activity">click for all</A></font></td>
							</tr>
						</table>
					</td>
					<td width="40%" valign="top">
						<table border="0" cellpadding="3" cellspacing="0" width="100%">
							<tr><td><u>Last Payment</u><br></td></tr>
							<tr>
								<td>
									<cfquery name="max_payment_id" datasource="mysql">
									select max(paymentid) as payid from egom_payments
									where intrepid = #client.userid#
									</cfquery>
									
									<cfif max_payment_id.payid is ''>
									No payments have been processed.
									<cfelse>
									
									<cfquery name="last_payment" datasource="mysql">
									select total_amount, date_applied, paymenttypeid
									from egom_payments
									where paymentid = #max_payment_id.payid#
									</cfquery>
									#LSCurrencyFormat(last_payment.total_amount, 'local')# on #DateFormat(last_payment.date_applied,'mm/dd/yyyy')# 
									</cfif>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
		<td width="50%" valign="top">
			<!----<table border="0" cellpadding="3" cellspacing="0" width="100%">
				<tr><td colspan="2" bgcolor="##C2D1EF"><img src="pics/$.gif"><img src="pics/$.gif"><img src="pics/$.gif"> <b>Finance Reports & Tools</b></td></tr>
				<tr><td width="50%" valign="top"><u>:: Reports</u></td><td width="50%" valign="top"><u>:: Tools</u></td></tr>				
				<tr><td><a href="?curdoc=invoice/int_rep_account_activity">Balance Report</a></td><td><a href="?curdoc=invoice/school_tuition">Request Refund / Adjustment</a></td></tr>
				<tr><td></td><td>Reprint an Invoice or Statement</td></tr>
			</table>---->
		</td>
	</tr>
</table>
<br /><br />

<table  width="95%" class="box" bgcolor="##ffffff" align="center" cellpadding="3" cellspacing="0">
	<tr><td bgcolor="##C2D1EF"><b>Students List &nbsp; &nbsp; &nbsp; &nbsp; Total of #students.recordcount# student(s)</b></td></tr>
	<tr>
		<td width="100%">
			<table border="0" cellpadding="3" cellspacing="0" width="100%">				
				<tr>
					
					<td width="24%"><b>Student</b></td>
					<td width="10%" align="right"><b>School Tuition</b></td>
					<td width="10%" align="right"><b>Total Invoiced</b></td>
					<td width="10%" align="right"><b>Received</b></td>
					<td width="10%" align="right"><b>Credit</b></td>
					<td width="10%" align="right"><b>Outstanding</b></td>
					<td width="2%">&nbsp;</td>
				</tr>
			</table>			
			<div class="scroll">
			<table border="0" cellpadding="3" cellspacing="0" width="100%">				
			<cfloop query="students">
				<cfquery name="total_invoiced" datasource="MySql">
					SELECT sum(amount) as amount
					FROM egom_charges
					WHERE studentid = '#studentid#'
				</cfquery>	
				<cfif total_invoiced.amount is ''>
					<cfset total_invoiced.amount = 0>
				</cfif>
				<cfquery name="total_received" datasource="mysql">
				select sum(egom_payment_charges.amount_paid) as total_amount
				from egom_payment_charges
				LEFT JOIN egom_charges on egom_charges.chargeid = egom_payment_charges.chargeid
				where egom_charges.studentid = #studentid# 
				</cfquery>							
				<cfif total_received.total_amount is ''>
					<cfset total_received.total_amount = 0>
				</cfif>
				<cfif programtypeid EQ '1' OR programtypeid EQ '2'>
					<cfset school_tuition = '#tuition_year#'>
				<cfelseif programtypeid EQ '3' OR programtypeid EQ '4'>
					<cfset school_tuition = '#tuition_semester#'>
				<cfelse>
					<cfset school_tuition = ''>
				</cfif>
				
				<tr bgcolor="#iif(students.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
					
					<td width="24%"><a href="?curdoc=invoice/view_student_info&studentid=#studentid#">#firstname# #familylastname# (###studentid#)</a></td>
					<cfif programid EQ 0>
						<td colspan="6" align="center" bgcolor="##FFCCFF">Student has not been assigned to a program.</td>
					<cfelseif school_tuition EQ ''>
						<td colspan="6" align="center" bgcolor="##9999FF">Tuition for this school has not been recorded.</td>
					<cfelse>
						<td width="10%" align="right">#LSCurrencyFOrmat(school_tuition, 'local')#</td>
						<td width="10%" align="right"><cfif total_invoiced.amount NEQ ''><a href="?curdoc=invoice/view_student_info&studentid=#studentid#">#LSCurrencyFormat(total_invoiced.amount, 'local')#</a><cfelse>$0.00</cfif></td>
						<td width="10%" align="right">#LSCurrencyFormat(total_received.total_amount,'local')#</td>
						<td width="10%" align="right">$0.00</td>
						<td width="10%" align="right"><cfset balance_due = total_invoiced.amount - #total_invoiced.amount# - #total_received.total_amount#> #LSCurrencyFOrmat(balance_Due, 'local')#</td>
						<td width="1%">&nbsp;</td>
					</cfif>
				</tr>
			</cfloop>
			</table>
			</div>
		</td>
	</tr>
</table>
<br /><br />

</cfoutput>

</body>
</html>