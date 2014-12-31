<cfsetting requesttimeout="9999">

<cfquery name="qGetPlacedStudents" datasource="#APPLICATION.DSN#">
    SELECT
    	studentID,
        historyID,
        hostID,
        datePlaced,
        dateRelocated,
        isRelocation,
        dateArrived
    FROM
        (
            SELECT 
                s.studentID,
                h.historyID,
                h.hostID,
                h.datePlaced,
                h.dateRelocated,
                h.isRelocation,
                (
                    SELECT 
                        dep_date 
                    FROM 
                        smg_flight_info 
                    WHERE 
                        studentID = s.studentID 
                    AND 
                        flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="arrival"> 
                    AND
                        programID = s.programID
                    AND 
                        isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                    ORDER BY 
                        dep_date ASC,
                        dep_time ASC
                    LIMIT 1                            
                )  AS dateArrived
            FROM
                smg_students s
            INNER JOIN
                smg_hosthistory h ON h.studentID = s.studentID
                    AND
                        h.assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                    AND
                        h.hostID = s.hostID 
                    AND
                    	h.isActive = <cfqueryparam cfsqltype="cf_sql_integer" value="1">  
            WHERE 
                s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,5,10,12" list="yes"> )
			AND
            	s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">     
		) AS t
	WHERE
    	datePlaced > dateArrived    
    AND
    	isRelocation =  <cfqueryparam cfsqltype="cf_sql_integer" value="0">   
	ORDER BY
    	studentID               
</cfquery>

<cfscript>
	vTotalRecords = 0;
</cfscript>

<cfoutput>
	
    <table style="border:1px solid ##999;">
    	<tr>
        	<td>Student ID</td>
            <td>Date Arrived</td>
            <td>Date Placed</td>
            <td>Date Relocated</td>
		</tr>            
    
        <cfloop query="qGetPlacedStudents">
            
            <cfquery name="qIsOnlyRecord" datasource="#APPLICATION.DSN#">
                SELECT
                    historyID
                FROM
                    smg_hosthistory
                WHERE
                    studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetPlacedStudents.studentID#">
                AND
                    hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetPlacedStudents.hostID#">
                AND
                    historyID != <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetPlacedStudents.historyID#">           
            </cfquery>        
            
            <cfif NOT VAL(qIsOnlyRecord.recordCount)>
    
                <cfscript>
                    vTotalRecords++;
                </cfscript>

                <tr>
                    <td>#qGetPlacedStudents.studentID#</td>
                    <td>#DateFormat(qGetPlacedStudents.dateArrived,'mm/dd/yy')#</td>
                    <td>#DateFormat(qGetPlacedStudents.datePlaced,'mm/dd/yy')#</td>
                    <td>#DateFormat(qGetPlacedStudents.dateRelocated,'mm/dd/yy')#</td>
                </tr>            
    
            </cfif>
        
        </cfloop>
	
    </table>
    
	<p>Total of #vTotalRecords# of students</p>
        
</cfoutput>

<p>Relocation flag and date updated</p>
