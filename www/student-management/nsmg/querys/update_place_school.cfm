<cfquery name="double_check_placement" datasource="MySQL">
    select hostid, dateplaced, arearepid, placerepid, schoolid, studentid
    from smg_students
    where studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.studentid#">
</cfquery>

<cfquery name="check_history" datasource="MySql">
    SELECT historyid, schoolid, studentid, hostid
    FROM smg_hosthistory
    WHERE studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.studentid#">
</cfquery>

<cfif VAL(double_check_placement.schoolid)> <!--- THERE'S A SCHOOL --->
    A school was assigned to this student on #double_check_placement.dateplaced#.
<cfelse>

    <cftransaction action="BEGIN" isolation="SERIALIZABLE">
    
        <Cfquery name="place_school" datasource="MySQL">
            UPDATE 
            	smg_students
            SET 
            	schoolid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.schoolid#">
            WHERE 
            	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.studentid#">
            LIMIT 1
        </cfquery>
        
        <cfif double_check_placement.arearepid is not '0' AND double_check_placement.hostid is not '0' AND double_check_placement.placerepid is not '0' AND check_history.recordcount is '0'>
        
            <cfquery name="create_original_placement" datasource="MySql">
                INSERT INTO smg_hosthistory	(hostid, studentid, schoolid, orignal_place, dateofchange, arearepid, placerepid, changedby, reason)
                values('#double_check_placement.hostid#', '#double_check_placement.studentid#', '#FORM.schoolid#', 'yes',
                #CreateODBCDateTime(now())#, '#double_check_placement.arearepid#', '#double_check_placement.placerepid#', '#CLIENT.userid#','Original Placement')
            </cfquery>
        
        </cfif>		
    
    </cftransaction>

</cfif>

<cflocation url="../forms/place_menu.cfm?studentid=#CLIENT.studentid#" addtoken="no">