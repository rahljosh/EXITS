<cfif not IsDefined('form.programid')>
	<table align="center" width="90%" cellpadding=6 cellspacing="0">
	<tr><td>An error has ocurred and the report could not be generated. Please go back and try again.</td></tr>
	<tr><td align="center"><input type="image" value="close window" src="pics/back.gif" onClick="javascript:history.back()"></td></tr>
	</table><br>
	<cfabort>
</cfif>

<!--- get company region --->
<cfquery name="get_region" datasource="MySQL">
	SELECT	regionname, company, regionid
	FROM smg_regions
	WHERE company = '#client.companyid#'
	<cfif NOT IsDefined('form.inactive')>AND active = '1'</cfif>
	ORDER BY regionname
</cfquery>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<cfquery name="get_program" datasource="MYSQL">
	SELECT	ProgramID, programname, startdate, enddate, companyid, type,
			programtype
	FROM 	smg_programs 
	LEFT JOIN smg_program_type ON type = programtypeid
	WHERE 
    	programid IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes">)
</cfquery>

<cfquery name="get_stu_in_prog" datasource="MySQL">
	SELECT	 count(studentid) as count_stu
	FROM 	smg_students
	<cfif form.continent NEQ 0>INNER JOIN smg_countrylist c ON countryresident = c.countryid</cfif>
	WHERE onhold_approved <= '4'
    AND 
    	canceldate IS NULL
    AND 
    	active = 1
    AND 
      programid IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes">)
    <cfif form.continent NEQ 0>AND c.continent = '#form.continent#'</cfif>
</cfquery>

<cfquery name="get_stu_placed" datasource="MySQL">
	SELECT	 count(studentid) as count_stu
	FROM 	smg_students
	<cfif form.continent NEQ 0>INNER JOIN smg_countrylist c ON countryresident = c.countryid</cfif>
	WHERE hostid != '0' 
		AND host_fam_approved < '5'
		AND onhold_approved <= '4'
        AND active = 1
		AND canceldate IS NULL
        AND 
          programid IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes">)
		<cfif isDate(FORM.date_host_fam_approved)>
			AND date_host_fam_approved <= #CreateODBCDate(form.date_host_fam_approved)#
		</cfif>
		<cfif form.continent NEQ 0>AND c.continent = '#form.continent#'</cfif>
</cfquery>

<!--- <cfif not isDefined('url.graphics')><cfset url.graphics = 'no'></cfif> --->
<cfoutput>
<span class="application_section_header">#companyshort.companyshort# Program Statistics</span><br>

