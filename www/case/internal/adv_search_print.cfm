<link rel="stylesheet" href="reports/reports.css" type="text/css">

<cfif NOT isDefined("url.student_order")>
	<cfset url.student_order = "familylastname">
</cfif>

<!-----Company Information----->
<cfinclude template="querys/get_company_short.cfm">

<cfquery name="students" datasource="caseusa">
	SELECT
		smg_students.studentid, smg_students.hostid, smg_students.familylastname,
		smg_students.firstname, smg_students.sex, smg_students.regionguar, smg_students.state_guarantee, 
		smg_students.regionassigned, smg_students.programid,
		smg_regions.regionfacilitator, smg_regions.regionname,
		smg_countrylist.countryname,
		smg_g.regionname as r_guarantee,
		smg_companies.companyshort,
		smg_states.state	
	FROM smg_students 
	INNER JOIN smg_companies on smg_students.companyid = smg_companies.companyid
	INNER JOIN smg_countrylist ON smg_students.countryresident = smg_countrylist.countryid
	<cfif form.preayp is 'english'>INNER JOIN smg_aypcamps preayp ON aypenglish = preayp.campid</cfif>
	<cfif form.preayp is 'orient'>INNER JOIN smg_aypcamps preayp ON ayporientation = preayp.campid</cfif>
	LEFT JOIN smg_regions on smg_students.regionassigned = smg_regions.regionid
	LEFT JOIN smg_regions smg_g on smg_students.regionalguarantee = smg_g.regionid
	LEFT JOIN smg_states ON state_guarantee = smg_states.id
	WHERE 1 = 1
	<!--- ACTIVE --->
	<cfif form.active is '1'>
		AND smg_students.active = 1
	<cfelseif form.active EQ '0'>	
		 AND smg_students.active = 0
	</cfif>
	<!--- PLACEMENT STATUS --->
	<cfif form.status EQ 'placed'>
		AND (hostid != 0)
	<cfelseif form.status EQ 'unplaced'>
		AND (hostid = 0)
	</cfif>
	<!--- DIRECT PLACEMENT --->
	<cfif form.direct EQ 'yes'>
		AND direct_placement = '1'
	<cfelseif form.direct EQ 'no'>
		AND direct_placement = '0'
	</cfif>
	<!--- AGE --->
	<cfif form.age NEQ '0'>
		<cfset nextage = #form.age# + 1>
		AND DATEDIFF(now(),smg_students.dob)/365 >= '#form.age#' AND DATEDIFF(now(),smg_students.dob)/365 < '#nextage#'
	</cfif>
	<!--- GENDER --->
	<cfif form.gender NEQ '0'>
		AND sex = '#form.gender#'
	</cfif>
	<!--- GRADES --->
	<cfif form.grades NEQ '0'>
		AND grades = '#form.grades#'
	</cfif>		
	<!--- GRADUATE STUDENTS --->
	<cfif form.graduate EQ '1'>
		AND (grades = '12' OR grades = '11' AND (countryresident = '49' or countryresident = '237'))
	</cfif>	
  	<!--- RELIGION --->
 	<cfif form.religion NEQ '0'>
		AND religiousaffiliation = '#form.religion#'	
	</cfif>	
	<!--- SPORTS --->
	<cfif form.sports NEQ '0'>
		AND comp_sports = '#form.sports#'
	</cfif> 
	<!--- NARRATIVE --->
	<cfif form.interests_other NEQ ''>
		AND interests_other LIKE '%#form.interests_other#%'
	</cfif>	
	<!--- COUNTRY --->
	<cfif form.countryid NEQ '0'>
		AND countryresident = '#form.countryid#'
	</cfif>
	<!--- INTERNATIONAL REP. --->	
	 <cfif form.intrep NEQ '0'>
		AND intrep = '#form.intrep#'
	</cfif>
	<!--- REGION --->
	<cfif form.regionid NEQ '0'>
		AND regionassigned = '#form.regionid#'
	</cfif>
	<!--- STATE --->
	<cfif form.stateid NEQ '0'>
		AND state_guarantee = '#form.stateid#'
	</cfif>		
 	<!--- STUDENT ID --->
	<cfif form.studentid is ''><cfelse>
		AND studentid = '#form.studentid#'
	</cfif>
	<!----Students under a regional manager---->
	<cfif client.usertype is 5>
		<Cfquery name="regionname" datasource="caseusa">
			SELECT regionid
			FROM user_access_rights
			WHERE userid = #client.userid#
		</Cfquery>
		AND( regionassigned like
		<Cfloop query="regionname" >
		 #regionid# <cfif regionname.recordcount eq regionname.currentrow><cfelse>or</cfif>
		</Cfloop>)
	</cfif>
	<!--- PROGRAM --->
	<cfif form.programid NEQ '0'>
		AND (
	  <cfloop list=#form.programid# index='prog'>
	 	    programid = #prog# 
		   <cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
	   </cfloop> )
	</cfif>
	<!----students under a regional ADVISOR ---->
	<cfif client.usertype EQ '6'>
		<cfquery name="get_users_under_adv" datasource="caseusa">
			SELECT DISTINCT userid	FROM user_access_rights
			WHERE advisorid = '#client.userid#' AND companyid = '#client.companyid#'
				  OR userid = '#client.userid#'
		</cfquery>
		<cfset ad_users = ValueList(get_users_under_adv.userid, ',')>
			AND ( arearepid = 
				<cfloop list="#ad_users#" index='i' delimiters = ",">
				'#i#' <cfif #ListLast(ad_users)# is #i#><cfelse> or arearepid = </cfif> </Cfloop> 
			OR  placerepid = 
				<cfloop list="#ad_users#" index='i' delimiters = ",">
				'#i#' <cfif #ListLast(ad_users)# is #i#><cfelse> or placerepid = </cfif> </Cfloop>
			OR arearepid = '#client.userid#' OR placerepid = '#client.userid#')
	</cfif>
	<!----students under a area_Rep---->
	<cfif client.usertype is 7>
		<cfif #form.status# is 'placed'>
			and arearepid = #client.userid#
		<cfelse>
				
		<Cfquery name="regionname" datasource="caseusa">
			SELECT regionid
			FROM user_access_rights
			WHERE userid = #client.userid#
		</Cfquery>
		AND( regionassigned like
		<Cfloop query="regionname" >
		 #regionid# <cfif regionname.recordcount eq regionname.currentrow><cfelse>or</cfif>
		</Cfloop>)
	
		</cfif>
	</cfif>
	<!----students under an int_Rep---->
	<cfif client.usertype is 8>
		<Cfquery name="regionname" datasource="caseusa">
			SELECT regionid
			FROM user_access_rights
			WHERE userid = #client.userid#
		</Cfquery>
		AND( regionassigned like
		<Cfloop query="regionname" >
		 #regionid# <cfif regionname.recordcount eq regionname.currentrow><cfelse>or</cfif>
		</Cfloop>)
		</cfif>
	<!--- show all students under the SMG Comnpany --->
	<cfif #client.companyid# is 5><cfelse>
		and smg_students.companyid = #client.companyid# 
	</cfif>
 	order by #url.student_order#
