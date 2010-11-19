<!--- Kill Extra Output ---><br />
<cfsilent>

	<cfparam name="FORM.programID" default="">
    <cfparam name="FORM.active" default="1">
    
    <!--- Get Program --->
    <cfquery name="qGetProgram" datasource="MYSQL">
        SELECT	
            p.programid, 
            p.programname
        FROM 	
            smg_programs p
        LEFT JOIN 
            smg_program_type ON p.type = programtypeid
        WHERE
            programid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programid#" list="yes"> ) 
        ORDER BY 
            p.programname
    </cfquery>
    
    <!-----Company Information----->
    <cfinclude template="../querys/get_company_short.cfm">
    
    <!--- get total students in program --->
    <cfquery name="qGetTotalStudents" datasource="MySQL">
        SELECT	
            studentid, 
            hostid
        FROM 	
            smg_students
        WHERE 
            companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        AND        
            hostid != <cfqueryparam cfsqltype="cf_sql_integer" value="0">
        AND 
            host_fam_approved <= <cfqueryparam cfsqltype="cf_sql_integer" value="4">
        AND 
            programid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programid#" list="yes"> ) 
        <!--- inactive --->        
        <cfif FORM.active EQ 0> 
            AND 
                active = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
        <!--- active --->        
        <cfelseif FORM.active EQ 1> 
            AND 
                active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        <!--- canceled --->        
        <cfelseif FORM.active EQ 2>
            AND 
                canceldate IS NOT NULL
        </cfif>
    </cfquery>

	<cfquery name="qTotalPlaced" datasource="MySQL">
		SELECT 
        	DISTINCT count( s.studentid ) AS totalPlaced
		FROM 
        	smg_students s
		LEFT JOIN 
        	smg_users u ON s.placerepid = u.userid
		WHERE 
        	s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
		AND            
            s.hostid != <cfqueryparam cfsqltype="cf_sql_integer" value="0">
        AND 
            s.host_fam_approved <= <cfqueryparam cfsqltype="cf_sql_integer" value="4">
        AND 
            s.programid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programid#" list="yes"> ) 		
        <cfif FORM.active EQ 0> <!--- inactive --->
            AND
                 s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
        <cfelseif FORM.active EQ 1> <!--- active --->
            AND 
                s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        <cfelseif FORM.active EQ 2> <!--- canceled --->
            AND 
                s.canceldate IS NOT NULL
        </cfif>
        GROUP BY 
        	placerepid
		ORDER BY 
        	totalPlaced
	</cfquery>

    <cfquery name="qTotalPerRep" datasource="MySQL">
        SELECT DISTINCT 
            count( s.studentid ) AS totalPlaced, 
            u.userid
        FROM 
            smg_students s
        LEFT JOIN 
            smg_users u ON s.placerepid = u.userid
        WHERE 
            s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        AND
            s.hostid != <cfqueryparam cfsqltype="cf_sql_integer" value="0">
        AND 
            s.host_fam_approved <= <cfqueryparam cfsqltype="cf_sql_integer" value="4">
        AND 
            s.programid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programid#" list="yes"> ) 		
        <cfif FORM.active EQ 0> <!--- inactive --->
            AND
                 s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
        <cfelseif FORM.active EQ 1> <!--- active --->
            AND 
                s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        <cfelseif FORM.active EQ 2> <!--- canceled --->
            AND 
                s.canceldate IS NOT NULL
        </cfif>
        GROUP BY 
            s.placerepid
        ORDER BY 
            totalPlaced
    </cfquery>
    
</cfsilent>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Total Placements</title>
<link rel="stylesheet" href="reports.css" type="text/css">
</head>
<body>

<cfif NOT LEN(FORM.programid)>
	<table width='100%' cellpadding=6 cellspacing="0" align="center" frame="box">
	<tr><td align="center">
	<h1>Sorry, It was not possible to proccess you request at this time due the program information was not found.<br>
	Please close this window and be sure you select at least one program from the programs list before you run the report.</h1>
	<center><input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()"></center>
	</td></tr>
	</table>
	<cfabort>
</cfif>

<cfoutput>

<table width="50%" cellpadding=6 cellspacing="0" align="center">
<span class="application_section_header">#companyshort.companyshort# - TOTAL Placements</span>
</table><br>

<table width="50%" cellpadding=6 cellspacing="0" align="center" frame="box">
<tr><td align="center">
	Program(s) Included in this Report:<br>
	<cfloop query="qGetProgram"><b>#programname# &nbsp; (###ProgramID#)</b><br></cfloop>
	Total of <cfif FORM.active EQ 0>inactive<cfelseif FORM.active EQ 1>active<cfelseif FORM.active EQ 2>canceled</cfif> Students <b>placed</b> in program: #qGetTotalStudents.recordcount#
	</td></tr>
</table><br>

<!--- table header --->
<table width="50%" cellpadding=6 cellspacing="0" align="center" frame="box">	
	<tr><th width="50%">Total of Placements</th><th width="50%" align="center">Total of Reps</th></tr>

	<cfloop query="qTotalPlaced">
		
		<cfset cur_placed = qTotalPlaced.totalPlaced>
		
		<cfset calc_total_reps = 0>
	 		
		<cfloop query="qTotalPerRep">
			<cfif qTotalPerRep.totalPlaced EQ cur_placed>
				<cfset calc_total_reps = calc_total_reps + 1>
			</cfif>	
		</cfloop>
		<tr><td align="center">#qTotalPlaced.totalPlaced#</td><td align="center">#calc_total_reps#</td></tr>
	</cfloop>
	
</table><br>

</cfoutput>

</body>
</html>