<link rel="stylesheet" href="../smg.css" type="text/css">
<Title>Placement Notes</title>
<body bgcolor="white" background="white.jpg">

<cfif not IsDefined('url.update')>
	<cfset url.update = 'no'>
</cfif>

<cfif IsDefined('url.studentid')>
	<cfset client.studentid = '#url.studentid#'>
</cfif>

<!--- Student Info --->
<cfinclude template="../querys/get_student_info.cfm">

<!--- include template page header --->
<cfinclude template="placement_status_header.cfm">

<cfoutput query="get_student_info">

<table width="580" align="center">
<tr><td><span class="application_section_header">Placement Paperwork</span></td></tr>
</table><br>

<div class="row">

<cfif hostid EQ 0>
	<cfoutput>
	<table width="580" align="center">
		<tr><td align="center"><h3>There is no host family assigned to this student.</h3></td></tr>
		<tr><td align="center"><h3>You cannot enter placement notes if the student is not placed. Please add a host family first.</h3></td></tr>
	</table><br>
	<table width="580" align="center">
	<tr><td align="center">
			<input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()">
		</td></tr>
	</table>
	</cfoutput>
	<cfabort>
</cfif>

<cfparam name="edit" default="yes">
<form action="../querys/update_place_notes.cfm?studentid=#client.studentid#"  method="post">

<cfif url.update is 'yes'>
	<div align="center"><span class="get_Attention">Placement Notes Updated</span></div><br>
</cfif>

<Table width="580" align="center" cellpadding=3 cellspacing="0">
	<tr><td align="center"><div align="justify">
		<p>Please enter comment as you want to see it appear in the placement letter.
		Other Pertinent Information (other information student needs to have).</p></div>
	</td></tr>
	<tr><td align="center"><textarea cols=50 rows=10 name="placement_notes">#placement_notes#</textarea></td></tr>
</table>

<table width="580" align="center">
<tr>
	<td align="right" width="50%"><font size=-1><br>
	<input name="submit" type="image" src="../pics/update.gif" align="right" border=0>&nbsp;&nbsp;</form></td>
	<td align="left" width="50%">
		<font size=-1><Br>&nbsp;&nbsp;
		<input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()">
	</td>
</tr>
</table>
</cfoutput>

<br>
</div>