<cfloop list=#form.credit_to_refund# index=i>

	<cfquery name="get_bal" datasource="MySQL">
	select creditid, description, amount, amount_applied
	from smg_credit
	where id = #i#
	</cfquery>
	<cfset balance = #get_bal.amount# - #get_bal.amount_applied#>
	<cfquery name="insert_refund" datasource="MySQL">
	insert into smg_invoice_refunds (agentid, companyid, date,creditid, amount, reason)
						values (#url.userid#, #client.companyid#, #CreateODBCDate(now())#,#i#,#balance#, '#get_bal.description#')
	</cfquery>
	
	<cfquery name="set_credit_zero" datasource="MySQL">
	update smg_credit
		set active = 0
		where id = #i#
	</cfquery>

</cfloop>


<body onLoad="opener.location.reload()"> 
<h2>Refund item has been succesfully recorded.</h2>

<br><br>
<input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()">