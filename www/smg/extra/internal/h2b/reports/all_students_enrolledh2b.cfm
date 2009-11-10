
<cfif IsDefined('form.companyid')>
<cfquery name="get_candidates" datasource="MySql">
  SELECT extra_candidates.firstname, extra_candidates.lastname, extra_candidates.placedby, extra_candidates.sex, extra_candidates.hostcompanyid, extra_hostcompany.name, smg_programs.startdate, smg_programs.enddate, extra_candidates.ds2019, extra_candidates.programid, extra_candidates.companyid
  FROM extra_candidates
  INNER JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = extra_candidates.hostcompanyid
  INNER JOIN smg_programs ON smg_programs.programid = extra_candidates.programid
  INNER JOIN smg_users ON smg_users.userid = extra_candidates.intrep
  WHERE extra_candidates.companyid = #client.companyid#

 AND extra_candidates.intrep = #form.companyid#  
 AND extra_candidates.programid = #form.program#


</cfquery>
</cfif>

<!---
<cfif IsDefined('form.companyid')>
<cfquery name="students_hired" datasource="mysql">
select c.firstname, c.candidateid,c.lastname, c.sex, c.home_country,c.email, c.earliestarrival, c.programid, c.intrep, c.ssn, c.passport_date, c.passport_expires, c.passport_number,
p.programname, 
u.businessname,
smg_countrylist.countryname
from extra_candidates c

LEFT JOIN smg_programs p on p.programid = c.programid
LEFT JOIN smg_users u on u.userid = c.intrep
LEFT JOIN smg_countrylist on smg_countrylist.countryid = c.home_country
<!----
where c.hostcompanyid = #form.hostcompany#
and c.programid = #form.program# ---->
  WHERE c.companyid = #client.companyid#
  AND c.hostcompanyid = #form.companyid# 
  and c.programid = #form.program#
  
</cfquery> 
</cfif>--->


<cfoutput>
<form action="index.cfm?curdoc=reports/all_students_enrolledh2b" method="post">
<table width="95%" cellpadding="4" cellspacing="0" border="0" align="center">
  <tr valign="middle" height="24">
    <td valign="middle" bgcolor="##E4E4E4" class="title1" colspan=2><font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp;Students enrolled </font></td>

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
		<meta http-equiv="refresh" content="1;url=index.cfm?curdoc=reports/all_students_enrolledh2bflashpaper&program=#form.program#&companyid=#form.companyid#">
		
	<cfelse>
<strong>Number of Candidates: #get_candidates.recordcount# </strong> 

				
   <table border="0" cellpadding="4" cellspacing="0" class="section" align="center" width="95%">
  <tr>
    <th width="315" align="left"  bgcolor="4F8EA4"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="FFFFFF">Student</font></span></th>
    <th width="348" align="left" bgcolor="4F8EA4"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="FFFFFF">Sex </font></span></th>
    <th width="262" align="left"  bgcolor="4F8EA4"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="FFFFFF">Self</font></span></th>
    <th width="262" align="left"  bgcolor="4F8EA4"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="FFFFFF">Lenght</font></span></th>
    <th width="262" align="left"  bgcolor="4F8EA4"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="FFFFFF">Placement Information</font></span></th>
    <th width="262" align="left"  bgcolor="4F8EA4"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="FFFFFF">DS2019</font></span></th>
  </tr>
 
 	 <cfloop query="get_candidates">
				<tr>
				  <th align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#firstname# #lastname#</font></th>
				  <th align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#sex#</font></th>
				  <th align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><cfif placedby eq 'self'>X<cfelse> </cfif></font></th>
				  <th align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"> #DateDiff('ww', startdate, enddate)# weeks</font></th>
				  <th align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#name#</font></th>
				  <th align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#ds2019#</font></th>
				</tr>
			  </cfloop>
			</table>  
				
			 <cfif NOT IsDefined('form.companyid') >
			<div align="center">	<font size="2" face="Verdana, Arial, Helvetica, sans-serif">Please select report criteria and click on generate report. <br /> </font></div><br />

			  <cfelseif get_candidates.recordcount eq 0 >
			<tr><td align="center" colspan=10> <div align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">No students found based on the criteria you specified. Please change and re-run the report.</font></div><br />
</td></tr>
			  <cfelse>
			  
		<!--- resultados campos da tabela --->


			  </cfif>
			  
		</cfif>
<cfelse>
<div align="center">Print resutls will replace the menu options and take a bit longer to generate.<br /> Onscreen will allow you to change criteria with out clicking your back button.
</cfif>
    
</cfoutput>

</body>
</html>
