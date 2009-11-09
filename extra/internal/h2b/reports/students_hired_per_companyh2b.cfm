
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
</cfif>

<cfoutput>
<!----
<cfdocument format="FlashPaper" orientation="landscape" backgroundvisible="yes" overwrite="no" fontembed="yes">
---->
<!----<cfif students_hired.recordcount eq 0>
<div align = "center">
	Based on your criteria, no results were returned.
</div>
<cfelse> ---->
<!----<Table width=100%>
	<tr>
		<td>
		Report: Students hired per company<br />
		Company: #students_hired.businessname#<br>
		Program: #students_hired.programname#<br>
		<font size=-2> #DateFormat(now(), 'mmm. d, yyyy')# at #TimeFormat(now(), 'h:mm t')# MST</font>
		
		</td>
		<td align="right">
		<img src="http://dev.student-management.com/extra/images/extra-logo.jpg" width=50 height=65>		
		</td>
</Table>--->

<form action="index.cfm?curdoc=reports/students_hired_per_companyh2b" method="post">
<table width="95%" cellpadding="4" cellspacing="0" border="0" align="center">
  <tr valign="middle" height="24">
    <td valign="middle" bgcolor="##E4E4E4" class="title1" colspan=2><font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp;Students hired per company</font></td>

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
		<meta http-equiv="refresh" content="1;url=index.cfm?curdoc=reports/students_hired_per_companyh2bflashpaper&program=#form.program#&companyid=#form.companyid#">
		
	<cfelseif form.print eq 0>
				<br>
				
			<cfloop query="students_hired">	
				<table width=100% cellpadding="4" cellspacing=0> 
					<tr>
					<Th align="left" bgcolor="##4F8EA4"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="##FFFFFF">Student</font></Th>
					<th align="left" bgcolor="##4F8EA4"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="##FFFFFF">Sex</font></th>
					<th align="left" bgcolor="##4F8EA4"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="##FFFFFF">Country</font></th>
					<th align="left" bgcolor="##4F8EA4"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="##FFFFFF">Email</font></th>
					<th align="left" bgcolor="##4F8EA4"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="##FFFFFF">SSN</font></th>
					<th align="left" bgcolor="##4F8EA4"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="##FFFFFF">Passport</font></th>
					<th align="left" bgcolor="##4F8EA4"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="##FFFFFF">Passport dates </font></th>
					<th align="left" bgcolor="##4F8EA4"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="##FFFFFF">International Agent</font></th>
					</tr>
				
					<tr <cfif students_hired.currentrow mod 2>bgcolor="##E4E4E4"</cfif>>
						<td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#firstname# #lastname#</font></td>
						<td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#sex#</font></td>
						<td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#countryname#</font></td>
						<td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#email#</font></td>
						<td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#ssn#</font></td>
						<td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#passport_number#</font></td>
						<td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#dateformat (passport_date, 'mm/dd/yyyy')# #dateformat (passport_expires, 'mm/dd/yyyy')#</font></td>
						<td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#businessname#</font></td>
					</tr>
				</cfloop>
					</table>
				
				
			 <cfif NOT IsDefined('form.companyid') >
			<div align="center">	<font size="2" face="Verdana, Arial, Helvetica, sans-serif">Please select report criteria and click on generate report. <br /> </font></div			><br />

			  <cfelseif students_hired.recordcount eq 0 >
			<tr><td align="center" colspan=10> <div align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">No students found based on the criteria you specified. Please change and re-run the report.</font></div><br />
</td></tr>
			
			
			
			 </cfif>
			  
	
<cfelse>
<div align="center">Print resutls will replace the menu options and take a bit longer to generate.<br /> Onscreen will allow you to change criteria with out clicking your back button.
</cfif> 
</cfif>


</cfoutput>