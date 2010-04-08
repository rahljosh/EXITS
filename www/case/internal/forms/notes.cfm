<link rel="stylesheet" href="../smg.css" type="text/css">

<cfquery name="notes" datasource="caseusa">
Select notes, firstname, middlename, familylastname, studentid
from smg_students
where studentid = #client.studentid#
</cfquery>

<div id="information_window">
<cfoutput query="notes">
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="../pics/header_background.gif"><img src="../pics/students.gif"></td>
		<td background="../pics/header_background.gif"><h2>Notes</h2></td>
		<td align="right" background="../pics/header_background.gif"><h2>#notes.firstname# #notes.familylastname# (#notes.studentid#)</h2></td>
		<td width=17 background="../pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<form method="post" action="../querys/update_notes.cfm">
<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
	<cfif #cgi.http_referer# is ''><cfelse>
	<tr><td align="center"><span class="get_Attention">Notes Updated</span></td></tr>
	</cfif>
	<tr><td align="center">Notes will be date stamped and signed.</td></tr>
	<tr><td align="center"><textarea cols=43 rows=18 name="notes">#notes#</textarea></td></tr>
</table>
</cfoutput>

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
</div>