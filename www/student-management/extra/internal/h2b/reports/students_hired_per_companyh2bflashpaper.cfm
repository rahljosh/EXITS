<cfdocument format="FlashPaper" orientation="landscape" backgroundvisible="yes" overwrite="no" fontembed="yes">
<style type="text/css">
<!--
.head1 { 
	font-family: Arial, Helvetica, sans-serif;
	font-size: 25;
	padding:5 ;
	font-weight:300;	}
.head2 { 
	font-family: Arial, Helvetica, sans-serif;
	font-size: 20;
	padding:5 ;
	font-weight:300;	}
.head3 { 
	font-family: Arial, Helvetica, sans-serif;
	font-size: 16;
	padding:5 ;
	}
.thin-border-bottom { 
    border-bottom: 1px solid #000000; }
.thin-border{ border: 1px solid #000000;}
-->
</style>
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
  AND c.hostcompanyid = #url.companyid# 
  and c.programid = #url.program#
  
</cfquery>
<cfquery name="program_info" datasource="mysql">
select programname
from smg_programs
where programid = #url.program#
</cfquery> 
<cfquery name="host_company_info" datasource="mysql">
select name
from extra_hostcompany
where hostcompanyid = #url.companyid#
</cfquery> 
<cfoutput>


<img src="../../pics/black_pixel.gif" width="100%" height="2">

<div class="head1">Students hired per company</div>
<img src="../../pics/black_pixel.gif" width="100%" height="2">
<div class="head2">Program: #program_info.programname#</div>
<img src="../../pics/black_pixel.gif" width="100%" height="2">
<div class="head3">Company: #host_company_info.name#  &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;   Total Number Candidates:#students_hired.recordcount#</div>
<img src="../../pics/black_pixel.gif" width="100%" height="2">
						<table width=100% cellpadding="4" cellspacing=0> 
	<tr>
	<Th align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" >Student</font></Th>
	<th align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" >Sex</font></th>
	<th align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" >Country</font></th>
	<th align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" >Email</font></th>
	<th align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" >SSN</font></th>
	<th align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" >Passport</font></th>
	<th align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" >Passport dates </font></th>
	<th align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" >Intl. Rep.</font></th>
	</tr>
<cfloop query="students_hired">
	<tr > <!--- line color: <cfif students_hired.currentrow mod 2>bgcolor="##E4E4E4"</cfif> --->
		<td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#firstname# #lastname#</font></td><td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#sex#</font></td><td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#countryname#</font></td><td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#email#</font></td><td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#ssn#</font></td>
		<td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#passport_number#</font></td>
		<td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#dateformat (passport_date, 'mm/dd/yyyy')# #dateformat (passport_expires, 'mm/dd/yyyy')#</font></td>
		<td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#businessname#</font></td>
	</tr>
</cfloop>
  </table>
				<img src="../../pics/black_pixel.gif" width="100%" height="2">
				<Br><br>
				<font size=-1>Report Prepared on #DateFormat(now(), 'dddd, mmm, d, yyyy')#</font>
				</cfoutput>
</cfdocument>