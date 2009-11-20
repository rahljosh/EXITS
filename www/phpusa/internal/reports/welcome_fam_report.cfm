<!--- Kill Extra Output --->
<cfsilent>
	
    <!--- Param Form Variables ---->
    <cfparam name="FORM.programID" default="0">
    
    <!-----Company Information----->
    <cfinclude template="../querys/get_company_short.cfm">
   
    <!--- Get Program --->
    <cfquery name="qGetPrograms" datasource="MYSQL">
        SELECT	
        	*
        FROM 	
        	smg_programs 
        LEFT JOIN 
        	smg_program_type ON type = programtypeid
        WHERE 	
        	(
            	<cfloop list="#FORM.programID#" index="prog">
                	programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#prog#">
                	<cfif ListLast(FORM.programID) NEQ prog> OR </cfif>
                </cfloop> 
             )
    </cfquery>
    
</cfsilent>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Welcome Family Report</title>
</head>
<link rel="stylesheet" href="reports.css" type="text/css">

<body>

<cfoutput>

    <table width="100%" cellpadding="4" cellspacing="0" align="center">
    	<tr>
        	<th><span class="application_section_header">#companyshort.companyshort# - Current Welcome Family Report</span></th>
        </tr>
    </table>
    
    <br>
    
    <table width="100%" cellpadding="4" cellspacing="0" align="center" frame="box">
        <tr><td align="center">
            Program(s) Included in this Report:<br>
            <cfloop query="qGetPrograms"><b>#programname# &nbsp; (###ProgramID#)</b><br></cfloop>
        </td></tr>
    </table>
    
    <br>

	<cfloop query="qGetPrograms">
		
        <cfquery name="qGetStudents" datasource="MySql">
            SELECT DISTINCT 
                stu_prog.programid,
                s.studentid, 
                s.firstname, 
                s.familylastname,
                smg_programs.programname,
                u.businessname,
                h.hostid, 
                h.familylastname as hostlastname, 
                h.motherfirstname, 
                h.motherlastname, 
                h.fatherfirstname, 
                h.fatherlastname,
                h.address, 
                h.city, 
                h.zip, 
                h.state,
                sc.schoolid, 
                sc.schoolname
            FROM 
                smg_students s
            INNER JOIN 
                php_students_in_program stu_prog ON stu_prog.studentid = s.studentid
            INNER JOIN 
                smg_hosts h ON h.hostid = stu_prog.hostid
			INNER JOIN 
            	php_schools sc ON sc.schoolid = stu_prog.schoolid            
            INNER JOIN 
                smg_programs ON smg_programs.programid = stu_prog.programid
            INNER JOIN 
                smg_users u on u.userid = s.intrep 
            WHERE 
                stu_prog.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#"> 
            AND 
                stu_prog.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            AND 
                stu_prog.programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetPrograms.programid#">
            AND 
                stu_prog.is_welcome_family = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            ORDER BY 
                familylastname
        </cfquery>	

        <table width="95%" cellpadding="0" cellspacing="0" align="center" frame="below">	
            <tr><td><b>Program #programname#</b> &nbsp; &nbsp; &nbsp; Total of #qGetStudents.recordcount# student(s)</td></tr>	
        </table>
        
        <br>
        
        <table width="95%" cellpadding="0" cellspacing="0" align="center" frame="below">	
            <tr>
                <td width="25%"><b>Student</b></td>
                <td width="25%"><b>Host Family</b></td>
                <td width="25%"><b>Address</b></td>
                <td width="25%"><b>School</b></td>
            </tr>
        </table>
        
        <br>
            
        <table width="95%" cellpadding=2 cellspacing="0" align="center" frame="below">	
            <cfloop query="qGetStudents">
                <tr bgcolor="#iif(currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
                    <td width="25%">#firstname# #familylastname# (###studentid#)</td>
                    <td width="25%">
                        <cfif motherlastname NEQ ''>
                        	#motherfirstname# #motherlastname#
                        <cfelseif fatherlastname NEQ ''>
                        	#fatherfirstname# #fatherlastname#</cfif>
                        (###hostid#)
                    </td>			
                    <td width="25%">#address#, #city# #state# #zip#</td>
                    <td width="25%">#schoolname# (###schoolid#)</td>
                </tr>            
            </cfloop>
            
            <cfif NOT VAL(qGetStudents.recordCount)>
            	<tr>
                	<td>
                    	There are no students that match your criteria in this program.
                    </td>
				</tr>                                    
            </cfif>								
        </table>
        
        <br>

	</cfloop>

</cfoutput>
</body>
</html>