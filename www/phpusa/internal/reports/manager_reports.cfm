<style type="text/css">
	table.nav_bar { font-size: 10px; ; border: 1px solid e2efc7; }
</style>

<!--- PROGRAM LIST --->
<cfquery name="get_program" datasource="#application.dsn#">
select *
from smg_programs 
where active = 1 and companyid = 6
</cfquery>
<!--- REGION LIST --->
<!--- <cfinclude template="../querys/get_user_regions.cfm"> --->



<h2 align="center">Flight Information</h2>

<table border=0 cellpadding=8 cellspacing=2 width=100% class="section">
<tr><td>

<table cellpadding=6 cellspacing="0" align="center" width="97%">
	<tr>
	<td width="50%" valign="top">
		<cfform action="reports/flight_information_report.cfm" method="POST" target="blank">
		<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
			<tr><th colspan="2" bgcolor="#C4CDE7">Flight Arrival Information</th></tr>
				<tr align="left">
					<TD>Program :</td>
					<TD><select name="programid" multiple  size="4">
					<cfoutput query="get_program"><option value="#ProgramID#">#programname#</option></cfoutput></select></td></tr>
				
				<tr><td colspan="2"><input type="checkbox" name="dates">&nbsp;Limit to Arrival dates between:</input></td></tr>
				<tr>
					<td width="5">From : </td><td><cfinput type="text" name="date1" size="7" maxlength="10" validate="date"> mm-dd-yyyy</td>
				</tr>
				<tr>
					<td width="5">To : </td><td><cfinput type="text" name="date2" size="7" maxlength="10" validate="date"> mm-dd-yyyy</td></tr>			
			<tr><TD colspan="2" align="center" bgcolor="#C4CDE7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
		</table>
		</cfform>
	</td>
	<td width="50%">
		<cfform action="reports/flight_info_depart_report.cfm" method="POST" target="blank">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="#C4CDE7">Flight Departure Information</th></tr>
				<tr align="left">
					<TD>Program :</td>
					<TD><select name="programid" multiple  size="4">
					<cfoutput query="get_program"><option value="#ProgramID#">#programname#</option></cfoutput></select></td></tr>
				
								<tr><td colspan="2"><input type="checkbox" name="dates">&nbsp; Including Period Below (Depar. Date)</input></td></tr>
				<tr>
					<td width="5">From : </td><td><cfinput type="text" name="date1" size="7" maxlength="10" validate="date"> mm-dd-yyyy</td>
				</tr>
				<tr>
					<td width="5">To : </td><td><cfinput type="text" name="date2" size="7" maxlength="10" validate="date"> mm-dd-yyyy</td></tr>			
				<tr><TD colspan="2" align="center" bgcolor="#C4CDE7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
			</table>
		</cfform>
	</td>
	</tr>
</table><br>

<table cellpadding=6 cellspacing="0" align="center" width="97%">
	<tr>
	<td width="50%">
		<cfform action="reports/flight_info_missing_by_region.cfm" method="POST" target="blank">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="#C4CDE7">Flight Info Missing By Region</th></tr>
				<tr align="left">
					<TD>Program :</td>
					<TD><select name="programid" multiple  size="4">
					<cfoutput query="get_program"><option value="#ProgramID#">#programname#</option></cfoutput></select></td></tr>
				
				<tr><td colspan=2>Date Placed (leave blank for no filter) :</td></tr>
               	<tr>
					<td width="5">Between : </td><td><cfinput type="text" name="place_date1" size="7" maxlength="10" validate="date"> mm-dd-yyyy</td>
				</tr>
				<tr>
					<td width="5">And : </td><td><cfinput type="text" name="place_date2" size="7" maxlength="10" validate="date"> mm-dd-yyyy</td></tr>	
									
				<tr><TD colspan="2" align="center" bgcolor="#C4CDE7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
			</table>
		</cfform>
	</td>
	<td width="50%">
			<!--- new form here --->
	</td>
	</tr>
</table><br>

</td></tr>
</table>