<style type="text/css">
<!--
.thin-border-bottom { 
    border-bottom: 1px solid #000000; }
	.thin-border-top { 
    border-top: 1px solid #000000; }
.thin-border{ border: 1px solid #000000;}
-->
</style>
<cfif IsDefined('form.intrep')>
<cfquery name="get_candidate" datasource="MySQL">
	SELECT	 candidateid, lastname, firstname, middlename, sex, dob, birth_city, intrep,
			wat_vacation_start, wat_vacation_end, enddate, startdate, ds2019,
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
		AND programid = #form.program# 
		AND intrep = #form.intrep#
		<!--- ticket 1026 ---->
		AND (ds2019 is null or ds2019 = '')
		<!---AND onhold_approved <= '4'--->
	ORDER BY candidateid
</cfquery>

<cfquery name="intrep_email" datasource="mysql">
select email 
from smg_users
where userid = #form.intrep# 
</cfquery>

<cfinclude template="../querys/get_company_short.cfm">
</cfif>
asdf
<cfoutput>


<form action="reports/ds2019_verification_wt_screen.cfm" method="post">





<!-----Display Reports---->

<cfif isDefined('form.print')>
	<cfif form.print eq 1>
		<span class="style1"><center><b>Results are being generated...</b></center></span><br /><br /><br />
		<meta http-equiv="refresh" content="1;url=index.cfm?curdoc=reports/ds2019_verification&intrep=#form.intrep#&program=#form.program#&format=FlashPaper">
	<cfelseif form.print eq 2>
		<span class="style1"><center><b>Results are being generated...</b></center></span><br /><br /><br />
		<meta http-equiv="refresh" content="1;url=reports/ds2019_verification.cfm&intrep=#form.intrep#&program=#form.program#&format=PDF">
		
	<cfelse>

<!-----Intl. Agent----->
<cfquery name="int_Agent" datasource="MySQL">
	select companyid, businessname, fax, email
	from smg_users 
	where userid = #form.intrep# 
	
</cfquery>

<cfquery name="program_name" datasource="MySQL">
	SELECT programname, programid
	FROM smg_programs
	WHERE programid = #form.program#
</cfquery>
	<cfset toline = "">
	<cfif isDefined('form.email_intrep')> 
		<cfset toline = #ListAppend(toline, "#int_agent.email#")#>
	</cfif>
	<cfif isDefined('form.email_self')> 
		<cfset toline = #ListAppend(toline, "#client.email#")#>
	</cfif>
<cfif toline is not ''>
<div align="center">
<font color="##FF9900">This report was emailed to: #toline#</font>
</div>
</cfif>
<table width=100% align="center" border=0 bgcolor="FFFFFF">

<cfoutput>


  <tr>
	<td  valign="top" width=90><span id="titleleft">
		<span class="style1">TO:<br>
		FAX:<br>
		E-MAIL:<br>
		<br>
		<br>		
		<!---Today's Date:<br>--->
        </span></td>
	<td  valign="top" class="style1"><span id="titleleft">
		<cfif len(#int_agent.businessname#) gt  40>#Left(int_agent.businessname,40)#..</font></a><cfelse>#int_agent.businessname#</cfif><br>
		#int_agent.fax#<br>
		<a href="mailto:#int_agent.email#">#int_agent.email#</a><br><br><br>
		#DateFormat(now(), 'dddd, mmmm dd, yyyy')#<br>	</td>
	<td class="style1"><!---<img src="../../pics/logo/#client.companyid#.gif"  alt="" border="0" align="right">--->
	<img src="http://www.student-management.com/extra/internal/pics/INTO-Logo.jpg" width="80" height="80" />	</td>	
	<td align="right" valign="top" class="style1"> 
		<div align="right"><span id="titleleft">
		#companyshort.companyshort#<br>
		#companyshort.address#<br>
		#companyshort.city#, #companyshort.state# #companyshort.zip#<br><br>
		<cfif companyshort.phone is ''><cfelse> Phone: #companyshort.phone#<br></cfif>
		<cfif companyshort.toll_free is ''><cfelse> Toll Free: #companyshort.toll_free#<br></cfif>
	<cfif companyshort.fax is ''><cfelse> Fax: #companyshort.fax#<br></cfif></div>	</td></tr>		
</cfoutput>
<span class="style1">
</table>

<div id="pagecell_reports">
</span>
<img src="../../pics/black_pixel.gif" width="100%" height="2">

<div align="center" class="style1"><font size="+3"> DS 2019 Verification Report</font></div>
<img src="../../pics/black_pixel.gif" width="100%" height="2">


<span class="style1"><br>
</span>


			
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
				<!---  <td width=10% valign="top" class="style1"><strong>Program Length </strong></td>--->
			      <td width=10% valign="top" class="style1"><strong>Start Date </strong></td>
				  <td width=10% valign="top" class="style1"><strong>End Date </strong>
				</tr>
				
				<cfloop query="get_candidate">
				<tr bgcolor="#iif(get_candidate.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
					<td class="style1" valign="top">#get_candidate.candidateid#</td><td class="style1" valign="top">#get_candidate.lastname#</td><td class="style1" valign="top">#get_candidate.firstname#</td>
					<td class="style1" valign="top">#get_candidate.middlename#</td><td class="style1" valign="top">#get_candidate.sex#</td><td class="style1" valign="top">#DateFormat(get_candidate.dob, 'mm/dd/yyyy')#</td>
					<td class="style1" valign="top">#get_candidate.birth_city#</td><td class="style1" valign="top">#get_candidate.countrybirth#</td><td class="style1" valign="top">#get_candidate.countrycitizen#</td>
					<td class="style1" valign="top" >#get_candidate.countryresident#</td>
<!---					<td class="style1" valign="top"> <cfif get_candidate.wat_vacation_start EQ ''>n/a<cfelse> #DateDiff('ww', get_candidate.wat_vacation_start, get_candidate.wat_vacation_end)# weeks </cfif></td>--->
					<td class="style1" valign="top"><!---- get_candidate.wat_vacation_start --->
					<cfif get_candidate.startdate EQ ''><cfelse>#DateFormat(get_candidate.startdate, 'mm/dd/yyyy')# </cfif></td>
					<td class="style1" valign="top"> <cfif get_candidate.enddate EQ ''><cfelse>#DateFormat(get_candidate.enddate, 'mm/dd/yyyy')# </cfif></td>				
					
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
			  
	

<cfif toline is not ''>
#toline# 123456
<cfmail to="josh@pokytrails.com" from="#client.email#" Subject="DS-2019 Verification Report" type="html" server="exitgroup.org" username="outgoing@exitgroup.org" password="p%15gz">
<table width="100%" align="center" border="0" bgcolor="FFFFFF">

<cfoutput>


  <tr>
	<td  valign="top" width="90"><span id="titleleft">
		<span class="style1">TO:<br />
		FAX:<br />
		E-MAIL:<br />
		<br />
		<br />		
		<!---Today's Date:<br>--->
        </span></span></td>
	<td  valign="top" class="style1"><span id="titleleft">
		<cfif len(#int_agent.businessname#) gt  40>#Left(int_agent.businessname,40)#..<cfelse>#int_agent.businessname#</cfif><br />
		#int_agent.fax#<br />
		<a href="mailto:#int_agent.email#">#int_agent.email#</a><br />
		<br />
		<br />
		#DateFormat(now(), 'dddd, mmmm dd, yyyy')#<br />	</span></td>
	<td class="style1"><!---<img src="../../pics/logo/#client.companyid#.gif"  alt="" border="0" align="right">--->
	<img src="../pics/INTO-Logo.jpg" height="80" />	</td>	
	<td align="right" valign="top" class="style1"> 
		<div align="right"><span id="titleleft">
		#companyshort.companyshort#<br />
		#companyshort.address#<br />
		#companyshort.city#, #companyshort.state# #companyshort.zip#<br />
		<br />
		<cfif companyshort.phone is ''><cfelse> Phone: #companyshort.phone#<br />
		</cfif>
		<cfif companyshort.toll_free is ''><cfelse> Toll Free: #companyshort.toll_free#<br />
		</cfif>
	<cfif companyshort.fax is ''><cfelse> Fax: #companyshort.fax#<br />
	</cfif></span></div>	</td></tr>		
</cfoutput>
<tr>
  <td><span class="style1"></span></td></tr>
</table>

<div id="pagecell_reports">

<img src="../../pics/black_pixel.gif" width="100%" height="2" />

<div align="center" class="style1"><font size="+3"> DS 2019 Verification Report</font></div>
<img src="../../pics/black_pixel.gif" width="100%" height="2" />


<span class="style1"><br />
</span>


			
			<span class="style1"><br />
  </span>
			<table width="100%" frame="below" cellpadding="7" cellspacing="0" class="thin-border-bottom" >
				<tr class="thin-border-bottom" >
				  <td width="3%" valign="top" class="style1"><strong>ID</strong></td>
				  <td width="14%" valign="top" class="style1"><strong>Last Name</strong></td>
				  <td width="14%" valign="top" class="style1"><strong>First Name</strong></td>
				  <td width="14%" valign="top" class="style1"><strong>Middle Name</strong></td>
				  <td width="6%" valign="top" class="style1"><strong>Sex</strong></td>
				  <td width="9%" valign="top" class="style1"><strong>Date of Birth</strong></td>
				  <td width="10%" valign="top" class="style1"><strong>City of Birth</strong></td>
				  <td width="10%" valign="top" class="style1"><strong>Country of Birth</strong></td>
				  <td width="10%" valign="top" class="style1"><strong>Country of Citizenship</strong></td>
				  <td width="12%" valign="top" class="style1"><strong>Country of Residence</strong></td>
				<!---  <td width=10% valign="top" class="style1"><strong>Program Length </strong></td>--->
			      <td width="10%" valign="top" class="style1"><strong>Start Date </strong></td>
				  <td width="10%" valign="top" class="style1"><strong>End Date </strong>				</td>
				</tr>
				
				<cfloop query="get_candidate">
				<tr bgcolor="#iif(get_candidate.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
					<td class="style1" valign="top">#get_candidate.candidateid#</td><td class="style1" valign="top">#get_candidate.lastname#</td><td class="style1" valign="top">#get_candidate.firstname#</td>
					<td class="style1" valign="top">#get_candidate.middlename#</td><td class="style1" valign="top">#get_candidate.sex#</td><td class="style1" valign="top">#DateFormat(get_candidate.dob, 'mm/dd/yyyy')#</td>
					<td class="style1" valign="top">#get_candidate.birth_city#</td><td class="style1" valign="top">#get_candidate.countrybirth#</td><td class="style1" valign="top">#get_candidate.countrycitizen#</td>
					<td class="style1" valign="top" >#get_candidate.countryresident#</td>
<!---					<td class="style1" valign="top"> <cfif get_candidate.wat_vacation_start EQ ''>n/a<cfelse> #DateDiff('ww', get_candidate.wat_vacation_start, get_candidate.wat_vacation_end)# weeks </cfif></td>--->
					<td class="style1" valign="top"><cfif get_candidate.wat_vacation_start EQ ''>n/a<cfelse>#DateFormat(get_candidate.wat_vacation_start, 'mm/dd/yyyy')# </cfif></td>
					<td class="style1" valign="top"> <cfif get_candidate.wat_vacation_end EQ ''>n/a<cfelse>#DateFormat(get_candidate.wat_vacation_end, 'mm/dd/yyyy')# </cfif></td>				
					
				</tr>
				</cfloop>
  </table>
			
			<table width="98%" cellpadding="2" cellspacing="0" >
				<tr>
					<td valign="top" class="style1"><div align="justify">
					Please take a look at all the information above. If there's anything wrong or misspelled, please correct it ON THIS FORM and return it to us dated and signed.<br /><br /><br /><br />
					</div></td></tr>
				<tr>
						<td align="left" valign="top">
						
								  <table>
										<tr><td class="style1"><b>Our best regards,</b></td></tr>
										<tr><td class="style1"><b>#companyshort.verification_letter#</b><br /></td></tr>
										<tr>
										  <td class="style1"><b>Into EdVentures.</b></td>
										</tr>
						  </table>
				</td>
				<td align="right">
						
						
							<table width="300" align="right" class="thin-border" frame="border" cellpadding="2" cellspacing="0">
								<tr><td class="style1" colspan="2"><h3>Return check:</h3></td></tr>
							
								
								<tr><td>Date:</td><td> ____________________________</td></tr>
								<tr>
								  <td><br /></td>
								</tr>
								
								<tr><td>Signature:</td><td> ____________________________</td></tr>			
				  </table>
				</td>
			</tr>
  </table>
			  
	
</div></cfmail>

		</cfif>

</cfif>

<cfelse>
<div align="center"><span class="style1">Print resutls will replace the menu options and take a bit longer to generate.<br /> Onscreen will allow you to change criteria with out clicking your back button.</span></<br /><br />
</cfif>
    

</cfoutput>
