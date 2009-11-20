<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../phpusa.css" type="text/css">
<title>Placement Status</title>
</head>

<body>

<cfif NOT IsDefined('url.unqid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<!--- Get Student Info by UniqueID --->
<cfinclude template="../querys/get_student_unqid.cfm">

<cfquery name="boarding_school" datasource="mysql">
	SELECT schoolid, schoolname, boarding_school
	FROM php_schools
	WHERE schoolid = '#get_student_unqid.schoolid#'
</cfquery>

<!--- SET GRAY IMAGES --->
<cfset host_image = 'host_1'>
<cfset school_image = 'school_1'>
<cfset place_image = 'place_1'>
<cfset super_image = 'super_1'>
<cfset double_image = 'double_1'>
<cfset paperwork_image = 'paperwork_1'>
<cfset notes_image = 'notes_1'>

<cfoutput query="get_student_unqid">

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
	<!---
	<cfif date_pis_received NEQ '' and doc_full_host_app_date NEQ '' and doc_letter_rec_date NEQ ''
	and doc_rules_rec_date NEQ '' and doc_photos_rec_date NEQ '' and doc_school_accept_date NEQ ''
	and doc_school_profile_rec NEQ '' and doc_conf_host_rec NEQ '' and doc_ref_form_1 NEQ ''
	and doc_ref_form_2 NEQ ''>
		<cfset paperwork_image = 'paperwork_3'>  <!--- paperwork complete image --->
	<cfelse>
		<cfset paperwork_image = 'paperwork_2'>  <!--- paperwork incomplete image --->
	</cfif>
	--->
	<cfset paperwork_image = 'paperwork_2'>  <!--- paperwork incomplete image --->
</cfif>

<!--- PLACEMENT NOTES --->
<cfif placement_notes EQ ''>
	<cfset notes_image = 'notes_1'>
<cfelse>
	<cfset notes_image = 'notes_3'>
</cfif>

<title>Placement Management</title>

<table width="580" align="center">
	<tr><td><span class="application_section_header">Student: #get_student_unqid.firstname# #get_student_unqid.familylastname# (###get_student_unqid.studentid#)</span></td></tr>
</table>

<table width="580" border="0" cellpadding="2" align="center" bgcolor="##ffffff" class="box">
	<tr bgcolor="##C2D1EF"><td colspan="7" align="center">
		Placement Status &nbsp; : &nbsp;
		<u><i><b>
		<cfif (boarding_school.boarding_school EQ '1' AND get_student_unqid.placerepid NEQ '0' AND get_student_unqid.arearepid NEQ '0') OR (hostid NEQ '0' AND schoolid NEQ '0' AND placerepid NEQ '0' AND arearepid NEQ '0')> 
			P L A C E D
		<cfelseif hostid NEQ '0' OR schoolid NEQ '0' OR placerepid NEQ '0' OR arearepid NEQ '0'>
			I N C O M P L E T E
		<cfelse>
			U N P L A C E D
		</cfif>
		</b></i></u>
		</td>
	</tr>
	<tr>
		<td width="86" align="center"><a href="place_school.cfm?unqid=#get_student_unqid.uniqueid#&assignedid=#get_student_unqid.assignedid#"><img src="../pics/place_menu/#school_image#.gif"  alt="High School" border="0"></a></td>
		<td width="86" align="center"><a href="place_host.cfm?unqid=#get_student_unqid.uniqueid#&assignedid=#get_student_unqid.assignedid#"><img src="../pics/place_menu/#host_image#.gif"  alt="Host Family" border="0"></a></td>
		<td width="86" align="center"><a href="place_placerep.cfm?unqid=#get_student_unqid.uniqueid#&assignedid=#get_student_unqid.assignedid#"><img src="../pics/place_menu/#place_image#.gif"  alt="Placing Representative" border="0"></a></td>		
		<td width="86" align="center"><a href="place_superep.cfm?unqid=#get_student_unqid.uniqueid#&assignedid=#get_student_unqid.assignedid#"><img src="../pics/place_menu/#super_image#.gif"  alt="Supervising Representative" border="0"></a></td>
		<td width="86" align="center"><a href="place_double.cfm?unqid=#get_student_unqid.uniqueid#&assignedid=#get_student_unqid.assignedid#"><img src="../pics/place_menu/#double_image#.gif"  alt="Double Placement" border="0"></a></td>
		<td width="86" align="center"><a href="place_paperwork.cfm?unqid=#get_student_unqid.uniqueid#&update=no&assignedid=#get_student_unqid.assignedid#"><img src="../pics/place_menu/#paperwork_image#.gif"  alt="Placement Paperwork" border="0"></a></td>
		<td width="86" align="center"><a href="place_notes.cfm?unqid=#get_student_unqid.uniqueid#&update=no&assignedid=#get_student_unqid.assignedid#"><img src="../pics/place_menu/#notes_image#.gif"  alt="Placement Notes" border="0"></a></td>
	</tr>
	<tr><td colspan="7" align="center"><a href="place_menu.cfm?unqid=#get_student_unqid.uniqueid#"><b><u>M A I N &nbsp; M E N U</u></b></a></td></tr>
	<tr><td colspan="7" align="center">Use the menu above to browse through the sections.</td></tr>
</table><br>
</cfoutput>

</body>
</html>