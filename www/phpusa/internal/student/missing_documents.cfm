<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Missing Documents</title>
</head>

<body>

<Cfif not isdefined ('client.userid')>
	<cflocation url="../axis.cfm?to" addtoken="no">
</Cfif>

<cfif NOT IsDefined('url.unqid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<cfinclude template="../querys/get_student_unqid.cfm">

<cfform name="update" action="qr_missing_documents.cfm"  method="post">

<cfoutput query="get_student_unqid">

<cfinput type="hidden" name="unqid" value="#uniqueid#">
<table width="400"  border="0" align="center" cellpadding="0" cellspacing="0">
	<tr><th bgcolor="##DEE1E7">M i s s i n g &nbsp;&nbsp;&nbsp;  D o c u m e n t s </th></tr>
</table>
	
<table width="400" border=0 align="center" cellpadding=4 cellspacing=0 bgcolor=##ffffff class="box">
	<tr>
		<td valign="top" colspan=2 align="center">Items greyed out are based on information entered on the students profile. 
	</tr>
	<tr><td valign=top>
			<table>
				<tr>
					<td>Personal & Academic Information</td>
				</tr>
				<tr>	
					<Td><cfif transcript is 'no'>
							<input name="transcript" type="radio" value="yes">Yes <input type="radio" name="transcript"  value="no" checked>No
						<cfelse>
							<input type="radio" name="transcript" value="yes"   checked>Yes <input type="radio" name="transcript" value="no">No
						</cfif> &nbsp;&nbsp;&nbsp;Transcript of Grades</td>
				  </tr>
					<tr>
						<Td><cfif language_eval is 'no'><input type="radio" name="language_eval" value="yes">Yes <input type="radio" name="language_eval" value="no" checked>No<cfelse>
							<input type="radio" name="language_eval" value="yes" checked>Yes <input type="radio" name="language_eval" value="no">No</cfif> &nbsp;&nbsp;&nbsp;Language Evaluation</td>
					</tr>
					<tr>
						<Td><cfif social_skills is 'no'><input type="radio" name="social_skills" value="yes">Yes <input type="radio" name="social_skills" value="no" checked>No<cfelse>
							<input type="radio" name="social_skills"  value="yes" checked>Yes <input type="radio" name="social_skills" value="no">No</cfif> &nbsp;&nbsp;&nbsp;Social Skills</td>
					</tr>
					<tr>
						<Td><cfif health is 'no'><input type="radio" name="health" value="yes">Yes <input type="radio" name="health" value="no"  value="no" checked>No<cfelse>
							<input type="radio" name="health"  value="yes" checked>Yes <input type="radio" name="health" value="no">No</cfif> &nbsp;&nbsp;&nbsp;Health Questionnaire</td>
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
						<Td><cfif php_passport_copy is 'no'><input type="radio" name="php_passport_copy" value="yes">Yes <input type="radio" name="php_passport_copy" value="no" checked>No<cfelse>
							<input type="radio" name="php_passport_copy"  value="yes" checked>Yes <input type="radio" name="php_passport_copy" value="no">No</cfif> &nbsp;&nbsp;&nbsp;Copy of Passport</td>
					</tr>
			</table>
			</td>
		<tr>
			<Td colspan=2>Other Missing Items:<br>
						   <textarea cols="45" rows="5" name="other_missing" wrap="VIRTUAL">#other_missing_docs#</textarea></Td>
	  </tr>
	</table>
	
<table border=0 cellpadding=4 cellspacing=0 width="400" class="section">
	<tr><td align="right" width="50%"><input name="Submit" type="image" src="../pics/update.gif" border=0 alt=" update ">&nbsp;</td>
		<td align="left" width="50%">&nbsp;<input type="image" value="close window" src="../pics/close.gif" alt="close window" onClick="javascript:window.close()"></td></tr>
</table>

</cfoutput>

</cfform>

</body>
</html>