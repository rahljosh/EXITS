<cfif isDefined('url.hostid')>
	<cfset client.hostid = #url.hostid#>
</cfif>

<script>
function areYouSure() { 
   if(confirm("You are about to delete this Host Family. You will not be able to recover this information. Click OK to continue")) { 
     form.submit(); 
        return true; 
   } else { 
        return false; 
   } 
} 
</script>

<cfquery name="user_compliance" datasource="caseusa">
	SELECT userid, compliance
	FROM smg_users
	WHERE userid = <cfqueryparam value="#client.userid#" cfsqltype="cf_sql_integer">
</cfquery>

<cfinclude template="querys/family_info.cfm">

<cfif family_info.recordcount EQ 0>
	The host family ID you are looking for, <cfoutput>#url.hostid#</cfoutput>, was not found. This could be for a number of reasons.<br><br>
	<ul>
		<li>the host family record was deleted or renumbered
		<li>the link you are following is out of date
		<li>you do not have proper access rights to view this host family
	</ul>
	If you feel this is incorrect, please contact <a href="mailto:support@case-usa.org">Support</a>
	<cfabort>
</cfif>

<!-----Host Children----->
<cfquery name="host_children" datasource="caseusa">
	SELECT *
	FROM smg_host_children
	WHERE hostid = '#family_info.hostid#'
	ORDER BY birthdate
</cfquery>

<!----- Students being Hosted----->
<cfquery name="hosting_students" datasource="caseusa">
	SELECT studentid, familylastname, firstname, p.programname, c.countryname
	FROM smg_students
	INNER JOIN smg_programs p ON smg_students.programid = p.programid
	LEFT JOIN smg_countrylist c ON smg_students.countryresident = c.countryid
	WHERE hostid = '#family_info.hostid#'
	ORDER BY familylastname
</cfquery>

<!--- Students previous hosted --->
<cfquery name="hosted_students" datasource="caseusa">
	SELECT DISTINCT h.studentid, familylastname, firstname, p.programname, c.countryname
	FROM smg_students
	INNER JOIN smg_hosthistory h ON smg_students.studentid = h.studentid
	INNER JOIN smg_programs p ON smg_students.programid = p.programid
	LEFT JOIN smg_countrylist c ON smg_students.countryresident = c.countryid
	WHERE h.hostid = '#family_info.hostid#'
	ORDER BY familylastname
</cfquery>

<!--- REGION --->
<cfquery name="get_region" datasource="caseusa">
	SELECT regionid, regionname
	FROM smg_regions
	WHERE regionid = '#family_info.regionid#'
</cfquery>

<!--- SCHOOL ---->
<cfquery name="get_school" datasource="caseusa">
	SELECT schoolid, schoolname, address, city, state, begins, ends
	FROM smg_Schools
	WHERE schoolid = '#family_info.schoolid#'
</cfquery>

<style type="text/css">
<!--
div.scroll {
	height: 155px;
	width:auto;
	overflow:auto;
	border-left: 2px solid #c6c6c6;
	border-right: 2px solid #c6c6c6;
	background: #Ffffe6;
	left:auto;
}
div.scroll2 {
	height: 100px;
	width:auto;
	overflow:auto;
	border-left: 2px solid #c6c6c6;
	border-right: 2px solid #c6c6c6;
	background: #Ffffe6;
	left:auto;
}
</style>

