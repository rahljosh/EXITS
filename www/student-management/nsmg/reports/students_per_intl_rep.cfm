<link rel="stylesheet" href="reports.css" type="text/css">

<!--- Get Program --->
<cfquery name="get_program" datasource="MYSQL">
	SELECT	DISTINCT 
		p.programid, p.programname, 
		c.companyshort
	FROM 	smg_programs p
	INNER JOIN smg_companies c ON c.companyid = p.companyid
	WHERE 		
		programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#form.programid#" list="yes"> )
</cfquery>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<!--- get Students  --->
<Cfquery name="get_students" datasource="MySQL">
	SELECT 
    	s.studentid, 
        s.countryresident, 
        s.firstname, 
        s.familylastname, 
        s.intrep, 
        s.programid, 
        s.sex, 
        s.dateapplication, 
        s.dob,
		s.schoolID,
        u.userid, 
        u.businessname, 
        u.email, 
		p.programid, 
        p.programname,
		r.regionname, 
        r.regionid,
		countryname,
		h.familylastname as hostfamily,
		english.name as englishcamp, 
		orientation.name as orientationcamp,
        fac.firstName as facFirstName,
        fac.lastName as facLastName
	FROM 
    	smg_students s
	INNER JOIN 
    	smg_users u ON s.intrep = u.userid
	INNER JOIN 
    	smg_programs p	ON s.programid = p.programid
	LEFT OUTER JOIN 
    	smg_countrylist c ON s.countryresident = c.countryid
	LEFT OUTER JOIN 
    	smg_regions r ON s.regionassigned = r.regionid 
	LEFT OUTER JOIN 
    	smg_hosts h ON s.hostid = h.hostid		
	LEFT OUTER JOIN 
    	smg_aypcamps english ON s.aypenglish = english.campid
	LEFT OUTER JOIN 
    	smg_aypcamps orientation ON s.ayporientation = orientation.campid
	LEFT OUTER JOIN
    	smg_users fac ON fac.userID = r.regionFacilitator
    WHERE
        s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#form.programid#" list="yes"> )
    
        <cfif CLIENT.companyID EQ 5>
	        AND
	            s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,5,12" list="yes"> )        
        <cfelse>
	        AND
	            s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">        
        </cfif>        
        
        <cfif form.active EQ 1> <!--- active --->
            AND 
                s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.active#">
        <cfelseif form.active EQ '0'> <!--- inactive --->
            AND 
                canceldate IS NULL
        <cfelseif form.active EQ '2'> <!--- canceled --->
            AND canceldate IS NOT NULL
        </cfif>  
        <cfif form.intrep NEQ 0>
            AND
                s.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.intrep#">
        </cfif>
        <cfif form.status is 1>
            AND 
                s.hostid != <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
            AND 
                s.host_fam_approved <= <cfqueryparam cfsqltype="cf_sql_integer" value="4"> <!--- placed --->
        <cfelseif form.status EQ 2>
            AND 
                s.hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="0"> <!--- unplaced --->
        </cfif>
        <cfif form.preayp is 'all'>
            AND 
                (
                    s.aypenglish = english.campid 
                OR 
                    s.ayporientation = orientation.campid
                )
        <cfelseif form.preayp is 'english'>
            AND 
                s.aypenglish = english.campid
        <cfelseif form.preayp is 'orientation'>
            AND 
                s.ayporientation = orientation.campid
        </cfif>
    ORDER BY 
        u.businessname, 
        s.firstname, 
        s.familylastname
</cfquery>  

<table width='90%' cellpadding=6 cellspacing="0" align="center">
	<tr>
    	<td><span class="application_section_header"><cfoutput>#companyshort.companyshort# -  Students per International Rep.</cfoutput></span></td>
	</tr>        
</table>
<br>

<cfoutput>
<table width='90%' cellpadding=6 cellspacing="0" align="center" frame="box">
<tr><td align="center">
	<div align="center">Program(s) Included in this Report:</div><br>
	<cfloop query="get_program"><b>#programname# &nbsp; (#ProgramID#)</b><br></cfloop>
	<div align="center">Total of <cfif form.active EQ 1>Active<cfelseif form.active EQ '0'>Inactive<cfelseif form.active EQ '2'>Canceled</cfif> Students 
	<cfif form.status is 1><b>placed</b></cfif><cfif form.status is 2><b>unplaced</b></cfif> in report: &nbsp; #get_students.recordcount#</div>
	<cfif form.preayp is not 'none'><br>Pre-AYP #form.preayp# camp students</cfif>
</td></tr>
</table>
</cfoutput><br>

<table width='90%' cellpadding=6 cellspacing="0" align="center" frame="box">	
<tr><th width="75%">International Representative</th> <th width="25%">Total</th></tr>
</table><br>

