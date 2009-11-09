<link rel="stylesheet" href="reports.css" type="text/css">

<cfif not IsDefined('form.programid')>
<table width='100%' cellpadding=6 cellspacing="0" align="center" frame="box">
<tr><td align="center">
<h1>Sorry, It was not possible to proccess you request at this time due the program information was not found.<br>
Please close this window and be sure you select at least one program from the programs list before you run the report.</h1>
<center><input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()"></center>
</td></tr>
</table>
<cfabort>
</cfif>

<!--- Get Program --->
<cfquery name="get_program" datasource="MYSQL">
	SELECT	*
	FROM 	smg_programs 
	LEFT JOIN smg_program_type ON type = programtypeid
	WHERE 	(<cfloop list=#form.programid# index='prog'>
			programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop> )
</cfquery>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<!--- get company region --->
<cfquery name="get_region" datasource="MySQL">
	SELECT	regionname, company, regionid
	FROM smg_regions
	WHERE company = '#client.companyid#'
		<cfif form.regionid is  not 0>
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

<!--- get total students in program --->
<cfquery name="get_total_students" datasource="MySQL">
	SELECT	studentid, hostid
	FROM 	smg_students
	WHERE companyid = #client.companyid# 
		and active = '1' 
		AND hostid <> '0'
		AND host_fam_approved <= '4'
		<cfif IsDefined('form.dates')>
			AND (dateplaced between #CreateODBCDateTime(form.date1)# and #CreateODBCDateTime(form.date2)#) 
		</cfif>
		  	AND (<cfloop list=#form.programid# index='prog'>
			programid = #prog# 
		<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
		</cfloop> )
		<cfif client.usertype is '6'>
			AND (arearepid = 
			<cfloop list="#ad_users#" index='i' delimiters = ",">
		 	'#i#' <cfif #ListLast(ad_users)# is #i#><cfelse> or arearepid = </cfif> </Cfloop>)	
		</cfif>				
</cfquery>

<table width='100%' cellpadding=6 cellspacing="0" align="center">
<span class="application_section_header"><cfoutput>#companyshort.companyshort# - Students Placed by Supervising Rep.</cfoutput></span>
</table>
<br>

<table width='100%' cellpadding=6 cellspacing="0" align="center" frame="box">
<tr><td align="center">
	Program(s) Included in this Report:<br>
	<cfoutput query="get_program"><b>#programname# &nbsp; (#ProgramID#)</b><br></cfoutput>
	<cfoutput>Total of Students <b>placed</b> in program: #get_total_students.recordcount#</cfoutput>
	</td></tr>
</table>

<br> <!--- table header --->
<table width='100%' cellpadding=6 cellspacing="0" align="center" frame="box">	
<tr><th width="75%">Region</th> <th width="25%">Total Assigned</th></tr>
<tr><td width="75%">Supervising Rep.</td><td width="25%" align="center">Total Placed</td></tr>
</table>
<br>

<cfloop query="get_region">
	
	<cfset current_region = get_region.regionid>
	
	<Cfquery name="list_repid" datasource="MySQL">
	SELECT arearepid, u.firstname as repname
	FROM smg_students
	LEFT JOIN smg_users u ON arearepid = userid
	where smg_students.active = '1' AND smg_students.regionassigned = '#get_region.regionid#' AND smg_students.companyid = '#client.companyid#' 
			 AND smg_students.hostid <> '0'
			 AND (<cfloop list=#form.programid# index='prog'>
				smg_students.programid = #prog# 
				<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
				</cfloop> )
			<cfif client.usertype is '6'>
				AND ( userid = 
				<cfloop list="#ad_users#" index='i' delimiters = ",">
				'#i#' <cfif #ListLast(ad_users)# is #i#><cfelse> or userid = </cfif> </Cfloop>)
			</cfif>				
	Group by arearepid
	Order by repname
	</cfquery>
	
	<Cfquery name="get_total_in_region" datasource="MySQL">
		select studentid
		from smg_students
		where active = '1' AND regionassigned = '#get_region.regionid#'  AND companyid = '#client.companyid#'		<cfif IsDefined('form.dates')>
			AND (dateplaced between #CreateODBCDateTime(form.date1)# and #CreateODBCDateTime(form.date2)#) 
		</cfif>
AND hostid <> '0'
			   	  		   AND (<cfloop list=#form.programid# index='prog'>
							programid = #prog# 
							<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
							</cfloop> )
							<cfif client.usertype is '6'>
							AND ( arearepid = 
							<cfloop list="#ad_users#" index='i' delimiters = ",">
							'#i#' <cfif #ListLast(ad_users)# is #i#><cfelse> or arearepid = </cfif> </Cfloop>)	
							</cfif>				
	</cfquery> 
	
	<cfif get_total_in_region.recordcount is not 0>
	<table width='100%' cellpadding=6 cellspacing="0" align="center" frame="box">	
		<tr><th width="75%"><cfoutput>#get_region.regionname#</th><td width="25%" align="center"><b>#get_total_in_region.recordcount#</b></td></cfoutput></tr>
	</table><br>
	<cfloop query="list_repid">
		<Cfquery name="get_rep_info" datasource="MySQL">
			select userid, firstname, lastname
			from smg_users
			where userid = '#list_repid.arearepid#'
		</cfquery>

		<Cfquery name="get_students_region" datasource="MySQL">
			select s.studentid, s.firstname, s.familylastname, s.sex, s.programid, s.placerepid, s.dateplaced, s.hostid,
			c.countryname, h.familylastname as hostlastname, h.city as hostcity, h.state as hoststate, h.phone as hostphone
			from smg_students s
			INNER JOIN smg_countrylist c ON s.countryresident = countryid
			INNER JOIN smg_hosts h ON s.hostid = h.hostid
			where s.active = '1' AND s.regionassigned = '#current_region#'  AND s.companyid = '#client.companyid#' 
    				   	       AND s.arearepid = '#list_repid.arearepid#' AND s.host_fam_approved <= '4'
							   <cfif IsDefined('form.dates')>
							   AND (s.dateplaced between #CreateODBCDateTime(form.date1)# and #CreateODBCDateTime(form.date2)#) 
							   </cfif>
							   AND (<cfloop list=#form.programid# index='prog'>
								s.programid = #prog# 
								<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
								</cfloop> )
		</cfquery> 
		
		<cfif get_students_region.recordcount is not 0> 
			<table width='100%' cellpadding=6 cellspacing="0" align="center" frame="box">
				<tr><td width="75%" align="left">
					<cfoutput> &nbsp; <cfif get_rep_info.firstname is '' and get_rep_info.lastname is ''><font color="red">Missing or Unknown</font><cfelse>
					#get_rep_info.firstname# #get_rep_info.lastname#</u></cfif>
					</td>
					<td width="25%" align="center">#get_students_region.recordcount#</td></cfoutput></tr>
			</table>
			<table width='100%' frame=below cellpadding=6 cellspacing="0" align="center" frame="border">
				<tr>
					<td width="7%">ID</th>
					<td width="13%">First Name</td>
					<td width="13%">Last Name</td>
					<td width="7%" align="center">Gender</td>
					<td width="13%">Country</td>
					<td width="13%">Host Name</td>
					<td width="10%">Host Phone</td>
					<td width="13%">Host City / State</td>
					<td width="11%" align="center">Place Date</td>			
				</tr>	
				<cfoutput query="get_students_region">
					<tr bgcolor="#iif(get_students_region.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
						<td>#studentid#</td>
						<td>#firstname#</td>
						<td>#familylastname#</td>
						<td align="center">#sex#</td>
						<td>#countryname#</td>
						<td>#hostlastname# (#hostid#)</td>
						<td>#hostphone#</td>
						<td>#hostcity#, #hoststate#</td>				
						<td align="center">#DateFormat(dateplaced, 'mm/dd/yy')#</td>		
					</tr>							
				</cfoutput>	
			</table><br>				
		</cfif>  <!--- get_students_region.recordcount is not 0 ---> 
	
	</cfloop> <!--- cfloop query="list_repid" --->
	
	</cfif> <!---  get_total_in_region.recordcount --->
</cfloop> <!--- cfloop query="get_region" --->
<br>