</cfquery>

<!--- rows colors for the interest search --->
<cfset color = 1>
<cfset stucount = 0>

<table width='650' cellpadding=6 cellspacing="0" align="center">
<tr><td>
<span class="application_section_header"><cfoutput>#companyshort.companyshort# - Advanced Search - Students</cfoutput></span>
</td></tr>
</table>
<br>

<table width='650' cellpadding=6 cellspacing="0" align="center">
	<tr>
		<td width=30><b>ID</b></td>
		<td width=100><b>Last Name</b></td>
		<td width=90><b>First Name</b></td>
		<td width=40><b>Sex</b></td>
		<td width=80><b>Country</b></td>
		<td width=80><b>Region</b></td>
		<td width=120><b>Program</b></td>
		<cfif form.status is "unplaced"><cfelse>
			<Td width="80"><b>Family</b></td>
		</cfif>
		<cfif client.companyid is 5> <!--- show company name if you are logged in the SMG --->
		<td width=30><b>Company</b></td>
		</cfif>
	</tr>

<cfoutput query="students">
	<!--- GET STUDENT PROGRAM NAME --->
	<Cfquery name="program" datasource="caseusa">
		select programname
		from smg_programs
		where programid = #programid#
	</Cfquery> 
	
	<!--- GET HOST FAMILY NAME --->
	<Cfif #form.status# is 'unplaced'>
	<cfelse>
		<cfquery name="family" datasource="caseusa">
			SELECT familylastname
			FROM smg_hosts
			WHERE hostid = #hostid#
		</cfquery>
	</cfif>
	
	<!--- MATCH INTEREST --->
	<cfif form.interests EQ '0'>
		<tr bgcolor="#iif(students.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
				<td>#Studentid#</td>
				<td><cfif #len(familylastname)# gt 15>#Left(familylastname, 12)#...<Cfelse>#familylastname#</cfif></td>
				<td>#firstname#</td>
				<td>#sex#</td>
				<td><cfif len(#countryname#) lt 10>#countryname#<cfelse>#Left(countryname,13)#..</cfif></td>
				<td>#regionname# 
					<cfif students.regionguar is 'yes'>
					<font color="CC0000">
						<cfif r_guarantee is '' and state_guarantee EQ 0>* Missing</cfif>
						<cfif r_guarantee is not ''>* #r_guarantee#
							<cfelseif students.state_guarantee NEQ 0>* #students.state#</cfif>
					</cfif>	
				</td>
				<td>#program.programname#</td>
				<cfif #form.status# is "unplaced"><cfelse>
					<td>#family.familylastname#</td>
				</cfif>
				<cfif client.companyid is 5> <!--- show company name if you are logged in the SMG --->
					<td>#companyshort#</td>
				</cfif>
		</tr> 
	<cfelse> <!--- Get interests from each student --->
		<cfquery name="get_student_interests" datasource="caseusa">
			select interests, studentid
			from smg_students
			WHERE studentid = #studentid#	
		</cfquery> 
		<!--- Create a list with the interests and compare it with the one user selected --->
		<cfset check_list = ListFind(get_student_interests.interests, form.interests , ",")> 
			<cfif check_list is 0><cfelse> 
				<tr bgcolor="#iif(color MOD 2 ,DE("ededed") ,DE("white") )#">
					<td>#Studentid#</td>
					<td><cfif #len(familylastname)# gt 15>#Left(familylastname, 12)#...<Cfelse>#familylastname#</cfif></td>
					<td>#firstname#</td>
					<td>#sex#</td>
					<td><cfif len(#countryname#) lt 10>#countryname#<cfelse>#Left(countryname,13)#..</cfif></td>
					<td> #regionname#
						<cfif students.regionguar is 'yes'>
						<font color="CC0000">
							<cfif r_guarantee is '' and state_guarantee EQ 0>* Missing</cfif>
							<cfif r_guarantee is not ''>* #r_guarantee#
								<cfelseif students.state_guarantee NEQ 0>* #students.state#</cfif>
						</cfif>	
					</td>
					<td> #program.programname#</td>
					<cfif #form.status# is "unplaced"><cfelse>
						<td>#family.familylastname#</td>
					</cfif>
					<cfif client.companyid is 5> <!--- show company name if you are logged in the SMG --->
						<td>#companyshort#</td>
					</cfif>					
				</tr>
				<cfset color = color + 1>
				<cfset stucount = stucount + 1>
			</cfif>
	</cfif>
</cfoutput>
</table>
<br>
<table width='650' cellpadding=6 cellspacing="0" align="center">
<tr><td><font size=-1>
<cfif students.recordcount is 0>
	&nbsp; No student was found matching your criteria.<br>&nbsp; &nbsp; &nbsp; Go back and try another search.</center><br>
	<!--- 	<cfabort> --->
<cfelse>
	<cfif form.interests is 0>
		<cfoutput>&nbsp; #students.recordcount# students was found matching your criteria</cfoutput></center> <br>
	<cfelse>
		<cfoutput>&nbsp; #stucount# students was found matching your criteria</cfoutput></center> <br>
	</cfif>
</cfif>
</font></td></tr>
</table>

<cfoutput>
<table width='650' cellpadding=6 cellspacing="0" align="center" class="box">
<tr><td align="left" colspan="2"><font color="CC0000">* Regional / State Guarantee</font></td><td align="right" colspan="2">CTRL-F to search</td></tr>
<tr><td colspan="4"><b><i>Criteria used in this search :</i></b></td></tr>
<tr>
	<td width="25%"><i>Active : &nbsp;</i><cfif form.active is '1'>Yes</cfif><cfif form.active EQ '0'>No</cfif><cfif form.active is '2'>n/a</cfif></td>
	<td width="25%"><i>Placement Status :  &nbsp;</i><cfif form.status EQ '0'>n/a</cfif><cfif form.status is 'placed'>Placed</cfif><cfif form.status is 'unplaced'>Unplaced</cfif></td>
	<td width="25%"><i>Age :  &nbsp;</i><cfif form.age EQ '0'>n/a<cfelse>#form.age#</cfif></td>
	<td width="25%"><i>Gender :  &nbsp;</i><cfif form.gender EQ '0'>n/a</cfif><cfif form.gender is 'male'>Male</cfif><cfif form.gender is 'female'>Female</cfif></td>
</tr>
<tr>
	<td width="25%"><i>Religion :  &nbsp;</i><cfif form.religion EQ '0'>n/a<cfelse>
						<cfquery name="get_religious" datasource="caseusa">
						SELECT * FROM smg_religions WHERE religionid = #form.religion#
						</cfquery>#get_religious.religionname#</cfif></td>
	<td width="25%"><i>Interests : &nbsp;</i><cfif form.interests EQ '0'>n/a<cfelse>
						<cfquery name="get_interests" datasource="caseusa">
						SELECT * FROM smg_interests WHERE interestid = #form.interests#
						</cfquery>#get_interests.interest#</cfif></td>
	<td width="25%"><i>Comp. Sports : &nbsp;</i><cfif form.sports EQ '0'>n/a<cfelse><cfif form.sports is 'yes'>Yes</cfif><cfif form.sports is "no">no</cfif></cfif></td>
	<td width="25%"><i>Narrative : &nbsp;</i><cfif form.interests_other EQ ''>n/a<cfelse>#form.interests_other#</cfif></td>	
</tr>
<tr>
	<td width="25%"><i>Country : &nbsp;</i><cfif form.countryid EQ '0'>n/a<cfelse>#students.countryname#</cfif></td>
	<td width="25%"><i>Region : &nbsp;</i><cfif form.regionid EQ '0'>n/a<cfelse>#students.regionname#</cfif></td>
	<td width="25%"><i>State Guarantee : &nbsp;</i><cfif form.stateid EQ '0'>n/a<cfelse>#students.state#</cfif></td>
	<td width="25%"><i>Program(s) : &nbsp;</i><cfif form.programid EQ '0'>n/a<cfelse>
						<Cfquery name="get_program" datasource="caseusa">
						SELECT programname FROM smg_programs WHERE	
						<cfloop list=#form.programid# index='prog'>programid = #prog# 
		   					<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
	  					 </cfloop> 
						</Cfquery>
						<cfloop query="get_program">#get_program.programname#<br></cfloop></cfif></td>
</tr>
<tr>
	<td width="25%"><i>Student ID : &nbsp;</i><cfif form.studentid is ''>n/a<cfelse>#form.studentid#</cfif></td>
	<td width="25%"><i>Pre-AYP : &nbsp;</i>#form.preayp#</td>
	<td width="25%"><i>Intl. Rep : &nbsp;</i><cfif form.intrep EQ '0'>n/a<cfelse>
						<cfquery name="get_intrep" datasource="caseusa">
						SELECT businessname FROM smg_users WHERE userid = #form.intrep#
						</cfquery>#get_intrep.businessname#</cfif></td>
	<td width="25%"><i>Direct Placement : &nbsp;</i> #form.direct#</td>
</tr>
</table>
</cfoutput>