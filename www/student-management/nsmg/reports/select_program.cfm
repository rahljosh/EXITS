<!--- GENDER REPORT --->

<style type="text/css">
	table.nav_bar { font-size: 10px; background-color: #ffffff; border: 1px solid #666666; }
</style>

<cfinclude template="../querys/get_programs.cfm">

<span class="application_section_header">Gender Report by Region</span>
<br>
<div align="center">Select a program to view that gender report</div>
<br>

<table width="80%" align="center" cellpadding=6 cellspacing="0">
<tr>
	<td>
		<cfform action="?curdoc=reports/regional_gender" method="POST">
		<Table class="nav_bar" align="center" cellpadding=6 cellspacing="0">
		<tr><th colspan="2" bgcolor="#ededed">Gender Report</th></tr>
		<TR>
			<TD>Program :</td>
			<TD>
			<select name="programid" size="1">
				<cfoutput query="get_program"><option value="#ProgramID#"><cfif #len(get_program.programname)# gt 22>#Left(get_program.programname, 19)#...<cfelse>#programname#</cfif></option></cfoutput>
			</select>
			</td>
		</tr>
		<TR>
			<TD colspan="2" align="center" bgcolor="#ededed"><input type="image" src="pics/view.gif" align="center" border=0></td>
		</tr>
		</table>
		</cfform>
	</td>
</tr>
</table>
