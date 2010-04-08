<cfif not isDefined('form.preayp')>
<cflocation url="?curdoc=advanced_search">
<cfabort>
</cfif>

<cfif NOT isDefined("url.student_order")>
	<cfset url.student_order = "familylastname">
</cfif>

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
	<cfif client.usertype EQ 5>
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
	<cfif client.usertype EQ 5>
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
	<!----students under a area_Rep---->
	<cfif client.usertype EQ 7>
		<cfif form.status EQ 'placed'>
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
	<cfif client.usertype EQ 8>
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
	<cfif #client.companyid# NEQ 5>
		and smg_students.companyid = #client.companyid# 
	</cfif>
 	order by #url.student_order#
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
		<td width=30>ID</td>
		<td width=90>Last Name</td>
		<td width=80>First Name</td>
		<td width=40>Sex</td>
		<td width=80>Country</td>
		<td width=55>Region</td>
		<td width=60>Program</td>
		<cfif form.status is "unplaced"><cfelse>
			<Td width="60">Family</td>
		</cfif>
		<cfif client.companyid is 5> <!--- show company name if you are logged in the SMG --->
		<td width=30>Company</td>
		</cfif>
	</tr>
</table>

<div class="scroll">
<table width=100%>
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

<!--- APPLICATION LINK FOR OFFICE USERS --->
<cfif client.usertype lt 5>
	<cfset urllink ="index.cfm?curdoc=student_info&studentid=#studentid#"> 
<cfelse>
	<cfset urllink="student_profile.cfm?studentid=#studentid#"> 
</cfif>

<!--- MATCH INTEREST --->
<cfif form.interests is '0'>
	<tr bgcolor="#iif(students.currentrow MOD 2 ,DE("ffffe6") ,DE("white") )#">
			<td width=10><a href='#urllink#'>#Studentid#</a></td>
			<td width=90><a href='#urllink#'><cfif #len(familylastname)# gt 15>#Left(familylastname, 12)#...<Cfelse>#familylastname#</cfif> </a></td>
			<td width=80><a href='#urllink#'> #firstname# </a></td>
			<td width=50> #sex#</td>
			<td width=80><cfif len(#countryname#) lt 10>#countryname#<cfelse>#Left(countryname,13)#..</cfif></td>
			<td width=55> #regionname# 
					<cfif students.regionguar is 'yes'>
					<font color="CC0000">
						<cfif r_guarantee is '' and state_guarantee EQ 0>* Missing</cfif>
						<cfif r_guarantee is not ''>* #r_guarantee#
							<cfelseif students.state_guarantee NEQ 0>* #students.state#</cfif>
					</cfif>	
			</td>
			<td width=60> #program.programname#</td>
			<cfif #form.status# is "unplaced"><cfelse>
				<td width="60">#family.familylastname#</td>
			</cfif>
			<cfif client.companyid is 5> <!--- show company name if you are logged in the SMG --->
				<td width=30>#companyshort#</td>
			</cfif>
	</tr> 
<cfelse>
 	<!--- Get interests from each student --->
	<cfquery name="get_student_interests" datasource="caseusa">
		select interests, studentid
		from smg_students
		WHERE studentid = #studentid#	
	</cfquery> 
	<!--- Create a list with the interests and compare it with the one user selected --->
	<cfset check_list = ListFind(get_student_interests.interests, form.interests , ",")> 
		<cfif check_list is 0><cfelse> 
			<tr bgcolor="#iif(color MOD 2 ,DE("ffffe6") ,DE("white") )#">
				<td width=15><a href='#urllink#'>#Studentid#</a></td>
				<td width=90><a href='#urllink#'><cfif #len(familylastname)# gt 15>#Left(familylastname, 12)#...<Cfelse>#familylastname#</cfif> </a></td>
				<td width=80><a href='#urllink#'> #firstname# </a></td>
				<td width=40> #sex#</td>
				<td width=80><cfif len(#countryname#) lt 10>#countryname#<cfelse>#Left(countryname,13)#..</cfif></td>
				<td width=55> #regionname# 
					<cfif students.regionguar is 'yes'>
					<font color="CC0000">
						<cfif r_guarantee is '' and state_guarantee EQ 0>* Missing</cfif>
						<cfif r_guarantee is not ''>* #r_guarantee#
							<cfelseif students.state_guarantee NEQ 0>* #students.state#</cfif>
					</cfif></td>
				<td width=60> #program.programname#</td>
				<cfif #form.status# is "unplaced"><cfelse>
					<td width="60">#family.familylastname#</td>
				</cfif>
				<cfif client.companyid is 5> <!--- show company name if you are logged in the SMG --->
					<td width=30>#companyshort#</td>
				</cfif>					
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
<tr><td align="left"><font color="CC0000">&nbsp; * Regional / State Guarantee</font></td>
	<td align="right"><font color="CC0000">CTRL-F to search &nbsp;</font></td>
</tr>

<cfoutput>
<form action="adv_search_print.cfm" method="POST" target="_blank"> <!--- PRINT VIEW --->
<input type="hidden" name="active" value="#form.active#"> <!--- ACTIVE STATUS --->
<input type="hidden" name="status" value="#form.status#"> <!--- PLACEMENT STATUS --->
<input type="hidden" name="preayp" value="#form.preayp#"> <!--- PRE AYP CAMP --->
<input type="hidden" name="direct" value="#form.direct#"> <!--- DIRECT PLACEMENT --->
<input type="hidden" name="age" value="#form.age#"> <!--- AGE --->
<input type="hidden" name="gender" value="#form.gender#"> <!--- GENDER --->
<input type="hidden" name="grades" value="#form.grades#"> <!--- GRADUATE --->
<input type="hidden" name="graduate" value="#form.graduate#"> <!--- GRADUATE --->
<input type="hidden" name="religion" value="#form.religion#"> <!--- RELIGION --->
<input type="hidden" name="interests" value="#form.interests#"> <!--- INTERESTS --->
<input type="hidden" name="sports" value="#form.sports#"> <!--- SPORTS --->
<input type="hidden" name="interests_other" value="#form.interests_other#"> <!--- SPORTS --->
<input type="hidden" name="countryid" value="#form.countryid#"> <!--- COUNTRY --->
<input type="hidden" name="intrep" value="#form.intrep#"> <!--- INTERNATIONAL REP. --->	
<input type="hidden" name="regionid" value="#form.regionid#"> <!--- REGION --->
<input type="hidden" name="stateid" value="#form.stateid#"> <!--- REGION --->
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