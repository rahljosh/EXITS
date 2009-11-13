<cfsetting requesttimeout="99999">

<cfif IsDefined('form.intrep') AND form.intrep NEQ "All">
	<cfquery name="get_candidates_into" datasource="MySql">
		SELECT extra_candidates.firstname, extra_candidates.lastname, extra_candidates.placedby, extra_candidates.sex, extra_candidates.hostcompanyid, extra_hostcompany.name, smg_programs.startdate, smg_programs.enddate, extra_candidates.ds2019, extra_candidates.wat_vacation_Start, extra_candidates.wat_vacation_end, extra_candidates.dob, extra_candidates.candidateid, extra_candidates.intrep, extra_candidates.wat_placement, extra_candidates.candidateid, extra_candidates.status
		FROM extra_candidates
		LEFT JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = extra_candidates.hostcompanyid
		INNER JOIN smg_programs ON smg_programs.programid = extra_candidates.programid
		INNER JOIN smg_users ON smg_users.userid = extra_candidates.intrep
		WHERE extra_candidates.intrep = #form.intrep#
		AND extra_candidates.programid = #form.program#  
		AND extra_candidates.status = 'canceled'
		AND extra_candidates.wat_placement = 'INTO-Placement'
	</cfquery>
	<cfquery name="get_candidates_self" datasource="MySql">
	  SELECT extra_candidates.firstname, extra_candidates.lastname, extra_candidates.candidateid, extra_candidates.placedby, extra_candidates.sex, extra_candidates.hostcompanyid, extra_hostcompany.name, smg_programs.startdate, smg_programs.enddate, extra_candidates.ds2019, extra_candidates.wat_vacation_Start, extra_candidates.wat_vacation_end, extra_candidates.status, extra_candidates.wat_placement
	  FROM extra_candidates
	  LEFT JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = extra_candidates.hostcompanyid
	  INNER JOIN smg_programs ON smg_programs.programid = extra_candidates.programid
	  INNER JOIN smg_users ON smg_users.userid = extra_candidates.intrep
	  WHERE extra_candidates.intrep = #form.intrep#
 	  AND extra_candidates.programid = #form.program#  and extra_candidates.status = 'canceled'
	  AND extra_candidates.wat_placement = 'Self-Placement'
	</cfquery>
</cfif>

<script>
function test(){
	with (document.form) {
		if (intrep.value == '') {
			alert("Please, select a INTERNATIONAL REP. first!");
			intrep.focus();
			return false;
		}
		if (program.value == '') {
			alert("Please, select a PROGRAM first!");
			program.focus();
			return false;
		}
	}
}
</script>


<cfoutput>

<form action="index.cfm?curdoc=reports/all_canceled_students_enrolled_wt" method="post" name="form" onSubmit="return test()">
<table width="95%" cellpadding="4" cellspacing="0" border="0" align="center">
  <tr valign="middle" height="24">
    <td valign="middle" bgcolor="##E4E4E4" class="title1" colspan=2><span class="style1">&nbsp;All cancelled students per Int. Rep. and Program</span></td>
  </tr>
  <tr valign="middle" height="24">
    <td valign="middle" class="title1" colspan=2>&nbsp;</td>
  </tr>


  	
  <tr valign="middle">
    <td align="right" valign="middle" class="style1"><b>Int. Rep.:</b> </td>
	
	<td valign="middle">  
      <script language="JavaScript" type="text/javascript"> 
		<!-- Begin
		function formHandler2(form){
		var URL = document.formagent.agent.options[document.formagent.agent.selectedIndex].value;
		window.location.href = URL;
		}
		// End -->
    </script>

		
		<cfquery name="get_intrep" datasource="MySql">
			SELECT userid as intrep, businessname
			FROM smg_users
			WHERE usertype = 8
			AND businessname != ' '
			ORDER BY businessname	
		</cfquery>
      </span>
       
        
		  
	   <select name="intrep" class="style1">
			<option></option>
			<option value="All">---  All International Representatives  ---</option>
            <cfloop query="get_intrep">
              <option value="#get_intrep.intrep#" <cfif IsDefined('form.intrep')><cfif get_intrep.intrep eq #form.intrep#> selected</cfif></cfif>> #get_intrep.businessname# </option>
            </cfloop>
       </select>
         
        </td>

  </tr>
    <tr>
    <cfquery name="get_program" datasource="MySql">
		SELECT programname, programid
		FROM smg_programs 
		where companyid = #client.companyid#
    </cfquery>
    <td valign="middle" align="right" class="style1"><b>Program:</b> </td>
	<td> 
	<select name="program" class="style1">
		<option></option>
		<cfloop query="get_program">
		<option value=#programid# <cfif IsDefined('form.program')><cfif get_program.programid eq #form.program#> selected</cfif></cfif>>#programname#</option>
		</cfloop>
	</select>
	 </td>
	</tr>

 <Tr>
  	<td align="right" class="style1"><b>Format:</b> </td><td  class="style1"> <input type="radio" name="print" value=0 checked>  Onscreen (View Only) <input type="radio" name="print" value=1> Print (PDF) 
  </Tr>
  <tr>
  	<td colspan=2 align="center"><br />
  	  <input type="submit" value="Generate Report" class="style1" />
      <br />
      <br />
      <br /></td>
  </tr>
