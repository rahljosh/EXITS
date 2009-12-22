<cfif IsDefined('form.intrep') AND form.intrep NEQ "All">

<cfquery name="get_candidates_into" datasource="MySql">
	SELECT extra_candidates.firstname, extra_candidates.lastname, extra_candidates.placedby, extra_candidates.sex, extra_candidates.hostcompanyid, extra_hostcompany.name, extra_candidates.ds2019, extra_candidates.startdate, extra_candidates.enddate
	, extra_candidates.intrep, extra_candidates.wat_placement, extra_candidates.candidateid
	FROM extra_candidates
	LEFT JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = extra_candidates.hostcompanyid
	INNER JOIN smg_programs ON smg_programs.programid = extra_candidates.programid
	INNER JOIN smg_users ON smg_users.userid = extra_candidates.intrep
	WHERE extra_candidates.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.intrep#">
	AND extra_candidates.programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.program#">
	AND extra_candidates.wat_placement = <cfqueryparam cfsqltype="cf_sql_varchar" value="CSB-Placement">
	AND extra_candidates.status <> <cfqueryparam cfsqltype="cf_sql_varchar" value="canceled">
</cfquery>

<cfquery name="get_candidates_no_placement" datasource="MySql">
	SELECT extra_candidates.firstname, extra_candidates.lastname, extra_candidates.placedby, extra_candidates.sex, extra_candidates.hostcompanyid, extra_hostcompany.name, extra_candidates.ds2019, extra_candidates.startdate, extra_candidates.enddate
	, extra_candidates.intrep, extra_candidates.wat_placement, extra_candidates.candidateid
	FROM extra_candidates
	LEFT JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = extra_candidates.hostcompanyid
	INNER JOIN smg_programs ON smg_programs.programid = extra_candidates.programid
	INNER JOIN smg_users ON smg_users.userid = extra_candidates.intrep
	WHERE extra_candidates.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.intrep#">
	AND extra_candidates.programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.program#">
	AND extra_candidates.status <> <cfqueryparam cfsqltype="cf_sql_varchar" value="canceled">
	AND extra_candidates.wat_placement = <cfqueryparam cfsqltype="cf_sql_varchar" value="">	
</cfquery>

<cfquery name="get_candidates_self" datasource="MySql">
	SELECT extra_candidates.firstname,extra_candidates.candidateid, extra_candidates.lastname, extra_candidates.placedby, extra_candidates.sex, extra_candidates.hostcompanyid, extra_hostcompany.name, extra_candidates.ds2019, extra_candidates.wat_vacation_Start, extra_candidates.wat_vacation_end, extra_candidates.intrep, extra_candidates.wat_placement, extra_candidates.startdate, extra_candidates.enddate
	FROM extra_candidates
	LEFT JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = extra_candidates.hostcompanyid
	INNER JOIN smg_programs ON smg_programs.programid = extra_candidates.programid
	INNER JOIN smg_users ON smg_users.userid = extra_candidates.intrep
	WHERE extra_candidates.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.intrep#">
	AND extra_candidates.programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.program#">
	AND extra_candidates.wat_placement = <cfqueryparam cfsqltype="cf_sql_varchar" value="Self-Placement">
	AND extra_candidates.status <> <cfqueryparam cfsqltype="cf_sql_varchar" value="canceled">
</cfquery>

<cfset total = get_candidates_self.recordcount + get_candidates_into.recordcount + get_candidates_no_placement.recordcount>

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

<form action="index.cfm?curdoc=reports/all_students_enrolled_wt" method="post" name="form" onSubmit="return test()">
<table width="95%" cellpadding="4" cellspacing="0" border="0" align="center">
  <tr valign="middle" height="24">
    <td valign="middle" bgcolor="##E4E4E4" class="title1" colspan=2><span class="style1">&nbsp;All active students enrolled in the program by Int. Rep. and Program</span></td>
  </tr>
  <tr valign="middle" height="24">
    <td valign="middle" colspan=2>&nbsp;</td>
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
    <td valign="middle" align="right" class="style1"><b>Program:</b></td>
	<td> <select name="program"  class="style1">
		<option></option>
	<cfloop query="get_program">
	<option value=#programid# <cfif IsDefined('form.program')><cfif get_program.programid eq #form.program#> selected</cfif></cfif>>#programname#</option>
	</cfloop>
	</select>
	 </td>
	</tr>

 <Tr>
  	<td align="right" class="style1"><b>Format: </b></td><td  class="style1"> <input type="radio" name="print" value=0 checked>  Onscreen (View Only) <input type="radio" name="print" value=1> Print (PDF) 
  </Tr>
  <tr>
  	<td colspan=2 align="center"><br />
  	<input type="submit" value="Generate Report" class="style1" />
  	  <br />
  	  <br />
  	  <br /></td></tr>
