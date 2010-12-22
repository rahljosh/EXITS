<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Book a Student Trip</title>
<link href="STB.css" rel="stylesheet" type="text/css" />

<style type="text/css">
<!--
.wrapper {
	width: 700px;
	margin-right: auto;
	margin-left: auto;
}
.info2 {
	width: 600px;
	margin-right: auto;
	margin-left: auto;
	font-family: Arial, Helvetica, sans-serif;
	font-size: 13px;
}
.infoBold {
	font-weight: bold;
	font-family: Arial, Helvetica, sans-serif;
}
.infoItalic {
	font-style: italic;
	font-family: Arial, Helvetica, sans-serif;
}
.clear {
	display: block;
	clear: both;
	height: 10px;
}
.boxTile2 {
	background-image: url(images/loginTile.png);
	background-repeat: repeat-y;
	width: 700px;
}
.topColor {
	
	height: 60px;
	width: 580px;
	float: left;
	margin-top: 25px;
}
#tripLogo {
	background-color: #FFF;
	height: 100px;
	width: 125px;
	position: absolute;
	z-index: 200;
}
.signatureLine{border-bottom:thin;}
-->
</style>
</head>

<body>

<!----Retrieve Stuents Company Information---->
<cfquery name="company_info" datasource="#application.dsn#">
select *
from smg_companies
where companyid = #client.companyid#
</cfquery>
<!----Retrieve required Student Information---->
<cfquery name="student_info" datasource="#application.dsn#">
select s.familylastname, s.firstname, s.studentid, s.med_allergies, s.other_allergies, s.dob, s.email, s.cell_phone, s.sex, s.regionassigned,  s.countrybirth, s.countrycitizen, s.med_allergies, s.other_allergies, s.countryresident, h.airport_city, h.airport_state, h.local_air_code, h.major_air_code, 
h.hostid, h.familylastname hostlast, h.motherfirstname, h.fatherfirstname, h.motherlastname, h.fatherlastname, h.address, h.address2, h.city, h.state, h.zip, h.email as hostemail, h.phone as hostphone, h.mother_cell, h.father_cell, h.fatherworkphone, h.motherworkphone,
u.firstname as areaRep_first, u.lastname as areaRep_last, u.phone as areaRep_phone,
school.schoolname
from smg_students s 
left join smg_hosts h on h.hostid = s.hostid
left join smg_users u on u.userid = s.arearepid
left join smg_schools school on school.schoolid = h.schoolid
where s.studentid = #url.student# 
</cfquery>

<Cfquery name="regionalManager" datasource="#application.dsn#">
select firstname, lastname, phone
from smg_users
left join user_access_rights on user_access_rights.userid = smg_users.userid
where user_access_rights.regionid = #student_info.regionassigned#
and user_access_rights.usertype = 5
</Cfquery>
<Cfquery name="thisTripInfo" datasource="#application.dsn#">
select * 
from student_tours
where id = #url.id# 
limit 1
</Cfquery>
<cfoutput>

<div class="wrapper">
      <div class="boxTop"></div>
      <div class="boxTile2">
</div>

<p></p>
<Table width=700 cellpadding=2 cellspacing=0>
	<Tr>
    	<td><img src="http://ise.exitsapplication.com/nsmg/pics/logos/#client.companyid#_header_logo.png"/></td><td><h1 align="center"><font color="black">&nbsp;&nbsp;&nbsp;#company_info.companyshort_nocolor# Tours Permission Form</font></h1></td>
 </Tr>
 </Table>
 <Table width=700 cellpadding=2 cellspacing=0>
    <Tr>
    	<td colspan=4><br /><strong><font size=+1>Student Information</font></strong><Br /><img src="http://ise.exitsapplication.com/nsmg/pics/line.gif" height=1 width=100%/></td>
    </Tr>
    <tr>
    	<td>Name: <strong>#student_info.firstname# #student_info.familylastname# </strong> (#student_info.studentid#)<br></td><td>Cell:<cfif student_info.cell_phone is ''>N/A<cfelse> <strong>#student_info.cell_phone#</strong></cfif></td>
        
    </tr>
    <Tr>
    	<td>Sex: <strong>#UCase(student_info.sex)# </Td><td>Email: <strong>#student_info.email#</strong></Td>
    </Tr>
    <tr>
    	<Td>DOB: <Strong>#DateFormat(student_info.dob,'mmm d, yyyy')#</Strong> (#DateDiff('yyyy', '#student_info.dob#', '#now()#')# years old)</Td><Td>Nationality: #thisTripInfo.stunationality# </Td>
    </tr>
    <tr>
    	<td colspan=3>Roommate Nationality: <strong>#thisTripInfo.nationality#  </strong>
		 <cfif thisTripInfo.person1 is not ''>#thisTripInfo.person2#,</cfif>
		 <cfif thisTripInfo.person2 is not ''>#thisTripInfo.person2#,</cfif>
         <cfif thisTripInfo.person3 is not ''>#thisTripInfo.person3#</cfif>  </td>
    <Tr>
    	<td colspan=4><strong><font size=+1>Host Family Information</font></strong><Br /><img src="http://ise.exitsapplication.com/nsmg/pics/line.gif" height=1 width=100%/></td>
    </Tr>
    <tr>
    	<td valign="top"> 

        <strong>#student_info.fatherfirstname# #student_info.fatherlastname# <Cfif student_info.fatherfirstname is not '' and student_info.motherfirstname is not ''> & </Cfif> #student_info.motherfirstname# #student_info.motherlastname#</strong><br />
        #student_info.address#<br />
		<cfif student_info.address2 is not ''>#student_info.address2#</br></cfif>
