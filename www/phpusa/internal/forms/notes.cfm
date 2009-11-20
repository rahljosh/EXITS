<link rel="stylesheet" href="../upi.css" type="text/css">
<cfquery name="notes" datasource="mysql">
Select notes, firstname, middlename, familylastname, studentid
from smg_students
where uniqueid = '#url.unqid#'
</cfquery>


<cfoutput query="notes">

<form method="post" action="../querys/update_notes.cfm?unqid=#url.unqid#">

<table width="400"  border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td bgcolor="##DEE1E7">
<br>
<table width="90%" border=1 align="center" cellpadding=4 cellspacing=0 bordercolor="##C7CFDC" class="box">
	<cfif #cgi.http_referer# is not ''><cfelse>
	<tr><td align="center" bordercolor="##FFFFFF"><span class="get_Attention">Notes Updated</span></td>
	</tr>
	</cfif>
	<tr><td align="center" bordercolor="##FFFFFF">Notes will be date stamped and signed.</td>
	</tr>
	<tr><td align="center" bordercolor="##FFFFFF"><textarea cols=43 rows=18 name="notes">#notes#</textarea></td>
	</tr>
</table>
</cfoutput>

<table width=90% border=0 align="center" cellpadding=4 cellspacing=0 class="section">
	<tr><td align="right" width="50%"><input name="Submit" type="image" src="../pics/update.gif" border=0 alt=" update ">&nbsp;</td>
		<td align="left" width="50%">&nbsp;<input type="image" value="close window" src="../pics/close.gif"  alt="close" onClick="javascript:window.close()"></td></tr>
</table>


</div>

