<style type="text/css">
	table.nav_bar { font-size: 10px; background-color: #ffffff; border: 1px solid #666666;   }
</style>

<cfinclude template="../querys/get_active_programs.cfm">

<cfinclude template="../querys/get_intl_rep_candidates.cfm">

<table width=95% cellpadding=0 cellspacing=0 border=0 align="center">
	<tr valign=middle height=24>
		<td width="57%" valign="middle" bgcolor="#E4E4E4" class="title1">&nbsp;DS-2019 Verification </td>
	</tr>
</table>
<br>
<!---<span class="application_section_header">DS-2019 Verification</span><br>--->
<div align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Select a program to view the list </font></div><br>

<table width="95%" align="center" cellpadding=5 cellspacing="0">
<tr>
	<td width="50%">
		<cfform action="reports/ds2019_list.cfm" method="POST" target="_blank">
		<Table class="nav_bar" cellpadding=5 cellspacing="0" align="left" width="100%">
		<tr><th colspan="2" bgcolor="#ededed"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">DS-2019 Verification Report not received</font></th></tr>
		<TR>
			<TD><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Program :</font></td>
			<TD><select name="programid" multiple size="6">
				<cfoutput query="get_active_programs"><option value="#ProgramID#">#get_active_programs.companyshort# - #programname#</option></cfoutput></select>
			</td>
		</tr>
		</tr>
		<TR>
		<TD colspan="2" align="center" bgcolor="#ededed"><input type="image" src="../pics/view.gif" align="center" border=0></td>
		</tr>
		</table>
		</cfform>
	</td>
	<td width="50%">
		<cfform action="reports/ds2019_list_printed.cfm" method="POST" target="_blank">
		<Table class="nav_bar" cellpadding=5 cellspacing="0" align="left" width="100%">
		<tr><th colspan="2" bgcolor="#ededed"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">DS 2019 Verification Report Received</font></th></tr>
		<TR>
			<TD><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Program :</font></td>
			<TD><select name="programid" multiple size="6">
				<cfoutput query="get_active_programs"><option value="#ProgramID#">#get_active_programs.companyshort# - #programname#</option></cfoutput></select>
			</td>
		</tr>
		<TR>
		<TD colspan="2" align="center" bgcolor="#ededed"><input type="image" src="../pics/view.gif" align="center" border=0></td>
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
		<tr><th colspan="2" bgcolor="#ededed"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">DS-2019 Forms to be issued </font></th></tr>
		<TR>
			<TD><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Program :</font></td>
			<TD><select name="programid" multiple size="6">
				<cfoutput query="get_active_programs"><option value="#ProgramID#">#get_active_programs.companyshort# - #programname#</option></cfoutput></select>
			</td>
		</tr>
		</tr>
		<TR>
		<TD colspan="2" align="center" bgcolor="#ededed"><input type="image" src="../pics/view.gif" align="center" border=0></td>
		</tr>
		</table>
		</cfform>
	</td>
	<td width="50%">
	</td>
</tr>
</table>

<br>
<div align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Select a program and Intl. Rep to print out the verification report.</font></div>
<br>

<cfform name="form" action="reports/ds2019_verification.cfm" method="POST" target="blank">
<table width="95%" align="center" cellpadding=5 cellspacing="0">
<tr>
	<td valign="top">
		<Table class="nav_bar" align="left" cellpadding=5 cellspacing="0">
			<tr><th colspan="2" bgcolor="#ededed"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">DS-2019 Verification Report</font></th></tr>
			<tr>
				<TD><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Program :</font></td>

                <td>
                    <select name="programid" size="4" multiple>
                        <cfoutput query="get_active_programs">
                            <option value="#ProgramID#">
                                <cfif #len(get_active_programs.programname)# gt 32>#Left(get_active_programs.programname, 29)#...<cfelse> #programname# &nbsp; </cfif>
                            </option>
                        </cfoutput>
                    </select>
				</td>
			</tr>
			<TR>
				<TD><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Intl. Rep. :</font></td>
				<td><select name="intrep" size="1">
					<cfoutput query="get_intl_rep_candidates"><option value="#intrep#"><cfif #len(get_intl_rep_candidates.businessname)# gt 32>#Left(get_intl_rep_candidates.businessname, 29)#...<cfelse>#businessname#</cfif></option></cfoutput>	
					</select>
				</td>
			</tr>
			<TR>
				<TD align="center" colspan="2" bgcolor="#ededed"><input type="image" src="../pics/view.gif" align="center" border=0></td>
			</tr>
		</table>	
	</td>	
	<td valign="top">
			<Table class="nav_bar" align="right" border="0">
				<tr><th bgcolor="#CC0000"><font color="white" face="Verdana, Arial, Helvetica, sans-serif">Reminder</font></th></tr>
				<tr>
					<td bgcolor="#ededed"><font size="1" face="Verdana, Arial, Helvetica, sans-serif">Reports print best in Landscape, you have to specify this in your print options.<br>
					Instructions for: <A href="">Internet Explorer, Mozilla, Netscape</A><br><Br>
					<font size=-2>This instructions open in a seperate window, so you can use them while you print</font></td>
				</tr>				
			</table>
	</td>
</tr>
</table>
</cfform>	
