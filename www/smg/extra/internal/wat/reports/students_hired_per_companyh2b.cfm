<cfif IsDefined('url.userid')>
<cfquery name="students_hired" datasource="mysql">
select c.firstname, c.lastname, c.sex, c.home_country,c.email, c.earliestarrival, c.programid, c.intrep, c.ssn, c.passport_date, c.passport_expires, c.passport_number,
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
  AND c.intrep = #url.userid# 
  
</cfquery> 
</cfif>

<cfoutput>
<!----
<cfdocument format="FlashPaper" orientation="landscape" backgroundvisible="yes" overwrite="no" fontembed="yes">
---->
<!----<cfif students_hired.recordcount eq 0>
<div align = "center">
	Based on your criteria, no results were returned.
</div>
<cfelse> ---->
<!----<Table width=100%>
	<tr>
		<td>
		Report: Students hired per company<br />
		Company: #students_hired.businessname#<br>
		Program: #students_hired.programname#<br>
		<font size=-2> #DateFormat(now(), 'mmm. d, yyyy')# at #TimeFormat(now(), 'h:mm t')# MST</font>
		
		</td>
		<td align="right">
		<img src="http://dev.student-management.com/extra/images/extra-logo.jpg" width=50 height=65>		
		</td>
</Table>--->


<table width="95%" cellpadding="0" cellspacing="0" border="0" align="center">
  <tr valign="middle" height="24">
    <td width="57%" valign="middle" bgcolor="##E4E4E4" class="title1"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp;Students hired per company</font></td>
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
      <script language="JavaScript" type="text/javascript"> 
		<!-- Begin
		function formHandler2(form){
		var URL = document.formagent.agent.options[document.formagent.agent.selectedIndex].value;
		window.location.href = URL;
		}
		// End -->
    </script>
          <cfquery name="get_agent" datasource="MySql">
			SELECT businessname, userid
            FROM smg_users
        </cfquery>
      </font>
        <form name="formagent" id="formagent">
          <font size="2" face="Verdana, Arial, Helvetica, sans-serif">
            <select name="agent" onchange="javascript:formHandler2()">
            <cfloop query="get_agent">
              <option value="?curdoc=reports/students_hired_per_companyh2b&amp;userid=#get_agent.userid#" <cfif IsDefined('url.userid')><cfif get_agent.userid eq #url.userid#> selected</cfif></cfif>> #get_agent.businessname# </option>
            </cfloop>
          </select>
          </font>
        </form></td>
    <!--- <cfdocument format="FlashPaper" orientation="landscape" backgroundvisible="yes" overwrite="no" fontembed="yes">--->
    <td align="right" valign="top" class="style1">&nbsp;</td>
    <td></td>
  </tr>
  <tr valign="middle" height="24">
    <td valign="middle" class="title1"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">
      <cfif IsDefined('url.userid') >
        Total No of Students #students_hired.recordcount#
      </cfif>
    </font></td>
    <td align="right" valign="top" class="style1">&nbsp;</td>
    <td></td>
  </tr>
</table>
<br><br>

 <cfif NOT IsDefined('url.userid') >
  	<font size="2" face="Verdana, Arial, Helvetica, sans-serif">Choose an Intl. Rep. <br /> </font>
  <cfelseif students_hired.recordcount eq 0 >
  <font size="2" face="Verdana, Arial, Helvetica, sans-serif">	No students </font>
  <cfelse>
  
  
<table width=100% cellpadding="4" cellspacing=0> 
	<tr>
	<Th align="left" bgcolor="##4F8EA4"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="##FFFFFF">Student</font></Th><th align="left" bgcolor="##4F8EA4"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="##FFFFFF">Sex</font></th><th align="left" bgcolor="##4F8EA4"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="##FFFFFF">Country</font></th><th align="left" bgcolor="##4F8EA4"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="##FFFFFF">Email</font></th>
	<th align="left" bgcolor="##4F8EA4"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="##FFFFFF">SSN</font></th>
	<th align="left" bgcolor="##4F8EA4"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="##FFFFFF">Passport</font></th>
	<th align="left" bgcolor="##4F8EA4"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="##FFFFFF">Passport dates </font></th><th align="left" bgcolor="##4F8EA4"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="##FFFFFF">Intl. Rep.</font></th>
	</tr>
<cfloop query="students_hired">
	<tr <cfif students_hired.currentrow mod 2>bgcolor="##E4E4E4"</cfif>>
		<td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#firstname# #lastname#</font></td><td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#sex#</font></td><td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#countryname#</font></td><td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#email#</font></td><td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#ssn#</font></td>
		<td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#passport_number#</font></td>
		<td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#dateformat (passport_date, 'mm/dd/yyyy')# #dateformat (passport_expires, 'mm/dd/yyyy')#</font></td>
		<td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#businessname#</font></td>
	</tr>
</cfloop>
	</table>
  </cfif>
    
<!----</cfif>--->
<!----
</cfdocument>
---->
</cfoutput>