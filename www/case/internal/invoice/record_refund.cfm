<cfloop list=#form.credit_to_refund# index=i>

	<cfquery name="get_bal" datasource="caseusa">
	select amount, amount_applied
	from smg_credit
	where creditid = #i#
	</cfquery>
	<cfset balance = #get_bal.amount# - #get_bal.amount_applied#>
	<cfquery name="insert_refund" datasource="caseusa">
	insert into smg_invoice_refunds (agentid, companyid, date,creditid, amount)
						values (#url.userid#, #client.companyid#, #CreateODBCDate(now())#,#i#,#balance#)
	</cfquery>
	
	<cfquery name="set_credit_zero" datasource="caseusa">
	update smg_credit
		set active = 0
		where creditid = #i#
	</cfquery>

</cfloop>


<body onload="opener.location.reload()"> 
<h2>Refund item has been succesfully recorded.</h2>

<br><br>
<input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()">