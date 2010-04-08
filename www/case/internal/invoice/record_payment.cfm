<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="check_rights.cfm">

<cfif not isDefined('form.charge_apply')>
<link rel="stylesheet" href="../../smg.css" type="text/css">
<head>
<title>Receive Payments</title>
<div class="application_section_header">Receive Payment</div><br>
</head>
<cfoutput>
You did not specify which items to apply this partial payment to.<br><Br>
Please click 'back' and make sure:<br>
you have checked each line to apply charges to<br>

<div class="button"><input name="back" type="image" src="../pics/back.gif" align="right" border=0 onClick="history.back()"></div>
</cfoutput>
<cfabort>
</cfif>


<cfif form.diff gte 0>
<cfset total_apply = 0>
<cfloop list=#form.charge_apply# index=x>
<Cfset total_apply = #total_apply# + #Evaluate("FORM." & x & "_apply")#>
</cfloop>
	<!----Display Error---->
	<cfif total_apply is not #form.amount_received#>
		<link rel="stylesheet" href="../../smg.css" type="text/css">
	<head>
	<title>Receive Payments</title>
	<div class="application_section_header">Receive Payment</div><br>
	</head>
		<cfoutput>
		The total amount you are applying: #LSCurrencyFormat(total_apply,'local')# does not equal the amount received: #LSCurrencyFormat(form.amount_received,'local')#<br><br>
		Please click 'back' and make sure:<br>
		the amounts entered add up to the amount received<br><br>
		<div class="button"><input name="back" type="image" src="../pics/back.gif" align="right" border=0 onClick="history.back()"></div>
		</cfoutput>
		<cfabort>
		</cfif>
	</cfif>

 

<cftransaction action="begin" isolation="serializable">

<cfquery name="payment_Details" datasource="caseusa">
insert into smg_payment_received (date, date_applied, paymentref, paymenttype, totalreceived, agentid, companyid)
				values(#CreateODBCDate(form.transdate)#, #CreateODBCDate(now())#, '#form.pay_ref#', '#form.payment_type#', #form.amount_received#, #form.agent#, #client.companyid#)
</cfquery>
<cfquery name="paymentid" datasource="caseusa">
select max(paymentid) as payid from smg_payment_received
</cfquery>


<cfloop list=#form.charge_apply# index=x>
<cfquery name="apply_charges" datasource="caseusa">
insert into smg_payment_charges (paymentid, chargeid, amountapplied)
				values(#paymentid.payid#, #x#, #Evaluate("FORM." & x & "_apply")#)
</cfquery>
</cfloop>


<cfif isDefined('form.credit')>

<Cfset credit_amount = #form.credit# * -1>
<cfquery name="add_credit" datasource="caseusa">
insert into smg_credit(agentid, invoiceid, description, type, amount, date, companyid, payref)
			values   (#form.agent#, #form.invoice#, 'Overpayment of invoice #form.invoice#', 'credit', #credit_amount#, #now()#, #client.companyid#, '#form.pay_ref#')
</cfquery>
</cfif>

<cfif isDefined('form.apply_credit_id')>

<cfquery name="get_bal" datasource="caseusa">
select amount_applied, amount from smg_credit
where creditid = #apply_credit_id#
</cfquery>
<cfset new_amount_received = #get_bal.amount_applied# + #form.amount_received#>
<cfquery name="update_amount_applied" datasource="caseusa">
update smg_credit
set amount_applied = #new_amount_received#
where creditid = #apply_credit_id#
</cfquery>

<cfif get_bal.amount eq #new_amount_received#>
<cfquery name="deactivate_credit" datasource="caseusa">
update smg_credit
set active = 0
where creditid = #form.apply_credit_id#
</cfquery>
</cfif>
</cfif>

<!-----Amount Paid Equals Amount Due---->
<!----
<cfif form.diff is 0>
<cfquery name="get_chargeid_for_invoice" datasource="caseusa">
select chargeid, amount_due
from smg_charges
where invoiceid = #form.invoice#
</cfquery>
<cfquery name="paymentid" datasource="caseusa">
select max(paymentid) as payid from smg_payment_received
</cfquery>
<cfloop query=get_chargeid_for_invoice>
<cfquery name="paycharge" datasource="caseusa">
insert into smg_payment_charges (paymentid, chargeid, amountapplied)
					values(#paymentid.payid#, #chargeid#,#amount_due#)

</cfquery>
</cfloop>


</cfif>
---->


</cftransaction>
<!----
<cfquery name="get_unpaid_charges" datasource="caseusa">
		select smg_charges.chargeid, smg_payment_charges.chargeid, smg_payment_charges.amountapplied, smg_payment_charges.paymentid
		from smg_charges left outer join smg_payment_charges on (smg_charges.chargeid = smg_payment_charges.chargeid)
		where smg_charges.invoiceid = #form.invoice#
</cfquery>
<cfoutput query="get_unpaid_charges">
#chargeid#
</cfoutput>
---->
<cflocation url="payment_message.cfm" addtoken="yes">