<cfoutput>
<table cellpadding="0" cellspacing="0" border="0" width="100%">
<tr><td width="60%" align="left" valign="top">
	<!--- HEADER OF TABLE --- Host Family Information --->
	<table width=100% cellpadding=0 cellspacing=0 border=0 height=24 >
		<tr valign=middle height=24>
			<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td><td width=26 background="pics/header_background.gif"><img src="pics/family.gif"></td>
			<td background="pics/header_background.gif"><h2>Host Family Information</h2></td><cfif client.usertype LTE '4'><td background="pics/header_background.gif"><a href="?curdoc=querys/delete_host&hostid=#hostid#" onClick="return areYouSure(this);"><img src="pics/deletex.gif" border="0"></img></a></td></cfif>
			<td background="pics/header_background.gif" width=16><a href="?curdoc=forms/edit_host_fam_pis&hostid=#hostid#"><img src="pics/edit.png" border=0 alt="Edit"></a></td><td width=17 background="pics/header_rightcap.gif">&nbsp;</td></tr>
	</table>
	<!--- BODY OF A TABLE --->
	<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
		<tr><td>Family Name:</td><td>#family_info.familylastname#</td><td>ID:</td><td>#family_info.hostid#</td></tr>
		<tr><td>Address:</td><td>#family_info.address#</td></tr>
		<tr><td>City:</td><td>#family_info.city#</td></tr>
		<tr><td>State:</td><td>#family_info.state#</td><td>ZIP:</td><td>#family_info.zip#</td></tr>
		<tr><td>Phone:</td><td>#family_info.phone#</td></tr>
		<tr><td>Email:</td><td><a href="mailto:#family_info.email#">#family_info.email#</a></td></tr>
		<tr><td>Host Father:</td><td>#family_info.fatherfirstname# #family_info.fatherlastname# &nbsp; <cfif family_info.fatherbirth is '0'><cfelse> <cfset calc_age_father = #CreateDate(family_info.fatherbirth,01,01)#> (#DateDiff('yyyy', calc_age_father, now())#) </cfif></td><td>Occupation:</td><td><cfif family_info.fatherworkposition is ''>n/a<cfelse>#family_info.fatherworkposition#</cfif></td></tr>
		<tr><td>Host Mother:</td><td>#family_info.motherfirstname# #family_info.motherlastname#  &nbsp; <cfif family_info.motherbirth is '0'><cfelse> <cfset calc_age_mom = #CreateDate(family_info.motherbirth,01,01)#> (#DateDiff('yyyy', calc_age_mom, now())#) </cfif></td><td>Occupation:</td><td><cfif family_info.motherworkposition is ''>n/a<cfelse>#family_info.motherworkposition#</cfif></td></tr>
	</table>	
	<!--- BOTTOM OF A TABLE --->
	<table width=100% cellpadding=0 cellspacing=0 border=0>
		<tr valign="bottom"><td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td><td width=100% background="pics/header_background_footer.gif"></td><td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td></tr>
	</table>		
</td>
<td width="2%"></td> <!--- SEPARATE TABLES --->
<td width="38%" align="right" valign="top">
	<!--- HEADER OF TABLE --- Other Family Members --->
	<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
		<tr valign=middle height=24>
			<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td><td width=26 background="pics/header_background.gif"><img src="pics/family.gif"></td>
			<td background="pics/header_background.gif"><h2>Other Family Members</h2></td><td background="pics/header_background.gif" width=16><a href="?curdoc=forms/host_fam_pis_2"><img src="pics/edit.png" border=0 alt="Edit"></a></td>
			<td width=17 background="pics/header_rightcap.gif">&nbsp;</td></tr>
	</table>
	<!--- BODY OF TABLE --->
	<table width=100% border=0 cellpadding=4 cellspacing=0 class="section">
		<tr><td width="40%"><u>Name</u></td>
			<td width="20%"><u>Sex</u></td>
			<td width="20%"><u>Age</u></td>
			<td width="20%"><u>At Home</u></td></tr>
	</table>
	<div class="scroll">
	<table width=100% align="left" border=0 cellpadding=2 cellspacing=0>
		<cfloop query="host_children">
			<tr><td width="40%">#name#</td>
				<td width="20%">#sex#</td>
				<td width="20%"><cfif birthdate NEQ ''>#DateDiff('yyyy', birthdate, now())#</cfif></td>
				<td width="20%">#liveathome#</td></tr>
		</cfloop>
	</table>
	</div>
	<!--- BOTTOM OF A TABLE --->
	<table width=100% cellpadding=0 cellspacing=0 border=0>
		<tr valign="bottom"><td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td><td width=100% background="pics/header_background_footer.gif"></td><td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td></tr>
	</table>		
