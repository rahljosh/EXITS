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

<cfquery name="get_candidates" datasource="MySql">
  SELECT extra_candidates.firstname, extra_candidates.lastname, extra_candidates.placedby, extra_candidates.sex, extra_candidates.hostcompanyid, extra_hostcompany.name, smg_programs.startdate, smg_programs.enddate, extra_candidates.ds2019, extra_candidates.programid, extra_candidates.companyid
  FROM extra_candidates
  INNER JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = extra_candidates.hostcompanyid
  INNER JOIN smg_programs ON smg_programs.programid = extra_candidates.programid
  INNER JOIN smg_users ON smg_users.userid = extra_candidates.intrep
  WHERE extra_candidates.companyid = #client.companyid#

 AND extra_candidates.intrep = #url.companyid#  
 AND extra_candidates.programid = #url.program#


</cfquery>

<!---
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
  
</cfquery> --->
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
<div class="head3">Company: #host_company_info.name#  &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;   Total Number Candidates:#get_candidates.recordcount#</div>
<img src="../../pics/black_pixel.gif" width="100%" height="2">
						<table border="0" cellpadding="4" cellspacing="0" class="section" align="center" width="95%">
  <tr>
    <th width="315" align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Student</font></span></th>
    <th width="348" align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Sex </font></span></th>
    <th width="262" align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Self</font></span></th>
    <th width="262" align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Lenght</font></span></th>
    <th width="262" align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Placement Information</font></span></th>
    <th width="262" align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">DS2019</font></span></th>
  </tr>
 
 	 <cfloop query="get_candidates">
				<tr>
				  <th align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#firstname# #lastname#</font></th>
				  <th align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#sex#</font></th>
				  <th align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><cfif placedby eq 'self'>X<cfelse> </cfif></font></th>
				  <th align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"> #DateDiff('ww', startdate, enddate)# weeks</font></th>
				  <th align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#name#</font></th>
				  <th align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#ds2019#</font></th>
				</tr>
			  </cfloop>
  </table>
			
			
				<img src="../../pics/black_pixel.gif" width="100%" height="2">
				<Br><br>
				<font size=-1>Report Prepared on #DateFormat(now(), 'dddd, mmm, d, yyyy')#</font>
</cfoutput>
</cfdocument>