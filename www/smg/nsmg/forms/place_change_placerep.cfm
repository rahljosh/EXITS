<link rel="stylesheet" href="smg.css" type="text/css">

<cfif IsDefined('url.studentid')><cfelse>
	<cfset url.studentid = #client.studentid#>
</cfif>

<!--- Student Info --->
<cfinclude template="../querys/get_student_info.cfm">

<cfquery name="get_region_assigned" datasource="MySQL">
	SELECT regionname
	FROM smg_regions
	WHERE regionid = #get_student_info.regionassigned#
</cfquery>

<!--- get reps for students region --->
<cfinclude template="../querys/get_available_reps.cfm">

<!--- include template page header --->
<cfinclude template="placement_status_header.cfm">

<table width="580" align="center">
<tr><td><span class="application_section_header">Change Placing Representative</span></td></tr>
</table>

<table width="580" align="center">
<tr><td><cfoutput>The following Reps in #get_region_assigned.regionname# region are available for this student:</cfoutput></td></tr>
</table>

<cfform action="../querys/update_change_placerep.cfm?studentid=#client.studentid#" method="post">
<table width="580" align="center">
<tr><td>				
<cfselect name="placerepid">
	<option value="0">Select Rep</option>
	<cfoutput query="get_available_reps">
			<option value=#userid#>#firstname# #lastname# (#userid#)</option>
	</cfoutput>
	</cfselect>
</td></tr>
<tr><td>
	Please indicate why you are changing the placing representative:<br>
	<textarea cols=50 rows=7 name="reason"></textarea>
</td></tr>
</table>
<br>
<table width="580" align="center">
	<Tr>
		<td align="right" width="50%">
		<input name="submit" type="image" src="../pics/update.gif" align="right" border=0></cfform></td>
		<td align="left" width="50%">
		<input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()"></td>
	</tr>
</table>