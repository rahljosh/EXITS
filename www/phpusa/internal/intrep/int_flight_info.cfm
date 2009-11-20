<!--- revised by Josh Rahl on 09/29/2005 --->
<link rel="stylesheet" href="../smg.css" type="text/css">
<style type="text/css">
table.nav_bar { font-size: 10px; background-color: #ffffff; border: 1px solid #2E5872; }
</style>



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
<!-----Script to show certain fields---->
function changeDiv(the_div,the_change)
{
  var the_style = getStyleObject(the_div);
  if (the_style != false)
  {
    the_style.display = the_change;
  }
}
function getStyleObject(objectId) {
	if (document.getElementById && document.getElementById(objectId)) {
	return document.getElementById(objectId).style;
	} else if (document.all && document.all(objectId)) {
	return document.all(objectId).style;
	} else {
	return false;
	}
}
function extensiondate(startdate,enddate) {
if (document.form1.insu_dp_trans_type.value == 'extension') {
		document.form1.insu_dp_new_date.value = (startdate);
	} else {
		document.form1.insu_dp_new_date.value = "";
	}
if (document.form1.insu_dp_trans_type.value == 'early return') {
		document.form1.insu_dp_end_date.value = (enddate);
	} else {
		document.form1.insu_dp_end_date.value = ""
	}
}
// -->
</script>

<Title>Flight Information</title>
<!---If linking in from Int Agent imputing flight info, get student ID---->
<cfif isDefined ('url.unqid')>
	<cfquery name="get_student_id" datasource="MySQL">
	select studentid 
	from smg_students
	where uniqueid = '#url.unqid#'
	</cfquery>
	<cfset client.studentid = #get_student_id.studentid#>
</cfif> 


<cfinclude template="../querys/get_company_short.cfm">

<Cfquery name="get_student_info" datasource="MySQL">
	SELECT  s.familylastname, s.firstname, s.studentid, s.hostid, s.flight_info_notes, 
			s.insurance,
			u.insurance_typeid, u.businessname,
			p.insurance_startdate,
			h.airport_city, h.major_air_code
	FROM smg_students s
	INNER JOIN smg_users u ON u.userid = s.intrep
	INNER JOIN smg_programs p ON p.programid = s.programid
	LEFT OUTER JOIN smg_hosts h ON h.hostid = s.hostid
	WHERE studentid = #client.studentid#
</Cfquery>

<cfquery name="get_arrival" datasource="MySql">
	SELECT flightid, studentid, dep_date, dep_city, dep_aircode, dep_time, flight_number, arrival_city, 
			arrival_aircode, arrival_time, overnight, flight_type
	FROM smg_flight_info
	WHERE studentid = '#client.studentid#' and flight_type = 'arrival'
	ORDER BY flightid <!--- dep_date, dep_time --->
</cfquery>

<cfquery name="get_departure" datasource="MySql">
	SELECT flightid, studentid, dep_date, dep_city, dep_aircode, dep_time, flight_number, arrival_city, 
			arrival_aircode, arrival_time, overnight, flight_type
	FROM smg_flight_info
	WHERE studentid = '#client.studentid#' and flight_type = 'departure'
	ORDER BY flightid <!--- dep_date, dep_time --->
</cfquery>

<cfoutput><br>
<table width=100% cellpadding=0 cellspacing=0 border=0 align="center">
	<tr valign=middle height=24>
		<td width="100%" valign="middle" bgcolor="##e9ecf1"><h2 align="left" class="style1">FLIGHT INFORMATION</h2></td>
	</tr>
</table>
</cfoutput>

<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
	<cfif get_student_info.insurance_typeid GT '1'>
	<tr><td align="center"><font color="FF0000">* Please be aware that flight information provided by you will affect the student's insurance start or end date. Please submit only confirmed arrivals/departures.</font></td></tr>
	</cfif>
	<tr><td width="100%">
<cfparam name="edit" default="yes">
<cfform name="form1" action="qr_int_flight_info.cfm">
<cfoutput query="get_student_info">
		
	<!--- A R R I V A L    I N F O R M A T I O N    --->
	<table border="0" align="center" width="99%" bordercolor="C0C0C0" valign="top" cellpadding="3" cellspacing="1">
	<th colspan=11 bgcolor="ACB9CD"> A R R I V A L &nbsp;&nbsp; T O &nbsp; &nbsp; U S A &nbsp; &nbsp; I N F O R M A T I O N </th>
	<tr bgcolor="ACB9CD">
		<th><font size="-2"><b>Delete</b></font></th><th>Date (mm/dd/yyyy)</th><th>Departure City</th><th>Airport Code</th><th>Arrival City</th><th>Airport Code</th>
		<th>Flight Number</th><th>Departure Time (12:00am)</th><th>Arrival Time(12:00am)</th><th>Overnight Flight</th><th><font size="-2"><b>Status</b></font></th>
	</tr>
	<tr bgcolor="ACB9CD"><td colspan="11">The Aiport Arrival is: &nbsp; #airport_city# - #major_air_code#</td></tr> 
	<cfif get_arrival.recordcount is '0' or IsDefined('url.add_arr')>
		<input type="hidden" name="ar_update" value='new'>
		<cfif get_arrival.recordcount GT '0'>
		<cfloop query="get_arrival"> <!--- previous information --->
		<tr bgcolor="D5DCE5">
			<td align="center"><a href="del_int_flight_info.cfm?flightid=#flightid#" onClick="return areYouSure(this);"><img src="../pics/deletex.gif" border="0"></img></a></td>
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
		<tr bgcolor="D5DCE5">
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
		<tr bgcolor="D5DCE5">
				<input type="hidden" name="ar_flightid#get_arrival.currentrow#" value="#flightid#">
			<td align="center"><a href="del_int_flight_info.cfm?flightid=#flightid#" onClick="return areYouSure(this);"><img src="../pics/deletex.gif" border="0"></img></a></td>
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
		<tr bgcolor="D5DCE5"><td colspan="11" align="center"><a href="int_flight_info.cfm?add_arr=yes">Add more legs to the flight information above</a></td></tr>
		<tr bgcolor="D5DCE5"><td colspan="11" align="center"><font size=-1>*Flight tracking information by Travelocity, not all flights will be available. #companyshort.companyshort# is not responsible for information on or gathered from travelocity.com.</td></tr>
	</cfif>
	</table><br>
	
	<table border="0" align="center" width="99%" bordercolor="C0C0C0" valign="top" cellpadding="3" cellspacing="1">
	<th bgcolor="ACB9CD"> N O T E S &nbsp; O N &nbsp; T H I S &nbsp; F L I G H T &nbsp; I N F O R M A T I O N </tr>
	<tr bgcolor="D5DCE5"><td align="center"><textarea cols="75" rows="3" name="flight_notes" wrap="VIRTUAL">#get_student_info.flight_info_notes#</textarea></td></tr>
	</table><br>
	
	<!--- D E P A R T U R E      I N F O R M A T I O N    --->
	<table border="0" align="center" width="99%" bordercolor="C0C0C0" valign="top" cellpadding="3" cellspacing="1">
	<th colspan="11" bgcolor="FDCEAC">D E P A R T U R E &nbsp;&nbsp; F R O M &nbsp; &nbsp; U S A  &nbsp; &nbsp; I N F O R M A T I O N</th>
	<tr bgcolor="FDCEAC">
		<th><font size="-2"><b>Delete</b></font></th><th>Date (mm/dd/yyyy)</th><th>Departure City</th><th>Airport Code</th><th>Arrival City</th><th>Airport Code</th>
		<th>Flight Number</th><th>Departure Time(12:00am)</th><th>Arrival Time(12:00am)</th><th>Overnight Flight</th><th><font size="-2"><b>Status</b></font></th>
	</tr>
	<cfif get_departure.recordcount is '0' or IsDefined('url.add_dep')>
		<input type="hidden" name="dp_update" value='new'>
		<cfif get_departure.recordcount GT 0> <!--- previous information --->
		<cfloop query="get_departure">
		<tr bgcolor="FEE6D3">
			<td align="center"><a href="del_int_flight_info.cfm?flightid=#flightid#" onClick="return areYouSure(this);"><img src="../pics/deletex.gif" border="0"></img></a></td>
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
		<tr bgcolor="FEE6D3">
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
		<tr bgcolor="FEE6D3">
				<input type="hidden" name="dp_flightid#get_departure.currentrow#" value="#flightid#">
			<td align="center"><a href="del_int_flight_info.cfm?flightid=#flightid#" onClick="return areYouSure(this);"><img src="../pics/deletex.gif" border="0"></img></a></td>
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
		<tr bgcolor="FEE6D3"><td colspan="11" align="center"><a href="int_flight_info.cfm?add_dep=yes">Add more legs to the flight information above</a></td></tr>
		<tr bgcolor="FEE6D3"><td colspan="11" align="center"><font size=-1>*Flight tracking information by Travelocity, not all flights will be available. #companyshort.companyshort# is not responsible for information on or gathered from travelocity.com.</td></tr>
	</cfif>
	</table>
	
</td></tr>
</table>  <!--- main table --->

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr><td align="right" width="50%"><input name="Submit" type="image" src="../pics/update.gif" border=0 alt=" update ">&nbsp;</td>
		<td align="left" width="50%">&nbsp;<input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()"></td></tr>
</table>


</cfoutput>
</cfform>