#student_info.city# #student_info.state# &nbsp;&nbsp;#student_info.zip#<br />
 Local Airport: <strong>#student_info.local_air_code#</strong><br />
    Major Airport: <strong>#student_info.major_air_code#</strong></td>
</td><Td>
       Home Phone: <strong>#student_info.hostphone#</strong> <br />
      <Cfif #student_info.motherfirstname# is not ''>
      	 #student_info.motherfirstname#  cell phone: <Cfif student_info.mother_cell is ''>N/A<cfelse> <strong>#student_info.mother_cell#</strong></Cfif><br />
		#student_info.motherfirstname# work Phone: <Cfif student_info.motherworkphone is ''>N/A<cfelse> <strong>#student_info.motherworkphone#</strong></Cfif><Br />
	</Cfif>
 
     <Cfif #student_info.fatherfirstname# is not ''>
        #student_info.fatherfirstname# cell phone: <Cfif student_info.father_cell is ''>N/A<cfelse> <strong>#student_info.father_cell#</strong></Cfif><Br />
    	#student_info.fatherfirstname# WORK Phone:  <Cfif student_info.fatherworkphone is ''>N/A<cfelse> <strong>#student_info.fatherworkphone#</strong></Cfif><Br />
    </Cfif> 
    Email: <strong>#student_info.hostemail#</strong> 
      </td>
	</tr>
  <tr>
    	<td colspan=2><strong><font size=+1>Medical & Allergy Information</font></strong> <em><font size=-2>Remember you must cary your card while on tour!</font></em><Br /><img src="http://ise.exitsapplication.com/nsmg/pics/line.gif" height=1 width=100%/></td>
    </Tr>
    <Tr>
   		<td>Medical Allergies: &nbsp </font><cfif student_info.med_allergies is ''>no<cfelse>#student_info.med_allergies#</cfif></td>
		<td>Other: &nbsp </font><cfif student_info.other_allergies is ''>no<cfelse>#student_info.other_allergies#</cfif></td>
	</tr>
    <tr>
    	<td colspan=2>Any thing else: #thisTripInfo.med#<td>
    </tr>
     <Tr>
    	<td colspan=2><strong><font size=+1>Tour Details</font></strong><Br /><img src="http://ise.exitsapplication.com/nsmg/pics/line.gif" height=1 width=100%/></td>
    </Tr>
      <Tr>
    <cfquery name="trip_info" datasource="#application.dsn#">
    select st.tripid, smgt.tour_Date, smgt.tour_name
    from student_tours st
    left join smg_tours smgt on smgt.tour_id = st.tripid 
    where id = #url.id#
    </cfquery>
	
    	<Td colspan=2>
        <cfloop query="trip_info">
        <strong> #trip_info.tour_name#</strong> - #trip_info.tour_date#<br />
       	</cfloop>
    	</Td>
    </tr>    
    
  
    <Tr>
    	<Td colspan=2>
        <Table width=758 cellpadding=2 cellspacing=0>
	<Tr>
    	<td colspan=4><br /><strong><font size=+1>Signatures</font></strong><Br /><font size=-2>I have read and understand all the Terms and Conditions either on website or attached form.  All parties acknowledge that while on tour, ISE and MPD Tour America, Inc. or its representatives may take any action deemed necessary to protect student safety and well being, including medical treatment at the student's expense and transportaion home at student's expense. </em>.<Br /><img src="http://ise.exitsapplication.com/nsmg/pics/line.gif" height=1 width=100%/></td>
    </Tr>
    <tr>
    	<td width="244" class="signatureLine" valign="bottom"><br /><br /><Br />____________________________________</td><td width="3">&nbsp;</td><td width="497" class="signatureLine" valign="bottom">____________________________________</td>
    	<td rowspan=7> Please sign and submit at least 30 days prior to your departure.<br />
        Form can be emailed to:<Br />
        <h3>info@mpdtoursamerica.com</h3>
        or faxed to:
        <h3> 718-439-8565</h3>
        or via postal mail:<br />
        <h3>9101 Shore Road <Br />
        Suite ##203<Br />
        Brookly, NY 11209</h3> </td>
    </tr>
    <tr>
    	<td>#student_info.firstname# #student_info.familylastname#</td><td></td><td> #student_info.fatherfirstname# #student_info.fatherlastname# <Cfif student_info.fatherfirstname is not '' and student_info.motherfirstname is not ''> or </Cfif> #student_info.motherfirstname# #student_info.motherlastname#</td>
        </tr>
            <tr>
    	<td class="signatureLine" valign="bottom"><br /><Br /><br />____________________________________</td><td>&nbsp;</td><td class="signatureLine" valign="bottom">____________________________________</td>
    </tr>
    <tr>
    	<td>#student_info.areaRep_first# #student_info.areaRep_last#<Br />Area Representative - #student_Info.areaRep_phone#</td><td></td><td>#regionalManager.firstname# #regionalManager.lastname# <Br />Regional Manager - #regionalManager.phone#</td>
        </tr>
    <tr>
    	<td class="signatureLine" valign="bottom"><br /><Br /><br />____________________________________</td><td>&nbsp;</td>
    	<td class="signatureLine" valign="bottom">____________________________________ </td>
    </tr>
    <tr>
    	<td><Cfif student_info.schoolname is ''>School<cfelse> #student_info.schoolname#</Cfif> Representative<br /><font size=-2><em>Students may not miss school without school permission and must make up any missed work.</td><td></td><td valign="top"> Printed Name & Posistion</td>
        </tr>

</table>
        </Td>
     </Tr>
</table>







<br>
<span class="infoItalic">

<!-- end info --></div>
<div class="clear"></div>
<!-- end boxTile --></div>
      <div class="boxBot"></div>
  <!-- end wrapper --></div>
 
</cfoutput>