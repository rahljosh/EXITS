
<style type="text/css">
<!--
.style1 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 14;
}
.style2 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 18;
}

-->
</style>


<cfquery name="get_candidate" datasource="MySql">
	SELECT candidateid, uniqueid, firstname, middlename, lastname
	FROM extra_candidates
	WHERE uniqueid = '#url.uniqueid#'
</cfquery>


<table width="60%" border="0">
  <tr>
    <td class="style1"><img src="http://www.student-management.com/2.gif"><br /></td>
    <td class="style2">Babylon, New York 11702<br />
      1-888-Into USA </td>
  </tr>
</table>
<span class="style1"><br />
</span>
<table width="60%" border="0">
  <tr>
    <td valign="top" class="style1">TO: </td>
    <td class="style1">U.S Embassy/Consulate<br />
      Social Security Administration<br>
      <br></td>
  </tr>
  <tr>
    <td valign="top" class="style1">From: </td>
    <td class="style1">Craig Brewer<br />
Executive Director<br />
Responsible Officer<br />
U.S. Department of State Designated Sponsor P-3-06010</td>
  </tr>
</table>
<br>
<br>
<br>
<br>
<br>
<br>
<cfoutput query="get_candidate">

<p class="style1"> To Whom it May Concern:<br>
  <br>
</p>
<p class="style1">Please accept this letter as an official document attesting to the fact that #firstname# #middlename# #lastname# is a participant on the IntoEdVentures Summer Work and Travel.<br />
  <br />
  IntoEdVentures is a sponsor of exchange visitors to the United States, participating in<br />
  Exchange Visitor Program P-3-06010, designated by the United States Department of State.<br />
  Such participants have been admitted under Section 101 (A) (15) (J) of the Immigration and<br />
  Nationality Act. Their J-1 visa status is evidenced by the DS2019 Form and the J-1 visa in their passports.<br />
  <br />
  According to the Immigration Reform and Control Act of 1986 (IRCA), the participants of this program are eligible for employment. 
  The participants of this program 
  are also entitled to receive compensation from employers for theirs efforts while they are on the 
  program.<br />
  <br />
  Each participant has been sponsored by IntoEdVentures as indicated on the DS2019 Form.<br />
  <br />
  IntoEdVentures would like to thank you in advance for your cooperation. If you should have<br />
  any questions or concerns, please feel free to contact us at 1-888-Into USA.<br>
  <br>
  <br>
</p>
<p class="style1">Kind Regards,<br>
  <br />
  <img src="http://www.student-management.com/extra/internal/uploadedfiles/craig_signature.gif"><br>
  Craig Brewer<br />
Executive Director/Responsible Officer</p>
<br /><br /><br />
</cfoutput>