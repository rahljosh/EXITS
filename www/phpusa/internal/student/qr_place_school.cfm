<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Placement Management - High School</title>
</head>

<body>

<cftry>

<cfif NOT IsDefined('url.unqid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<!--- get student info by uniqueID --->
<cfinclude template="../querys/get_student_unqid.cfm">

<cfquery name="get_program_info" datasource="mysql">
	SELECT DISTINCT php.assignedid, php.arearepid, php.placerepid, php.schoolid, php.hostid
	FROM php_students_in_program php
	WHERE php.studentid = '#get_student_unqid.studentid#'
		AND php.assignedid = <cfqueryparam value="#form.assignedid#" cfsqltype="cf_sql_integer" maxlength="6"> 
		AND php.active = '1'
</cfquery>	

<!---  SELECT NEW SCHOOL --->
<cfif NOT IsDefined('url.change')>
	<cftransaction action="BEGIN" isolation="SERIALIZABLE">
		<Cfquery name="place_school" datasource="mysql">
			UPDATE php_students_in_program
				SET schoolid = '#form.schoolid#',
					dateplaced = #CreateODBCDate(now())#
			WHERE assignedid = '#get_program_info.assignedid#'
			LIMIT 1
		</cfquery>
	</cftransaction>
<!--- UPDATE/CHANGE CURRENT SCHOOL --->
<cfelse>
	<cftransaction action="BEGIN" isolation="SERIALIZABLE">
		<Cfquery name="place_school" datasource="mysql">
			UPDATE php_students_in_program
			SET schoolid = '#form.schoolid#',
				dateplaced = <cfif form.schoolid EQ '0'>NULL<cfelse>#CreateODBCDate(now())#</cfif>,
				school_acceptance = NULL,
				i20received = NULL,
				hf_placement = NULL,
				hf_application = NULL,
				doubleplace = '0'
			WHERE assignedid = '#get_program_info.assignedid#'
			LIMIT 1
		</cfquery>
	</cftransaction>
</cfif>

<cflocation url="place_menu.cfm?unqid=#get_student_unqid.uniqueid#&assignedid=#get_student_unqid.assignedid#" addtoken="no">	

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>

</body>
</html>