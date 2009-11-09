<cfdocument format="pdf" orientation="landscape" backgroundvisible="yes" overwrite="no" fontembed="yes">
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

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

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
		AND extra_candidates.programid = #url.program# 
		AND extra_candidates.intrep = #url.intrep#
		AND extra_candidates.h2b_i129_filled = 0
		AND extra_candidates.active = 1
		<!---AND onhold_approved <= '4'--->
	ORDER BY extra_candidates.lastname
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
	<img src="http://dev.student-management.com/extra/internal/pics/Into-Logo.jpg" width="80" height="80" />	</td>	
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

<div align="center" class="style1"><font size="+3"> I-129  Report</font></div>
<img src="../../pics/black_pixel.gif" width="100%" height="2">


<span class="style1"><br>
</span>
<p class="style1">Total Number of Candidates: <cfoutput>#get_candidate.recordcount# </cfoutput><br /></p>
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
	
	<cfoutput query="get_candidate">
	<tr bgcolor="#iif(get_candidate.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
		<td class="style1" valign="top">#get_candidate.lastname#</td><td class="style1" valign="top">#get_candidate.firstname#</td>
					<td class="style1" valign="top">#get_candidate.middlename#</td><td class="style1" valign="top">#DateFormat(get_candidate.dob, 'mm/dd/yyyy')#</td>
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
	</cfoutput>
</Table>

<!----
<table width=98% cellpadding=2 cellspacing="2" >
	<tr>
		<td valign="top" class="style1" colspan=2><div align="justify">
		Please take a look at all the information above. If there's anything wrong or misspelled, please correct it ON THIS FORM and return it to us dated and signed.<br /><br /><br /><br />
		</div></td></tr>
	<tr>
	<td>
		  <table align="left">
	<tr><td class="style1"><b>Our best regards,</b></td></tr>
	<tr><td class="style1"><b>#companyshort.verification_letter#</b></td></tr>
	<tr>
	  <td class="style1"><Br /><br /><b>Into EdVentures.</b></td>
	</tr>
</table>

	</td>
	<td>

	<table width="300" align="right" class="thin-border" cellpadding=2 cellspacing="0">
					<tr><td class="style1" ><u>Return check:</u></td></tr>
					<tr><td class="style1"><br><br>Date: ________________________________</td></tr><br />
					<tr><td class="style1"><br />Signature: ____________________________<br />	</td></tr>			
		  </table>
	</td>	
	</tr>
</table>
  
------>



</div>
</cfdocument>