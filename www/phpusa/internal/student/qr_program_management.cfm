<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Update Program Management</title>
<link rel="stylesheet" href="../phpusa.css" type="text/css">
</head>

<body>

<cftry> 

<cfparam name="form.companyid" default="6">

<!--- UPDATE CURRENT PROGRAMS --->
<cfloop From = "1" To = "#form.count#" Index = "x">
	<!--- CHECK IF ACTIVE BOX IS CHECKED --->
	<cfif IsDefined('form.active_#x#')>
		<!---
		<cfquery name="update_status" datasource="MySql">
			UPDATE php_students_in_program
			SET active = '0'
			WHERE studentid = '#form.studentid#'
		</cfquery>
		--->
		<cfquery name="update_active_program" datasource="MySQL">
			UPDATE php_students_in_program 
			SET active = '1'
			WHERE assignedid = '#form["assignedid_" & x]#'
			LIMIT 1
		</cfquery>
	</cfif>
</cfloop>

<!--- ADD NEW PROGRAM --->
<cfif form.new_program NEQ 0 AND form.new_status NEQ 'no'>
	<!--- NEW PROGRAM = ACTIVE / CURRENT PROGRAM = INACTIVE /  --->
	<!---
	<cfif form.new_status EQ 1>
		<cfquery name="update_status" datasource="MySql">
			UPDATE php_students_in_program
			SET active = '0'
			WHERE studentid = '#form.studentid#'
		</cfquery>
	</cfif>
	--->
	<cfquery name="add_student" datasource="MySql">
		INSERT INTO php_students_in_program 
			(studentid, companyid, programid, inputby, active, datecreated) 
		VALUES 
			('#form.studentid#', '#form.companyid#', '#form.new_program#', '#client.userid#', '#form.new_status#', #CreateODBCDate(now())#)		
	</cfquery>
</cfif>

<cfoutput>
<script language="JavaScript">
<!-- 
alert("You have successfully updated this page. Thank You.");
	location.replace("program_management.cfm?unqid=#form.unqid#");
-->
</script>
</cfoutput>

<cfcatch type="any">
	<table width="98%" class="box" bgcolor="##ffffff" align="center" cellpadding="3" cellspacing="0">
		<tr><td><cfinclude template="../error_message.cfm"></td></tr>
	</table>
</cfcatch> 
</cftry>

</body>
</html>