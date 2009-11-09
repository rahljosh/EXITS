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

<cfquery name="get_candidates" datasource="MySql">
  	SELECT extra_candidates.firstname, extra_candidates.lastname, extra_candidates.placedby, extra_candidates.sex, extra_candidates.hostcompanyid, extra_hostcompany.name, smg_programs.startdate, smg_programs.enddate, extra_candidates.ds2019, extra_candidates.wat_vacation_start, extra_candidates.wat_vacation_end, extra_candidates.dob, extra_candidates.candidateid, extra_candidates.intrep, extra_candidates.wat_placement, extra_candidates.candidateid, extra_candidates.status
  	FROM extra_candidates
  	LEFT JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = extra_candidates.hostcompanyid
  	INNER JOIN smg_programs ON smg_programs.programid = extra_candidates.programid
  	INNER JOIN smg_users ON smg_users.userid = extra_candidates.intrep
  	WHERE extra_candidates.hostcompanyid = #url.hostcompanyid#
 	AND extra_candidates.programid = #url.program#  and extra_candidates.status = 'canceled'
</cfquery>

<cfquery name="get_candidates_self" datasource="MySql">
 	SELECT extra_candidates.firstname, extra_candidates.lastname, extra_candidates.placedby, extra_candidates.sex, extra_candidates.hostcompanyid, extra_hostcompany.name, smg_programs.startdate, smg_programs.enddate, extra_candidates.ds2019, extra_candidates.wat_vacation_Start, extra_candidates.wat_vacation_end, extra_candidates.status
	FROM extra_candidates
	INNER JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = extra_candidates.hostcompanyid
	INNER JOIN smg_programs ON smg_programs.programid = extra_candidates.programid
	INNER JOIN smg_users ON smg_users.userid = extra_candidates.intrep
	WHERE extra_candidates.hostcompanyid = #url.hostcompanyid#
	AND extra_candidates.programid = #url.program# and extra_candidates.status = 'canceled'
	AND extra_candidates.placedby = 'self'
</cfquery>

<cfquery name="program_info" datasource="mysql">
	SELECT programname
	FROM smg_programs
	WHERE programid = #url.program#
</cfquery> 

<cfquery name="get_hostcompanyname" datasource="mysql">
	SELECT extra_hostcompany.name
	FROM extra_hostcompany
	WHERE extra_hostcompany.hostcompanyid = #url.hostcompanyid#
</cfquery>

<cfset total = #get_candidates_self.recordcount# + #get_candidates.recordcount#>
<cfoutput>


<img src="../../pics/black_pixel.gif" width="100%" height="2">
<div class="title1">All cancelled students by Host Company and Program</div>
<img src="../../pics/black_pixel.gif" width="100%" height="2">
<table width="95%" align="center">
	<tr>
		<td width="50%">
			<div class="style1"><strong>Program:</strong> #program_info.programname#</div>
			<div class="style1"><strong>Host Company:</strong> #get_hostcompanyname.name# </div>
		</td>
		<td width="50%">
			<div class="style1"><strong>INTO-Placement:</strong> #get_candidates.recordcount#</div>
			<div class="style1"><strong>Self-Placement:</strong> #get_candidates_self.recordcount#</div>
			<div class="style1"><strong>Total Number of Students:</strong> #total#</div>
		</td>
	</tr>
</table>

<img src="../../pics/black_pixel.gif" width="100%" height="2">

<table width=100% cellpadding="4" cellspacing=0> 
  	<tr>
		<th  align="left" class="style1">Student</th>
		<th  align="left" class="style1">Sex </th>
		<th  align="left" class="style1">Start Date</th>
		<th  align="left" class="style1">End Date</th>
		<th  align="left" class="style1">Placement Information</th>
		<th  align="left" class="style1">DS2019</th>
		<th  align="left" class="style1">Option</th>	
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
</table>
				<img src="../../pics/black_pixel.gif" width="100%" height="2">
				<Br><br>
				<span class="style2">Report Prepared on #DateFormat(now(), 'dddd, mmm, d, yyyy')#</span>
				</cfoutput>
</cfdocument>