<cfif form.preayp is 'none'>		
	<cfoutput query="get_students" group="intrep">
		<table width='90%' cellpadding=6 cellspacing="0" align="center" frame="box">	
			<tr><th width="75%"><a href="mailto:#email#">#businessname#</a></th>
				<cfquery name="get_total" dbtype="query">
				   SELECT studentid
				   FROM get_students
				   WHERE intrep = #intrep#
				 </cfquery>
                 
                <Cfquery name="qSchoolDates" datasource="MySQL">
                        SELECT year_begins
                        FROM smg_school_dates
                        INNER JOIN smg_programs p ON p.seasonid = smg_school_dates.seasonid
                        WHERE schoolid = <cfqueryparam value="#get_students.schoolid#" cfsqltype="cf_sql_integer">
                        AND p.programid = <cfqueryparam value="#get_students.programid#" cfsqltype="cf_sql_integer">
                 </cfquery>
                 					
				<td width="25%" align="center">#get_total.recordcount#</td></tr>
			</table>
			<table width='90%' frame="below" cellpadding=6 cellspacing="0" align="center">
				<tr>
                	<td width="6%" align="center"><b>ID</b></th>
					<td width="18%"><b>Student</b></td>
					<td width="8%" align="center"><b>Sex</b></td>
					<td width="8%" align="center"><b>DOB</b></td>
					<td width="12%"><b>Country</b></td>
					<cfif form.status is 1>
						<td width="12%"><b>Family</b></td>
					<cfelse>
						<td width="12%"><b>Region</b></td>
					</cfif>			
					<td width="16%"><b>Facilitator</b></td>
					<td width="12%"><b>School Start Date</b></td>
                    <td width="8%"><b>Entry Date</b></td>
             </tr>
			 <cfoutput>					
				<tr bgcolor="#iif(get_students.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
					<td align="center">#studentid#</td>
					<td>#firstname# #familylastname#</td>
					<td align="center">#sex#</td>
					<td align="center">#DateFormat(DOB, 'mm/dd/yyyy')#</td>
					<td>#countryname#</td>
					<cfif form.status is 1>
						<td>#hostfamily#</td>	
					<cfelse>
						<td>#regionname#</td>	
					</cfif>		
                    <td>#facFirstName# #facLastName#</td>			
					<td>#DateFormat(qSchoolDates.year_begins, 'mm/dd/yyyy')#</td>
                    <td>#DateFormat(dateapplication, 'mm/dd/yyyy')#</td></tr>							
			</cfoutput>	
			</table><br>
	</cfoutput><br>
    
<!--- pre ayp cfif --->
<cfelse>

	<cfoutput query="get_students" group="intrep">
			<table width='90%' cellpadding=6 cellspacing="0" align="center" frame="box">	
			<tr><th width="75%"><a href="mailto:#email#">#businessname#</a></th>
				<cfquery name="get_total" dbtype="query">
				   SELECT studentid
				   FROM get_students
				   WHERE intrep = #intrep#
				 </cfquery>					
				<td width="25%" align="center">#get_total.recordcount#</td></tr>
			</table>
			<table width='90%' frame="below" cellpadding=6 cellspacing="0" align="center">
				<tr><td width="6%" align="center"><b>ID</b></th>
					<td width="18%"><b>Student</b></td>
					<td width="8%" align="center"><b>Sex</b></td>
					<td width="8" align="center"><b>DOB</b></td>
					<td width="12%"><b>Country</b></td>
					<cfif form.status is 1>
						<td width="12%"><b>Family</b></td>
					<cfelse>
						<td width="12%"><b>Region</b></td>
					</cfif>			
					<td width="16%"><b>Facilitator</b></td>
                    <td width="12%"><b>Entry Date</b></td>
					<td width="%8%"><b>Pre-AYP Camp</b></td>
                </tr>
			 <cfoutput>					
				<tr bgcolor="#iif(get_students.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
					<td align="center">#studentid#</td>
					<td>#firstname# #familylastname#</td>
					<td align="center">#sex#</td>
					<td>#DateFormat(DOB, 'mm/dd/yyyy')#</td>
					<td>#countryname#</td>
					<cfif form.status is 1>
						<td>#hostfamily#</td>	
					<cfelse>
						<td>#regionname#</td>	
					</cfif>	
                    <td>#facFirstName# #facLastName#</td>					
					<td>#DateFormat(dateapplication, 'mm/dd/yyyy')#</td>
					<td>#englishcamp# #orientationcamp#</td></tr>							
			</cfoutput>	
			</table><br>
	</cfoutput><br>			
</cfif><!--- pre ayp cfif --->
			

