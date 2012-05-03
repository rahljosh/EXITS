
<!----
<cfparam name="URL.all" default="0">

<cfquery name="get_program" datasource="MYSQL">
	SELECT	
    	*
	FROM 	
    	smg_programs p
	INNER JOIN 
    	smg_companies c ON p.companyid = c.companyid
	LEFT JOIN 
    	smg_program_type t ON type = t.programtypeid
	WHERE
        p.companyid IN (<cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,5,10,12,13" list="yes">)
    AND	
    	p.is_deleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
	<cfif NOT VAL(URL.All)>
		AND
	        p.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
    </cfif>
	ORDER BY 
    	p.startdate DESC, 
        p.programname
</cfquery>
---->
<cfscript>
    	if ( CLIENT.companyid eq 13 OR client.companyid eq 14){
			get_program = APPCFC.PROGRAM.getPrograms(companyid=client.companyid,isActive=1);
		}
		else
			{
			get_program = APPCFC.PROGRAM.getPrograms(isActive=1);
		}
</cfscript>