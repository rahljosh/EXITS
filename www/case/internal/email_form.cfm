<cftry>

<cfif NOT IsDefined('url.unqid')>
	<cfinclude template="error_message.cfm">
</cfif>

<!--- OPENING FROM PHP - AXIS --->
<cfif IsDefined('url.user')>
	<cfset client.userid = '#url.user#'>
</cfif>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" type="text/css" href="../smg.css">
<title>Email Feature</title>
</head>

<body>

<script language="JavaScript"> 
<!--// 
   function CheckEmail() {
   if (document.send_email.email_address.value == '') {
	 alert("You must enter at least one e-mail address");
	 document.send_email.email_address.focus(); 
	 return false; } 
	}
//-->
</script> 

<cfquery name="get_student_info" datasource="caseusa">
 	SELECT s.firstname, s.familylastname, s.studentid,
		u.businessname
	FROM smg_students s
	INNER JOIN smg_users u ON u.userid = s.intrep
	WHERE s.uniqueid = <cfqueryparam value="#url.unqid#" cfsqltype="cf_sql_varchar">
</cfquery>

<table width=430 cellpadding=0 cellspacing=0 border=0>
<tr><td>

	<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
		<tr valign=middle height=24>
			<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
			<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
			<td background="pics/header_background.gif"><h2>Emailing EXITS Online Application</h2></td>
			<td background="pics/header_background.gif" align="right">
			<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
		</tr>
	</table>	
	<cfoutput query="get_student_info">
	<cfform action="qr_email_form.cfm" name="send_email" method="post" onSubmit="return CheckEmail();">
	<cfinput type="hidden" name="studentid" value="#studentid#">
	<cfinput type="hidden" name="userid" value="#client.userid#">
	<table width=100% border=0 cellpadding=4 cellspacing=0 class="section">
		<tr>	
			<td colspan="2"><div align="justify"><br>
				This screen allows you to send automated emails that contain a link to the complete EXITS application to potential host families, 
				schools, reps or anyone interested in this student.
				In order to send e-mails just complete the boxes below and click on the send button.
				</div><br>
			</td>
		</tr>
		<tr>	
			<td colspan="2"><b>Student: #get_student_info.firstname# #familylastname# (###studentid#)</b></td>
		</tr>
		<tr>	
			<td colspan="2">Please enter e-mails on the box below.<br></td>
		</tr>
		<tr>	
			<td colspan="2"><textarea name="email_address" rows="3" cols="45"></textarea><br>
				<b>Note:</b> If entering more than one email address separate them with a semi-colon ( ; ).
			</td>
		</tr>
		<tr>	
			<td colspan="2">Comments: (optional)</td>
		</tr>	
		<tr>	
			<td colspan="2"><textarea name="comments" rows="3" cols="45"></textarea></td>
		</tr>
		<tr>	
			<td align="right" width="50%"><input name="Submit" type="image" src="../pics/submit.gif" border=0 alt=" Send Email ">&nbsp </cfform></td>
			<td align="left" width="50%">&nbsp;<input type="image" value="close window" src="../pics/close.gif" alt=" Close this Screen " onClick="javascript:window.close()"></td>
		</tr>	
	</table>
	</cfoutput>
	
	<cfinclude template="../table_footer.cfm">

</td></tr>
</table>

<cfcatch type="any">
	<cfinclude template="error_message.cfm">
</cfcatch>
</body></html></cftry>


