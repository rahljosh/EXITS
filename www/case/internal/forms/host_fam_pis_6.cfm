<cfquery name="get_trans" datasource="caseusa">
select schooltransportation, school_trans
from smg_hosts
where hostid = #client.hostid#
</cfquery>

<cfinclude template="../querys/family_info.cfm">

<cfform action="?curdoc=querys/insert_school_questions_pis" method="post">
<Cfoutput>
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/school.gif"></td>
		<td background="pics/header_background.gif"><h2>School Information</h2></td>
		<td align="right" background="pics/header_background.gif"><span class="edit_link">[ <a href="?curdoc=host_fam_info&hostid=#client.hostid#">overview</a> ]</span></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
	<tr><td width="80%" valign="top">
		<table border=0 cellpadding=4 cellspacing=0 align="left" width="100%">
			<tr><td>Please list ALL costs student is responsible for (other than lunch):</td></tr>
			<tr><td><textarea cols="50" rows="4" name="school_costs" wrap="VIRTUAL">#family_info.schoolcosts#</textarea></td></tr>
			<tr bgcolor="e2efc7"><td>Distance from home to school: <input type="text" size=3 name="distance_school" value=#family_info.schooldistance#> miles</td></tr>
			<tr bgcolor="e2efc7"><td>Transportation to school:</td></tr>
			<tr bgcolor="e2efc7"><td>
				<cfif get_trans.schooltransportation is 'School Bus'><cfinput type="radio" name="transportation" value="School Bus" checked> School Bus<cfelse><cfinput type="radio" name="transportation" value="School Bus" selected> School Bus</cfif>
				<cfif get_trans.schooltransportation is 'Car'> <cfinput type="radio" name="transportation" value="Car" checked> Car<cfelse><cfinput type="radio" name="transportation" value="Car"> Car</cfif>
				<cfif get_trans.schooltransportation is 'Public Transportation'><cfinput type="radio" name="transportation" value="Public Transportation" checked> Public Transportation<cfelse><cfinput type="radio" name="transportation" value="Public Transportation"> Public Transportation</cfif>
			</td></tr>
			<tr bgcolor="e2efc7"><td>					
				<cfif get_trans.schooltransportation is 'Walk'><cfinput type="radio" name="transportation" value="Walk" checked> Walk <cfelse><cfinput type="radio" name="transportation" value="Walk"> Walk</cfif>
				<cfif get_trans.schooltransportation is 'Other'><cfinput type="radio" name="transportation" value="Other" checked> Other: &nbsp; <cfinput type="text" name="other_desc" size=10 value="#get_trans.school_trans#"><cfelse><cfinput type="radio" name="transportation" value="Other"> Other: &nbsp; <cfinput type="text" name="other_desc" size=10></cfif> 
			</td></tr>
		</table>
	</td>
	<td width="20%" align="right" valign="top">
		<table border=0 cellpadding=4 cellspacing=0 align="right">
			<tr><td align="right"><cfinclude template="../family_pis_menu.cfm"></td></tr>
		</table> 		
	</td>
	</tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr><td align="center"><input name="Submit" type="image" src="pics/next.gif" align="middle" border=0></td></tr>
</table>

<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>
</Cfoutput>
</cfform>
