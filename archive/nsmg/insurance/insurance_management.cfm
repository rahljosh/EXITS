<!--- revised by Marcus Melo on 12/01/2005 --->
<link rel="stylesheet" href="../smg.css" type="text/css">

<!-----Script to show certain fields---->
<script type="text/javascript">
<!--
function changeDiv(the_div,the_change)
{
  var the_style = getStyleObject(the_div);
  if (the_style != false)  {
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
function extensiondate(startdate,enddate,progenddate)
{
	if (document.form1.insu_trans_type.value == 'extension') {
		document.form1.insu_new_date.value = (startdate);
		if (progenddate == enddate) {
			document.form1.insu_end_date.value = "";
		} else {
			document.form1.insu_end_date.value = (progenddate);
			   }
	} else if ((document.form1.insu_trans_type.value == 'correction') || (document.form1.insu_trans_type.value == 'early return') || (document.form1.insu_trans_type.value == 'cancellation')) {
		document.form1.insu_end_date.value = (enddate);
		document.form1.insu_new_date.value = "";
	}
	else {
		document.form1.insu_new_date.value = "";
		document.form1.insu_end_date.value = "";
	}
}
// -->
</script>

<cfinclude template="../querys/get_company_short.cfm">

<Cfquery name="get_student_info" datasource="MySQL">
	SELECT  s.familylastname, s.firstname, s.studentid, s.hostid, s.flight_info_notes, s.cancelinsurancedate,
			s.insurance, u.insurance_typeid , u.businessname,
			p.insurance_startdate, p.insurance_enddate
	FROM smg_students s
	INNER JOIN smg_users u ON u.userid = s.intrep
	INNER JOIN smg_programs p ON p.programid = s.programid
	WHERE studentid =  <cfqueryparam value="#client.studentid#" cfsqltype="cf_sql_integer">
</Cfquery>

<cfoutput>
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="../pics/header_background.gif"><img src="../pics/user.gif"></td>
		<td background="../pics/header_background.gif"><h2>#companyshort.companyshort# - Insurance Management</h2></td>
		<td align="right" background="../pics/header_background.gif"><h2>#get_student_info.firstname# #get_student_info.familylastname# (#get_student_info.studentid#)</h2></td>
		<td width=17 background="../pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<div class="section">
<cfif (get_student_info.insurance_typeid EQ 0 OR get_student_info.insurance_typeid EQ 1)> 
	<table border="0" align="center" width="100%" cellpadding="3" cellspacing="1">
		<tr><td>This Agent does not take Insurance or the Insurance Policy Type is Missing.</td></tr>
	</table>
	<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign="bottom">
		<td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td>
		<td width=100% background="../pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td></tr>
	</table>
	<cfabort>
</cfif>	

<cfquery name="get_insurance" datasource="MySql">
	SELECT insuranceid, new_date, end_date, sent_to_caremed, transtype
	FROM smg_insurance
	WHERE studentid = <cfqueryparam value="#client.studentid#" cfsqltype="cf_sql_integer">
		AND companyid = '#client.companyid#'
	ORDER BY insuranceid
</cfquery>

<cfquery name="get_last_record" datasource="MySql">
	SELECT MAX(insuranceid) as insuranceid
	FROM smg_insurance
	WHERE studentid = '#client.studentid#'
</cfquery>

<Cfquery name="get_history" datasource="MySQL">
	SELECT insuranceid, studentid, firstname, lastname, sex, dob, country_code, new_date, end_date, sent_to_caremed, 
	org_code, policy_code, transtype
	FROM smg_insurance
	WHERE studentid = <cfqueryparam value="#client.studentid#" cfsqltype="cf_sql_integer">
	ORDER BY insuranceid
</cfquery>

<Cfquery name="get_end_date" datasource="MySQL">
	SELECT insuranceid, end_date
	FROM smg_insurance
	WHERE studentid = <cfqueryparam value="#client.studentid#" cfsqltype="cf_sql_integer">
	ORDER BY insuranceid DESC
</cfquery>
	
<!--- Nothing has been filled with Caremed --->
<cfif get_insurance.recordcount is '0' AND get_student_info.insurance is ''> 
	<table border="0" align="center" width="100%" cellpadding="3" cellspacing="1">
		<tr><td colspan="5">The student's insurance has not been filled with Caremed yet.</td></tr>
		<tr><td align="center" width="50%">&nbsp;<input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()"></td></tr>
	</table>
	<!----footer of table---->
	<table width=100% cellpadding=0 cellspacing=0 border=0>
		<tr valign="bottom">
			<td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td>
			<td width=100% background="../pics/header_background_footer.gif"></td>
			<td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td></tr>
	</table>
	<cfabort>
</cfif> 

<cfform name="form1" action="insurance_management_qr.cfm">
<!--- INSURANCE CORRECTION / EXTENSION DATE --->
<table border="0" align="center" width="100%" cellpadding="3" cellspacing="1">
	<tr bgcolor="e2efc7">
		<th width="14%">Transaction</th>
		<th width="27%">Start Date / Departure Date <br> (mm-dd-yyyy)</th>
		<th width="26%">End Date <br> (mm-dd-yyyy)</th>
		<th width="27%">Sent on:</th>
		<th width="6%">New</th></tr>
	<!--- CORRECTION HISTORY --->
	<cfloop query="get_insurance">
		<!--- info has not been sent_to_caremed, able to change it --->	
		<cfif get_insurance.sent_to_caremed EQ ''> 
		<tr>
			<td align="center">#transtype#</td>	
			<td align="center">
				<cfinput type="hidden" name="insuranceid" value="#get_insurance.insuranceid#">
				<cfinput type="text" name="insu_new_date" value="#DateFormat(get_insurance.new_date, 'mm/dd/yyyy')#" size="10" maxlength="10" required="yes" validate="date" message="Please enter a valid date for the insurance start date">
		   </td>  
			<td align="center"><cfinput type="text" name="insu_end_date" value="#DateFormat(get_insurance.end_date, 'mm/dd/yyyy')#" size="10" maxlength="10" required="yes" validate="date" message="Please enter a valid date for the insurance end date"></td>
			<td align="center">It has not been sent yet</td>
			<td align="center"><cfinput type="checkbox" name="check" disabled></td>
		</tr>
		<tr><td align="center" colspan="4"><cfinput name="Submit" type="image" src="../pics/update.gif" border=0 alt=" update ">&nbsp;</td>
		<!--- info has been sent_to_caremed to caremed - ready only --->
		<cfelse> 
		<tr>
			<td align="center">#transtype#</td>				
			<td align="center">#DateFormat(get_insurance.new_date, 'mm/dd/yyyy')#</td>
			<td align="center">#DateFormat(get_insurance.end_date, 'mm/dd/yyyy')#</td>
			<td align="center">#DateFormat(get_insurance.sent_to_caremed, 'mm/dd/yyyy')#</td>
			<td align="center">
				<cfif get_last_record.insuranceid EQ get_insurance.insuranceid AND get_insurance.sent_to_caremed NEQ ''>
					<cfinput type="checkbox" name="new" value="new" onClick="changeDiv('1','block');">
				<cfelse>
			
				<cfinput type="checkbox" name="new" value="new" onClick="changeDiv('1','block');">
			<!----
					<cfinput type="checkbox" name="check" >
					---->
				</cfif>
			</td>
		</tr>
		</cfif>
	</cfloop>
</table>

<!--- ADD NEW IF CHECKBOX NEW IS CHECKED--->
<div id="1" style="display:none"> 
<table border="0" align="center" width="100%" cellpadding="3" cellspacing="1">
	<tr>  
		<td align="center" width="14%">
			<select name="insu_trans_type" onChange="extensiondate('#DateFormat(DateAdd('y', 1, get_end_date.end_date), 'mm/dd/yyyy')#','#DateFormat(get_end_date.end_date, 'mm/dd/yyyy')#','#DateFormat(get_student_info.insurance_enddate, 'mm/dd/yyyy')#')">
				<option value="0"></option>
				<option value="new">New App</option>
				<option value="correction">Correction</option>
 				<option value="early return">Early Return</option>
				<option value="cancellation">Cancellation</option>
				<option value="extension">Extension</option>
			</select>
		</td>
		<td align="center" width="27%"><cfinput type="text" name="insu_new_date" value="" size="10" maxlength="10" required="yes" validate="date" message="Please enter a valid date for the insurance start date"></td>
		<td align="center" width="26%"><cfinput type="text" name="insu_end_date" value="" size="10" maxlength="10" required="yes" validate="date" message="Please enter a valid date for the insurance end date"></td>
		<td align="center" width="27%">n/a</td>
		<td align="center" width="6%"><cfinput type="checkbox" name="check" disabled></td>
	</tr>
	<tr><td colspan="4"><em><font color="FF0000">PS: For Early Return or Cancelation, please enter the Departure Date on the Start Date box</em></font></td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td colspan="4" align="center"><cfinput name="Submit" type="image" src="../pics/update.gif" border=0 alt=" update ">&nbsp;</td>
</table>
</div><br> 

<!--- Insurance History --->
<table width="100%" border=0 cellpadding=3 cellspacing=0>
	<tr><td colspan="11"><h2>Insurance History Detailed</h2></td></tr>
	<tr bgcolor="e2efc7">
		<td><b>Transaction</b></td><td><b>First Name</b></td><td><b>Last Name</b></td>
		<td><b>Sex</b></td><td><b>DOB</b></td><td><b>Country</b></td>
		<td><b>Start Date</b></td><td><b>End Date</b></td><td><b>Org. Code</b></td>		
		<td><b>Policy Code</b></td>				
		<td><b>Sent on</b></td>
	</tr>
	<cfif get_history.recordcount EQ '0'>
	<tr><td colspan=9 align="center">Insurance file has not been filled.</td></tr>
	<cfelse>
		<cfloop query="get_history">
			<tr bgcolor="#iif(get_history.currentrow MOD 2 ,DE("ffffe6") ,DE("e2efc7") )#">
				<td>#transtype#</td>
				<td>#get_history.firstname#</td>
				<td>#get_history.lastname#</td>
				<td><cfif sex IS NOT ''>#sex#</cfif></td>
				<td><cfif dob IS NOT ''>#DateFormat(dob, 'mm/dd/yyyy')#</cfif></td>
				<td>#country_code#</td>
				<td><cfif new_date IS NOT ''>#DateFormat(new_date, 'mm/dd/yyyy')#</cfif></td>
				<td><cfif end_date IS NOT ''>#DateFormat(end_date, 'mm/dd/yyyy')#</cfif></td>				
				<td>#org_code#</td>		
				<td>#policy_code#</td>		
				<td><cfif sent_to_caremed EQ ''>File has not been sent<cfelse></cfif>#DateFormat(sent_to_caremed, 'mm/dd/yyyy')#</td>
			</tr>
		</cfloop>
	</cfif>
</table><br>

<table border="0" align="center" width="100%" cellpadding="3" cellspacing="1">
	<tr bgcolor="e2efc7"><td><b>Transaction Type</b></td><td><b>Description</b></td></tr>
	<tr><td>New App</td><td>Initial coverage for a participant</td></tr>		
	<tr><td>Correction</td><td>If any details to the participant's coverage requires change</td></tr>		
	<tr><td>Cancellation</td><td>If the participant never left his/her country of origin</td></tr>
	<tr><td>Early Return</td><td>If the participant returns to his/her country of origin prior to the end date of coverage</td></tr>		
	<tr><td>Extension</td><td>If the coverage end date needs to be extended</td></tr>		
</table>
</div>
</cfform>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr><td align="center" width="50%">&nbsp;<input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()"></td></tr>
</table>
</cfoutput>

<!----footer of table---->
<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign="bottom">
		<td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td>
		<td width=100% background="../pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td></tr>
</table>