<Cfif isDefined('url.s')>
	<Cfquery name="get_student_info" datasource="caseusa">
	SELECT s.studentid, s.intrep, s.hostid, s.programid, s.companyid, s.regionassigned, s.firstname, s.familylastname,
		ag.businessname, ag.fax as intfax, ag.email as intemail, ag.firstname as intfirstname, 
		ag.lastname as intlastname, ag.businessphone as intbusinessphone,
		p.programname,
		c.companyshort, c.address as compaddress, c.city as compcity, c.state as compstate, c.zip as compzip,
		c.phone as compphone, c.toll_free as comptoll_free, c.fax as compfax
	FROM smg_students s
	INNER JOIN smg_users ag ON s.intrep = ag.userid
	INNER JOIN smg_programs p ON s.programid = p.programid
	INNER JOIN smg_companies c ON s.companyid = c.companyid
	WHERE s.uniqueid = <cfqueryparam value="#url.s#" cfsqltype="cf_sql_longvarchar">
	</Cfquery>

	<cfif get_student_info.recordcount is '0'> <!--- NONE STUDENTS WERE FOUND --->
		<table width=400 border=0>
		<td><a href="http://www.student-management.com"><img src="newsmg/pics/logos/5.gif"  alt="" border="0" align="left"></a></td>	
		<td><b>STUDENT MANAGEMENT GROUP</b><br>http://www.student-management.com<br><br></td></tr>
		<tr><td colspan="2"><p>Sorry, we could not process your request at this time.<br>The id provided does not match with any of our students.</p>
				<p>Please try again.</p><p>If you are still having problems, please contact your facilitator.</p></td></tr>		
		</table>
		<cfabort>
	</cfif>
<cfelse>
		<table width=400 border=0>
		<td><a href="http://www.case-usa.org"><img src="internal/pics/logos/10.gif"  alt="" border="0" align="left"></a></td>	
		<td><b>CASE</b><br>http://www.case-usa.org<br><br></td></tr>
		<tr><td colspan="2"><p>Sorry, an error has occur and we could not process your request at this time.</p>
				<p>Please try again.</p><p>If you are still having problems, please contact your facilitator.</p></td></tr>		
		</table>
	<cfabort>
</Cfif>

<cfquery name="get_students_area_rep_follow" datasource="caseusa">
SELECT smg_students.studentid, smg_students.arearepid, smg_users.*
FROM smg_students 
INNER JOIN smg_users ON smg_students.arearepid = smg_users.userid
WHERE smg_students.studentid = #get_student_info.studentid#
</cfquery>

<cfquery name="get_host" datasource="caseusa">
SELECT s.studentid, s.hostid,
		h.familylastname, h.fatherfirstname, h.fatherlastname, h.motherfirstname, h.motherlastname, h.address, h.address2, h.city, h.state, h.zip, h.phone
FROM smg_students s
INNER JOIN smg_hosts h ON s.hostid = h.hostid
WHERE s.studentid = #get_student_info.studentid#
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
ORDER BY dep_date, dep_time
</cfquery>

<cfquery name="get_dep" datasource="caseusa">
SELECT flightid, studentid, dep_date, dep_city, dep_aircode, dep_time, flight_number, arrival_city, 
		arrival_aircode, arrival_time, overnight, flight_type
FROM smg_flight_info
WHERE studentid = '#get_student_info.studentid#' and flight_type = 'departure'
ORDER BY dep_date, dep_time
</cfquery>

<!-----Director----->
<!---- THe folling querys: pull region using %LIKE% to capture all users with 9 or 19 as an exampel.  Then 
loop through those user and pull there regions, compare there regions including usertype and company to the one we 
want the report for.  Only one user should end up with a 9 and 5 and company 1.  Set that user to the Regional Director.---->
<cfquery name="determin_regin" datasource="caseusa">
select userid
from smg_users
where regions like '%#get_Student_info.regionassigned#%' and usertype = 5 and companyid like '%#get_student_info.companyid#%'
</cfquery>
<!--
<cfset pos_list = 0>
-->

<Cfloop query="determin_regin">
	<cfquery name="select_region_list" datasource="caseusa">
		select regions
		from smg_users where userid = #userid#
	</cfquery>
	<cfloop list="#select_region_list.regions#" index=i>
	<cfif #i# is #get_Student_info.regionassigned#><cfset pos_list = #determin_regin.userid#> </cfif>
	</cfloop>
</Cfloop>

<cfquery name="regional_director" datasource="caseusa">
select firstname, lastname, userid, address, address2, city, state, zip, phone, email, fax 
from smg_users
where userid = #pos_list# and usertype = 5
</cfquery>

<!-----Facilitator----->
<cfif #get_student_info.regionassigned# is not 0>
	<cfquery name="get_facilitator" datasource="caseusa">
	select firstname, lastname 
	from smg_users
	where userid = '#regions.regionfacilitator#' 
	</cfquery>
</cfif>

<link rel="stylesheet" href="newsmg/profile.css" type="text/css">
<link rel="stylesheet" href="newsmg/reports/reports.css" type="text/css">

