<cfif IsDefined('form.program')>
	<cfquery name="get_students" datasource="mysql">
	SELECT c.candidateid, c.firstname, c.lastname, c.dob, c.citizen_country, c.ds2019, c.companyid, c.hostcompanyid, smg_countrylist.countryname, extra_hostcompany.name, c.home_address cadress, extra_hostcompany.address, smg_countrylist.countryname, c.wat_participation, extra_hostcompany.address as hostcompany_address, extra_hostcompany.city as hostcompany_city, extra_hostcompany.state, extra_hostcompany.zip as hostcompany_zip, smg_states.state as hostcompany_state, c.status
	FROM extra_candidates c
	INNER JOIN smg_programs ON smg_programs.programid = c.programid
	INNER JOIN smg_countrylist ON smg_countrylist.countryid = c.citizen_country
	LEFT JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = c.hostcompanyid
	LEFT JOIN smg_states ON smg_states.id = extra_hostcompany.state
		<!--- form parameters --->
	  WHERE c.companyid = 8
	  AND c.status <> 'canceled'
      AND c.ds2019 <> ''
	  AND c.programid = #form.program#
	  ORDER BY c.ds2019
	</cfquery>
</cfif>


<cfoutput >

<!-----
<cfquery name="get_candidates_self" datasource="MySql">
  SELECT extra_candidates.firstname, extra_candidates.lastname, extra_candidates.placedby, extra_candidates.sex, extra_candidates.hostcompanyid, extra_hostcompany.name, smg_programs.startdate, smg_programs.enddate, extra_candidates.ds2019, extra_candidates.wat_vacation_start, extra_candidates.wat_vacation_end
  FROM extra_candidates
  INNER JOIN smg_programs ON smg_programs.programid = extra_candidates.programid
	INNER JOIN smg_countrylist ON smg_countrylist.countryid = extra_candidates.citizen_country
	LEFT JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = extra_candidates.hostcompanyid
 WHERE extra_candidates.companyid = 8 AND wat_placement = 'self'
</cfquery>
------>

<form action="index.cfm?curdoc=reports/list_students_work_study_wt" method="post">
<table width="95%" cellpadding="4" cellspacing="0" border="0" align="center">
  <tr valign="middle" height="24">
    <td valign="middle" bgcolor="##E4E4E4" class="title1" colspan=2><font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp;List of Students (Work Study)</font></td>

  </tr>


  	
  <tr valign="middle">
  <td align="right" valign="middle" class="title1"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><!---Host Company:---> </td>
	
	<td valign="middle">  
      <script language="JavaScript" type="text/javascript"> 
		<!-- Begin
		function formHandler2(form){
		var URL = document.formagent.agent.options[document.formagent.agent.selectedIndex].value;
		window.location.href = URL;
		}
		// End -->
    </script>
        </font>
    
        </td>


  </tr>
    <tr>
  <!----  <cfquery name="get_program" datasource="MySql">
		SELECT programname, programid
		FROM smg_programs 
		where companyid = #client.companyid#
    </cfquery>---->
    <td valign="middle" align="right" class="title1"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><!---Program:---> </font></td><td> <!----<select name="program">
		<option></option>
	<cfloop query="get_program">
	<option value=#programid# <cfif IsDefined('form.program')><cfif get_program.programid eq #form.program#> selected</cfif></cfif>>#programname#</option>
	</cfloop>---->
	
	 </td>
  
  </tr>
<tr>
    <cfquery name="get_program" datasource="MySql">
	SELECT programname, programid
	FROM smg_programs 
	where companyid = #client.companyid#
    </cfquery>
    <td valign="middle" align="right" class="style1"><b>Program:</b></td>
	<td class="style1"> 
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
	<td class="style1"> <input type="radio" name="print" value=0 checked>  Onscreen (View Only) <input type="radio" name="print" value=1> Print (FlashPaper) <input type="radio" name="print" value=2> Print (PDF)</font>
  </Tr>
  <tr>
  	<td colspan=2 align="center"><br />
