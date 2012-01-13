<link rel="stylesheet" href="reports.css" type="text/css">

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<!--- get total students in each program according to the company --->
<cfquery name="qGetProgramLists" datasource="MySQL">
    SELECT 	
    	programname
    FROM	
    	smg_programs
    WHERE 
        programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#form.programID#" list="yes"> )
	<cfif CLIENT.companyID EQ 5>
        AND
            companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
    <cfelse>
        AND
            companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
    </cfif>
    ORDER BY 
        programname
</cfquery>

<table width='650' cellpadding=6 cellspacing="0" align="center">
<span class="application_section_header"><cfoutput>#companyshort.companyshort# - Total of Graduated Students<br> (12th grade)</cfoutput></span>
</table><br>

<!--- Get countries according to the program --->
<cfquery name="qGetResults" datasource="MySQL">
    SELECT
    	count(studentID) AS totalStudents,
        businessName
    FROM
    	(
    		<!--- Grade 12 --->
            SELECT 	
                s.studentID,
                u.businessName 
            FROM 	
                smg_students s
            INNER JOIN 
                smg_users u ON u.userID = s.intRep
            WHERE 	
                s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
            AND
                s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> )
            
			<cfif CLIENT.companyID EQ 5>
                AND
                    s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
            <cfelse>
                AND
                    s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
            </cfif>
            
            AND
                s.grades = <cfqueryparam cfsqltype="cf_sql_integer" value="12">

			UNION 
            
            <!--- Grade 11 for certain countries --->
            SELECT 	
                s.studentID,
                u.businessName 
            FROM 	
                smg_students s
            INNER JOIN 
                smg_users u ON u.userID = s.intRep
            WHERE 	
                s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
            AND
                s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> )
            
			<cfif CLIENT.companyID EQ 5>
                AND
                    s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
            <cfelse>
                AND
                    s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
            </cfif>
            
            AND
                s.grades = <cfqueryparam cfsqltype="cf_sql_integer" value="11">
            AND
                s.countryresident IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="49,237" list="yes"> )
        )  AS t 
                     
    GROUP BY 
        businessName
    ORDER BY    	
        businessName
</cfquery>

<cfoutput>
<!--- 0 students will skip the table --->
<cfif qGetResults.recordcount> 	
	<table width='650' cellpadding=6 cellspacing="0" align="center" frame="box">	
		<tr>
			<td colspan="2">Program(s): &nbsp;<br> <cfloop query="qGetProgramLists"><i><u>#programname# &nbsp;</u></i><br></cfloop></td>
		</tr>
		<tr><th width="75%">BusinessName</th> <th width="25%">Total</th></tr>
		<!--- Country Loop --->
 		<cfloop query="qGetResults">
			<tr><th width="75%">#businessName#</th><th width="25%" align="center">#totalStudents#</th></tr>
		</cfloop>
	</table>
	<br /><br />	
</cfif>

</cfoutput>