<cfdocument format="PDF" orientation="landscape" backgroundvisible="yes" overwrite="no" fontembed="yes">
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
.style1 { 
	font-family: Arial, Helvetica, sans-serif;
	font-size: 10;
	}
.thin-border-bottom { 
    border-bottom: 1px solid #000000; }
.thin-border{ border: 1px solid #000000;}
-->
</style>
<cfif IsDefined('url.program')>
 <cfquery name="get_candidates_into" datasource="mysql">
	SELECT c.firstname, c.lastname, c.candidateid, c.wat_doc_agreement, c.wat_doc_college_letter, c.wat_doc_passport_copy, c.wat_placement,
	c.wat_doc_job_offer, c.wat_doc_orientation, smg_users.companyid, smg_users.businessname, c.wat_placement,
	extra_hostcompany.name as companyname
	
	FROM extra_candidates c
	INNER JOIN smg_programs ON smg_programs.programid = c.programid
	INNER JOIN smg_users ON smg_users.userid = c.intrep
    LEFT JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = c.hostcompanyid
	WHERE c.programid = #url.program#
	AND (c.wat_doc_agreement = 0 OR c.wat_doc_college_letter = 0 OR
	     c.wat_doc_passport_copy = 0 OR c.wat_doc_job_offer = 0 OR c.wat_doc_orientation = 0)
	AND c.active = 1
	AND c.wat_placement = 'CSB-Placement'	
	ORDER BY smg_users.businessname, c.firstname
 </cfquery>
 
 <cfquery name="get_candidates_self" datasource="mysql">
	SELECT c.firstname, c.lastname, c.candidateid, c.wat_doc_agreement, c.wat_doc_college_letter, c.wat_doc_passport_copy, c.wat_placement,
	c.wat_doc_job_offer, c.wat_doc_orientation, smg_users.companyid, smg_users.businessname, c.wat_placement,
	extra_hostcompany.name as companyname
	
	FROM extra_candidates c
	INNER JOIN smg_programs ON smg_programs.programid = c.programid
	INNER JOIN smg_users ON smg_users.userid = c.intrep
    LEFT JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = c.hostcompanyid
	WHERE c.programid = #url.program#
	AND (c.wat_doc_agreement = 0 OR c.wat_doc_college_letter = 0 OR
	     c.wat_doc_passport_copy = 0 OR c.wat_doc_job_offer = 0 OR c.wat_doc_orientation = 0)
	AND c.active = 1
	AND c.wat_placement = 'Self-Placement'	
	ORDER BY smg_users.businessname, c.firstname
 </cfquery>
 
 
<!--- <cfquery name="get_wat_placement" datasource="mysql">
	SELECT c.wat_placement, count(c.wat_placement) AS total
	FROM extra_candidates c
    WHERE c.programid = #url.program#
	AND (c.wat_doc_agreement = 0 OR c.wat_doc_college_letter = 0 OR
	     c.wat_doc_passport_copy = 0 OR c.wat_doc_job_offer = 0 OR c.wat_doc_orientation = 0)
	AND c.active = 1
	GROUP BY wat_placement
</cfquery> --->


SELECT name, extra_hostcompany.hostcompanyid, extra_candidates.candidateid, extra_candidates.uniqueid
	FROM extra_hostcompany
	INNER JOIN extra_candidates ON extra_candidates.hostcompanyid = extra_hostcompany.hostcompanyid
	

</cfif>

   
<cfoutput>


<img src="../../pics/black_pixel.gif" width="100%" height="2">

<strong><font size="4" face="Verdana, Arial, Helvetica, sans-serif" >Missing Documents Report</font></strong><br>


<cfset total = #get_candidates_self.recordcount# + #get_candidates_into.recordcount#>

<div class="style1"><strong>&nbsp; &nbsp; CSB-Placement:</strong> #get_candidates_into.recordcount#</div>	
<div class="style1"><strong>&nbsp; &nbsp; Self-Placement:</strong> #get_candidates_self.recordcount#</div>
<div class="style1"><strong>&nbsp; &nbsp; --------------------------------------------</strong></div>
<div class="style1"><strong>&nbsp; &nbsp; Total Number Students:</strong> #total#</div>
<div class="style1"><strong>&nbsp; &nbsp; --------------------------------------------</strong></div>	

<img src="../../pics/black_pixel.gif" width="100%" height="2">
					
					
							
  <table width=100% cellpadding="4" cellspacing=0>
    <tr>
		<td align="left" class="style1"><b>Agent</b></th>	
   		<td align="left" class="style1"><b>Student</b></Th>
      	<td align="left" class="style1"><b>Missing<font color="FFFFFF">_</font>Documents</b></th>
  		<td align="left" class="style1"><b>Placement Information</b></th>	
      	<td align="left" class="style1"><b>Option</b></th>	      	   
    </tr>

		<cfloop query="get_candidates_into">
			<tr <cfif get_candidates_into.currentrow mod 2>bgcolor="##E4E4E4"</cfif>>
			  	<td class="style1">#businessname#</td>
				<td class="style1">#firstname# #lastname# (#candidateid#)</td>
				<td class="style1"><cfif get_candidates_into.wat_doc_agreement EQ 0>- Agreement<br /></cfif>
					<cfif get_candidates_into.wat_doc_college_letter EQ 0>- College Letter<br /></cfif>
					<cfif get_candidates_into.wat_doc_passport_copy EQ 0>- Passport Copy<br /></cfif>
					<cfif get_candidates_into.wat_doc_job_offer EQ 0>- Job Offer<br /></cfif>
					<cfif get_candidates_into.wat_doc_orientation EQ 0>- Orientation Sign Off</cfif></td>		
				<td class="style1">#companyname#</td>
				<td class="style1">CSB-Placement</td>
			</tr>
		</cfloop>
		
		<cfloop query="get_candidates_self">
			<tr <cfif get_candidates_self.currentrow mod 2>bgcolor="##E4E4E4"</cfif>>
			  	<td class="style1">#businessname#</td>
				<td class="style1">#firstname# #lastname# (#candidateid#)</td>
				<td class="style1"><cfif get_candidates_self.wat_doc_agreement EQ 0>- Agreement<br /></cfif>
					<cfif get_candidates_self.wat_doc_college_letter EQ 0>- College Letter<br /></cfif>
					<cfif get_candidates_self.wat_doc_passport_copy EQ 0>- Passport Copy<br /></cfif>
					<cfif get_candidates_self.wat_doc_job_offer EQ 0>- Job Offer<br /></cfif>
					<cfif get_candidates_self.wat_doc_orientation EQ 0>- Orientation Sign Off</cfif></td>		
				<td class="style1">#companyname#</td>
				<td class="style1">Self-Placement</td>
			</tr>
		</cfloop>
	
	</table>

		
		
				<img src="../../pics/black_pixel.gif" width="100%" height="2">
				<Br><br>
				<span class="style1">Report Prepared on #DateFormat(now(), 'dddd, mmm, d, yyyy')#</span>
</cfoutput>

</cfdocument>
