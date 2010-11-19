<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="check_rights.cfm">

<link rel="stylesheet" href="../../smg.css" type="text/css">
<head>
<title>Receive Payments</title>
<div class="application_section_header">Receive Payment</div><br>
</head>
<table width=100% cellpadding =4 cellspacing =0>
	<tr bgcolor="#FFFFCC">
		<td><b><span class="edit_link">Enter Payment Info</b></td><td><span class="edit_link">Apply Payment to...</span></td><td   bgcolor="#FF8080"><span class="edit_link">Over / Under Payment</td><td><span class="edit_link">Finalize</td>
	</tr>

</table>
<cfform method="post" action="record_payment.cfm">
<cfoutput>
<input type="hidden" name="agent" value=#form.agent#>
<input type="hidden" name="payment_type" value='#form.payment_method#'>
<cfif form.payment_method is 'apply credit'>
<cfset form.amount_received = #form.amount_applied#>
<input type="hidden" name="amount_received" value=#form.amount_applied#>
<input type="hidden" name="orig_credit_amount" value=#form.orig_credit_amount#>
<cfelse>
<input type="hidden" name="amount_received" value=#form.amount_received#>
</cfif>
<input type="hidden" name="pay_ref" value='#form.pay_ref#'>
<input type="hidden" name="invoice" value=#form.invoice#>
<cfif form.payment_method is 'apply credit'>
<input type="hidden" name="apply_credit_id" value=#form.apply_credit_id#>

</cfif>
<cfif form.invoice is not ''>
<!----Retrieve total amount due on Invoice---->
<cfquery name="invoice_details" datasource="mysql">
select sum(amount_due) as due from smg_charges where invoiceid = #form.invoice#
</cfquery>

<!----Retrieve total amount already paid on this invoice---->
<cfquery name="charges_paid" datasource="MySQL">
select smg_charges.chargeid, smg_payment_charges.chargeid, smg_payment_charges.amountapplied, smg_payment_charges.paymentid
from smg_charges right join smg_payment_charges on (smg_charges.chargeid = smg_payment_charges.chargeid)
where smg_charges.invoiceid = #form.invoice#
</cfquery>
<cfset paid_amount =0>
<cfloop query="charges_paid">
<cfset paid_amount = #paid_amount# + #charges_paid.amountapplied#> 
</cfloop>

The following is a summary of the transaction that will post when you click approve.<br>

<table>
	<Tr>
		<td>Agent:</td><td>#form.agent#</td>
	</Tr>
	<tr>
		<td>Invoice:</td><td>#form.invoice#</td>
	</tr>
	<tr>
		<Td>Payment Method / Ammount:</Td><td>#form.payment_method# / #LSCurrencyFormat(form.amount_received,'local')#</td>
	</tr>
	
	<Tr>
		<td>Date Received:</td>
		<!---If Wire Transfer, allow date to be entered, otherwise record as recived today---->
		<Td>
		<cfif form.payment_method is 'wire transfer'><cfinput type="text" name='transdate' size=12 required="yes" message="Please enter the transaction date."> mm/dd/yyyy or mm-dd-yyyy<cfelse><input type="hidden" name=transdate value='#DateFormat(now(), 'mm/dd/yyyy')#'></cfif> #DateFormat(now(), 'mm/dd/yyyy')#</Td>
	</Tr>
	<tr>
		<td colspan=2><hr width=30%></td>
	</tr>
	
	<tr>
		<td>Original Invoice Amount Due:</td><Td>#LSCurrencyFormat(invoice_details.due, 'local')#</Td>
	</tr>
	<tr>
		<td>Previous Payments Received:</td><Td><u>#LSCurrencyFormat(paid_amount, 'local')#</u></Td>
	</tr>

	<tr>
		<td>Current Balance Due:</td><td><cfset current_balance = #invoice_details.due# - #paid_amount#>#LSCurrencyFormat(current_balance, 'local')#</td>
	</tr>
	<tr>
		<td>Payment Received:</td><Td>#LSCurrencyFormat(form.amount_received,'local')#</Td>
	</tr>
	<tr>
		<td>New Balance Due:</td><Td> <cfset diff =  #invoice_details.due# - #paid_amount# - #form.amount_received#>#diff#<input type="hidden" name="diff" value=#diff#></Td>
	</tr>

