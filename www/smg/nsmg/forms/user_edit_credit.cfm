
<title>Credit Details</title>
<cfquery name="account_credit" datasource="mysql">
select account_credit 
from smg_users
where userid = #url.userid#
</cfquery>
<div id="information_window">
<span class="application_section_header">Account Credit</span> <br>
<cfoutput query="account_credit">
<form method="post" action="querys/user_change_account_credit.cfm?userid=#url.userid#"

<table align="Center" border=0>
	<tr>
		<td colspan=3 align="center" bgcolor="005B01"><font color="white">Manually Change Account Balance</font></td>
	</tr>
	<tr>
		<td>Current Account Credit: </td><td colspan=2>#LSCurrencyFormat(account_credit, 'local')#</td><td></td>
	</tr>
	<tr>
		<td>New Account Credit: </td><td colspan=2><input type="text" name="account_credit" size=8></td><td></td>
	</tr>
	<Tr>
		<td colspan=3>DO NOT USE THIS IF YOU ARE REFUNDING THE AGENT.<br>CREATE A REFUND INVOICE.</td>
	</Tr>
	<tr>
		<td colspan=3 bgcolor="CCCCCC"></td><td></td>
	</tr>
	

</table>
<div class="button"> <input name="submit" type="image" src="pics/update.gif" align="right" border=0></div>
</form>
</cfoutput>
