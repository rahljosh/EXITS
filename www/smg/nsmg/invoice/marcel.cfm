<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Untitled Document</title>
</head>

<body>

<cfquery name="getProg" datasource="MySQL">
SELECT programid, programname, startdate, enddate, type
FROM smg_programs
WHERE companyid = 1
</cfquery>

<cfloop query="getProg">

	<!---
	<cfquery name="getProg2" datasource="MySQL">
	SELECT programid, programname
	FROM smg_programs
	WHERE companyid <> 1
	AND programname LIKE '#getProg.programname#'
	</cfquery>
	--->

	<cfquery name="getProg2" datasource="MySQL">
	SELECT programid, programname
	FROM smg_programs
	WHERE companyid <> 1
	AND startdate LIKE '#dateformat(getProg.startdate, "yyyy-mm-dd")#'
	AND enddate LIKE '#dateformat(getProg.enddate, "yyyy-mm-dd")#'
	AND type = #getProg.type#
	</cfquery>
	
	<cfset programList = ValueList(getProg2.programid)>
	
	<cfif getProg2.recordCount>
	
		<cfquery name="getProg2" datasource="MySQL">
		UPDATE smg_students
		SET programid = #getProg.programid#
		WHERE programid IN (#programList#)
		</cfquery>
	
		<cfquery name="getProg2" datasource="MySQL">
		UPDATE smg_programs
		SET is_deleted = 1
		WHERE programid IN (#programList#)
		</cfquery>
	
	</cfif>

</cfloop>



</body>
</html>
