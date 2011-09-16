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

<!--- get company region --->
<cfquery name="get_region" datasource="MySQL">
	SELECT	regionname, company, regionid, smg_companies.companyshort
	FROM smg_regions
	INNER JOIN smg_companies ON smg_companies.companyid = smg_regions.company
	WHERE 1=1
	<cfif client.companyid NEQ '5'>AND company = '#client.companyid#'</cfif>
	<cfif form.regionid NEQ 0>AND regionid = '#form.regionid#'</cfif>
	ORDER BY companyshort, regionname
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
<span class="application_section_header">#companyshort.companyshort# - Missing Arrival Flight Information</span><br>

<table width='100%' cellpadding=4 cellspacing="0" align="center" bgcolor="FFFFFF" frame="box">
	<tr><td class="style3"><b>Program(s) :</b><br> 
	<cfloop query="get_program"><i>#get_program.companyshort# &nbsp; #get_program.programname#</i><br></cfloop></td></tr>
</table><br>

<cfloop query="get_region">
	<cfquery name="get_students" datasource="MySql">
	SELECT 	s.studentid, s.firstname, s.familylastname, s.arearepid, s.dateplaced,
			u.firstname as super_name, u.lastname as super_lastname,
			h.familylastname as hostlastname, h.state, h.city, h.major_air_code,
			intrep.businessname,
			p.programname,
			r.regionname,
			sc.begins
	FROM smg_students s 
	INNER JOIN smg_programs p ON s.programid = p.programid
	INNER JOIN smg_regions r ON s.regionassigned = r.regionid
	LEFT JOIN smg_hosts h ON s.hostid = h.hostid
	INNER JOIN smg_users intrep ON s.intrep = intrep.userid
	LEFT JOIN smg_schools sc ON s.schoolid = sc.schoolid
	LEFT JOIN smg_users u ON s.arearepid = u.userid
	<cfif form.preayp EQ 'all'>
		INNER JOIN smg_aypcamps camp ON (camp.campid = s.aypenglish OR camp.campid = s.ayporientation)
	<cfelseif form.preayp EQ 'english'>
		INNER JOIN smg_aypcamps camp ON camp.campid = s.aypenglish
	<cfelseif form.preayp EQ 'orientation'>
		INNER JOIN smg_aypcamps camp ON camp.campid = s.ayporientation
	</cfif>	
	WHERE s.active = 1 
			AND s.host_fam_approved < '5'
			AND s.regionassigned = #get_region.regionid# 
			AND	( <cfloop list=#form.programid# index='prog'>
					s.programid = #prog# 
					<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
				</cfloop> )
			AND s.studentid NOT IN (
            	SELECT 
                	studentid 
                FROM 
                	smg_flight_info 
                WHERE 
                	flight_type IN ( <cfqueryparam cfsqltype="cf_sql_varchar" value="arrival,preAypArrival" list="yes"> )
                AND 
                	isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0"> 
                )		
		<cfif client.usertype is '6'>
			AND ( s.placerepid = 
			<cfloop list="#ad_users#" index='i' delimiters = ",">
		 		'#i#' <cfif #ListLast(ad_users)# is #i#><cfelse> or s.placerepid = </cfif> </Cfloop>)
			AND ( s.arearepid = 
				<cfloop list="#ad_users#" index='i' delimiters = ",">
		 		'#i#' <cfif #ListLast(ad_users)# is #i#><cfelse> or s.arearepid = </cfif> </Cfloop>)
		</cfif>	
 		<cfif client.usertype is '7'>
			AND (s.placerepid = '#client.userid#' or s.arearepid = '#client.userid#' )
		</cfif>
        
        <cfif form.place_date1 is not '' and form.place_date2 is not ''>
        	AND dateplaced between #CreateODBCDate(form.place_Date1)# and #CreateODBCDate(form.place_Date2)#
        </cfif>
		
	GROUP BY s.studentid
	ORDER BY r.regionname, u.lastname, s.firstname
	</cfquery>
    
	
	<cfif get_students.recordcount is '0'><cfelse>
	<table border="1" align="center" width='100%' bordercolor="C0C0C0" valign="top" cellpadding="3" cellspacing="1">
		<tr><td class="style3" colspan="2"><b>Region :</b> &nbsp; <i>#get_region.companyshort# &nbsp; #get_region.regionname#</i> &nbsp; &nbsp; &nbsp; &nbsp; Total of #get_students.recordcount# student(s)</tr>
	</table><br>
	
	<table width=100% border=0 cellpadding=6 cellspacing="2" align="center" bgcolor="FFFFFF">
		<tr>
			<th width="28%" align="left">Student</th>
			<th width="16%" align="left">Int. Rep</th>
			<th width="17%" align="left">Host Family</th>
			<th width="17%" align="left">City</th>
			<th width="5%" align="left">State</th>
			<th width="5%" align="left">Airport</th>
			<th width="12%" align="center">Arrival Info</th>
            <th align="Center">Date Placed</th>
		</tr>
		<cfloop query="get_students">
			<tr bgcolor="#iif(get_students.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
				<td>#firstname# #familylastname# (#studentid#)</td>
				<td>#businessname#</td>
				<td>#hostlastname#</td>
				<td>#city#</td>
				<td align="center">#state#</td>
				<td align="center">#major_air_code#</td>
				<td align="center"></td>
                <td align="Center">#DateFormat(dateplaced,'mm/dd/yyyy')#</td>	
			</tr>
		</cfloop>
	</table><br>
	</cfif>
</cfloop> <!--- region --->
</cfoutput>