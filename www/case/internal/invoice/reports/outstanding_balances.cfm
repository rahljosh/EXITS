<!--- CHECK INVOICE RIGHTS ---->
<!----
<cfinclude template="../check_rights.cfm">
---->
<cfsetting requestTimeOut = "1000">

<cfif not isDefined('form.beg_date')>
	<cfset form.beg_date = '09/01/2008'>
</cfif>
<cfif not isDefined('form.end_date')>
	<cfset form.end_date = #DateFormat(now(), 'mm/dd/yyyy')#>
</cfif>

<cfoutput>
<div align="center"><h2>Outstanding balances as of #DateFormat(now(), 'mm-dd-yyyy')# at #TimeFormat(now(),'h:mm:ss tt')#<br></h2></div>

<cfquery name="get_int_Reps" datasource="caseusa">
select smg_users.userid, smg_users.firstname, smg_users.lastname, smg_users.businessname, smg_users.userid
from smg_users
where usertype = 8 
order by businessname
</cfquery>

Current Date Range: #form.beg_date# thru #form.end_date#
<cfform method="post" action="outstanding_balances.cfm">
<cfoutput>
Date Range to include: <input type="text" value='#form.beg_date#' name=beg_date> thru <input type="text" name="end_date" value=#form.end_date#> *defaults to include all dates in system.
</cfoutput>
<br>
<input type="submit" name="Update Dates">
</cfform>
<table width=100% cellpadding=4 cellspacing=0>
	<tr>
		<td width=30>Agent</td><td>CASE</td><TD>Total</TD>
	</tr>
<cfloop query="get_int_reps">
	<!----ISE Numbers---->			
			<!----sum of amount due---->
			<Cfquery name="total_Due_ise" datasource="caseusa">
			select sum(amount_due) as amount_due
			from smg_charges
			where companyid = 10
			and (date between #CreateODBCDateTime(form.beg_Date)# and #CreateODBCDateTime(form.end_date)#)
			and agentid = #userid#
			</Cfquery>
			<cfif total_due_ise.amount_due is ''>
			<cfset total_Due_ise.amount_due = 0>
			</cfif>
			<!----sum of received payments---->
			<cfquery name="received_payments_ise" datasource="caseusa">
			select sum(totalreceived) as amount_paid
			from smg_payment_received
			where companyid = 10
			and (date_applied between #CreateODBCDateTime(form.beg_Date)# and #CreateODBCDateTime(form.end_date)#)
			and agentid = #userid#
			</cfquery>
			<cfif received_payments_ise.amount_paid is ''>
			<cfset received_payments_ise.amount_paid = 0>
			</cfif>
			<!----Sum of credits---->
			<cfquery name="sum_credits_ise" datasource="caseusa">
			SELECT sum(amount) AS credit_amount, sum(amount_applied) AS credit_applied, sum(amount)-sum(amount_applied) AS totalcredit
			from smg_credit
			where companyid = 10
			and agentid = #userid# and active = 1
			and (date between #CreateODBCDateTime(form.beg_Date)# and #CreateODBCDateTime(form.end_date)#)
			</cfquery>
			<cfif sum_credits_ise.totalcredit is ''>
			<cfset sum_credits_ise.totalcredit = 0>
			</cfif>
			
			
			<!----Sum of Overpayment Credits---->
			<cfquery name="overpayment_credit_ise" datasource="caseusa">
			select sum(amount) as overpayment_amount
			from smg_credit
			where agentid = #userid# and payref <> '' and active = 0
			and companyid = 10
			and (date between #CreateODBCDateTime(form.beg_Date)# and #CreateODBCDateTime(form.end_date)#)
			</cfquery>
			<cfif overpayment_credit_ise.overpayment_amount is ''>
			<cfset overpayment_credit_ise.overpayment_amount = 0>
			</cfif>


			<cfset ise_bal = #total_Due_ise.amount_due# - #received_payments_ise.amount_paid# - #sum_credits_ise.totalcredit# + #overpayment_credit_ise.overpayment_amount#>


						
			
			
			<Cfset agent_total_bal =  #ise_bal#>
<tr <cfif get_int_reps.currentrow mod 2>bgcolor='cccccc'</cfif> >
	<td ><a href="?curdoc=invoice/user_account_details&userid=#userid#">#businessname#</a></td><td>#LSCurrencyFormat(ise_bal, 'local')#</td><td>#LSCurrencyFormat(agent_total_bal, 'local')#</td>
</tr>


</cfloop>
<!----Grand Totals Due---->
	<!----ISE Numbers---->			
			<!----sum of amount due---->
			<Cfquery name="gtotal_Due_ise" datasource="caseusa">
			select sum(amount_due) as amount_due
			from smg_charges
			where companyid = 10
			and (date between #CreateODBCDateTime(form.beg_Date)# and #CreateODBCDateTime(form.end_date)#)
			</Cfquery>
			<cfif gtotal_due_ise.amount_due is ''>
			<cfset gtotal_Due_ise.amount_due = 0>
			</cfif>
			<!----sum of received payments---->
			<cfquery name="greceived_payments_ise" datasource="caseusa">
			select sum(totalreceived) as amount_paid
			from smg_payment_received
			where companyid = 10
			and (date_applied between #CreateODBCDateTime(form.beg_Date)# and #CreateODBCDateTime(form.end_date)#)
			</cfquery>
			<cfif greceived_payments_ise.amount_paid is ''>
			<cfset greceived_payments_ise.amount_paid = 0>
			</cfif>
			<!----Sum of credits---->
			<cfquery name="gsum_credits_ise" datasource="caseusa">
			select sum(amount) as credit_amount
			from smg_credit
			where companyid = 10 and active = 1
			and (date between #CreateODBCDateTime(form.beg_Date)# and #CreateODBCDateTime(form.end_date)#)
			</cfquery>
			<cfif gsum_credits_ise.credit_amount is ''>
			<cfset gsum_credits_ise.credit_amount = 0>
			</cfif>
			
			<!----Sum of Overpayments---->
			<cfquery name="goverpayment_credit_ise" datasource="caseusa">
			select sum(amount) as overpayment_amount
			from smg_credit
			where payref <> '' and active = 0
			and companyid = 10
			and (date between #CreateODBCDateTime(form.beg_Date)# and #CreateODBCDateTime(form.end_date)#)
			</cfquery>
			<cfif goverpayment_credit_ise.overpayment_amount is ''>
			<cfset goverpayment_credit_ise.overpayment_amount = 0>
			</cfif>
			
			<cfset gise_bal = #gtotal_Due_ise.amount_due# - #greceived_payments_ise.amount_paid# - #gsum_credits_ise.credit_amount# + #goverpayment_credit_ise.overpayment_amount#>

			
			
			<Cfset gagent_total_bal = #gise_bal# >
	<tr> 
		<td>Totals Due</td><td>#LSCurrencyFormat(gise_bal, 'local')#</td>
</tr>
</table>
</cfoutput>