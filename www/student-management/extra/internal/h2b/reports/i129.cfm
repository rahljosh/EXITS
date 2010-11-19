
<cfif IsDefined('form.intrep')>
<cfquery name="get_candidate" datasource="MySQL">
	SELECT	 <!----candidateid, lastname, firstname, middlename, sex, dob, birth_city, intrep,
			wat_vacation_start, wat_vacation_end, startdate,---->
			*, extra_hostcompany.name as hostcompanyname, 
	birth.countryname as countrybirth,
	resident.countryname as countryresident,
	citizen.countryname as countrycitizen,
	passcountry.countryname as passportcountry
	<!----
	birth_country as countrybirth,
	residence_country as countryresident,
	citizen_country as countrycitizen ---->
	FROM 	extra_candidates
	LEFT JOIN extra_hostcompany ON extra_candidates.requested_placement = extra_hostcompany.hostcompanyid
	LEFT JOIN smg_countrylist birth ON extra_candidates.birth_country = birth.countryid
	LEFT JOIN smg_countrylist resident ON extra_candidates.residence_country = resident.countryid
	LEFT JOIN smg_countrylist citizen ON extra_candidates.citizen_country = citizen.countryid
	LEFT JOIN smg_countrylist passcountry ON extra_candidates.passport_country = passcountry.countryid
	WHERE <!----verification_received is null
		AND ----> 
		extra_candidates.companyid = 9<!----#client.companyid# ---->
		<!----AND extra_candidates.active = '1' ---->
		AND extra_candidates.programid = #form.program# 
		AND extra_candidates.intrep = #form.intrep#
		AND extra_candidates.h2b_i129_filled = 0
		AND extra_candidates.active = 1
		<!---AND onhold_approved <= '4'--->
	ORDER BY extra_candidates.lastname
</cfquery>
<cfinclude template="../querys/get_company_short.cfm">
</cfif>

<cfoutput>


<form action="index.cfm?curdoc=reports/i129" method="post">
<table width="95%" cellpadding="4" cellspacing="0" border="0" align="center">
  <tr valign="middle" height="24">
    <td valign="middle" bgcolor="##E4E4E4" class="title1" colspan=2><font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp;I-129 Report</font></td>

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
			<!--- SELECT smg_users.businessname, smg_users.userid
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
		<meta http-equiv="refresh" content="1;url=index.cfm?curdoc=reports/i129flashpaper-2&intrep=#form.intrep#&program=#form.program#">
		<!----- index.cfm?curdoc=reports/i129flashpaper&intrep=#form.intrep#&program=#form.program# ---->
		
	<cfelse>
			
			<p class="style1">Total Number of Candidates: #get_candidate.recordcount# <br /></p>
			
			<span class="style1"><br>
			</span>
			<Table width=100% frame=below cellpadding=7 cellspacing="0" class="thin-border-bottom" >
				<tr class="thin-border-bottom" >
				  
				  <td width=14% valign="top" class="style1"><strong>Last Name</strong></td>
				  <td width=14% valign="top" class="style1"><strong>First Name</strong></td>
				  <td width=14% valign="top" class="style1"><strong>Middle Name</strong></td>
				  <td width=9% valign="top" class="style1"><strong>Date of Birth</strong></td>
				  <td width=10% valign="top" class="style1"><strong>Country of Birth</strong></td>
				  <td width=10% valign="top" class="style1"><strong>Country of Citizenship</strong></td>
				  <td width=12% valign="top" class="style1"><strong>Mailing Address </strong></td>
				  <td width=10% valign="top" class="style1"><strong>Previously participated </strong></td>
				  <td width=10% valign="top" class="style1"><strong>Social Security Number </strong></td>
				  <td width=10% valign="top" class="style1"><strong>I-94 Number </strong></td>
				  <td width=10% valign="top" class="style1"><strong>Date H-2B expires  </strong></td>
				  <td width=10% valign="top" class="style1"><strong>Passport Number </strong></td>
				  <td width=10% valign="top" class="style1"><strong>Contry Where Issued </strong></td>
				  <td width=10% valign="top" class="style1"><strong>Date Issued </strong></td>
				  <td width=10% valign="top" class="style1"><strong>Date Expires </strong></td>
  				  <td width=10% valign="top" class="style1"><strong>Requested Placement </strong></td>
				</tr>
				
				<cfloop query="get_candidate">
				<tr bgcolor="#iif(get_candidate.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
					
					<td class="style1" valign="top">#get_candidate.lastname#</td>
					<td class="style1" valign="top">#get_candidate.firstname#</td>
					<td class="style1" valign="top">#get_candidate.middlename#</td>
					<td class="style1" valign="top">#DateFormat(get_candidate.dob, 'mm/dd/yyyy')#</td>
					<td class="style1" valign="top">#get_candidate.countrybirth#</td><td class="style1" valign="top">#get_candidate.countrycitizen#</td>
					<td class="style1" valign="top" >#get_candidate.home_address#</td>
					<td class="style1" valign="top"><cfif get_candidate.h2b_participated is 0> No <cfelse> Yes</cfif></td>
					<td class="style1" valign="top">#get_candidate.ssn#</td>
					<td class="style1" valign="top">#get_candidate.h2b_i94#</td>
					<td class="style1" valign="top">#DateFormat(h2b_date_expires, 'mm/dd/yyyy')#</td>
					<td class="style1" valign="top">#get_candidate.passport_number#</td>
					<td class="style1" valign="top">#passportcountry#</td>
					<td class="style1" valign="top">#DateFormat(passport_date, 'mm/dd/yyyy')#</td>
					<td class="style1" valign="top">#DateFormat(passport_expires, 'mm/dd/yyyy')#</td>
					<td class="style1" valign="top"><!----#requested_placement#----> #hostcompanyname#</td>															
																							
				</tr>
				</cfloop>
			</Table>
			
			<!----<table width=98% cellpadding=2 cellspacing="0" >
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
			  
	----->


	</cfif>

<cfelse>
<div align="center">Print resutls will replace the menu options and take a bit longer to generate.<br /> Onscreen will allow you to change criteria with out clicking your back button.
</cfif>
    

</cfoutput>