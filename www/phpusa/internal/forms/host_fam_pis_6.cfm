<cfquery name="get_trans" datasource="mysql">
select schooltransportation, school_trans
from smg_hosts
where hostid = #client.hostid#
</cfquery>

<cfinclude template="../querys/family_info.cfm">

<cfform action="?curdoc=querys/insert_school_questions_pis" method="post">
<Cfoutput>
<table width=90% height=24 border=0 align="center" cellpadding=0 cellspacing=0>
	<tr valign=middle height=24>
		<td background="pics/header_background.gif"><h2>School Information</h2></td>
		<td align="right" background="pics/header_background.gif"><span class="edit_link">[ <a href="?curdoc=host_fam_info&hostid=#client.hostid#">overview</a> ]</span></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table width="90%" border=1 align="center" cellpadding=8 cellspacing=8 bordercolor="##C2D1EF" bgcolor="##FFFFFF" >
	<tr><td width="80%" valign="top" class="box">
		<table border=0 cellpadding=4 cellspacing=0 align="left" width="100%">
			<tr><td>Please list ALL costs student is responsible for (other than lunch):</td></tr>
			<tr><td><textarea cols="50" rows="4" name="school_costs" wrap="VIRTUAL">#family_info.schoolcosts#</textarea></td></tr>
			<tr bgcolor="e2efc7"><td bgcolor="C2D1EF">Distance from home to school: 
			  <input type="text" size=3 name="distance_school" value=#family_info.schooldistance#> miles</td></tr>
			<tr bgcolor="e2efc7"><td bgcolor="C2D1EF">Transportation to school:</td>
			</tr>
			<tr bgcolor="e2efc7"><td bgcolor="C2D1EF">
				<cfif get_trans.schooltransportation is 'School Bus'><cfinput type="radio" name="transportation" value="School Bus" checked> School Bus<cfelse><cfinput type="radio" name="transportation" value="School Bus" selected> School Bus</cfif>
				<cfif get_trans.schooltransportation is 'Car'> <cfinput type="radio" name="transportation" value="Car" checked> Car<cfelse><cfinput type="radio" name="transportation" value="Car"> Car</cfif>
				<cfif get_trans.schooltransportation is 'Public Transportation'><cfinput type="radio" name="transportation" value="Public Transportation" checked> Public Transportation<cfelse><cfinput type="radio" name="transportation" value="Public Transportation"> Public Transportation</cfif>
			</td></tr>
			<tr bgcolor="e2efc7"><td bgcolor="C2D1EF">					
				<cfif get_trans.schooltransportation is 'Walk'><cfinput type="radio" name="transportation" value="Walk" checked> Walk <cfelse><cfinput type="radio" name="transportation" value="Walk"> Walk</cfif>
				<cfif get_trans.schooltransportation is 'Other'><cfinput type="radio" name="transportation" value="Other" checked> Other: &nbsp; <cfinput type="text" name="other_desc" size=10 value="#get_trans.school_trans#"><cfelse><cfinput type="radio" name="transportation" value="Other"> Other: &nbsp; <cfinput type="text" name="other_desc" size=10></cfif> 
			</td></tr>
		</table>
	</td>
	<td width="20%" align="right" valign="top" class="box">
		<table border=0 cellpadding=4 cellspacing=0 align="right">
			<tr><td align="right"><cfinclude template="../family_pis_menu.cfm"></td></tr>
		</table> 		
	</td>
	</tr>
</table>

<table width=90% border=0 align="center" cellpadding=4 cellspacing=0 class="section">
	<tr><td align="center"><input name="Submit" type="image" alt="next" src="pics/next.gif" align="middle" border=0></td></tr>
</table>


</Cfoutput>
</cfform>
