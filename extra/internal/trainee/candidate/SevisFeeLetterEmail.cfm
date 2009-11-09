<cfquery name="get_candidate" datasource="MySql">
	SELECT *, smg_countrylist.countryid, smg_countrylist.countryname, smg_users.firstname as intrep_name, smg_users.email as intrep_email
	FROM extra_candidates
	INNER JOIN smg_countrylist ON smg_countrylist.countryid = extra_candidates.birth_country
	AND extra_candidates.home_country AND extra_candidates.citizen_country
	INNER JOIN smg_users ON smg_users.userid = extra_candidates.intrep
	WHERE extra_candidates.uniqueid = '#form.uniqueid#'
</cfquery>

<style type="text/css">
<!--
.style1 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 13px;
}
.style2 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 16px; font-weight: bold; }
-->
</style>

<!----TO: #get_intrep_email.email# --->

 <cfoutput query="get_candidate">
 
<CFMAIL TO="#intrep_email#" bcc="tanya@iseusa.com" FROM="tanya@iseusa.com"
	 SUBJECT="#firstname# #middlename# #lastname# form DS-2019 issued/sevis fee payment information" type="html"> 
	 
	  <br />


<p class="style1">
RE: #firstname# #lastname#<br>

Dear #intrep_name#,
<br>
<br>

This letter is to confirm that #firstname# #lastname# has been approved by ISE for the J-1 visa sponsorship and has been entered into the Student and Exchange Visitor Information System (SEVIS) database. A DS-2019 form (SEVIS ID #ds2019#) has been issued and sent.<br>
    <br>
  If an appointment to apply for the J-1 visa at the U.S. Embassy or Consulate in the home country has not yet been scheduled, please make sure that is done at this time.<br>
  <br>
  In the meantime, please find the necessary information below in order to pay the required SEVIS fee ($180.00 US for trainees) to the United States Department of Homeland Security (DHS).<br>
  <br>
  This fee can be paid by accessing form I-901 at the following web site:<br>
  <br>
  <b>https://www.fmjfee.com/index.jhtml</b><br>
  <br>
  For a PDF version of form I-901 and the instructions for completing this form,  please visit:<br>
  <br>
  <b>http://www.ice.gov/graphics/sevis/pdf/I-901.pdf</b><br>
  <br>
  The SEVIS fee must be paid before applying for the J-1 visa at the U.S. Embassy or Consulate.</p>
<p class="style1">You will need to bring the electronic or original receipt with you for your visa interview.<br>
    <br>
  Below is the information needed to complete form I-901 exactly as it appears on  the DS-2019 form<br>
  issued  by ISE:<br />
</p><br />

<table width="80%" border="0" align="center">
  <tr>
    <td width="35%"><span class="style1"><strong>First Name:</strong></span></td>
    <td width="65%"><span class="style1">#firstname# </span></td>
  </tr>
  <tr>
    <td><span class="style1"><strong>Middle Name:</strong></span></td>
    <td><span class="style1">#middlename#</span></td>
  </tr>
  <tr>
    <td><span class="style1"><strong>Last Name:</strong></span></td>
    <td><span class="style1">#lastname#</span></td>
  </tr>
  <tr>
    <td><span class="style1"><strong>Address:</strong> </span></td>
    <td><span class="style1">119  Cooper Street, Babylon, NY 11702</span></td>
  </tr>
  <tr>
    <td><span class="style1"><strong>Date of Birth:</strong></span></td>
    <td><span class="style1">#DateFormat(dob, 'mm/dd/yyyy')#</span></td>
  </tr>
  <tr>
    <td><span class="style1"><strong>Gender:</strong></span></td>
    <td><span class="style1">#sex#</span></td>
  </tr>
  <tr>
    <td><span class="style1"><strong>City of Birth:</strong></span></td>
    <td><span class="style1">#birth_city#</span></td>
  </tr>
  <tr>
    <td><span class="style1"><strong>Country of Birth:</strong></span></td>
    <td><span class="style1"><!---#birth_country#---> #countryname#</span></td>
  </tr>
  <tr>
    <td><span class="style1"><strong>Country of Citizenship:</strong></span></td>
    <td><span class="style1"><!---#citizen_country#---> #countryname#</span></td>
  </tr>
  <tr>
    <td><span class="style1"><strong>Exchange Visitor Program Number:</strong></span></td>
    <td><span class="style1">P-3-10071</span></td>
  </tr>
  <tr>
    <td><span class="style1"><strong>SEVIS Identification Number:</strong></span></td>
    <td><span class="style1">#ds2019#</span></td>
  </tr>
  <tr>
    <td><span class="style1"><strong>Passport Number</strong><font size="-2"> (if available): </font></span></td>
    <td><span class="style1">#passport_number#</span></td>
  </tr>
  <tr>
    <td><span class="style1"><strong>Exchange Visitor Category:</strong></span></td>
    <td><span class="style1">TRAINEE ($180.00)</span></td>
  </tr>
</table>

<br />
<p class="style1">Please do not hesitate to contact  ISE Training Program staff should you have any questions.</p>
<p class="style1">Sincerely,</p>
<p class="style1">Tatsyana Bykava (tanya@iseusa.com) </p>

	  
</CFMAIL>
</cfoutput>