<SCRIPT LANGUAGE="JavaScript">
<!-- Begin
function checkEmail(obj) {
if (obj.form.send_email.checked = true) {
obj.checked = true; 
} else {
obj.checked = false; }
}
//  End -->
</script>

<style type="text/css">
	table.nav_bar { font-size: 10px; background-color: #ffffe6; border: 1px solid e2efc7; }
</style>

<!--- PROGRAM LIST --->
<cfinclude template="../querys/get_active_programs.cfm">
<!--- INTERNATIONAL REPS WITH KIDS ASSIGNED TO THE COMPANY--->
<cfinclude template="../querys/get_intl_rep.cfm">
<!--- ALL INTERNATIONAL REPS --->
<cfinclude template="../querys/get_all_intl_rep.cfm">

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
		<td background="pics/header_background.gif"><h2>Intl. Representatives Reports</h2></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table border=0 cellpadding=8 cellspacing=2 width=100% class="section">
	<tr><td colspan="3" align="center">Select a report and click on view</td></tr>
	<tr><td>
	
		<!--- Row 1 - 2 boxes --->
		<table class="nav_bar" cellpadding=6 cellspacing="0" align="center" width="95%">
		<tr>
		<td width="50%" align="left">
				<cfform action="reports/email_intl_placement_report.cfm" method="POST" target="blank">
				<Table class="nav_bar" cellpadding=6 cellspacing="0" align="left" width="100%">
					<tr><th colspan="2" bgcolor="e2efc7">Placement Reports & Flight Info</th></tr>
					<tr align="left">
						<TD>Program :</td>
						<TD><select name="programid" multiple  size="5">
						<cfoutput query="get_program"><option value="#ProgramID#">#programname#</option></cfoutput></select></td>
					</tr>
					<tr align="left">
						<TD>Intl. Rep:</td>
						<TD><select name="intrep" size="1">
							<option value=0>All Intl. Reps</option>
							<cfoutput query="get_intl_rep"><option value="#intrep#">#businessname#</option></cfoutput>
							</select></td>
					</tr>
					<tr><td colspan="2"><input type="checkbox" name="send_email" onClick="copy_user.checked = false">&nbsp; Send automated emails to Intl. Agents.</input></td></tr>
					<tr><td colspan="2"><input type="checkbox" name="copy_user" onClick="checkEmail(this)">&nbsp; I would like to receive a copy of the emails</input></td></tr>
					<tr><td colspan="2" align="center"><font color="FF6600">* Approved placements only.</font></td></tr>
					<tr><td colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
				</table>
				</cfform>
		</td>
		<td width="50%" align="right" valign="top">
			<cfform action="reports/email_ds2019_verification.cfm" method="POST" target="blank">
				<Table class="nav_bar" cellpadding=6 cellspacing="0" align="left"  width="100%">
					<tr><th colspan="2" bgcolor="e2efc7">DS-2019 Verification Reports</th></tr>
					<tr align="left">
						<TD>Program :</td>
						<TD><cfselect name="programid" multiple  size="5">
							<cfoutput query="get_program"><option value="#ProgramID#">#programname#</option></cfoutput>
							</cfselect></td>
					</tr>
					<tr align="left">
						<TD>Intl. Rep:</td>
						<TD><cfselect name="intrep" size="1">
							<option value=0>All Intl. Reps</option>
							<cfoutput query="get_intl_rep"><option value="#intrep#">#businessname#</option></cfoutput>
							</cfselect></td>
					</tr>
					<tr><td>Deadline(optional):</td><td><cfinput type="text" name="deadline" size="6" maxlength="10" validate="date"> mm/dd/yyyy</td></tr>
					<tr><td colspan="2"><input type="checkbox" name="send_email" onClick="copy_user.checked = false">&nbsp; Send automated emails to Intl. Agents.</input></td></tr>
					<tr><td colspan="2"><input type="checkbox" name="copy_user" onClick="checkEmail(this)">&nbsp; I would like to receive a copy of the emails</input></td></tr>
					<tr><TD colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0 readonly="yes"></td></tr>
				</table>
			</cfform>
		</td>
		</tr>
		</table><br>
	</td></tr>
	
	<tr><td>
		<!--- Row 2 - 2 boxes --->
		<table class="nav_bar" cellpadding=6 cellspacing="0" align="center" width="95%">
		<tr>
		<td width="50%" align="left">
				<cfform action="reports/placed_students_place.cfm" method="POST" target="blank">
					<Table class="nav_bar" cellpadding=6 cellspacing="0" align="left"  width="100%">
						<tr><th colspan="2" bgcolor="e2efc7">Acceptance Letters</th></tr>
					</table>
				</cfform>
		</td>
		<td width="50%" align="right" valign="top">
				<cfform action="reports/placed_students_place.cfm" method="POST" target="blank">
					<Table class="nav_bar" cellpadding=6 cellspacing="0" align="left"  width="100%">
						<tr><th colspan="2" bgcolor="e2efc7">Not Available</th></tr>
					</table>
				</cfform>
		</td>
		</tr>
		</table><br>
	</td></tr>
</table>

<cfinclude template="../table_footer.cfm">