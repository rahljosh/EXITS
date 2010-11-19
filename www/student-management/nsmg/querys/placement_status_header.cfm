<link rel="stylesheet" href="../smg.css" type="text/css">
<link rel="stylesheet" href="profile.css" type="text/css">

<!--- Student Info --->
<cfinclude template="../querys/get_student_info.cfm">

<cfquery name="get_region_assigned" datasource="MySQL">
	SELECT smg_students.regionassigned, smg_regions.regionname
	FROM smg_students 
	RIGHT JOIN smg_regions on smg_students.regionassigned = smg_regions.regionid
	WHERE studentid = #client.studentid#
</cfquery>

<!--- nothing has been done --->
<cfset host_image = 'host_1'>
<cfset school_image = 'school_1'>
<cfset place_image = 'place_1'>
<cfset super_image = 'super_1'>
<cfset double_image = 'double_1'>

<!--- It's not complete --->
<cfif get_student_info.hostid is '0' and (get_student_info.schoolid is not '0' or get_student_info.arearepid is not '0' or get_student_info.placerepid is not '0')>
	<cfset host_image = 'host_2'></cfif>

<cfif get_student_info.schoolid is '0' and (get_student_info.hostid is not '0' or get_student_info.arearepid is not '0' or get_student_info.placerepid is not '0')>
	<cfset school_image = 'school_2'></cfif>

<cfif get_student_info.placerepid is '0' and (get_student_info.hostid is not '0' or get_student_info.schoolid is not '0' or get_student_info.arearepid is not '0')>
	<cfset place_image = 'place_2'></cfif>

<cfif get_student_info.arearepid is '0' and (get_student_info.hostid is not '0' or get_student_info.schoolid is not '0' or get_student_info.placerepid is not '0')>
	<cfset super_image = 'super_2'></cfif>

<!--- complete --->
<cfif get_student_info.hostid is not '0'><cfset host_image = 'host_3'></cfif>

<cfif get_student_info.schoolid is not '0'><cfset school_image = 'school_3'></cfif>

<cfif get_student_info.placerepid is not '0'><cfset place_image = 'place_3'></cfif>

<cfif get_student_info.arearepid is not '0'><cfset super_image = 'super_3'></cfif>

<cfif get_student_info.doubleplace is not '0'><cfset double_image = 'double_3'></cfif>

<title>Placement Management</title>

<cfoutput>
<table width="480">
<tr><td><span class="application_section_header">#get_student_info.firstname# #get_student_info.familylastname# (#get_student_info.studentid#)</span></td></tr>
</table>
</cfoutput>
<P></P>
<cfoutput>
<table width="480" class="nav_bar">
<tr><td colspan="5" align="center" bgcolor="D5DCE5">
	Placement Status &nbsp; : &nbsp;
	<cfif get_student_info.hostid is '0' and get_student_info.schoolid is '0' and get_student_info.arearepid is '0' and get_student_info.placerepid is '0'>
	<u><i>Unplaced</i></u>
	<cfelse>
		<cfif get_student_info.hostid is '0' or get_student_info.schoolid is '0' or get_student_info.arearepid is '0' or get_student_info.placerepid is '0'>
		<u><i>Incomplete</i></u>
		<cfelse>
		<u><i>Complete</i></u>
		</cfif>
	</cfif>
	</td></tr>
<tr><cfoutput>
	<td width="96"><a href="../forms/place_host.cfm?studentid=#client.studentid#"><img src="../pics/#host_image#.jpg"  alt="" border="0"></a></td>
	<td width="96"><a href="../forms/place_school.cfm?studentid=#client.studentid#"><img src="../pics/#school_image#.jpg"  alt="" border="0"></a></td>
	<td width="96"><a href="../forms/place_placerep.cfm?studentid=#client.studentid#"><img src="../pics/#place_image#.jpg"  alt="" border="0"></a></td>		
	<td width="96"><a href="../forms/place_superep.cfm?studentid=#client.studentid#"><img src="../pics/#super_image#.jpg"  alt="" border="0"></a></td>
	<td width="96"><a href="../forms/place_double.cfm?studentid=#client.studentid#"><img src="../pics/#double_image#.jpg"  alt="" border="0"></a></td>
	</cfoutput>
</tr>
<tr><td colspan="5" align="center"><a href="../forms/place_menu.cfm">Main Menu</a></td></tr>
<tr><td colspan="5" align="center" bgcolor="D5DCE5">Use the menu above to browse through the sections.</td></tr>
</table>
</cfoutput>
<table width="480">
<tr><td><hr align="left"></td></tr>
</table>