</table>
<br>




 <br>
		
		  
				 <cfif diff is 0>
				Charges to be paid are indicated below indicates how the charges will be applied.  Please verify that this is correct before clicking approve.
				 <cfelseif diff gt 0>
				 This is a partial payment.  Amounts have been estimated, please double check the amounts and check/uncheck boxes as appropirate to apply the charges to the correct student. 
				 Do NOT apply more then the max amount for each item. For items that were overpaid, please credit the remaining balance as a credit.<br>
				 <cfelseif diff lt 0>
				  The amount paid is greater than the amount due for this invoice.  The difference #LSCurrencyFormat(diff,'local')# <cfabort> <!--- will show up as a credit on the agents account that you can apply to another payment by
				 clicking on Receive Payment and selecting Account Credit from the payment method. --->  
				 <input type="hidden" name="credit" value=#diff#>
				 </cfif>
				 <br><br>
		<cfquery name="open_charges" datasource="MySQL">
        select s.*, sp.type AS progType
        from smg_charges s
        LEFT JOIN smg_programs sp ON sp.programid = s.programid
        where invoiceid = #invoice#
        </cfquery>
        
		<table>
			<tr>
				<td></td><td>Due</td><td>Paid</td><td>Apply</td><td>Max Apply</td><td>Student</td><td>Type</td><td>Description</td>
			</tr>
			<!----Retreive charges for invoice---->
			<cfloop query="open_charges">
			<cfquery name="charge_details" datasource="mysql">
			select * from smg_charges
			where chargeid = #chargeid#            
			</cfquery>
			<!----Check if money has been applied for this charge---->
			<cfquery name="check_if_paid" datasource="MySQL">
			select *
			from smg_payment_charges
			where chargeid = #chargeid#
			</cfquery>
				<cfset charge_amount_paid = 0>
				<cfloop query="check_if_paid">
				<Cfset paid_charge_id = #chargeid#>
				<cfset charge_amount_paid = #charge_amount_paid# + #amountapplied#>
				</cfloop>
                
			<cfswitch expression="#progType#">
            	<cfcase value="7,8,9,11,22,23"><!--- work programs --->            
                    <cfquery name="student_name" datasource="mysql">
                    SELECT firstname, lastname AS familylastname
                    FROM extra_candidates
                    WHERE candidateid = #charge_details.stuid#
                    </cfquery>
                </cfcase>
				<cfdefaultcase>
                    <cfquery name="student_name" datasource="mysql">
                    SELECT firstname, familylastname
                    FROM smg_students
                    WHERE studentid = #charge_details.stuid#
                    </cfquery>
               	</cfdefaultcase>
			</cfswitch>
            
			<cfset line_balance = #charge_details.amount_due# - #charge_amount_paid#>
			<tr>
				<td><input name=charge_apply type="checkbox" value=#chargeid# <cfif charge_amount_paid gte #charge_details.amount_due#>disabled="true"</Cfif><cfif charge_amount_paid is 0 and diff lte 0>checked</Cfif>></td><td>#charge_details.amount_due# </td><td>#charge_amount_paid#</td><td><cfif charge_amount_paid gte #charge_details.amount_due#><font size="-2">paid in full</font><cfelse><input type="text"  size=5 name=#chargeid#_apply value=#line_balance#> </Cfif></td><td>#line_balance#</td><td>#student_name.firstname# #student_name.familylastname#</td><td>#charge_details.type#</td><td>#charge_details.description#</td>
			</tr>
			<Cfset paid_charge_id = 0>
				<cfset charge_amount_paid = 0>
			</cfloop>
		</table>
	
 

</cfif>
<Br><br>
</cfoutput>
You must click 'approve' to finalize this transaction.
<div class="button"><input name="back" type="image" src="../pics/approve.gif" align="right" border=0></div>



</cfform>