<br />
<input type="submit" class="style1" value="Generate Report" /><br />
</td>
  </tr>
</table>


<br>




<!-----Display Reports---->

<cfif isDefined('form.print')>
	<cfif form.print eq 1>
		<span class="style1"><center><b>Results are being generated...</b></center></span><br /><br /><br />	
		<meta http-equiv="refresh" content="1;url=index.cfm?curdoc=reports/list_students_work_study_wt_flashpaper&format=FlashPaper&program=#form.program#">
		<cfelseif form.print eq 2>
		<meta http-equiv="refresh" content="1;url=index.cfm?curdoc=reports/list_students_work_study_wt_flashpaper&format=PDF&program=#form.program#">
	<cfelse>
<strong><font size="2" face="Verdana, Arial, Helvetica, sans-serif" >Total Number of Students: #get_students.recordcount# </font></strong> 

<!----<div class="head3">  <strong><font size="2" face="Verdana, Arial, Helvetica, sans-serif"> Self-Placement:</strong> #get_candidates_self.recordcount#</font></div>
<div class="head3">  <strong><font size="2" face="Verdana, Arial, Helvetica, sans-serif"> CSB-Placement:</strong> #get_students.recordcount#</font></div>-------->

<img src="../../pics/black_pixel.gif" width="100%" height="2">
					
  <table width=100% cellpadding="4" cellspacing=0>
    <tr>
      <Th align="left" bgcolor="4F8EA4" class="style2">Student Name</Th>
      <th align="left" bgcolor="4F8EA4" class="style2">Date of Birth</th>
      <th align="left" bgcolor="4F8EA4" class="style2">Citizenship</th>
      <th align="left" bgcolor="4F8EA4" class="style2">DS2019</th>
	  <th align="left" bgcolor="4F8EA4" class="style2">No. Part.</th>
	  <th align="left" bgcolor="4F8EA4" class="style2">Company</th>
	  <th align="left" bgcolor="4F8EA4" class="style2">Address</th>
    </tr>
	 <img src="../../pics/black_pixel.gif" width="100%" height="2">
				

		
<!----			<div align="center">	<font size="2" face="Verdana, Arial, Helvetica, sans-serif">Please select report criteria and click on generate report. <br /> </font></div			><br />---->

			  <cfif get_students.recordcount eq 0 >
			<tr><td align="center" colspan=10> <div align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">No students found based on the criteria you specified. Please change and re-run the report.</font></div><br />
</td></tr>
			  <cfelse>
			  
			  

				<cfloop query="get_students">
			
	
				  <tr <cfif get_students.currentrow mod 2>bgcolor="E4E4E4"</cfif>>
					<td class="style1">#firstname# #lastname# (#candidateid#)</td>
					<td class="style1">#DateFormat(dob, 'mm/dd/yyyy')#</td>
					<td class="style1">#countryname#</td>
					<td class="style1">#ds2019#</td>
					<td class="style1"><cfif #wat_participation# eq ''>0<cfelse>#wat_participation#</cfif></td>
					<td class="style1">#name#</td>
					<td class="style1"><cfif hostcompany_address NEQ ''>#hostcompany_address#, #hostcompany_city#, #hostcompany_state# - #hostcompany_zip# </cfif></td>															
				  </tr>
				</cfloop>
			  </table>
			  <img src="../../pics/black_pixel.gif" alt="." width="100%" height="2"> <Br>
			  <br>
			  <font size=-1>Report Prepared on #DateFormat(now(), 'dddd, mmm, d, yyyy')#</font> 
			  </cfif>
			  
		</cfif>
<cfelse>
<span class="style1"><center>Print resutls will replace the menu options and take a bit longer to generate.<br /> Onscreen will allow you to change criteria with out clicking your back button.</center></span>
</cfif>
    
	
	
</cfoutput>