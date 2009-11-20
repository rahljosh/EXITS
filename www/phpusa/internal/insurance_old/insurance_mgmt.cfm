<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link rel="stylesheet" href="../smg.css" type="text/css">
<title>Insurance Management</title>
</head>

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

<body>

<cfif NOT IsDefined('url.unqid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<cfinclude template="../querys/get_student_unqid.cfm">

<cfquery name="get_program_dates" datasource="MySql">
	SELECT p.insurance_startdate, p.insurance_enddate
	FROM smg_programs p
	WHERE programid = '#get_student_unqid.programid#'
</cfquery>

<cfquery name="get_intl_rep" datasource="MySql">
	SELECT userid, businessname, extra_insurance_typeid
	FROM smg_users
	WHERE userid = '#get_student_unqid.intrep#'
</cfquery>

<cfquery name="get_insurance" datasource="MySql">
	SELECT insuranceid, studentid, firstname, lastname, sex, dob, country_code, new_date, end_date, sent_to_caremed, 
		org_code, policy_code, transtype
	FROM smg_insurance 
	WHERE studentid = <cfqueryparam value="#get_student_unqid.studentid#" cfsqltype="cf_sql_integer">
		AND companyid = '6'
	ORDER BY insuranceid
</cfquery>

<Cfquery name="get_end_date" datasource="MySQL">
	SELECT insuranceid, end_date
	FROM smg_insurance
	WHERE studentid = <cfqueryparam value="#get_student_unqid.studentid#" cfsqltype="cf_sql_integer">
		AND companyid = '6'
	ORDER BY insuranceid DESC
</cfquery>

<cfoutput>

<table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="CCCCCC" bgcolor="f4f4f4">
<tr><td bordercolor="FFFFFF" valign="top">

		<!----Header Table---->
		<table width=95% cellpadding=0 cellspacing=0 border=0 align="center" height="25" bgcolor="E4E4E4">
			<tr bgcolor="E4E4E4">
				<td class="title1">&nbsp; &nbsp; INSURANCE MANAGEMENT</td>
				<td class="title1" align="right">#get_student_unqid.firstname# #get_student_unqid.familylastname# (###get_student_unqid.studentid#) &nbsp; &nbsp;</td>
			</tr>
		</table><br>

		<!--- CHECK IF HAS INSURANCE --->
		<cfif get_student_unqid.insurancedate EQ '' AND get_intl_rep.extra_insurance_typeid LTE 1>
			<table border=0 cellpadding=4 cellspacing=1 class="section" align="center" width=95%>
				<tr bgcolor="##8FB6C9"><td class="style2">This Agent does not take Caremed Insurance or the Insurance Policy Type is Missing.</td></tr>
			</table>
			<cfabort>
		</cfif>

		<cfform name="form1" action="qr_insurance_mgmt.cfm">
		<cfinput type="hidden" name="assignedid" value="#get_student_unqid.assignedid#">
		<table cellpadding=5 cellspacing=5 border=1 align="center" width="97%" bordercolor="C7CFDC" bgcolor="ffffff">
			<tr>
				<td bordercolor="FFFFFF">
					<table width="100%" cellpadding=5 cellspacing=1 border=0>
						<tr bgcolor="##8FB6C9" align="center" class="style2">
							<td width="15%">Transaction</td>
							<td width="32%">Start Date / Departure Date <br> (mm-dd-yyyy)</td>
							<td width="22%">End Date <br> (mm-dd-yyyy)</td>
							<td width="25%">Filed Date</td>
							<td width="6%">New</td>
						</tr>
						<cfif get_insurance.recordcount>
						<cfloop query="get_insurance">
							<cfif sent_to_caremed EQ ''> 
								<tr bgcolor="#iif(currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#" class="style1" align="center">
									<td>#transtype#	<cfinput type="hidden" name="insuranceid" value="#insuranceid#"></td>
									<td><cfinput type="text" name="insu_new_date" value="#DateFormat(new_date, 'mm/dd/yyyy')#" size="10" maxlength="10" validate="date" message="Please enter a valid date for the insurance start date"></td>
									<td><cfinput type="text" name="insu_end_date" value="#DateFormat(end_date, 'mm/dd/yyyy')#" size="10" maxlength="10" validate="date" message="Please enter a valid date for the insurance end date"></td>
									<td>not been sent</td>
									<td><cfinput type="checkbox" name="check" disabled></td>					
								</tr>
								<tr><td colspan="5" align="center" bgcolor="e9ecf1"><cfinput name="Submit" type="image" src="../pics/update.gif" border=0 alt=" update ">&nbsp;</td>							
							<cfelse>
								<tr bgcolor="#iif(currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#" class="style1" align="center">
									<td>#transtype#</td>
									<td>#DateFormat(new_date, 'mm/dd/yyyy')#</td>
									<td>#DateFormat(end_date, 'mm/dd/yyyy')#</td>
									<td>#DateFormat(sent_to_caremed, 'mm/dd/yyyy')#</td>
									<td><cfif get_insurance.recordcount EQ currentrow AND sent_to_caremed NEQ ''>
											<cfinput type="checkbox" name="new" value="new" onClick="changeDiv('1','block');">
										<cfelse>
											<cfinput type="checkbox" name="check" disabled>
										</cfif>
									</td>					
								</tr>
							</cfif>
							<cfset last_insurancedate = #DateFormat(end_date, 'mm/dd/yyyy')#>						
						</cfloop>						
						</table>
						<!--- ADD NEW IF CHECKBOX NEW IS CHECKED--->
						<div id="1" style="display:none"> 
						<table width="100%" cellpadding=5 cellspacing=1 border=0>
							<tr bgcolor="e9ecf1" class="style1" align="center">
								<td width="15%">
									<select name="insu_trans_type" onChange="extensiondate('#DateFormat(DateAdd('y', 1, get_end_date.end_date), 'mm/dd/yyyy')#','#DateFormat(get_end_date.end_date, 'mm/dd/yyyy')#','#DateFormat(get_program_dates.insurance_enddate, 'mm/dd/yyyy')#')">
										<option value="0"></option>
										<option value="new">New App</option>
										<option value="correction">Correction</option>
										<option value="early return">Early Return</option>
										<option value="cancellation">Cancellation</option>
										<option value="extension">Extension</option>
									</select>
								</td>
								<td width="32%"><cfinput type="text" name="insu_new_date" value="" size="10" maxlength="10" validate="date" message="Please enter a valid date for the insurance start date"></td>
								<td width="22%"><cfinput type="text" name="insu_end_date" value="" size="10" maxlength="10" validate="date" message="Please enter a valid date for the insurance end date"></td>
								<td width="25%">n/a</td>
								<td width="6%"><cfinput type="checkbox" name="check" disabled></td>
							</tr>
							<tr><td colspan="5"><em><font color="FF0000">PS: For Early Return or Cancelation, please enter the Departure Date on the Start Date box</em></font></td></tr>
							<tr><td colspan="5" align="center" bgcolor="e9ecf1"><cfinput name="Submit" type="image" src="../pics/update.gif" border=0 alt=" update ">&nbsp;</td>
						</table>
						</div>
						<!--- ADD NEW IF CHECKBOX NEW IS CHECKED--->
						<cfelse>
						<table width="100%" cellpadding=5 cellspacing=1 border=0>
							<tr bgcolor="e9ecf1" class="style1" align="center"><td>Insurance has not been filed.</td></tr>
						</table>
						</cfif>
				</td>
			</tr>
		</table>
		</cfform>

		<!--- DESCRIPTION OF TRANSACTIONS --->
		<table cellpadding=5 cellspacing=5 border=1 align="center" width="97%" bordercolor="C7CFDC" bgcolor="ffffff">
			<tr>
				<td bordercolor="FFFFFF">
					<table width="100%" cellpadding=5 cellspacing=1 border=0>
						<tr bgcolor="##8FB6C9" class="style2"><td><b>Transaction Type</b></td><td><b>Description</b></td></tr>
						<tr class="style1"><td>New App</td><td>Initial coverage for a participant</td></tr>		
						<tr class="style1"><td>Correction</td><td>If any details to the participant's coverage requires change</td></tr>		
						<tr class="style1"><td>Cancellation</td><td>If the participant never left his/her country of origin</td></tr>
						<tr class="style1"><td>Early Return</td><td>If the participant returns to his/her country of origin prior to the end date of coverage</td></tr>		
						<tr class="style1"><td>Extension</td><td>If the coverage end date needs to be extended</td></tr>		
					</table>
				</td>
			</tr>
		</table><br>

		<!--- INSURANCE HISTORY --->
		<table cellpadding=5 cellspacing=5 border=1 align="center" width="97%" bordercolor="C7CFDC" bgcolor="ffffff">
			<tr>
				<td bordercolor="FFFFFF">
					<table width="100%" cellpadding=5 cellspacing=1 border=0>
						<tr bgcolor="##8FB6C9" align="center" class="style2">
							<td>Transaction</td>
							<td>First Name</td>
							<td>Last Name</td>
							<td>Sex</td>
							<td>DOB</td>
							<td>Start Date</td>
							<td>End Date</td>
							<td>Org. Code</td>
							<td>Policy Code</td>
							<td>Filed</td>
						</tr>
						<cfloop query="get_insurance">
							<tr class="style1" bgcolor="#iif(currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
								<td>#transtype#</td>
								<td>#firstname#</td>
								<td>#lastname#</td>
								<td>#sex#</td>
								<td>#DateFormat(dob, 'mm/dd/yyyy')#</td>
								<td>#DateFormat(new_date, 'mm/dd/yyyy')#</td>
								<td>#DateFormat(end_date, 'mm/dd/yyyy')#</td>
								<td>#org_code#</td>
								<td>#policy_code#</td>
								<td>#DateFormat(sent_to_caremed, 'mm/dd/yyyy')#</td>						
							</tr>
						</cfloop>
					</table>	
				</td>
			</tr>
		</table><br>

</td></tr>
</table>

</cfoutput>

</body>
</html>