</table>


<cfif isDefined('form.print')>
	<cfif form.print eq 1>
		<span class="style1"><center><b>Results are being generated...</b></center></span><br /><br /><br />
		<meta http-equiv="refresh" content="1;url=index.cfm?curdoc=reports/all_students_enrolled_wt_flashpaper&program=#form.program#&intrep=#form.intrep#">
		
	<cfelse>

<br />
	
	<cfset into =  0 >
	<cfparam name="variables.intoPlacement" default="0">
	<cfparam name="variables.selfPlacement" default="0">
	<cfparam name="variables.noPlacement" default="0">
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
		AND status != 'canceled'
		)
		ORDER BY businessname
		</cfquery>
		
	<cfloop query="getWatAgents">
	
		<cfquery name="get_candidates_into" datasource="MySql">
		SELECT extra_candidates.firstname, extra_candidates.lastname, extra_candidates.placedby, extra_candidates.sex, extra_candidates.hostcompanyid, extra_hostcompany.name, extra_candidates.ds2019, extra_candidates.startdate, extra_candidates.enddate, extra_candidates.intrep, extra_candidates.wat_placement, extra_candidates.candidateid, smg_users.businessname
		FROM extra_candidates
		LEFT JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = extra_candidates.hostcompanyid
		INNER JOIN smg_programs ON smg_programs.programid = extra_candidates.programid
		INNER JOIN smg_users ON smg_users.userid = extra_candidates.intrep
		WHERE extra_candidates.programid = #form.program#  
		AND extra_candidates.wat_placement = 'CSB-Placement'
		AND extra_candidates.status <> 'canceled'
		AND extra_candidates.intrep = #getWatAgents.userid#
		ORDER BY smg_users.businessname
		</cfquery>
	
		<cfquery name="get_candidates_no_placement" datasource="MySql">
		SELECT extra_candidates.firstname, extra_candidates.lastname, extra_candidates.placedby, extra_candidates.sex, extra_candidates.hostcompanyid, extra_hostcompany.name, extra_candidates.ds2019, extra_candidates.startdate, extra_candidates.enddate, extra_candidates.intrep, extra_candidates.wat_placement, extra_candidates.candidateid, smg_users.businessname
		FROM extra_candidates
		LEFT JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = extra_candidates.hostcompanyid
		INNER JOIN smg_programs ON smg_programs.programid = extra_candidates.programid
		INNER JOIN smg_users ON smg_users.userid = extra_candidates.intrep
		WHERE extra_candidates.programid = #form.program#  
		AND extra_candidates.status <> 'canceled'
		AND extra_candidates.wat_placement = ''	
		AND extra_candidates.intrep = #getWatAgents.userid#
		ORDER BY smg_users.businessname
		</cfquery>
	
		<cfquery name="get_candidates_self" datasource="MySql">
		SELECT extra_candidates.firstname,extra_candidates.candidateid, extra_candidates.lastname, extra_candidates.placedby, extra_candidates.sex, extra_candidates.hostcompanyid, extra_hostcompany.name, extra_candidates.ds2019, extra_candidates.wat_vacation_Start, extra_candidates.wat_vacation_end, extra_candidates.intrep, extra_candidates.wat_placement, extra_candidates.startdate, extra_candidates.enddate, smg_users.businessname
		FROM extra_candidates
		LEFT JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = extra_candidates.hostcompanyid
		INNER JOIN smg_programs ON smg_programs.programid = extra_candidates.programid
		INNER JOIN smg_users ON smg_users.userid = extra_candidates.intrep
		WHERE extra_candidates.programid = #form.program# 
		AND extra_candidates.wat_placement = 'Self-Placement'
		AND extra_candidates.status <> 'canceled'
		AND extra_candidates.intrep = #getWatAgents.userid#
		ORDER BY smg_users.businessname
		</cfquery>
		
	<cfset totalPerAgent = #get_candidates_self.recordcount# + #get_candidates_into.recordcount# + #get_candidates_no_placement.recordcount#>
	<cfset intoPlacement = #variables.intoPlacement# + #get_candidates_into.recordcount#>
	<cfset selfPlacement = #variables.selfPlacement# + #get_candidates_self.recordcount#>
	<cfset noPlacement = #variables.noPlacement# + #get_candidates_no_placement.recordcount#>
	<cfset grandTotal = #variables.grandTotal# + #variables.totalPerAgent#>
	
  <table width=99% cellpadding="4" cellspacing=0 align="center">
  	<tr>
		<td colspan="8">
		<small><strong>#businessname# - Total candidates: #variables.totalPerAgent#</strong> (#get_candidates_into.recordcount# INTO; #get_candidates_self.recordcount# Self)</small>
		</td>
	</tr>
	<tr>
      <Th align="left" bgcolor="4F8EA4" class="style2">Student</Th>
      <th align="left" bgcolor="4F8EA4" class="style2">Sex</th>
      <th align="left" bgcolor="4F8EA4" class="style2">Start Date</th>
      <th align="left" bgcolor="4F8EA4" class="style2">End Date</th>
	  <th align="left" bgcolor="4F8EA4" class="style2">Placement Information</th>
	  <th align="left" bgcolor="4F8EA4" class="style2">DS2019</th>
	  <th align="left" bgcolor="4F8EA4" class="style2">Option</th>
	  <th align="left" bgcolor="4F8EA4" class="style2">Int. Rep.</th>
    </tr>
				
		<cfloop query="get_candidates_into">
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
		</table>
		<br/><br/>
	</cfloop>
	
	<!---- Per Int. Rep. ---->
	<cfelse>
	
	<cfset totalPerAgent = #get_candidates_self.recordcount# + #get_candidates_into.recordcount# + #get_candidates_no_placement.recordcount#>
	<cfset intoPlacement = #variables.intoPlacement# + #get_candidates_into.recordcount#>
	<cfset selfPlacement = #variables.selfPlacement# + #get_candidates_self.recordcount#>
	<cfset noPlacement = #variables.noPlacement# + #get_candidates_no_placement.recordcount#>
	<cfset grandTotal = #variables.grandTotal# + #variables.totalPerAgent#>
	<table width=99% cellpadding="4" cellspacing=0 align="center">
	<tr>
      <Th align="left" bgcolor="4F8EA4" class="style2">Student</Th>
      <th align="left" bgcolor="4F8EA4" class="style2">Sex</th>
      <th align="left" bgcolor="4F8EA4" class="style2">Start Date</th>
      <th align="left" bgcolor="4F8EA4" class="style2">End Date</th>
	  <th align="left" bgcolor="4F8EA4" class="style2">Placement Information</th>
	  <th align="left" bgcolor="4F8EA4" class="style2">DS2019</th>
	  <th align="left" bgcolor="4F8EA4" class="style2">Option</th>
    </tr>					
		<cfloop query="get_candidates_into">
			<tr <cfif into mod 2>bgcolor="##E4E4E4"</cfif>>
				<td class="style1">#firstname# #lastname# (#candidateid#)</td>
				<td class="style1">#sex#</td>
				<td class="style1">#DateFormat(startdate, 'mm/dd/yyyy')#</td>
				
				<td class="style1">#DateFormat(enddate, 'mm/dd/yyyy')#</td>
				<td class="style1">#name#</td>
				<td class="style1">#ds2019#</td>
				<td class="style1">#wat_placement#</td>
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
			</tr>
			<cfset into = into + 1 >
		</cfloop>
		</table>
	</cfif>
	
	

<br />	

<div class="style1"><strong>&nbsp; &nbsp; CSB-Placement:</strong> #variables.intoPlacement#</div>	
<div class="style1"><strong>&nbsp; &nbsp; Self-Placement:</strong> #variables.selfPlacement#</div>
<div class="style1"><strong>&nbsp; &nbsp; Unassigned:</strong> #variables.noPlacement#</div>
<div class="style1"><strong>&nbsp; &nbsp; ----------------------------------</strong></div>
<div class="style1"><strong>&nbsp; &nbsp; Total Number Students:</strong> #variables.grandTotal#</div>
<div class="style1"><strong>&nbsp; &nbsp; ----------------------------------</strong></div> 
<br>
<span class="style1">Report Prepared on #DateFormat(now(), 'dddd, mmm, d, yyyy')#</span> 
			    
<img src="../../pics/black_pixel.gif" alt="." width="100%" height="2"> <Br><br />
</cfif>
</cfif>
</cfoutput>