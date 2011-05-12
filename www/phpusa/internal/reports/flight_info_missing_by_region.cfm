<cfinclude template="../querys/get_company_short.cfm">

<link rel="stylesheet" href="../profile.css" type="text/css">
<link rel="stylesheet" href="../reports.css" type="text/css">

<style type="text/css">
table.nav_bar { font-size: 10px; background-color: #ffffff; border: 1px solid #999999; }
.style3 {font-size: 13px}
</style>

<cfsetting requestTimeOut = "300">

<!--- Get Program --->
<cfquery name="get_program" datasource="MYSQL">
	SELECT	*
	FROM 	smg_programs p
	INNER JOIN smg_companies c ON p.companyid = c.companyid
	LEFT JOIN smg_program_type ON type = programtypeid
	WHERE <cfloop list=#form.programid# index='prog'>
			p.programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
		</cfloop>
</cfquery>




<cfoutput>
<span class="application_section_header">#companyshort.companyshort# - Missing Arrival Flight Information</span><br>

<table width='100%' cellpadding=4 cellspacing="0" align="center" bgcolor="FFFFFF" frame="box">
	<tr><td class="style3"><b>Program(s) :</b><br> 
	<cfloop query="get_program"><i>#get_program.companyshort# &nbsp; #get_program.programname#</i><br></cfloop></td></tr>
</table><br>


	<cfquery name="get_students" datasource="MySql">
	SELECT 	s.studentid, s.firstname, s.familylastname, s.arearepid, p.dateplaced,	intrep.businessname,
			pro.programname, p.programid
	FROM smg_students s 
	INNER JOIN php_students_in_program p ON s.studentid = p.studentid
    INNER JOIN smg_programs pro on pro.programid = p.programid
	INNER JOIN smg_users intrep ON s.intrep = intrep.userid
	
	WHERE s.active = 1 
			
			AND	( <cfloop list=#form.programid# index='prog'>
					s.programid = #prog# 
					<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
				</cfloop> )
			AND s.studentid NOT IN (SELECT studentid FROM smg_flight_info WHERE flight_type =  'arrival')		
		
        
        <cfif form.place_date1 is not '' and form.place_date2 is not ''>
        	AND dateplaced between #CreateODBCDate(form.place_Date1)# and #CreateODBCDate(form.place_Date2)#
        </cfif>
		
	GROUP BY s.studentid
	ORDER BY intrep.businessname, s.firstname
	</cfquery>
    
	
	<cfif get_students.recordcount is '0'><cfelse>
	<table border="1" align="center" width='100%' bordercolor="C0C0C0" valign="top" cellpadding="3" cellspacing="1">
		<tr><td class="style3" colspan="2"> Total of #get_students.recordcount# student(s)</tr>
	</table><br>
	
	<table width=100% border=0 cellpadding=6 cellspacing="2" align="center" bgcolor="FFFFFF">
		<tr>
			<th width="28%" align="left">Student</th>
			<th width="16%" align="left">Int. Rep</th>

            <th align="Center">Date Placed</th>
		</tr>
		<cfloop query="get_students">
			<tr bgcolor="#iif(get_students.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
				<td>#firstname# #familylastname# (#studentid#)</td>
				<td>#businessname#</td>
				
                <td align="Center">#DateFormat(dateplaced,'mm/dd/yyyy')#</td>	
			</tr>
		</cfloop>
	</table><br>
	</cfif>

</cfoutput>