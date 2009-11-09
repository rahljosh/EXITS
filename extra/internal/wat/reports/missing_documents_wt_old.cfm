<cfif IsDefined('form.program')>
 <cfquery name="get_students" datasource="mysql">
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
	ORDER BY smg_users.businessname, c.firstname	
 </cfquery>
 
 
 <cfquery name="get_wat_placement" datasource="mysql">
	SELECT c.wat_placement, count(c.wat_placement) AS total
	FROM extra_candidates c
    WHERE c.programid = #form.program#
	AND (c.wat_doc_agreement = 0 OR c.wat_doc_college_letter = 0 OR
	     c.wat_doc_passport_copy = 0 OR c.wat_doc_job_offer = 0 OR c.wat_doc_orientation = 0)
	AND c.active = 1
	GROUP BY wat_placement
</cfquery>
</cfif>


<cfoutput >


<form action="index.cfm?curdoc=reports/missing_documents_wt" method="post">
<table width="95%" cellpadding="4" cellspacing="0" border="0" align="center">
  <tr valign="middle" height="24">
    <td valign="middle" bgcolor="##E4E4E4" class="title1" colspan=2><font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp;Missing Documents Report</font></td>

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
      </font>
       
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
    <td valign="middle" align="right" class="title1"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Program: </font></td><td> <select name="program">
		<option></option>
	<cfloop query="get_program">
	<option value=#programid# <cfif IsDefined('form.program')><cfif get_program.programid eq #form.program#> selected</cfif></cfif>>#programname#</option>
	</cfloop>
	
	 </td>
  
  </tr>

  <Tr>
  	<td align="right" class="title1"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Format: </font></td><td> <input type="radio" name="print" value=0 checked>  Onscreen (View Only) <input type="radio" name="print" value=1> Print (FlashPaper) 
  </Tr>
  <tr>
  	<td colspan=2 align="center"><input type="submit" value="Generate Report" /></td>
  </tr>
</table>


<br>




<!-----Display Reports---->

<cfif isDefined('form.print')>
	<cfif form.print eq 1>
		Results are being generated...		
		<meta http-equiv="refresh" content="1;url=index.cfm?curdoc=reports/missing_documents_wt_flashpaper&program=#form.program#">
		

		
	<cfelse>


<cfloop query="get_wat_placement">
<strong><font size="2" face="Verdana, Arial, Helvetica, sans-serif" ><cfif wat_placement is ''> Unclassified<cfelse>#wat_placement#</cfif>: #total# </font></strong>
<br />


</cfloop>
		
<strong><font size="2" face="Verdana, Arial, Helvetica, sans-serif" >Total Number of Students: #get_students.recordcount# </font></strong><br />


<img src="../../pics/black_pixel.gif" width="100%" height="2">
					
  <table width=100% cellpadding="4" cellspacing=0>
    <tr>
      <th align="left" ><font size="2" face="Verdana, Arial, Helvetica, sans-serif" >Agent</font></th>	 
      <Th align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" >Student</font></Th>
      <th align="left" ><font size="2" face="Verdana, Arial, Helvetica, sans-serif" >Missing<font color="FFFFFF">_</font>Documents</font></th>
   <th align="left" ><font size="2" face="Verdana, Arial, Helvetica, sans-serif" >Placement Information</font></th>  
      <th align="left" ><font size="2" face="Verdana, Arial, Helvetica, sans-serif" >Option</font></th>	  	
	
    </tr>
	 <img src="../../pics/black_pixel.gif" width="100%" height="2">
				

		
<!----			<div align="center">	<font size="2" face="Verdana, Arial, Helvetica, sans-serif">Please select report criteria and click on generate report. <br /> </font></div			><br />---->

			  <cfif get_students.recordcount eq 0 >
			<tr><td align="center" colspan=10> <div align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">No students found based on the criteria you specified. Please change and re-run the report.</font></div><br />
</td></tr>
			  <cfelse>
			  
			  

				<cfloop query="get_students">
			
	
				  <tr <cfif get_students.currentrow mod 2>bgcolor="##E4E4E4"</cfif>>
					<td valign="top"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#businessname#</font></td>
					<td valign="top"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#firstname# #lastname# (#candidateid#)</font></td>
					<td valign="top"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">
					<cfif get_students.wat_doc_agreement EQ 0>Agreement.<br /></cfif>
					<cfif get_students.wat_doc_college_letter EQ 0>College Letter.<br /></cfif>
					<cfif get_students.wat_doc_passport_copy EQ 0>Passport Copy.<br /></cfif>
					<cfif get_students.wat_doc_job_offer EQ 0>Job Offer.<br /></cfif>
					<cfif get_students.wat_doc_orientation EQ 0>Orientation Sign Off.</cfif>
					</font></td>
					
<td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#companyname#</font></td>
					<td><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><cfif wat_placement is ''><font color="FF0000">Unclassified</font><cfelse>#wat_placement#</cfif></font></td>
					

				  </tr>
				</cfloop>
			  </table>
			  <img src="../../pics/black_pixel.gif" alt="." width="100%" height="2"> <Br>
			  <br>
			  <font size=-1>Report Prepared on #DateFormat(now(), 'dddd, mmm, d, yyyy')#</font> 
			  </cfif>
			  
		</cfif>
<cfelse>
<div align="center">Print resutls will replace the menu options and take a bit longer to generate.<br /> Onscreen will allow you to change criteria with out clicking your back button.
</cfif>
    
	
	
</cfoutput>