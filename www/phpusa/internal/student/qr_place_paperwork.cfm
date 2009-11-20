<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Untitled Document</title>
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

<cftransaction action="BEGIN" isolation="SERIALIZABLE">

	<Cfquery name="paperwork" datasource="mysql">
		UPDATE php_students_in_program
			SET school_acceptance = <cfif form.school_acceptance NEQ ''>#CreateODBCDate(school_acceptance)#<cfelse>NULL</cfif>,
				sevis_fee_paid = <cfif form.sevis_fee_paid NEQ ''>#CreateODBCDate(sevis_fee_paid)#<cfelse>NULL</cfif>,
				i20received = <cfif form.i20received NEQ ''>#CreateODBCDate(i20received)#<cfelse>NULL</cfif>,
				hf_application = <cfif form.hf_application NEQ ''>#CreateODBCDate(hf_application)#<cfelse>NULL</cfif>,
				hf_placement = <cfif form.hf_placement NEQ ''>#CreateODBCDate(hf_placement)#<cfelse>NULL</cfif>
		WHERE assignedid = '#get_program_info.assignedid#'
		LIMIT 1
	</cfquery>
	
</cftransaction>

<cflocation url="place_paperwork.cfm?unqid=#get_student_unqid.uniqueid#&assignedid=#get_student_unqid.assignedid#" addtoken="no">	

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>

</body>
</html>
