<!--- <style type="text/css">
	table.nav_bar { font-size: 10px; background-color: #ffffff; border: 1px solid #666666; }
</style> --->

<link rel="stylesheet" href="../reports/reports.css" type="text/css">

<cfinclude template="../querys/get_active_programs.cfm">


<!--- INTERNATIONAL REPS WITH KIDS ASSIGNED TO THE COMPANY--->
<cfinclude template="../querys/get_intl_rep.cfm">

<span class="application_section_header">SEVIS BATCH REPORTS</span><br>

<table class="nav_bar" cellpadding=4 cellspacing="0" align="center" width="96%">
<tr><th bgcolor="ededed">&nbsp; &nbsp; &nbsp; &nbsp; S E V I S &nbsp; R E P O R T S</th><td width="5%" align="right" bgcolor="ededed"><a href="index.cfm?menu=tools&submenu=users&curdoc=sevis/menu"><img src="pics/sevis_menu.gif" border="0"></a></td></tr>
</table><br>

<table cellpadding=6 cellspacing="0" align="center" width="98%">
<tr>
<td colspan="2" valign="top">
	<cfform action="sevis/report_students.cfm" method="POST" target="blank">
		<Table class="nav_bar" cellpadding=6 cellspacing="0" align="center" width="100%">
			<tr><th colspan="2" bgcolor="#ededed">BATCH REPORT</th></tr>
			<tr><td colspan="2" bgcolor="#ededed" align="center"><font size="-2">(Batch ID, Batch Date, Bulk ID, Bulk Date and Insured Date)</font></td></tr>
			<tr align="left">
				<TD>Program :</td>
				<TD><select name="programid" multiple  size="5">			
					<!--- <option value=0>All Programs</option> --->
					<cfoutput query="get_program"><option value="#ProgramID#">#programname#</option></cfoutput>
					</select></td></tr>
			<tr align="left">
				<TD>Intl. Rep :</td>
				<TD><select name="intrep" size="1">
					<option value=0>All Intl. Reps</option>
					<cfoutput query="get_intl_rep"><option value="#intrep#">#businessname#</option></cfoutput>
					</select></td></tr>
			<tr><TD colspan="2" align="center" bgcolor="#ededed"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
		</table>
	</cfform>
</td>
</tr>
</table><br><br>