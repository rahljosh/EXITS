<cfif IsDefined('form.program')>
	<cfquery name="get_students" datasource="mysql">
	SELECT c.firstname, c.lastname, c.sex, c.home_country, c.intrep, c.requested_placement, c.programid, smg_programs.programname, smg_users.companyid, smg_users.businessname, c.companyid, c.hostcompanyid, smg_countrylist.countryname, extra_hostcompany.name, c.wat_placement, c.candidateid, c.wat_placement
	FROM extra_candidates c
	INNER JOIN smg_users ON smg_users.userid = c.intrep
	INNER JOIN smg_programs ON smg_programs.programid = c.programid
	INNER JOIN smg_countrylist ON smg_countrylist.countryid = c.home_country
	LEFT JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = c.requested_placement 
	  WHERE c.companyid = #client.companyid#
	  AND c.hostcompanyid = 0
	  AND c.programid = #form.program#
	  AND c.status = 1
	  AND c.wat_placement = 'CSB-Placement'
	ORDER BY businessname
	</cfquery>
	
	<cfquery name="get_students_self" datasource="mysql">
	SELECT c.firstname, c.lastname, c.sex, c.home_country, c.intrep, c.requested_placement, c.programid, smg_programs.programname, smg_users.companyid, smg_users.businessname, c.companyid, c.hostcompanyid, smg_countrylist.countryname, extra_hostcompany.name, c.wat_placement, c.candidateid, c.wat_placement
	FROM extra_candidates c
	INNER JOIN smg_users ON smg_users.userid = c.intrep
	INNER JOIN smg_programs ON smg_programs.programid = c.programid
	INNER JOIN smg_countrylist ON smg_countrylist.countryid = c.home_country
	LEFT JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = c.requested_placement 
	  WHERE c.companyid = #client.companyid#
	  AND c.hostcompanyid = 0
	  AND c.programid = #form.program#
	  AND c.status = 1
	  AND c.wat_placement = 'Self-Placement'
	ORDER BY businessname
	</cfquery>
	
	<cfset total = #get_students_self.recordcount# + #get_students.recordcount#>
</cfif>


<cfoutput >



<form action="index.cfm?curdoc=reports/unplaced_students_wt" method="post">
<table width="95%" cellpadding="4" cellspacing="0" border="0" align="center">
  <tr valign="middle" height="24">
    <td valign="middle" bgcolor="##E4E4E4" class="title1" colspan=2>&nbsp;Unplaced students - for self and into placement</td>
  </tr>
  	
  <tr valign="middle">
  	<tr valign="middle" height="24">
    	<td valign="middle" colspan=2> <script language="JavaScript" type="text/javascript"> 
		<!-- Begin
		function formHandler2(form){
		var URL = document.formagent.agent.options[document.formagent.agent.selectedIndex].value;
		window.location.href = URL;
		}
		// End -->
    </script></td>
  	</tr>

    <tr>
    <cfquery name="get_program" datasource="MySql">
		SELECT programname, programid
		FROM smg_programs 
		where companyid = #client.companyid#
    </cfquery>
    <td valign="middle" align="right" class="style1">Program: </td><td> 
	<select name="program" class="style1">
		<option></option>
		<cfloop query="get_program">
		<option value=#programid# <cfif IsDefined('form.program')><cfif get_program.programid eq #form.program#> selected</cfif></cfif>>#programname#</option>
		</cfloop>
	</select>
	
	 </td>
  
  </tr>

  <Tr>
  	<td align="right" class="style1">Format: </td>
	<td class="style1"> <input type="radio" class="style1" name="print" value=0 checked>  Onscreen (View Only) <input type="radio" name="print" value=1> Print (FlashPaper) 
  </Tr>
  <tr>
  	<td colspan=2 align="center"><br />
<input type="submit" value="Generate Report" class="style1" /><br />
<br />
</td>
  </tr>
</table>

<br>


<!-----Display Reports---->

<cfif isDefined('form.print')>
	<cfif form.print eq 1>
		<span class="style1"><center><b>Results are being generated...</b></center></span><br /><br /><br />		
		<meta http-equiv="refresh" content="1;url=index.cfm?curdoc=reports/unplaced_students_wt_flashpaper&program=#form.program#">
	<cfelse>

