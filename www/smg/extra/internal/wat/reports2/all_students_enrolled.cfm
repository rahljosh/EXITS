<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>All Students Enroolled in the Program</title>

</head>
<cfif IsDefined('url.userid')>
<cfquery name="get_candidates" datasource="MySql">
  SELECT extra_candidates.firstname, extra_candidates.lastname, extra_candidates.sex, extra_candidates.hostcompanyid, extra_hostcompany.name, extra_candidates.intrep, smg_users.userid, smg_users.businessname
  FROM extra_candidates
  INNER JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = extra_candidates.hostcompanyid
  INNER JOIN smg_users ON smg_users.userid = extra_candidates.intrep
  WHERE extra_candidates.companyid = #client.companyid#
  AND extra_candidates.intrep = #url.userid#  

</cfquery>
</cfif>
<body>
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
      <td valign="middle" class="title1"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Agent 
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

                <option value="?curdoc=reports/all_students_enrolled&userid=#get_agent.userid#" <cfif IsDefined('url.userid')><cfif get_agent.userid eq #url.userid#> selected</cfif></cfif>> #get_agent.businessname# </option>
            </cfloop>
          
        </select>
       </form>
      </font></td>
   <!--- <cfdocument format="FlashPaper" orientation="landscape" backgroundvisible="yes" overwrite="no" fontembed="yes">--->
      <td align="right" valign="top" class="style1">&nbsp;</td>
      <td></td>
    </tr>
    <tr valign="middle" height="24">
      <td valign="middle" class="title1"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">
	  				<cfif IsDefined('url.userid') >Total No of Students #get_candidates.recordcount# </cfif></font></td>
      <td align="right" valign="top" class="style1">&nbsp;</td>
      <td></td>
    </tr>
  </table>
  <br />
  
 <cfif NOT IsDefined('url.userid') >
  	<font size="2" face="Verdana, Arial, Helvetica, sans-serif">Choose an Agent <br /> </font>
  <cfelseif get_candidates.recordcount eq 0 >
  <font size="2" face="Verdana, Arial, Helvetica, sans-serif">	No students </font>
  <cfelse>
  
  <table border="0" cellpadding="4" cellspacing="0" class="section" align="center" width="95%">
    <tr>
      <th width="315" align="left"  bgcolor="##4F8EA4"><span class="style2"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Student</font></span></th>
      <th width="348" align="left" bgcolor="##4F8EA4"><span class="style2"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Sex </font></span></th>
      <th width="262" align="left"  bgcolor="##4F8EA4"><span class="style2"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Placement Information</font></span></th>
    </tr>
    <tr>
	
      <th align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#get_candidates.firstname# #get_candidates.lastname#</font></th>
      <th align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#get_candidates.sex#</font></th>
      <th align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#get_candidates.name#</font></th>
    </tr>

  </table>
  
  
  <br />
 </cfif>

<!--- </cfdocument> ---->
</cfoutput>

</body>
</html>