</table>

<cfif isDefined('form.print')>
	<cfquery name="program_info" datasource="mysql">
		select programname
		from smg_programs
		where programid = #form.program#
	</cfquery> 
		



	<cfif form.print eq 1>
		 <span class="style1"><center><b>Results are being generated...	</b></center></span><br /><br /><br />
		<meta http-equiv="refresh" content="1;url=index.cfm?curdoc=reports/all_canceled_students_enrolled_flashpaper&program=#form.program#&intrep=#form.intrep#">
		
	<cfelse>

	<cfset into =  0 >
	<cfparam name="variables.intoPlacement" default="0">
	<cfparam name="variables.selfPlacement" default="0">
	<cfparam name="variables.grandTotal" default="0">
	
	<!---- All Participants ---->
	<cfif form.intrep EQ "All">
	
		<cfquery name="getWatAgents" datasource="MySQL">
		SELECT userid, businessname
		FROM smg_users
		WHERE usertype =8
		AND userid
		IN (
		
		SELECT DISTINCT(intrep)
		FROM extra_candidates
		WHERE programid = #form.program#
		AND status = 'canceled'
		)
		ORDER BY businessname
		</cfquery>
	
	<cfloop query="getWatAgents">
	
		<cfquery name="get_candidates_into" datasource="MySql">
			SELECT extra_candidates.firstname, extra_candidates.lastname, extra_candidates.placedby, extra_candidates.sex, extra_candidates.hostcompanyid, extra_hostcompany.name, smg_programs.startdate, smg_programs.enddate, extra_candidates.ds2019, extra_candidates.wat_vacation_Start, extra_candidates.wat_vacation_end, extra_candidates.dob, extra_candidates.candidateid, extra_candidates.intrep, extra_candidates.wat_placement, extra_candidates.candidateid, extra_candidates.status, smg_users.businessname
			FROM extra_candidates
			LEFT JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = extra_candidates.hostcompanyid
			INNER JOIN smg_programs ON smg_programs.programid = extra_candidates.programid
			INNER JOIN smg_users ON smg_users.userid = extra_candidates.intrep
			WHERE extra_candidates.programid = #form.program#  
			AND extra_candidates.status = 'canceled'
			AND extra_candidates.wat_placement = 'INTO-Placement'
			AND extra_candidates.intrep = #getWatAgents.userid#
			ORDER BY smg_users.businessname, extra_candidates.wat_placement
		</cfquery>
		<cfquery name="get_candidates_self" datasource="MySql">
		  SELECT extra_candidates.firstname, extra_candidates.lastname, extra_candidates.candidateid, extra_candidates.placedby, extra_candidates.sex, extra_candidates.hostcompanyid, extra_hostcompany.name, smg_programs.startdate, smg_programs.enddate, extra_candidates.ds2019, extra_candidates.wat_vacation_Start, extra_candidates.wat_vacation_end, extra_candidates.status, extra_candidates.wat_placement, smg_users.businessname
		  FROM extra_candidates
		  LEFT JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = extra_candidates.hostcompanyid
		  INNER JOIN smg_programs ON smg_programs.programid = extra_candidates.programid
		  INNER JOIN smg_users ON smg_users.userid = extra_candidates.intrep
		  WHERE extra_candidates.programid = #form.program#  and extra_candidates.status = 'canceled'
		  AND extra_candidates.wat_placement = 'Self-Placement'
		  AND extra_candidates.intrep = #getWatAgents.userid#
		  ORDER BY smg_users.businessname
		</cfquery>

		<cfset totalPerAgent = #get_candidates_self.recordcount# + #get_candidates_into.recordcount#>
		<cfset intoPlacement = #variables.intoPlacement# + #get_candidates_into.recordcount#>
		<cfset selfPlacement = #variables.selfPlacement# + #get_candidates_self.recordcount#>
		<cfset grandTotal = #variables.grandTotal# + #variables.totalPerAgent#>
				
		<table width=99% cellpadding="4" cellspacing=0 align='center'>
			<tr>
				<td><small><strong>#businessname# - Total Candidates: #variables.totalPerAgent#</strong> (#get_candidates_into.recordcount# INTO, #get_candidates_self.recordcount# Self)</small></td>
			</tr>
			<tr>
			  <Th align="left" bgcolor="4F8EA4" class="style2">Student</Th>
			  <th align="left" bgcolor="4F8EA4" class="style2">Sex</th>
			  <th align="left" bgcolor="4F8EA4" class="style2">Placement Info</th>
			  <th align="left" bgcolor="4F8EA4" class="style2">DS2019</th>
			  <th align="left" bgcolor="4F8EA4" class="style2">Option</th>
			  <th align="left" bgcolor="4F8EA4" class="style2">Int. Rep.</th>
			</tr>
				
			<cfloop query="get_candidates_into">
			<tr <cfif into mod 2>bgcolor="##E4E4E4"</cfif>>
				<td><span class="style1">#firstname# #lastname# (#candidateid#)</span></td>
				<td><span class="style1">#sex#</span></td>
				<td><span class="style1">#name#</span></td>
				<td><span class="style1">#ds2019#</span></td>
				<td><span class="style1">#wat_placement# </span></td>
				<td class="style1">#businessname#</td>
			</tr>
			<cfset into = into + 1 >
			</cfloop>

			<cfloop query="get_candidates_self">
			<tr <cfif into mod 2>bgcolor="##E4E4E4"</cfif>>
				<td><span class="style1">#firstname# #lastname# (#candidateid#)</span></td>
				<td><span class="style1">#sex#</span></td>
				<td><span class="style1">#name#</span></td>
				<td><span class="style1">#ds2019#</span></td>
				<td><span class="style1">#wat_placement# </span></td>
				<td class="style1">#businessname#</td>
			</tr>
			<cfset into = into + 1 >
			</cfloop>
		</table>		
		<br/><br/>
	</cfloop>
		
	<!---- Per Int. Rep. ---->
	<cfelse>
	
	<cfset totalPerAgent = #get_candidates_self.recordcount# + #get_candidates_into.recordcount#>
	<cfset intoPlacement = #variables.intoPlacement# + #get_candidates_into.recordcount#>
	<cfset selfPlacement = #variables.selfPlacement# + #get_candidates_self.recordcount#>
	<cfset grandTotal = #variables.grandTotal# + #variables.totalPerAgent#>
	
	<table width=99% cellpadding="4" cellspacing=0 align='center'>
	<tr>
      <Th align="left" bgcolor="4F8EA4" class="style2">Student</Th>
      <th align="left" bgcolor="4F8EA4" class="style2">Sex</th>
      <th align="left" bgcolor="4F8EA4" class="style2">Placement Info</th>
      <th align="left" bgcolor="4F8EA4" class="style2">DS2019</th>
	  <th align="left" bgcolor="4F8EA4" class="style2">Option</th>
    </tr>
		<cfloop query="get_candidates_into">
		<tr <cfif into mod 2>bgcolor="##E4E4E4"</cfif>>
			<td><span class="style1">#firstname# #lastname# (#candidateid#)</span></td>
			<td><span class="style1">#sex#</span></td>
			<td><span class="style1">#name#</span></td>
			<td><span class="style1">#ds2019#</span></td>
			<td><span class="style1">#wat_placement# </span></td>
		</tr>
		<cfset into = into + 1 >
		</cfloop>
		
		<cfloop query="get_candidates_self">
		<tr <cfif into mod 2>bgcolor="##E4E4E4"</cfif>>
			<td><span class="style1">#firstname# #lastname# (#candidateid#)</span></td>
			<td><span class="style1">#sex#</span></td>
			<td><span class="style1">#name#</span></td>
			<td><span class="style1">#ds2019#</span></td>
			<td><span class="style1">#wat_placement# </span></td>
		</tr>
		<cfset into = into + 1 >
		</cfloop>
		</table>
	</cfif>

<br>
<div class="style1"><strong>&nbsp; &nbsp; INTO-Placement:</strong> #variables.intoPlacement#</div>	
<div class="style1"><strong>&nbsp; &nbsp; Self-Placement:</strong> #variables.selfPlacement#</div>
<div class="style1"><strong>&nbsp; &nbsp; ----------------------------------</strong></div>
<div class="style1"><strong>&nbsp; &nbsp; Total Number Students:</strong> #variables.grandTotal#</div>
<div class="style1"><strong>&nbsp; &nbsp; ----------------------------------</strong></div>

<br />
<br>
<span class="style1">Report Prepared on #DateFormat(now(), 'dddd, mmm, d, yyyy')#</span> 
			  
</cfif>
</cfif>

</cfoutput>