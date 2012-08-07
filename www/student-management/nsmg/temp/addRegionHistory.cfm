<cfsetting requesttimeout="9999">

<cfquery name="qGetStudents" datasource="#APPLICATION.DSN#">
	SELECT
    	s.studentID,
        s.regionAssigned
  	FROM
    	smg_students s
  	WHERE
    	s.active = 1
  	AND
    	s.regionAssigned != 0
  	AND
    	s.studentID NOT IN (SELECT studentID FROM smg_regionHistory)
</cfquery>

<cfoutput query="qGetStudents">
	<cfquery datasource="#APPLICATION.DSN#">
        INSERT INTO
            smg_regionHistory
            (
                studentID,
                regionID,
                fee_waived,
                reason,
                date
            )
      	VALUES
        	(
            	#studentID#,
                #regionID#,
                0,
                'Student was unassigned',
                #NOW()#
            )
    </cfquery>
</cfoutput>