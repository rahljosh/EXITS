
<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<cfquery name="get_candidate" datasource="MySQL">
	SELECT	 candidateid, lastname, firstname, middlename, sex, dob, birth_city, intrep,
			wat_vacation_start, wat_vacation_end, startdate, enddate,
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
		AND status = '1'
		AND programid = #url.program# 
		AND intrep = #url.intrep#
		<!---AND onhold_approved <= '4'--->
	ORDER BY candidateid
</cfquery>

<!-----Intl. Agent----->
<cfquery name="int_Agent" datasource="MySQL">
	select companyid, businessname, fax, email
	from smg_users 
	where userid = #url.intrep#
	
</cfquery>

<cfquery name="program_name" datasource="MySQL">
	SELECT programname, programid
	FROM smg_programs
	WHERE programid = #url.program#
</cfquery>
<style type="text/css">
<!--
.style1 { 
	font-family: Arial, Helvetica, sans-serif;
	font-size: 10; 	}
.thin-border-bottom { 
    border-bottom: 1px solid #000000; }
	.thin-border-top { 
    border-top: 1px solid #000000; }
.thin-border{ border: 1px solid #000000;}
-->
</style>

<!----
<cfdocument format="pdf" orientation="landscape">
---->


<cfoutput>
<table width=100% align="center" border=0 bgcolor="FFFFFF">
  <tr>
	<td  valign="top" width=90><span id="titleleft">
		<span class="style1">TO:<br>
		FAX:<br>
		E-MAIL:<br>
		<br>
		<br>		
        </span></td>
	<td  valign="top" class="style1"><span id="titleleft">
		<cfif len(#int_agent.businessname#) gt  40>#Left(int_agent.businessname,40)#..</font></a><cfelse>#int_agent.businessname#</cfif><br>
		#int_agent.fax#<br>
		<a href="mailto:#int_agent.email#">#int_agent.email#</a><br><br><br>
		#DateFormat(now(), 'dddd, mmmm dd, yyyy')#<br></span></td>
	<td class="style1">
	<img src="../../pics/new_logo.gif" width="80" height="80">
	 </td>	
	<td align="right" valign="top" class="style1"> 
		<div align="right"><span id="titleleft">
		#companyshort.companyshort#<br>
		#companyshort.address#<br>
		#companyshort.city#, #companyshort.state# #companyshort.zip#<br><br>
		<cfif companyshort.phone is ''><cfelse> Phone: #companyshort.phone#<br></cfif>
		<cfif companyshort.toll_free is ''><cfelse> Toll Free: #companyshort.toll_free#<br></cfif>
	<cfif companyshort.fax is ''><cfelse> Fax: #companyshort.fax#<br></cfif></span></div></td></tr>		
</table>
</cfoutput>

<div id="pagecell_reports">
<img src="../../pics/black_pixel.gif" width="100%" height="2">


<div align="center" class="style1"><font size="+3"> DS 2019 Verification Report</font></div>
<img src="../../pics/black_pixel.gif" width="100%" height="2">

<span class="style1"><br>
</span>

<Table width=100% frame=below cellpadding=2 cellspacing="0" class="thin-border-bottom" >
				<tr class="thin-border-bottom" >
				  <td valign="top" class="style1"><strong>ID</strong></td>
				  <td valign="top" class="style1"><strong>Last Name</strong></td>
				  <td valign="top" class="style1"><strong>First Name</strong></td>
				  <td valign="top" class="style1"><strong>Middle Name</strong></td>
				  <td valign="top" class="style1"><strong>Sex</strong></td>
				  <td valign="top" class="style1"><strong>Date of Birth</strong></td>
				  <td valign="top" class="style1"><strong>City of Birth</strong></td>
				  <td valign="top" class="style1"><strong>Country of Birth</strong></td>
				  <td valign="top" class="style1"><strong>Country of Citizenship</strong></td>
				  <td valign="top" class="style1"><strong>Country of Residence</strong></td>
			      <td valign="top" class="style1"><strong>Start Date </strong></td>
				  <td valign="top" class="style1"><strong>End Date </strong>
				</tr>
				<tr>
					<td colspan="12" valign="middle"><img src="../pics/black_pixel.gif" width="100%" height="1"></td>
				</tr>
			<cfoutput>			
				<cfloop query="get_candidate">
				<tr bgcolor="#iif(get_candidate.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
					<td colspan="12" height="25"></td>
				</tr>
				<tr bgcolor="#iif(get_candidate.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
					<td class="style1" valign="top">#get_candidate.candidateid#</td>			
					<td class="style1" valign="top">#get_candidate.lastname#</td>
					<td class="style1" valign="top">#get_candidate.firstname#</td>
					<td class="style1" valign="top">#get_candidate.middlename#</td>
					<td class="style1" valign="top">#get_candidate.sex#</td>
					<td class="style1" valign="top">#DateFormat(get_candidate.dob, 'mm/dd/yyyy')#</td>
					<td class="style1" valign="top">#get_candidate.birth_city#</td>
					<td class="style1" valign="top">#get_candidate.countrybirth#</td>
					<td class="style1" valign="top">#get_candidate.countrycitizen#</td>
					<td class="style1" valign="top">#get_candidate.countryresident#</td>
					<td class="style1" valign="top"><cfif get_candidate.startdate EQ ''><cfelse>#DateFormat(get_candidate.startdate, 'mm/dd/yyyy')# </cfif></td>
					<td class="style1" valign="top"> <cfif get_candidate.enddate EQ ''><cfelse>#DateFormat(get_candidate.enddate, 'mm/dd/yyyy')# </cfif></td></tr>
				</tr>
				</cfloop>
			</cfoutput>
		</Table>
		
			<cfoutput>
			  <table width=98% cellpadding=2 cellspacing="0" >
                <tr>
                  <td valign="top" class="style1"><div align="justify"> Please take a look at all the information above. If there's anything wrong or misspelled, please correct it ON THIS FORM and return it to us dated and signed.<br />
                        <br />
                    <br />
                    <br />
               	  </div></td>
                  	<td rowspan="2" valign="top" class="style1"><br />
                  	    <br />
               	        <br />
           	          <table width="300" align="right" class="thin-border" frame="border" cellpadding=2 cellspacing="0">
						  <tr>
							<td class="style1" colspan=2><h3>Return check:</h3></td>
							  </tr>
						  <tr>
							<td class="style1">Date:</td>
								<td> ____________________________</td>
							  </tr>
							  <tr>
								<td><br /></td>
							  </tr>
						  <tr>
							<td class="style1">Signature:</td>
								<td> ____________________________</td>
							  </tr>
					  </table>
						
					</td>
                </tr>
                <tr>
                  <td align="left" valign="top">
				 
				  <table>
                      <tr>
                        <td class="style1"><b>Our best regards,</b></td>
                      </tr>
                      <tr>
                        <td class="style1"><b>#companyshort.verification_letter#</b><br /></td>
                      </tr>
                      <tr>
                        <td class="style1"><b>Into EdVentures.</b></td>
                      </tr>
                  </table>
				 
				 </td>
                </tr>
              </table>
			</cfoutput>
			<!----
            </cfdocument>
			---->