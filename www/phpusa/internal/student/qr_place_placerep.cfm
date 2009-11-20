<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Placement Management - Host Family</title>
</head>

<body>

<!--- <cftry> --->

<cfif NOT IsDefined('url.unqid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<!--- get student info by uniqueID --->
<cfinclude template="../querys/get_student_unqid.cfm">

<cfquery name="check_history" datasource="mysql">
	SELECT historyid, schoolid, studentid, hostid
	FROM smg_hosthistory
	WHERE studentid = '#get_student_unqid.studentid#'
</cfquery>

<cfquery name="boarding_school" datasource="mysql">
	SELECT schoolid, schoolname, boarding_school
	FROM php_schools
	WHERE schoolid = '#get_student_unqid.schoolid#'
</cfquery>

<!---  SELECT NEW PLACING --->
<cfif NOT IsDefined('url.change')>
	
	<cftransaction action="BEGIN" isolation="SERIALIZABLE">

		<cfquery name="get_program_info" datasource="mysql">
			SELECT DISTINCT php.assignedid, php.arearepid, php.placerepid, php.schoolid, php.hostid
			FROM php_students_in_program php
			WHERE php.studentid = '#get_student_unqid.studentid#'
				AND php.assignedid = <cfqueryparam value="#form.assignedid#" cfsqltype="cf_sql_integer" maxlength="6"> 
				AND php.active = '1'
		</cfquery>	
		
		<Cfquery name="place_rep" datasource="mysql">
			UPDATE php_students_in_program
				SET placerepid = '#form.placerepid#'
			WHERE assignedid = '#get_program_info.assignedid#'
			LIMIT 1
		</cfquery>
		
		<!--- Creating Original Placement - Boarding school = no host family --->
		<cfif check_history.recordcount EQ '0' AND boarding_school.boarding_school EQ '1' AND get_student_unqid.arearepid NEQ '0' AND form.placerepid NEQ '0'>
			<cfquery name="create_original_placement" datasource="mysql">
				INSERT INTO smg_hosthistory	(hostid, studentid, schoolid, original_place, dateofchange, arearepid, placerepid, changedby, reason)
				values('0', '#get_student_unqid.studentid#', '#get_program_info.schoolid#', 'yes',
				 #CreateODBCDateTime(now())#, '#get_program_info.arearepid#', '#form.placerepid#', '#client.userid#', 'Original Placement')
			</cfquery>
		<cfelseif check_history.recordcount EQ '0' AND get_student_unqid.hostid NEQ '0' AND get_student_unqid.arearepid NEQ '0' AND form.placerepid NEQ '0'>
			<cfquery name="create_original_placement" datasource="mysql">
				INSERT INTO smg_hosthistory	(hostid, studentid, schoolid, original_place, dateofchange, arearepid, placerepid, changedby, reason)
				values('#get_program_info.hostid#', '#get_student_unqid.studentid#', '#get_program_info.schoolid#', 'yes',
				 #CreateODBCDateTime(now())#, '#get_program_info.arearepid#', '#form.placerepid#', '#client.userid#', 'Original Placement')
			</cfquery>
		</cfif>	
	</cftransaction>

<!--- UPDATE/CHANGE CURRENT PLACING --->
<cfelse>


</cfif>

<cflocation url="place_menu.cfm?unqid=#get_student_unqid.uniqueid#&assignedid=#get_student_unqid.assignedid#" addtoken="no">	

<!--- <cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>
 --->
