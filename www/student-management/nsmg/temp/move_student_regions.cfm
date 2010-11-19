<!---
	MOVE STUDENTS FROM REGION A TO REGION B AND CREATES A REGION HISTORY LOG
---->

Move Region/Program <br /><br />

<!--- REGION --->

<!----
<cfset RegionFrom = 1387>
<cfset RegionTo = 1157>
<cfset reason = "Moved as Per Bob Keegan request">

<cfquery name="qGetRegionTo" datasource="MySql">
    SELECT
        regionID,
        company
    FROM 
        smg_regions
    WHERE
        regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#RegionTo#">
</cfquery>

<cfquery name="qGetStudents" datasource="MySql">
    SELECT
        studentID,
        companyID,        
        regionAssigned,
        regionGuar,
        regionalGuarantee, <!--- rguarantee --->
        state_guarantee,
        jan_app       
    FROM 
        smg_students
    WHERE
        regionAssigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#regionFrom#">
</cfquery>

<cfloop query="qGetStudents">

	<cfquery name="region_history" datasource="MySql">
		INSERT INTO 
        	smg_regionhistory
		(
            studentid, 
            regionid, 
            rguarenteeid,	
            stateguaranteeid, 
            fee_waived, 
            reason, 
            changedby,  
            date
        )
		VALUES
			(
            	<cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudents.studentid#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudents.regionAssigned#">,
				<cfif qGetStudents.regionGuar EQ 'no'>
                    <cfqueryparam cfsqltype="cf_sql_integer" value="0">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="0">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="0">,
                <cfelse>
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudents.regionalGuarantee#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudents.state_guarantee#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudents.jan_app)#">,
                </cfif>
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#reason#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#">
			)
	</cfquery>
	
	<cfquery name="updStudent" datasource="MySql">
		UPDATE 
        	smg_students
		SET 
            companyiD = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRegionTo.company#">,
            regionAssigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRegionTo.regionID#">,
        	dateassigned = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#">
		WHERE 
        	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudents.studentid#">
	</cfquery>

</cfloop>

<cfoutput>
	#qGetStudents.recordCount# records updated.
</cfoutput>

--->



<!--- Program --->

<!--- 

<cfset programFrom = 252>
<cfset programTo = 254>
<cfset reason = "Moved as Per Bob Keegan request">

<cfquery name="qGetProgramTo" datasource="MySql">
    SELECT
        programID,
        companyID
    FROM 
        smg_programs
    WHERE
        programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#programTo#">
</cfquery>

<cfquery name="qGetStudents" datasource="MySql">
    SELECT 
    	s.studentID, 
        s.programID, 
        s.companyID, 
        p.programname
    FROM 
    	smg_regionhistory
    INNER JOIN 
    	smg_students s ON s.studentid = smg_regionhistory.studentid
    INNER JOIN 
    	smg_programs p ON p.programid = s.programid
    WHERE 
    	reason LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="Moved as Per Bob Keegan request">
</cfquery>

<cfloop query="qGetStudents">

	<cfquery name="programHistory" datasource="MySql">
		INSERT INTO 
        	smg_programhistory
		(
        	studentid, 
            programid, 
            reason, 
            changedby,  
            date
        )
		VALUES
        (
            <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudents.studentid#">, 
            <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudents.programID#">, 
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#reason#">, 
           	<cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">,
            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#"> 
        )
	</cfquery>
	
	<cfquery name="updStudent" datasource="MySql">
		UPDATE 
        	smg_students
		SET 
            companyiD = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudents.companyID#">,
            programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#programTo#">
		WHERE 
        	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudents.studentid#">
	</cfquery>

</cfloop>

<cfoutput>
	#qGetStudents.recordCount# records updated.
</cfoutput>
