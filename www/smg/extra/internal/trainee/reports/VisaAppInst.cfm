<cfdocument format="pdf" orientation="portrait" backgroundvisible="yes" overwrite="no" fontembed="yes">

<cfquery name="get_candidate" datasource="MySql">
SELECT firstname, middlename, lastname, home_country, ds2019, extra_candidates.fieldstudyid, extra_candidates.subfieldid, extra_candidates.programid, smg_programs.programname, extra_sevis_sub_fieldstudy.subfield, extra_sevis_fieldstudy.fieldstudy, smg_countrylist.countryname
FROM extra_candidates
INNER JOIN extra_sevis_fieldstudy ON extra_sevis_fieldstudy.fieldstudyid = extra_candidates.fieldstudyid
INNER JOIN extra_sevis_sub_fieldstudy ON extra_sevis_sub_fieldstudy.subfieldid = extra_candidates.subfieldid
INNER JOIN smg_programs ON smg_programs.programid = extra_candidates.programid
INNER JOIN smg_countrylist ON smg_countrylist.countryid = extra_candidates.citizen_country
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
      <div align="center">Visa Application Instructions <font color="#FFFFFF">____________ </font> </div>
    </div></td>
  </tr>
</table><cfoutput query="get_candidate"><br />

<table width="90%" border="0">
  <tr>
    <td width="45%" align="left" class="style1">To: <span class="style3">#firstname# #middlename# #lastname#</td>
	<td width="45%" align="right" class="style1">Date: #DateFormat(now(), 'mmmm d, yyyy')#</td>
  </tr>
</table>

<p class="style1">Congratulations, you are now on your way to obtaining a J-1 trainee visa as a participant in International Student Exchange's sponsored Trainee Program.<br />
<br />
Please make an appointment at the consulate to obtain your J-1 trainee visa.  Your visa will be valid for up to 18 months.  It will be a multi-entry visa.<br />
<br />
You have completed your written application, and ISE has issued your form DS-2019.  It is enclosed with these instructions.  The form DS-2019 is your "Certificate of Eligibility".  You must show it to the Consular as a prerequisite to them issuing the J-1 trainee visa.<br />
<br />
Do not say to your country's officials or American Officials that you are "working" in America.  You are not authorized to work in America.  You are Training.  That is the word to use.  "TRAINING".  J-1 is not a work/employment visa.  It is a trainee visa in the field of
               <cfif #subfield# EQ ''>
                    #fieldstudy#
                    <cfelse>
                    #subfield#
        </cfif>.<br />
		<br />
		You must also produce the ISE Enrollment Confirmation Letter for the Consular.<br />
		<br />
		You must also show the Immigration Officer the Sponsorship Letter for Host Company.  However, give the original of that letter to the Human Resources (Personnel) Department of your new Host Company.<br />
		<br />
		In most cases, these documents, along with your valid Passport Identification, is all you need to procure a visa.  However, each Country is different; therefore, you should make an early appointment to the Consulate's office in case they request you to return with additional documentation.<br />
		<br />
During your training in the USA you are insured from the start day to the last day of your training (please see your DS2019 form). You are responsible for the insurance before and after the training program start and end dates accordingly.<br><br>
<strong>After you arrive to America, please send me your new address and date when you actually arrived. You must do it within 2 weeks of your arrival.  If this is not done we cannot activate your status in the SEVIS database and your profile will be cancelled automatically. </strong><br>
    <br>
    Respectfully Submitted,<br />
    <br>
    <br>
	<br>
	<br>
</p>
<p class="style1">Sergei Chernyshov<br>
Program Manager
</p>
</cfoutput>
</cfdocument>