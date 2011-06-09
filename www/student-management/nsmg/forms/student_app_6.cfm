<cfinclude template="../querys/get_student_info.cfm">

<cfform action="querys/insert_student_allergies.cfm">
<cfoutput query="get_student_info">
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
		<td background="pics/header_background.gif"><h2>Smoking, Allergies, Chores & Curfew</h2></td>
		<td align="right" background="pics/header_background.gif"> Student: #firstname# #familylastname# (#studentid#) &nbsp; <span class="edit_link">[ <a href="?curdoc=student_info&studentid=#studentid#">overview</a> ]</span></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<!--- body of a table --->
<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
	<tr><td width="80%">
		<table border=0 cellpadding=2 cellspacing=0 align="left" width="100%">
			<Tr><Td class="label">Do you smoke?</td>
				<td><cfif smoke is 'yes'><cfinput type="radio" name="smoke" value="yes" checked>Yes <cfinput type="radio" name="smoke" value="no">No
					<cfelseif smoke is 'no'><cfinput type="radio" name="smoke" value="yes">Yes <cfinput type="radio" name="smoke" value="no" checked>No
					<cfelse><cfinput type="radio" name="smoke" value="yes">Yes <cfinput type="radio" name="smoke" value="no">No</cfif></td>
			</tr>										
			<tr><td></td><td><font size="-12">For your information: <i>The purchase and/or smoking of cigarettes for persons under age 18 is illegal in most parts of the USA.  
								Individual host families may have additional rules which must be followed by their student.</font></td>
			</tr>
			<Tr bgcolor="e2efc7"><td class="label">Are you allergic to:</td><td></td></tr>
			<tr bgcolor="e2efc7"><td class="label">Animals?</td>
				<td><cfif animal_allergies is 'yes'><cfinput type="radio" name="animal_allergies" value="yes" checked>Yes <cfinput type="radio" name="animal_allergies" value="no">No
					<cfelseif animal_allergies is 'no'><cfinput type="radio" name="animal_allergies" value="yes">Yes <cfinput type="radio" name="animal_allergies" value="no" checked>No
					<cfelse><cfinput type="radio" name="animal_allergies" value="yes">Yes <cfinput type="radio" name="animal_allergies" value="no">No</cfif></td>
			</tr>
			<tr bgcolor="e2efc7"><td class="label">Medications?</td>
				<td><cfif med_allergies is 'yes'><cfinput type="radio" name="med_allergies" value="yes" checked>Yes <cfinput type="radio" name="med_allergies" value="no">No
					<cfelseif med_allergies is 'no'><cfinput type="radio" name="med_allergies" value="yes">Yes <cfinput type="radio" name="med_allergies" value="no" checked>No
					<cfelse><cfinput type="radio" name="med_allergies" value="yes">Yes <cfinput type="radio" name="med_allergies" value="no">No</cfif></td>
			</tr>
			<tr bgcolor="e2efc7"><td class="label">Other (be specific)?</td><td><cfinput type="text" name="other_allergies" size=20 value="#other_allergies#"></td></tr>
			<Tr><Td class="label">Do you usually help with household chores?</td>
				<td><cfif chores is 'yes'><cfinput type="radio" name="chores" value="yes" checked>Yes <cfinput type="radio" name="chores" value="no">No
					<cfelseif chores is 'no'><cfinput type="radio" name="chores" value="yes">Yes <cfinput type="radio" name="chores" value="no" checked>No
					<cfelse><cfinput type="radio" name="chores" value="yes">Yes <cfinput type="radio" name="chores" value="no">No</cfif></td>
			</tr>
			<tr><Td class="label">If yes, list the chores for which you are responsible:</td>
				<td><textarea cols=30 rows=3 name="chores_list">#chores_list#</textarea></td></tr>
			<tr bgcolor="e2efc7"><td colspan="2">If your parents require you to be home at a certain time in the evening, please specify that time:</td></tr>
			<Tr bgcolor="e2efc7">
				<Td class="label">Weekdays:</td><td><cfif #weekday_curfew# is '00:00:00'><cfinput type="text" size="5" name="weekday_curfew" value=""><cfelse> <cfinput type="text" size="5" name="weekday_curfew" value="#TimeFormat(weekday_curfew, 'h:mm tt')#"></cfif> hh-mm am/pm</td>
			</tr>
			<tr bgcolor="e2efc7">
				<td class="label">Weekends:</td><td><cfif #weekend_curfew# is '00:00:00'><cfinput type="text" size="5" name="weekend_curfew" value=""><cfelse> <cfinput type="text" size="5" name="weekend_curfew" value="#TimeFormat(weekend_curfew, 'h:mm tt')#"></cfif> hh-mm am/pm</td>
			</tr>
		</table>
	</td>
	<td width="20%" align="right" valign="top">
		<table border=0 cellpadding=3 cellspacing=0 align="right">
			<tr><td align="right"><cfinclude template="student_app_menu.cfm"></td></tr>
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