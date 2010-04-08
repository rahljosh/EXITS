<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="check_rights.cfm">

<Cfform action="invoice/monthly_statement.cfm?userid=#url.userid#" method="post">
	<div align="center">
	<table>
		<tr>
			<td>Start of Stateent:</td><td> <cfinput type="text" size=10 name="beg_date" value="10/01/2006" label="Start Date of Statement"></td>
		</tr>
		<tr>
			<td>End of Stateent:</Td><td><cfinput type="text"  name="end_date" size=10 value="10/31/2006" label="End Date of Statement"> </td>
		</tr>
		<tr>
			<td colspan=2><input type=checkbox name=pdf value=1 checked>Create PDF</td>
		</tr>
	</table>
	
		<cfinput type="submit" value="Create Statement" name="submit">
		</div>
	
</Cfform>