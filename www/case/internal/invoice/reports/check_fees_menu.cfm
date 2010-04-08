<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="../check_rights.cfm">

<style type="text/css">
	table.nav_bar { font-size: 10px; background-color: #ffffe6; border: 1px solid e2efc7; }
</style>

<cfinclude template="../../querys/get_seasons.cfm">

<cfoutput>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
		<td background="pics/header_background.gif"><h2>Check Missing Charges Per International Representative</h2></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table border=0 cellpadding=8 cellspacing=2 width=100% class="section">
<tr><td>

	<table cellpadding=4 cellspacing="0" align="center" width="96%">
	<tr>
		<td width="50%" valign="top">
			<cfform action="?curdoc=invoice/reports/check_fees" method="POST" target="blank">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" align="left" width="100%">
				<tr><th colspan="2" bgcolor="e2efc7">Check Fees</th></tr>
				<tr align="left">
					<td align="right">Season :</td>
					<td>
					<select name="seasonid" size="1">
						<option value=0></option>
						<cfloop query="get_seasons">
							<option value="#seasonid#">#season#</option>
						</cfloop>
					</select>
					</td>		
				</tr>
				<tr align="left">
					<td align="right">Charge Type :</td>
					<td>
					<select name="chargetype" size="1">
						<option value="0"></option>
						<option value="1">Deposit Fee</option>
						<option value="2">Program Fee</option>
						<option value="3">Insurance</option>
						<option value="4">Region Guarantee</option>
						<option value="5">State Guarantee</option>
						<option value="6">SEVIS Fee</option>
						<option value="7">Pre-AYP English Camp</option>
						<option value="8">Cancelation Fee</option>
					</select>
					</td>		
				</tr>
				<tr align="left">
					<td align="right"><input type="checkbox" name="showstudents"></td>
					<td>Show students</td>		
				</tr>
				<tr>
					<td colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
				</tr>
			</table>
			</cfform>
		</td>
		<td width="50%" valign="top">&nbsp;
			
		</td>		
	</tr>
	</table>
	
</td></tr>
</table>

</cfoutput>

<cfinclude template="../../table_footer.cfm">