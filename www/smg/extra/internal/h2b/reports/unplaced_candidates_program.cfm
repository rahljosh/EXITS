<cfif IsDefined('form.program')>
	<cfquery name="get_students" datasource="mysql">
	SELECT c.firstname, c.lastname, c.candidateid, c.sex, c.home_country, c.intrep, c.requested_placement, c.programid, smg_programs.programname, smg_users.companyid, smg_users.businessname, c.companyid, c.hostcompanyid, smg_countrylist.countryname, extra_hostcompany.name, c.requested_placement
	FROM extra_candidates c
	INNER JOIN smg_users ON smg_users.userid = c.intrep
	INNER JOIN smg_programs ON smg_programs.programid = c.programid
	INNER JOIN smg_countrylist ON smg_countrylist.countryid = c.home_country
	LEFT JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = c.requested_placement 
		<!--- form parameters --->
	  WHERE c.companyid = #client.companyid#
	  AND c.hostcompanyid = 0<!---#form.companyid# --->
	  AND c.programid = #form.program#
	 

	  <!----AND c.requested_placement is null ---->
	</cfquery>
</cfif>


<cfoutput >



<form action="index.cfm?curdoc=reports/unplaced_candidates_program" method="post">
<table width="95%" cellpadding="4" cellspacing="0" border="0" align="center">
  <tr valign="middle" height="24">
    <td valign="middle" bgcolor="##E4E4E4" class="title1" colspan=2><font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp;Unplaced candidates per Program</font></td>

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
		<meta http-equiv="refresh" content="1;url=index.cfm?curdoc=reports/unplaced_candidates_programflashpaper&program=#form.program#">
		
	<cfelse>
<!----
<cfquery name="get_wat_placement" datasource="mysql">
	SELECT wat_placement, count(wat_placement) AS total
	FROM extra_candidates
	WHERE active = 1 
	AND companyid = 8
	AND hostcompanyid = 0
	GROUP BY wat_placement
</cfquery>

<cfloop query="get_wat_placement">
<strong><font size="2" face="Verdana, Arial, Helvetica, sans-serif" >Students #wat_placement#:  #total# </font></strong>
<br />
</cfloop>---->
<strong><font size="2" face="Verdana, Arial, Helvetica, sans-serif" >Total of Students: #get_students.recordcount# </font></strong>


<img src="../../pics/black_pixel.gif" width="100%" height="2">
					
  <Table width=100% frame=below cellpadding=7 cellspacing="0" class="thin-border-bottom" >
				<tr class="thin-border-bottom" >
				  
      <Th align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" >Candidate</font></Th>
      <th align="left" ><font size="2" face="Verdana, Arial, Helvetica, sans-serif" >Sex</font></th>
      <th align="left" ><font size="2" face="Verdana, Arial, Helvetica, sans-serif" >Country</font></th>
      <th align="left" ><font size="2" face="Verdana, Arial, Helvetica, sans-serif" >Req. Placement </font></th>
      <th align="left" ><font size="2" face="Verdana, Arial, Helvetica, sans-serif" >Agent</font></th>
    </tr>
	 <img src="../../pics/black_pixel.gif" width="100%" height="2">
				

		
<!----			<div align="center">	<font size="2" face="Verdana, Arial, Helvetica, sans-serif">Please select report criteria and click on generate report. <br /> </font></div			><br />---->

			  <cfif get_students.recordcount eq 0 >
			<tr><td align="center" colspan=10> <div align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">No students found based on the criteria you specified. Please change and re-run the report.</font></div><br />
</td></tr>
			  <cfelse>
			  
			  

				<cfloop query="get_students">
				<tr bgcolor="#iif(get_students.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
		
	
				 
					<td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#firstname# #lastname# (#candidateid#) <!----#hostcompanyid#---></font></td>
					<td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#sex#</font></td>
					<td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#countryname#</font></td>
					<td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#name#</font></td>
					<td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#businessname#</font></td>
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