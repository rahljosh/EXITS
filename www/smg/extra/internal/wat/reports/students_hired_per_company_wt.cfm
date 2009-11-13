<cfsetting requesttimeout="99999">
<cfoutput>

<form action="index.cfm?curdoc=reports/students_hired_per_company_wt" method="post">
<table width="95%" cellpadding="4" cellspacing="0" border="0" align="center">
  <tr valign="middle" height="24">
    <td valign="middle" bgcolor="##E4E4E4" class="title1" colspan=2>&nbsp;Students hired per company</td>
  </tr>
  <tr valign="middle" height="24">
    <td valign="middle" colspan=2>&nbsp;</td>
  </tr>

  <tr valign="middle">
    <td align="right" valign="middle" class="style1"><b>Host Company: </b></td>
	
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
			SELECT extra_hostcompany.hostcompanyid, extra_hostcompany.name, extra_hostcompany.phone, extra_hostcompany.supervisor, extra_hostcompany.city, extra_hostcompany.state, extra_hostcompany.business_typeid, extra_typebusiness.business_type as typebusiness, smg_states.state as s
			FROM extra_hostcompany
    		LEFT JOIN smg_states ON smg_states.id = extra_hostcompany.state
    		LEFT JOIN extra_typebusiness ON extra_typebusiness.business_typeid = extra_hostcompany.business_typeid
			WHERE companyid = #client.companyid#
			AND extra_hostcompany.name != ' '
			ORDER BY name
        </cfquery>
      </span>
       
         
            <select name="companyid" class="style1">
			<option></option>
			<option value="ALL">---  All Host Companies  ---</option>
            <cfloop query="get_host_company">
              <option value="#hostcompanyid#" <cfif IsDefined('form.companyid')><cfif get_host_company.hostcompanyid eq #form.companyid#> selected</cfif></cfif>> #get_host_company.name# </option>
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
    <td valign="middle" align="right" class="style1"><b>Program: </b></td><td>
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
	<td class="style1"> <input type="radio" class="style1" name="print" value=0 checked>  Onscreen (View Only) <input type="radio" name="print" value=1> Print (PDF)
  <input type="radio" name="print" value=2> Excel (XLS)
  </Tr>
  <tr>
  	<td colspan=2 align="center"><br />
	<br />
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
		<meta http-equiv="refresh" content="1;url=index.cfm?curdoc=reports/students_hired_per_company_wt_flashpaper&program=#form.program#&companyid=#form.companyid#&format=PDF">
	<cfelse>
	
	<cfif form.print eq 2>
		<span class="style1"><center><b>Results are being generated...</b></center></span><br /><br /><br />
		<meta http-equiv="refresh" content="1;url=index.cfm?curdoc=reports/students_hired_per_company_wt_excel&program=#form.program#&companyid=#form.companyid#">
	<cfelse>
	
<br />

<cfquery name="getHostCompany" datasource="MySQL">
SELECT hostcompanyid, name
FROM extra_hostcompany
WHERE hostcompanyid
IN
(
SELECT DISTINCT(hostcompanyid)
FROM extra_candidates
WHERE programid = #form.program#
AND status != 'canceled'
)
<cfif form.companyid NEQ 'ALL'>
	AND hostcompanyid = #form.companyid#
</cfif>
ORDER BY name
</cfquery>

<cfparam name="variables.intoPlacement" default="0">
<cfparam name="variables.selfPlacement" default="0">
<cfparam name="variables.grandTotal" default="0">

