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

<cfquery name="get_host_state" datasource="MySql">
SELECT state
FROM smg_hosts
WHERE hostid = '#get_student_info.hostid#'
</cfquery>

<cfquery name="get_available_schools" datasource="MySQL">
SELECT *
FROM smg_schools
WHERE state = '#get_host_state.state#'
ORDER BY schoolname
</cfquery>

<!--- include template page header --->
<cfinclude template="placement_status_header.cfm">

<table width="580" align="center">
<tr><td><span class="application_section_header">Change School</span></td></tr>
</table>

<table width="580" align="center">
<tr><td>	
<cfoutput>The following schools in the state of #get_host_state.state# are available for this student:</cfoutput>
</td></tr>
</table>

<cfform action="../querys/update_change_school.cfm?studentid=#client.studentid#" method="post">
<table width="580" align="center">
<tr><td>				
<cfselect name="schoolid">
	<option value="0">Select a School</option>
	<cfoutput query="get_available_schools">
	<option value=#schoolid#>			
	#schoolname# (#schoolid#)
	</option>
	</cfoutput>
	</cfselect>
</td></tr>
<tr><td>
	Please indicate why you are changing the school:<br>
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