<cfinclude template="../querys/get_student_info.cfm">

<cfoutput query="get_student_info">

<cfform action="querys/insert_student_school.cfm">
<input type="hidden" name="studentID" value="#get_student_info.studentID#" />

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
		<td background="pics/header_background.gif"><h2>School Information</h2></td>
		<td align="right" background="pics/header_background.gif"> Student: #firstname# #familylastname# (#studentid#) &nbsp; <span class="edit_link">[ <a href="?curdoc=student_info&studentid=#studentid#">overview</a> ]</span></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<!--- body of a table --->
<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
	<tr><td width="80%" valign="top">
		<table border=0 cellpadding=2 cellspacing=0 width="100%">
			<tr><Td width="50%" align="right">Convalidation needed:</td>
					<td width="50%"><cfif convalidation_needed is 'yes'><cfinput type="radio" name="convalidation_needed" value="yes" checked>Yes <cfinput type="radio" name="convalidation_needed" value="no">No
						<cfelseif convalidation_needed is 'no'><cfinput type="radio" name="convalidation_needed" value="yes">Yes <cfinput type="radio" name="convalidation_needed" value="no" checked>No
						<cfelse><cfinput type="radio" name="convalidation_needed" value="yes">Yes <cfinput type="radio" name="convalidation_needed" value="no">No</cfif></td>
			</tr>										
			<tr><td align="right"><font size="-12">&nbsp; For your information: <i>Students from Brazil,  Ecuador, Italy, Mexico and Spain. </i></font></td></tr>
			<tr bgcolor="e2efc7"><td align="right">Last Grade completed:</td>
				<td><cfinput type="text" name="grades" size=10 value="#grades#"></td></tr>
			<tr bgcolor="e2efc7">
				<td align="right">Upon arrival, will the student have completed secondary school in his/her home country?</td>
				<td>
					<cfif app_completed_school is 'Yes'><cfinput type="radio" name="app_completed_school" value="Yes" checked="yes" onchange="DataChanged();">Yes<cfelse><cfinput type="radio" name="app_completed_school" value="Yes" onchange="DataChanged();">Yes</cfif>&nbsp; &nbsp;
					<cfif app_completed_school is 'No'><cfinput type="radio" name="app_completed_school" value="No" checked="yes" onchange="DataChanged();">No<cfelse><cfinput type="radio" name="app_completed_school" value="No" onchange="DataChanged();">No</cfif>	
				</td>
			</tr>
			<tr bgcolor="e2efc7"><td align="right">Estimated GPA:</td>
				<td><cfinput type="text" name="estgpa" size=10 value="#estgpa#"></td></tr>
			<tr><td align="right">Years of English:</td>
				<td><cfinput type="text" name="yearsenglish" size=10 value="#yearsenglish#"></td></tr>
			<tr><td align="right">SLEP Test Score:</td>
				<td><cfinput type="text" name="slep_score" size=10 value="#slep_score#"></td></tr>
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

</cfform>

</cfoutput>
