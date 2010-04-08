<link rel="stylesheet" href="../smg.css" type="text/css">

<cfquery name="placement_notes" datasource="caseusa">
Select firstname, middlename, familylastname, placement_notes, studentid
from smg_students
where studentid = #client.studentid#
</cfquery>

<cfoutput query="placement_notes">
<Title>Placement notes on #firstname# #middlename# #familylastname#</title>

<form method="post" action="../querys/update_placement_notes.cfm">

<div id="information_window">

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="../pics/header_background.gif"><img src="../pics/students.gif"></td>
		<td background="../pics/header_background.gif"><h2>Placement Notes</h2></td>
		<td width=17 background="../pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
	<tr><td align="center"><h2>#firstname# #middlename# #familylastname# (#studentid#)</h2></td></tr>
	<cfif #cgi.http_referer# is ''><cfelse>
	<tr><td align="center"><span class="get_Attention">Placement Notes Updated</span></td></tr>
	</cfif>
	<tr><td align="center"><div align="justify">
		<p>Please enter comment as you want to see it appear in the placement letter.
		Other Pertinent Information (other information student needs to have).</p></div>
	</td></tr>
	<tr><td align="center"><textarea cols=40 rows=14 name="placement_notes">#placement_notes#</textarea></td></tr>
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