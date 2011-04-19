

<cfquery name="get_students" datasource="mysql">
SELECT firstname, lastname, sex, home_country, intrep, requested_placement, extra_candidates.programid, smg_programs.programname, smg_users.companyid, smg_users.businessname
FROM extra_candidates
INNER JOIN smg_users ON smg_users.userid = extra_candidates.intrep
INNER JOIN smg_programs ON smg_programs.programid = extra_candidates.programid
WHERE 
</cfquery>

<cfoutput query="get_students">



<form action="index.cfm?curdoc=reports/unplaced_students" method="post">
<table width="95%" cellpadding="4" cellspacing="0" border="0" align="center">
  <tr valign="middle" height="24">
    <td valign="middle" bgcolor="##E4E4E4" class="title1" colspan=2><font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp;Unplaced Students</font></td>

  </tr>


  	
  <tr valign="middle">
    <td align="right" valign="middle" class="title1"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Host Company: </td>
	
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
       
         
            <select name="companyid">
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
		<meta http-equiv="refresh" content="1;url=index.cfm?curdoc=reports/unplaced_students_wt_flashpaper&program=#form.program#&companyid=#form.companyid#">
		
	<cfelse>
<strong>Number of Candidates: #get_students.recordcount# </strong> 

					
  <table width=100% cellpadding="4" cellspacing=0>
    <tr>
      <Th align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" >Student</font></Th>
      <th align="left" ><font size="2" face="Verdana, Arial, Helvetica, sans-serif" >Sex</font></th>
      <th align="left" ><font size="2" face="Verdana, Arial, Helvetica, sans-serif" >Country</font></th>
      <th align="left" ><font size="2" face="Verdana, Arial, Helvetica, sans-serif" >Intl. Rep.</font></th>
      <th align="left" ><font size="2" face="Verdana, Arial, Helvetica, sans-serif" >Requested Placement </font></th>
    </tr>
 
				
				
			 <cfif NOT IsDefined('form.companyid') >
			<div align="center">	<font size="2" face="Verdana, Arial, Helvetica, sans-serif">Please select report criteria and click on generate report. <br /> </font></div			><br />

			  <cfelseif get_students.recordcount eq 0 >
			<tr><td align="center" colspan=10> <div align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">No students found based on the criteria you specified. Please change and re-run the report.</font></div><br />
</td></tr>
			  <cfelse>
			  
			  

				<cfloop query="get_students">
				<tr <cfif get_students.currentrow mod 2>bgcolor="##E4E4E4"</cfif>>
		
				  <tr >
					<td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#firstname# #lastname#</font></td>
					<td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#sex#</font></td>
					<td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#countryname#</font></td>
					<td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#businessname#</font></td>
					<td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#requested_placement#</font></td>
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