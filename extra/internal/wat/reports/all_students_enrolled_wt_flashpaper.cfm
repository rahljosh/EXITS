<cfdocument format="PDF" orientation="landscape" backgroundvisible="yes" overwrite="no" fontembed="yes">

<style type="text/css">
.style1 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 10px;
	padding:2;
}
.style2 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 8px;
	padding:2;
}
.title1 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 15px;
	color: #000000;
	font-weight: bold;
	padding:5;
}
</style>

<cfquery name="program_info" datasource="mysql">
	SELECT programname
	FROM smg_programs
	WHERE programid = #url.program#
</cfquery> 

<cfif url.intrep NEQ "All">

<cfquery name="get_candidates" datasource="MySql">
 	SELECT extra_candidates.firstname, extra_candidates.lastname, extra_candidates.placedby, extra_candidates.sex, extra_candidates.hostcompanyid, extra_hostcompany.name, extra_candidates.ds2019, extra_candidates.startdate, extra_candidates.enddate
	, extra_candidates.intrep, extra_candidates.wat_placement, extra_candidates.candidateid
	FROM extra_candidates
	LEFT JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = extra_candidates.hostcompanyid
	INNER JOIN smg_programs ON smg_programs.programid = extra_candidates.programid
	INNER JOIN smg_users ON smg_users.userid = extra_candidates.intrep
	WHERE extra_candidates.intrep = #url.intrep#
	AND extra_candidates.status <> 'canceled'
	AND extra_candidates.wat_placement = 'INTO-Placement'
	AND extra_candidates.programid = #url.program#
</cfquery>

<cfquery name="get_candidates_self" datasource="MySql">
	SELECT extra_candidates.firstname, extra_candidates.candidateid, extra_candidates.lastname, extra_candidates.placedby, extra_candidates.sex, extra_candidates.hostcompanyid, extra_hostcompany.name, extra_candidates.ds2019, extra_candidates.wat_vacation_Start, extra_candidates.wat_vacation_end, extra_candidates.intrep, extra_candidates.wat_placement, extra_candidates.startdate, extra_candidates.enddate
	FROM extra_candidates
	LEFT JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = extra_candidates.hostcompanyid
	INNER JOIN smg_programs ON smg_programs.programid = extra_candidates.programid
	INNER JOIN smg_users ON smg_users.userid = extra_candidates.intrep
	WHERE extra_candidates.intrep = #url.intrep#
	AND extra_candidates.status <> 'canceled'
	AND extra_candidates.programid = #url.program#
	AND extra_candidates.wat_placement = 'Self-Placement'
</cfquery>

<cfquery name="get_intrep" datasource="MySql">
 	SELECT userid as intrep, businessname
	FROM smg_users
	WHERE usertype = 8
	AND userid = #url.intrep# 
	ORDER BY businessname		
</cfquery>

<cfset total = #get_candidates_self.recordcount# + #get_candidates.recordcount#>

</cfif>

<cfoutput>

<img src="../../pics/black_pixel.gif" width="100%" height="2">
<div class="title1">All active students enrolled in the program by Int. Rep. and Program</div>
<img src="../../pics/black_pixel.gif" width="100%" height="2">

