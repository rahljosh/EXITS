<cfdocument format="pdf" orientation="portrait" backgroundvisible="yes" overwrite="no" fontembed="yes">

<cfquery name="get_candidate" datasource="MySql">
	SELECT *, <!---- smg_countrylist.countryname --->
	bcountrylist.countryname as birhcountryname,
	hcountrylist.countryname as homecountryname,
	ccountrylist.countryname as citizencountryname
	
	FROM extra_candidates
	
	<!---- INNER JOIN smg_countrylist ON smg_countrylist.countryid = extra_candidates.birth_country
	AND extra_candidates.home_country AND extra_candidates.citizen_country ---->
	
	INNER JOIN smg_countrylist as bcountrylist ON bcountrylist.countryid = extra_candidates.birth_country
	INNER JOIN smg_countrylist as hcountrylist ON hcountrylist.countryid = extra_candidates.home_country
	INNER JOIN smg_countrylist as ccountrylist ON ccountrylist.countryid = extra_candidates.citizen_country
	
	WHERE uniqueid = '#url.uniqueid#'
</cfquery>

<style type="text/css">
<!--
.style1 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 13px;
}
.style2 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 16px; font-weight: bold; }
.style3 {font-family: Verdana, Arial, Helvetica, sans-serif; font-weight: bold; }
-->
</style>
<table width="100%" border="0">
  <tr>
    <td width="11%"><img src="http://www.student-management.com/nsmg/pics/ise-logo2.gif" width="120" height="120" /></td>
    <td width="89%"><div class="style2">
      <div align="center">Sponsorship Letter <font color="#FFFFFF">____________ </font> </div>
    </div></td>
  </tr>
</table><cfoutput query="get_candidate"><br />

<table width="90%" border="0">
  <tr>
    <td width="45%" align="left" class="style1">To Host Company Payroll Department</td>
	<td width="45%" align="right" class="style1">Date: #DateFormat(now(), 'mmmm d, yyyy')#</td>
  </tr>
</table>

<p class="style1">This  letter is confirms that #firstname# #lastname# is a participant in International Student Exchange's Trainee Program.  We would like to remind you that the International Student Exchange participants are exempt from Social Security, Medicare withholding and Federal Unemployment Tax if they possess or obtain a sponsorship letter authorizing employment.  {ref. Department of the Treasury, Internal Revenue Service, Circular E, Employer's Tax Guide (page 31) section on Students, scholars, trainees, teachers, etc., number 5}.  <span class="style3">This letter serves that purpose.</span><br />
    <br>
    Participants must obtain Social Security Numbers for payroll purposes.  Trainees must apply on their own behalf and in person at the local Social Security Office and present <cfif sex EQ 'm'>his<cfelse>her</cfif> passport with the I-94 card and the Certificate of Eligibility (DS-2019).  Trainees can locate the nearest office by visiting:<br>
	<br />
	 <span class="style3">http://www.ssa.gov</span><br />
  <br>
  As proof of application, they will be issued form SSA-5028. If you wish to prepare a report of earnings before the participant has received their Social Security card, you may leave the space for the Social Security number blank.<br>
  <br>
  Participants are, however, subject to all applicable federal, state and local tax withholdings.  For further information regarding employer responsibilities when engaging foreign personnel, please visit: <br>
  <br />
  <span class="style3">http://www.ssa.gov/employer/hiring.htm</span><br />
  <br>
  Respectfully Submitted,<br />
  <br />
  <img src="../../pics/TanyaSig.gif" /><br />
  <br /></p>
  
<p class="style1">Ms. Tatsyana Bykava, Program Manager<br />
International Student Exchange<br />
119 Cooper Street<br />
Babylon, NY  11702<br />
1-800-776-4656</p>
</cfoutput>
</cfdocument>