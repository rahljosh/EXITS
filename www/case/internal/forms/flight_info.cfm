<!--- revised by Josh Rahl on 09/29/2005 --->
<link rel="stylesheet" href="../smg.css" type="text/css">
<style type="text/css">
table.nav_bar { font-size: 10px; background-color: #ffffff; border: 1px solid #2E5872; }
</style>
<cfif isDefined('url.studentid')>
	<cfset client.studentid = #url.studentid#>
</cfif> 
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

<cfinclude template="../querys/company_short.cfm">

<Cfquery name="get_student_info" datasource="caseusa">
	SELECT  s.familylastname, s.firstname, s.studentid, s.hostid, s.flight_info_notes, s.insurance, s.termination_date,
			u.insurance_typeid, u.businessname,
			p.insurance_startdate,
			h.airport_city, h.major_air_code
	FROM smg_students s
	INNER JOIN smg_users u ON u.userid = s.intrep
	INNER JOIN smg_programs p ON p.programid = s.programid
	LEFT OUTER JOIN smg_hosts h ON h.hostid = s.hostid
	WHERE studentid = #client.studentid#
</Cfquery>

<cfquery name="get_arrival" datasource="caseusa">
	SELECT flightid, studentid, dep_date, dep_city, dep_aircode, dep_time, flight_number, arrival_city, 
			arrival_aircode, arrival_time, overnight, flight_type
	FROM smg_flight_info
	WHERE studentid = '#client.studentid#' and flight_type = 'arrival'
	ORDER BY flightid <!--- dep_date, dep_time --->
</cfquery>

<cfquery name="get_departure" datasource="caseusa">
	SELECT flightid, studentid, dep_date, dep_city, dep_aircode, dep_time, flight_number, arrival_city, 
			arrival_aircode, arrival_time, overnight, flight_type
	FROM smg_flight_info
	WHERE studentid = '#client.studentid#' and flight_type = 'departure'
	ORDER BY flightid <!--- dep_date, dep_time --->
</cfquery>

<cfoutput><br>
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="../pics/header_background.gif"><img src="../pics/students.gif"></td>
		<td background="../pics/header_background.gif"><h2>FLIGHT INFORMATION</h2></td>
		<td align="right" background="../pics/header_background.gif"><h2>#get_student_info.firstname# #get_student_info.familylastname# (#get_student_info.studentid#)</h2></td>
		<td width=17 background="../pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>
</cfoutput>

<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
	<tr><td width="100%">
	
	<!--- WELL FORMATED HTML EMAIL --->
	<cfif client.usertype LTE 4>
		<table border="0" align="center" width="99%" bordercolor="C0C0C0" valign="top" cellpadding="3" cellspacing="1">
			<tr bgcolor="D5DCE5"><td align="center" width="50%">REGIONAL DIRECTOR</td><td align="center" width="50%">YOURSELF</td></tr>
			<tr bgcolor="D5DCE5"><td align="center" width="50%">
			<form name="email" action="../reports/email_flight_html.cfm" method="post" onsubmit="return confirm ('Are you sure? This Flight Information will be sent to the Regional Director')">
				<input type="image" src="../pics/sendemail.gif" value="send email"><br>
			<font size="-2" color="#CC6600"><b>Be sure you have updated the flight information before sending the e-mail to the Regional Director.</b></font>
			</form>
			</td>
			<td align="center" width="50%">
			<form name="email2" action="../reports/email_flight_html2.cfm" method="post" onsubmit="return confirm ('Are you sure? This Flight Information will be sent to Yourself')">
				<input type="image" src="../pics/sendemail.gif" value="send email"><br>
			<font size="-2" color="#CC6600"><b>Be sure you have updated the flight information before sending the e-mail to yourself.</b></font>
			</form>
			</td></tr>
		</table><br>
	</cfif>
	
	<cfif client.usertype GT 4>
		<cfparam name="edit" default="no">
	<cfelse>
		<cfif #cgi.http_referer# is ''><cfelse><br><div align="center"><span class="get_Attention"><b>Flight Information Updated</b></span></div></cfif>
		<cfparam name="edit" default="yes">
	</cfif>
	
<cfform name="form1" action="../querys/update_flight_info.cfm">
<cfoutput query="get_student_info">
		
	<cfif #cgi.http_referer# NEQ ''>
		<cfif get_student_info.insurance_typeid GT '1' AND client.usertype LTE 4> 
		<table border="0" align="center" width="99%" bordercolor="C0C0C0" valign="top" cellpadding="3" cellspacing="1">
			<th colspan=4 bgcolor="FF5151"> 
				<a href="" onClick="javascript: win=window.open('../insurance/insurance_management.cfm?studentid=#client.studentid#', 'Settings', 'height=400, width=800, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"> 
				 <font color="FFFFFF">* Arrival Information Only * This student takes CASE Insurance. Please click here to enter insurance correction date. </font></a></th>
		</table>
		</cfif>
	</cfif>
		
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
			<td align="center"><cfif client.usertype LTE 4><a href="../querys/delete_flight_info.cfm?flightid=#flightid#" onClick="return areYouSure(this);"><img src="../pics/deletex.gif" border="0"></img></a></cfif></td>
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
			<td align="center"><cfif client.usertype LTE 4><a href="../querys/delete_flight_info.cfm?flightid=#flightid#" onClick="return areYouSure(this);"><img src="../pics/deletex.gif" border="0"></img></a></cfif></td>
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
		<tr bgcolor="D5DCE5"><td colspan="11" align="center"><a href="flight_info.cfm?add_arr=yes">Add more legs to the flight information above</a></td></tr>
		</cfif>
		<tr bgcolor="D5DCE5"><td colspan="11" align="center"><font size=-1>*Flight tracking information by Travelocity, not all flights will be available. #company_short.companyshort# is not responsible for information on or gathered from travelocity.com.</td></tr>
	</cfif>
	</table><br>
	
	<table border="0" align="center" width="99%" bordercolor="C0C0C0" valign="top" cellpadding="3" cellspacing="1">
	<th bgcolor="ACB9CD"> N O T E S &nbsp; O N &nbsp; T H I S &nbsp; F L I G H T &nbsp; I N F O R M A T I O N </tr>
	<tr bgcolor="D5DCE5"><td align="center"><textarea cols="75" rows="3" name="flight_notes" wrap="VIRTUAL">#get_student_info.flight_info_notes#</textarea></td></tr>
	</table><br>
		
	<!--- D E P A R T U R E      I N F O R M A T I O N    |    T E R M I N A T I O N    D A T E --->
		
	<cfif get_student_info.insurance_typeid GT '1' and client.usertype LTE 4> 
	<table border="0" align="center" width="99%" bordercolor="C0C0C0" valign="top" cellpadding="3" cellspacing="1">
		<tr><th colspan=5 bgcolor="FDCEAC">T E R M I N A T I O N &nbsp; &nbsp; D A T E &nbsp; &nbsp; (For students with no departing information)</th></tr>
		<tr bgcolor="FEE6D3">
			<td width="20%">Termination Date:</td>
			<td width="80%"><cfinput type="text" name="termination_date" value="#DateFormat(get_student_info.termination_date, 'mm/dd/yyyy')#" size="7" maxlength="10" validate="date"> mm/dd/yyyy</td>
		</tr>	
	</table><br>	
	</cfif>
		
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
			<td align="center"><cfif client.usertype LTE 4><a href="../querys/delete_flight_info.cfm?flightid=#flightid#" onClick="return areYouSure(this);"><img src="../pics/deletex.gif" border="0"></img></a></cfif></td>
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
			<td align="center"><cfif client.usertype LTE 4><a href="../querys/delete_flight_info.cfm?flightid=#flightid#" onClick="return areYouSure(this);"><img src="../pics/deletex.gif" border="0"></img></a></cfif></td>
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
		<tr bgcolor="FEE6D3"><td colspan="11" align="center"><a href="flight_info.cfm?add_dep=yes">Add more legs to the flight information above</a></td></tr>
		</cfif>
		<tr bgcolor="FEE6D3"><td colspan="11" align="center"><font size=-1>*Flight tracking information by Travelocity, not all flights will be available. #company_short.companyshort# is not responsible for information on or gathered from travelocity.com.</td></tr>
	</cfif>
	</table>
	
</td></tr>
</table>  <!--- main table --->

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr><cfif client.usertype LTE 4>
		<td align="right" width="50%"><input name="Submit" type="image" src="../pics/update.gif" border=0 alt=" update ">&nbsp;</td>
		</cfif>
		<td align="left" width="50%">&nbsp;<input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()"></td></tr>
</table>

<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td>
		<td width=100% background="../pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td>
	</tr>
</table>
</cfoutput>
</cfform>




<!---- INSURANCE DELETED FROM FLIGHT INFORMATION 

<cfquery name="get_arrival_insu" datasource="caseusa">
	SELECT insuranceid, new_date, end_date, sent_to_caremed, transtype
	FROM smg_insurance
	WHERE studentid = '#client.studentid#' AND (transtype = 'new' OR transtype = 'correction')
	ORDER BY insuranceid
</cfquery>

<cfquery name="get_last_arrival" datasource="caseusa">
	SELECT MAX(insuranceid) as insuranceid
	FROM smg_insurance
	WHERE studentid = '#client.studentid#' AND (transtype = 'new' OR transtype = 'correction')
</cfquery>

<cfquery name="get_depart_insu" datasource="caseusa">
	SELECT insuranceid, new_date, end_date, sent_to_caremed, transtype
	FROM smg_insurance
	WHERE studentid = '#client.studentid#' AND (transtype = 'extension' OR transtype = 'early return')
	ORDER BY insuranceid
</cfquery>

<cfquery name="get_last_depart" datasource="caseusa">
	SELECT MAX(insuranceid) as insuranceid
	FROM smg_insurance
	WHERE studentid = '#client.studentid#' AND (transtype = 'extension' OR transtype = 'early return')
</cfquery>

<Cfquery name="get_end_date" datasource="caseusa">
	SELECT insuranceid, end_date
	FROM smg_insurance
	WHERE studentid = <cfqueryparam value="#client.studentid#" cfsqltype="cf_sql_integer">
	ORDER BY insuranceid DESC
</cfquery>


	<!--- INSURANCE CORRECTION DATE --->
	<cfif get_student_info.insurance_typeid GT '1' AND client.usertype LTE 4> 
	<table border="0" align="center" width="99%" bordercolor="C0C0C0" valign="top" cellpadding="3" cellspacing="1">
		<th colspan=4 bgcolor="ACB9CD"> C A R E M E D &nbsp; - &nbsp; A R R I V A L &nbsp; &nbsp; I N F O R M A T I O N</th>
		<tr bgcolor="D5DCE5">
			<th width="14%">Transaction</th>
			<th width="40%">Correction Date (mm-dd-yyyy)</th>
			<th width="40%">Sent to Caremed on:</th>
			<th width="6%">New</th></tr>
		<cfif get_arrival_insu.recordcount is '0' and insurance is ''> <!--- Nothing has been filled with Caremed --->
		<tr bgcolor="D5DCE5">	
			<td colspan="4">The student's insurance has not been filled with Caremed yet.</td>
		</tr>
		<cfelse> <!--- CORRECTION HISTORY --->
		<cfloop query="get_arrival_insu">
			<tr bgcolor="D5DCE5">
				<td align="center">#transtype#</td>	
				<cfif get_arrival_insu.sent_to_caremed is ''> <!--- info has not been sent_to_caremed, able to change it --->	
					<td align="center"><input type="text" name="insu_new_date" value="#DateFormat(get_arrival_insu.new_date, 'mm/dd/yyyy')#" size="7" maxlength="10" validate="date">
									   <input type="hidden" name="insuranceid" value="#get_arrival_insu.insuranceid#"></td>
					<td align="center">It has not been sent to Caremed yet</td>
					<td align="center"><input type="checkbox" disabled></td>
				<cfelse> <!--- info has been sent_to_caremed to caremed - ready only --->
					<td align="center">#DateFormat(get_arrival_insu.new_date, 'mm/dd/yyyy')#</td>
					<td align="center">#DateFormat(get_arrival_insu.sent_to_caremed, 'mm/dd/yyyy')#</td>
					<td align="center"><cfif get_last_arrival.insuranceid is get_arrival_insu.insuranceid and get_arrival_insu.sent_to_caremed is not ''>
						<input type="checkbox" name="new" value="new" onClick="changeDiv('1','block');">
						<cfelse><input type="checkbox" disabled></cfif></td>
				</cfif>
			</tr>
		</cfloop>
		</cfif>
		</table>	
		<div id ="1" style="display:none"> <!--- ADD NEW CORRECTION IF CHECKBOX NEW IS CHECKED--->
		<table border="0" align="center" width="99%" bordercolor="C0C0C0" valign="top" cellpadding="3" cellspacing="1">
			<tr bgcolor="D5DCE5">
				<td align="center" width="14%">correction</td>
				<td align="center" width="40%"><input type="text" name="insu_new_date" value="" size="7" maxlength="10" validate="date"></td>
				<td align="center" width="40%">n/a</td>
				<td align="center" width="6%"><input type="checkbox" disabled></td>
			</tr>
		</table>	
		</div><br>
	</cfif>


<!--- INSURANCE DEPARTURE INFORMATION --->
	<cfif get_student_info.insurance_typeid GT '1' and client.usertype LTE 4> 
	<table border="0" align="center" width="99%" bordercolor="C0C0C0" valign="top" cellpadding="3" cellspacing="1">
		<tr><th colspan=5 bgcolor="FDCEAC">C A R E M E D &nbsp; - &nbsp; L E A V I N G &nbsp; &nbsp; D A T E &nbsp; &nbsp; A D J U S T M E N T S</th></tr>
		<tr bgcolor="FEE6D3">
			<th width="14%">Transaction</th>
			<th width="27%">Departure Date (mm-dd-yyyy)</th>
			<th width="26%">End Date (mm-dd-yyyy)</th>
			<th width="27%">Sent to Caremed on:</th>
			<th width="6%">New</th>
		</tr>	
		<!--- Nothing has been filled with Caremed --->
		<cfif get_depart_insu.recordcount is '0'> 
		<tr bgcolor="FEE6D3">	
			<td align="center">n/a</td>
			<td align="center">n/a</td>
			<td align="center">n/a</td>
			<td align="center">n/a</td>
			<td align="center"><cfinput type="checkbox" name="dp_new" value="new" onClick="changeDiv('2','block');"></td>
		</tr>
		<cfelse>
		<cfloop query="get_depart_insu">
			<tr bgcolor="FEE6D3">
				<td align="center">#transtype#</td>	
				<!--- info has not been sent_to_caremed, able to change it --->	
				<cfif get_depart_insu.sent_to_caremed is ''> 
					<td align="center"><cfinput type="text" name="insu_dp_new_date" value="#DateFormat(get_depart_insu.new_date, 'mm/dd/yyyy')#" size="7" maxlength="10" validate="date">
									   <cfinput type="hidden" name="dp_insuranceid" value="#get_depart_insu.insuranceid#"></td>
					<td align="center"><cfinput type="text" name="insu_dp_end_date" value="#DateFormat(get_depart_insu.end_date, 'mm/dd/yyyy')#" size="7" maxlength="10" validate="date"></td>
					<td align="center">It has not been sent to Caremed yet</td>
					<td align="center"><cfinput type="checkbox" name="dp_checkbox" disabled></td>
				<cfelse> <!--- info has been sent_to_caremed to caremed - ready only --->
					<td align="center">#DateFormat(get_depart_insu.new_date, 'mm/dd/yyyy')#</td>
					<td align="center">#DateFormat(get_depart_insu.end_date, 'mm/dd/yyyy')#</td>
					<td align="center">#DateFormat(get_depart_insu.sent_to_caremed, 'mm/dd/yyyy')#</td>
					<td align="center">
						<cfif get_last_depart.insuranceid is get_depart_insu.insuranceid and get_depart_insu.sent_to_caremed is not ''>
							<cfinput type="checkbox" name="dp_new" value="new" onClick="changeDiv('2','block');">
						<cfelse>
							<cfinput type="checkbox" name="dp_checkbox" disabled>
						</cfif>
					</td>
				</cfif>
			</tr>
		</cfloop>
		</cfif>
	</table>	
	
	<!--- ADD NEW EARLY RETURN - EXTENSION IF CHECKBOX NEW IS CHECKED--->
	<div id ="2" style="display:none"> 
	<table border="0" align="center" width="99%" bordercolor="C0C0C0" valign="top" cellpadding="3" cellspacing="1">
		<tr bgcolor="FEE6D3">
			<td align="center" width="14%">	
				<select name="insu_dp_trans_type" onChange="extensiondate('#DateFormat(DateAdd('y', 1, get_end_date.end_date), 'mm/dd/yyyy')#','#DateFormat(get_arrival_insu.end_date, 'mm/dd/yyyy')#')">
				<option value="0"></option>
				<option value="early return">Early Return</option>
				<option value="extension">Extension</option>
				</select>
			</td>
			<td align="center" width="27%"><cfinput type="text" name="insu_dp_new_date" value="" size="7" maxlength="10" validate="date"></td>
			<td align="center" width="26%"><cfinput type="text" name="insu_dp_end_date" value="" size="7" maxlength="10" validate="date"></td>
			<td align="center" width="27%">n/a</td>
			<td align="center" width="6%"><cfinput type="checkbox" name="dp_checkbox" disabled></td>
		</tr>
	</table>	
	</div><br>
	</cfif>


--->