<style type="text/css">
table.nav_bar { font-size: 10px; background-color: #ffffff; border: 1px solid #999999; }
.style3 {font-size: 13px}
</style>

<cfoutput>
<table width=680 align="center" border=0 bgcolor="FFFFFF">
	<tr>
	<td  valign="top" width=90><span id="titleleft">
		TO:<br>
		RD:<br>
		FAX:<br>
		E-MAIL:<br><br><br>		
		Today's Date:<br></td>
	<td  valign="top"><span id="titleleft">
		#regions.regionname#<br>
		#regional_director.firstname# #regional_director.lastname# <br>
		#regional_director.fax#<br>
		<a href="mailto:#regional_director.email#">#regional_director.email#</a><br><br><br>
		#DateFormat(now(), 'dddd, mmmm dd, yyyy')#<br></td>
	<td><img src="newsmg/pics/logos/#get_student_info.companyid#.gif"  alt="" border="0" align="right"></td>	
	<td valign="top" align="right"> 
		<div align="right"><span id="titleleft">
		#get_student_info.companyshort#<br>
		#get_student_info.compaddress#<br>
		#get_student_info.compcity#, #get_student_info.compstate# #get_student_info.compzip#<br><br>
		<cfif get_student_info.compphone is ''><cfelse> Phone: #get_student_info.compphone#<br></cfif>
		<cfif get_student_info.comptoll_free is ''><cfelse> Toll Free: #get_student_info.comptoll_free#<br></cfif>
		<cfif get_student_info.compfax is ''><cfelse> Fax: #get_student_info.compfax#<br></cfif></div></td></tr>		
</table><br>

<table  width=680 align="center" border=0 bgcolor="FFFFFF" >
<tr><td><hr width=80% align="center"></td></tr>
<tr>
	<td>
    <div align="justify"><span class="application_section_header"><font size=+1><b><u>Flight Information</u></b></font></span><br><br>
		<p>We are pleased to give you the flight information for the following student:<br>
		Please pass this information to the host family as soon as possible and in case of any doubt do not hesitate to contact us.</p>
	 </div></td></tr>
</table><br>

<table width=680 border=0 align="center" bgcolor="FFFFFF">
	<tr><td width="60" class="style3"><b>Program: </b></td><td class="style3">#get_student_info.programname#</td></tr>
	<tr><td></td></tr><tr><td></td></tr>
	<tr><td class="style3"><b>Student: </b></td><td width="370" class="style3">#get_student_info.firstname# #get_student_info.familylastname# (#get_student_info.studentid#)</td>
		<td class="style3"><b>Region: </b></td><td class="style3">#regions.regionname#</td></tr>
	<tr><td colspan=4 class="style3"><hr width=100% align="center"></td></tr>
</table>

<table width=680 border=0 align="center" bgcolor="FFFFFF">	
	<tr><td width="80" class="style3"><b>Intl. Rep.: </b></td><td class="style3">#get_student_info.intfirstname# #get_student_info.intlastname# &nbsp &nbsp #get_student_info.businessname# &nbsp &nbsp Phone : &nbsp #get_student_info.intbusinessphone#</td></tr>	
	<tr><td class="style3"></td></tr><tr><td class="style3"></td></tr>
	<tr><td class="style3"><b>Area Rep.: </b></td><td class="style3">#get_students_area_rep_follow.firstname# #get_students_area_rep_follow.lastname# &nbsp &nbsp Phone : &nbsp #get_students_area_rep_follow.phone#</td></tr>	
	<tr><td class="style3"></td></tr><tr><td class="style3"></td></tr>
	<tr><td class="style3"><b>Host Family.: </b></td>
		<td class="style3">
		<cfif get_host.fatherfirstname is not ''>Mr. #get_host.fatherfirstname#</cfif> <cfif #get_host.fatherlastname# is not #get_host.motherlastname#>#get_host.fatherlastname#</cfif>
		<cfif get_host.fatherfirstname is not '' and get_host.motherfirstname is not ''> and </cfif>
		<cfif get_host.motherfirstname is not ''>Mrs. #get_host.motherfirstname#</cfif> <cfif #get_host.fatherlastname# is not #get_host.motherlastname#>#get_host.motherlastname#<Cfelse>
		#get_host.familylastname#</cfif> (#get_host.hostid#) &nbsp &nbsp Phone : &nbsp #get_host.phone#</td></tr>	
	<tr><td class="style3"></td><td class="style3">#get_host.address#, #get_host.city#, #get_host.state# &nbsp #get_host.zip#</td></tr>
</table>

<!--- ARRIVAL INFORMATION --->
<cfif get_arrival.recordcount GT '0'><br>
	<table border="1" align="center" width="680" bordercolor="C0C0C0" valign="top" cellpadding="3" cellspacing="1">
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
<table width=680 border=0 align="center" bgcolor="FFFFFF">
<tr><td align="left" class="style3">
  <br>Regards,<br>
  #get_facilitator.firstname# #get_facilitator.lastname#
</td></tr>
</table>
</cfoutput>