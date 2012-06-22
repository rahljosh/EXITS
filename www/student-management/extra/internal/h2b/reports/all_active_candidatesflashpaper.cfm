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
  SELECT *
  <!----extra_candidates.firstname, extra_candidates.lastname, extra_candidates.placedby, extra_candidates.sex, extra_candidates.hostcompanyid, extra_hostcompany.name, smg_programs.startdate, smg_programs.enddate, extra_candidates.ds2019, extra_candidates.programid, extra_candidates.companyid---->
  FROM extra_candidates
  LEFT JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = extra_candidates.hostcompanyid
  LEFT JOIN smg_programs ON smg_programs.programid = extra_candidates.programid
  LEFT JOIN smg_users ON smg_users.userid = extra_candidates.intrep
  WHERE <!----extra_candidates.hostcompanyid = #form.companyid#
  AND ----->extra_candidates.programid = #url.program#
  AND extra_candidates.intrep = #url.intrep#
and extra_candidates.status = 1


</cfquery>
 

		  <cfquery name="get_int_rep" datasource="MySql">
			SELECT smg_users.businessname, smg_users.userid
            FROM smg_users
			LEFT JOIN user_Access_rights on smg_users.userid = user_access_rights.userid
			where  smg_users.userid = #url.intrep#

        </cfquery>
		

<cfquery name="program_info" datasource="mysql">
select programname
from smg_programs
where programid = #url.program#
</cfquery> 
<!----<cfquery name="host_company_info" datasource="mysql">
select name
from extra_hostcompany
where hostcompanyid = #url.companyid#
</cfquery> ---->
<cfoutput>


<img src="../../pics/black_pixel.gif" width="100%" height="2">
<cfif IsDefined('get_candidates')>
<div class="head1">All active candidates per International Representative and Program </div>
<img src="../../pics/black_pixel.gif" width="100%" height="2">
<div class="head2">Program: #program_info.programname#</div>
<img src="../../pics/black_pixel.gif" width="100%" height="2">
<div class="head3">Int. Rep.: #get_int_rep.businessname#  &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;   Total Number Candidates:#get_candidates.recordcount#</div>
<img src="../../pics/black_pixel.gif" width="100%" height="2">
				 <Table width=100% frame=below cellpadding=7 cellspacing="0" class="thin-border-bottom" >
				<tr class="thin-border-bottom" >
				  
				  <td width=14% valign="top" class="style1"><strong>Candidate</strong></td>
				  <td width=14% valign="top" class="style1"><strong>Placement Information</strong></td>
				  
</tr>				  
 
 	 <cfloop query="get_candidates">
			<tr bgcolor="#iif(get_candidates.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
					
					<td class="style1" valign="top">#firstname# #lastname# (#candidateid#)</td>
					<td class="style1" valign="top">#name#</td>
				

				</tr>
			  </cfloop>
			</table>  
			
			<cfelse>
			No candidates found based on the criteria you specified.
			
	</cfif>		
			
				<img src="../../pics/black_pixel.gif" width="100%" height="2">
				<Br><br>
				<font size=-1>Report Prepared on #DateFormat(now(), 'dddd, mmm, d, yyyy')#</font>
</cfoutput>
</cfdocument>