
<cfif IsDefined('form.intrep')>
<cfquery name="get_candidates" datasource="MySql">
  SELECT *
  <!----extra_candidates.firstname, extra_candidates.lastname, extra_candidates.placedby, extra_candidates.sex, extra_candidates.hostcompanyid, extra_hostcompany.name, smg_programs.startdate, smg_programs.enddate, extra_candidates.ds2019, extra_candidates.programid, extra_candidates.companyid---->
  FROM extra_candidates
  LEFT JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = extra_candidates.hostcompanyid
  LEFT JOIN smg_programs ON smg_programs.programid = extra_candidates.programid
  LEFT JOIN smg_users ON smg_users.userid = extra_candidates.intrep
  WHERE <!----extra_candidates.hostcompanyid = #form.companyid#
  AND ----->extra_candidates.programid = #form.program#
  AND extra_candidates.intrep = #form.intrep#
  AND extra_candidates.status = 1


</cfquery>
</cfif>




<cfoutput>
<form action="index.cfm?curdoc=reports/all_active_candidates" method="post">
<table width="95%" cellpadding="4" cellspacing="0" border="0" align="center">
  <tr valign="middle" height="24">
    <td valign="middle" bgcolor="##E4E4E4" class="title1" colspan=2><font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp;All active candidates per International Representative and Program  </font></td>

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
		
		  <cfquery name="get_int_rep" datasource="MySql">			
			SELECT userid, firstname, lastname, businessname, uniqueid,
				smg_countrylist.countryname
			FROM smg_users
			LEFT JOIN smg_countrylist ON country = smg_countrylist.countryid
			WHERE usertype = 8
				AND active = '1'
			ORDER BY businessname
        </cfquery>
		
      </font>
       
         
<!----            <select name="companyid">
			<option></option>
            <cfloop query="get_host_company">
              <option value="#hostcompanyid#" <cfif IsDefined('form.companyid')><cfif get_host_company.hostcompanyid eq #form.companyid#> selected</cfif></cfif>> #get_host_company.name# </option>
            </cfloop>
          </select>---->
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
		<meta http-equiv="refresh" content="1;url=index.cfm?curdoc=reports/all_active_candidatesflashpaper&program=#form.program#&intrep=#form.intrep#">
		
	<cfelse>
	<cfif IsDefined('get_candidates.recordcount')>
<p class="style1">Total Number of Candidates: #get_candidates.recordcount# <br /></p>
	

				
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
			 <cfif NOT IsDefined('form.companyid') >
			<div align="center">	<font size="2" face="Verdana, Arial, Helvetica, sans-serif">Please select report criteria and click on generate report. <br /> </font></div><br />

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
