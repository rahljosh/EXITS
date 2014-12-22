<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../reports/reports.css" type="text/css">
<title>Flight Arrival x School Acceptance</title>
</head>

<body>

<cfsetting requestTimeOut = "300">

<cfif NOT IsDefined('form.programid')>
	You must select a program in order to run the report.
	<!--- <cfinclude template="../forms/error_message.cfm"> --->
	<cfabort>
</cfif>

<!--- Get Program --->
<cfquery name="qGetSelectedPrograms" datasource="MYSQL">
	SELECT	
    	*
	FROM 	
    	smg_programs 
	LEFT JOIN 
    	smg_program_type ON type = programtypeid
	WHERE 
    	programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#form.programid#" list="yes"> )
</cfquery>

<cfquery name="qGetStudents" datasource="MySql">
    SELECT DISTINCT 
        s.studentid, 
        s.countryresident, 
        s.firstname, 
        s.familylastname, 
        s.sex, 
        s.programid, 
        sh.placerepid,
        sh.dateplaced, 
        sh.hostid, 
        sh.doc_school_accept_date,
        u.firstname as repfirstname, 
        u.lastname as replastname, 
        u.userid,
        fi.dep_date
    FROM 
        smg_students s
    INNER JOIN
    	smg_hosthistory sh ON sh.studentID = s.studentID
        	AND
            	sh.isActive = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
    LEFT JOIN 
        smg_users U on u.userid = s.placerepid
    INNER JOIN 
        smg_flight_info fi ON fi.studentid = s.studentid 
          AND 
              fi.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
          AND
              fi.flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="arrival">                 
    WHERE 
        s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1"> 
    AND             
        s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#form.programid#" list="yes"> )
	AND	
    	sh.doc_school_accept_date IS NULL    
    GROUP BY 
        s.studentid
    ORDER BY 
        dep_date, 
        repfirstname
</cfquery>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<cfoutput>
<table width="670" cellpadding=3 cellspacing="0" align="center">
	<tr><td><span class="application_section_header">#companyshort.companyshort# - Students with Arrival Information and  Missing School Acceptance (Place Management)</span></td></tr>
</table><br>

<table width="670" cellpadding=3 cellspacing="0" align="center" frame="box">
	<tr><td align="center">
		Program(s) Included in this Report:<br>
		<cfloop query="qGetSelectedPrograms"><b>#programname# &nbsp; (#ProgramID#)</b><br></cfloop>
		</td>
	</tr>
	<tr><td>PS: This report lists STUDENTS with flight arrival information that do not have school acceptance letter.</td></tr>
</table><br>

	<table width="670" frame=below cellpadding=3 cellspacing="0" align="center" frame="border">
	<tr>
		<td width="25%"><b>Placement Rep:</b></td>
		<td width="30%"><b>Student</b></th>
		<td width="15%"><b>Placement Date</b></td>
		<td width="15%"><b>Arrival Date</b></td>
		<td width="15%"><b>School Acceptance</b></td>
	</tr>	
	<cfloop query="qGetStudents">			
        <tr bgcolor="#iif(qGetStudents.currentRow MOD 2 ,DE("ededed") ,DE("white") )#">			
            <td><cfif hostid EQ 0>Unplaced <cfelseif repfirstname EQ '' and replastname EQ ''><font color="red">Missing or Unknown</font><cfelse><u>#repfirstname# #replastname# (###userid#)</u></cfif></td>
            <td>#firstname# #familylastname# (###studentid#)</td>
            <td><cfif hostid EQ 0>Unplaced<cfelse>#DateFormat(dateplaced, 'mm/dd/yyyy')#</cfif></td>
            <td><cfif dep_date NEQ ''>#DateFormat(dep_date, 'mm/dd/yyyy')#<cfelse><font color="red">Missing</font></cfif></td>
            <td><cfif doc_school_accept_date NEQ ''>#DateFormat(doc_school_accept_date, 'mm/dd/yyyy')#<cfelse><font color="red">Missing</font></cfif></td>
        </tr>
	</cfloop>
	</table><br>
	
<br>
</cfoutput>

</body>
</html>