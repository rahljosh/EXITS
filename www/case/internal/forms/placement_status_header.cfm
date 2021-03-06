<link rel="stylesheet" href="../smg.css" type="text/css">
<link rel="stylesheet" href="profile.css" type="text/css">

<!--- Student Info --->
<cfinclude template="../querys/get_student_info.cfm">

<cfquery name="get_region_assigned" datasource="caseusa">
	SELECT smg_students.regionassigned, smg_regions.regionname
	FROM smg_students 
	RIGHT JOIN smg_regions on smg_students.regionassigned = smg_regions.regionid
	WHERE studentid = #client.studentid#
</cfquery>

<!--- SET GRAY IMAGES --->
<cfset host_image = 'host_1'>
<cfset school_image = 'school_1'>
<cfset place_image = 'place_1'>
<cfset super_image = 'super_1'>
<cfset double_image = 'double_1'>
<cfset paperwork_image = 'paperwork_1'>
<cfset notes_image = 'notes_1'>

<cfoutput query="get_student_info">

<!--- It's not complete --->
<cfif hostid is '0' and (schoolid NEQ '0' or arearepid NEQ '0' or placerepid NEQ '0')><cfset host_image = 'host_2'></cfif>
<cfif schoolid is '0' and (hostid NEQ '0' or arearepid NEQ '0' or placerepid NEQ '0')><cfset school_image = 'school_2'></cfif>
<cfif placerepid is '0' and (hostid NEQ '0' or schoolid NEQ '0' or arearepid NEQ '0')><cfset place_image = 'place_2'></cfif>
<cfif arearepid is '0' and (hostid NEQ '0' or schoolid NEQ '0' or placerepid NEQ '0')><cfset super_image = 'super_2'></cfif>

<!--- PLACEMENT BUTTONS --->
<cfif hostid NEQ '0'><cfset host_image = 'host_3'></cfif>
<cfif schoolid NEQ '0'><cfset school_image = 'school_3'></cfif>
<cfif placerepid NEQ '0'><cfset place_image = 'place_3'></cfif>
<cfif arearepid NEQ '0'><cfset super_image = 'super_3'></cfif>
<cfif doubleplace NEQ '0'><cfset double_image = 'double_3'></cfif>

<!--- PAPERWORK --->
<cfif hostid NEQ '0'>
	<!--- CHECK CBCS --->
	<cfquery name="get_host" datasource="caseusa">
		SELECT hostid, familylastname, fatherfirstname, fatherlastname, fatherdob, 
			motherfirstname, motherlastname, motherdob
		FROM smg_hosts
		WHERE hostid = '#get_student_info.hostid#'
	</cfquery>
	<!--- CHECK CBCS --->
	<cfquery name="get_host_members" datasource="caseusa">
		SELECT childid, membertype, name, lastname, birthdate, cbc_form_received
		FROM smg_host_children  
		WHERE hostid = '#get_student_info.hostid#'
			AND (DATEDIFF(now(), birthdate)/365) > 18
			AND liveathome = 'yes'
	</cfquery>

	<cfset member_missing = 0>
	<cfloop query="get_host_members">
		<cfif cbc_form_received EQ ''>
			<cfset member_missing = member_missing + 1>
		</cfif>
	</cfloop>

	<cfif date_pis_received NEQ '' AND doc_full_host_app_date NEQ '' AND doc_letter_rec_date NEQ ''
		AND doc_rules_rec_date NEQ '' AND doc_photos_rec_date NEQ '' AND doc_school_accept_date NEQ ''
		AND doc_school_profile_rec NEQ '' AND doc_conf_host_rec NEQ '' AND doc_ref_form_1 NEQ ''
		AND doc_ref_form_2 NEQ '' AND member_missing EQ 0>	
		<cfif stu_arrival_orientation NEQ '' AND host_arrival_orientation NEQ ''>
			<cfset paperwork_image = 'paperwork_4'>  <!--- paperwork complete image --->
		<cfelse>
			<cfset paperwork_image = 'paperwork_3'>  <!--- paperwork docs complete missing orientations --->
		</cfif>
	<cfelse>
		<cfset paperwork_image = 'paperwork_2'>  <!--- paperwork incomplete image --->
	</cfif>
</cfif>

<!--- PLACEMENT NOTES --->
<cfif placement_notes EQ ''>
	<cfset notes_image = 'notes_1'>
<cfelse>
	<cfset notes_image = 'notes_3'>
</cfif>

<title>Placement Management</title>

<table width="580" align="center" >
<tr><td><span class="application_section_header">#get_student_info.firstname# #get_student_info.familylastname# (#get_student_info.studentid#)</span></td></tr>
</table>
<P></P>
<table width="580" border="0" bgcolor="##ffffe6" class="nav_bar" cellpadding="2" align="center">
<tr bgcolor="##ffffe6"><td colspan="7" align="center">
	Placement Status &nbsp; : &nbsp;
	<cfif get_student_info.hostid is '0' and get_student_info.schoolid is '0' and get_student_info.arearepid is '0' and get_student_info.placerepid is '0'>
		<u><i>U N P L A C E D</i></u>
	<cfelse>
		<cfif get_student_info.hostid is '0' or get_student_info.schoolid is '0' or get_student_info.arearepid is '0' or get_student_info.placerepid is '0'>
		&nbsp; <u><b>I N C O M P L E T E</b></u>
		<cfelse>
		&nbsp; <u><b>C O M P L E T E</b></u>
		</cfif>
	</cfif>
	</td></tr>
<tr bgcolor="##ffffe6">
	<td width="86" align="center"><a href="place_host.cfm?studentid=#client.studentid#"><img src="../pics/place_menu/#host_image#.gif"  alt="Host Family" border="0"></a></td>
	<td width="86" align="center"><a href="place_school.cfm?studentid=#client.studentid#"><img src="../pics/place_menu/#school_image#.gif"  alt="High School" border="0"></a></td>
	<td width="86" align="center"><a href="place_placerep.cfm?studentid=#client.studentid#"><img src="../pics/place_menu/#place_image#.gif"  alt="Placing Representative" border="0"></a></td>		
	<td width="86" align="center"><a href="place_superep.cfm?studentid=#client.studentid#"><img src="../pics/place_menu/#super_image#.gif"  alt="Supervising Representative" border="0"></a></td>
	<td width="86" align="center"><a href="place_double.cfm?studentid=#client.studentid#"><img src="../pics/place_menu/#double_image#.gif"  alt="Double Placement" border="0"></a></td>
	<td width="86" align="center"><a href="place_paperwork.cfm?studentid=#client.studentid#&update=no"><img src="../pics/place_menu/#paperwork_image#.gif"  alt="Placement Paperwork" border="0"></a></td>
	<td width="86" align="center"><a href="place_notes.cfm?studentid=#client.studentid#&update=no"><img src="../pics/place_menu/#notes_image#.gif"  alt="Placement Notes" border="0"></a></td>
</tr>
<tr bgcolor="##ffffe6"><td colspan="7" align="center"><a href="place_menu.cfm"><b><u>M A I N &nbsp; M E N U</u></b></a></td></tr>
<tr bgcolor="##ffffe6"><td colspan="7" align="center">Use the menu above to browse through the sections.</td></tr>
</table>
</cfoutput>
<table width="580" align="center">
<tr><td><hr align="left"></td></tr>
</table>