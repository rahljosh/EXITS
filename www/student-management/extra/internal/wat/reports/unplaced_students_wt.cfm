<cfif IsDefined('FORM.program')>

	<cfquery name="qGetCandidates" datasource="mysql">
        SELECT 
            c.uniqueID, 
            c.programid,
            c.candidateid, 
            c.companyid, 
            c.hostcompanyid, 
            c.firstname, 
            c.lastname, 
            c.sex, 
            c.home_country, 
            c.intrep, 
            c.requested_placement, 
            c.wat_placement, 
            c.wat_placement, 
            c.change_requested_comment, 
            c.englishAssessment,
            c.englishAssessmentComment,        
            u.companyid, 
            u.businessname, 
            p.programname, 
            cl.countryname, 
            eh.name 
        FROM 
        	extra_candidates c
        INNER JOIN 
        	smg_users u ON u.userid = c.intrep
        INNER JOIN 
        	smg_programs p ON p.programid = c.programid
        INNER JOIN 
        	smg_countrylist cl ON cl.countryid = c.home_country
        LEFT JOIN
        	extra_hostcompany eh ON eh.hostcompanyid = c.requested_placement 
        WHERE 
        	c.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
        AND 
        	c.hostcompanyid = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
        AND 
        	c.programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.program#">
        AND 
        	c.status = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND 
        	c.wat_placement = <cfqueryparam cfsqltype="cf_sql_varchar" value="CSB-Placement">
        ORDER BY 
        	u.businessname
	</cfquery>
	
	<cfquery name="qGetCandidatesSelf" datasource="mysql">
        SELECT 
            c.uniqueID, 
            c.programid,
            c.candidateid, 
            c.companyid, 
            c.hostcompanyid, 
            c.firstname, 
            c.lastname, 
            c.sex, 
            c.home_country, 
            c.intrep, 
            c.requested_placement, 
            c.wat_placement, 
            c.wat_placement, 
            c.change_requested_comment, 
            c.englishAssessment,
            c.englishAssessmentComment,        
            u.companyid, 
            u.businessname, 
            p.programname, 
            cl.countryname, 
            eh.name 
        FROM 
        	extra_candidates c
        INNER JOIN 
        	smg_users u ON u.userid = c.intrep
        INNER JOIN 
        	smg_programs p ON p.programid = c.programid
        INNER JOIN 
        	smg_countrylist cl ON cl.countryid = c.home_country
        LEFT JOIN
        	extra_hostcompany eh ON eh.hostcompanyid = c.requested_placement 
        WHERE 
        	c.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
        AND 
        	c.hostcompanyid = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
        AND 
        	c.programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.program#">
        AND 
        	c.status = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND 
        	c.wat_placement = <cfqueryparam cfsqltype="cf_sql_varchar" value="Self-Placement">
        ORDER BY 
        	u.businessname
	</cfquery>
	
	<cfset total = qGetCandidatesSelf.recordcount + qGetCandidates.recordcount>
</cfif>

<cfscript>
	// Get Program List
	qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms(companyID=CLIENT.companyID);
</cfscript>

<cfoutput>

<form action="index.cfm?curdoc=reports/unplaced_students_wt" method="post">
<table width="95%" cellpadding="4" cellspacing="0" border="0" align="center">
  <tr valign="middle" height="24">
    <td valign="middle" bgcolor="##E4E4E4" class="title1" colspan=2>
        <font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp; Program Reports -> List of Unplaced Candidates</font>
    </td>
  </tr>
  	
  <tr valign="middle">
  	<tr valign="middle" height="24">
    	<td valign="middle" colspan=2> <script language="JavaScript" type="text/javascript"> 
		<!-- Begin
		function formHandler2(form){
		var URL = document.formagent.agent.options[document.formagent.agent.selectedIndex].value;
		window.location.href = URL;
		}
		// End -->
    </script></td>
  	</tr>

    <tr>
    <td valign="middle" align="right" class="style1">Program: </td><td> 
	<select name="program" class="style1">
		<option></option>
		<cfloop query="qGetProgramList">
		<option value=#programid# <cfif IsDefined('FORM.program')><cfif qGetProgramList.programid eq #FORM.program#> selected</cfif></cfif>>#programname#</option>
		</cfloop>
	</select>
	
	 </td>
  
  </tr>

  <Tr>
  	<td align="right" class="style1">Format: </td>
	<td class="style1"> <input type="radio" class="style1" name="print" value=0 checked>  Onscreen (View Only) <input type="radio" name="print" value=1> Print (FlashPaper) 
  </Tr>
  <tr>
  	<td colspan=2 align="center"><br />
<input type="submit" value="Generate Report" class="style1" /><br />
<br />
</td>
  </tr>
</table>

<br>


<!-----Display Reports---->

<cfif isDefined('FORM.print')>
	<cfif FORM.print eq 1>
		<span class="style1"><center><b>Results are being generated...</b></center></span><br /><br /><br />		
		<meta http-equiv="refresh" content="1;url=index.cfm?curdoc=reports/unplaced_students_wt_flashpaper&program=#FORM.program#">
	<cfelse>

