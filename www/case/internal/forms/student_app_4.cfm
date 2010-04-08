<cfinclude template="../querys/get_student_info.cfm">

<cfinclude template="../querys/get_interests.cfm">

<cfquery name="get_student_interests" datasource="caseusa">
select interests, interests_other
from smg_students
where studentid = #client.studentid# 
</cfquery>

<cfform action="querys/insert_student_interests.cfm" method="post">
<cfoutput query="get_student_info">

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
		<td background="pics/header_background.gif"><h2>Activites & Interests</h2></td>
		<td align="right" background="pics/header_background.gif"> Student: #firstname# #familylastname# (#studentid#) &nbsp; <span class="edit_link">[ <a href="?curdoc=student_info&studentid=#studentid#">overview</a> ]</span></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<!--- body of a table --->
<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
	<tr><td width="80%">
		<table border=0 cellpadding=2 cellspacing=0 align="left" width="100%">
			<tr><cfloop query="get_interests">	
					<td><input type="checkbox" name="interest" value='#interestid#' <cfif ListFind(get_student_interests.interests, interestid , ",")>checked<cfelse></cfif>> </td><td>#interest#</td>
					<cfif (get_interests.currentrow MOD 4 ) is 0></tr><tr></cfif>
				</cfloop>
			<tr><td>&nbsp;</td></tr>
			<Tr bgcolor="e2efc7">
				<td align="left" colspan="4">Do you play in a Band?</td>
				<td colspan="4"><cfif band is 'yes'><cfinput type="radio" name=band value="yes" checked>Yes <cfinput type="radio" name=band value="no">No
								<cfelseif band is 'no'><cfinput type="radio" name=band value="yes">Yes <cfinput type="radio" name=band value="no" checked>No  
								<Cfelse><cfinput type="radio" name=band value="yes">Yes <cfinput type="radio" name=band value="no">No</cfif> </td>
			</tr>
			<Tr bgcolor="e2efc7">
				<td align="left" colspan="4">Do you play in an Orchestra?</td>
				<td colspan="4"><Cfif orchestra is 'yes'><cfinput type="radio" name=orchestra value="yes" checked>Yes  <cfinput type="radio" name=orchestra value="no">No
								<cfelseif orchestra is 'no'><cfinput type="radio" name=orchestra value="yes">Yes  <cfinput type="radio" name=orchestra value="no" checked>No
								<cfelse><cfinput type="radio" name=orchestra value="yes">Yes  <cfinput type="radio" name=orchestra value="no">No</cfif></td>
			</tr>
			<Tr bgcolor="e2efc7">
				<td align="left" colspan="4">Do you play in competitive sports?</td>
				<td colspan="4"><Cfif comp_sports is 'yes'><cfinput type="radio" name=comp_sports value="yes" checked>Yes <cfinput type="radio" name=comp_sports value="no">No
								<cfelseif comp_sports is 'no'><cfinput type="radio" name=comp_sports value="yes" checked>Yes <cfinput type="radio" name=comp_sports value="no" checked>No
								<cfelse><cfinput type="radio" name=comp_sports value="yes">Yes <cfinput type="radio" name=comp_sports value="no"></cfif></td>
			</tr>
			<tr bgcolor="e2efc7"><td colspan="8">Please list any specific interests, hobbies, activities and any awards or commendations:</td></tr>
			<tr bgcolor="e2efc7"><td colspan="8"><textarea cols="60" rows="8" name="specific_interests" wrap="VIRTUAL">#interests_other#</textarea></td></tr>
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