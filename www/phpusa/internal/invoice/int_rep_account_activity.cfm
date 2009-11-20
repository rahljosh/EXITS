<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<style type="text/css">
.thin-border-bottom{  border-bottom: 1px solid #000000;}
</style>
<Cfquery name="get_intl_rep" datasource="MySQL">
	SELECT userid, businessname
	FROM smg_users
	WHERE usertype = '8'
		AND active = '1'
		<cfif client.usertype GT '4'>
			AND userid = <cfqueryparam value="#client.userid#" cfsqltype="cf_sql_integer">
		</cfif>
	ORDER BY businessname
</Cfquery>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>All account activity for #businessname#</title>
</head>

<body>
<cfoutput>
<div align="center">
<h2>Account History</h2>
<div align="left">Limit view to: All Transactions |  Only Invoiced | Only Payments | Only Credits & Cancelations <br />
    <br />
  Below is a list of indicated transactions recorded as of #DateFormat(now(), 'mmm d, yyyy')# at #TimeFormat(now(), 'h:mm:ss tt')# MST
  <br />
</div></div>
<cfquery name="payments" datasource="mySQL">
select *
from egom_payments
where intrepid = #client.userid#
</cfquery>

<Table width=80% align="center" border=0>
<tr class="thin-border-bottom">
			<td><strong>Date</strong></td><td><strong>Invoiced</strong></td><td><strong>Payments</strong></td><td><strong>Credits & <br /> Cancelations</strong></td><td><strong>Running <br /> Balance</strong></td></tr>
		</tr>

	<cfloop query="payments">

	<tr>
		<td>#DateFormat(date_applied, 'mmm d, yyyy')# #TimeFormat(date_applied, 'h:mm:ss tt')#</td><td>invoiced</td><td>#LSCurrencyFormat(total_amount)#</td><td>credits</td><td>Balance</td>
	</tr>
	</cfloop>

</Table>

</cfoutput>
</body>
</html>
