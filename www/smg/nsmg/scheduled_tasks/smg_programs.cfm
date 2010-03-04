<!--- Kill Extra Output --->
<cfsilent>

	<!--- SET PROGRAMS TO INACTIVE --->
    <cfquery name="qGetExpiredPrograms" datasource="MySql">
        SELECT	
            programID
        FROM 
            smg_programs p
        WHERE 
            p.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND	
            p.companyID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,5,10,12" list="yes">)
        AND        
            DATE_ADD(p.endDAte, INTERVAL 90 DAY) < now()
        ORDER BY 
            p.programname
    </cfquery>
    
    <cfif VAL(qGetExpiredPrograms.recordCount)>
    
        <cfquery datasource="MySql">
            UPDATE 
                smg_programs 
            SET 
                active = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
            WHERE 
                programid IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#ValueList(qGetExpiredPrograms.programID)#" list="yes">)
        </cfquery>
    
    </cfif>
    <!--- END OF SET PROGRAMS TO INACTIVE --->

</cfsilent>