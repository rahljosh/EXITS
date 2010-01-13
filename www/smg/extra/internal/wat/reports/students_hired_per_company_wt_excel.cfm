<cfreport format="EXCEL" filename="mydir/students_hired_per_company.xls" overwrite = "yes"/>

<style type="text/css">
.style1 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 10px;
	padding:2;
}
.style2 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 8px;
	padding:2;
}
.title1 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 15px;
	color: #000000;
	font-weight: bold;
	padding:5;
}
</style>

<cfquery name="students_hired" datasource="mysql">
	select c.firstname, c.candidateid,c.lastname, c.sex, c.home_country,c.email, c.earliestarrival, c.programid, c.intrep, c.ssn, c.passport_date, c.passport_expires, c.passport_number, c.wat_vacation_start, c.wat_vacation_end, c.startdate, c.enddate, c.wat_placement, c.status,
	p.programname, c.ds2019,
	u.businessname,
	smg_countrylist.countryname
	FROM extra_candidates c
	LEFT JOIN smg_programs p on p.programid = c.programid
	LEFT JOIN smg_users u on u.userid = c.intrep
	LEFT JOIN smg_countrylist on smg_countrylist.countryid = c.home_country
	WHERE c.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
	<cfif VAL(URL.hostCompanyID)>
	    AND c.hostcompanyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.hostCompanyID#">
    </cfif>
	AND c.programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.program#">
	AND c.wat_placement = <cfqueryparam cfsqltype="cf_sql_varchar" value="CSB-Placement">
	AND c.status != <cfqueryparam cfsqltype="cf_sql_varchar" value="canceled">
</cfquery> 

<cfquery name="get_candidates_self" datasource="mysql">
  	SELECT extra_candidates.firstname, extra_candidates.lastname, extra_candidates.candidateid, extra_candidates.home_country, extra_candidates.email, extra_candidates.placedby, extra_candidates.sex, extra_candidates.hostcompanyid, extra_hostcompany.name, extra_candidates.ds2019, extra_candidates.wat_vacation_Start, extra_candidates.wat_vacation_end, extra_candidates.wat_placement, extra_candidates.startdate, extra_candidates.enddate, 
		smg_countrylist.countryname, smg_users.businessname
  	FROM extra_candidates
	INNER JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = extra_candidates.hostcompanyid
  	INNER JOIN smg_programs ON smg_programs.programid = extra_candidates.programid
  	INNER JOIN smg_users ON smg_users.userid = extra_candidates.intrep
	LEFT JOIN smg_countrylist on smg_countrylist.countryid = extra_candidates.home_country
 	WHERE extra_candidates.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
	<cfif VAL(URL.hostCompanyID)>
	    AND extra_candidates.hostcompanyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.hostCompanyID#"> 
	</cfif>
    AND extra_candidates.programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.program#">
	AND extra_candidates.wat_placement = <cfqueryparam cfsqltype="cf_sql_varchar" value="Self-Placement">
	AND extra_candidates.status != <cfqueryparam cfsqltype="cf_sql_varchar" value="canceled">
</cfquery>

<cfset total = get_candidates_self.recordcount + students_hired.recordcount>

<cfquery name="program_info" datasource="mysql">
	select programname
	from smg_programs
	where programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.program#">
</cfquery> 

<cfquery name="host_company_info" datasource="mysql">
	select name
	from extra_hostcompany
	<cfif VAL(URL.hostCompanyID)>
    	where hostcompanyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.hostCompanyID#"> 
    </cfif>
</cfquery> 

<cfoutput>


<img src="../../pics/black_pixel.gif" width="100%" height="2">
<div class="title1">Students hired per company</div>
<img src="../../pics/black_pixel.gif" width="100%" height="2">
<table width="95%" align="center">
	<tr>
		<td width="50%">
			<div class="style1"><strong>Program:</strong> #program_info.programname#</div>
			<div class="style1"><strong>Host Company:</strong> #host_company_info.name# </div>
		</td>
		<td width="50%">
			<div class="style1"><strong>CSB-Placement:</strong> #students_hired.recordcount#</div>
			<div class="style1"><strong>Self-Placement:</strong> #get_candidates_self.recordcount#</div>
			<div class="style1"><strong>Total Number of Students:</strong> #total#</div>
		</td>
	</tr>
</table>

<img src="../../pics/black_pixel.gif" width="100%" height="2">

<table width=100% cellpadding="4" cellspacing=0> 
	<tr>
		<Th align="left" class="style1">Student</font></Th>
		<th align="left" class="style1">Sex</font></th>
		<th align="left" class="style1">Country</font></th>
		<th align="left" class="style1">Email</font></th>
		<th align="left" class="style1">Start Date </font></th>
		<th align="left" class="style1">End Date</font></th>
		<th align="left" class="style1">International Agent</font></th>
		<th align="left" class="style1">Option</font></th>
	</tr>
	<tr>
  	<td colspan=8><img src="../../pics/black_pixel.gif" width="100%" height="2"></td>
  </tr>
	<cfloop query="students_hired">
	<tr <cfif students_hired.currentrow mod 2>bgcolor="##E4E4E4"</cfif>>
		<td valign="top" class="style1">#firstname# #lastname# (#candidateid#)</font></td>
		<td valign="top" class="style1">#sex#</font></td>
		<td valign="top" class="style1">#countryname#</font></td>
		<td valign="top" class="style1">#email#</font></td>
		
		<cfif ds2019 is not ''>
		<td valign="top" class="style1"><!----#passport_number#---->#dateformat (startdate, 'mm/dd/yyyy')#</font></td>
		<td valign="top" class="style1">#dateformat (enddate, 'mm/dd/yyyy')# </font></td>
		<Cfelse>
		<td colspan=2 align="center" class="style1">Awaiting DS-2019</td>
		</cfif>
		
		<td valign="top" class="style1">#businessname#</font></td>
		<td valign="top" class="style1">#wat_placement#</font></td>
	</tr>
	</cfloop>
	
	<cfloop query="get_candidates_self">
	<tr <cfif get_candidates_self.currentrow mod 2>bgcolor="##E4E4E4"</cfif>>
		<td valign="top" class="style1">#firstname# #lastname# (#candidateid#)</font></td>
		<td valign="top" class="style1">#sex#</font></td>
		<td valign="top" class="style1">#countryname#</font></td>
		<td valign="top" class="style1">#email#</font></td>
		
		<cfif ds2019 is not ''>
		<td valign="top" class="style1"><!----#passport_number#---->#dateformat (startdate, 'mm/dd/yyyy')#</font></td>
		<td valign="top" class="style1">#dateformat (enddate, 'mm/dd/yyyy')# </font></td>
		<Cfelse>
		<td colspan=2 align="center"  class="style1">Awaiting DS-2019</td>
		</cfif>
		
		<td valign="top" class="style1">#businessname#</font></td>
		<td valign="top" class="style1">#wat_placement#</font></td>
	</tr>
	</cfloop>
</table>
<img src="../../pics/black_pixel.gif" width="100%" height="2">
<Br><br>
<span class="style2">Report Prepared on #DateFormat(now(), 'dddd, mmm, d, yyyy')#</span>
</cfoutput>

