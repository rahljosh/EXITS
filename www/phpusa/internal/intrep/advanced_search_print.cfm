<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Advanced Search Print</title>
</head>

<body>

<link rel="stylesheet" href="reports/reports.css" type="text/css">

<cfif isDefined("url.student_order")>
<cfelse>
	<cfset url.student_order = "familylastname">
</cfif>

<cfquery name="students" datasource="MySQL">
	SELECT s.studentid, s.hostid, s.familylastname, s.firstname, s.sex, s.regionguar, s.state_guarantee,
		s.regionassigned, s.programid, s.uniqueid,
		smg_regions.regionfacilitator, smg_regions.regionname,
		smg_countrylist.countryname,
		smg_g.regionname as r_guarantee,
		smg_companies.companyshort,
		smg_states.state	
	FROM smg_students s
	INNER JOIN smg_companies on s.companyid = smg_companies.companyid
	INNER JOIN smg_countrylist ON s.countryresident = smg_countrylist.countryid
	<cfif form.preayp is 'english'>INNER JOIN smg_aypcamps preayp ON aypenglish = preayp.campid</cfif>
	<cfif form.preayp is 'orient'>INNER JOIN smg_aypcamps preayp ON ayporientation = preayp.campid</cfif>
	LEFT JOIN smg_regions on s.regionassigned = smg_regions.regionid
	LEFT JOIN smg_regions smg_g on s.regionalguarantee = smg_g.regionid
	LEFT JOIN smg_states ON state_guarantee = smg_states.id
	WHERE intrep = '#client.userid#'
	<!--- ACTIVE --->
	<cfif form.active is '1'>
		AND s.active = 1
	<cfelseif form.active EQ '0'>	
		 AND s.active = 0
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
	<!--- STATE --->
	<cfif form.stateid NEQ '0'>
		AND state_guarantee = '#form.stateid#'
	</cfif>		
 	<!--- STUDENT ID --->
	<cfif form.studentid NEQ ''>
		AND studentid = '#form.studentid#'
	</cfif>
	<!--- PROGRAM --->
	<cfif form.programid NEQ '0'>
		AND (
	  <cfloop list="#form.programid#" index='prog'>
	 	    programid = #prog# 
		   <cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
	   </cfloop> )
	</cfif>
 	order by '#url.student_order#'
</cfquery>

<!--- rows colors for the interest search --->
<cfset color = 1>
<cfset stucount = 0>

<table width='650' cellpadding=6 cellspacing="0" align="center">
	<tr><td><span class="application_section_header">Advanced Search - Students</span></td></tr>
</table>
<br>

<table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
	<tr>
		<td width="5%">ID</td>
		<td width="15%">Last Name</td>
		<td width="15%">First Name</td>
		<td width="10%">Sex</td>
		<td width="10%">Country</td>
		<td width="13%">Region</td>
		<td width="10%">Program</td>
		<cfif form.status NEQ "unplaced">
			<Td width="10%">Family</td>
		</cfif>
		<td width="13%">Company</td>
		<td width="2%">&nbsp;</td></td>
	</tr>

