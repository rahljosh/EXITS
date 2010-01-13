<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Receive Payment</title>

<SCRIPT LANGUAGE="JavaScript"> 
<!-- Begin
<!-- Script for Agent
function formHandler(form){
var URL = document.form.intrep.options[document.form.intrep.selectedIndex].value;
window.location.href = URL;
}
<!-- Script for invoice
function formHandlerInvoice(form){
var URL = document.form.invoice.options[document.form.invoice.selectedIndex].value;
window.location.href = URL;
}
<!-- script for student
function formHandlerStudents(form){
var URL = document.form.open_students.options[document.form.open_students.selectedIndex].value;
window.location.href = URL;
}
// opens letters in a defined format
function OpenInvoice(url) {
	newwindow=window.open(url, 'Invoice', 'height=580, width=790, location=no, scrollbars=yes, menubar=yes, toolbars=yes, resizable=yes'); 
	if (window.focus) {newwindow.focus()}
}

function CalculateTotal() {
    var payment_total = 0;

    // Run through all the form fields
    for (var i=0; i < document.payment.elements.length; ++i) {
        // Get the current field
        form_field = document.payment.elements[i];
       
	    // Get the field's name
        form_name = form_field.name;
	
        // Is it a "amount" field?
        if (form_name.substring(0,7) == "amount_") {           
			// If so, extract the amount from the name
			if (form_field.value == "") {
				charge_amount = 0
			} else {
				charge_amount = parseFloat(form_field.value);
			}
		    // Update the order total
            payment_total += charge_amount;
        }
    }
    // Display the total rounded to two decimal places
    document.payment.payment_amount.value = payment_total;
}
//-->
</script> 
</head>

<body>

<cfquery name="agents" datasource="MySql"> <!--- cachedwithin="#CreateTimeSpan(0,0,60,0)#" --->
	SELECT distinct u.businessname, u.userid
	FROM php_students_in_program php
	INNER JOIN smg_students s ON php.studentid = s.studentid
	INNER JOIN smg_users u ON  u.userid = s.intrep
	LEFT JOIN smg_programs p ON p.programid = php.programid
	LEFT JOIN php_schools ON php_schools.schoolid = php.schoolid
	LEFT JOIN smg_program_type programtype ON programtype.programtypeid = p.type
	WHERE php.companyid = <cfqueryparam value="#client.companyid#" cfsqltype="cf_sql_integer">
		AND php.active = '1'
	ORDER BY u.businessname, familylastname
</cfquery>

<cfif isDefined('url.intrep')>
	<cfset intrep = #url.intrep#>
<cfelse>
	<cfset intrep = 0>
</cfif>
	
<cfoutput>

