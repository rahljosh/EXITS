<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Flight Information</title>
<link rel="stylesheet" href="reports.css" type="text/css">
</head>

<body>

<style type="text/css">
table.nav_bar { font-size: 10px; background-color: #ffffff; border: 1px solid #999999; }
.style3 {font-size: 13px}
</style>

<cfif isdefined('url.unqid')>
	<cfquery name="get_unqid" datasource="MySql">
		SELECT *
		FROM smg_students
		WHERE uniqueid = '#url.unqid#'
	</cfquery>
	<cfset client.studentid = #get_unqid.studentid#>
</cfif>

<cfinclude template="../querys/get_student_info.cfm">
<cfinclude template="../querys/get_students_host.cfm">
<cfinclude template="../querys/get_students_area_rep_follow.cfm">

<!-----Company Information----->
<Cfquery name="companyshort" datasource="MySQL">
select *
from smg_companies
where companyid = #get_student_info.companyid#
</Cfquery>

<!-----Intl. Agent----->
<cfquery name="get_int_Agent" datasource="MySQL">
select companyid, businessname, fax, email, firstname, lastname, businessphone
from smg_users 
where userid = #get_Student_info.intrep#
</cfquery>

<!-----Program Name----->
<cfquery name="program_name" datasource="MySQL">
select programname
from smg_programs
where programid = #get_Student_info.programid#
</cfquery>

<!-----Regions----->
<cfquery name="regions" datasource="MySQL">
select regionname, regionfacilitator
from smg_regions
where regionid = #get_Student_info.regionassigned#
</cfquery>

<!-----Facilitator----->
<cfif #get_student_info.regionassigned# is not 0>
	<cfquery name="get_facilitator" datasource="MySQL">
	select firstname, lastname 
	from smg_users
	where userid = '#regions.regionfacilitator#' 
	</cfquery>
</cfif>

<cfquery name="get_arrival" datasource="MySql">
	SELECT 
    	flightid, studentid, dep_date, dep_city, dep_aircode, dep_time, flight_number, arrival_city, 
		arrival_aircode, arrival_time, overnight, flight_type
    FROM 
        smg_flight_info
    WHERE 
        studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_student_info.studentid#">
    AND 
        flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="arrival">
    AND
        isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">  
	ORDER BY 
    	flightid 
		<!--- dep_date, dep_time --->
</cfquery>

<cfquery name="get_dep" datasource="MySql">
	SELECT 
    	flightid, studentid, dep_date, dep_city, dep_aircode, dep_time, flight_number, arrival_city, 
		arrival_aircode, arrival_time, overnight, flight_type
    FROM 
        smg_flight_info
    WHERE 
        studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_student_info.studentid#">
    AND 
        flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="departure">
    AND
        isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">  
	ORDER BY 
    	flightid 
		<!--- dep_date, dep_time --->
</cfquery>

<cfoutput>
<table width=680 align="center" border=0 bgcolor="FFFFFF">
	<tr>
	<td  valign="top" width=90><span id="titleleft">
		TO:<br>
		FAX:<br>
		Today's Date:<br>
	</td>
	<td  valign="top"><span id="titleleft">
		#get_int_Agent.businessname# - #get_int_Agent.firstname# #get_int_Agent.lastname#<br>
		#get_int_Agent.fax#<br>
		#DateFormat(now(), 'dddd, mmmm dd, yyyy')#<br>
	</td>
	<td><img src="../pics/logos/#get_student_info.companyid#.gif"  alt="" border="0" align="right"></td>	
	<td valign="top" align="right"> 
		<div align="right"><span id="titleleft">
		#companyshort.companyshort#<br>
		#companyshort.address#<br>
		#companyshort.city#, #companyshort.state# #companyshort.zip#<br><br>
		<cfif companyshort.phone is ''><cfelse> Phone: #companyshort.phone#<br></cfif>
		<cfif companyshort.toll_free is ''><cfelse> Toll Free: #companyshort.toll_free#<br></cfif>
		<cfif companyshort.fax is ''><cfelse> Fax: #companyshort.fax#<br></cfif></div>
	</td></tr>		
</table>
<br>

<table  width=680 align="center" border=0 bgcolor="FFFFFF" >
<tr><td><hr width=80% align="center"></td></tr>
<tr>
	<td>
    <div align="justify"><span class="application_section_header"><font size=+1><b><u>Flight Information</u></b></font></span><br>
		<p>We are pleased to give you the flight information for the following student:<br>
		Please pass this information to the host family as soon as possible and in case of any doubt do not hesitate to contact us.</p>
	 </div></td></tr>
</table>
     <br>

  <table width=680 border=0 align="center" bgcolor="FFFFFF">
	<tr><td width="60" class="style3"><b>Program :</b></td><td class="style3">#program_name.programname#</td></tr>
	<tr><td></td></tr><tr><td></td></tr>
	<tr><td class="style3"><b>Student: </b></td><td width="370" class="style3">#get_student_info.firstname# #get_student_info.familylastname# (#get_student_info.studentid#)</td>
		<td class="style3"><b>Region: </b></td><td class="style3">#regions.regionname#</td>
	</tr>
	<tr><td colspan=4 class="style3"><hr width=100% align="center"></td></tr>
</table>

<table width=680 border=0 align="center" bgcolor="FFFFFF">	
	<tr><td width="80" class="style3"><b>Intl. Rep.: </b></td><td class="style3">#get_int_Agent.firstname# #get_int_Agent.lastname# &nbsp &nbsp #get_int_Agent.businessname# &nbsp &nbsp Phone : &nbsp #get_int_Agent.businessphone#</td></tr>	
	<tr><td class="style3"></td></tr><tr><td class="style3"></td></tr>
	
	<tr><td class="style3"><b>Area Rep.: </b></td><td class="style3">#get_students_area_rep_follow.firstname# #get_students_area_rep_follow.lastname# &nbsp &nbsp Phone : &nbsp #get_students_area_rep_follow.phone#</td></tr>	
	<tr><td class="style3"></td></tr><tr><td class="style3"></td></tr>
	
	<tr><td class="style3"><b>Host Family.: </b></td><td class="style3"><cfif get_students_host.fatherfirstname is ''> <cfelse>Mr. #get_students_host.fatherfirstname# <cfif get_students_host.motherfirstname is ''><cfelse> and</cfif> </cfif>Mrs. #get_students_host.motherfirstname# #get_students_host.familylastname# (#get_students_host.hostid#) &nbsp &nbsp Phone : &nbsp #get_students_host.phone#</td></tr>	
	<tr><td class="style3"></td><td class="style3">#get_students_host.address#, #get_students_host.city#, #get_students_host.state# &nbsp #get_students_host.zip#</td></tr>
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

<cfif get_student_info.flight_info_notes is not ''>
<table border="1" align="center" width="680" bordercolor="C0C0C0" valign="top" cellpadding="3" cellspacing="1">
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
<table width=680 border=0 align="center" bgcolor="FFFFFF">
<tr><td align="left" class="style3">
  <br>Regards,<br>
  #get_facilitator.firstname# #get_facilitator.lastname#
</td></tr>
</table>
</cfoutput>

</body>
</html>