<!--- <cfquery name="get_wat_placement" datasource="mysql">
	SELECT wat_placement, count(wat_placement) AS total
	FROM extra_candidates
	WHERE active = 1 
	AND companyid = 8
	AND hostcompanyid = 0
	AND status = 1
	AND active = 1
	GROUP BY wat_placement
</cfquery> --->


<div class="style1"><strong>&nbsp; &nbsp; CSB-Placement:</strong> #get_students.recordcount#</div>	
<div class="style1"><strong>&nbsp; &nbsp; Self-Placement:</strong> #get_students_self.recordcount#</div>
<div class="style1"><strong>&nbsp; &nbsp; ----------------------------------</strong></div>
<div class="style1"><strong>&nbsp; &nbsp; Total Number Students:</strong> #total#</div>
<div class="style1"><strong>&nbsp; &nbsp; ----------------------------------</strong></div>

<!--- <cfloop query="get_wat_placement">
<strong><font size="2" face="Verdana, Arial, Helvetica, sans-serif" >Students #wat_placement#:  #total# </font></strong>
<br />
</cfloop>
<strong><font size="2" face="Verdana, Arial, Helvetica, sans-serif" >Total Number of Students: #get_students.recordcount# </font></strong><br /> --->

<img src="../../pics/black_pixel.gif" width="100%" height="2">
					
  <table width=100% cellpadding="4" cellspacing=0>
  <tr>
      <Th align="left" bgcolor="4F8EA4" class="style2">Student</Th>
      <th align="left" bgcolor="4F8EA4" class="style2">Sex</th>
      <th align="left" bgcolor="4F8EA4" class="style2">Country</th>
      <th align="left" bgcolor="4F8EA4" class="style2">Req. Placement</th>
	  <th align="left" bgcolor="4F8EA4" class="style2">Agent</th>
	  <th align="left" bgcolor="4F8EA4" class="style2">Option</th>
    </tr>	

	 <img src="../../pics/black_pixel.gif" width="100%" height="2">
				

		
<!----			<div align="center">	<font size="2" face="Verdana, Arial, Helvetica, sans-serif">Please select report criteria and click on generate report. <br /> </font></div			><br />---->

			  <cfif get_students.recordcount eq 0 AND get_students_self.recordcount eq 0 >
			<tr><td align="center" colspan=10> <div align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">No students found based on the criteria you specified. Please change and re-run the report.</font></div><br />
</td></tr>
			  <cfelse>  
				<cfset into = 1 >
				<cfloop query="get_students">
				 <tr <cfif into mod 2>bgcolor="##E4E4E4"</cfif>>
					<td class="style1">#firstname# #lastname# (#candidateid#)</td>
					<td class="style1">#sex#</td>
					<td class="style1">#countryname#</td>
					<td class="style1">#name#</td>
					<td class="style1">#businessname#</td>
					<td class="style1">#wat_placement#</td>
				  </tr>
				  <cfset into = into + 1 >
				</cfloop>
				
				<cfloop query="get_students_self">
				 <tr <cfif into mod 2>bgcolor="##E4E4E4"</cfif>>
					<td class="style1">#firstname# #lastname# (#candidateid#)</td>
					<td class="style1">#sex#</td>
					<td class="style1">#countryname#</td>
					<td class="style1">#name#</td>
					<td class="style1">#businessname#</td>
					<td class="style1">#wat_placement#</td>
				  </tr>		
				  <cfset into = into + 1 >	  
				</cfloop>
				
			  </table>
			  <img src="../../pics/black_pixel.gif" alt="." width="100%" height="2"> <Br>
			  <br>
			  <span class="style1">Report Prepared on #DateFormat(now(), 'dddd, mmm, d, yyyy')#</span>
			  </cfif>
			  
		</cfif>
<cfelse>
<div align="center" class="style1">Print resutls will replace the menu options and take a bit longer to generate.<br /> Onscreen will allow you to change criteria with out clicking your back button.</div>
</cfif>
	
</cfoutput>