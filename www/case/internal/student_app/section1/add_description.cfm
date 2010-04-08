<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="../app.css">
	<title>Add Picture Description</title>
</head>
<body>

<cftry>

<cfquery name="get_current_description" datasource="caseusa">
	SELECT description, id 
	FROM smg_student_app_family_album
	WHERE studentid = #client.studentid#
		AND filename = '#url.img#'
</cfquery>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="../pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="../pics/students.gif"></td>
		<td class="tablecenter"><h2>Add Picture Description</h2></td>
		<td width="42" class="tableside"><img src="../pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<cfif get_current_description.recordcount eq 0>
	<cfset insert=0>
<cfelse>
	<cfset insert=1>
</cfif>

<cfoutput>

<div class="section">
<table width=550 cellpadding=4 cellspacing=0 border=0>
	<tr>
		<td style="line-height:20px;" valign="top" colspan=3><br>
		<cfform action="../querys/add_picture_description.cfm?img=#url.img#&insert=#insert#" method="post" enctype="multipart/form-data" preloader="no">
		Please add a description of this picture. Include as much information as you would like.<br>
			<table width=100% cellpadding=4 cellspacing=0 border=0>
				<tr>
					<td><img src="../../uploadedfiles/online_app/picture_album/#client.studentid#/#url.img#" width=200></td>
					<td><textarea name="pic_description" cols=25 rows=8>#get_current_description.description#</textarea></td>
				</tr>
				<tr><td align="center" colspan="2"><br><br><input type="image" src="../pics/add_description.gif" alt="Add Description"></td></tr>
			</table>
		</cfform>
		</td>
	</tr>
</table>
</cfoutput>

</div>

<!--- FOOTER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="8">
		<td width="8"><img src="../pics/p_bottonleft.gif" width="8"></td>
		<td width="100%" class="tablebotton"><img src="../pics/p_spacer.gif"></td>
		<td width="42"><img src="../pics/p_bottonright.gif" width="42"></td>
	</tr>
</table>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>

</body>
</html>