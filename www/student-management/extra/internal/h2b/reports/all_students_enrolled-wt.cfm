
<cfif IsDefined('url.userid')>
<cfquery name="get_candidates" datasource="MySql">
  SELECT extra_candidates.firstname, extra_candidates.lastname, extra_candidates.placedby, extra_candidates.sex, extra_candidates.hostcompanyid, extra_hostcompany.name, smg_programs.startdate, smg_programs.enddate, extra_candidates.ds2019,
  extra_candidates.wat_vacation_start, extra_candidates.wat_vacation_end
  FROM extra_candidates
  INNER JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = extra_candidates.hostcompanyid
  INNER JOIN smg_programs ON smg_programs.programid = extra_candidates.programid
  INNER JOIN smg_users ON smg_users.userid = extra_candidates.intrep
  WHERE extra_candidates.companyid = #client.companyid#

 AND extra_candidates.intrep = #url.userid#  

</cfquery>
</cfif>




<cfoutput>
  <table width="95%" cellpadding="0" cellspacing="0" border="0" align="center">
    <tr valign="middle" height="24">
      <td width="57%" valign="middle" bgcolor="##E4E4E4" class="title1"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp;Students enrolled in the program </font></td>
      <td width="42%" align="right" valign="top" bgcolor="##E4E4E4" class="style1">&nbsp;</td>
      <td width="1%"></td>
    </tr>
    <tr valign="middle" height="24">
      <td valign="middle" class="title1">&nbsp;</td>
      <td align="right" valign="top" class="style1">&nbsp;</td>
      <td></td>
    </tr>
    <tr valign="middle" height="24">
    <cfquery name="get_program" datasource="MySql">
		SELECT smg_companies.companyid, smg_companies.companyname, smg_companies.companyshort
        FROM smg_companies
        INNER JOIN extra_candidates ON extra_candidates.companyid = smg_companies.companyid
        WHERE smg_companies.companyid = #client.companyid#
    </cfquery>
      <td valign="middle" class="title1"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Program #get_program.companyshort#</font></td>
      <td align="right" valign="top" class="style1">&nbsp;</td>
      <td></td>
    </tr>
    <tr valign="middle" height="24">
      <td valign="middle" class="title1"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Intl. Rep.
        <SCRIPT LANGUAGE="JavaScript"> 
		<!-- Begin
		function formHandler2(form){
		var URL = document.formagent.agent.options[document.formagent.agent.selectedIndex].value;
		window.location.href = URL;
		}
		// End -->
    </SCRIPT>
            <cfquery name="get_agent" datasource="MySql">
			SELECT businessname, userid
            FROM smg_users
        </cfquery>
            <form name="formagent">
              <select name="agent" onChange="javascript:formHandler2()">
                <cfloop query="get_agent">
                  <option value="?curdoc=reports/all_students_enrolled-wt&userid=#get_agent.userid#" <cfif IsDefined('url.userid')><cfif get_agent.userid eq #url.userid#> selected</cfif></cfif>> #get_agent.businessname# </option>
                </cfloop>
              </select>
            </form>
      </font></td>
      <td align="right" valign="top" class="style1">&nbsp;</td>
      <td></td>
    </tr>
    <tr valign="middle" height="24">
      <td valign="middle" class="title1"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">
      				<cfif IsDefined('url.userid') >Total No of Students #get_candidates.recordcount# </font></cfif></td>
      <td align="right" valign="top" class="style1">&nbsp;</td>
      <td></td>
    </tr>
  </table>
</cfoutput><br />

 <cfif NOT IsDefined('url.userid') >
  	<font size="2" face="Verdana, Arial, Helvetica, sans-serif">Choose an Intl. Rep.<br> </font>
  <cfelseif get_candidates.recordcount eq 0 >
  <font size="2" face="Verdana, Arial, Helvetica, sans-serif">	No students </font>
  <cfelse>
  

<table border="0" cellpadding="4" cellspacing="0" class="section" align="center" width="95%">
  <tr>
    <th width="315" align="left"  bgcolor="#4F8EA4"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#FFFFFF">Student</font></span></th>
    <th width="348" align="left" bgcolor="#4F8EA4"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#FFFFFF">Sex </font></span></th>
    <th width="262" align="left"  bgcolor="#4F8EA4"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#FFFFFF">Self</font></span></th>
    <th width="262" align="left"  bgcolor="#4F8EA4"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#FFFFFF">Lenght</font></span></th>
    <th width="262" align="left"  bgcolor="#4F8EA4"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#FFFFFF">Placement Information</font></span></th>
    <th width="262" align="left"  bgcolor="#4F8EA4"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#FFFFFF">DS2019</font></span></th>
  </tr>
  <cfoutput query="get_candidates">
    <tr>
      <th align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#firstname# #lastname#</font></th>
      <th align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#sex#</font></th>
      <th align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><cfif placedby eq 'self'>X<cfelse> </cfif></font></th>
      <th align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"> <!---#DateDiff('ww', startdate, enddate)# ---> <cfif wat_vacation_start EQ ''>n/a<cfelse> #DateDiff('ww', wat_vacation_start, wat_vacation_end)# weeks</cfif></font></th>
      <th align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#name#</font></th>
      <th align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#ds2019#</font></th>
    </tr>
  </cfoutput>
</table>
</cfif>
</body>
</html>