<cfloop query="getHostCompany">

	<cfquery name="students_hired" datasource="mysql">
		select c.firstname, c.candidateid,c.lastname, c.sex, c.home_country,c.email, c.earliestarrival, c.programid, c.intrep, c.ssn, c.passport_date, c.passport_expires, c.passport_number, c.wat_vacation_start, c.wat_vacation_end, c.startdate, c.enddate, c.wat_placement, c.status, extra_hostcompany.name,
		p.programname, c.ds2019, c.dob,
		u.businessname,
		smg_countrylist.countryname
		FROM extra_candidates c
		LEFT JOIN smg_programs p on p.programid = c.programid
		LEFT JOIN smg_users u on u.userid = c.intrep
		LEFT JOIN smg_countrylist on smg_countrylist.countryid = c.home_country
		LEFT JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = c.hostcompanyid
		WHERE c.companyid = #client.companyid#
		AND c.hostcompanyid = #getHostCompany.hostcompanyid# 
		AND c.programid = #form.program#
		AND c.wat_placement = 'INTO-Placement'
		AND c.status <> 'canceled'
	</cfquery> 
	
	<cfquery name="get_candidates_self" datasource="mysql">
		SELECT extra_candidates.firstname, extra_candidates.lastname, extra_candidates.candidateid, extra_candidates.home_country, extra_candidates.email, extra_candidates.placedby, extra_candidates.sex, extra_candidates.hostcompanyid, extra_hostcompany.name,  extra_candidates.ds2019, extra_candidates.wat_vacation_Start, extra_candidates.wat_vacation_end, extra_candidates.wat_placement, extra_candidates.startdate, extra_candidates.enddate,
			smg_countrylist.countryname, smg_users.businessname, extra_candidates.dob, extra_candidates.ssn
		FROM extra_candidates
		INNER JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = extra_candidates.hostcompanyid
		INNER JOIN smg_programs ON smg_programs.programid = extra_candidates.programid
		INNER JOIN smg_users ON smg_users.userid = extra_candidates.intrep
		LEFT JOIN smg_countrylist on smg_countrylist.countryid = extra_candidates.home_country
		WHERE extra_candidates.companyid = #client.companyid#
		AND extra_candidates.hostcompanyid = #getHostCompany.hostcompanyid#  
		AND extra_candidates.programid = #form.program#
		AND extra_candidates.wat_placement = 'Self-Placement'
		AND extra_candidates.status <> 'canceled'
	</cfquery>

	<cfset totalPerAgent = #students_hired.recordCount# + #get_candidates_self.recordCount#>
	<cfset intoPlacement = #variables.intoPlacement# + #students_hired.recordCount#>
	<cfset selfPlacement = #variables.selfPlacement# + #get_candidates_self.recordCount#>
	<cfset grandTotal = #variables.grandTotal# + #variables.totalPerAgent#>

	<table width=99% cellpadding="4" cellspacing=0 align="center"> 
		<tr>
			<td colspan="12">
			<small><strong>#getHostCompany.name# - Total Candidates: #variables.totalPerAgent#</strong> (#students_hired.recordCount# INTO; #get_candidates_self.recordCount# Self)</small>
			</td>
		</tr>
		<tr>
			<td align="left" bgcolor="4F8EA4" class="style2">ID</Td>
			<td align="left" bgcolor="4F8EA4" class="style2">Last Name</Td>
			<td align="left" bgcolor="4F8EA4" class="style2">First Name</Td>
			<td align="left" bgcolor="4F8EA4" class="style2">Sex</td>
			<td align="left" bgcolor="4F8EA4" class="style2">DOB</Td>
			<td align="left" bgcolor="4F8EA4" class="style2">Country</td>
			<td align="left" bgcolor="4F8EA4" class="style2">Email</td>
			<td align="left" bgcolor="4F8EA4" class="style2">SSN</Td>
			<td align="left" bgcolor="4F8EA4" class="style2">Start Date</td>
			<td align="left" bgcolor="4F8EA4" class="style2">End Date</td>
			<td align="left" bgcolor="4F8EA4" class="style2">International Agent</td>
			<td align="left" bgcolor="4F8EA4" class="style2">Option</td>
		</tr>
					
					
	<cfif NOT IsDefined('form.companyid') >
	<div align="center">	<span class="style1">Please select report criteria and click on generate report. <br /> </span></div			><br />
	
	<cfelseif students_hired.recordcount eq 0 AND get_candidates_self.recordcount eq 0 >
	<tr><td align="center" colspan=10> <div align="center"><span class="style1">No students found based on the criteria you specified. Please change and re-run the report.</span></div><br />
	</td></tr>
	<cfelse>
	
		<cfset into =  1 >
		
		<cfloop query="students_hired">
			<tr <cfif into mod 2>bgcolor="##E4E4E4"</cfif>>
				<td><span class="style1">#candidateid#</span></td>
				<td><span class="style1">#lastname#</span></td>
				<td><span class="style1">#firstname# </span></td>
				<td><span class="style1">#sex#</span></td>
				<td><span class="style1">#dateformat (dob, 'mm/dd/yyyy')#</span></td>
				<td><span class="style1">#countryname#</span></td>
				<td><span class="style1">#email#</span></td>
				<td><span class="style1">#ssn#</span></td>
				<cfif ds2019 is not ''>
				
				<td><span class="style1"><!----#passport_number#---->#dateformat (startdate, 'mm/dd/yyyy')#</span></td>
				<td><span class="style1">#dateformat (enddate, 'mm/dd/yyyy')# </span></td>
				<Cfelse>
				<td colspan=2 align="center"><span class="style1">Awaiting DS-2019</span></td>
				</cfif>
				<td><span class="style1">#businessname#</span></td>
				<td><span class="style1">#wat_placement#</span></td>
			</tr>
			<cfset into = into + 1 >
		</cfloop>
		
		<cfloop query="get_candidates_self">
			<tr <cfif into mod 2>bgcolor="##E4E4E4"</cfif>>
				<td><span class="style1">#candidateid#</span></td>
				<td><span class="style1">#lastname#</span></td>
				<td><span class="style1">#firstname# </span></td>
				<td><span class="style1">#sex#</span></td>
				<td><span class="style1">#dateformat (dob, 'mm/dd/yyyy')#</span></td>
				<td><span class="style1">#countryname#</span></td>
				<td><span class="style1">#email#</span></td>
				<td><span class="style1">#ssn#</span></td>
				<cfif ds2019 is not ''>
				
				<td><span class="style1"><!----#passport_number#---->#dateformat (startdate, 'mm/dd/yyyy')#</span></td>
				<td><span class="style1">#dateformat (enddate, 'mm/dd/yyyy')# </span></td>
				<Cfelse>
				<td colspan=2 align="center"><span class="style1">Awaiting DS-2019</span></td>
				</cfif>
				<td><span class="style1">#businessname#</span></td>
				<td><span class="style1">#wat_placement#</span></td>
			</tr>
			<cfset into = into + 1 >
		</cfloop>
		</table>
		<br />
	</cfif>
</cfloop>

<div class="style1"><strong>&nbsp; &nbsp; INTO-Placement:</strong> #variables.intoPlacement#</div>	
<div class="style1"><strong>&nbsp; &nbsp; Self-Placement:</strong> #variables.selfPlacement#</div>
<div class="style1"><strong>&nbsp; &nbsp; ----------------------------------</strong></div>
<div class="style1"><strong>&nbsp; &nbsp; Total Number Students:</strong> #variables.grandTotal#</div>
<div class="style1"><strong>&nbsp; &nbsp; ----------------------------------</strong></div>		  
			  
		</cfif></cfif>
<cfelse>
<span class="style1"><center>Print resutls will replace the menu options and take a bit longer to generate.<br /> Onscreen will allow you to change criteria with out clicking your back button.</center></span>

</cfif>
    

</cfoutput>