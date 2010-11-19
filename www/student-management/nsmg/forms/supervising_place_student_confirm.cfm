<style type="text/css"> 
<!-- A:link { text-decoration: none; color:#YourColor 
} A:visited { text-decoration: none; color:white } A:hover { text-decoration: 
none; color:gray } -->
</style>

<cfoutput>

<cfquery name="payment_type" datasource="MySQL">
	select type, id
	from smg_payment_types
	WHERE active = '1'
</cfquery>

<cfquery name="get_student_info" datasource="MySql">
	SELECT s.studentid, s.firstname, s.familylastname
	FROM smg_students s
	WHERE s.studentid = <cfqueryparam value="#url.studentid#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="place_payment" datasource="MySql">
	SELECT u.firstname, u.lastname, u.userid,
	s.studentid, s.firstname as stufirstname, s.familylastname,
	p.amount, p.comment, p.id,
	t.type
	FROM smg_rep_payments p
	INNER JOIN smg_users u ON p.agentid = u.userid
	INNER JOIN smg_students s ON s.studentid = p.studentid
	INNER JOIN smg_payment_types t ON t.id = p.paymenttype
	WHERE p.id = <cfqueryparam value="#url.p_payment#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="super_payment" datasource="MySql"> 
	SELECT u.firstname, u.lastname, u.userid,
	s.studentid, s.firstname as stufirstname, s.familylastname,
	p.amount, p.comment, p.id,
	t.type
	FROM smg_rep_payments p
	INNER JOIN smg_users u ON p.agentid = u.userid
	INNER JOIN smg_students s ON s.studentid = p.studentid
	INNER JOIN smg_payment_types t ON t.id = p.paymenttype
	WHERE p.id = <cfqueryparam value="#url.s_payment#" cfsqltype="cf_sql_integer">
</cfquery>

<h2>Student: #get_student_info.firstname# #get_student_info.familylastname# (#url.studentid#)</h2>
<Br>Below is a summary of the payments recorded.<br>

<table width=90% cellpadding=4 cellspacing=0>
	<tr>
		<td bgcolor="010066" colspan=5><font color="white"><strong>Supervised by &nbsp; #super_payment.firstname# #super_payment.lastname# (#super_payment.userid#)  &nbsp; <span class="get_attention"><b>::</b></span>
				<a href="" onClick="javascript: win=window.open('forms/supervising_history.cfm?userid=#super_payment.userid#', 'Settings', 'height=300, width=650, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Payment History</a></strong></font></td>
	</tr>	
	<tr bgcolor="CCCCCC">
		<Td>ID</Td><td>Student</td><td>Type</td><td>Amount</td><td>Comment</td>
	</tr>
	<Cfif super_payment.recordcount is '0'>
	<tr>
		<td colspan=5 align="center">No supervision payments submitted.</td>
	</tr>
	<cfelse>
	<tr>
		<Td>#super_payment.id#</Td><td>#super_payment.stufirstname# #super_payment.familylastname# (#super_payment.studentid#)</td>
		<Td>#super_payment.type#</Td>  
		<td>#LSCurrencyFormat(super_payment.amount, 'local')#</td>
		<td>#super_payment.comment#</td>
	</tr>
	</cfif>
	
	<tr><td>&nbsp;</td></tr>	
	
	<tr>
		<td bgcolor="010066" colspan=5><font color="white"><strong>Placed by &nbsp; #place_payment.firstname# #place_payment.lastname# (#place_payment.userid#) &nbsp; <span class="get_attention"><b>::</b></span>
				<a href="" onClick="javascript: win=window.open('forms/supervising_history.cfm?userid=#place_payment.userid#', 'Settings', 'height=300, width=650, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Payment History</a></strong></font></td>
	</tr>
	<tr bgcolor="CCCCCC">
		<Td>ID</Td><td>Student</td><td>Type</td><td>Amount</td><td>Comment</td>
	</tr>
	<Cfif place_payment.recordcount is '0'>
	<tr>
		<td colspan=5 align="center">No placement payments submitted.</td>
	</tr>
	<cfelse>
	<tr>
		<Td>#place_payment.id#</Td><td>#place_payment.stufirstname# #place_payment.familylastname# (#place_payment.studentid#)</td>
		<Td>#place_payment.type#</Td>  
		<td>#LSCurrencyFormat(place_payment.amount, 'local')#</td>
		<td>#place_payment.comment#</td>
	</tr>
	</cfif>
</table>

<br><div align="center"><a href="?curdoc=forms/supervising_placement_payments"><img src="pics/newpayment.gif" border="0" align="bottom"></a></div>
</cfoutput>