<img src="../../pics/black_pixel.gif" width="100%" height="2">
<table width=100% cellpadding="3" cellspacing="0"> 
  
  <cfset into = 1 >	
  
  <!---- All Participants ---->
	<cfif url.intrep EQ "All">
	  <tr>
		<td  align="left" class="style1"><b>Student</b></td>
		<td  align="left" class="style1"><b>Sex</b></td>
		<td  align="left" class="style1"><b>Start Date</b></td>
		<td  align="left" class="style1"><b>End Date</b></td>
		<td  align="left" class="style1"><b>Placement Information</b></td>
		<td  align="left" class="style1"><b>DS2019</b></td>
		<td  align="left" class="style1"><b>Option</b></td>	
		<td  align="left" class="style1"><b>Int. Rep.</b></td>	
	  </tr>
	  <tr>
		<td colspan=8><img src="../../pics/black_pixel.gif" width="100%" height="2"></td>
	  </tr>
				
		<cfquery name="get_candidates" datasource="MySql">
		SELECT extra_candidates.firstname, extra_candidates.lastname, extra_candidates.placedby, extra_candidates.sex, extra_candidates.hostcompanyid, extra_hostcompany.name, extra_candidates.ds2019, extra_candidates.startdate, extra_candidates.enddate, extra_candidates.intrep, extra_candidates.wat_placement, extra_candidates.candidateid, smg_users.businessname
		FROM extra_candidates
		LEFT JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = extra_candidates.hostcompanyid
		INNER JOIN smg_programs ON smg_programs.programid = extra_candidates.programid
		INNER JOIN smg_users ON smg_users.userid = extra_candidates.intrep
		WHERE extra_candidates.programid = #url.program#  
		AND extra_candidates.wat_placement = 'INTO-Placement'
		AND extra_candidates.status <> 'canceled'
		ORDER BY smg_users.businessname
	</cfquery>
	
	<cfquery name="get_candidates_no_placement" datasource="MySql">
	SELECT extra_candidates.firstname, extra_candidates.lastname, extra_candidates.placedby, extra_candidates.sex, extra_candidates.hostcompanyid, extra_hostcompany.name, extra_candidates.ds2019, extra_candidates.startdate, extra_candidates.enddate, extra_candidates.intrep, extra_candidates.wat_placement, extra_candidates.candidateid, smg_users.businessname
	FROM extra_candidates
	LEFT JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = extra_candidates.hostcompanyid
	INNER JOIN smg_programs ON smg_programs.programid = extra_candidates.programid
	INNER JOIN smg_users ON smg_users.userid = extra_candidates.intrep
	WHERE extra_candidates.programid = #url.program#  
	AND extra_candidates.status <> 'canceled'
	AND extra_candidates.wat_placement = ''	
	ORDER BY smg_users.businessname
</cfquery>

<cfquery name="get_candidates_self" datasource="MySql">
	SELECT extra_candidates.firstname,extra_candidates.candidateid, extra_candidates.lastname, extra_candidates.placedby, extra_candidates.sex, extra_candidates.hostcompanyid, extra_hostcompany.name, extra_candidates.ds2019, extra_candidates.wat_vacation_Start, extra_candidates.wat_vacation_end, extra_candidates.intrep, extra_candidates.wat_placement, extra_candidates.startdate, extra_candidates.enddate, smg_users.businessname
	FROM extra_candidates
	LEFT JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = extra_candidates.hostcompanyid
	INNER JOIN smg_programs ON smg_programs.programid = extra_candidates.programid
	INNER JOIN smg_users ON smg_users.userid = extra_candidates.intrep
	WHERE extra_candidates.programid = #url.program# 
	AND extra_candidates.wat_placement = 'Self-Placement'
	AND extra_candidates.status <> 'canceled'
	ORDER BY smg_users.businessname
</cfquery>

