<link rel="stylesheet" href="../smg.css" type="text/css">

<cfinclude template="../querys/get_student_info.cfm">

<cfinclude template="../querys/get_interests.cfm">

<cfquery name="get_student_interests" datasource="caseusa">
	select interests, interests_other
	from smg_students
	where studentid = #client.studentid# 
</cfquery>

<cfform action="../querys/update_profile_adj.cfm" method="post">
<cfoutput query="get_student_info"><br>
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="../pics/header_background.gif"><img src="../pics/students.gif"></td>
		<td background="../pics/header_background.gif"><h2>Profile Adjustments</h2></td>
		<td align="right" background="../pics/header_background.gif"><h2>#get_Student_info.firstname# #get_Student_info.familylastname# (#get_Student_info.studentid#)</h2></td>
		<td width=17 background="../pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
	<cfif #cgi.http_referer# is ''><cfelse>
	<tr><td align="center" colspan="8"><span class="get_Attention">Profile Ajustments Updated</span></td></tr>
	</cfif>
	<tr><td colspan="8"><h2> Interests </h2></td></tr>
	<tr>
	<cfloop query="get_interests">	
			<td><input type="checkbox" name="interest" value='#interestid#' <cfif ListFind(get_student_interests.interests, interestid , ",")>checked<cfelse></cfif>> </td>
			<td>#interest#</td>
			<cfif (get_interests.currentrow MOD 4 ) is 0></tr><tr></cfif>
	</cfloop>
	<tr bgcolor="e2efc7">
		<td align="left" colspan="4">Do you play in a Band?</td>
		<td colspan="4">  <cfif band is 'yes'><cfinput type="radio" name=band value="yes" checked>Yes <cfinput type="radio" name=band value="no">No
			  <cfelseif band is 'no'><cfinput type="radio" name=band value="yes">Yes <cfinput type="radio" name=band value="no" checked>No  
			  <Cfelse><cfinput type="radio" name=band value="yes">Yes <cfinput type="radio" name=band value="no">No</cfif> </td>
	</tr>
		<Tr bgcolor="e2efc7">
		<td align="left" colspan="4">Do you play in an Orchestra?</td>
		<td colspan="4"> <Cfif orchestra is 'yes'><cfinput type="radio" name=orchestra value="yes" checked>Yes  <cfinput type="radio" name=orchestra value="no">No
			 <cfelseif orchestra is 'no'><cfinput type="radio" name=orchestra value="yes">Yes  <cfinput type="radio" name=orchestra value="no" checked>No
			 <cfelse><cfinput type="radio" name=orchestra value="yes">Yes  <cfinput type="radio" name=orchestra value="no">No</cfif></td>
	</tr>
		<Tr bgcolor="e2efc7">
		<td align="left" colspan="4">Do you play in competitive sports?</td>
		<td colspan="4">  <Cfif comp_sports is 'yes'><cfinput type="radio" name=comp_sports value="yes" checked>Yes <cfinput type="radio" name=comp_sports value="no">No
			  <cfelseif comp_sports is 'no'><cfinput type="radio" name=comp_sports value="yes" checked>Yes <cfinput type="radio" name=comp_sports value="no" checked>No
			  <cfelse><cfinput type="radio" name=comp_sports value="yes">Yes <cfinput type="radio" name=comp_sports value="no"></cfif></td>
	</tr>
</table>

<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
	<tr><td><h2> Narrative </h2></td></tr>
	<tr><td>Please list any specific interests, hobbies, activities and any awards or commendations:</td></tr>
	<Tr><td><textarea cols="60" rows="8" name="specific_interests" wrap="VIRTUAL">#interests_other#</textarea></td></tr>
</table>

<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
	<tr bgcolor="e2efc7"><td colspan="2"><h2> School Information </h2></td></tr>
	<tr bgcolor="e2efc7"><td class="label">Last Grade completed:</td>
		<td><cfinput type="text" name="grades" size=10 value="#grades#"></td></tr>
	<tr bgcolor="e2efc7"><td class="label">Years of English:</td>
		<td><cfinput type="text" name="yearsenglish" size=10 value="#yearsenglish#"></td></tr>
	<cfif client.usertype LTE '4'>
	<tr bgcolor="e2efc7"><td class="label">Estimated GPA:</td>
		<td><cfinput type="text" name="estgpa" size=10 value="#estgpa#"></td></tr>
	<tr bgcolor="e2efc7"><td class="label">SLEP Test Score:</td>
		<td><cfinput type="text" name="slep_score" size=10 value="#slep_score#"></td></tr>
	</cfif>
</table>

<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
	<tr><td><h2> Allergies </h2></td></tr>
	<Tr><Td class="label">Are you allergic to:</td><td></td></tr>
	<tr><td class="label">Animals?</td><td><cfif animal_allergies is 'yes'><cfinput type="radio" name="animal_allergies" value="yes" checked>Yes <cfinput type="radio" name="animal_allergies" value="no">No
											<cfelseif animal_allergies is 'no'><cfinput type="radio" name="animal_allergies" value="yes">Yes <cfinput type="radio" name="animal_allergies" value="no" checked>No
											<cfelse><cfinput type="radio" name="animal_allergies" value="yes">Yes <cfinput type="radio" name="animal_allergies" value="no">No</cfif></td></tr>
	<tr><td class="label">Medications?</td><td><cfif med_allergies is 'yes'><cfinput type="radio" name="med_allergies" value="yes" checked>Yes <cfinput type="radio" name="med_allergies" value="no">No
												<cfelseif med_allergies is 'no'><cfinput type="radio" name="med_allergies" value="yes">Yes <cfinput type="radio" name="med_allergies" value="no" checked>No
												<cfelse><cfinput type="radio" name="med_allergies" value="yes">Yes <cfinput type="radio" name="med_allergies" value="no">No</cfif></td></tr>
	<tr><td class="label">Other (be specific)?</td><td><cfinput type="text" name="other_allergies" size=20 value="#other_allergies#"></td></tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr><td align="right" width="50%"><input name="Submit" type="image" src="../pics/update.gif" border=0 alt=" update ">&nbsp;</td>
		<td align="left" width="50%">&nbsp;<input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()"></td></tr>
</table>

<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td>
		<td width=100% background="../pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td>
	</tr>
</table>	
</cfoutput>
</cfform>