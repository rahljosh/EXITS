<cfdocument format="pdf" orientation="portrait" backgroundvisible="yes" overwrite="no" fontembed="yes">
<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
-->
</style>

<style type="text/css">
<!--
.style1 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 14;
}
-->
</style>


<cfquery name="get_student" datasource="mysql">
SELECT firstname, middlename, lastname, home_country, ds2019, extra_candidates.fieldstudyid, extra_candidates.subfieldid, extra_candidates.programid, smg_programs.programname, extra_sevis_sub_fieldstudy.subfield, extra_sevis_fieldstudy.fieldstudy, smg_countrylist.countryname
FROM extra_candidates
INNER JOIN extra_sevis_fieldstudy ON extra_sevis_fieldstudy.fieldstudyid = extra_candidates.fieldstudyid
INNER JOIN extra_sevis_sub_fieldstudy ON extra_sevis_sub_fieldstudy.subfieldid = extra_candidates.subfieldid
INNER JOIN smg_programs ON smg_programs.programid = extra_candidates.programid
INNER JOIN smg_countrylist ON smg_countrylist.countryid = extra_candidates.citizen_country
WHERE uniqueid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.uniqueid#">
</cfquery>

<cfoutput query="get_student">
<table width="100%" border="0">
  <tr>
    <td><table width="100%" border="0">
      <tr>
        <td width="13%" class="style1"><img src="http://www.student-management.com/nsmg/pics/ise-logo2.gif" width="120" height="120" /> </td>
        <td width="87%" class="style1"><b>International Student Exchange</b><br>
          <br>
          119 Cooper Street - Babylon, NY 11702<br>
          <br>
          Toll Free: 800-766-4656 - Tel: 631-893-4540 - Fax : 631-893-4550</td>
      </tr>
    </table>
    <br>
        <strong><p align="center"><font size="+1" class="style1" > ENROLLMENT CONFIRMATION</p></strong> </font><br>
  <p align="left" class="style1">   TO: Consular Officer or Embassy Representative<br>
    <br>
    FROM: International Student Exchange<br>
    <br>
    RE: #firstname# #middlename# #lastname# <!--- #programname#  18 month Training program---></p>
  <br>
    #DateFormat(Now(), 'DDDD, MMMM D, YYYY')#. <br />
      <br />
      <br />
    </p>
   
     <div align="justify"><span class="style1">Please accept this letter as official notification verifying that #firstname# #middlename# #lastname# is a participant on the International Student Exchange Trainee Program. International Student Exchange has been designated by the Education &amp; Cultural Affairs division of the Department of State to issue Form DS-2019 to all qualified applicants for the Trainee category, occupational field of <cfif #subfield# EQ ''> #fieldstudy#
                    <cfelse> #subfield#</cfif>. We have reviewed the application materials for #firstname# #middlename# #lastname# and verified that the individual is well qualified for the Trainee program.<br />
                  <br />
                  #firstname# #middlename# #lastname# is a citizen of #countryname# and has been accepted into the ISE Trainee Program. Form DS-2019 number #ds2019# has been issued for the above-mentioned student to train in the field of
              <cfif #subfield# EQ ''>
                    #fieldstudy#
                    <cfelse>
                    #subfield#
        </cfif>
              .<br />
              <br />
              If there are any questions about this student or about the ISE Trainee program, please feel free to contact me directly at any time.
      <br>
 
   <br>
      <br>
  Sincerely,<br>
      <br />
      <br />
      <br />
      <br />
      <br />
      <br>
  Sergei Chernyshov<br>
Program Manager
<br>
  <p align="center" class="style1">    www.isetraining.com</p>    </td>
  </tr>
</table>
</cfoutput>

</cfdocument>