<!--- <cfquery name="get_wat_placement" datasource="mysql">
	SELECT wat_placement, count(wat_placement) AS total
	FROM extra_candidates
	WHERE active = 1 
	AND companyid = 8
	AND hostcompanyid = 0
	AND status = 1
	AND active = 1
	GROUP BY wat_placement
</cfquery> --->


<div class="style1"><strong>&nbsp; &nbsp; CSB-Placement:</strong> #qGetCandidates.recordcount#</div>	
<div class="style1"><strong>&nbsp; &nbsp; Self-Placement:</strong> #qGetCandidatesSelf.recordcount#</div>
<div class="style1"><strong>&nbsp; &nbsp; ----------------------------------</strong></div>
<div class="style1"><strong>&nbsp; &nbsp; Total Number Students:</strong> #total#</div>
<div class="style1"><strong>&nbsp; &nbsp; ----------------------------------</strong></div>

<!--- <cfloop query="get_wat_placement">
<strong><font size="2" face="Verdana, Arial, Helvetica, sans-serif" >Students #wat_placement#:  #total# </font></strong>
<br />
</cfloop>
<strong><font size="2" face="Verdana, Arial, Helvetica, sans-serif" >Total Number of Students: #qGetCandidates.recordcount# </font></strong><br /> --->

<img src="../../pics/black_pixel.gif" width="100%" height="2">
					
  <table width=100% cellpadding="4" cellspacing=0>
  <tr>
      <Th align="left" bgcolor="##4F8EA4" class="style2">Student</Th>
      <th align="left" bgcolor="##4F8EA4" class="style2">Sex</th>
      <th align="left" bgcolor="##4F8EA4" class="style2">Country</th>
      <th align="left" bgcolor="##4F8EA4" class="style2">Skype ID</th>
      <th align="left" bgcolor="##4F8EA4" class="style2">Req. Placement</th>
      <th align="left" bgcolor="##4F8EA4" class="style2">Comments</th>
      <th align="left" bgcolor="##4F8EA4" class="style2">English Assessment CSB</th>
      <th align="left" bgcolor="##4F8EA4" class="style2">English Assessment Comment</th>
	  <th align="left" bgcolor="##4F8EA4" class="style2">Intl. Rep.</th>
	  <th align="left" bgcolor="##4F8EA4" class="style2">Option</th>
    </tr>	

	 <img src="../../pics/black_pixel.gif" width="100%" height="2">
				
		  <cfif qGetCandidates.recordcount eq 0 AND qGetCandidatesSelf.recordcount eq 0 >
			<tr><td align="center" colspan=10> <div align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">No students found based on the criteria you specified. Please change and re-run the report.</font></div><br />
</td></tr>
			  <cfelse>  
				<cfset into = 1 >
				<cfloop query="qGetCandidates">
                	
				 <tr <cfif into mod 2>bgcolor="##E4E4E4"</cfif>>
					<td class="style1">
                    	<a href="?curdoc=candidate/candidate_info&uniqueid=#qGetCandidates.uniqueID#" target="_blank" class="style4">
                    		#firstname# #lastname# (#candidateid#)
						</a>
                    </td>
					<td class="style1">#sex#</td>
					<td class="style1">#countryname#</td>
                    <td class="style1">#APPLICATION.CFC.ONLINEAPP.getAnswerByFilter(sectionName='section1', foreignTable=APPLICATION.foreignTable, foreignID=qGetCandidates.candidateID, applicationQuestionID=27).answer#</td>
					<td class="style1">#name#</td>
					<td class="style1">#change_requested_comment#</td>
                    <td class="style1">#englishAssessment#</td>
                    <td class="style1">#englishAssessmentComment#</td>
                    <td class="style1">#businessname#</td>
					<td class="style1">#wat_placement#</td>                    
				  </tr>
				  <cfset into = into + 1 >
				</cfloop>
				
				<cfloop query="qGetCandidatesSelf">
				 <tr <cfif into mod 2>bgcolor="##E4E4E4"</cfif>>
					<td class="style1">
                    	<a href="?curdoc=candidate/candidate_info&uniqueid=#qGetCandidatesSelf.uniqueID#" target="_blank" class="style4">
	                    	#firstname# #lastname# (#candidateid#)
    					</a>
                    </td>
					<td class="style1">#sex#</td>
					<td class="style1">#countryname#</td>
					<td class="style1">#name#</td>
                    <td class="style1">#change_requested_comment#</td>
					<td class="style1">#englishAssessment#</td>
                    <td class="style1">#englishAssessmentComment#</td>
                    <td class="style1">#businessname#</td>
					<td class="style1">#wat_placement#</td>
				  </tr>		
				  <cfset into = into + 1 >	  
				</cfloop>
				
			  </table>
			  <img src="../../pics/black_pixel.gif" alt="." width="100%" height="2"> <Br>
			  <br>
			  <span class="style1">Report Prepared on #DateFormat(now(), 'dddd, mmm, d, yyyy')#</span>
			  </cfif>
			  
		</cfif>
<cfelse>
<div align="center" class="style1">Print resutls will replace the menu options and take a bit longer to generate.<br /> Onscreen will allow you to change criteria with out clicking your back button.</div>
</cfif>
	
</cfoutput>