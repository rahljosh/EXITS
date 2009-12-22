<cfif IsDefined('form.program')>
 <cfquery name="get_candidates_into" datasource="mysql">
	SELECT c.firstname, c.lastname, c.candidateid, c.wat_doc_agreement, c.wat_doc_college_letter, c.wat_doc_passport_copy,
	c.wat_doc_job_offer, c.wat_doc_orientation, smg_users.companyid, smg_users.businessname, c.wat_placement,
	extra_hostcompany.name as companyname
	FROM extra_candidates c
	INNER JOIN smg_programs ON smg_programs.programid = c.programid
	INNER JOIN smg_users ON smg_users.userid = c.intrep
	LEFT JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = c.hostcompanyid
    WHERE c.programid = #form.program#
	AND (c.wat_doc_agreement = 0 OR c.wat_doc_college_letter = 0 OR
	     c.wat_doc_passport_copy = 0 OR c.wat_doc_job_offer = 0 OR c.wat_doc_orientation = 0)
	AND c.active = 1
	AND c.wat_placement = 'CSB-Placement'
	ORDER BY smg_users.businessname, c.firstname	
 </cfquery>
 <cfquery name="get_candidates_self" datasource="mysql">
	SELECT c.firstname, c.lastname, c.candidateid, c.wat_doc_agreement, c.wat_doc_college_letter, c.wat_doc_passport_copy,
	c.wat_doc_job_offer, c.wat_doc_orientation, smg_users.companyid, smg_users.businessname, c.wat_placement,
	extra_hostcompany.name as companyname
	FROM extra_candidates c
	INNER JOIN smg_programs ON smg_programs.programid = c.programid
	INNER JOIN smg_users ON smg_users.userid = c.intrep
	LEFT JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = c.hostcompanyid
    WHERE c.programid = #form.program#
	AND (c.wat_doc_agreement = 0 OR c.wat_doc_college_letter = 0 OR
	     c.wat_doc_passport_copy = 0 OR c.wat_doc_job_offer = 0 OR c.wat_doc_orientation = 0)
	AND c.active = 1
	AND c.wat_placement = 'Self-Placement'
	ORDER BY smg_users.businessname, c.firstname	
 </cfquery>
 
 
<!--- <cfquery name="get_wat_placement" datasource="mysql">
	SELECT c.wat_placement, count(c.wat_placement) AS total
	FROM extra_candidates c
    WHERE c.programid = #form.program#
	AND (c.wat_doc_agreement = 0 OR c.wat_doc_college_letter = 0 OR
	     c.wat_doc_passport_copy = 0 OR c.wat_doc_job_offer = 0 OR c.wat_doc_orientation = 0)
	AND c.active = 1
	GROUP BY wat_placement
</cfquery> --->
</cfif>


<cfoutput >


<form action="index.cfm?curdoc=reports/missing_documents_wt" method="post">
<table width="95%" cellpadding="4" cellspacing="0" border="0" align="center">
  <tr valign="middle" height="24">
    <td valign="middle" bgcolor="##E4E4E4" class="title1" colspan=2>&nbsp;Missing Documents Report</td>

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
       <!----   <cfquery name="get_host_company" datasource="MySql">
			SELECT name, hostcompanyid
            FROM extra_hostcompany
			WHERE active = 1 
			Order by name
        </cfquery>---->
      
       
         <!---
            <select name="companyid">
			<option></option>
            <cfloop query="get_host_company">
              <option value="#hostcompanyid#" <cfif IsDefined('form.companyid')><cfif get_host_company.hostcompanyid eq #form.companyid#> selected</cfif></cfif>> #get_host_company.name# </option>
            </cfloop>
          </select>---->
         
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
	<td> <select name="program" class="style1">
		<option></option>
	<cfloop query="get_program">
	<option value=#programid# <cfif IsDefined('form.program')><cfif get_program.programid eq #form.program#> selected</cfif></cfif>>#programname#</option>
	</cfloop>
	</select>
	
	 </td>
  
  </tr>

  <Tr>
  	<td align="right"  class="style1"><b>Format: </b></td>
	<td class="style1"> <input type="radio"  name="print" value=0 checked>  Onscreen (View Only) <input type="radio" name="print" value=1> Print (FlashPaper) 
  </Tr>
  <tr>
  	<td colspan=2 align="center"><br />
<input type="submit"  class="style1" value="Generate Report" /></td>
  </tr>
</table>


<br>




<!-----Display Reports---->

<cfif isDefined('form.print')>
	<cfif form.print eq 1>
		<center><span class="style1"><b>Results are being generated...</b></span></center>
		<meta http-equiv="refresh" content="1;url=index.cfm?curdoc=reports/missing_documents_wt_flashpaper&program=#form.program#">
		

		
	<cfelse>