<cfset total = #get_candidates_self.recordcount# + #get_candidates.recordcount# + #get_candidates_no_placement.recordcount#>

		<cfloop query="get_candidates">
			<tr <cfif into mod 2>bgcolor="##E4E4E4"</cfif>>
				<td class="style1">#firstname# #lastname# (#candidateid#)</td>
				<td class="style1">#sex#</td>
				<td class="style1">#DateFormat(startdate, 'mm/dd/yyyy')#</td>
				<td class="style1">#DateFormat(enddate, 'mm/dd/yyyy')#</td>
				<td class="style1">#name#</td>
				<td class="style1">#ds2019#</td>
				<td class="style1">#wat_placement#</td>
				<td class="style1">#businessname#</td>
			</tr>
			<cfset into = into + 1 >
		</cfloop>
					
		<cfloop query="get_candidates_self">
			<tr <cfif into mod 2>bgcolor="##E4E4E4"</cfif>>
				<td class="style1">#firstname# #lastname# (#candidateid#)</td>
				<td class="style1">#sex#</td>
				<td class="style1">#DateFormat(startdate, 'mm/dd/yyyy')#</td>
				<td class="style1">#DateFormat(enddate, 'mm/dd/yyyy')#</td>
				<td class="style1">#name#</td>
				<td class="style1">#ds2019#</td>
				<td class="style1">#wat_placement#</td>
				<td class="style1">#businessname#</td>
			</tr>
			<cfset into = into + 1 >
		</cfloop>
		
		<cfloop query="get_candidates_no_placement">
			<tr <cfif into mod 2>bgcolor="##E4E4E4"</cfif>>
				<td class="style1">#firstname# #lastname# (#candidateid#)</td>
				<td class="style1">#sex#</td>
				<td class="style1">#DateFormat(startdate, 'mm/dd/yyyy')#</td>
				<td class="style1">#DateFormat(enddate, 'mm/dd/yyyy')#</td>
				<td class="style1">#name#</td>
				<td class="style1">#ds2019#</td>
				<td class="style1"><font color="FF0000"><b>Unassigned</b></font></td>
				<td class="style1">#businessname#</td>
			</tr>
			<cfset into = into + 1 >
		</cfloop>

	
	<!---- Per Int. Rep. ---->
	<cfelse>	
	
	  <tr>
		<td  align="left" class="style1"><b>Student</b></td>
		<td  align="left" class="style1"><b>Sex</b></td>
		<td  align="left" class="style1"><b>Start Date</b></td>
		<td  align="left" class="style1"><b>End Date</b></td>
		<td  align="left" class="style1"><b>Placement Information</b></td>
		<td  align="left" class="style1"><b>DS2019</b></td>
		<td  align="left" class="style1"><b>Option</b></td>	
	  </tr>
	  <tr>
		<td colspan=7><img src="../../pics/black_pixel.gif" width="100%" height="2"></td>
	  </tr>
				
	<cfloop query="get_candidates">
		<tr <cfif get_candidates.currentrow mod 2>bgcolor="##E4E4E4"</cfif>>
			<th align="left" class="style1">#firstname# #lastname# (#candidateid#)</th>
			<th align="left" class="style1">#sex#</th>
			<th align="left" class="style1">#DateFormat(startdate, 'mm/dd/yyyy')#</th>
			<th align="left" class="style1">#DateFormat(enddate, 'mm/dd/yyyy')#</th>
			<th align="left" class="style1">#name#</th>
			<th align="left" class="style1">#ds2019#</th>
			<th align="left" class="style1">#wat_placement#</th>
		</tr>
	</cfloop>
	
	<cfloop query="get_candidates_self">
		<tr <cfif get_candidates_self.currentrow mod 2>bgcolor="##E4E4E4"</cfif>>
			<th align="left" class="style1">#firstname# #lastname# (#candidateid#)</th>
			<th align="left" class="style1">#sex#</th>
			<th align="left" class="style1">#DateFormat(startdate, 'mm/dd/yyyy')#</th>
			<th align="left" class="style1">#DateFormat(enddate, 'mm/dd/yyyy')#</th>
			<th align="left" class="style1">#name#</th>
			<th align="left" class="style1">#ds2019#</th>
			<th align="left" class="style1">#wat_placement#</th>
		</tr>
	</cfloop>
	
	</cfif>
</table>
<img src="../../pics/black_pixel.gif" width="100%" height="2">
<Br><br />
<table width="95%" align="center">
	<tr>
		<td width="50%">
			<div class="style1"><strong>Program:</strong> #program_info.programname#</div>
			<div class="style1"><strong>Int. Rep.:</strong> <cfif url.intrep EQ "All"> All International Rep. <cfelse>#get_intrep.businessname#</cfif></div>
		</td>
		<td width="50%">
			<div class="style1"><strong>INTO-Placement:</strong> #get_candidates.recordcount#</div>
			<div class="style1"><strong>Self-Placement:</strong> #get_candidates_self.recordcount#</div>
			<div class="style1"><strong>Total Number of Students:</strong> #total#</div>
		</td>
	</tr>
</table><br>
<span class="style2">Report Prepared on #DateFormat(now(), 'dddd, mmm, d, yyyy')#</span>
</cfoutput>
</cfdocument>