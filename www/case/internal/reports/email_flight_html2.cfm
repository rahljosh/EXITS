<link rel="stylesheet" href="reports.css" type="text/css">
<link rel="stylesheet" href="../smg.css" type="text/css">

<style type="text/css">
table.nav_bar { font-size: 10px; background-color: #ffffff; border: 1px solid #2E5872; }
</style>

<cfif isdefined('url.studentid')>
	<cfset client.studentid = #url.studentid#>
</cfif>

<cfinclude template="../querys/get_student_info.cfm">
<cfinclude template="../querys/get_students_host.cfm">
<cfinclude template="../querys/get_students_area_rep_follow.cfm">
<cfinclude template="../querys/get_company_short.cfm">

<!-----Intl. Agent----->
<cfquery name="get_int_Agent" datasource="caseusa">
select companyid, businessname, fax, email, firstname, lastname, businessphone
from smg_users 
where userid = #get_Student_info.intrep#
</cfquery>

<!-----Program Name----->
<cfquery name="program_name" datasource="caseusa">
select programname
from smg_programs
where programid = #get_Student_info.programid#
</cfquery>

<!-----Regions----->
<cfquery name="regions" datasource="caseusa">
select regionname, regionfacilitator
from smg_regions
where regionid = #get_Student_info.regionassigned#
</cfquery>

<cfquery name="get_arrival" datasource="caseusa">
SELECT flightid, studentid, dep_date, dep_city, dep_aircode, dep_time, flight_number, arrival_city, 
		arrival_aircode, arrival_time, overnight, flight_type
FROM smg_flight_info
WHERE studentid = '#get_student_info.studentid#' and flight_type = 'arrival'
ORDER BY flightid <!--- dep_date, dep_time --->
</cfquery>

<cfquery name="get_dep" datasource="caseusa">
SELECT flightid, studentid, dep_date, dep_city, dep_aircode, dep_time, flight_number, arrival_city, 
		arrival_aircode, arrival_time, overnight, flight_type
FROM smg_flight_info
WHERE studentid = '#get_student_info.studentid#' and flight_type = 'departure'
ORDER BY flightid <!--- dep_date, dep_time --->
</cfquery>

<!-----Director----->
<cfquery name="regional_director" datasource="caseusa">
SELECT smg_users.userid, firstname, lastname, phone, address, address2, city, state, zip, phone, email, fax
FROM smg_users
INNER JOIN user_access_rights ON smg_users.userid = user_access_rights.userid
WHERE user_access_rights.regionid = '#get_student_info.regionassigned#' and user_access_rights.usertype = '5'
</cfquery>

<!-----Facilitator----->
<cfif #get_student_info.regionassigned# is not 0>
	<cfquery name="get_facilitator" datasource="caseusa">
	select firstname, lastname, email
	from smg_users
	where userid = '#regions.regionfacilitator#' 
	</cfquery>
</cfif>

<cfquery name="get_current_user" datasource="caseusa">
SELECT email, firstname, lastname
FROM smg_users
WHERE userid = #client.userid#
</cfquery>

<!---- Send Email to the user ---->
<!---- Local variables ---->
<!---- <cfif cgi.HTTP_HOST is 'web'>
	<CFSET ImgScrPath = "http://web">
<cfelse>
	<CFSET ImgScrPath = "http://www.student-management.com">
</cfif> ---->
<!---- <CFSET ImgScrPath = "http://#CGI.HTTP_HOST#"> ---->

<CFSET ImgScrPath = "http://www.case-usa.org">

<cfoutput>
<CFMAIL SUBJECT="Flight Information for #get_student_info.firstname# #get_student_info.familylastname# ( #get_student_info.studentid# )"
TO=#get_current_user.email#
FROM="support@case-usa.org"
TYPE="HTML">
<HTML>
<HEAD>

<style type="text/css">
table.nav_bar { font-size: 10px; background-color: ffffff; border: 1px solid 000000; }
.style3 {font-size: 13px}

.application_section_header{
border-bottom: 1px dashed Gray;
text-transform: uppercase;
letter-spacing: 5px;
width:100%;
text-align:center;
background;
background: DCDCDC;
font-size: small;
}
</style>
</HEAD>
<BODY>

<p>Please DO NOT reply to this message.</p>
<p>If you are not able to read this e-mail please contact your Facilitator or <a href="http://www.case-usa.org/flight_view.cfm?s=#get_student_info.uniqueid#">click here</a><br></p>

<table width="85%" align="center" border=0 bgcolor="FFFFFF">
	<tr>
	<td  valign="top" width=90>
		TO:<br>
		RD:<br>
		FAX:<br>
		E-MAIL:<br><br><br>		
		Today's Date:<br>
	</td>
	<td  valign="top">
		#regions.regionname#<br>
		#regional_director.firstname# #regional_director.lastname# <br>
		#regional_director.fax#<br>
		<a href="mailto:#regional_director.email#">#regional_director.email#</a><br><br><br>
		#DateFormat(now(), 'dddd, mmmm dd, yyyy')#<br>
	</td>
	
	<td><img src="#ImgScrPath#/#client.companyid#.gif"  alt="" border="0" align="right"></td>	
	<td valign="top" align="right"> 
		<div align="right">
		#companyshort.companyshort#<br>
		#companyshort.address#<br>
		#companyshort.city#, #companyshort.state# #companyshort.zip#<br><br>
		<cfif companyshort.phone is ''><cfelse> Phone: #companyshort.phone#<br></cfif>
		<cfif companyshort.toll_free is ''><cfelse> Toll Free: #companyshort.toll_free#<br></cfif>
		<cfif companyshort.fax is ''><cfelse> Fax: #companyshort.fax#<br></cfif></div>
		<br>
	</td></tr>		
</table>
<br>

<table  width="85%" align="center" border=0 bgcolor="FFFFFF" >
<tr><td><hr width="100%" align="center"></td></tr>
<tr><td align="center" bgcolor="CCCCCC" class="style3">
	<span class="application_section_header"><font size=+1><b><u>Flight Information</u></b></font></span><br></td></tr>
<tr><td align="center" class="style3">
	<p>We are pleased to give you the flight information for the following student:<br>
	Please pass this information to the host family as soon as possible and in case of any doubt do not hesitate to contact us.</p>
	</td></tr>
</table>
<br>

<table width="85%" border=0 align="center" bgcolor="FFFFFF">
	<tr><td width="60" class="style3"><b>Program :</b></td><td class="style3">#program_name.programname#</td></tr>
	<tr><td></td></tr><tr><td></td></tr>
	<tr><td class="style3"><b>Student: </b></td><td width="370" class="style3">#get_student_info.firstname# #get_student_info.familylastname# (#get_student_info.studentid#)</td>
	<td class="style3"><b>Region: </b></td><td class="style3">#regions.regionname#</td></tr>
	<tr><td colspan=4 class="style3"><hr width=85% align="center"></td></tr>
</table>

<table width="85%" border=0 align="center" bgcolor="FFFFFF">	
	<tr><td width="80" class="style3"><b>Intl. Rep.: </b></td><td class="style3">#get_int_Agent.firstname# #get_int_Agent.lastname# &nbsp; &nbsp; #get_int_Agent.businessname# &nbsp; &nbsp; Phone : &nbsp; #get_int_Agent.businessphone#</td></tr>	
	<tr><td class="style3"></td></tr><tr><td class="style3"></td></tr>
	
	<tr><td class="style3"><b>Area Rep.: </b></td><td class="style3">#get_students_area_rep_follow.firstname# #get_students_area_rep_follow.lastname# &nbsp; &nbsp; Phone : &nbsp; #get_students_area_rep_follow.phone#</td></tr>	
	<tr><td class="style3"></td></tr><tr><td class="style3"></td></tr>
	
	<tr><td class="style3"><b>Host Family.: </b></td><td class="style3"><cfif get_students_host.fatherfirstname is not ''>Mr. #get_students_host.fatherfirstname#</cfif> <cfif #get_students_host.fatherlastname# is not #get_students_host.motherlastname#>#get_students_host.fatherlastname#</cfif>
		<cfif get_students_host.fatherfirstname is not '' and get_students_host.motherfirstname is not ''> and </cfif>
		<cfif get_students_host.motherfirstname is not ''>Mrs. #get_students_host.motherfirstname#</cfif> <cfif #get_students_host.fatherlastname# is not #get_students_host.motherlastname#>#get_students_host.motherlastname#<Cfelse>
		#get_students_host.familylastname#</cfif> (#get_students_host.hostid#) &nbsp; &nbsp; Phone : &nbsp; #get_students_host.phone#</td></tr>	
	<tr><td class="style3"></td><td class="style3">#get_students_host.address#, #get_students_host.city#, #get_students_host.state# &nbsp; #get_students_host.zip#</td></tr>
</table>

<!--- ARRIVAL INFORMATION --->
<cfif get_arrival.recordcount GT '0'><br>
	<table border="1" align="center" width="85%" bordercolor="C0C0C0" valign="top" cellpadding="3" cellspacing="1">
	<tr bgcolor="ACB9CD"><th colspan="9" class="style3"> A R R I V A L &nbsp; &nbsp; I N F O R M A T I O N </th></tr>
	<tr bgcolor="ACB9CD">
		<th>Date</th><th>Departure City</th><th>Airport Code</th><th>Arrival City</th><th>Airport Code</th>
		<th>Flight Number</th><th>Departure Time</th><th>Arrival Time</th><th>Overnight Flight</th></tr>
	<cfloop query="get_arrival">
	<tr bgcolor="D5DCE5">
		<td align="center">#DateFormat(dep_date , 'mm/dd/yyyy')#&nbsp;</td>
		<td align="center">#dep_city#&nbsp;</td>
		<td align="center">#dep_aircode#&nbsp;</td>
		<td align="center">#arrival_city#&nbsp;</td>
		<td align="center">#arrival_aircode#&nbsp;</td>
		<td align="center">#flight_number#&nbsp;</td>
		<td align="center">#TimeFormat(dep_time, 'hh:mm tt')#&nbsp;</td>
		<td align="center">#TimeFormat(arrival_time, 'h:mm tt')#&nbsp;</td>
		<td align="center">
			 <cfif overnight is 0><cfset chk =''><cfelse><cfset chk ='checked'></cfif>
			<input type="checkbox" name="ar_overnight#get_arrival.currentrow#" value="#overnight#" #chk# readonly="yes"></input></td>
	</tr>
	<cfif overnight is 1>
	<tr bgcolor="D5DCE5"><td colspan="9" align="center">Please note arrival time is the next day due to an overnight flight.</td></tr>
	</cfif>	
	</cfloop>
	</table><br>
</cfif>
	
<cfif get_student_info.flight_info_notes is not ''>
<table border="1" align="center" width="85%" bordercolor="C0C0C0" valign="top" cellpadding="3" cellspacing="1">
<th bgcolor="ACB9CD"> N O T E S &nbsp; O N &nbsp; T H I S &nbsp; F L I G H T &nbsp; I N F O R M A T I O N</tr>
<tr bgcolor="D5DCE5"><td align="center"><div align="justify"><p>#get_student_info.flight_info_notes#</p></div></td></tr>
</table><br>
</cfif>	  
	  	  
<!--- DEPARTURE INFORMATION --->
<cfif get_dep.recordcount GT '0'><br>
	<table border="1" align="center" width="680" bordercolor="C0C0C0" valign="top" cellpadding="3" cellspacing="1">
	<tr bgcolor="FDCEAC"><th colspan="9" class="style3"> D E P A R T U R E &nbsp; &nbsp; I N F O R M A T I O N </th></tr>
	<tr bgcolor="FDCEAC">
		<th>Date</th><th>Departure City</th><th>Airport Code</th><th>Arrival City</th><th>Airport Code</th>
		<th>Flight Number</th><th>Departure Time</th><th>Arrival Time</th><th>Overnight Flight</th></tr>
	<cfloop query="get_dep">
	<tr bgcolor="FEE6D3">
		<td>#DateFormat(dep_date , 'mm/dd/yyyy')#&nbsp;</td>
		<td align="center">#dep_city#&nbsp;</td>
		<td align="center">#dep_aircode#&nbsp;</td>
		<td>#arrival_city#&nbsp;</td>
		<td align="center">#arrival_aircode#&nbsp;</td>
		<td align="center">#flight_number#&nbsp;</td>
		<td align="center">#TimeFormat(dep_time, 'hh:mm tt')#&nbsp;</td>
		<td align="center">#TimeFormat(arrival_time, 'h:mm tt')#&nbsp;</td>
		<td align="center">
			 <cfif overnight is 0><cfset chk =''><cfelse><cfset chk ='checked'></cfif>
			<input type="checkbox" name="ar_overnight#get_arrival.currentrow#" value="#overnight#" #chk#></input></td>
	</tr>
	<cfif overnight is 1>
	<tr bgcolor="FEE6D3"><td colspan="9" align="center">Please note arrival time is the next day due to an overnight flight.</td></tr>
	</cfif>			  
	</cfloop>
	</table><br>	
</cfif>

<br>
<!--- PAGE BOTTON --->	
<table width="85%" border=0 align="center" bgcolor="FFFFFF">
<tr><td align="left" class="style3">
  <br>Regards,<br>
  #get_facilitator.firstname# #get_facilitator.lastname#
</td></tr>
</table>

</body>
</html>
</CFMAIL>

<span class="application_section_header">FLIGHT INFORMATION</span>
<div class="row"><br>

<div align="center"><h1><u>#get_student_info.firstname# #get_student_info.familylastname# ( #get_student_info.studentid# )</u></h1></div>

<table border="0" align="center" width="99%" bordercolor="C0C0C0" valign="top" cellpadding="3" cellspacing="1">
<tr align="center" bgcolor="ACB9CD"><td><span class="get_Attention">This Flight Information has been sent to #get_current_user.firstname# #get_current_user.lastname# at #get_current_user.email#</span></td></tr>
<td align="center" bgcolor="ACB9CD">
	<input type="image" value="back" src="../pics/back.gif" onClick="javascript:history.back()">  &nbsp;  &nbsp;  &nbsp;  &nbsp;
	<input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()">
</td></tr>
</table>
</div>
</cfoutput>
<!----  Path:	#ImgScrPath#<br>
	Remote Address: #cgi.REMOTE_ADDR#<br>
	Http Host:	#cgi.HTTP_HOST#<br> ---->