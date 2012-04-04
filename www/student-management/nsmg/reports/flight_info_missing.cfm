<cfinclude template="../querys/get_company_short.cfm">

<link rel="stylesheet" href="../profile.css" type="text/css">
<link rel="stylesheet" href="reports.css" type="text/css">

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

<!--- get agents --->
<cfquery name="get_agents" datasource="MySQL">
	SELECT userid, businessname, smg_users.email
	FROM smg_users
	INNER JOIN smg_students s ON s.intrep = smg_users.userid
	INNER JOIN smg_hosts ON s.hostid = smg_hosts.hostid
	<cfif form.preayp EQ 'all'>
		INNER JOIN smg_aypcamps camp ON (camp.campid = s.aypenglish OR camp.campid = s.ayporientation)
	<cfelseif form.preayp EQ 'english'>
		INNER JOIN smg_aypcamps camp ON camp.campid = s.aypenglish
	<cfelseif form.preayp EQ 'orientation'>
		INNER JOIN smg_aypcamps camp ON camp.campid = s.ayporientation
	</cfif>
	WHERE s.active = '1'
		<cfif form.intrep is 0><cfelse>AND userid = '#form.intrep#'</cfif>
		AND s.host_fam_approved < '5'
		AND	( <cfloop list=#form.programid# index='prog'>
			s.programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
		</cfloop> )
	GROUP BY businessname
	ORDER BY businessname
</cfquery>

<span class="application_section_header"><cfoutput>#companyshort.companyshort# - Missing Arrival Flight Information</cfoutput></span>
<br>

<cfoutput>
<table width='100%' cellpadding=4 cellspacing="0" align="center" bgcolor="FFFFFF" frame="box">
	<tr><td class="style3"><b>Program(s) :</b><br> 
	<cfloop query="get_program"><i>#get_program.companyshort# &nbsp; #get_program.programname#</i><br></cfloop></td></tr>
	<!--- <tr><td>Total of #get_total_students.recordcount# students in this report.</td></tr> --->
</table><br>

<cfloop query="get_agents">
	
<cfquery name="get_students" datasource="MySql">
		SELECT 	s.studentid, s.firstname, s.familylastname, s.arearepid, 
				h.familylastname as hostlastname, h.state, h.city, h.major_air_code
		FROM smg_students s 
		INNER JOIN smg_programs p ON s.programid = p.programid
		INNER JOIN smg_users u ON s.intrep = u.userid
		INNER JOIN smg_regions r ON s.regionassigned = r.regionid
		INNER JOIN smg_hosts h ON s.hostid = h.hostid
		<cfif form.preayp EQ 'all'>
			INNER JOIN smg_aypcamps camp ON (camp.campid = s.aypenglish OR camp.campid = s.ayporientation)
		<cfelseif form.preayp EQ 'english'>
			INNER JOIN smg_aypcamps camp ON camp.campid = s.aypenglish
		<cfelseif form.preayp EQ 'orientation'>
			INNER JOIN smg_aypcamps camp ON camp.campid = s.ayporientation
		</cfif>
		WHERE 
        	s.active = '1' 
		AND 
        	s.intrep = '#get_agents.userid#' 
		AND 
        	s.host_fam_approved < '5'
		AND	( 
        	<cfloop list=#form.programid# index='prog'>
				s.programid = #prog# 
				<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop> )
		AND 
        	s.studentid NOT IN (
            	SELECT 
                	studentid 
                FROM 
                	smg_flight_info 
                WHERE 
                	flight_type IN ( <cfqueryparam cfsqltype="cf_sql_varchar" value="arrival,preAypArrival" list="yes"> )
                AND 
                	isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0"> 
                )
     	AND
        	s.app_current_status = <cfqueryparam cfsqltype="cf_sql_integer" value="11">			
		Order by s.firstname
	</cfquery>
	
	<cfif get_students.recordcount NEQ 0>
		<table width='100%' cellpadding=4 cellspacing="0" align="center" bgcolor="FFFFFF" frame="box">
		<tr><td class="style3"><b>International Agent :</b> &nbsp; <a href="mailto:#get_agents.email#"><i>#get_agents.businessname#</i></a> &nbsp; &nbsp; &nbsp; &nbsp; Total of #get_students.recordcount# student(s)</tr>
		</table><br>
		<table width=100% border=0 cellpadding=6 cellspacing="2" align="center" bgcolor="FFFFFF">
		<tr>
			<th width="30%" align="left">Student</th>
			<th width="17%" align="left">Host Family</th>
			<th width="17%" align="left">City</th>
			<th width="5%" align="left">State</th>
			<th width="5%" align="left">Airport</th>
			<th width="26%" align="center">Arrival Information</th>
		</tr>
		<cfloop query="get_students">
		<tr bgcolor="#iif(get_students.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
			<td>#firstname# #familylastname# (#studentid#)</td>
			<td>#hostlastname#</td>
			<td>#city#</td>
			<td align="center">#state#</td>
			<td align="center">#major_air_code#</td>
			<td align="center"></td>	
		</tr>
		</cfloop>
		</table><br>
	</cfif>
</cfloop>
</cfoutput>