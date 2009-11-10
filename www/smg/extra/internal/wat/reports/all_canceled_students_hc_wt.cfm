<cfif IsDefined('form.companyid')>
<cfquery name="get_candidates" datasource="MySql">
  SELECT extra_candidates.firstname, extra_candidates.lastname, extra_candidates.placedby, extra_candidates.sex, extra_candidates.hostcompanyid, extra_hostcompany.name, smg_programs.startdate, smg_programs.enddate, extra_candidates.ds2019, extra_candidates.wat_vacation_Start, extra_candidates.wat_vacation_end, extra_candidates.dob, extra_candidates.candidateid, extra_candidates.intrep, extra_candidates.wat_placement, extra_candidates.candidateid, extra_candidates.status
  FROM extra_candidates
  LEFT JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = extra_candidates.hostcompanyid
  INNER JOIN smg_programs ON smg_programs.programid = extra_candidates.programid
  INNER JOIN smg_users ON smg_users.userid = extra_candidates.intrep
  WHERE extra_candidates.hostcompanyid = #form.companyid#
  AND extra_candidates.programid = #form.program#  and extra_candidates.status = 'canceled'
</cfquery>
</cfif>

<cfoutput>

<form action="index.cfm?curdoc=reports/all_canceled_students_hc_wt" method="post">
<table width="95%" cellpadding="4" cellspacing="0" border="0" align="center">
	<tr valign="middle" height="24">
    	<td valign="middle" bgcolor="##E4E4E4" class="title1" colspan=2>&nbsp;All cancelled students per Host Company and Program</td>
  	</tr>
	<tr valign="middle" height="24">
    	<td valign="middle" colspan=2>&nbsp;</td>
  	</tr>
	
	<tr valign="middle">
    	<td align="right" valign="middle" class="style1"><b>Host Company:</b></td>
		<td valign="middle">  
		   <script language="JavaScript" type="text/javascript"> 
			<!-- Begin
			function formHandler2(form){
			var URL = document.formagent.agent.options[document.formagent.agent.selectedIndex].value;
			window.location.href = URL;
			}
			// End -->
		</script>
			  <cfquery name="get_host_company" datasource="MySql">
				SELECT name, hostcompanyid
				FROM extra_hostcompany
				where active = 1
				Order by name
			</cfquery>
		  </font>
       
         
            <select name="companyid" class="style1">
			<option></option>
            <cfloop query="get_host_company">
              <option value="#hostcompanyid#" <cfif IsDefined('form.companyid')><cfif get_host_company.hostcompanyid eq #form.companyid#> selected</cfif></cfif>> #get_host_company.name# </option>
            </cfloop>
          </select>
         
        </td>
    <!--- <cfdocument format="FlashPaper" orientation="landscape" backgroundvisible="yes" overwrite="no" fontembed="yes">--->

	</tr>
    <tr>
		<cfquery name="get_program" datasource="MySql">
			SELECT programname, programid
			FROM smg_programs 
			where companyid = #client.companyid#
		</cfquery>
   	 	<td valign="middle" align="right" class="style1"><b>Program: </b></td>
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
  		<td align="right" class="style1"><b>Format: </b></td>
		<td class="style1"> <input type="radio" name="print" value=0 checked>  Onscreen (View Only) <input type="radio" name="print" value=1> Print (PDF) 
  	</Tr>
  <tr>
  	<td colspan=2 align="center"><br />
<br />
<input type="submit" value="Generate Report" class="style1" /><br />
<br />
<br />
</td>
  </tr>
</table>

<cfif isDefined('form.print')>
	<cfquery name="get_candidates_self" datasource="MySql">
	  SELECT extra_candidates.firstname, extra_candidates.lastname, extra_candidates.placedby, extra_candidates.sex, extra_candidates.hostcompanyid, extra_hostcompany.name, smg_programs.startdate, smg_programs.enddate, extra_candidates.ds2019, extra_candidates.wat_vacation_Start, extra_candidates.wat_vacation_end, extra_candidates.status
	  FROM extra_candidates
	  INNER JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = extra_candidates.hostcompanyid
	  INNER JOIN smg_programs ON smg_programs.programid = extra_candidates.programid
	  INNER JOIN smg_users ON smg_users.userid = extra_candidates.intrep
	  WHERE extra_candidates.hostcompanyid = #form.companyid#
	  AND extra_candidates.programid = #form.program#  and extra_candidates.status = 'canceled'
	  AND extra_candidates.placedby = 'self'
	</cfquery>
	<cfquery name="program_info" datasource="mysql">
		select programname
		from smg_programs
		where programid = #form.program#
	</cfquery> 

		<cfset total = #get_candidates_self.recordcount# + #get_candidates.recordcount#>



	<cfif form.print eq 1>
		<span class="style1"><center><b>Results are being generated...</b></center></span><br /><br /><br />		
		<meta http-equiv="refresh" content="1;url=index.cfm?curdoc=reports/all_canceled_students_hc_wt_flashpaper&program=#form.program#&hostcompanyid=#form.companyid#">
		
	<cfelse>

<div class="style1"><strong>&nbsp; &nbsp; INTO-Placement:</strong> #get_candidates.recordcount#</div>	
<div class="style1"><strong>&nbsp; &nbsp; Self-Placement:</strong> #get_candidates_self.recordcount#</div>
<div class="style1"><strong>&nbsp; &nbsp; ----------------------------------</strong></div>
<div class="style1"><strong>&nbsp; &nbsp; Total Number Students:</strong> #total#</div>
<div class="style1"><strong>&nbsp; &nbsp; ----------------------------------</strong></div>

<br />

					
<table width=99% cellpadding="4" cellspacing=0 align="center">
 	<tr>
    	<th align="left" bgcolor="4F8EA4" class="style2">Student</Th>
      	<th align="left" bgcolor="4F8EA4" class="style2">Sex</th>
	  	<th align="left" bgcolor="4F8EA4" class="style2">Placement Information</th>
	  	<th align="left" bgcolor="4F8EA4" class="style2">DS2019</th>
	  	<th align="left" bgcolor="4F8EA4" class="style2">Option</th>
    </tr>
	<cfset into = 1 >			
	<cfloop query="get_candidates">
	<tr <cfif into mod 2>bgcolor="##E4E4E4"</cfif>>
		<td class="style1">#firstname# #lastname# (#candidateid#)</td>
		<td class="style1">#sex#</td>
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
		<td class="style1">#name#</td>
		<td class="style1">#ds2019#</td>
		<td class="style1">#wat_placement#</td>
	</tr>
	<cfset into = into + 1 >
	</cfloop>

</table>
			  

<br>
<span class="style1">Report Prepared on #DateFormat(now(), 'dddd, mmm, d, yyyy')#</font> 

</cfif>
</cfif>
</cfoutput>