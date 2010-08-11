<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<Title>Flight Information</title>
	<script type="text/javascript">
	<!--
	function areYouSure() { 
	   if(confirm("You are about to delete this flight information. Click OK to continue")) { 
		 form.submit(); 
			return true; 
	   } else { 
			return false; 
	   } 
	} 
	</script>
</head>

<body>

<cfif NOT IsDefined('url.unqid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<cfinclude template="../querys/get_company_short.cfm">

<cfquery name="get_student_unqid" datasource="mysql">
	SELECT  s.familylastname, s.firstname, s.studentid,  s.flight_info_notes, s.uniqueid,
			u.php_insurance_typeid, u.businessname, s.schoolid,
			p.insurance_startdate,
			php_schools.airport_city, php_schools.major_air_code, php_school_dates.year_begins
	FROM smg_students s
	INNER JOIN php_students_in_program stu_prog ON stu_prog.studentid = s.studentid
	INNER JOIN smg_users u ON u.userid = s.intrep
	INNER JOIN smg_programs p ON p.programid = stu_prog.programid
	LEFT JOIN php_schools ON php_schools.schoolid = stu_prog.schoolid
	LEFT JOIN php_school_dates ON php_school_dates.schoolid = stu_prog.schoolid
	WHERE s.uniqueid = <cfqueryparam value="#url.unqid#" cfsqltype="cf_sql_char">
</Cfquery>

<cfquery name="get_arrival" datasource="mysql">
	SELECT flightid, studentid, dep_date, dep_city, dep_aircode, dep_time, flight_number, arrival_city, 
			arrival_aircode, arrival_time, overnight, flight_type
	FROM smg_flight_info
	WHERE studentid = '#get_student_unqid.studentid#' 
		AND flight_type = 'arrival'
		
	ORDER BY flightid <!--- dep_date, dep_time --->
</cfquery>

<cfquery name="get_departure" datasource="mysql">
	SELECT flightid, studentid, dep_date, dep_city, dep_aircode, dep_time, flight_number, arrival_city, 
			arrival_aircode, arrival_time, overnight, flight_type
	FROM smg_flight_info
	WHERE studentid = '#get_student_unqid.studentid#' 
	AND flight_type = 'departure'
	
	ORDER BY flightid <!--- dep_date, dep_time --->
</cfquery>

<cfoutput>

<cfform name="form1" action="qr_flight_info.cfm">
<cfinput type="hidden" name="studentid" value="#get_student_unqid.studentid#">
<cfinput type="hidden" name="uniqueid" value="#get_student_unqid.uniqueid#">

<table border="0" align="center" width="99%" bordercolor="##C0C0C0" valign="top" cellpadding="3" cellspacing="1">
	<tr><th bgcolor="##ACB9CD">F L I G H T &nbsp; &nbsp; I N F O R M A T I O N</th></tr>
	<tr><th bgcolor="##ACB9CD">Student : #get_student_unqid.firstname# #get_student_unqid.familylastname# (###get_student_unqid.studentid#)</th></tr>
</table><br />

<!--- A R R I V A L    I N F O R M A T I O N    --->
<table border="0" align="center" width="99%" bordercolor="##C0C0C0" valign="top" cellpadding="3" cellspacing="1">
	<th colspan=11 bgcolor="##ACB9CD"> A R R I V A L &nbsp;&nbsp; T O &nbsp; &nbsp; U S A &nbsp; &nbsp; I N F O R M A T I O N </th>
	<tr bgcolor="##ACB9CD">
		<th><font size="-2"><b>Delete</b></font></th><th>Date (mm/dd/yyyy)</th><th>Departure City</th><th>Airport Code</th><th>Arrival City</th><th>Airport Code</th>
		<th>Flight Number</th><th>Departure Time (12:00am)</th><th>Arrival Time(12:00am)</th><th>Overnight Flight</th><th><font size="-2"><b>Status</b></font></th>
	</tr>
	<tr bgcolor="##ACB9CD"><td colspan="11">The Aiport Arrival is: &nbsp; #get_student_unqid.airport_city# - #get_student_unqid.major_air_code#</td></tr> <tr bgcolor="##ACB9CD"><td colspan="11">First Day Of Class: &nbsp; <font color="##FF0000">#DateFormat(get_student_unqid.year_begins, 'mm/dd/yyyy')#</font></td>
	</tr> 
	<cfif get_arrival.recordcount is '0' or IsDefined('url.add_arr')>
		<input type="hidden" name="ar_update" value='new'>
		<cfif get_arrival.recordcount GT '0'>
		<cfloop query="get_arrival"> <!--- previous information --->
		<tr bgcolor="##D5DCE5">
			<td align="center"><cfif client.usertype LTE 4><a href="qr_flight_info_del.cfm?unqid=#get_student_unqid.uniqueid#&flightid=#flightid#" onClick="return areYouSure(this);"><img src="../pics/deletex.gif" border="0"></img></a></cfif></td>
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
				<input type="checkbox" name="ar_overnight#get_arrival.currentrow#" value="#overnight#" #chk# readonly="yes" disabled></input></td>
			<td align="center">
				<cfif flight_number is not ''>
				<a href="http://dps1.travelocity.com/dparflifo.ctl?aln_name=#left(flight_number,2)#&flt_num=#RemoveChars(flight_number,1,2)#" target="blank"><img src="../pics/arrow.gif" border="0"></img></a><cfelse>n/a</cfif></td>
		</tr>
		</cfloop>
		</cfif>
		<cfloop from = "1" to = "4" index="i"> <!--- ADD NEW FLIGHT INFORMATION --->
		<tr bgcolor="##D5DCE5">
			<td>&nbsp;</td>
			<td><cfinput type="text" name="ar_dep_date#i#" size="6" maxlength="10" validate="date"></cfinput></td>
			<td><cfinput type="text" name="ar_dep_city#i#" size="7" maxlength="40"></cfinput></td>
			<td><cfinput type="text" name="ar_dep_aircode#i#" size="1" maxlength="3" onChange="javascript:this.value=this.value.toUpperCase();"></cfinput></td>
			<td><cfinput type="text" name="ar_arrival_city#i#" size="7" maxlength="40"></cfinput></td>
			<td><cfinput type="text" name="ar_arrival_aircode#i#" size="1" maxlength="3" onChange="javascript:this.value=this.value.toUpperCase();"></cfinput></td>
			<td><cfinput type="text" name="ar_flight_number#i#" size="4" maxlength="8" onChange="javascript:this.value=this.value.toUpperCase();"></cfinput></td>
			<td><cfinput type="text" name="ar_dep_time#i#" size="5" maxlength="8"></cfinput></td>
			<td><cfinput type="text" name="ar_arrival_time#i#" size="5" maxlength="8"></cfinput></td>
			<td align="center"><cfinput type="checkbox" name="ar_overnight#i#"></cfinput></td>
			<td align="center">&nbsp;</td>
		</tr>
		</cfloop>
	<cfelse> <!--- EDIT FLIGHT INFORMATION --->
		<input type="hidden" name="ar_update" value='update'>
		<input type="hidden" name="ar_count" value='#get_arrival.recordcount#'>
		<cfloop query="get_arrival">
		<tr bgcolor="##D5DCE5">
				<input type="hidden" name="ar_flightid#get_arrival.currentrow#" value="#flightid#">
			<td align="center"><cfif client.usertype LTE 4><a href="qr_flight_info_del.cfm?unqid=#get_student_unqid.uniqueid#&flightid=#flightid#" onClick="return areYouSure(this);"><img src="../pics/deletex.gif" border="0"></img></a></cfif></td>
			<td><cfinput type="text" name="ar_dep_date#get_arrival.currentrow#" size="6" maxlength="10" value="#DateFormat(dep_date , 'mm/dd/yyyy')#"></cfinput></td>
			<td><cfinput type="text" name="ar_dep_city#get_arrival.currentrow#" size="7" maxlength="40" value="#dep_city#"></cfinput></td>
			<td><cfinput type="text" name="ar_dep_aircode#get_arrival.currentrow#" size="1" maxlength="3" value="#dep_aircode#" onChange="javascript:this.value=this.value.toUpperCase();"></cfinput></td>
			<td><cfinput type="text" name="ar_arrival_city#get_arrival.currentrow#" size="7" maxlength="40" value="#arrival_city#"></cfinput></td>
			<td><cfinput type="text" name="ar_arrival_aircode#get_arrival.currentrow#" size="1" maxlength="3" value="#arrival_aircode#" onChange="javascript:this.value=this.value.toUpperCase();"></cfinput></td>
			<td><cfinput type="text" name="ar_flight_number#get_arrival.currentrow#" size="4" maxlength="8" value="#flight_number#" onChange="javascript:this.value=this.value.toUpperCase();"></cfinput></td>
			<td><cfinput type="text" name="ar_dep_time#get_arrival.currentrow#" size="5" maxlength="8" value="#TimeFormat(dep_time, 'hh:mm tt')#"></cfinput></td>
			<td><cfinput type="text" name="ar_arrival_time#get_arrival.currentrow#" size="5" maxlength="8" value="#TimeFormat(arrival_time, 'h:mm tt')#"></cfinput></td>
			<td align="center"><cfif overnight is 0><cfset chk ='no'><cfelse><cfset chk ='yes'></cfif>
				<cfinput type="checkbox" name="ar_overnight#get_arrival.currentrow#" value="#overnight#" checked="#chk#"></cfinput></td>
			<td align="center">
				<cfif flight_number is not ''>
				<a href="http://dps1.travelocity.com/dparflifo.ctl?aln_name=#left(flight_number,2)#&flt_num=#RemoveChars(flight_number,1,2)#" target="blank"><img src="../pics/arrow.gif" border="0"></img></a><cfelse>n/a</cfif></td>
		</tr>	
		</cfloop>
		<cfif client.usertype LTE 4>
		<tr bgcolor="##D5DCE5"><td colspan="11" align="center"><a href="flight_info.cfm?unqid=#get_student_unqid.uniqueid#&add_arr=yes">Add more legs to the flight information above</a></td></tr>
		</cfif>
		<tr bgcolor="##D5DCE5"><td colspan="11" align="center"><font size=-1>*Flight tracking information by Travelocity, not all flights will be available. DMD Private High School is not responsible for information on or gathered from travelocity.com.</td></tr>
	</cfif>
</table><br>
	
<table border="0" align="center" width="99%" bordercolor="##C0C0C0" valign="top" cellpadding="3" cellspacing="1">
	<th bgcolor="##ACB9CD"> N O T E S &nbsp; O N &nbsp; T H I S &nbsp; F L I G H T &nbsp; I N F O R M A T I O N </tr>
	<tr bgcolor="##D5DCE5"><td align="center"><textarea cols="75" rows="3" name="flight_notes" wrap="VIRTUAL">#get_student_unqid.flight_info_notes#</textarea></td></tr>
</table><br>
		
<!--- D E P A R T U R E      I N F O R M A T I O N    --->
<table border="0" align="center" width="99%" bordercolor="##C0C0C0" valign="top" cellpadding="3" cellspacing="1">
	<th colspan="11" bgcolor="##FDCEAC">D E P A R T U R E &nbsp;&nbsp; F R O M &nbsp; &nbsp; U S A  &nbsp; &nbsp; I N F O R M A T I O N</th>
	<tr bgcolor="##FDCEAC">
		<th><font size="-2"><b>Delete</b></font></th><th>Date (mm/dd/yyyy)</th><th>Departure City</th><th>Airport Code</th><th>Arrival City</th><th>Airport Code</th>
		<th>Flight Number</th><th>Departure Time(12:00am)</th><th>Arrival Time(12:00am)</th><th>Overnight Flight</th><th><font size="-2"><b>Status</b></font></th>
	</tr>
	<cfif get_departure.recordcount is '0' or IsDefined('url.add_dep')>
		<input type="hidden" name="dp_update" value='new'>
		<cfif get_departure.recordcount GT 0> <!--- previous information --->
		<cfloop query="get_departure">
		<tr bgcolor="##FEE6D3">
			<td align="center"><cfif client.usertype LTE 4><a href="qr_flight_info_del.cfm?unqid=#get_student_unqid.uniqueid#&flightid=#flightid#" onClick="return areYouSure(this);"><img src="../pics/deletex.gif" border="0"></img></a></cfif></td>
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
				<input type="checkbox" name="ar_overnight#get_arrival.currentrow#" value="#overnight#" #chk# disabled></input></td>
			<td align="center">
				<cfif flight_number is not ''>
				<a href="http://dps1.travelocity.com/dparflifo.ctl?aln_name=#left(flight_number,2)#&flt_num=#RemoveChars(flight_number,1,2)#" target="blank"><img src="../pics/arrow.gif" border="0"></img></a><cfelse>n/a</cfif></td>
		</tr>
		</cfloop>
		</cfif>
		<cfloop from = "1" to = "4" index="i"> <!--- ADD NEW FLIGHT INFORMATION --->
		<tr bgcolor="##FEE6D3">
				<input type="hidden" name="dp_type#i#" value="departure">
			<td>&nbsp;</td>
			<td><cfinput type="text" name="dp_dep_date#i#" size="6" maxlength="10"></cfinput></td>
			<td><cfinput type="text" name="dp_dep_city#i#" size="7" maxlength="40"></cfinput></td>
			<td><cfinput type="text" name="dp_dep_aircode#i#" size="1" maxlength="3" onChange="javascript:this.value=this.value.toUpperCase();"></cfinput></td>
			<td><cfinput type="text" name="dp_arrival_city#i#" size="7" maxlength="40"></cfinput></td>
			<td><cfinput type="text" name="dp_arrival_aircode#i#" size="1" maxlength="3" onChange="javascript:this.value=this.value.toUpperCase();"></cfinput></td>
			<td><cfinput type="text" name="dp_flight_number#i#" size="4" maxlength="8" onChange="javascript:this.value=this.value.toUpperCase();"></cfinput></td>
			<td><cfinput type="text" name="dp_dep_time#i#" size="5" maxlength="8"></cfinput></td>
			<td><cfinput type="text" name="dp_arrival_time#i#" size="5" maxlength="8"></cfinput></td>
			<td align="center"><cfinput type="checkbox" name="dp_overnight#i#"></cfinput></td>
			<td>&nbsp;</td>
		</tr>
		</cfloop>
	<cfelse> <!--- ADD/EDIT FLIGHT INFORMATION --->
		<input type="hidden" name="dp_update" value='update'>
		<input type="hidden" name="dp_count" value='#get_departure.recordcount#'>
		<cfloop query="get_departure">	
		<tr bgcolor="##FEE6D3">
				<input type="hidden" name="dp_flightid#get_departure.currentrow#" value="#flightid#">
			<td align="center"><cfif client.usertype LTE 4><a href="qr_flight_info_del.cfm?unqid=#get_student_unqid.uniqueid#&flightid=#flightid#" onClick="return areYouSure(this);"><img src="../pics/deletex.gif" border="0"></img></a></cfif></td>
			<td><cfinput type="text" name="dp_dep_date#get_departure.currentrow#" size="6" maxlength="10" value="#DateFormat(dep_date , 'mm/dd/yyyy')#"></cfinput></td>
			<td><cfinput type="text" name="dp_dep_city#get_departure.currentrow#" size="7" maxlength="40" value="#dep_city#"></cfinput></td>
			<td><cfinput type="text" name="dp_dep_aircode#get_departure.currentrow#" size="1" maxlength="3" value="#dep_aircode#" onChange="javascript:this.value=this.value.toUpperCase();"></cfinput></td>
			<td><cfinput type="text" name="dp_arrival_city#get_departure.currentrow#" size="7" maxlength="40" value="#arrival_city#"></cfinput></td>
			<td><cfinput type="text" name="dp_arrival_aircode#get_departure.currentrow#" size="1" maxlength="3" value="#arrival_aircode#" onChange="javascript:this.value=this.value.toUpperCase();"></cfinput ></td>
			<td><cfinput type="text" name="dp_flight_number#get_departure.currentrow#" size="4" maxlength="8" value="#flight_number#" onChange="javascript:this.value=this.value.toUpperCase();"></cfinput></td>
			<td><cfinput type="text" name="dp_dep_time#get_departure.currentrow#" size="5" maxlength="8" value="#TimeFormat(dep_time, 'hh:mm tt')#"></cfinput></td>
			<td><cfinput type="text" name="dp_arrival_time#get_departure.currentrow#" size="5" maxlength="8" value="#TimeFormat(arrival_time, 'h:mm tt')#"></cfinput></td>
			<td align="center"><cfif overnight is 0><cfset chk ='no'><cfelse><cfset chk ='yes'></cfif>
				<cfinput type="checkbox" name="dp_overnight#get_departure.currentrow#" value="#overnight#" checked="#chk#"></cfinput></td>
			<td align="center">
				<cfif flight_number is not ''>
				<a href="http://dps1.travelocity.com/dparflifo.ctl?aln_name=#left(flight_number,2)#&flt_num=#RemoveChars(flight_number,1,2)#" target="blank"><img src="../pics/arrow.gif" border="0"></img></a><cfelse>n/a</cfif></td>
		</tr>	
		</cfloop>
		<cfif client.usertype LTE 4>
		<tr bgcolor="##FEE6D3"><td colspan="11" align="center"><a href="flight_info.cfm?unqid=#get_student_unqid.uniqueid#&add_dep=yes">Add more legs to the flight information above</a></td></tr>
		</cfif>
		<tr bgcolor="##FEE6D3"><td colspan="11" align="center"><font size=-1>*Flight tracking information by Travelocity, not all flights will be available. #companyshort.companyshort# is not responsible for information on or gathered from travelocity.com.</td></tr>
	</cfif>
</table>
	
<table border="0" align="center" width="99%" bordercolor="##C0C0C0" valign="top" cellpadding="3" cellspacing="1">
	<tr><cfif client.usertype LTE 4>
		<td align="right" width="50%"><input name="Submit" type="image" src="../pics/update.gif" border=0 alt=" update ">&nbsp;</td>
		</cfif>
		<td align="left" width="50%">&nbsp;<input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()"></td></tr>
</table>
</cfform>

</cfoutput>

</body>
</html>