<!----
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
</cfif>---->

<cfif IsDefined('form.intrep')>
<cfquery name="get_candidates" datasource="MySql">
   SELECT *
  FROM extra_candidates
  LEFT JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = extra_candidates.hostcompanyid
  LEFT JOIN smg_programs ON smg_programs.programid = extra_candidates.programid
  LEFT JOIN smg_users ON smg_users.userid = extra_candidates.intrep
  WHERE extra_candidates.programid = #form.program#
  AND extra_candidates.intrep = #form.intrep#
 AND extra_candidates.cancel_date IS NOT NULL
</cfquery>
</cfif>

<cfoutput>



<form action="index.cfm?curdoc=reports/all_cancelled_candidates" method="post">
<table width="95%" cellpadding="4" cellspacing="0" border="0" align="center">
  <tr valign="middle" height="24">
    <td valign="middle" bgcolor="##E4E4E4" class="title1" colspan=2><font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp;All cancelled candidates per International Representatives and Program </font></td>

  </tr>


  	
  <tr valign="middle">
    <td align="right" valign="middle" class="title1"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Int. Rep.: </td>
	
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
		
		<cfquery name="get_int_rep" datasource="MySql">
		<!--- 	SELECT smg_users.businessname, smg_users.userid
            FROM smg_users
			LEFT JOIN user_Access_rights on smg_users.userid = user_access_rights.userid
			where  user_access_rights.usertype =8 and smg_users.active=1
			Order by businessname --->
			SELECT userid, firstname, lastname, businessname, uniqueid,
				smg_countrylist.countryname
			FROM smg_users
			LEFT JOIN smg_countrylist ON country = smg_countrylist.countryid
			WHERE usertype = 8
				AND active = '1'
			ORDER BY businessname
        </cfquery>
		
      </font>
       
         <!----
            <select name="companyid">
			<option></option>
            <cfloop query="get_host_company">
              <option value="#hostcompanyid#" <cfif IsDefined('form.companyid')><cfif get_host_company.hostcompanyid eq #form.companyid#> selected</cfif></cfif>> #get_host_company.name# </option>
            </cfloop>
          </select>--->
		  
		  <select name="intrep">
				<option></option>
				<cfloop query="get_int_rep">
				  <option value="#userid#" <cfif IsDefined('form.intrep')><cfif get_int_rep.userid eq #form.intrep#> selected</cfif></cfif>> #get_int_rep.businessname# </option>
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
		<meta http-equiv="refresh" content="1;url=index.cfm?curdoc=reports/all_cancelled_candidatesflashpaper&program=#form.program#&intrep=#form.intrep#">
		
	<cfelseif form.print eq 0>
				<br>
				
				<cfif IsDefined('get_candidates.recordcount')>
				
	<strong> <font size="2" face="Verdana, Arial, Helvetica, sans-serif"> Number of Candidates: #get_candidates.recordcount# </strong> </font>			
			
			 <Table width=100% frame=below cellpadding=7 cellspacing="0" class="thin-border-bottom" >
				<tr class="thin-border-bottom" >
				  
				  <td width=14% valign="top" class="style1"><strong>Candidate</strong></td>
				  <td width=14% valign="top" class="style1"><strong>Placement Information</strong></td>
				  
</tr>				  
 <cfloop query="get_candidates">	
 	
			<tr bgcolor="#iif(get_candidates.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
					
					<td class="style1" valign="top">#firstname# #lastname# (#candidateid#)</td>
					<td class="style1" valign="top">#name#</td>
				

				</tr>
			  </cfloop>
			</table>  
			<cfelse>
			<tr><td align="center" colspan=10> <div align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">No candidates found based on the criteria you specified. Please change and re-run the report.</font></div><br />
				</cfif>
				
			 <cfif NOT IsDefined('form.intrep') >
			<div align="center">	<font size="2" face="Verdana, Arial, Helvetica, sans-serif">Please select report criteria and click on generate report. <br /> </font></div><br />

			 
			  
</td></tr>
			  
			  </cfif>
			
			
			  
	
<cfelse>
<div align="center">Print resutls will replace the menu options and take a bit longer to generate.<br /> Onscreen will allow you to change criteria with out clicking your back button.
</cfif> 
</cfif>


</cfoutput>
