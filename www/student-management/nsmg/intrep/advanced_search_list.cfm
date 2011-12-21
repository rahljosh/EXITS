<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Advanced Search</title>
</head>

<body>

<cfif NOT isDefined("url.student_order")>
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
		AND DATEDIFF(now(),s.dob)/365 >= '#form.age#' AND DATEDIFF(now(),s.dob)/365 < '#nextage#'
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

<style>
div.scroll {
	height: 325px;
	width: 100%;
	overflow: auto;
	border-left: 2px solid #c6c6c6;
	border-right: 2px solid #c6c6c6;
	background: #Ffffe6;
}
-->
</style>

<!--- rows colors for the interest search --->
<cfset color = 1>
<cfset stucount = 0>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
		<td background="pics/header_background.gif"><h2>Advanced Search Results</h2></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

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
</table>

<div class="scroll">
<table width=100%>
<cfoutput query="students">
<!--- GET STUDENT PROGRAM NAME --->
<Cfquery name="program" datasource="MySQL">
	select programname
	from smg_programs
	where programid = #programid#
</Cfquery> 

<!--- GET HOST FAMILY NAME --->
<Cfif #form.status# is 'unplaced'>
<cfelse>
	<cfquery name="family" datasource="MySQL">
		SELECT familylastname
		FROM smg_hosts
		WHERE hostid = #hostid#
	</cfquery>
</cfif>

<cfset urllink ="index.cfm?curdoc=intrep/int_student_info&unqid=#uniqueid#"> 

<!--- MATCH INTEREST --->
<cfif form.interests EQ '0'>
	<tr bgcolor="#iif(students.currentrow MOD 2 ,DE("ffffe6") ,DE("white") )#">
			<td width="5%"><a href='#urllink#'>#Studentid#</a></td>
			<td width="15%"><a href='#urllink#'>#familylastname#</a></td>
			<td width="15%"><a href='#urllink#'>#firstname# </a></td>
			<td width="10%">#sex#</td>
			<td width="10%">#countryname#</td>
			<td width="13%">#regionname# 
					<cfif students.regionguar is 'yes'>
					<font color="CC0000">
						<cfif r_guarantee is '' and state_guarantee EQ 0>* Missing</cfif>
						<cfif r_guarantee is not ''>* #r_guarantee#
							<cfelseif students.state_guarantee NEQ 0>* #students.state#</cfif>
					</cfif>	
			</td>
			<td width="10%"> #program.programname#</td>
			<cfif #form.status# NEQ "unplaced">
				<td width="10%">#family.familylastname#</td>
			</cfif>
			<td width="12%">#companyshort#</td>
	</tr> 
<cfelse>
 	<!--- Get interests from each student --->
	<cfquery name="get_student_interests" datasource="MySQL">
		select interests, studentid
		from smg_students
		WHERE studentid = #studentid#	
	</cfquery> 
	<!--- Create a list with the interests and compare it with the one user selected --->
	<cfset check_list = ListFind(get_student_interests.interests, form.interests , ",")> 
		<cfif check_list NEQ '0'>
			<tr bgcolor="#iif(color MOD 2 ,DE("ffffe6") ,DE("white") )#">
				<td width="5%"><a href='#urllink#'>#Studentid#</a></td>
				<td width="15%"><a href='#urllink#'>#familylastname#</a></td>
				<td width="15%"><a href='#urllink#'>#firstname#</a></td>
				<td width="10%">#sex#</td>
				<td width="10%">#Left(countryname,13)#</td>
				<td width="13%">#regionname# 
					<cfif students.regionguar is 'yes'>
					<font color="CC0000">
						<cfif r_guarantee is '' and state_guarantee EQ 0>* Missing</cfif>
						<cfif r_guarantee is not ''>* #r_guarantee#
							<cfelseif students.state_guarantee NEQ 0>* #students.state#</cfif>
					</cfif></td>
				<td width="10%">#program.programname#</td>
				<cfif #form.status# NEQ "unplaced">
					<td width="10%">#family.familylastname#</td>
				</cfif>
				<td width="12%">#companyshort#</td>
			</tr>
			<cfset color = color + 1>
			<cfset stucount = stucount + 1>
		</cfif>
</cfif>
</cfoutput>
</table>
</div>

<table width=100% bgcolor="#ffffe6" class="section">
<tr><td align="left" colspan="2"><font size=-1>
	<cfif students.recordcount is 0>
		&nbsp; No student was found matching your criteria.<br>&nbsp; &nbsp; Go back and try to search again.
	<cfelse>
		<cfif form.interests is 0>
			<cfoutput>&nbsp; #students.recordcount# student<cfif students.recordcount gt 1>s</cfif>  <cfif students.recordcount gt 1>were<cfelse>was</cfif> found matching your criteria</cfoutput>
		<cfelse>
			<cfoutput>&nbsp; #stucount# students were found matching your criteria</cfoutput>
		</cfif>
	</cfif></font></td>
</tr>
<tr><td align="left"><font color="CC0000">&nbsp; * Regional / State Preference</font></td>
	<td align="right"><font color="CC0000">CTRL-F to search &nbsp;</font></td>
</tr>

<cfoutput>
<form action="intrep/advanced_search_print.cfm" method="POST" target="_blank"> <!--- PRINT VIEW --->
<input type="hidden" name="active" value="#form.active#"> <!--- ACTIVE STATUS --->
<input type="hidden" name="status" value="#form.status#"> <!--- PLACEMENT STATUS --->
<input type="hidden" name="preayp" value="#form.preayp#"> <!--- PRE AYP CAMP --->
<input type="hidden" name="direct" value="#form.direct#"> <!--- DIRECT PLACEMENT --->
<input type="hidden" name="age" value="#form.age#"> <!--- AGE --->
<input type="hidden" name="gender" value="#form.gender#"> <!--- GENDER --->
<input type="hidden" name="graduate" value="#form.graduate#"> <!--- GRADUATE --->
<input type="hidden" name="religion" value="#form.religion#"> <!--- RELIGION --->
<input type="hidden" name="interests" value="#form.interests#"> <!--- INTERESTS --->
<input type="hidden" name="sports" value="#form.sports#"> <!--- SPORTS --->
<input type="hidden" name="interests_other" value="#form.interests_other#"> <!--- SPORTS --->
<input type="hidden" name="stateid" value="#form.stateid#"> <!--- STATE --->
<input type="hidden" name="programid" value="#form.programid#"> <!--- PROGRAM --->
<input type="hidden" name="studentid" value="#form.studentid#"><!--- STUDENT ID --->
<tr><td colspan="2" align="center"><input name="Submit" type="image" src="pics/print_friendly.gif" alt="Print Friendly Format"  border=0></td></tr>
</form>
</cfoutput>
</table>

<!----footer of table---->
<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>

</body>
</html>
