<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Untitled Document</title>
</head>

<body>

<cfif not IsDefined('form.seasonid')>
<br>
<table align="center" width="90%" cellpadding=6 cellspacing="0">
<tr><td>An error has ocurred and the report could not be generated. Please go back and try again.</td></tr>
<tr><td align="center"><input type="image" value="close window" src="pics/back.gif" onClick="javascript:history.back()"></td></tr>
</table><br>
<cfabort>
</cfif>

<cfquery name="get_season" datasource="MySql">
	SELECT seasonid, season
	FROM smg_seasons
	WHERE ( <cfloop list=#form.seasonid# index='season'> seasonid = #season# <cfif season EQ #ListLast(form.seasonid)#><Cfelse>or</cfif> </cfloop> )
</cfquery>

<!--- get company region --->
<cfquery name="get_region" datasource="MySQL">
	SELECT	regionname, company, regionid
	FROM smg_regions
	WHERE company = #client.companyid#
	<cfif IsDefined('form.inactive')><cfelse>AND active = '1'</cfif>
	ORDER BY regionname
</cfquery>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<cfquery name="get_program" datasource="MYSQL">
	SELECT	ProgramID, programname, startdate, enddate, p.companyid, type,
			programtype,
			c.companyshort
	FROM 	smg_programs p
	INNER JOIN smg_companies c ON c.companyid = p.companyid
	LEFT JOIN smg_program_type ON type = programtypeid
	WHERE 
        p.companyid IN (<cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,5,10" list="yes">)
    AND	
    	p.is_deleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">	
		
        AND ( <cfloop list=#form.seasonid# index='season'> smgseasonid = #season# <cfif season EQ #ListLast(form.seasonid)#><Cfelse>or</cfif> </cfloop> ) 	  
</cfquery>

<cfquery name="get_stu_in_prog" datasource="MySQL">
	SELECT	 count(studentid) as count_stu
	FROM 	smg_students
	INNER JOIN smg_programs p ON smg_students.programid = p.programid
	<cfif form.continent NEQ 0>INNER JOIN smg_countrylist c ON countryresident = c.countryid</cfif>
	WHERE smg_students.active = '1'
		AND onhold_approved <= '4'
		<cfif form.continent NEQ 0>AND c.continent = '#form.continent#'</cfif>
		<cfif client.companyid NEQ '5'>AND p.companyid = '#client.companyid#'</cfif>
		AND ( <cfloop list=#form.seasonid# index='season'> smgseasonid = #season# <cfif season EQ #ListLast(form.seasonid)#><Cfelse>or</cfif> </cfloop> ) 	  
</cfquery>

<cfquery name="get_stu_placed" datasource="MySQL">
	SELECT	 count(studentid) as count_stu
	FROM 	smg_students
	INNER JOIN smg_programs p ON smg_students.programid = p.programid
	<cfif form.continent is 0><cfelse>INNER JOIN smg_countrylist c ON countryresident = c.countryid</cfif>
	WHERE smg_students.active = '1' and hostid <> '0' AND `host_fam_approved` < '5'
		  <cfif form.continent NEQ 0>AND c.continent = '#form.continent#'</cfif>
		  AND onhold_approved <= '4'
			<cfif client.companyid NEQ '5'>AND p.companyid = '#client.companyid#'</cfif>
			AND ( <cfloop list=#form.seasonid# index='season'> smgseasonid = #season# <cfif season EQ #ListLast(form.seasonid)#><Cfelse>or</cfif> </cfloop> ) 	  
</cfquery>

<!--- <cfif not isDefined('url.graphics')><cfset url.graphics = 'no'></cfif> --->
<cfoutput>
<span class="application_section_header">#companyshort.companyshort# Program Statistics Per Season</span><br>

<table align="center" width="90%" cellpadding=6 cellspacing="0" frame="box">
<tr><td align="left">
	<font face="" color="Gray"> &nbsp &nbsp Season(s) : &nbsp </font><br>
	<cfloop query="get_season">&nbsp &nbsp <b>#season#</b><br></cfloop>
	
	<font face="" color="Gray"> &nbsp &nbsp Program(s) : &nbsp </font><br>
	<cfloop query="get_program">&nbsp &nbsp <b><!--- (#ProgramID#) ---> #companyshort# &nbsp #programname# &nbsp (#programtype#)</b><br></cfloop>
	
	<cfif form.continent is not 0><font face="" color="Gray">&nbsp &nbsp Continent: &nbsp; </font><b>#form.continent#</b><br></cfif>
	<font face="" color="Gray"> &nbsp &nbsp Students in Program(s) : &nbsp </font>#get_stu_in_prog.Count_stu#<br>
	<font face="" color="Gray"> &nbsp &nbsp Placed : &nbsp </font>#get_stu_placed.Count_stu# (#numberformat(evaluate((get_stu_placed.Count_stu/get_stu_in_prog.Count_stu)*100),"___.__")#%) &nbsp;  <font size="-2" color="FF6633"> ( Approved Placements Only )</font><br>
	<font face="" color="Gray"> &nbsp &nbsp Unplaced : &nbsp </font>#get_stu_in_prog.Count_stu - get_stu_placed.Count_stu# (#numberformat(evaluate(((get_stu_in_prog.Count_stu - get_stu_placed.Count_stu)/get_stu_in_prog.Count_stu)*100),"___.__")#%)<br>
</td></tr>
</table><br>
</cfoutput>

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
	INNER JOIN smg_programs p ON smg_students.programid = p.programid
	<cfif form.continent is 0><cfelse>INNER JOIN smg_countrylist c ON countryresident = c.countryid</cfif>
	WHERE regionassigned = #get_region.regionid# 
		AND smg_students.active = '1'
		<cfif form.continent NEQ 0>AND c.continent = '#form.continent#'</cfif>
		AND onhold_approved <= '4'
		<cfif client.companyid NEQ '5'>AND p.companyid = '#client.companyid#'</cfif>
		AND ( <cfloop list=#form.seasonid# index='season'> smgseasonid = #season# <cfif season EQ #ListLast(form.seasonid)#><Cfelse>or</cfif> </cfloop> ) 	  
</cfquery>

<cfquery name="get_stu_placed_region" datasource="MYSQL">
	SELECT	SUM(if(not isnull(StudentID), 1, 0) ) as placed_student,
			SUM(if(Sex = 'Female', 1, 0)) as placed_female,
			SUM(if(Sex = 'Male', 1, 0)) as placed_male
	FROM 	smg_students
	INNER JOIN smg_programs p ON smg_students.programid = p.programid
	<cfif form.continent is 0><cfelse>INNER JOIN smg_countrylist c ON countryresident = c.countryid</cfif>
	WHERE regionassigned = #get_region.regionid# 
		AND smg_students.active = '1' 
		AND `host_fam_approved` < '5'	AND onhold_approved <= '4'
		<cfif form.continent NEQ 0>AND c.continent = '#form.continent#'</cfif>
		AND Hostid <> '0' 
		<cfif client.companyid NEQ '5'>AND p.companyid = '#client.companyid#'</cfif>
		AND ( <cfloop list=#form.seasonid# index='season'> smgseasonid = #season# <cfif season EQ #ListLast(form.seasonid)#><Cfelse>or</cfif> </cfloop> ) 	  
</cfquery>

<cfoutput>
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
</cfoutput>
</cfloop>
</table><br>

</body>
</html>
