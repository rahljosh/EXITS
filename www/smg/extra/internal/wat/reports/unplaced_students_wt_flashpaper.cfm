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
<cfif IsDefined('url.program')>
	<cfquery name="get_students" datasource="mysql">
	SELECT c.firstname, c.lastname, c.sex, c.home_country, c.intrep, c.status, c.requested_placement, c.programid, smg_programs.programname, smg_users.companyid, smg_users.businessname, c.companyid, c.hostcompanyid, smg_countrylist.countryname, extra_hostcompany.name, c.wat_placement, c.candidateid
	FROM extra_candidates c
	INNER JOIN smg_users ON smg_users.userid = c.intrep
	INNER JOIN smg_programs ON smg_programs.programid = c.programid
	INNER JOIN smg_countrylist ON smg_countrylist.countryid = c.home_country
	LEFT JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = c.requested_placement 
<!---	INNER JOIN extra_hostcompany ON extra_hostcompany.companyid = c.hostcompanyid --->
		<!--- form parameters --->
	  WHERE c.companyid = #client.companyid#
	  AND c.hostcompanyid = 0
	  AND c.programid = #url.program#
	  AND c.status = 1
	  ORDER BY businessname
	</cfquery>
	</cfif>
<cfquery name="program_info" datasource="mysql">
select programname
from smg_programs
where programid = #url.program#
</cfquery> 

<cfquery name="host_company_info" datasource="mysql">
select name
from extra_hostcompany
where hostcompanyid = 0
</cfquery> 
<cfoutput>


<img src="../../pics/black_pixel.gif" width="100%" height="2">

<div class="head1">Unplaced students - for self and into placement</div>
<img src="../../pics/black_pixel.gif" width="100%" height="2">
<div class="head2">Program: #program_info.programname#</div>
<img src="../../pics/black_pixel.gif" width="100%" height="2">

<cfquery name="get_wat_placement" datasource="mysql">
	SELECT wat_placement, count(wat_placement) AS total
	FROM extra_candidates
	WHERE active = 1 
	AND companyid = 8
	AND hostcompanyid = 0
	AND status = 1
	GROUP BY wat_placement
</cfquery>


<cfloop query="get_wat_placement">
<font size="2" face="Verdana, Arial, Helvetica, sans-serif" >Students #wat_placement#:  #total# </font>
<br />
</cfloop>
<font size="2" face="Verdana, Arial, Helvetica, sans-serif" >Total of Students: #get_students.recordcount# </font><br />

<img src="../../pics/black_pixel.gif" width="100%" height="2">
					
					
							
  <table width=100% cellpadding="4" cellspacing=0>
    <tr>
      <Th align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" >Student</font></Th>
      <th align="left" ><font size="2" face="Verdana, Arial, Helvetica, sans-serif" >Sex</font></th>
      <th align="left" ><font size="2" face="Verdana, Arial, Helvetica, sans-serif" >Country</font></th>

      <th align="left" ><font size="2" face="Verdana, Arial, Helvetica, sans-serif" >Requested Placement </font></th>
      <th align="left" ><font size="2" face="Verdana, Arial, Helvetica, sans-serif" >Intl. Rep.</font></th>
	  <th align="left" ><font size="2" face="Verdana, Arial, Helvetica, sans-serif" >Option </font></th>	  
    </tr>
 
				
					  
			  

				<cfloop query="get_students">
			
			
			 <tr <cfif get_students.currentrow mod 2>bgcolor="##E4E4E4"</cfif>>
					<td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#firstname# #lastname# (#candidateid#)</font></td>
					<td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#sex#</font></td>
					<td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#countryname#</font></td>

					<td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#name#</font></td>
					<td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#businessname#</font></td>					
					<td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#wat_placement# <!---len('wat_placement', 4)# ---></font></td>
				  </tr>
				  </cfloop>
				<img src="../../pics/black_pixel.gif" width="100%" height="2">
				<Br><br>
				<font size=-1>Report Prepared on #DateFormat(now(), 'dddd, mmm, d, yyyy')#</font>
				</cfoutput>
</cfdocument>