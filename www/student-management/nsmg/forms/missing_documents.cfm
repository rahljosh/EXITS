<link rel="stylesheet" href="../smg.css" type="text/css">

<cfinclude template="../querys/get_student_info.cfm">

<Title>Missing Documents</title>

<body bgcolor="white" background="white.jpg">

<div id="information_window">
<cfoutput query="get_Student_info">
<cfform action="../querys/update_missing_docs.cfm"  method="post">

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="../pics/header_background.gif"><img src="../pics/students.gif"></td>
		<td background="../pics/header_background.gif"><h2>Missing Documents</h2></td>
		<td width=17 background="../pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
	<tr><td colspan=2><u>M i s s i n g ?</u></td></tr>
	<cfif #cgi.http_referer# is ''><cfelse>
	<tr><td align="center"><span class="get_Attention">Missing Information Updated</span></td></tr>
	</cfif>
	<tr>	
		<Td><cfif transcript is 'no'>
				<input type="radio" name="transcript" value="yes">Yes <input type="radio" name="transcript"  value="no" checked>No
			<cfelse>
				<input type="radio" name="transcript" value="yes" checked>Yes <input type="radio" name="transcript" value="no">No
			</cfif> &nbsp;&nbsp;&nbsp;Transcript of Grades</td>
	</tr>
	<tr>
		<Td><cfif language_eval is 'no'><input type="radio" name="language_eval" value="yes">Yes <input type="radio" name="language_eval" value="no" checked>No<cfelse>
			<input type="radio" name="language_eval" value="yes" checked>Yes <input type="radio" name="language_eval" value="no">No</cfif> &nbsp;&nbsp;&nbsp; Language Evaluation</td>
	</tr>
	<tr>
		<Td><cfif social_skills is 'no'><input type="radio" name="social_skills" value="yes">Yes <input type="radio" name="social_skills" value="no" checked>No<cfelse>
			<input type="radio" name="social_skills"  value="yes" checked>Yes <input type="radio" name="social_skills" value="no">No</cfif>  &nbsp;&nbsp;&nbsp;Social Skills</td>
	</tr>
	<tr>
		<Td><cfif health is 'no'><input type="radio" name="health" value="yes">Yes <input type="radio" name="health" value="no"  value="no" checked>No<cfelse>
			<input type="radio" name="health"  value="yes" checked>Yes <input type="radio" name="health" value="no">No</cfif>&nbsp;&nbsp;&nbsp;Health Questionnaire</td>
	</tr>
	<tr>
		<Td><cfif immunization is 'no'><input type="radio" name="immunization" value="yes">Yes <input type="radio" name="immunization" value="no" checked>No<cfelse>
			<input type="radio" name="immunization"  value="yes" checked>Yes <input type="radio" name="immunization" value="no">No</cfif> &nbsp;&nbsp;&nbsp;Immunization Records</td>
	</tr>
	<tr>
		<Td><cfif minorauthorization is 'no'><input type="radio" name="minorauthorization" value="yes">Yes <input type="radio" name="minorauthorization" value="no" checked>No<cfelse>
			<input type="radio" name="minorauthorization"  value="yes" checked>Yes <input type="radio" name="minorauthorization" value="no">No</cfif> &nbsp;&nbsp;&nbsp;Authorization to Treat a Minor</td>
	</tr>
    
	
    
	<tr>
		<Td>Missing Documents:<br>
           <textarea cols="40" rows="6" name="other_missing" wrap="VIRTUAL">#other_missing_docs#</textarea></Td>
	</tr>
</table>
	
<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr><td align="right" width="50%"><input name="Submit" type="image" src="../pics/update.gif" border=0 alt=" update ">&nbsp;</td>
		<td align="left" width="50%">&nbsp;<input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()"></td></tr>
</table>
</cfform>

<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td>
		<td width=100% background="../pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td>
	</tr>
</table>	
</div>
</cfoutput>