<table align="center" width="90%" cellpadding=6 cellspacing="0" frame="box">
<tr><td align="left">
	&nbsp &nbsp Program(s) : &nbsp <br>
	<cfloop query="get_program">&nbsp &nbsp <b>(#ProgramID#) &nbsp #programname# &nbsp (#programtype#)</b><br></cfloop>
	<cfif form.continent NEQ 0>&nbsp &nbsp Continent: &nbsp; <b>#form.continent#</b><br></cfif>
	<cfif isDate(FORM.date_host_fam_approved)>&nbsp &nbsp Students placed by <b>#DateFormat(form.date_host_fam_approved, 'mm/dd/yyyy')#</b><br></cfif>
	&nbsp &nbsp Active Students in Program(s) : &nbsp #get_stu_in_prog.Count_stu#<br>
	&nbsp &nbsp Placed : &nbsp #get_stu_placed.Count_stu# (#numberformat(evaluate((get_stu_placed.Count_stu/get_stu_in_prog.Count_stu)*100),"___.__")#%) &nbsp;  <font size="-2" color="FF6633"> ( Approved Placements Only )</font><br>
	&nbsp &nbsp Unplaced : &nbsp #get_stu_in_prog.Count_stu - get_stu_placed.Count_stu# (#numberformat(evaluate(((get_stu_in_prog.Count_stu - get_stu_placed.Count_stu)/get_stu_in_prog.Count_stu)*100),"___.__")#%)<br>
</td></tr>
</table>
<br>
<table align="center" width="90%" cellpadding=2 cellspacing="0" border="1">
<tr>
	<Th width="26%">Region</th>
	<Th colspan="3">Assigned</th>
	<td></td>
	<Th colspan="3">Placed</th>
	<td></td>
	<Th colspan="3">Ratio</th>
</tr>

<tr>
	<td>&nbsp;</td>
	<TD width="8%" align="center">Total</td>
	<TD width="8%" align="center">Female</td>
	<TD  width="8%" align="center">Male</td>
	<td width="1%"></td>
	<TD width="8%" align="center">Total</td>
	<TD width="8%" align="center">Female</td>
	<TD width="8%" align="center">Male</td>
	<td width="1%"></td>
	<TD width="8%" align="center">Total</td>
	<TD width="8%" align="center">Female</td>
	<TD width="8%" align="center">Male</td>
</tr>
<cfloop query="get_region">

<cfquery name="get_stu_assigned_region" datasource="MYSQL">
	SELECT	SUM(if(not isnull(StudentID), 1, 0) ) AS assigned_students,
			SUM(IF(SEX = 'FEMALE', 1, 0)) AS assigned_female,
			SUM(IF(SEX = 'MALE', 1, 0)) AS assigned_male
	FROM 	smg_students
	<cfif form.continent NEQ 0>INNER JOIN smg_countrylist c ON countryresident = c.countryid</cfif>
	WHERE regionassigned = '#get_region.regionid#' 
		  AND onhold_approved <= 4
		  AND  active = 1
		  <cfif form.continent NEQ 0>AND c.continent = '#form.continent#'</cfif>
        AND 
          programid IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes">)
</cfquery>

<cfquery name="get_stu_placed_region" datasource="MYSQL">
	SELECT	SUM(if(not isnull(StudentID), 1, 0) ) as placed_student,
			SUM(if(Sex = 'Female', 1, 0)) as placed_female,
			SUM(if(Sex = 'Male', 1, 0)) as placed_male
	FROM 	smg_students
	<cfif form.continent NEQ 0>INNER JOIN smg_countrylist c ON countryresident = c.countryid</cfif>
	WHERE regionassigned = '#get_region.regionid#' 
		AND host_fam_approved < 5	
		AND Hostid != 0 
		AND onhold_approved <= 4
		And active = 1
		<cfif isDate(FORM.date_host_fam_approved)>
			AND date_host_fam_approved <= #CreateODBCDate(form.date_host_fam_approved)#
		</cfif>
		<cfif form.continent NEQ 0>AND c.continent = '#form.continent#'</cfif>
        AND 
          programid IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes">)
</cfquery>

<tr bgcolor="#iif(get_region.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
	<td align="left">#get_region.regionname#</td> 
	<td align="right">#numberformat(get_stu_assigned_region.assigned_students)#</td>
	<td align="right">#numberformat(get_stu_assigned_region.assigned_female)#</td>
	<td align="right">#numberformat(get_stu_assigned_region.assigned_male)#</td>
	<td></td>
	<td align="right">#numberformat(get_stu_placed_region.placed_student)#</td>
	<td align="right">#numberformat(get_stu_placed_region.placed_female)#</td>
	<td align="right">#numberformat(get_stu_placed_region.placed_male)#</td>
	<td></td>
	<TD align="right">
	<cfif numberformat(get_stu_assigned_region.assigned_students) is 0>N/A
	<cfelse>
		<cfif numberformat(get_stu_placed_region.placed_student) is 0>0%
		<cfelse>
			#numberformat(evaluate((get_stu_placed_region.placed_student/get_stu_assigned_region.assigned_students)*100),"___.__")#
		</cfif>
	</cfif>
	</td>
	<TD align="right">
	<cfif numberformat(get_stu_assigned_region.assigned_female) is 0>N/A
	<cfelse>
			<cfif numberformat(get_stu_placed_region.placed_female) is 0>0%
		<cfelse>
			#numberformat(evaluate((get_stu_placed_region.placed_female/get_stu_assigned_region.assigned_female)*100),"___.__")#
		</cfif>
	</cfif>
	</td>
	<TD align="right">
	<cfif numberformat(get_stu_assigned_region.assigned_male) is 0>N/A
	<cfelse>
		<cfif numberformat(get_stu_placed_region.placed_male) is 0>0%
		<cfelse>
			#numberformat(evaluate((get_stu_placed_region.placed_male/get_stu_assigned_region.assigned_male)*100),"___.__")#
		</cfif>
	</cfif>
	</td>
</tr>
</cfloop>

<cfquery name="get_stu_unassigned" datasource="MYSQL">
	SELECT	SUM(if(not isnull(StudentID), 1, 0) ) AS assigned_students,
			SUM(IF(SEX = 'FEMALE', 1, 0)) AS assigned_female,
			SUM(IF(SEX = 'MALE', 1, 0)) AS assigned_male,
			studentid
	FROM 	smg_students
	<cfif form.continent NEQ 0>INNER JOIN smg_countrylist c ON countryresident = c.countryid</cfif>
	WHERE regionassigned = '0' 
		  AND onhold_approved <= '4'
		  AND canceldate IS NULL
		<cfif isDate(FORM.date_host_fam_approved)>
			AND date_host_fam_approved <= #CreateODBCDate(form.date_host_fam_approved)#
		</cfif>
		  <cfif form.continent NEQ 0>AND c.continent = '#form.continent#'</cfif>
        AND 
          programid IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes">)
		group by studentid
</cfquery>


<cfquery name="get_unassigned_placed" datasource="MYSQL">
	SELECT	SUM(if(not isnull(StudentID), 1, 0) ) as placed_student,
			SUM(if(Sex = 'Female', 1, 0)) as placed_female,
			SUM(if(Sex = 'Male', 1, 0)) as placed_male
	FROM 	smg_students
	<cfif form.continent NEQ 0>INNER JOIN smg_countrylist c ON countryresident = c.countryid</cfif>
	WHERE regionassigned = '0' 
		AND host_fam_approved < '5'	
		AND Hostid != '0' 
		AND onhold_approved <= '4'
		AND canceldate IS NULL
		<cfif isDate(FORM.date_host_fam_approved)>
			AND date_host_fam_approved <= #CreateODBCDate(form.date_host_fam_approved)#
		</cfif>
		<cfif form.continent NEQ 0>AND c.continent = '#form.continent#'</cfif>
        AND 
          programid IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes">)
</cfquery>
<tr bgcolor="ededed">
	<td align="left">-- Unassigned -- </td> 
	<td align="right">#numberformat(get_stu_unassigned.assigned_students)#</td>
	<td align="right">#numberformat(get_stu_unassigned.assigned_female)#</td>
	<td align="right">#numberformat(get_stu_unassigned.assigned_male)#</td>
	<td></td>
	<td align="right">#numberformat(get_unassigned_placed.placed_student)#</td>
	<td align="right">#numberformat(get_unassigned_placed.placed_female)#</td>
	<td align="right">#numberformat(get_unassigned_placed.placed_male)#</td>
	<td></td>
	<TD align="right">
	<cfif numberformat(get_stu_unassigned.assigned_students) is 0>N/A
	<cfelse>
		<cfif numberformat(get_unassigned_placed.placed_student) is 0>0%
		<cfelse>
			#numberformat(evaluate((get_unassigned_placed.placed_student/get_stu_unassigned.assigned_students)*100),"___.__")#
		</cfif>
	</cfif>
	</td>
	<TD align="right">
	<cfif numberformat(get_stu_unassigned.assigned_female) is 0>N/A
	<cfelse>
			<cfif numberformat(get_unassigned_placed.placed_female) is 0>0%
		<cfelse>
			#numberformat(evaluate((get_unassigned_placed.placed_female/get_stu_unassigned.assigned_female)*100),"___.__")#
		</cfif>
	</cfif>
	</td>
	<TD align="right">
	<cfif numberformat(get_stu_unassigned.assigned_male) is 0>N/A
	<cfelse>
		<cfif numberformat(get_unassigned_placed.placed_male) is 0>0%
		<cfelse>
			#numberformat(evaluate((get_unassigned_placed.placed_male/get_stu_unassigned.assigned_male)*100),"___.__")#
		</cfif>
	</cfif>
	</td>
</tr>

</table><br>
</cfoutput>