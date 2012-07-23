<cfsetting requesttimeout="99999">

<cfquery name="qGetStudents" datasource="MySql">
	SELECT
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

<cfoutput>Number of students updated: #qGetStudents.recordCount#<br />Students updated:<br /></cfoutput>
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