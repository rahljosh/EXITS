<!--- use cfsetting to block output of HTML outside of cfoutput tags --->
<cfsetting enablecfoutputonly="Yes">



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

<!----<table width=100% align="center" border=0 bgcolor="FFFFFF">

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
</table>-------->

<div id="pagecell_reports">
</span>


<!--- set content type --->
<cfcontent type="application/msexcel">

<!--- suggest default name for XLS file --->
<<!--- "Content-Disposition" in cfheader also ensures 
relatively correct Internet Explorer behavior. --->
<cfheader name="Content-Disposition" value="attachment; filename=i129report.xls"> 


<cfoutput>
I-129 Report<br><br>


<Table>
	<tr >
	  <td ><strong>Last Name</strong></td>
				  <td><strong>First Name</strong></td>
				  <td><strong>Middle Name</strong></td>
				  <td><strong>Date of Birth</strong></td>
				  <td><strong>Country of Birth</strong></td>
				  <td><strong>Country of Citizenship</strong></td>
				  <td><strong>Mailing Address </strong></td>
				  <td><strong>Previously participated </strong></td>
				  <td><strong>Social Security Number </strong></td>
				  <td><strong>I-94 Number </strong></td>
				  <td><strong>Date H-2B expires  </strong></td>
				  <td><strong>Passport Number </strong></td>
				  <td><strong>Contry Where Issued </strong></td>
				  <td><strong>Date Issued </strong></td>
				  <td><strong>Date Expires </strong></td>
  				  <td><strong>Requested Placement </strong></td>
    </tr>
	</cfoutput>
	<cfoutput query="get_candidate">
	
	<tr >
		<td>#get_candidate.lastname#</td><td>#get_candidate.firstname#</td>
					<td>#get_candidate.middlename#</td><td>#DateFormat(get_candidate.dob, 'mm/dd/yyyy')#</td>
					<td>#get_candidate.countrybirth#</td><td>#get_candidate.countrycitizen#</td>
					<td>#get_candidate.home_address#</td>
					<td><cfif get_candidate.h2b_participated is 0> No <cfelse> Yes</cfif></td>
					<td>#get_candidate.ssn#</td>
					<td>#get_candidate.h2b_i94#</td>
					<td>#DateFormat(h2b_date_expires, 'mm/dd/yyyy')#</td>
					<td>#get_candidate.passport_number#</td>
					<td>#passportcountry#</td>
					<td>#DateFormat(passport_date, 'mm/dd/yyyy')#</td>
					<td>#DateFormat(passport_expires, 'mm/dd/yyyy')#</td>
					<td><!----#requested_placement#----> #hostcompanyname#</td>		
	</cfoutput>
</Table>


</div>
</body>