</td></tr>
</table><br>

<table cellpadding="0" cellspacing="0" border="0" width="100%">
<tr>
	<td width="32%" align="left" valign="top">
		<!--- HEADER OF TABLE --- COMMUNITY INFO --->
		<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
			<tr valign=middle height=24>
				<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td><td width=26 background="pics/header_background.gif"><img src="pics/family.gif"></td>
				<td background="pics/header_background.gif"><h2>Community Info</h2></td><td background="pics/header_background.gif" width=16><a href="?curdoc=forms/family_app_7_pis"><img src="pics/edit.png" border=0 alt="Edit"></a></td>
				<td width=17 background="pics/header_rightcap.gif">&nbsp;</td></tr>
		</table>
		<!--- BODY OF TABLE --->
		<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
			<tr><td>Region:</td><td colspan="3"><cfif get_region.regionname is ''>not assigned<cfelse>#get_region.regionname#</cfif></td></tr>
			<tr><td>Community:</td><td colspan="3"><cfif family_info.community is ''>n/a<cfelse> #family_info.community#</cfif></td></tr>
			<tr><td>Closest City:</td><td><cfif family_info.nearbigcity is ''>n/a<cfelse> #family_info.nearbigcity#</cfif></td><td>Distance:</td><td>#family_info.near_City_dist# miles</td></tr>
			<tr><td>Airport Code:</td><td colspan="3"><cfif family_info.major_air_code is ''>n/a<cfelse> #family_info.major_air_code#</cfif></td></tr>
			<tr><td>Airport City:</td><td colspan="3"><cfif family_info.airport_city is '' and family_info.airport_state is ''>n/a<cfelse>#family_info.airport_city# / #family_info.airport_state#</cfif></td></tr>
			<tr><td valign="top">Interests: </td><td colspan="3"><cfif len(#family_info.pert_info#) gt '100'>#Left(family_info.pert_info,92)# <a href="?curdoc=forms/family_app_7_pis">more...</a><cfelse>#family_info.pert_info#</cfif></td></tr>
		</table>				
		<!--- BOTTOM OF A TABLE  --- COMMUNITY INFO --->
		<table width=100% cellpadding=0 cellspacing=0 border=0>
			<tr valign="bottom"><td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td><td width=100% background="pics/header_background_footer.gif"></td><td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td></tr>
		</table>				
	</td>
	<td width="2%"></td> <!--- SEPARATE TABLES --->
	<td width="28%" align="center" valign="top">
		<!--- HEADER OF TABLE --- SCHOOL --->
		<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
			<tr valign=middle height=24>
				<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td><td width=26 background="pics/header_background.gif"><img src="pics/school.gif"></td>
				<td background="pics/header_background.gif"><h2>School Info</h2></td><td background="pics/header_background.gif" width=16><a href="?curdoc=forms/host_fam_pis_5"><img src="pics/edit.png" border=0 alt="Edit"></a></td>
				<td width=17 background="pics/header_rightcap.gif">&nbsp;</td></tr>
		</table>
		<!--- BODY OF TABLE --->
		<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
			<tr><td>School:</td><td><cfif get_school.recordcount is '0'>there is no school assigned<cfelse>#get_school.schoolname#</cfif></td></tr>
			<tr><td>Address:</td><td><cfif get_school.address is ''>n/a<cfelse>#get_school.address#</cfif></td></tr>
			<tr><td>City:</td><td><cfif get_school.city is ''>n/a<cfelse>#get_school.city#</cfif></td></tr>
			<tr><td>State:</td><td><cfif get_school.state is ''>n/a<cfelse>#get_school.state#</cfif></td></tr>
			<!----
			<tr><td>Start Date:</td><td><cfif get_school.begins is ''>n/a<cfelse>#DateFormat(get_school.begins, 'mm/dd/yyyy')#</cfif></td></tr>
			<tr><td>End Date:</td><td><cfif get_school.ends is ''>n/a<cfelse>#DateFormat(get_school.ends, 'mm/dd/yyyy')#</cfif></td></tr>			
			---->
			<tr><td>&nbsp;</td></tr>
		</table>				
		<!--- BOTTOM OF A TABLE --- SCHOOL  --->
		<table width=100% cellpadding=0 cellspacing=0 border=0>
			<tr valign="bottom"><td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td><td width=100% background="pics/header_background_footer.gif"></td><td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td></tr>
		</table>		
	</td>
	<td width="2%"></td> <!--- SEPARATE TABLES --->
	<td width="36%" align="right" valign="top">
		<!--- HEADER OF TABLE --- STUDENTS --->
		<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
			<tr valign=middle height=24>
				<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td><td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
				<td background="pics/header_background.gif"><h2>Students </h2></td><td align="right" background="pics/header_background.gif"><font size="-1">[ Hosting / Hosted ]</font></td>
				<td width=17 background="pics/header_rightcap.gif">&nbsp;</td></tr>
		</table>
		<!--- BODY OF TABLE --->
		<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
			<tr><td width="10%"><u>ID</u></td>
				<td width="50%"><u>Name</u></td>
				<td width="20%"><u>Country</u></td>
				<td width="20%"><u>Program</u></td></tr>
		</table>
		<div class="scroll2">
		<table width=100% align="left" border=0 cellpadding=1 cellspacing=0>
			<cfif hosting_students.recordcount is '0'>
				<tr><td colspan="4" align="center">no current students are assigned to this host family</td></tr>
			<cfelse>			
				<tr><td colspan="4" bgcolor="e2efc7"><u>Current Students</u></td></tr>
				<cfloop query="hosting_students">
					<tr bgcolor="e2efc7"><td width="10%"><A href="?curdoc=student_info&studentid=#studentid#">#studentid#</A></td>
						<td width="50%"><A href="?curdoc=student_info&studentid=#studentid#">#firstname# #familylastname#</td>
						<td width="20%">#countryname#</td>
						<td width="20%">#programname#</td></tr>
				</cfloop>
			</cfif>	
			<cfif hosted_students.recordcount is '0'>
				<tr><td colspan="4" align="center">no previous students were assigned to this host family</td></tr>
			<cfelse>			
				<tr><td colspan="4"><u>Students Hosted</u></td></tr>
				<cfloop query="hosted_students">
					<tr><td width="10%"><A href="?curdoc=student_info&studentid=#studentid#">#studentid#</A></td>
						<td width="50%"><A href="?curdoc=student_info&studentid=#studentid#">#firstname# #familylastname#</td>
						<td width="20%">#countryname#</td>
						<td width="20%">#programname#</td></tr>
				</cfloop>
			</cfif>
		</table>
		</div>			
		<!--- BOTTOM OF A TABLE --- STUDENTS  --->
		<table width=100% cellpadding=0 cellspacing=0 border=0>
			<tr valign="bottom"><td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td><td width=100% background="pics/header_background_footer.gif"></td><td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td></tr>
		</table>		
	</td>
</tr>
</table><br>

<!--- CBC HISTORY --->
<cfquery name="get_cbc_mother" datasource="caseusa">
	SELECT smg_hosts_cbc.hostid, motherssn, motherfirstname, motherlastname, familylastname, batchid,
		 smg_hosts_cbc.seasonid, requestid, date_authorized, date_sent, date_received, flagcbc,batchid,
		smg_seasons.season
	FROM smg_hosts_cbc
	LEFT JOIN smg_seasons ON smg_seasons.seasonid = smg_hosts_cbc.seasonid
	LEFT JOIN smg_hosts ON smg_hosts.hostid = smg_hosts_cbc.hostid
	WHERE smg_hosts_cbc.hostid = <cfqueryparam value="#family_info.hostid#" cfsqltype="cf_sql_integer"> 
		AND cbc_type = 'mother'
	ORDER BY smg_seasons.season
</cfquery>

<cfquery name="get_cbc_father" datasource="caseusa">
	SELECT smg_hosts_cbc.hostid, fatherssn, fatherfirstname, fatherlastname, familylastname, batchid,
		smg_hosts_cbc.seasonid, requestid, date_authorized, date_sent, date_received, flagcbc, 
		smg_seasons.season
	FROM smg_hosts_cbc
	LEFT JOIN smg_seasons ON smg_seasons.seasonid = smg_hosts_cbc.seasonid
	LEFT JOIN smg_hosts ON smg_hosts.hostid = smg_hosts_cbc.hostid
	WHERE smg_hosts_cbc.hostid = <cfqueryparam value="#family_info.hostid#" cfsqltype="cf_sql_integer"> 
		AND cbc_type = 'father'
	ORDER BY smg_seasons.season
</cfquery>

<cfquery name="get_cbc_members" datasource="caseusa">
	SELECT date_authorized, requestid, smg_hosts_cbc.seasonid, date_sent, date_received,  batchid,
		smg_host_children.name,	smg_seasons.season
	FROM smg_hosts_cbc
	LEFT JOIN smg_seasons ON smg_seasons.seasonid = smg_hosts_cbc.seasonid
	LEFT JOIN smg_host_children ON smg_host_children.childid  = smg_hosts_cbc.familyid
	WHERE smg_hosts_cbc.hostid = <cfqueryparam value="#family_info.hostid#" cfsqltype="cf_sql_integer"> 
		AND cbc_type = 'member'
	ORDER BY smg_seasons.season
</cfquery>

<!--- CROSS DATA - check if was submitted under a user --->
<cfquery name="check_mother" datasource="caseusa">
	SELECT DISTINCT u.userid, u.ssn, firstname, lastname, cbc.cbcid, cbc.requestid, date_authorized, date_sent, date_received,
		smg_seasons.season,cbc.batchid
	FROM smg_users u
	INNER JOIN smg_users_cbc cbc ON cbc.userid = u.userid
	LEFT JOIN smg_seasons ON smg_seasons.seasonid = cbc.seasonid
	WHERE u.ssn != ''
		AND cbc.familyid = '0'
		AND ((u.ssn = '#family_info.motherssn#' AND u.ssn != '') OR (u.firstname = '#family_info.motherfirstname#' AND u.lastname = '#family_info.familylastname#' <cfif family_info.fatherdob EQ ''>AND u.dob = '#DateFormat(family_info.fatherdob,'yyyy/mm/dd')#'</cfif>))
</cfquery>
<cfquery name="check_father" datasource="caseusa">
	SELECT DISTINCT u.userid, u.ssn, u.firstname, u.lastname, cbc.cbcid, cbc.requestid, date_authorized, date_sent, date_received,
		smg_seasons.season
	FROM smg_users u
	INNER JOIN smg_users_cbc cbc ON cbc.userid = u.userid
	LEFT JOIN smg_seasons ON smg_seasons.seasonid = cbc.seasonid
	WHERE u.ssn != ''
		AND cbc.familyid = '0'
		AND ((u.ssn = '#family_info.fatherssn#' AND u.ssn != '') OR (u.firstname = '#family_info.fatherfirstname#' AND u.lastname = '#family_info.familylastname#' <cfif family_info.motherdob EQ ''>AND u.dob = '#DateFormat(family_info.fatherdob,'yyyy/mm/dd')#'</cfif>))
</cfquery>


<!--- SIZING TABLE --->
<table cellpadding="0" cellspacing="0" border="0" width="100%">
<tr>
	<td width="60%" valign="top">
		<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
			<tr valign=middle height=24>
				<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
				<td width=26 background="pics/header_background.gif"><img src="pics/notes.gif"></td>
				<td background="pics/header_background.gif"><h2>Criminal Background Check</td>
				<cfif client.usertype EQ '1' OR user_compliance.compliance EQ '1'>
					<td background="pics/header_background.gif" width=16><a href="?curdoc=cbc/hosts_cbc&hostid=#family_info.hostid#"><img src="pics/edit.png" border=0 alt="Edit"></a></td>
				</cfif>
				<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
			</tr>
		</table>
		<table width=100% cellpadding=4 cellspacing=0 border=0 class="section">
			<tr bgcolor="e2efc7">
				<td align="center" valign="top"><b>Name</b></td>
				<td align="center" valign="top"><b>Season</b></td>		
				<td align="center" valign="top"><b>Date Sent</b> <br><font size="-2">mm/dd/yyyy</font></td>		
	 			<td align="center" valign="top"><b>Date Received</b> <br><font size="-2">mm/dd/yyyy</font></td>		
				<td align="center" valign="top"><b>Request ID</b></td>
			</tr>				
			<cfif get_cbc_mother.recordcount EQ '0' AND check_mother.recordcount EQ '0' AND get_cbc_father.recordcount EQ '0' AND check_father.recordcount EQ '0'>
				<tr><td align="center" colspan="5">No CBC has been submitted.</td></tr>
			<cfelse>
				<tr><td colspan="6">Host Mother:</td></tr>
				<cfloop query="get_cbc_mother">
				<tr bgcolor="#iif(currentrow MOD 2 ,DE("white") ,DE("ffffe6") )#"> 
					<td>#family_info.motherfirstname# #family_info.motherlastname#</td>
					<td align="center" style="line-height:20px;"><b>#season#</b></td>
					<td align="center" style="line-height:20px;"><cfif date_sent EQ ''>processing<cfelse>#DateFormat(date_sent, 'mm/dd/yyyy')#</cfif></td>
					<td align="center" style="line-height:20px;"><cfif date_received EQ ''>processing<cfelse>#DateFormat(date_received, 'mm/dd/yyyy')#</cfif></td>
					<td align="center" style="line-height:20px;"><cfif requestid EQ ''>processing<cfelseif flagcbc EQ 1 AND client.usertype LTE 4>On Hold Contact Compliance<cfelse><cfif client.usertype lte 4><a href="?curdoc=cbc/view_host_cbc&file=batch_#batchid#_host_mother_#hostid#_rec.xml"></cfif>#requestid#</a></cfif></td>
				</tr>
				</cfloop>
				<cfloop query="check_mother">
				<tr><td colspan="3">CBC Submitted for User #firstname# #lastname# (###userid#).</td></tr>
				<tr bgcolor="#iif(currentrow MOD 2 ,DE("white") ,DE("ffffe6") )#"> 
					<td>&nbsp;</td>
					<td align="center" style="line-height:20px;"><b>#season#</b></td>
					<td align="center" style="line-height:20px;"><cfif date_sent EQ ''>processing<cfelse>#DateFormat(date_sent, 'mm/dd/yyyy')#</cfif></td>
					<td align="center" style="line-height:20px;"><cfif date_received EQ ''>processing<cfelse>#DateFormat(date_received, 'mm/dd/yyyy')#</cfif></td>		
					<td align="center" style="line-height:20px;"><cfif requestid EQ ''>processing<cfelse>
					
						<!----Piece together file name---->
						<cfif client.usertype lte 4><a href="?curdoc=cbc/view_host_cbc&file=batch_#batchid#_host_mother_#hostid#_rec.xml"></cfif>#requestid#</a>
				
					
					</cfif></td>
				</tr>
				</cfloop>
				<tr><td colspan="6">Host Father:</td></tr>
				<cfloop query="get_cbc_father">
				<tr bgcolor="#iif(currentrow MOD 2 ,DE("white") ,DE("ffffe6") )#"> 
					<td>#family_info.fatherfirstname# #family_info.fatherlastname#</td>
					<td align="center" style="line-height:20px;"><b>#season#</b></td>
					<td align="center" style="line-height:20px;"><cfif date_sent EQ ''>processing<cfelse>#DateFormat(date_sent, 'mm/dd/yyyy')#</cfif></td>
					<td align="center" style="line-height:20px;"><cfif date_received EQ ''>processing<cfelse>#DateFormat(date_received, 'mm/dd/yyyy')#</cfif></td>		
					<td align="center" style="line-height:20px;"><cfif requestid EQ ''>processing<cfelseif flagcbc EQ 1 AND client.usertype LTE 4>On Hold Contact Compliance<cfelse>		
					
						<cfif client.usertype lte 4><a href="?curdoc=cbc/view_host_cbc&file=batch_#batchid#_host_father_#hostid#_rec.xml">#requestid#</a></cfif></cfif></td>
				</tr>
				</cfloop>
				<cfloop query="check_father">
				<tr><td colspan="6">CBC Submitted for User #firstname# #lastname# (###userid#).</td></tr>
				<tr bgcolor="#iif(currentrow MOD 2 ,DE("white") ,DE("ffffe6") )#"> 
					<td>&nbsp;</td>
					<td align="center" style="line-height:20px;"><b>#season#</b></td>
					<td align="center" style="line-height:20px;"><cfif date_sent EQ ''>processing<cfelse>#DateFormat(date_sent, 'mm/dd/yyyy')#</cfif></td>
					<td align="center" style="line-height:20px;"><cfif date_received EQ ''>processing<cfelse>#DateFormat(date_received, 'mm/dd/yyyy')#</cfif></td>							
					<td align="center" style="line-height:20px;"><cfif requestid EQ ''>processing<cfelse>
					</cfif></td>
				</tr>
				</cfloop>				
			</cfif>
			<tr bgcolor="e2efc7"><th colspan="6">Other Family Members</th></tr>
			<cfif get_cbc_members.recordcount EQ '0'>
			<tr><td align="center" colspan="6">No CBC has been submitted.</td></tr>
			<cfelse>
			<cfloop query="get_cbc_members">
			<tr bgcolor="#iif(currentrow MOD 2 ,DE("white") ,DE("ffffe6") )#"> 
				<td align="center" style="line-height:20px;"><b>#name#</b></td>
				<td align="center" style="line-height:20px;"><b>#season#</b></td>
				<td align="center" style="line-height:20px;"><cfif date_sent EQ ''>processing<cfelse>#DateFormat(date_sent, 'mm/dd/yyyy')#</cfif></td>
				<td align="center" style="line-height:20px;"><cfif date_received EQ ''>processing<cfelse>#DateFormat(date_received, 'mm/dd/yyyy')#</cfif></td>		
				<td align="center" style="line-height:20px;"><cfif requestid EQ ''>processing<cfelse>
				
				
					<cfif client.usertype lte 4><a href="?curdoc=cbc/view_host_cbc&file=batch_#batchid#_hostm_#name#_#hostid#_rec.xml">#requestid#</a></cfif>
				
				
					</td>
				</cfif>
			</tr>
			</cfloop>
			</cfif>
		</table>
		<!----footer of table---->
		<table width=100% cellpadding=0 cellspacing=0 border=0>
			<tr valign=bottom >
				<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
				<td width=100% background="pics/header_background_footer.gif"></td>
				<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
			</tr>
		</table>
	</td>
	<td width="2%" valign="top"></td>
	<td width="49%" valign="top"></td>
</tr>
</table>

<!--- <center>
<cfif client.usertype LTE '4'><a href="?curdoc=querys/delete_host&hostid=#hostid#" onClick="return areYouSure(this);"><img src="pics/delete.gif" border="0"></img></a>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </cfif>
<a href="?curdoc=forms/edit_host_fam_pis&hostid=#hostid#"><img src="pics/edit.gif" border="0"></img></a></center> --->
</cfoutput>