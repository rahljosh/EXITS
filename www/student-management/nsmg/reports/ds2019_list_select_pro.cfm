<style type="text/css">
	table.nav_bar { font-size: 10px; background-color: #ffffff; border: 1px solid #666666; }
</style>

<cfinclude template="../querys/get_active_programs.cfm">

<cfinclude template="../querys/get_intl_rep.cfm">

<!--- REGION LIST --->
<cfinclude template="../querys/get_regions.cfm">

<span class="application_section_header">#CLIENT.DSFormName# Verification</span><br>
<div align="center">Select a program to view the list</div><br>

<table width="95%" align="center" cellpadding=5 cellspacing="0">
<tr>
	<td width="50%">
		<cfform action="reports/ds2019_list.cfm" method="POST" target="_blank">
		<Table class="nav_bar" cellpadding=5 cellspacing="0" align="left" width="100%">
		<tr><th colspan="2" bgcolor="#ededed">#CLIENT.DSFormName# Verification Report not received</th></tr>
		<TR>
			<TD>Program :</td>
			<TD><select name="programid" multiple size="6">
				<cfoutput query="get_program"><option value="#ProgramID#">#programname#</option></cfoutput></select>
			</td>
		</tr>
		</tr>
		<TR>
		<TD colspan="2" align="center" bgcolor="#ededed"><input type="image" src="pics/view.gif" align="center" border=0></td>
		</tr>
		</table>
		</cfform>
	</td>
	<td width="50%">
		<cfform action="reports/ds2019_list_printed.cfm" method="POST" target="_blank">
		<Table class="nav_bar" cellpadding=5 cellspacing="0" align="left" width="100%">
		<tr><th colspan="2" bgcolor="#ededed">#CLIENT.DSFormName# Verification Report Received</th></tr>
		<TR>
			<TD>Program :</td>
			<TD><select name="programid" multiple size="6">
				<cfoutput query="get_program"><option value="#ProgramID#">#programname#</option></cfoutput></select>
			</td>
		</tr>
		<TR>
		<TD colspan="2" align="center" bgcolor="#ededed"><input type="image" src="pics/view.gif" align="center" border=0></td>
		</tr>
		</table>
		</cfform>
	</td>
</tr>
</table><br>

<table width="95%" align="center" cellpadding=5 cellspacing="0">
<tr>
	<td width="50%">
		<cfform action="reports/ds2019_be_issued.cfm" method="POST" target="_blank">
		<Table class="nav_bar" cellpadding=5 cellspacing="0" align="left" width="100%">
		<tr><th colspan="2" bgcolor="#ededed">#CLIENT.DSFormName# Forms to be issued</th></tr>
		<TR>
			<TD>Program :</td>
			<TD><select name="programid" multiple size="6">
				<cfoutput query="get_program"><option value="#ProgramID#">#programname#</option></cfoutput></select>
			</td>
		</tr>
		</tr>
		<TR>
		<TD colspan="2" align="center" bgcolor="#ededed"><input type="image" src="pics/view.gif" align="center" border=0></td>
		</tr>
		</table>
		</cfform>
	</td>
	<td width="50%">
	</td>
</tr>
</table>

<br>
<div align="center">Select a program and Intl. Rep to print out the verification report.</div>
<br>

<cfform action="reports/ds2019_verification.cfm" method="POST" target="blank">
<table width="95%" align="center" cellpadding=5 cellspacing="0">
<tr>
	<td valign="top">
		<Table class="nav_bar" align="left" cellpadding=5 cellspacing="0">
			<tr><th colspan="2" bgcolor="#ededed">#CLIENT.DSFormName# Verification Report</th></tr>
			<tr>
				<TD>Program :</td>
					<td><select name="programid" size="1">
					<cfoutput query="get_program"><option value="#ProgramID#"><cfif #len(get_program.programname)# gt 32>#Left(get_program.programname, 29)#...<cfelse>#programname#</cfif></option></cfoutput>
					</select>
				</td>
			</tr>
			<TR>
				<TD>Intl. Rep. :</td>
				<td><select name="intrep" size="1">
					<cfoutput query="get_intl_rep"><option value="#intrep#"><cfif #len(get_intl_rep.businessname)# gt 32>#Left(get_intl_rep.businessname, 29)#...<cfelse>#businessname#</cfif></option></cfoutput>	
					</select>
				</td>
			</tr>
			<TR>
				<TD align="center" colspan="2" bgcolor="#ededed"><input type="image" src="pics/view.gif" align="center" border=0></td>
			</tr>
		</table>	
	</td>	
	<td valign="top">
			<Table class="nav_bar" align="right" border="0">
				<tr><th bgcolor="#CC0000"><font color="white">Reminder</th></tr>
				<tr>
					<td bgcolor="#ededed">Reports print best in Landscape, you have to specify this in your print options.<br>
					Instructions for: <A href="">Internet Explorer, Mozilla, Netscape</A><br><Br>
					<font size=-2>This instructions open in a seperate window, so you can use them while you print</font></td>
				</tr>				
			</table>
	</td>
</tr>
</table>
</cfform>	
