<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Update Program History</title>
</head>

<body>

<cfsetting requesttimeout="99999">

<cfquery name="qGetStudents" datasource="MySql">
	SELECT
    	COUNT(s.studentID) AS number,
    	s.studentID,
        s.programID
	FROM
    	smg_students s
   	LEFT OUTER JOIN
    	smg_programHistory sph ON sph.studentID = s.studentID
    WHERE
    	s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
   	AND
    	s.programid != <cfqueryparam cfsqltype="cf_sql_integer" value="0">
    AND
        sph.studentID IS NULL
</cfquery>

<cfoutput>Number of students updated: #qGetStudents.number#<br />Students updated:<br /></cfoutput>
<cfloop query="qGetStudents">
	<cfoutput>#studentid#<br /></cfoutput>
  	<cfquery name="program_history" datasource="MySql">
        INSERT INTO smg_programhistory
            (
            studentID, 
            programID, 
            reason, 
            changedby,  
            date
            )
        VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#studentID#">, 
                <cfqueryparam cfsqltype="cf_sql_integer" value="#programID#">, 
               	<cfqueryparam cfsqltype="cf_sql_varchar" value="Student was unassigned">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#"> 
            )
	</cfquery>
</cfloop>
</body>
</html>