<!--- <cfloop query="get_wat_placement">
<strong><font size="2" face="Verdana, Arial, Helvetica, sans-serif" ><cfif wat_placement is ''> Unclassified<cfelse>#wat_placement#</cfif>: #total# </font></strong>
<br />
</cfloop> --->
<cfset total = #get_candidates_self.recordcount# + #get_candidates_into.recordcount#>

<div class="style1"><strong>&nbsp; &nbsp; CSB-Placement:</strong> #get_candidates_into.recordcount#</div>	
<div class="style1"><strong>&nbsp; &nbsp; Self-Placement:</strong> #get_candidates_self.recordcount#</div>
<div class="style1"><strong>&nbsp; &nbsp; ----------------------------------</strong></div>
<div class="style1"><strong>&nbsp; &nbsp; Total Number Students:</strong> #total#</div>
<div class="style1"><strong>&nbsp; &nbsp; ----------------------------------</strong></div>		


<img src="../../pics/black_pixel.gif" width="100%" height="2">
					
  <table width=99% cellpadding="4" align="center" cellspacing=0>
    <tr bgcolor="##FFFFCC">
      	<td align="left" class="style1"><strong>Agent</strong></td>	 
     	<td align="left" class="style1"><strong>Student</strong></td>
		<td align="left" class="style1"><strong>Placement Information</strong></td>  
   		<td align="left" class="style1" width="130"><strong>Missing Documents</strong></td>	  
      	<td align="left" class="style1"><strong>Option</strong></td>	  	
	</tr>

	 <img src="../../pics/black_pixel.gif" width="100%" height="2">
				

		
<!----			<div align="center">	<font size="2" face="Verdana, Arial, Helvetica, sans-serif">Please select report criteria and click on generate report. <br /> </font></div			><br />---->

			  <cfif get_candidates_into.recordcount eq 0 AND get_candidates_self.recordcount eq 0 >
			<tr><td align="center" colspan=10 class="style1"> <div align="center">No students found based on the criteria you specified. Please change and re-run the report.</div><br />
</td></tr>
			  <cfelse>

				<cfloop query="get_candidates_into">
				 <tr <cfif get_candidates_into.currentrow mod 2>bgcolor="##E4E4E4"</cfif>>
					<td valign="top" class="style1">#businessname#</td>
					<td valign="top" class="style1">#firstname# #lastname# (#candidateid#)</td>		
					<td valign="top" class="style1">#companyname#</td>
					<td valign="top" class="style1">
						<cfif get_candidates_into.wat_doc_agreement EQ 0><font color="##CC0000">- Agreement<br /></cfif>
							<cfif get_candidates_into.wat_doc_college_letter EQ 0><font color="##CC0000">- College Letter<br /></cfif>
							<cfif get_candidates_into.wat_doc_passport_copy EQ 0><font color="##CC0000">- Passport Copy<br /></cfif>
							<cfif get_candidates_into.wat_doc_job_offer EQ 0><font color="##CC0000">- Job Offer<br /></cfif>
							<cfif get_candidates_into.wat_doc_orientation EQ 0><font color="##CC0000">- Orientation Sign Off</cfif>
					</td>
					<td valign="top" class="style1">CSB-Placement</td>
				</tr>
				</cfloop>
				
				<cfloop query="get_candidates_self">
				 <tr <cfif get_candidates_self.currentrow mod 2>bgcolor="##E4E4E4"</cfif>>
					<td valign="top" class="style1">#businessname#</td>
					<td valign="top" class="style1">#firstname# #lastname# (#candidateid#)</td>		
					<td valign="top" class="style1">#companyname#</td>
					<td valign="top" class="style1">
						<cfif get_candidates_self.wat_doc_agreement EQ 0><font color="##CC0000">- Agreement<br /></cfif>
							<cfif get_candidates_self.wat_doc_college_letter EQ 0><font color="##CC0000">- College Letter<br /></cfif>
							<cfif get_candidates_self.wat_doc_passport_copy EQ 0><font color="##CC0000">- Passport Copy<br /></cfif>
							<cfif get_candidates_self.wat_doc_job_offer EQ 0><font color="##CC0000">- Job Offer<br /></cfif>
							<cfif get_candidates_self.wat_doc_orientation EQ 0><font color="##CC0000">- Orientation Sign Off</cfif>
					</td>
					<td valign="top" class="style1">Self-Placement</td>
				</tr>
				</cfloop>
				
			  </table>
			  <img src="../../pics/black_pixel.gif" alt="." width="100%" height="2"> <Br>
			  <br>
			  <span  class="style1">Report Prepared on #DateFormat(now(), 'dddd, mmm, d, yyyy')#</span> 
			  </cfif>
			  
		</cfif>
<cfelse>
<div align="center" class="style1">Print resutls will replace the menu options and take a bit longer to generate.<br /> Onscreen will allow you to change criteria with out clicking your back button.
</cfif>
    
	
	
</cfoutput>