<br />
<table width="95%" class="box" bgcolor="##ffffff" align="center" cellpadding="3" cellspacing="0">
	<tr><th>Receive a Payment</th></tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td width="100%" valign="top">
			<form name="form">
			<table border="0" cellpadding="3" cellspacing="0" width="100%">
				<tr><th colspan="4" bgcolor="##C2D1EF">Charges & Payment Review</th></tr>
				<tr>
					<Td>Agent:</Td>
					<td>
						<select name="intrep" onChange="javascript:formHandler()">
							<option value="?curdoc=invoice/receive_payment">Select Agent...</option>
							<cfloop query="agents">
							<option value="?curdoc=invoice/receive_payment&intrep=#userid#" <cfif intrep EQ userid>selected</cfif>>#businessname#</option>
							</cfloop>
						</select>
					</td>
				</tr>
				<Cfif isDefined('url.intrep')>
					<!----Charges by Invoice #---->
					<cfquery name="open_invoices" datasource="MySql"> 
						SELECT sum(egom_charges.amount) as invoice_amount, egom_charges.invoiceid
						FROM egom_charges
						LEFT JOIN egom_invoice on egom_invoice.invoiceid = egom_charges.invoiceid
						WHERE egom_invoice.full_paid = '0'
							AND egom_invoice.companyid = '6'
							AND egom_invoice.intrepid = '#intrep#'
							AND egom_charges.canceled = '0'
						GROUP BY invoiceid
					</cfquery>
					<!----Charges by Student---->
					<cfquery name="open_students" datasource="mysql">
						SELECT sum(e.amount) as student_amount, e.studentid, e.invoiceid,
							s.firstname, s.familylastname
						FROM egom_charges e 
						LEFT JOIN egom_invoice i on i.invoiceid = e.invoiceid
						LEFT JOIN smg_students s on s.studentid = e.studentid
						WHERE s.intrep = '#intrep#'
							AND e.full_paid = '0'
							AND e.canceled = '0'
						GROUP BY s.firstName
					</cfquery>
					<tr><td colspan=4>Select by invoice or student, keep in mind that a student may have charges on multiple invoices.</td></tr>
					<tr>
						<td>By Invoices</td>
						<td>
							<select name="invoice" onChange="javascript:formHandlerInvoice()">
							<option value="?curdoc=invoice/receive_payment&intrep=#intrep#">Select Invoice</option>
							<cfloop query="open_invoices">
							<option value = "?curdoc=invoice/receive_payment&intrep=#intrep#&invoice=#invoiceid#" <cfif isDefined('url.invoice')><cfif url.invoice eq invoiceid>selected</cfif></cfif>>###invoiceid# - #LSCurrencyFormat(invoice_amount,'local')#</option>
							</cfloop>
							</select>
						</td>
						<td>By Student</td>
						<td>
							<select name="open_students" onChange="javascript:formHandlerStudents()">
							<option value="?curdoc=invoice/receive_payment&intrep=#intrep#">Select Student</option>
							<cfloop query="open_students">
							<option value = "?curdoc=invoice/receive_payment&intrep=#intrep#&student=#studentid#" <cfif isDefined('url.student')><cfif url.student eq studentid>selected</cfif></cfif>>###studentID# - #firstname# #familylastname# - #LSCurrencyFormat(student_amount,'local')#</option>
							</cfloop>
							</select>
						</td>
					</tr>
					<CFIF isDefined('URL.INVOICE')>
						<cfquery name="charges" datasource="mysql">
							SELECT inv.invoiceid, inv.intrepid, inv.date,
								s.firstname, s.familylastname,
								e.chargetypeid, e.studentid, e.programid, e.amount, e.description, e.date, e.full_paid, e.canceled,
								u.userid, u.businessname, u.firstname, u.lastname, u.address, u.address2, u.city, u.zip, u.phone, u.fax, u.email,
								smg_countrylist.countryname, billcountry.countryname as billcountryname, e.chargeid
							FROM egom_invoice inv
							LEFT JOIN smg_users u on u.userid = inv.intrepid
							LEFT JOIN egom_charges e on e.invoiceid = inv.invoiceid
							LEFT JOIN smg_students s on s.studentid = e.studentid
							LEFT JOIN smg_countrylist ON smg_countrylist.countryid = u.country  
							LEFT JOIN smg_countrylist billcountry ON billcountry.countryid = u.billing_country  	
							WHERE inv.invoiceid = '#url.invoice#'
							ORDER BY e.invoiceid
						</cfquery>
						<cfset balance = 0>
						<tr>
							<td colspan=4><em>Details of Invoice:</em></td>
						</tr>
						<tr>
							<table border="0" cellpadding="3" cellspacing="0" width="100%">
								<tr>
									<td><b>Date</b></td>
									<td><b>Student Name (ID)</b></td>
									<td><b>Description</b></td>
									<td><b>Amount</b></td>
									<td><b>Received</b></td>
									<td><b>Running Total</b></td>
								</tr>
								<cfloop query="charges">
										<cfquery name="check_partial" datasource="mysql">
											SELECT sum(amount_paid) as amount_paid 
											FROM egom_payment_charges
											WHERE chargeid = #chargeid#
										</cfquery>
										<cfif check_partial.amount_paid EQ ''>
											<cfset check_partial.amount_paid = 0>
										</cfif>
								<tr <cfif charges.currentrow mod 2>bgcolor="##F5F5F5"</cfif>>	
									<td>#LSDateFormat(date, 'mm/dd/yyyy')#</td>
									<td>#firstname# #familylastname# (###studentid#)</td>
									<td>#description#</td>
									<td><cfif canceled EQ '1'><span class="strike"></cfif>#LSCurrencyFormat(amount,'local')#</td>
									<td>#LSCurrencyFormat(check_partial.amount_paid,'local')#</td>
									<td><cfif full_paid NEQ 1 AND canceled NEQ '1'><cfset balance = balance + amount - check_partial.amount_paid></cfif>#LSCurrencyFormat(balance,'local')#</td>
								</tr>	
								</cfloop>
								<tr>
									<td colspan=5 align="center"><strong>Total Due: #LSCurrencyFormat(balance,'local')#</strong></td>
								</tr>
							</table>
					</CFIF>
					<!----if a student is selected---->
					<CFIF isDefined('URL.student')>
						<cfquery name="charges" datasource="mysql">
							SELECT e.invoiceid, e.chargeid, e.studentid, e.amount, e.description, e.date, e.full_paid, e.canceled,
								s.familylastname, s.firstname, i.uniqueid
							FROM egom_charges e
							LEFT JOIN smg_students s on s.studentid = e.studentid
							LEFT JOIN egom_invoice i on i.invoiceid = e.invoiceid
							WHERE e.studentid = '#url.student#'
							ORDER BY e.invoiceid
						</cfquery>
						<cfset balance = 0>
						<tr><td colspan=4><em>Details of Student Charges:</em></td></tr>
						<tr>
							<table border="0" cellpadding="3" cellspacing="0" width="100%">
								<tr><td colspan=5>Student: <strong>#charges.firstname# #charges.familylastname#  (###charges.studentid#)</strong></td></tr>
								<tr>
									<td><b>Date</b></td>
									<td><b>Invoice</b></td>
									<td><b>Description</b></td>
									<td><b>Amount</b></td>
									<td><b>Received</b></td>
									<td><b>Running Total</b></td>
								</tr>
								<cfloop query="charges">
										<cfquery name="check_partial" datasource="mysql">
											SELECT sum(amount_paid) as amount_paid 
											FROM egom_payment_charges
											WHERE chargeid = #chargeid#
										</cfquery>
										<cfif check_partial.amount_paid is ''>
											<cfset check_partial.amount_paid = 0>
										</cfif>
								<tr <cfif charges.currentrow mod 2>bgcolor="##F5F5F5"</cfif>>	
									<td>#LSDateFormat(date, 'mm/dd/yyyy')#</td>
									<td><a href="javascript:OpenInvoice('invoice/view_invoice.cfm?i=#uniqueid#')">###invoiceid#</a></td>
									<td>#description#</td>
									<td><cfif canceled EQ '1'><span class="strike"></cfif>#LSCurrencyFormat(amount,'local')#</td>
									<td>#LSCurrencyFormat(check_partial.amount_paid,'local')#</td>
									<td><cfif full_paid NEQ 1 AND canceled NEQ '1'> <cfset balance = balance + amount - check_partial.amount_paid></cfif>#LSCurrencyFormat(balance,'local')#</td>
								</tr>	
								</cfloop>
								<tr>
									<td colspan=5 align="center"><strong>Total Due: #LSCurrencyFormat(balance,'local')#</strong></td>
								</tr>
							</table>
						</tr>
					</CFIF>
					</tr>
				</Cfif>
			</table>
			</form>

			<cfif isDefined('url.student') OR isDefined('url.invoice')>
				<cfform name="payment" action="invoice/qr_record_payment.cfm" method="post">
				<cfinput type="hidden" name="intrep" value="#intrep#"/>
				<cfinput type="hidden" name="memo" value=''/>
				<cfif IsDefined('url.student')>
					<cfinput type="hidden" name="student" value="#url.student#">
				</cfif>
				<cfif IsDefined('url.invoice')>
					<cfinput type="hidden" name="invoice" value="#url.invoice#">
				</cfif>	
				<table width="95%" class="box" bgcolor="##ffffff" align="center" cellpadding="3" cellspacing="0">
					<tr>
						<td>
							<table border="0" cellpadding="3" cellspacing="0" width="100%">
								<tr><th colspan="6" bgcolor="##C2D1EF">Payment Details</th></tr>
								<tr>
									<td>Payment Method:</td>
									<td>
										<cfquery name="payment_methods" datasource="mysql">
											SELECT *
											FROM egom_payment_type
                                            ORDER BY 
                                            	paymentType DESC			
										</cfquery>
										<select name="payment_method">
										<cfloop query="payment_methods">
										<option value="#paymenttypeid#">#paymenttype#</option>
										</cfloop>
										</select>
									</td>
									<td>Reference:</td>
									<td><cfinput type="text" name="ref" message="You must suplly a reference number. Please use check or wire transfer confermation number." validateat="onSubmit" required="yes" size=10></td>
									<td>Amount:</td>
									<td><cfinput type="text" name="payment_amount" size=10 value="#balance#"></td>
								</tr>
								<tr>
									<td>Date Received:</td><td><input type="text" name="date_received" value="" class="date-pick"/></td>
									<td>Date Applied:</td><td>#DateFormat(now(),'mm/dd/yy')# </td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
					<td colspan=6>
				
				<table width="100%" bgcolor="##ffffff" align="center" cellpadding="3" cellspacing="0">
					<tr><th colspan="6" bgcolor="##C2D1EF">If this is a partial payment, please indicate which charges it should be applied to.</th></tr>
					<tr>
						<td></td>
						<td>Invoice</td>
						<td>Description</td>
						<td>Amount Billed</td>
						<Td>Amount Received</Td>
						<td>Amount Due</td>
					</tr>
					<Tr>
						<cfloop query="charges">
							<cfquery name="check_partial" datasource="mysql">
								SELECT sum(amount_paid) as amount_paid 
								FROM egom_payment_charges
								WHERE chargeid = #chargeid#
							</cfquery>
							<cfif check_partial.amount_paid is ''>
								<cfset check_partial.amount_paid = 0>
							</cfif>
							<tr <cfif charges.currentrow mod 2>bgcolor="##F5F5F5"</cfif>>	
								<td><cfif full_paid NEQ 1 AND canceled NEQ 1><input type="hidden" value="#chargeid#" name="chargeid"/></cfif></td>
								<td>###invoiceid#</td>
								<td>#description#</td>
								<td><cfif canceled EQ '1'><span class="strike"></cfif>#LSCurrencyFormat(amount,'local')#</td>
								<td>#LSCurrencyFormat(check_partial.amount_paid,'local')#</td>
								<td><cfif full_paid NEQ 1 AND canceled NEQ 1>
										<cfset balance_due = #amount# - #check_partial.amount_paid#>
										<cfinput type="text" name="amount_#chargeid#" value="#balance_due#" size=8 onchange="CalculateTotal()">										
									<cfelse>
										$0.00
									</cfif>
								</td>
							</tr>	
						</cfloop>
				</table>
			</td>
			</table><br />
			<div align="center"><cfinput name="submit" type="submit" value="Process Payment" onClick="CalculateTotal()" submitOnce/></div>
			</cfform>
			</cfif>
			</td>
		</td>
	</tr>
</table>

</cfoutput>
</body>
</html>