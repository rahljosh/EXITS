<style type="text/css">
	table.nav_bar { font-size: 10px; background-color: #ffffe6; border: 1px solid e2efc7; }
</style>

<cfinclude template="../querys/get_programs.cfm">

<cfinclude template="../querys/get_intl_rep.cfm">

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
		<td background="pics/header_background.gif"><h2>Acceptance Letter and Missing Document Reports</h2></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table border=0 cellpadding=8 cellspacing=2 width=100% class="section">
<tr><td>

	<table cellpadding=4 cellspacing="0" align="center" width="96%">
	<tr>
		<td width="50%" valign="top">
			<cfform action="reports/acceptance_letters.cfm" method="POST" target="blank">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" align="left" width="100%">
				<tr><th colspan="2" bgcolor="e2efc7">Acceptance Letter</th></tr>
				<tr align="left">
					<TD>Intl. Rep. :</td>
					<TD>
					<select name="intrep" size="1">
					<option value=0></option>
					<cfoutput query="get_intl_rep"><option value="#intrep#"><cfif #len(get_intl_rep.businessname)# gt 35>#Left(get_intl_rep.businessname, 32)#...<cfelse>#businessname#</cfif></option></cfoutput>
					</select>
					</td>		
				</tr>
				<tr align="left">
					<td>From : </td><td>
						<cfinput type="text" name="date1" size="7" maxlength="10" validate="date"
						required="yes" message="Date is required!"> mm/dd/yyyy</td>
				</tr>
				<tr align="left">
					<td>To : </td><td>
						<cfinput type="text" name="date2" size="7" maxlength="10" validate="date" 
						required="yes" message="Date is required!"> mm/dd/yyyy</td>
				</tr>
				<tr>
					<td colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
				</tr>
			</table>
			</cfform>
		</td>
		<td width="50%" valign="top">
			<cfform action="reports/missing_documents.cfm" method="POST" target="blank">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" align="right" width="100%">
				<tr ><th colspan="2" bgcolor="e2efc7">Missing Documents</th></tr>
				<tr align="left">
					<TD>Program :</td>
					<TD><select name="programid" multiple  size="6">
					<cfoutput query="get_program"><option value="#ProgramID#"><cfif client.companyid is '5'>#get_program.companyshort# - </cfif><cfif #len(get_program.programname)# gt 35>#Left(get_program.programname, 32)#...<cfelse>#programname#</cfif></option></cfoutput></select></td></tr>
				</tr>
				<tr align="left">
					<TD>Intl. Rep. :</td>
					<TD>
					<select name="intrep" size="1">
					<option value=0>All Intl. Reps</option>
					<cfoutput query="get_intl_rep"><option value="#intrep#"><cfif #len(get_intl_rep.businessname)# gt 35>#Left(get_intl_rep.businessname, 32)#...<cfelse>#businessname#</cfif></option></cfoutput>
					</select>
					</td>		
				</tr>
				<tr>
					<TD colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
				</tr>
			</table>
			</cfform>
		</td>		
	</tr>
	</table>
	
</td></tr>
</table>
<cfinclude template="../table_footer.cfm">