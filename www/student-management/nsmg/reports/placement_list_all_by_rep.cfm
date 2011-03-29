<cfparam name="FORM.active" default="1">
<cfparam name="FORM.programID" default="">

<cfquery name="qGetPrograms" datasource="MySQL">
    SELECT 	
        programname, companyshort
    FROM	
        smg_programs
    INNER JOIN 
        smg_companies ON smg_programs.companyid = smg_companies.companyid
    WHERE 
        programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programid#" list="yes"> )
    ORDER BY 
        programname
</cfquery>

<cfquery name="qGetUsers" datasource="MySql">
	SELECT 
    	count(s.studentid) as total, 
        s.placerepid, 
        u.firstname, 
        u.lastname,
        u.companyid 
	FROM 
    	smg_students s
	INNER JOIN 
    	smg_users u ON s.placerepid = u.userid
	WHERE 
    	s.canceldate is null
    AND	
        s.programid  IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programid#" list="yes"> )
	<cfif CLIENT.companyID EQ 5>
        AND
            s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="$APPLICATION.SETTINGS.COMPANYLIST.ISE$" list="yes"> )
    <cfelse>
        AND
            s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
    </cfif>
	GROUP BY 
    	s.placerepid
	ORDER BY 
    	u.firstname
</cfquery>

<link rel="stylesheet" href="../smg.css" type="text/css">
<cfif not LEN(FORM.programid)>
	<table width='100%' cellpadding=6 cellspacing="0" align="center" frame="box">
	<tr><td align="center">
	<h1>Sorry, It was not possible to proccess you request at this time due the program information was not found.<br>
	Please close this window and be sure you select at least one program from the programs list before you run the report.</h1>
	<center><input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()"></center>
	</td></tr>
	</table>
	<cfabort>
</cfif>

<span class="application_section_header">Placement Report</span><br>

<table width='100%' cellpadding=2 cellspacing="0" align="center" frame="box">	
<tr><td colspan="2"><div align="justify">
	Program(s): &nbsp; &nbsp;
	<cfoutput query="qGetPrograms"><i><u>#programname# &nbsp; &nbsp; / &nbsp; &nbsp;</u></i></cfoutput>
	</div></td>
</tr>
</table><br>

<table width='100%' cellpadding=2 cellspacing="0" align="center" frame="below">
	<tr bgcolor="CCCCCC"><th width="75%">Representative</th><th width="25%">Total</th></tr>
</table>
<table width='100%' cellpadding=2 cellspacing="0" align="center" frame="below">
<tr><td width="40%">Student</td><td width="20%">Company</td><td width="20%">Program</td><td width="20%">Region Assigned</td></tr>
</table><br>

<cfoutput query="qGetUsers">
<table width='100%' cellpadding=2 cellspacing="0" align="center" frame="box">
	<tr bgcolor="CCCCCC"><th width="75%">#firstname# #lastname# (#placerepid#)</th><th width="25%">#total#</th></tr>
</table>
 	<cfquery name="qGetStudents" datasource="MySql">
        SELECT 
        	s.firstname, 
            s.familylastname, 
            s.studentid, 
            s.regionassigned, 
            p.programname, 
            c.companyshort, 
            r.regionname
        FROM 
        	smg_students s
        INNER JOIN 
        	smg_programs p ON s.programid = p.programid
        INNER JOIN 
        	smg_companies c ON s.companyid = c.companyid
        INNER JOIN 
        	smg_regions r ON s.regionassigned = r.regionid
        WHERE 
        	s.canceldate is null 
        AND 
        	placerepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetUsers.placerepid#">
        AND	
            s.programid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programid#" list="yes"> )
        <cfif CLIENT.companyID EQ 5>
            AND
                s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="$APPLICATION.SETTINGS.COMPANYLIST.ISE$" list="yes"> )
        <cfelse>
            AND
                s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
		</cfif>
        ORDER BY 
            companyshort, 
            regionname, 
            familylastname
	</cfquery>

<Table width=100% frame=below cellpadding=2 cellspacing="0" >
	<cfloop query="qGetStudents">
	<tr bgcolor="#iif(qGetStudents.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
		<td width="40%">#firstname# #familylastname# (#studentid#)</td>
		<td width="20%">#companyshort#</td><td width="20%">#programname#</td>
		<td width="20%">#regionname#</td>
	</tr>
	</cfloop>
</table><br>
</cfoutput>