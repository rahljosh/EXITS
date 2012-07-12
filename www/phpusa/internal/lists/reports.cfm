<style type="text/css">
<!--
.style1 {font-size: 15px}
.get_Attention{color: #8B0000;}
-->
</style>

<table width=90% height=24 border=0 align="center" cellpadding=0 cellspacing=0>
	<tr valign=middle height=24>

		<td><h2>R e p o r t s</h2></td>
		<td width=17>&nbsp;</td>
	</tr>
</table>

<table border=0 cellpadding=8 cellspacing=2 width=90% class="box" bgcolor="white" align="center">
<tr><td colspan="2">All reports that can be run are listed below.  These reports are also linked to various other 
	locations throughout the site.  If no reports are listed, there are no stand alone reports that you have access to.</td>
</tr>

<!--- EVERYBODY SEES IT --->
<tr bgcolor="C2D1EF"><td colspan="2"><span class="get_attention"><font color="000000"><b>::</b> Reports Available for All Users</font></span></td>
</tr>
<tr>
	<td><a href="http://www.universalprograms.com/internal/student_profile_all.cfm" target="top">All Student Profiles</a> (opens in new window)</td>
	<td><a href="http://www.universalprograms.com/internal/student_profile_all.cfm" target="top">School Marketing List</a> (opens a PDF in new window)</td>
</tr>
<tr>
	<td><a href="http://www.universalprograms.com/internal/reports/school_labels.cfm">School Labels Avery 5160</a> (opens in Microsoft Word)</td>
	<td><a href="http://www.universalprograms.com/internal/reports/school_list.cfm" target="top">School Contact List</a> (opens a PDF in new window)</td>
</tr>
<tr>
	<td><a href="http://www.universalprograms.com/internal/reports/student_notes.cfm">Students Listed w/ notes</a> (opens in new window)</td>
	<td></td>
</tr>

<!--- Marcus Testing section --->
<cfif client.userid  is 510 or client.usertype is 1>
<tr bgcolor="C2D1EF"><td colspan="2"><span class="get_attention"><font color="000000"><b>::</b> Testing Section</font></span></td>
</tr>
	<tr>
		<td><a href="reports/hdreport.cfm" target=top>Help Desk Report</a></td>
		<td></td>
	</tr>
</cfif>
</table>