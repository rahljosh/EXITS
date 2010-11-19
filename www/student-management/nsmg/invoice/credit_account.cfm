<link rel="stylesheet" href="../../smg.css" type="text/css">
<head>
<title>Credit Account</title>

<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="check_rights.cfm">

<div class="application_section_header">Credit Account</div><br>
</head>
<table width=100% cellpadding =4 cellspacing =0>
	<tr bgcolor="#FFFFCC">
		<td bgcolor="#FF8080"><b><span class="edit_link">Enter Credit Info</b></td><td><span class="edit_link">Confirmation</td>
	</tr>

</table><br><br>
<cfoutput>
<form method="post" action="record_credit.cfm?agentid=#url.userid#">
</cfoutput>
Please fill in all applicable fields...<br>
<table>
	<tr>
		<td>Student ID:</td><td><Input type="text" name="stuid" size=4></td>
	</tr>
	<tr>
		<td>Invoice Original Charge on:</td><Td><Input type="text" name="orig_inv" size=4></Td>
	</tr>
	<tr>
		<td>Type:</td><Td><Select name="type">
			<option value='cancelation'>Cancellation</option>
			<option value='discount'>Discount</option>
			<option value='credit'>Credit</option>
		</Select></Td>
	</tr>
	<tr>
	<td>Type:</td><Td><Select name="credit_type">
		<option value='AYP'>AYP</option>
		<option value='W&T'>W&T</option>
		<option value='H2B'>H2B</option>
		<option value='Trainee'>Trainee</option>
		<option value='Pre AYP'>Pre AYP</option>
		<option value='Short-Term'>Short-Term</option>
		<option value='Tuition'>Tuition</option>
		<option value='Slep Mtl'>Slep Mtl</option>
		<option value='Canadian Prog'>Canadian Prog</option>
		<option value='Other'></option>
	</Select>
	






	</Td>
	</tr>
	<tr>
		<td>Description:</td><Td><Input type="text" name="description" size=25></Td>
	</tr>
	<tr>
		<td>Amount of Credit:</td><td><input type="text" name="amount" size=25></td>
	</tr>
</table>

<br>
<div class="button"><input name="back" type="image" src="../../pics/approve.gif" align="right" border=0></div></form>