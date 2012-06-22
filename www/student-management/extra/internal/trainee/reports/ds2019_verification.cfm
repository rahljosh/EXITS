<cfdocument format="pdf" orientation="landscape" backgroundvisible="yes" overwrite="no" fontembed="yes">

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<cfquery name="get_candidate" datasource="MySQL">
	SELECT	 
    	candidateid, 
        lastname, 
        firstname, 
        middlename, 
        sex, 
        dob, 
        birth_city, 
        intrep,
		wat_vacation_start, 
        wat_vacation_end, 
        ds2019_startdate as startdate, 
        ds2019_enddate as enddate, 
        ds2019,
		birth.countryname as countrybirth,
		resident.countryname as countryresident,
		citizen.countryname as countrycitizen
		<!----
        birth_country as countrybirth,
        residence_country as countryresident,
        citizen_country as countrycitizen ---->
	FROM 	
    	extra_candidates
	LEFT JOIN 
    	smg_countrylist birth ON extra_candidates.birth_country = birth.countryid
	LEFT JOIN 
    	smg_countrylist resident ON extra_candidates.residence_country = resident.countryid
	LEFT JOIN 
    	smg_countrylist citizen ON extra_candidates.citizen_country = citizen.countryid
	WHERE 
    	verification_received IS NULL
    AND 
    	companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="7">
    AND 
    	status = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
    AND 
    	intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.intrep#">
    AND 
        ( 
            <cfloop list="#form.programid#" index="prog">
                programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#prog#">
                <cfif NOT LIstLast(form.programid) EQ prog> OR </cfif>
            </cfloop> 
        )  
    AND 
    	(
        	ds2019 = '' 
        OR
            ds2019 is null
        )
    <!---
	AND 
		onhold_approved <= '4'
	--->
	ORDER BY 
    	lastname
</cfquery>

<!-----Intl. Rep.----->
<cfquery name="int_Agent" datasource="MySQL">
	select 
    	companyid, 
        businessname, 
        fax, 
        email
	from 
    	smg_users 
	where 
    	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.intrep#">
</cfquery>

<link rel="stylesheet" href="reports.css" type="text/css">

<style type="text/css">
<!--
.style1 { 
	font-family: Arial, Helvetica, sans-serif;
	font-size: 10; 	}
.thin-border-bottom { 
    border-bottom: 1px solid #000000; }
.thin-border{ border: 1px solid #000000;}
-->
</style>
<table width=100% align="center" border=0 bgcolor="FFFFFF">

<cfoutput>
  <tr>
	<td  valign="top" width=90><span id="titleleft">
		<span class="style1">TO:<br>
		FAX:<br>
		E-MAIL:<br />
		FROM:<br>
		<br>
		<br>		
		<!---Today's Date:<br>--->
        </span></td>
	<td  valign="top" class="style1"><span id="titleleft">
		<cfif len(#int_agent.businessname#) gt 40>#Left(int_agent.businessname,40)#..</font></a><cfelse>#int_agent.businessname#</cfif><br>
		#int_agent.fax#<br>
		<a href="mailto:#int_agent.email#">#int_agent.email#</a><br />
		#companyshort.companyshort#<br>
		<br><br>
		#DateFormat(now(), 'dddd, mmmm dd, yyyy')#<br>	</td>
	<td class="style1"><!---<img src="../../pics/logo/#client.companyid#.gif"  alt="" border="0" align="right">--->
	<img src="http://www.student-management.com/nsmg/pics/ise-logo2.gif" width="80" height="80" />	</td>	
	<td align="right" valign="top" class="style1"> 
		<div align="right"><br>
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
	  <td width=10% valign="top" class="style1"><strong>Program Start Date</strong></td>
	  <td width=10% valign="top" class="style1"><strong>Program End Date </strong></td>
    </tr>
	
	<cfoutput query="get_candidate">
	<tr bgcolor="#iif(get_candidate.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
		<td class="style1" valign="top">#get_candidate.candidateid#</td><td class="style1" valign="top">#get_candidate.lastname#</td><td class="style1" valign="top">#get_candidate.firstname#</td>
		<td class="style1" valign="top">#get_candidate.middlename#</td><td class="style1" valign="top">#get_candidate.sex#</td><td class="style1" valign="top">#DateFormat(get_candidate.dob, 'mm/dd/yyyy')#</td>
		<td class="style1" valign="top">#get_candidate.birth_city#</td><td class="style1" valign="top">#get_candidate.countrybirth#</td><td class="style1" valign="top">#get_candidate.countrycitizen#</td>
		<td class="style1" valign="top" >#get_candidate.countryresident#</td>
		<td class="style1" valign="top"> <!---<cfif get_candidate.wat_vacation_start EQ ''>n/a<cfelse> #DateDiff('ww', get_candidate.wat_vacation_start, get_candidate.wat_vacation_end)# weeks </cfif>--->
		
							#DateFormat(startdate, 'mm/dd/yyy')#</td>
							
		<td class="style1" valign="top"><!---<cfif get_candidate.wat_vacation_start EQ ''>n/a<cfelse>#get_candidate.wat_vacation_start#</cfif>---> 
		
									#DateFormat(enddate, 'mm/dd/yyy')#</td>
	</tr>
	</cfoutput>
</Table>

<cfoutput>
<table width=98% cellpadding=2 cellspacing="0" >
	<tr>
		<td valign="top" class="style1"><div align="justify">
		Please take a look at all the information above. If there's anything wrong or misspelled, please correct it ON THIS FORM and return it to us dated and signed.<br /><br /><br /><br />
		</div></td></tr>
	<tr>
		
				<table width="300" align="right" class="thin-border" frame="border" cellpadding=2 cellspacing="0">
					<tr><td class="style1"><u>Return check:</u></td></tr>
					<tr><td class="style1"><br><br>Date: ________________________________</td></tr><br />
					<tr><td class="style1"><br />Signature: ____________________________<br />	</td></tr>			
				</table>
	</tr>
</table>
  
  <table><br />
	<tr><td class="style1"><b>Our best regards,</b></td></tr>
	<tr><td class="style1"><b>#companyshort.verification_letter#</b></td></tr>
	<tr>
	  <td class="style1">
      	<b>Sergei Chernyshov<br />
	  	sergei@iseusa.com</b>
      </td>
	</tr>
</table>

</cfoutput>


</div>
</cfdocument>