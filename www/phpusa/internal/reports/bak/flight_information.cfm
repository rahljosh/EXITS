<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Flight Information</title>
<link rel="stylesheet" href="reports.css" type="text/css">
</head>

<body>

<cftry>

<Cfif not isdefined ('client.userid')>
	<cflocation url="../../axis.cfm?to" addtoken="no">
</Cfif>

<cfif NOT IsDefined('url.unqid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<cfinclude template="../querys/get_company_short.cfm">

<cfquery name="get_student_unqid" datasource="MySql">
	SELECT s.studentid, s.firstname, s.middlename, s.familylastname, s.dob, s.sex, s.uniqueid, s.flight_info_notes,
		sc.schoolid, sc.schoolname, sc.address, sc.city, sc.zip, sc.fax, sc.email, sc.contact, 
		sta.state as schoolstate,
		p.programid, p.programname,
		<!--- FROM THE NEW TABLE PHP_STUDENTS_IN_PROGRAM --->		
		stu_prog.assignedid, stu_prog.companyid, stu_prog.programid, stu_prog.hostid, stu_prog.schoolid, stu_prog.placerepid, stu_prog.arearepid,
		stu_prog.dateplaced, stu_prog.school_acceptance, stu_prog.active, stu_prog.i20no
	FROM smg_students s
	INNER JOIN php_students_in_program stu_prog ON stu_prog.studentid = s.studentid
	LEFT JOIN smg_programs p ON stu_prog.programid = p.programid
	LEFT JOIN php_schools sc ON stu_prog.schoolid = sc.schoolid 
	LEFT JOIN smg_states sta ON sc.state = sta.id 
	WHERE s.uniqueid = <cfqueryparam value="#url.unqid#" cfsqltype="cf_sql_char">
	ORDER BY assignedid DESC	
</cfquery>

<cfquery name="get_arrival" datasource="MySql">
	SELECT flightid, studentid, dep_date, dep_city, dep_aircode, dep_time, flight_number, arrival_city, 
			arrival_aircode, arrival_time, overnight, flight_type
	FROM smg_flight_info
	WHERE studentid = '#get_student_unqid.studentid#' 
		AND companyid = '#client.companyid#'
		AND flight_type = 'arrival'
	ORDER BY flightid <!--- dep_date, dep_time --->
</cfquery>

<cfquery name="get_dep" datasource="MySql">
	SELECT flightid, studentid, dep_date, dep_city, dep_aircode, dep_time, flight_number, arrival_city, 
			arrival_aircode, arrival_time, overnight, flight_type
	FROM smg_flight_info
	WHERE studentid = '#get_student_unqid.studentid#' 
		AND companyid = '#client.companyid#'
		AND flight_type = 'departure'
	ORDER BY flightid <!--- dep_date, dep_time --->
</cfquery>

<cfoutput>

<!--- Page Header --->
<table width="670" align="center" border=0 bgcolor="##FFFFFF" cellpadding="2"> 
	<tr>
		<td>
		<table>
			<tr><td>TO:</td><td>#get_student_unqid.schoolname#</td></tr>
			<tr><td>FAX:</td><td>#get_student_unqid.fax#</td></tr>
			<tr><td>E-MAIL:</td><td><a href="mailto:#get_student_unqid.email#">#get_student_unqid.email#</a></td></tr>
			<tr><td colspan="2">#DateFormat(now(), 'dddd, mmmm dd, yyyy')#</td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2">
						<cfform action="flight_information_email.cfm?unqid=#get_student_unqid.uniqueid#" name="sendemail" method="post" onsubmit="return confirm ('Are you sure? This Acceptance Letter will be sent to #get_student_unqid.schoolname# at #get_student_unqid.email#')">
						<cfinput name="send" type="image" src="../pics/send-email.gif" value="send email">
					</cfform>
				</td>
			</tr>
		</table>
		</td>
		<td valign="top" rowspan=4 align="center"><img src="../pics/dmd-logo.jpg"></td>
		<td valign="top" align="right" > 
			<b>#companyshort.companyname#</b><br>
			#companyshort.address#<br>
			#companyshort.city#, #companyshort.state# #companyshort.zip#<br><br>
			<cfif companyshort.phone NEQ ''> Phone: #companyshort.phone#<br></cfif>
			<cfif companyshort.toll_free NEQ ''> Toll Free: #companyshort.toll_free#<br></cfif>
			<cfif companyshort.fax NEQ ''> Fax: #companyshort.fax#<br></cfif>
		</td>
	</tr>
</table>

<table width="670" border=0 align="center" bgcolor="##FFFFFF" cellpadding="2">
	<tr><td width="15%"><b>Student : </b></td><td>#get_student_unqid.firstname# #get_student_unqid.familylastname# (###get_student_unqid.studentid#)</td></tr>
	<tr><td><b>Program :</b></td><td>#get_student_unqid.programname#</td></tr>	
	<tr><td><b>School : </b></td><td>#get_student_unqid.schoolname#</td></tr>	
	<tr><td></td><td>#get_student_unqid.address#, #get_student_unqid.city#, #get_student_unqid.schoolstate# &nbsp #get_student_unqid.zip#</td></tr>
</table>

<table  width="670" align="center" border=0 bgcolor="##FFFFFF">
	<tr><td><hr width=100% align="center"></td></tr>
	<tr>
		<td>
			<div align="center"><span class="application_section_header"><font size=+1><b><u>Flight Information</u></b></font></span></div><br>
			<div align="justify">	
				<p>We are pleased to give you the flight information for the following student:<br>
				Please pass this information to the host family as soon as possible and in case of any doubt do not hesitate to contact us.</p>
			 </div>
		 </td>
	</tr>
</table>

<!--- ARRIVAL INFORMATION --->
<cfif get_arrival.recordcount GT '0'>
	<table border="1" align="center" width="670" bordercolor="##C0C0C0" valign="top" cellpadding="3" cellspacing="1">
	<tr bgcolor="##ACB9CD"><th colspan="9"> A R R I V A L &nbsp; &nbsp; I N F O R M A T I O N </th></tr>
	<tr bgcolor="##ACB9CD">
		<th>Date</th><th>Departure City</th><th>Airport Code</th><th>Arrival City</th><th>Airport Code</th>
		<th>Flight Number</th><th>Departure Time</th><th>Arrival Time</th><th>Overnight Flight</th></tr>
	<cfloop query="get_arrival">
	<tr bgcolor="##D5DCE5">
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
	<tr bgcolor="##D5DCE5"><td colspan="9" align="center">Please note arrival time is the next day due to an overnight flight.</td></tr>
	</cfif>	
	</cfloop>
	</table><br>
</cfif>

<cfif get_student_unqid.flight_info_notes NEQ ''>
	<table border="1" align="center" width="670" bordercolor="##C0C0C0" valign="top" cellpadding="3" cellspacing="1">
		<th bgcolor="##ACB9CD"> N O T E S &nbsp; O N &nbsp; T H I S &nbsp; F L I G H T &nbsp; I N F O R M A T I O N</tr>
		<tr bgcolor="##D5DCE5"><td align="center"><div align="justify"><p>#get_student_unqid.flight_info_notes#</p></div></td></tr>
	</table><br>
</cfif>
  
<!--- DEPARTURE INFORMATION --->
<cfif get_dep.recordcount GT '0'>
	<table border="1" align="center" width="670" bordercolor="##C0C0C0" valign="top" cellpadding="3" cellspacing="1">
	<tr bgcolor="##FDCEAC"><th colspan="9"> D E P A R T U R E &nbsp; &nbsp; I N F O R M A T I O N </th></tr>
	<tr bgcolor="##FDCEAC">
		<th>Date</th><th>Departure City</th><th>Airport Code</th><th>Arrival City</th><th>Airport Code</th>
		<th>Flight Number</th><th>Departure Time</th><th>Arrival Time</th><th>Overnight Flight</th></tr>
	<cfloop query="get_dep">
	<tr bgcolor="##FEE6D3">
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
	<tr bgcolor="##FEE6D3"><td colspan="9" align="center">Please note arrival time is the next day due to an overnight flight.</td></tr>
	</cfif>			  
	</cfloop>
	</table><br>	
</cfif>

<table width="670" align="center" border=0 cellpadding="1" cellspacing="1">
	<tr><td>Thanks,</td></tr>	
	<tr><td>&nbsp;</td></tr>
	<tr><td><img src="../pics/lukesign.jpg" border="0"></td></tr>
	<tr><td>Luke Davis</td></tr>	
	<tr><td>#companyshort.companyname#</td></tr>			
</table><br />
</cfoutput>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>

</cftry>
</body>
</html>