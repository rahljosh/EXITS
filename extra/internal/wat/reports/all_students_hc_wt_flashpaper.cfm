<cfdocument format="FlashPaper" orientation="portrait" backgroundvisible="yes" overwrite="no" fontembed="yes">
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
body{font-size:10px;}

-->

</style>

<cfquery name="get_candidates" datasource="MySql">
  SELECT extra_candidates.firstname, extra_candidates.lastname, extra_candidates.placedby, extra_candidates.sex, extra_candidates.hostcompanyid, extra_hostcompany.name, smg_programs.startdate, smg_programs.enddate, extra_candidates.ds2019, extra_candidates.wat_vacation_start, extra_candidates.wat_vacation_end, extra_candidates.dob, extra_candidates.candidateid, extra_candidates.intrep, extra_candidates.wat_placement, extra_candidates.candidateid
  FROM extra_candidates
  LEFT JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = extra_candidates.hostcompanyid
  INNER JOIN smg_programs ON smg_programs.programid = extra_candidates.programid
  INNER JOIN smg_users ON smg_users.userid = extra_candidates.intrep
  WHERE extra_candidates.hostcompanyid = #url.companyid#
 AND extra_candidates.programid = #url.program#  and extra_candidates.cancel_date <> 'null'

</cfquery>

<cfquery name="get_candidates_self" datasource="MySql">
 SELECT extra_candidates.firstname, extra_candidates.lastname, extra_candidates.placedby, extra_candidates.sex, extra_candidates.hostcompanyid, extra_hostcompany.name, smg_programs.startdate, smg_programs.enddate, extra_candidates.ds2019, extra_candidates.wat_vacation_Start, extra_candidates.wat_vacation_end
	  FROM extra_candidates
	  INNER JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = extra_candidates.hostcompanyid
	  INNER JOIN smg_programs ON smg_programs.programid = extra_candidates.programid
	  INNER JOIN smg_users ON smg_users.userid = extra_candidates.intrep
<!---	  WHERE extra_candidates.hostcompanyid = #form.companyid# --->
	  WHERE extra_candidates.hostcompanyid = #url.companyid#
	
	 AND extra_candidates.programid = #url.program# and extra_candidates.cancel_date <> 'null'
	 AND extra_candidates.placedby = 'self'
</cfquery>




<cfquery name="program_info" datasource="mysql">
select programname
from smg_programs
where programid = #url.program#
</cfquery> 

 <cfquery name="get_intrep" datasource="MySql">
 <!----
			SELECT intrep, smg_users.businessname, smg_users.usertype, smg_users.active
			FROM extra_candidates
			INNER JOIN smg_users ON smg_users.userid = extra_candidates.intrep
			WHERE smg_users.usertype = 8
			AND smg_users.active = 1
			AND intrep = #url.intrep#
 ---->
 	SELECT userid as intrep, businessname
	FROM smg_users
	WHERE usertype = 8
	AND userid = #url.intrep# 
	ORDER BY businessname

				
</cfquery>


<cfset not_self = #get_candidates_self.recordcount# - #get_candidates.recordcount#>
<cfoutput>


<img src="../../pics/black_pixel.gif" width="100%" height="2">

<div class="head1">All active students enrolled in the program by Int. Rep. and Program</div>
<img src="../../pics/black_pixel.gif" width="100%" height="2">
<div class="head2"><strong>Program:</strong> #program_info.programname#</div>

<div class="head3"><strong>Int. Rep.:</strong> #get_intrep.businessname# </div>
<div class="head3">  <strong>Total Number of Students:</strong> #get_candidates.recordcount#</div>
<div class="head3">  <strong>Self-Placement:</strong> #get_candidates_self.recordcount#</div>
<div class="head3">  <strong>INTO-Placement:</strong> #get_candidates.recordcount#</div>
<img src="../../pics/black_pixel.gif" width="100%" height="2">
						<table width=100% cellpadding="4" cellspacing=0> 
  <tr>
    <th  align="left" ><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Student</font></span></th>
    <th  align="left" ><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Sex </font></span></th>
    <th  align="left" ><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Start Date</font></span></th>
    <th  align="left" ><font size="2" face="Verdana, Arial, Helvetica, sans-serif" >End Date</font></span></th>
    <th  align="left" ><font size="2" face="Verdana, Arial, Helvetica, sans-serif" >Placement Information</font></span></th>
    <th  align="left" ><font size="2" face="Verdana, Arial, Helvetica, sans-serif">DS2019</font></span></th>
    <th  align="left" ><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Option</font></span></th>	
  </tr>

  <tr>
  	<td colspan=6><img src="../../pics/black_pixel.gif" width="100%" height="2"></td>
  </tr>
				
				

			  
			  

				<cfloop query="get_candidates">
     <tr>
      <th align="left" ><font size="1" face="Verdana, Arial, Helvetica, sans-serif">#firstname# #lastname# (#candidateid#)</font></th>
      <th align="left" ><font size="1" face="Verdana, Arial, Helvetica, sans-serif">#sex#</font></th>
      <th align="left" ><font size="1" face="Verdana, Arial, Helvetica, sans-serif">#DateFormat(startdate, 'mm/dd/yyyy')#</font></th>
      <th align="left" ><font size="1" face="Verdana, Arial, Helvetica, sans-serif">#DateFormat(enddate, 'mm/dd/yyyy')#</font></th>
      <th align="left" ><font size="1" face="Verdana, Arial, Helvetica, sans-serif">#name#</font></th>
      <th align="left" ><font size="1" face="Verdana, Arial, Helvetica, sans-serif">#ds2019#</font></th>
	  <th align="left" ><font size="1" face="Verdana, Arial, Helvetica, sans-serif">#wat_placement#</font></th>
    </tr>
			</cfloop>
				</table>
				<img src="../../pics/black_pixel.gif" width="100%" height="2">
				<Br><br>
				<font size=-1>Report Prepared on #DateFormat(now(), 'dddd, mmm, d, yyyy')#</font>
				</cfoutput>
</cfdocument>