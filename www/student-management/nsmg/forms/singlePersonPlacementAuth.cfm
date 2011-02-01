<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Single Person Placement Authorization</title>
<!----CSS Sheet---->
<link rel="stylesheet" href="../linked/css/student_profile.css" type="text/css">
 <cfquery name="studentFamInfo" datasource="#application.dsn#">
 select stu.firstname, stu.familylastname, stu.mothersname, stu.fathersname,
 a.businessname
 from smg_students stu
 left join smg_users a on a.userid = stu.intrep
 where stu.studentid = #url.studentid# 
 </cfquery>
<style>
 .signatureLine{border-bottom:thin;}
-->
</style>
</head>

<body>
 <cfoutput>
 <table class="profileTable" align="center">
    <Tr>
        <Td>
       
          <table align="center" background="../pics/#client.companyid#_short_profile_header.jpg">
                <tr>
                    
                    <td class="bottom_right" width=800 height=160>
          
                      <font size=+2>Single Person Placement Authorization Form &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font>
                    </td>
                </tr>
            </table>
            <br /><br />
            <Table align="Center" width=90%>
            	<Tr>
                	<Td colspan=3><p>The U.S Department of State requires Student exchange visitors and natural parents agree in writing to a single person placement. A single person is defined as someone living alone without children or family members.<sup>*</sup></p><br />
                    <p>I, <strong><u>#studentfaminfo.firstname# #studentfaminfo.familylastname#</u></strong>, agree to live with a
single person during my exchange year. I understand this type of placement has
been additionally screened by #client.companyshort#.</p><br />
<p><cfif studentFamInfo.fathersname is not '' AND studentFamInfo.mothersname is not ''>We<cfelse>I</cfif>, <u><strong>#studentFamInfo.fathersname# <cfif studentFamInfo.fathersname is not ''>&amp;</cfif> #studentFamInfo.mothersname#</strong></u>, agree to a single person placement for our son or daughter
during his/her exchange year. I/we understand this type of placement has been additionally screened by #client.companyshort#.</p>
        </Td>
	</Tr>
 	<tr>
    	<td class="signatureLine" valign="bottom"><br /><Br /><br /><br /><br />____________________________________</td><td>&nbsp;</td>
        <td class="signatureLine" valign="bottom">____________________________________</td>
    </tr>
    <tr>
    	<td>#studentfaminfo.firstname# #studentfaminfo.familylastname#</td><td></td><td>Date - MM/DD/YYYY</td>
        </tr>
 
    <cfif studentFamInfo.fathersname is not ''>
    <tr>
    	<td class="signatureLine" valign="bottom"><br /><Br /><br /><br /><br />____________________________________</td><td>&nbsp;</td>
        <td class="signatureLine" valign="bottom">____________________________________</td>
    </tr>
    <tr>
    	<td>#studentFamInfo.fathersname# <Cfif studentFamInfo.mothersname is not ''>OR <br /></Cfif> #studentFamInfo.mothersname# </td><td></td><td>Date - MM/DD/YYYY</td>
    </tr>
    </cfif>

    
    <tr>
    	<td class="signatureLine" valign="bottom"><br /><Br /><br /><br /><br />____________________________________</td><td>&nbsp;</td>
        <td class="signatureLine" valign="bottom">____________________________________</td>
    </tr>
    <tr>
    	<td>#client.companyshort# Signature  </td><td></td><td>Date - MM/DD/YYYY</td>
    </tr>
    <tr>		
        <Td colspan=3><br /><br /><div align="center"></div><Br /><br /><Br />
      <font size=-2><strong>*CFR Title 22, Part 62, Subpart B, &sect;62.25 (j)(9)</strong><br />
       <em>Ensure that a potential single adult host parent without a child in the home undergoes a secondary level review by an organizational representative other than the individual who recruited and selected the applicant. Such secondary review should include demonstrated evidence of the individual's friends or family who can provide an additional support network for the exchange student and evidence of the individual's ties to his/her community. Both the exchange student and his or her natural parents must agree in writing in advance of the student's placement with a single adult host parent without a child in the home.</em></font></Td>
    </Tr>
</table>
</cfoutput>
</body>
</html>