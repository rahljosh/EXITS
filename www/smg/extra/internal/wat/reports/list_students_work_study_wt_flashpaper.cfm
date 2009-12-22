<cfdocument format="#url.format#" orientation="landscape" backgroundvisible="yes" overwrite="no" fontembed="yes">
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
<!---<cfif IsDefined('url.program')>---->
<cfquery name="get_students" datasource="mysql">
	SELECT c.candidateid, c.firstname, c.lastname, c.dob, c.citizen_country, c.ds2019, c.companyid, c.hostcompanyid, smg_countrylist.countryname, extra_hostcompany.name, c.home_address cadress, extra_hostcompany.address, smg_countrylist.countryname, c.wat_participation, extra_hostcompany.address as hostcompany_address, extra_hostcompany.city as hostcompany_city, extra_hostcompany.state, extra_hostcompany.zip as hostcompany_zip, smg_states.state as hostcompany_state, c.status
	FROM extra_candidates c
	INNER JOIN smg_programs ON smg_programs.programid = c.programid
	INNER JOIN smg_countrylist ON smg_countrylist.countryid = c.citizen_country
	LEFT JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = c.hostcompanyid
	LEFT JOIN smg_states ON smg_states.id = extra_hostcompany.state
		<!--- form parameters --->
	  WHERE c.companyid = 8
	  AND c.status <> 'canceled'
      AND c.ds2019 <> ''
	  AND c.programid = #url.program#
	<!---  AND c.programid = #form.program#---->
	ORDER BY c.ds2019
	</cfquery>
<!----</cfif>---->

<!----<cfquery name="program_info" datasource="mysql">
	select programname
	from smg_programs
	where programid = #url.program#
</cfquery> --->
<!---
<cfquery name="host_company_info" datasource="mysql">
	select name
	from extra_hostcompany
	where hostcompanyid = #url.companyid#
</cfquery> 
---->

<!-----
<cfquery name="get_candidates_self" datasource="MySql">
  SELECT extra_candidates.firstname, extra_candidates.lastname, extra_candidates.placedby, extra_candidates.sex, extra_candidates.hostcompanyid, extra_hostcompany.name, smg_programs.startdate, smg_programs.enddate, extra_candidates.ds2019, extra_candidates.wat_vacation_start, extra_candidates.wat_vacation_end
  FROM extra_candidates
  INNER JOIN smg_programs ON smg_programs.programid = extra_candidates.programid
	INNER JOIN smg_countrylist ON smg_countrylist.countryid = extra_candidates.citizen_country
	LEFT JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = extra_candidates.hostcompanyid
 WHERE extra_candidates.companyid = 8 AND wat_placement = 'self'
</cfquery>
--------->
<cfoutput>

<img src="../../pics/black_pixel.gif" width="100%" height="2">

<div class="head1">List of Students (Work Study)</div>
<img src="../../pics/black_pixel.gif" width="100%" height="2">
<!----<div class="head2">Program: #program_info.programname#</div>
<img src="../../pics/black_pixel.gif" width="100%" height="2">--->
<div class="head3"> <strong>Number of Students: #get_students.recordcount# </strong> </div>
<!------
<div class="head3">  <strong><font size="1" face="Verdana, Arial, Helvetica, sans-serif"> Self-Placement:</strong> #get_candidates_self.recordcount#</font></div>
<div class="head3">  <strong><font size="1" face="Verdana, Arial, Helvetica, sans-serif"> CSB-Placement:</strong> #get_students.recordcount#</font></div>------->
<img src="../../pics/black_pixel.gif" width="100%" height="2">
					
					
							

					
  <table width=100% cellpadding="4" cellspacing=0>
    <tr>
      <Th align="left"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" >Student name</font></Th>
      <th align="left" ><font size="1" face="Verdana, Arial, Helvetica, sans-serif" >Date of Birth</font></th>
      <th align="left" ><font size="1" face="Verdana, Arial, Helvetica, sans-serif" >Citizenship</font></th>
      <th align="left" ><font size="1" face="Verdana, Arial, Helvetica, sans-serif" >DS2019</font></th>
      <th align="left" ><font size="1" face="Verdana, Arial, Helvetica, sans-serif" >No. Part. </font></th>
      <th align="left" ><font size="1" face="Verdana, Arial, Helvetica, sans-serif" >Company</font></th>
      <th align="left" ><font size="1" face="Verdana, Arial, Helvetica, sans-serif" >Address </font></th>
    </tr>

				
					  
			  

				<cfloop query="get_students">
			
	
				
				 <tr <cfif get_students.currentrow mod 2>bgcolor="E4E4E4"</cfif>>
					<td><font size="1" face="Verdana, Arial, Helvetica, sans-serif">#firstname# #lastname# (#candidateid#)</font></td>
					<td><font size="1" face="Verdana, Arial, Helvetica, sans-serif">#DateFormat(dob, 'mm/dd/yyyy')#</font></td>
					<td><font size="1" face="Verdana, Arial, Helvetica, sans-serif">#countryname#</font></td>
					<td><font size="1" face="Verdana, Arial, Helvetica, sans-serif">#ds2019#</font></td>
					<td><font size="1" face="Verdana, Arial, Helvetica, sans-serif"><cfif #wat_participation# eq ''>0<cfelse>#wat_participation#</cfif></font></td>
					<td><font size="1" face="Verdana, Arial, Helvetica, sans-serif">#name#</font></td>
					<td><font size="1" face="Verdana, Arial, Helvetica, sans-serif"><cfif hostcompany_address NEQ ''>#hostcompany_address#, #hostcompany_city#, #hostcompany_state# - #hostcompany_zip# </cfif></font></td>															
				  </tr>
				</cfloop>
			  </table>
			  
				<img src="../../pics/black_pixel.gif" width="100%" height="2">
				<Br><br>
				<font size=-1>Report Prepared on #DateFormat(now(), 'dddd, mmm, d, yyyy')#</font>
</cfoutput>
</cfdocument>