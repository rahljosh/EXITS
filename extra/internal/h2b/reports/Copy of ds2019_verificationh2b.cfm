
<cfif IsDefined('form.intrep')>
<cfquery name="get_candidate" datasource="MySQL">
	SELECT	 candidateid, lastname, firstname, middlename, sex, dob, birth_city, intrep,
			wat_vacation_start, wat_vacation_end, startdate,
	birth.countryname as countrybirth,
	resident.countryname as countryresident,
	citizen.countryname as countrycitizen
	<!----
	birth_country as countrybirth,
	residence_country as countryresident,
	citizen_country as countrycitizen ---->
	FROM 	extra_candidates
	LEFT JOIN smg_countrylist birth ON extra_candidates.birth_country = birth.countryid
	LEFT JOIN smg_countrylist resident ON extra_candidates.residence_country = resident.countryid
	LEFT JOIN smg_countrylist citizen ON extra_candidates.citizen_country = citizen.countryid
	WHERE verification_received is null
		AND companyid = #client.companyid# 
		AND active = '1' 
		AND programid = #form.program# 
		AND intrep = #form.intrep#
		<!---AND onhold_approved <= '4'--->
	ORDER BY lastname
</cfquery>
<cfinclude template="../querys/get_company_short.cfm">
</cfif>

<cfoutput>


<form action="index.cfm?curdoc=reports/ds2019_verificationh2b" method="post">
<table width="95%" cellpadding="4" cellspacing="0" border="0" align="center">
  <tr valign="middle" height="24">
    <td valign="middle" bgcolor="##E4E4E4" class="title1" colspan=2><font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp;DS 2019 Verification Report</font></td>

  </tr>


  	
  <tr valign="middle">
    <td align="right" valign="middle" class="title1"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">International Rep: </td>
	
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
			SELECT smg_users.businessname, smg_users.userid
            FROM smg_users
			LEFT JOIN user_Access_rights on smg_users.userid = user_access_rights.userid
			where  user_access_rights.usertype =8 and smg_users.active=1
			Order by businessname
        </cfquery>
      </font>
       
         
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
		<meta http-equiv="refresh" content="1;url=index.cfm?curdoc=reports/ds2019_verification&intrep=#form.intrep#&program=#form.program#">
		
	<cfelse>
			
			
			<span class="style1"><br>
			</span>
			<Table width=100% frame=below cellpadding=7 cellspacing="0" class="thin-border-bottom" >
				<tr class="thin-border-bottom" >
				  <td width=3% valign="top" class="style1"><strong>ID</strong></td>
				  <td width=14% valign="top" class="style1"><strong>Last Name</strong></td>
				  <td width=14% valign="top" class="style1"><strong>First Name</strong></td>
				  <td width=14% valign="top" class="style1"><strong>Middle Name</strong></td>
				  <td width=6% valign="top" class="style1"><strong>Sex</strong></td>
				  <td width=9% valign="top" class="style1"><strong>Date of Birth</strong></td>
				  <td width=10% valign="top" class="style1"><strong>City of Birth</strong></td>
				  <td width=10% valign="top" class="style1"><strong>Country of Birth</strong></td>
				  <td width=10% valign="top" class="style1"><strong>Country of Citizenship</strong></td>
				  <td width=12% valign="top" class="style1"><strong>Country of Residence</strong></td>
				  <td width=10% valign="top" class="style1"><strong>Program Length </strong></td>
				  <td width=10% valign="top" class="style1"><strong>Start Date </strong></td>
				</tr>
				
				<cfloop query="get_candidate">
				<tr bgcolor="#iif(get_candidate.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
					<td class="style1" valign="top">#get_candidate.candidateid#</td><td class="style1" valign="top">#get_candidate.lastname#</td><td class="style1" valign="top">#get_candidate.firstname#</td>
					<td class="style1" valign="top">#get_candidate.middlename#</td><td class="style1" valign="top">#get_candidate.sex#</td><td class="style1" valign="top">#DateFormat(get_candidate.dob, 'mm/dd/yyyy')#</td>
					<td class="style1" valign="top">#get_candidate.birth_city#</td><td class="style1" valign="top">#get_candidate.countrybirth#</td><td class="style1" valign="top">#get_candidate.countrycitizen#</td>
					<td class="style1" valign="top" >#get_candidate.countryresident#</td>
					<td class="style1" valign="top"> <cfif get_candidate.wat_vacation_start EQ ''>n/a<cfelse> #DateDiff('ww', get_candidate.wat_vacation_start, get_candidate.wat_vacation_end)# weeks </cfif></td>
					<td class="style1" valign="top"><cfif get_candidate.wat_vacation_start EQ ''>n/a<cfelse>#get_candidate.wat_vacation_start#</cfif></td>
				</tr>
				</cfloop>
			</Table>
			
			<table width=98% cellpadding=2 cellspacing="0" >
				<tr>
					<td valign="top" class="style1"><div align="justify">
					Please take a look at all the information above. If there's anything wrong or misspelled, please correct it ON THIS FORM and return it to us dated and signed.<br /><br /><br /><br />
					</div></td></tr>
				<tr>
						<td align="left" valign="top">
						
								  <table>
										<tr><td class="style1"><b>Our best regards,</b></td></tr>
										<tr><td class="style1"><b>#companyshort.verification_letter#</b><br></td></tr>
										<tr>
										  <td class="style1"><b>Into EdVentures.</b></td>
										</tr>
									</table>
				</td>
				<td align="right">
						
						
							<table width="300" align="right" class="thin-border" frame="border" cellpadding=2 cellspacing="0">
								<tr><td class="style1" colspan=2><h3>Return check:</h3></td></tr>
							
								
								<tr><td>Date:</td><td> ____________________________</td></tr>
								<tr>
									<td><br></td>
								</tr>
								
								<tr><td>Signature:</td><td> ____________________________</td></tr>			
							</table>
				</td>
			</tr>
			</table>
			  
	


		</cfif>

<cfelse>
<div align="center">Print resutls will replace the menu options and take a bit longer to generate.<br /> Onscreen will allow you to change criteria with out clicking your back button.
</cfif>
    

</cfoutput>