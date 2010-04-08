<cfinclude template="../querys/get_student_info.cfm">

<cfquery name="religion" datasource="caseusa">
select *
from smg_religions
</cfquery>


<cfform action="querys/insert_student_religion.cfm">
<cfoutput query="get_student_info">
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
		<td background="pics/header_background.gif"><h2>Religious Participation</h2></td>
		<td align="right" background="pics/header_background.gif"> Student: #firstname# #familylastname# (#studentid#) &nbsp; <span class="edit_link">[ <a href="?curdoc=student_info&studentid=#studentid#">overview</a> ]</span></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<!--- body of a table --->
<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
	<tr><td width="80%">
		<table border=0 cellpadding=2 cellspacing=0 align="left" width="100%">
			<tr><td>
				<Cfif religious_participation is 'active'><cfinput type="radio" name="church_Activity" value="active" checked><cfelse><cfinput type="radio" name="church_Activity" value="active" checked></cfif>Active (1-2x times a week)<br>
				<Cfif religious_participation is 'average'><cfinput type="radio" name="church_Activity" value="average" checked><cfelse><cfinput type="radio" name="church_Activity" value="average"></cfif>Average (1x a week)<br>
				<Cfif religious_participation is 'little interest'><cfinput type="radio" name="church_Activity" value="little interest" checked><cfelse><cfinput type="radio" name="church_Activity" value="little interest"></cfif>Little Interest (occasionally)<br>
				<Cfif religious_participation is 'inactive'><cfinput type="radio" name="church_Activity" value="inactive" checked><cfelse><cfinput type="radio" name="church_Activity" value="inactive"></cfif>Inactive (Never attend)<br>
				<Cfif religious_participation is 'no interest'><cfinput type="radio" name="church_Activity" value="no interest" checked><cfelse><cfinput type="radio" name="church_Activity" value="no interest"></cfif>No Interest
			</td></tr>
			<tr bgcolor="e2efc7"><td>Religious Affiliation &nbsp; 
					<select name="religious_affiliation">
						<option value="00" selected>
						<cfloop query="religion">
						<cfif get_student_info.religiousaffiliation is religionid><option value="#religionid#" selected>#religionname#<cfelse>
						<option value="#religionid#">#religionname#</cfif>
						</cfloop>
					</select>
			</td></tr>
			<tr><td>Church groups that you are active in, if any:</td></tr>
			<tr><td><textarea col=30 row=6 name="churchgroup">#churchgroup#</textarea></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr bgcolor="e2efc7"><td>Would you be willing to attend church with your host family? &nbsp;
					<cfif churchfam is 'yes'><cfinput type="radio" name="churchfam" value="yes" checked>Yes <cfinput type="radio" name="churchfam" value="no">No</cfif>
					<cfif churchfam is 'no'><cfinput type="radio" name="churchfam" value="yes">Yes <cfinput type="radio" name="churchfam" value="no"checked>No</cfif>
					<cfif churchfam is ''><cfinput type="radio" name="churchfam" value="yes">Yes <cfinput type="radio" name="churchfam" value="no">No</cfif>
			</td></tr>
		</table>
	</td>
	<td width="20%" align="right" valign="top">
		<table border=0 cellpadding=3 cellspacing=0 align="right">
			<tr><td align="right"><cfinclude template="../student_app_menu.cfm"></td></tr>
		</table> 		
	</td>
	</tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr><td align="center"><input name="Submit" type="image" src="pics/next.gif" border="0" value="  next  "></td></tr>
</table>

<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>
</cfoutput>
</cfform>