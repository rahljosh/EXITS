<cfinclude template="../querys/get_company_short.cfm">

<link rel="stylesheet" href="../profile.css" type="text/css">
<link rel="stylesheet" href="../reports.css" type="text/css">

<style type="text/css">
table.nav_bar { font-size: 10px; background-color: #ffffff; border: 1px solid #999999; }
.style3 {font-size: 13px}
</style>

<!--- Get Program --->
<cfquery name="get_program" datasource="MYSQL">
	SELECT	*
	FROM 	smg_programs 
	LEFT JOIN smg_program_type ON type = programtypeid
	WHERE <cfloop list=#form.programid# index='prog'>
			programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
		</cfloop>
</cfquery>

<!--- get company region --->
<cfquery name="get_region" datasource="MySQL">
	SELECT	regionname, company, regionid
	FROM smg_regions
	WHERE company = '#client.companyid#'
	<cfif form.regionid is 0>
	<cfelse>
		AND regionid = '#form.regionid#'	
	</cfif>
	ORDER BY regionname
</cfquery>

<cfif client.usertype is '6'> <!--- advisors --->
	<cfquery name="get_users_under_adv" datasource="MySql">
		SELECT userid
		FROM smg_users
		WHERE advisor_id = '#client.userid#' and companyid like '%#client.companyid#%'
	</cfquery>

	<cfset ad_users = ValueList(get_users_under_adv.userid, ',')>
	<cfset ad_users = ListAppend(ad_users, #client.userid#)>
</cfif> <!--- advisors --->

<cfoutput>
<span class="application_section_header">#companyshort.companyshort# - Students in the USA Missing School Acceptance Form</span><br><br>

<table width='100%' cellpadding=4 cellspacing="0" align="center" bgcolor="FFFFFF" frame="box">
	<tr><td class="style3"><b>Program(s) :</b><br> 
	<cfloop query="get_program"><i>&nbsp; #get_program.programname#</i><br></cfloop></td></tr>
</table><br>

<!--- table header --->
<table width='100%' cellpadding=4 cellspacing="0" align="center" frame="box">	
<tr><th width="85%">Region</th> <th width="15%">Total Assigned</th></tr>
</table><br>

<cfloop query="get_region">

	<cfquery name="get_students" datasource="MySql">
		SELECT 	s.studentid, s.firstname, s.familylastname, s.arearepid, s.doc_school_accept_date,
				u.firstname as super_name, u.lastname as super_lastname,
				p.programname,
				r.regionname, 
				sc.begins,
				flight.dep_date
		FROM smg_students s
		INNER JOIN smg_programs p ON s.programid = p.programid
		INNER JOIN smg_regions r ON s.regionassigned = r.regionid
		INNER JOIN smg_schools sc ON s.schoolid = sc.schoolid
		INNER JOIN smg_users u ON s.arearepid = u.userid
		INNER JOIN smg_flight_info flight ON s.studentid = flight.studentid
		<cfif form.preayp EQ 'all'>
			INNER JOIN smg_aypcamps camp ON (camp.campid = s.aypenglish OR camp.campid = s.ayporientation)
		<cfelseif form.preayp EQ 'english'>
			INNER JOIN smg_aypcamps camp ON camp.campid = s.aypenglish
		<cfelseif form.preayp EQ 'orientation'>
			INNER JOIN smg_aypcamps camp ON camp.campid = s.ayporientation
		</cfif>
		WHERE s.active = 1 
			AND flight.flight_type = 'arrival'
			AND flight.dep_date <= now()
			AND s.regionassigned = '#get_region.regionid#' 
			AND s.doc_school_accept_date IS NULL
			AND	( <cfloop list=#form.programid# index='prog'>
					s.programid = #prog# 
					<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
				</cfloop> )
			<cfif client.usertype EQ '7'>
				AND (s.placerepid = '#client.userid#' or s.arearepid = '#client.userid#' )
			</cfif>
			<cfif client.usertype EQ '6'>
				AND ( s.placerepid = 
				<cfloop list="#ad_users#" index='i' delimiters = ",">
					'#i#' <cfif #ListLast(ad_users)# is #i#><cfelse> or s.placerepid = </cfif> </Cfloop>)
				AND ( s.arearepid = 
					<cfloop list="#ad_users#" index='i' delimiters = ",">
					'#i#' <cfif #ListLast(ad_users)# is #i#><cfelse> or s.arearepid = </cfif> </Cfloop>)
			</cfif>	
		GROUP BY s.studentid
		ORDER BY r.regionname, u.lastname, s.firstname
	</cfquery>
	
	<cfif get_students.recordcount is '0'><cfelse>
		
		<table width='100%' cellpadding=4 cellspacing="0" align="center" frame="below">	
			<tr><th width="85%" bgcolor="CCCCCC"><cfoutput>#get_region.regionname#</th><td width="15%" align="center" bgcolor="CCCCCC"><b>#get_students.recordcount#</b></td></cfoutput></tr>
		</table>

		<table width='100%' frame=below cellpadding=4 cellspacing="0" align="center" frame="border">
			<tr>
				<td width="4%">ID</th>
				<td width="18%">Student</td>
				<td width="8%">Arrival Date</td>
				<td width="70%">Missing Documents</td>
			</tr>	
		<cfloop query="get_students">
			<!--- 	<cfquery name="get_arrival" datasource="MySql">
				SELECT max(flightid) as lastflight, dep_date
				FROM smg_flight_info  
				WHERE studentid = '#get_students.studentid#' and flight_type = 'arrival'
				GROUP BY studentid
			</cfquery> --->
			<tr>
				<td>#studentid#</td>
				<td>#firstname# #familylastname#</td>
				<td><cfif dep_date NEQ ''>#DateFormat(dep_date, 'mm/dd/yyyy')#</cfif></td>
				<td align="left"><i><font size="-2"><cfif doc_school_accept_date is ''>School Acceptance &nbsp; &nbsp;</cfif></font></i></td>
			</tr>		
		</cfloop> <!--- student --->
		</table><br>
	</cfif>
</cfloop> <!--- region --->
</cfoutput>