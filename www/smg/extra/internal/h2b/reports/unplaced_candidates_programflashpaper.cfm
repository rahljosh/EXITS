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
	SELECT c.firstname, c.lastname, c.sex, c.home_country, c.intrep, c.requested_placement, c.programid, smg_programs.programname, smg_users.companyid, smg_users.businessname, c.companyid, c.hostcompanyid, smg_countrylist.countryname, extra_hostcompany.name, c.wat_placement
	FROM extra_candidates c
	INNER JOIN smg_users ON smg_users.userid = c.intrep
	INNER JOIN smg_programs ON smg_programs.programid = c.programid
	INNER JOIN smg_countrylist ON smg_countrylist.countryid = c.home_country
	LEFT JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = c.requested_placement 
		<!--- form parameters --->
	  WHERE c.companyid = #client.companyid#
	  AND c.hostcompanyid = 0<!---#form.companyid# --->
	  AND c.programid = #url.program#


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
<div class="head1">Unplaced Candidates per Program</div>
<img src="../../pics/black_pixel.gif" width="100%" height="2">
<div class="head2">Program: #program_info.programname#</div>
<img src="../../pics/black_pixel.gif" width="100%" height="2">
<div class="head3">Total Number Candidates:#get_candidates.recordcount#</div>
<img src="../../pics/black_pixel.gif" width="100%" height="2">
				 <Table width=100% frame=below cellpadding=7 cellspacing="0" class="thin-border-bottom" >
				<tr class="thin-border-bottom" >
				  
      <Th align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" >Candidate</font></Th>
      <th align="left" ><font size="2" face="Verdana, Arial, Helvetica, sans-serif" >Sex</font></th>
      <th align="left" ><font size="2" face="Verdana, Arial, Helvetica, sans-serif" >Country</font></th>
      <th align="left" ><font size="2" face="Verdana, Arial, Helvetica, sans-serif" >Req. Placement </font></th>
      <th align="left" ><font size="2" face="Verdana, Arial, Helvetica, sans-serif" >Intl. Rep.</font></th>
    </tr>	  
 
 	 <cfloop query="get_candidates">
			<tr bgcolor="#iif(get_candidates.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
		
	
				 
					<td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#firstname# #lastname#</font></td>
					<td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#sex#</font></td>
					<td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#countryname#</font></td>
					<td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#name#</font></td>
					<td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#businessname#</font></td>
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