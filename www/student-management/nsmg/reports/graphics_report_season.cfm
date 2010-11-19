<cfif not IsDefined('form.seasonid') or not IsDefined('form.programid')><br>
	<table align="center" width="90%" cellpadding=6 cellspacing="0">
	<tr><td>An error has ocurred and the graphics could not be generated. Please go back and try again.</td></tr>
	<tr><td align="center"><input type="image" value="close window" src="pics/back.gif" onClick="javascript:history.back()"></td></tr>
	</table><br>
	<cfabort>
</cfif>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<cfquery name="get_season" datasource="MySql">
	SELECT seasonid, season
	FROM smg_seasons
	WHERE ( <cfloop list="#form.seasonid#" index="season"> seasonid = #season# <cfif season EQ #ListLast(form.seasonid)#><Cfelse>or</cfif> </cfloop> )
</cfquery>

<cfquery name="get_program" datasource="MYSQL">
	SELECT	p.ProgramID, p.programname, p.startdate, p.enddate, p.companyid, p.type,
			pt.programtype, c.companyshort
	FROM 	smg_programs p
	LEFT JOIN smg_program_type pt ON p.type = pt.programtypeid
	INNER JOIN smg_companies c ON p.companyid = c.companyid
	WHERE <cfloop list="#form.seasonid#" index="season"> smgseasonid = #season# <cfif season EQ #ListLast(form.seasonid)#><Cfelse>or</cfif> </cfloop>
	AND
        p.companyid IN (<cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,5,10,12,13" list="yes">)
    AND	
    	p.is_deleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">	
</cfquery>

<cfquery name="get_stu_in_prog" datasource="MySQL">
	SELECT	 count(studentid) as count_stu
	FROM 	smg_students
	INNER JOIN smg_programs p ON smg_students.programid = p.programid
	WHERE smg_students.active = '1' AND onhold_approved <= '4'
		  AND ( <cfloop list="#form.seasonid#" index="season"> smgseasonid = #season# <cfif season EQ #ListLast(form.seasonid)#><Cfelse>or</cfif> </cfloop> )
		  <cfif client.companyid NEQ '5'>AND p.companyid = '#client.companyid#'</cfif>
</cfquery>

<cfquery name="get_stu_placed" datasource="MySQL">
	SELECT	 count(studentid) as count_stu
	FROM 	smg_students
	INNER JOIN smg_programs p ON smg_students.programid = p.programid
	WHERE smg_students.active = '1' and hostid != '0' AND `host_fam_approved` < '5' AND onhold_approved <= '4'
		  AND ( <cfloop list="#form.seasonid#" index="season"> smgseasonid = #season# <cfif season EQ #ListLast(form.seasonid)#><Cfelse>or</cfif> </cfloop> )
  		  <cfif client.companyid NEQ '5'>AND p.companyid = '#client.companyid#'</cfif>
</cfquery>

<cfoutput>

<span class="application_section_header">#companyshort.companyshort# &nbsp; - &nbsp; G R A P H I C S</span>
<br>
<!--- HEADER --->
<table align="center" width="90%" cellpadding=6 cellspacing="0" frame="box">
<tr><td align="left">
	<font face="" color="Gray">&nbsp &nbsp As of #DateFormat(now(), 'mmm, dd yyyy')# - #TimeFormat(now(), 'hh:mm tt')#</font><br>
	
	<font face="" color="Gray"> &nbsp &nbsp Season(s) : &nbsp </font><br>
	<cfloop query="get_season">&nbsp &nbsp <b>#season#</b><br></cfloop>
	
	<font face="" color="Gray"> &nbsp &nbsp Program(s) : &nbsp </font><br>
	<cfloop query="get_program">&nbsp &nbsp <b><!--- (#ProgramID#) ---> #companyshort# &nbsp #programname# &nbsp (#programtype#)</b><br></cfloop>
	
	<font face="" color="Gray"> &nbsp &nbsp Total Active Students in Program(s) : &nbsp </font>#get_stu_in_prog.Count_stu#<br>
	<font face="" color="Gray"> &nbsp &nbsp Placed : &nbsp </font>#get_stu_placed.Count_stu# (#numberformat(evaluate((get_stu_placed.Count_stu/get_stu_in_prog.Count_stu)*100),"___.__")#%) &nbsp; <font size="-2" color="FF6633"> ( Approved Placements Only )</font><br>
	<font face="" color="Gray"> &nbsp &nbsp Unplaced : &nbsp </font>#get_stu_in_prog.Count_stu - get_stu_placed.Count_stu# (#numberformat(evaluate(((get_stu_in_prog.Count_stu - get_stu_placed.Count_stu)/get_stu_in_prog.Count_stu)*100),"___.__")#%)<br>
</td></tr>
</table><br>

<!--- <cfchart chartwidth="300" chartheight="200" yaxistitle="Asians" rotated="yes" pieslicestyle="solid">
	<cfchartseries
		type="pie"
		query="graphic_status"
		valuecolumn="result"
		itemcolumn="unplaced">
	</cfchartseries>
</cfchart> --->

<!--- GRAPHICS  GRAPHICS  GRAPHICS  GRAPHICS  GRAPHICS--->
<!--- TOTAL UNPLACED X PLACED --->
<cfquery name="unplaced_placed" datasource="MySql">
	SELECT 'Unplaced', count( studentid ) AS result 
	FROM smg_students
	INNER JOIN smg_programs p ON smg_students.programid = p.programid
	WHERE hostid = '0' and smg_students.active = '1' AND onhold_approved <= '4'
		  <cfif client.companyid NEQ '5'>AND p.companyid = '#client.companyid#'</cfif>
		  AND ( <cfloop list="#form.seasonid#" index="season"> smgseasonid = #season# <cfif season EQ #ListLast(form.seasonid)#><Cfelse>or</cfif> </cfloop> ) 
	OR hostid != '0' and smg_students.active = '1' AND `host_fam_approved` > '4'
	      <cfif client.companyid NEQ '5'>AND p.companyid = '#client.companyid#'</cfif>
		  AND ( <cfloop list="#form.seasonid#" index="season"> smgseasonid = #season# <cfif season EQ #ListLast(form.seasonid)#><Cfelse>or</cfif> </cfloop> ) 	  
	UNION 
	SELECT 'Placed', count( studentid ) AS result 
	FROM smg_students
	INNER JOIN smg_programs p ON smg_students.programid = p.programid
	WHERE hostid != '0' and smg_students.active = '1' AND `host_fam_approved` < '5' AND onhold_approved <= '4'
		  <cfif client.companyid NEQ '5'>AND p.companyid = '#client.companyid#'</cfif>
		  AND ( <cfloop list="#form.seasonid#" index="season"> smgseasonid = #season# <cfif season EQ #ListLast(form.seasonid)#><Cfelse>or</cfif> </cfloop> )
</cfquery>
<table align="center" width="90%" cellpadding=6 cellspacing="0" frame="box">
<tr><th bgcolor="CCCCCC">#companyshort.companyshort# &nbsp; - &nbsp; Unplaced x Placed
<cfset get_total = '0'>
<cfloop query="unplaced_placed"><cfset get_total = get_total + result></cfloop>&nbsp; &nbsp; Total of &nbsp; #get_total# &nbsp; Students</th></tr>
<tr><td align="center"><cfgraph query="unplaced_placed" type="pie" valueColumn="result" itemColumn="unplaced" graphHeight="200" graphWidth="300"></cfgraph></td></tr>
</table><br>


<!--- TOTAL ASIANS X NON-ASIANS --->
<cfquery name="asians_non_asians" datasource="MySql">
	SELECT 'Non-Asians', count( studentid ) AS result 
	FROM smg_students
	INNER JOIN smg_countrylist  ON countryresident = countryid
	INNER JOIN smg_programs p ON smg_students.programid = p.programid
	WHERE smg_students.active = '1' and continent != 'asia' AND onhold_approved <= '4'
		<cfif client.companyid NEQ '5'>AND p.companyid = '#client.companyid#'</cfif>
		  AND ( <cfloop list="#form.seasonid#" index="season"> smgseasonid = #season# <cfif season EQ #ListLast(form.seasonid)#><Cfelse>or</cfif> </cfloop> )
	UNION 
	SELECT 'Asians', count( studentid ) AS result 		
	FROM smg_students
	INNER JOIN smg_countrylist  ON countryresident = countryid
	INNER JOIN smg_programs p ON smg_students.programid = p.programid
	WHERE smg_students.active = '1' and continent = 'asia' AND onhold_approved <= '4'
		<cfif client.companyid NEQ '5'>AND p.companyid = '#client.companyid#'</cfif>
		  AND ( <cfloop list="#form.seasonid#" index="season"> smgseasonid = #season# <cfif season EQ #ListLast(form.seasonid)#><Cfelse>or</cfif> </cfloop> )
</cfquery>
<table align="center" width="90%" cellpadding=6 cellspacing="0" frame="box"><br>
<tr><th bgcolor="CCCCCC">#companyshort.companyshort# &nbsp; - &nbsp; Asians x Non-Asians
<cfset get_total = '0'>
<cfloop query="asians_non_asians"><cfset get_total = get_total + result></cfloop>&nbsp; &nbsp; Total of &nbsp; #get_total# &nbsp; Students</th></tr>
<tr><td align="center"><cfgraph query="asians_non_asians" type="pie" valueColumn="result" itemColumn="non-asians" graphHeight="200" graphWidth="300"></cfgraph></td></tr>
</table><br>

<!--- ASIANS - UNPLACED X PLACED --->
<cfquery name="asians_statistics" datasource="MySql">
	SELECT 'Unplaced', count( studentid ) AS result 		
	FROM smg_students
	INNER JOIN smg_countrylist  ON countryresident = countryid
	INNER JOIN smg_programs p ON smg_students.programid = p.programid
	WHERE smg_students.active = '1' and continent = 'asia' and hostid = '0' AND onhold_approved <= '4'
			<cfif client.companyid NEQ '5'>AND p.companyid = '#client.companyid#'</cfif>
		  AND ( <cfloop list="#form.seasonid#" index="season"> smgseasonid = #season# <cfif season EQ #ListLast(form.seasonid)#><Cfelse>or</cfif> </cfloop> )
	OR	smg_students.active = '1' and continent = 'asia' and hostid != '0' AND `host_fam_approved` > '4' AND onhold_approved <= '4'
			<cfif client.companyid NEQ '5'>AND p.companyid = '#client.companyid#'</cfif>
		  AND ( <cfloop list="#form.seasonid#" index="season"> smgseasonid = #season# <cfif season EQ #ListLast(form.seasonid)#><Cfelse>or</cfif> </cfloop> )
	UNION 
	SELECT 'Placed', count( studentid ) AS result 		
	FROM smg_students
	INNER JOIN smg_countrylist  ON countryresident = countryid
	INNER JOIN smg_programs p ON smg_students.programid = p.programid
	WHERE smg_students.active = '1' and continent = 'asia' and hostid != '0' AND `host_fam_approved` < '5' AND onhold_approved <= '4'
			<cfif client.companyid NEQ '5'>AND p.companyid = '#client.companyid#'</cfif>
		  AND ( <cfloop list="#form.seasonid#" index="season"> smgseasonid = #season# <cfif season EQ #ListLast(form.seasonid)#><Cfelse>or</cfif> </cfloop> )
</cfquery>
<table align="center" width="90%" cellpadding=6 cellspacing="0" frame="box"><br>
<tr><th bgcolor="CCCCCC">#companyshort.companyshort# &nbsp; - &nbsp; Asian Students - Unplaced x Placed
<cfset get_total = '0'>
<cfloop query="asians_statistics"><cfset get_total = get_total + result></cfloop>&nbsp; &nbsp; Total of &nbsp; #get_total# &nbsp; Students</th></tr>
<tr><td align="center"><cfgraph query="asians_statistics" type="pie" valueColumn="result" itemColumn="unplaced" graphHeight="200" graphWidth="300"></cfgraph></td></tr>
</table><br>

<!--- MALE ASIANS - UNPLACED X PLACED --->
<cfquery name="asian_male_statistics" datasource="MySql">
	SELECT 'M-Unplaced', count( studentid ) AS result
	FROM smg_students
	INNER JOIN smg_countrylist ON countryresident = countryid
	INNER JOIN smg_programs p ON smg_students.programid = p.programid
	WHERE smg_students.active = '1' AND continent = 'asia' AND hostid = '0' AND sex = 'male' AND onhold_approved <= '4'
			<cfif client.companyid NEQ '5'>AND p.companyid = '#client.companyid#'</cfif>
		  AND ( <cfloop list="#form.seasonid#" index="season"> smgseasonid = #season# <cfif season EQ #ListLast(form.seasonid)#><Cfelse>or</cfif> </cfloop> )
	OR smg_students.active = '1' AND continent = 'asia' AND hostid != '0' AND sex = 'male' AND `host_fam_approved` > '5' AND onhold_approved <= '4'
		<cfif client.companyid NEQ '5'>AND p.companyid = '#client.companyid#'</cfif>
		  AND ( <cfloop list="#form.seasonid#" index="season"> smgseasonid = #season# <cfif season EQ #ListLast(form.seasonid)#><Cfelse>or</cfif> </cfloop> )
	UNION
	SELECT 'M-Placed', count( studentid ) AS result
	FROM smg_students
	INNER JOIN smg_countrylist ON countryresident = countryid
	INNER JOIN smg_programs p ON smg_students.programid = p.programid 
	WHERE smg_students.active = '1' AND continent = 'asia' AND hostid != '0' AND sex = 'male' AND `host_fam_approved` < '5' AND onhold_approved <= '4'
		<cfif client.companyid NEQ '5'>AND p.companyid = '#client.companyid#'</cfif>
		  AND ( <cfloop list="#form.seasonid#" index="season"> smgseasonid = #season# <cfif season EQ #ListLast(form.seasonid)#><Cfelse>or</cfif> </cfloop> )
</cfquery>
<table align="center" width="90%" cellpadding=6 cellspacing="0" frame="box"><br>
<tr><th bgcolor="CCCCCC">#companyshort.companyshort# &nbsp; - &nbsp; Asian Male - Unplaced x Placed
<cfset get_total = '0'>
<cfloop query="asian_male_statistics"><cfset get_total = get_total + result></cfloop>&nbsp; &nbsp; Total of &nbsp; #get_total# &nbsp; Students</th></tr>
<tr><td align="center"><cfgraph query="asian_male_statistics" type="pie" valueColumn="result" itemColumn="M-Unplaced" graphHeight="200" graphWidth="300"></cfgraph></td></tr>
</table><br>

<!--- FEMALE ASIANS - UNPLACED X PLACED --->
<cfquery name="asian_female_statistics" datasource="MySql">
	SELECT 'F-Unplaced', count( studentid ) AS result
	FROM smg_students
	INNER JOIN smg_countrylist ON countryresident = countryid
	INNER JOIN smg_programs p ON smg_students.programid = p.programid
	WHERE smg_students.active = '1' AND continent = 'asia' AND hostid = '0' AND sex = 'female'  AND onhold_approved <= '4'
		  <cfif client.companyid NEQ '5'>AND p.companyid = '#client.companyid#'</cfif>
		  AND ( <cfloop list="#form.seasonid#" index="season"> smgseasonid = #season# <cfif season EQ #ListLast(form.seasonid)#><Cfelse>or</cfif> </cfloop> )
	OR  smg_students.active = '1' AND continent = 'asia' AND hostid != '0' AND sex = 'female'  AND `host_fam_approved` > '5' AND onhold_approved <= '4'
		<cfif client.companyid NEQ '5'>AND p.companyid = '#client.companyid#'</cfif>
		  AND ( <cfloop list="#form.seasonid#" index="season"> smgseasonid = #season# <cfif season EQ #ListLast(form.seasonid)#><Cfelse>or</cfif> </cfloop> )
	UNION
	SELECT 'F-Placed', count( studentid ) AS result
	FROM smg_students
	INNER JOIN smg_countrylist ON countryresident = countryid
	INNER JOIN smg_programs p ON smg_students.programid = p.programid	
	WHERE smg_students.active = '1' AND continent = 'asia' AND hostid != '0' AND sex = 'female' AND `host_fam_approved` < '5' AND onhold_approved <= '4'
		<cfif client.companyid NEQ '5'>AND p.companyid = '#client.companyid#'</cfif>
		  AND ( <cfloop list="#form.seasonid#" index="season"> smgseasonid = #season# <cfif season EQ #ListLast(form.seasonid)#><Cfelse>or</cfif> </cfloop> )
</cfquery>
<table align="center" width="90%" cellpadding=6 cellspacing="0" frame="box"><br>
<tr><th bgcolor="CCCCCC">#companyshort.companyshort# &nbsp; - &nbsp; Asian Female - Unplaced x Placed
<cfset get_total = '0'>
<cfloop query="asian_female_statistics"><cfset get_total = get_total + result></cfloop>&nbsp; &nbsp; Total of &nbsp; #get_total# &nbsp; Students</th></tr>
<tr><td align="center"><cfgraph query="asian_female_statistics" type="pie" valueColumn="result" itemColumn="F-Unplaced" graphHeight="200" graphWidth="300"></cfgraph></td></tr>
</table><br>

<!--- NON-ASIANS - UNPLACED X PLACED --->
<cfquery name="non_asians_unplaced_placed" datasource="MySql">
	SELECT 'Unplaced', count( studentid ) AS result 
	FROM smg_students
	INNER JOIN smg_countrylist  ON countryresident = countryid
	INNER JOIN smg_programs p ON smg_students.programid = p.programid
	WHERE smg_students.active = '1' and continent != 'asia' and hostid = '0' AND onhold_approved <= '4'
		  AND ( <cfloop list="#form.seasonid#" index="season"> smgseasonid = #season# <cfif season EQ #ListLast(form.seasonid)#><Cfelse>or</cfif> </cfloop> )
		  <cfif client.companyid NEQ '5'>AND p.companyid = '#client.companyid#'</cfif>
	OR smg_students.active = '1' and continent != 'asia' and hostid != '0' AND `host_fam_approved` > '5' AND onhold_approved <= '4'
		  AND ( <cfloop list="#form.seasonid#" index="season"> smgseasonid = #season# <cfif season EQ #ListLast(form.seasonid)#><Cfelse>or</cfif> </cfloop> )
		  <cfif client.companyid NEQ '5'>AND p.companyid = '#client.companyid#'</cfif>
	UNION 
	SELECT 'Placed', count( studentid ) AS result 
	FROM smg_students
	INNER JOIN smg_countrylist  ON countryresident = countryid
	INNER JOIN smg_programs p ON smg_students.programid = p.programid
	WHERE smg_students.active = '1' and continent != 'asia' and hostid != '0' AND `host_fam_approved` < '5' AND onhold_approved <= '4'
		<cfif client.companyid NEQ '5'>AND p.companyid = '#client.companyid#'</cfif>
		  AND ( <cfloop list="#form.seasonid#" index="season"> smgseasonid = #season# <cfif season EQ #ListLast(form.seasonid)#><Cfelse>or</cfif> </cfloop> )
</cfquery>
<table align="center" width="90%" cellpadding=6 cellspacing="0" frame="box"><br>
<tr><th bgcolor="CCCCCC">#companyshort.companyshort# &nbsp; - &nbsp; Non-Asians Students - Unplaced x Placed
<cfset get_total = '0'>
<cfloop query="non_asians_unplaced_placed"><cfset get_total = get_total + result></cfloop>&nbsp; &nbsp; Total of &nbsp; #get_total# &nbsp; Students</th></tr>
<tr><td align="center"><cfgraph query="non_asians_unplaced_placed" type="pie" valueColumn="result" itemColumn="unplaced" graphHeight="200" graphWidth="300"></cfgraph></td></tr>
</table><br>


<!--- NON-ASIANS MALE - UNPLACED X PLACED --->
<cfquery name="non_asian_male_statistics" datasource="MySql">
	SELECT 'M-Unplaced', count( studentid ) AS result
	FROM smg_students
	INNER JOIN smg_countrylist ON countryresident = countryid
	INNER JOIN smg_programs p ON smg_students.programid = p.programid
	WHERE smg_students.active = '1' AND continent != 'asia' AND hostid = '0' AND sex = 'male' AND onhold_approved <= '4'
		<cfif client.companyid NEQ '5'>AND p.companyid = '#client.companyid#'</cfif>
		  AND ( <cfloop list="#form.seasonid#" index="season"> smgseasonid = #season# <cfif season EQ #ListLast(form.seasonid)#><Cfelse>or</cfif> </cfloop> )
	OR smg_students.active = '1' AND continent != 'asia' AND hostid != '0' AND sex = 'male' AND `host_fam_approved` > '5' AND onhold_approved <= '4'
		<cfif client.companyid NEQ '5'>AND p.companyid = '#client.companyid#'</cfif>
		  AND ( <cfloop list="#form.seasonid#" index="season"> smgseasonid = #season# <cfif season EQ #ListLast(form.seasonid)#><Cfelse>or</cfif> </cfloop> )
	UNION
	SELECT 'M-Placed', count( studentid ) AS result
	FROM smg_students
	INNER JOIN smg_countrylist ON countryresident = countryid
	INNER JOIN smg_programs p ON smg_students.programid = p.programid
	WHERE smg_students.active = '1' AND continent != 'asia' AND hostid != '0' AND sex = 'male' AND `host_fam_approved` < '5' AND onhold_approved <= '4'
		<cfif client.companyid NEQ '5'>AND p.companyid = '#client.companyid#'</cfif>
		  AND ( <cfloop list="#form.seasonid#" index="season"> smgseasonid = #season# <cfif season EQ #ListLast(form.seasonid)#><Cfelse>or</cfif> </cfloop> )	  
</cfquery>
<table align="center" width="90%" cellpadding=6 cellspacing="0" frame="box"><br>
<tr><th bgcolor="CCCCCC">#companyshort.companyshort# &nbsp; - &nbsp; Non-Asian Male - Unplaced x Placed
<cfset get_total = '0'>
<cfloop query="non_asian_male_statistics"><cfset get_total = get_total + result></cfloop>&nbsp; &nbsp; Total of &nbsp; #get_total# &nbsp; Students</th></tr>
<tr><td align="center"><cfgraph query="non_asian_male_statistics" type="pie" valueColumn="result" itemColumn="M-Unplaced" graphHeight="200" graphWidth="300"></cfgraph></td></tr>
</table><br>

<!--- NON-ASIANS FEMALE - UNPLACED X PLACED --->
<cfquery name="non_asian_female_statistics" datasource="MySql">
	SELECT 'F-Unplaced', count( studentid ) AS result
	FROM smg_students
	INNER JOIN smg_countrylist ON countryresident = countryid
	INNER JOIN smg_programs p ON smg_students.programid = p.programid
	WHERE smg_students.active = '1' AND continent != 'asia' AND hostid = '0' AND sex = 'female' AND onhold_approved <= '4'
		<cfif client.companyid NEQ '5'>AND p.companyid = '#client.companyid#'</cfif>
		  AND ( <cfloop list="#form.seasonid#" index="season"> smgseasonid = #season# <cfif season EQ #ListLast(form.seasonid)#><Cfelse>or</cfif> </cfloop> )
	OR smg_students.active = '1' AND continent != 'asia' AND hostid != '0' AND sex = 'female' AND `host_fam_approved` > '5' AND onhold_approved <= '4'
		<cfif client.companyid NEQ '5'>AND p.companyid = '#client.companyid#'</cfif>
		  AND ( <cfloop list="#form.seasonid#" index="season"> smgseasonid = #season# <cfif season EQ #ListLast(form.seasonid)#><Cfelse>or</cfif> </cfloop> )
	UNION
	SELECT 'F-Placed', count( studentid ) AS result
	FROM smg_students
	INNER JOIN smg_countrylist ON countryresident = countryid
	INNER JOIN smg_programs p ON smg_students.programid = p.programid
	WHERE smg_students.active = '1' AND continent != 'asia' AND hostid != '0' AND sex = 'female' AND `host_fam_approved` < '5' AND onhold_approved <= '4'
		<cfif client.companyid NEQ '5'>AND p.companyid = '#client.companyid#'</cfif>
		  AND ( <cfloop list="#form.seasonid#" index="season"> smgseasonid = #season# <cfif season EQ #ListLast(form.seasonid)#><Cfelse>or</cfif> </cfloop> )	  
</cfquery>
<table align="center" width="90%" cellpadding=6 cellspacing="0" frame="box"><br>
<tr><th bgcolor="CCCCCC">#companyshort.companyshort# &nbsp; - &nbsp; Non-Asian Female - Unplaced x Placed
<cfset get_total = '0'>
<cfloop query="non_asian_female_statistics"><cfset get_total = get_total + result></cfloop>&nbsp; &nbsp; Total of &nbsp; #get_total# &nbsp; Students</th></tr>
<tr><td align="center"><cfgraph query="non_asian_female_statistics" type="pie" valueColumn="result" itemColumn="F-Unplaced" graphHeight="200" graphWidth="300"></cfgraph></td></tr>
</table><br>

<!--- ASIANS COUNTRY LIST --->
<cfquery name="get_list_countries" datasource="MySql">
	SELECT *  FROM smg_countrylist WHERE continent = 'asia'  ORDER BY countryname
</cfquery>
<table cellpadding=6 cellspacing="0" align="center" frame="box" width="90%">
<tr><td align="center" bgcolor="ededed">
Asian countries included in these graphics:</td></tr>	
<tr><td><cfloop query="get_list_countries">#get_list_countries.countryname# &nbsp; &nbsp;</cfloop></td></tr>
<tr><td><font size="-3"><i>If you would like to add/delete countries, please go to Tools -> Countries</i></font></td></tr>	
</table><br>

</cfoutput>