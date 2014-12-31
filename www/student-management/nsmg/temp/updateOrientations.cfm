<cfquery name="qGetVFHostOrientation" datasource="#APPLICATION.DSN#">
	SELECT fk_studentID, dateAdded
    FROM virtualFolder
    WHERE fk_documentType = 48
    AND fk_studentID = (SELECT studentID FROM smg_students WHERE studentID = fk_studentID AND programID > 338)
    AND fk_studentID IN (SELECT studentID FROM smg_hosthistory WHERE host_arrival_orientation IS NULL AND isActive = 1)
    GROUP BY fk_studentID
    LIMIT 50
</cfquery>

<cfquery name="qGetVFStudentOrientation" datasource="#APPLICATION.DSN#">
	SELECT fk_studentID, dateAdded
    FROM virtualFolder
    WHERE fk_documentType = 49
    AND fk_studentID = (SELECT studentID FROM smg_students WHERE studentID = fk_studentID AND programID > 338)
    AND fk_studentID IN (SELECT studentID FROM smg_hosthistory WHERE stu_arrival_orientation IS NULL AND isActive = 1)
    GROUP BY fk_studentID
    LIMIT 50
</cfquery>

<cfoutput>
	<cfset totalHost = 0>
    <cfset totalStudent = 0>
	<cfloop query="qGetVFHostOrientation">
    	<cfquery datasource="#APPLICATION.DSN#" result="updatedHostOrientation">
        	UPDATE smg_hosthistory
            SET host_arrival_orientation = #dateAdded#
            WHERE studentID = #fk_studentID#
            AND host_arrival_orientation IS NULL 
            AND isActive = 1
        </cfquery>
		<cfset totalHost = totalHost + updatedHostOrientation.recordCount>
    </cfloop>
    <cfloop query="qGetVFStudentOrientation">
    	<cfquery datasource="#APPLICATION.DSN#" result="updatedStudentOrientation">
        	UPDATE smg_hosthistory
            SET stu_arrival_orientation = #dateAdded#
            WHERE studentID = #fk_studentID#
            AND stu_arrival_orientation IS NULL 
            AND isActive = 1
        </cfquery>
        <cfset totalStudent = totalStudent + updatedStudentOrientation.recordCount>
    </cfloop>
	
    #qGetVFHostOrientation.recordCount# - #totalHost#
    <br/>
    #qGetVFStudentOrientation.recordCount# - #totalStudent#
</cfoutput>