<cfoutput query="students">
	<!--- GET STUDENT PROGRAM NAME --->
	<Cfquery name="program" datasource="MySQL">
		select programname
		from smg_programs
		where programid = #programid#
	</Cfquery> 
	
	<!--- GET HOST FAMILY NAME --->
	<Cfif #form.status# NEQ 'unplaced'>
		<cfquery name="family" datasource="MySQL">
			SELECT familylastname
			FROM smg_hosts
			WHERE hostid = #hostid#
		</cfquery>
	</cfif>
	
	<!--- MATCH INTEREST --->
	<cfif form.interests EQ '0'>
		<tr bgcolor="#iif(students.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
				<td>#Studentid#</td>
				<td>#familylastname#</td>
				<td>#firstname#</td>
				<td>#sex#</td>
				<td>#Left(countryname,13)#</td>
				<td>#regionname# 
					<cfif students.regionguar is 'yes'>
					<font color="CC0000">
						<cfif r_guarantee is '' and state_guarantee EQ 0>* Missing</cfif>
						<cfif r_guarantee is not ''>* #r_guarantee#
							<cfelseif students.state_guarantee NEQ 0>* #students.state#</cfif>
					</cfif>	
				</td>
				<td>#program.programname#</td>
				<cfif form.status NEQ "unplaced">
					<td>#family.familylastname#</td>
				</cfif>
				<td>#companyshort#</td>
		</tr> 
	<cfelse> <!--- Get interests from each student --->
		<cfquery name="get_student_interests" datasource="MySQL">
			select interests, studentid
			from smg_students
			WHERE studentid = #studentid#	
		</cfquery> 
		<!--- Create a list with the interests and compare it with the one user selected --->
		<cfset check_list = ListFind(get_student_interests.interests, form.interests , ",")> 
			<cfif check_list is 0><cfelse> 
				<tr bgcolor="#iif(color MOD 2 ,DE("ededed") ,DE("white") )#">
					<td>#Studentid#</td>
					<td>#familylastname#</td>
					<td>#firstname#</td>
					<td>#sex#</td>
					<td>#Left(countryname,13)#</td>
					<td>#regionname#
						<cfif students.regionguar is 'yes'>
						<font color="CC0000">
							<cfif r_guarantee is '' and state_guarantee EQ 0>* Missing</cfif>
							<cfif r_guarantee is not ''>* #r_guarantee#
								<cfelseif students.state_guarantee NEQ 0>* #students.state#</cfif>
						</cfif>	
					</td>
					<td>#program.programname#</td>
					<cfif #form.status# NEQ "unplaced">
						<td>#family.familylastname#</td>
					</cfif>
					<td>#companyshort#</td>
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
						<cfquery name="get_religious" datasource="MySQL">
						SELECT * FROM smg_religions WHERE religionid = #form.religion#
						</cfquery>#get_religious.religionname#</cfif></td>
	<td width="25%"><i>Interests : &nbsp;</i><cfif form.interests EQ '0'>n/a<cfelse>
						<cfquery name="get_interests" datasource="MySQL">
						SELECT * FROM smg_interests WHERE interestid = #form.interests#
						</cfquery>#get_interests.interest#</cfif></td>
	<td width="25%"><i>Comp. Sports : &nbsp;</i><cfif form.sports EQ '0'>n/a<cfelse><cfif form.sports is 'yes'>Yes</cfif><cfif form.sports is "no">no</cfif></cfif></td>
	<td width="25%"><i>Narrative : &nbsp;</i><cfif form.interests_other EQ ''>n/a<cfelse>#form.interests_other#</cfif></td>	
</tr>
<tr>
	<td width="25%"><i>State Guarantee : &nbsp;</i><cfif form.stateid EQ '0'>n/a<cfelse>#students.state#</cfif></td>
	<td width="25%"><i>Program(s) : &nbsp;</i><cfif form.programid EQ '0'>n/a<cfelse>
						<Cfquery name="get_program" datasource="MySQL">
						SELECT programname FROM smg_programs WHERE	
						<cfloop list=#form.programid# index='prog'>programid = #prog# 
		   					<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
	  					 </cfloop> 
						</Cfquery>
						<cfloop query="get_program">#get_program.programname#<br></cfloop></cfif></td>
	<td width="25%"><i>Student ID : &nbsp;</i><cfif form.studentid is ''>n/a<cfelse>#form.studentid#</cfif></td>
	<td width="25%"><i>Pre-AYP : &nbsp;</i>#form.preayp#</td>
</tr>
<tr>
	<td width="25%"><i>Direct Placement : &nbsp;</i> #form.direct#</td>
</tr>
</table>
</cfoutput>

</body>
</html>
