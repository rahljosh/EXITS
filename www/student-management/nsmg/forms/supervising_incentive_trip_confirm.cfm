<Cfquery name="rep_info" datasource="MySQL">
	select firstname, lastname, userid
	from smg_users
	where 
	userid =  <cfqueryparam  value="#url.user#"cfsqltype="cf_sql_integer">
</Cfquery>

<Cfquery name="payment_details" datasource="MySQL">
	select *
	from smg_rep_payments
	INNER JOIN smg_payment_types ON smg_rep_payments.paymenttype = smg_payment_types.id 
	where smg_rep_payments.id = <cfqueryparam value="#url.payment#" cfsqltype="cf_sql_integer">
</Cfquery>

<cfoutput>
<h2>Representitive: #rep_info.firstname# #rep_info.lastname# (#rep_info.userid#)&nbsp; <span class="get_attention"><b>::</b></span>
<a href="" onClick="javascript: win=window.open('forms/supervising_history.cfm?userid=#rep_info.userid#', 'Settings', 'height=300, width=650, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Payment History</a></h2>

<Br>Below is a summary of the payment recorded.<br>
<table width=90% cellpadding=4 cellspacing=0>
	<tr>
		<td bgcolor="010066" colspan=5><font color="white"><strong>Placed Students</strong></font></td>
	</tr>
	<tr bgcolor="CCCCCC">
		<Td >Payment ID</Td><td>Type</td><td>Amount</td><td>Comment</td>
	</tr>
	<tr>
		<td width="10%">#payment_details.id#</td>
		<Td width="20%">#payment_details.type#</Td>  
		<td width="10%">#LSCurrencyFormat(payment_details.amount, 'local')#</td>
		<td width="60%">#payment_details.comment#</td>
	</tr>
</table>
</form>
<br><div align="center"><a href="?curdoc=forms/supervising_placement_payments"><img src="pics/newpayment.gif" border="0" align="bottom"></a></div>
</cfoutput>