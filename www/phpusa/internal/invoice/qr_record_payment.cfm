<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Untitled Document</title>
</head>

<body>
<cfif form.credits neq 0>


<Cfquery name="credit_amount" datasource="#application.dsn#">
select *
from egom_credits
where origPayId = '#form.credits#'

</Cfquery>

</cfif>

<cftransaction action="begin" isolation="serializable"> 

<!--- CHECK CHARGES ---->
<cfset totalcharges = 0>
<cfloop list="#form.chargeid#" index="x">
	<cfif #Evaluate("FORM.amount_" & x)# GT 0>
		<cfset totalcharges = totalcharges + 1>
	</cfif>
</cfloop>

<!--- INCLUDE PAYMENT --->


<!----If paying with a credit, we don't want to add a new pay ref, since we will just be referencing the initial pay ref passed in via the credit---->
<cfif form.credits eq 0>
	<cfif totalcharges GT 0>
        <cfquery name="payment_Details" datasource="#application.dsn#">
            INSERT INTO egom_payments 
                (date_received, date_applied, transaction, paymenttypeid, userid, intrepid, total_amount, description, companyid)
            VALUES 
                (#CreateODBCDate(form.date_received)#, #CreateODBCDateTime(now())#, '#form.ref#', '#form.payment_method#', #client.userid#, #form.intrep#, '#form.payment_amount#', '#form.memo#', #client.companyid#)
        </cfquery>
        <cfquery name="paymentid" datasource="#application.dsn#">
            SELECT max(paymentid) as payid 
            FROM egom_payments
        </cfquery>
    </cfif>
<cfelse>
	<cfset paymentid.payid = #form.credits#>
</cfif> 

<Cfset rem_credit = 0>
<!--- INCLUDE CHARGES --->
<cfloop list="#form.chargeid#" index="x">
	<cfif #Evaluate("FORM.amount_" & x)# GT 0>
		<cfquery name="apply_charges" datasource="MySQL">
			INSERT INTO 
				egom_payment_charges (paymentid, chargeid, amount_paid)
			VALUES 
				(#paymentid.payid#, #x#, #Evaluate("FORM.amount_" & x)#)
		</cfquery>
	</cfif>
	<cfquery name="check_full_payment_due" datasource="mysql">
		SELECT sum(amount) as amount_charged 
		FROM egom_charges
		WHERE chargeid = '#x#'
	</cfquery>
	<cfquery name="check_full_payment_paid" datasource="mysql">
		SELECT sum(amount_paid) as amount_paid 
		FROM egom_payment_charges
		WHERE chargeid = '#x#'
	</cfquery>
	<cfif check_full_payment_due.amount_charged EQ check_full_payment_paid.amount_paid>
		<cfquery name="mark_paid" datasource="mysql">
			UPDATE egom_charges
			SET full_paid = 1
			WHERE chargeid = '#x#'
		</cfquery>
     <cfelseif check_full_payment_due.amount_charged LT check_full_payment_paid.amount_paid>
     	<cfquery name="mark_paid" datasource="mysql">
			UPDATE egom_charges
			SET full_paid = 1
			WHERE chargeid = '#x#'
		</cfquery>
   </cfif>

</cfloop>
</cftransaction>

<Cfoutput>

</Cfoutput>
<cfif form.credits neq 0>

<cfset final_remaining_credit = #credit_amount.amount# - #form.payment_amount#>

<cfif final_remaining_credit eq 0>
	<cfquery datasource="#application.dsn#">
    delete
    from egom_credits 
    where origPayID = '#form.credits#' 
   
    </cfquery>
<cfelse>
	<cfquery datasource="#application.dsn#">
    update egom_credits set amount = '#final_remaining_credit#'
    where origPayID = '#form.credits#' 
    
    </cfquery>
</cfif>
</cfif>

<cfoutput>

<html>
<head>
<script language="JavaScript">
<!-- 
alert("You have successfully received this payment.");
<cfif IsDefined('form.student')>
	location.replace("../index.cfm?curdoc=invoice/receive_payment&intrep=#form.intrep#&student=#form.student#");
<cfelseif IsDefined('form.invoice')>
	location.replace("../index.cfm?curdoc=invoice/receive_payment&intrep=#form.intrep#&invoice=#form.invoice#");
</cfif>
-->
</script>
</head>
</html> 		

</cfoutput>

</body>
</html>