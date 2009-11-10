<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link rel="stylesheet" href="../../style.css" type="text/css">
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
		document.form1.new_start_date.value = (startdate);
		if (progenddate == enddate) {
			document.form1.new_start_date.value = "";
		} else {
			document.form1.new_end_date.value = (progenddate);
			   }
	} else if ((document.form1.insu_trans_type.value == 'correction') || (document.form1.insu_trans_type.value == 'early return') || (document.form1.insu_trans_type.value == 'cancellation')) {
		document.form1.new_end_date.value = (enddate);
		document.form1.new_start_date.value = "";
	}
	else {
		document.form1.new_start_date.value = "";
		document.form1.new_end_date.value = "";
	}
}
// -->
</script>

<body>

<cfif NOT IsDefined('url.uniqueid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<cfinclude template="../querys/get_candidate_unqid.cfm">

<cfquery name="get_intl_rep" datasource="MySql">
	SELECT userid, businessname, extra_insurance_typeid
	FROM smg_users
	WHERE userid = '#get_candidate_unqid.intrep#'
</cfquery>

<cfquery name="get_insurance" datasource="MySql">
	SELECT insuranceid, candidateid, firstname, lastname, sex, dob, country_code, start_date, end_date, filed_date, 
		org_code, policy_code, transtype
	FROM extra_insurance_history 
	WHERE candidateid = <cfqueryparam value="#get_candidate_unqid.candidateid#" cfsqltype="cf_sql_integer">
	ORDER BY insuranceid
</cfquery>

<cfquery name="get_program_end_date" datasource="MySql">
	SELECT programid, startdate, enddate, insurance_enddate
	FROM smg_programs
	WHERE programid = <cfqueryparam value="#get_candidate_unqid.programid#" cfsqltype="cf_sql_integer">
</cfquery>

<cfoutput>

<table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="CCCCCC" bgcolor="f4f4f4">
<tr><td bordercolor="FFFFFF" valign="top">

		<!----Header Table---->
		<table width=95% cellpadding=0 cellspacing=0 border=0 align="center" height="25" bgcolor="E4E4E4">
			<tr bgcolor="E4E4E4">
				<td class="title1">&nbsp; &nbsp; Insurance Management </td>
				<td class="title1" align="right">#get_candidate_unqid.firstname# #get_candidate_unqid.lastname# (###get_candidate_unqid.candidateid#) &nbsp; &nbsp;</td>
			</tr>
		</table><br>

		<!--- CHECK IF HAS INSURANCE --->
		<cfif get_candidate_unqid.insurance_date EQ '' AND get_intl_rep.extra_insurance_typeid LTE 1>
			<table border=0 cellpadding=4 cellspacing=1 class="section" align="center" width=95%>
				<tr bgcolor="##8FB6C9"><td class="style2">This Agent does not take Caremed Insurance or the Insurance Policy Type is Missing.</td></tr>
			</table>
			<cfabort>
		</cfif>

		<cfform name="form1" action="qr_insurance_mgmt.cfm">
		<cfinput type="hidden" name="candidateid" value="#get_candidate_unqid.candidateid#">
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
							<cfif filed_date EQ ''> 
								<tr bgcolor="#iif(currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#" class="style1" align="center">
									<td>#transtype#	<cfinput type="hidden" name="insuranceid" value="#insuranceid#"></td>
									<td><cfinput type="text" name="start_date" value="#DateFormat(start_date, 'mm/dd/yyyy')#" size="10" maxlength="10" validate="date" message="Please enter a valid date for the insurance start date"></td>
									<td><cfinput type="text" name="end_date" value="#DateFormat(end_date, 'mm/dd/yyyy')#" size="10" maxlength="10" validate="date" message="Please enter a valid date for the insurance end date"></td>
									<td>not been sent</td>
									<td><cfinput type="checkbox" name="check" disabled></td>					
								</tr>
								<tr><td colspan="5" align="center" bgcolor="e9ecf1"><cfinput name="Submit" type="image" src="../../pics/update.gif" border=0 alt=" update ">&nbsp;</td>							
							<cfelse>
								<tr bgcolor="#iif(currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#" class="style1" align="center">
									<td>#transtype#</td>
									<td>#DateFormat(start_date, 'mm/dd/yyyy')#</td>
									<td>#DateFormat(end_date, 'mm/dd/yyyy')#</td>
									<td>#DateFormat(filed_date, 'mm/dd/yyyy')#</td>
									<td><cfif get_insurance.recordcount EQ currentrow AND filed_date NEQ ''>
											<cfinput type="checkbox" name="new" value="new" onClick="changeDiv('1','block');">
										<cfelse>
											<cfinput type="checkbox" name="check" disabled>
										</cfif>
									</td>					
								</tr>
							</cfif>
							<cfset last_insurance_date = #DateFormat(end_date, 'mm/dd/yyyy')#>						
						</cfloop>						
						</table>
						<!--- ADD NEW IF CHECKBOX NEW IS CHECKED--->
						<div id="1" style="display:none"> 
						<table width="100%" cellpadding=5 cellspacing=1 border=0>
							<tr bgcolor="e9ecf1" class="style1" align="center">
								<td width="15%">
									<select name="insu_trans_type" 
									onChange="extensiondate('#DateFormat(DateAdd('y', 1, last_insurance_date), 'mm/dd/yyyy')#','#DateFormat(last_insurance_date, 'mm/dd/yyyy')#','#DateFormat(get_program_end_date.insurance_enddate, 'mm/dd/yyyy')#')">
										<option value="0"></option>
										<option value="new">New App</option>
										<option value="correction">Correction</option>
										<option value="early return">Early Return</option>
										<option value="cancellation">Cancellation</option>
										<option value="extension">Extension</option>
									</select>
								</td>
								<td width="32%"><cfinput type="text" name="new_start_date" value="" size="10" maxlength="10" validate="date" message="Please enter a valid date for the insurance start date"></td>
								<td width="22%"><cfinput type="text" name="new_end_date" value="" size="10" maxlength="10" validate="date" message="Please enter a valid date for the insurance end date"></td>
								<td width="25%">n/a</td>
								<td width="6%"><cfinput type="checkbox" name="check" disabled></td>
							</tr>
							<tr><td colspan="5"><em><font color="FF0000">PS: For Early Return or Cancelation, please enter the Departure Date on the Start Date box</em></font></td></tr>
							<tr><td colspan="5" align="center" bgcolor="e9ecf1"><cfinput name="Submit" type="image" src="../../pics/update.gif" border=0 alt=" update ">&nbsp;</td>
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
								<td>#DateFormat(start_date, 'mm/dd/yyyy')#</td>
								<td>#DateFormat(end_date, 'mm/dd/yyyy')#</td>
								<td>#org_code#</td>
								<td>#policy_code#</td>
								<td>#DateFormat(filed_date, 'mm/dd/yyyy')#</td>						
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