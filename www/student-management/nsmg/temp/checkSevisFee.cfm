
<cfquery name="qGetIntlAgents" datasource="MySql">
    SELECT
        u.userID,
        u.firstName,
        u.lastName,
		u.accepts_sevis_fee,
        u.businessName
    FROM 
		smg_students s
	INNER JOIN       
    	smg_users u ON u.userID = s.intRep  
	INNER JOIN
    	smg_programs p ON p.programID = s.programID AND p.seasonID = 7 <!--- 10/11 --->        
	WHERE
    	s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
	AND
    	u.accepts_sevis_fee = ''        
</cfquery>

<cfdump var="#qGetIntlAgents#">