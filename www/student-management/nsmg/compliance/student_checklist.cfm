<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" type="text/css" href="../smg.css">
<title>SMG Student File Document Checklist</title>
</head>
<body>

<cfoutput>
<SCRIPT LANGUAGE="JavaScript">
	<!-- Begin
	
	// Document Ready!
    $(document).ready(function() {

		// JQuery Modal
		$(".jQueryModal").colorbox( {
			width:"60%", 
			height:"90%", 
			iframe:true,
			overlayClose:false,
			escKey:false 
		});		

	});

	function formHandler(form){
	var URL = document.form.sele_host.options[document.form.sele_host.selectedIndex].value;
	window.location.href = URL;
	}
	function todaydate3() {
		if (document.checklist.check_host_app.checked) {
			   document.checklist.host_application.value = '#DateFormat(now(), 'mm/dd/yyyy')#'; }
		else { document.checklist.host_application.value = ''; }
	}
	function todaydate4() {
		if (document.checklist.check_school.checked) {
			   document.checklist.school_acceptance.value = '#DateFormat(now(), 'mm/dd/yyyy')#'; }
		else { document.checklist.school_acceptance.value = ''; }
	}
	function todaydate5() {
		if (document.checklist.check_confi.checked) {
			   document.checklist.confidential_visit.value = '#DateFormat(now(), 'mm/dd/yyyy')#'; }
		else { document.checklist.confidential_visit.value = ''; }
	}
	function todaydate6() {
		if (document.checklist.check_form1.checked) {
			   document.checklist.reference1.value = '#DateFormat(now(), 'mm/dd/yyyy')#'; }
		else { document.checklist.reference1.value = ''; }
	}
	function todaydate7() {
		if (document.checklist.check_form2.checked) {
			   document.checklist.reference2.value = '#DateFormat(now(), 'mm/dd/yyyy')#'; }
		else { document.checklist.reference2.value = ''; }
	}
	function StuOrientation() {
		if (document.checklist.check_student_orientation.checked) {
			   document.checklist.student_orientation.value = '#DateFormat(now(), 'mm/dd/yyyy')#'; }
		else { document.checklist.student_orientation.value = ''; }
	}
	function HostOrientation() {
		if (document.checklist.check_host_orientation.checked) {
			   document.checklist.host_orientation.value = '#DateFormat(now(), 'mm/dd/yyyy')#'; }
		else { document.checklist.host_orientation.value = ''; }
	}
	function DoubleStudent() {
		if (document.checklist.check_double_doc_stu.checked) {
			   document.checklist.double_student.value = '#DateFormat(now(), 'mm/dd/yyyy')#'; }
		else { document.checklist.double_student.value = ''; }
	}
	function DoubleNatural() {
		if (document.checklist.check_double_doc_fam.checked) {
			   document.checklist.double_natural.value = '#DateFormat(now(), 'mm/dd/yyyy')#'; }
		else { document.checklist.double_natural.value = ''; }
	}
	function DoubleHost() {
		if (document.checklist.check_double_doc_host.checked) {
			   document.checklist.double_host.value = '#DateFormat(now(), 'mm/dd/yyyy')#'; }
		else { document.checklist.double_host.value = ''; }
	}
	function DoubleSchool() {
		if (document.checklist.check_double_doc_school.checked) {
			   document.checklist.double_school.value = '#DateFormat(now(), 'mm/dd/yyyy')#'; }
		else { document.checklist.double_school.value = ''; }
	}
	function AppComplete() {
		if (document.checklist.missing_docs.value == '') {
			   document.checklist.application_complete.check = true; }
		else { document.checklist.application_complete.check = false;  }
	}
	function CheckDouble() {
		if ((document.checklist.check_double_doc_stu.checked) && (document.checklist.check_double_doc_fam.checked) 
		&& (document.checklist.check_double_doc_host.checked) && (document.checklist.check_double_doc_school.checked)) {
		document.checklist.double_paperwork.checked = true; }
		else {
		document.checklist.double_paperwork.checked = false;
		}
	}
	function CheckFields() {
	   if (document.checklist.hostid.value == '0') {
		  alert("You must link these documents to a host family.");
		  document.checklist.hostid.focus();
		  return false;
	   } 
	}
	//  End -->
</script>
</cfoutput>

<cfif not IsDefined('url.unqid')>
	<Table width="100%" cellpadding="3" cellspacing="0" align="center">
	<tr><td align="center">	
		Sorry, it was not possible to process your request at this time. Please try again.
	</td></tr>
	<tr><td align="center"><font size=-1><Br>&nbsp;&nbsp;
		<input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()">
	</table>
	<cfabort>
</cfif>

<cfquery name="get_student_info" datasource="MySql">
	SELECT s.studentid, s.uniqueid, s.firstname, s.familylastname, s.other_missing_docs, 
		c.complianceid, c.hostid, c.application_complete,  
		c.host_application, c.school_acceptance, c.confidential_visit, c.reference1, c.reference2,	c.student_orientation,
		c.host_orientation, c.progress_reports, c.double_student, c.double_natural, c.double_host, c.double_school, c.compliance_notes,
		h.familylastname as hostlastname
	FROM smg_students s
	LEFT JOIN smg_compliance c ON s.studentid = c.studentid
	LEFT JOIN smg_hosts h ON h.hostid = c.hostid
	WHERE s.uniqueid = <cfqueryparam value="#url.unqid#" cfsqltype="cf_sql_char">
		  <cfif not IsDefined('url.compid')><cfelse>
			AND c.complianceid = <cfqueryparam value="#url.compid#" cfsqltype="cf_sql_integer">
		  </cfif>
	ORDER BY c.complianceid DESC
</cfquery>

<cfquery name="get_previous_docs" datasource="MySql">
	SELECT c.complianceid, h.familylastname as hostlastname, h.hostid
	FROM smg_compliance c
	LEFT JOIN smg_hosts h ON h.hostid = c.hostid
	WHERE complianceid != '#get_student_info.complianceid#'
		AND studentid = <cfqueryparam value="#get_student_info.studentid#" cfsqltype="cf_sql_char">
</cfquery>

<cfquery name="get_hosts" datasource="MySql">
	SELECT s.studentid, s.hostid, 
		smg_hosts.familylastname 
	FROM smg_students s
	INNER JOIN smg_hosts ON s.hostid = smg_hosts.hostid
	WHERE s.studentid = <cfqueryparam value="#get_student_info.studentid#" cfsqltype="cf_sql_integer">
	UNION
	SELECT history.studentid, history.hostid, 
		smg_hosts.familylastname 
	FROM smg_hosthistory history
	INNER JOIN smg_hosts ON history.hostid = smg_hosts.hostid
	WHERE history.studentid = <cfqueryparam value="#get_student_info.studentid#" cfsqltype="cf_sql_integer">
	AND history.hostid != '0'
</cfquery>

<cfquery name="user_rights" datasource="MySql">
	SELECT userid, compliance
	FROM smg_users
	WHERE userid = <cfqueryparam value="#client.userid#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="get_arrival" datasource="MySql">
    SELECT
	    studentid, 
        dep_date
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
</cfquery>

<cfloop index = "i" list = "10,12,2,4,6,8"> 
	<cfquery name="get_report#i#" datasource="MySQL">
		SELECT DISTINCT question.report_number, question.date, question.submit_type, 
			doc.id, doc.month_of_report, doc.date_submitted, doc.ny_accepted
		FROM smg_prquestion_details question
		INNER JOIN smg_document_tracking doc ON question.report_number = doc.report_number
		WHERE stuid = <cfqueryparam value="#get_student_info.studentid#" cfsqltype="cf_sql_integer">
			AND doc.month_of_report = '#i#'
	</cfquery>
</cfloop>

<!----Header Table---->
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="../pics/header_background.gif"><img src="../pics/students.gif"></td>
		<td background="../pics/header_background.gif"><h2>SMG - Student File Document Checklist</td>
		<td background="../pics/header_background.gif" align="right"></td>
		<td background="../pics/header_background.gif" width=16></td>
		<td width=17 background="../pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<cfoutput>

<cfform  name="checklist" action="qr_student_checklist.cfm" method="post" onSubmit="return CheckFields();">

<cfinput type="hidden" name="studentid" value="#get_student_info.studentid#">
<cfinput type="hidden" name="unqid" value="#get_student_info.uniqueid#">
<cfinput type="hidden" name="complianceid" value="#get_student_info.complianceid#">

<div class="section">

<table width="660" border=0 cellpadding=2 cellspacing=1 align="center">	
	<tr><td colspan="4" align="center"><h2>#get_student_info.firstname# #get_student_info.familylastname# (###get_student_info.studentid#)</h2><br></td></tr>
	<tr><td colspan="4"><a href="insert_student_cheklist.cfm?unqid=#get_student_info.uniqueid#">Add new set of documents</a></td></tr>
	<cfif get_previous_docs.recordcount GT '0'>
	<!--- host family selection --->
	<tr>
		<td colspan="4"> 
			<u>Previous host family documents due relocation</u><br>
			<cfloop query="get_previous_docs">
				&nbsp; <a href="student_checklist.cfm?unqid=#get_student_info.uniqueid#&compid=#get_previous_docs.complianceid#">The #hostlastname# Family (###hostid#)</a><br>
			</cfloop>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	</cfif>

	<!--- host family selection --->
	<tr>
		<td colspan="4">
			<cfif get_student_info.hostid EQ '0' OR get_student_info.hostid EQ ''>
				Please select a host family: &nbsp;
				<cfselect name="hostid" required="yes" message="You must link these documents to a host family.">
					<option value="0"></option>
				<cfloop query="get_hosts">
					<option value="#hostid#" <cfif get_student_info.hostid EQ get_hosts.hostid>selected</cfif>>#familylastname# Family ( ###hostid# )</option>
				</cfloop>
				</cfselect>
			<cfelse>
				<b>Host Family: &nbsp; The #get_student_info.hostlastname# family (###get_student_info.hostid#)</b>
			</cfif>
		</td>
	</tr>
	
	<tr>
		<td width="25">
			<cfif get_student_info.application_complete EQ '1'>
				<cfinput type="checkbox" name="application_complete" checked="yes">
			<cfelse>
				<cfinput type="checkbox" name="application_complete">
			</cfif>
		</td>
		<td width="360">Is the entire student application complete?</td>
		<td width="40">&nbsp;</td>
		<td width="235">&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td colspan="3">Missing Documents:<br>
			<textarea name="other_missing_docs" cols="58" rows="4" OnClick="javascript:AppComplete(this.value);">#get_student_info.other_missing_docs#</textarea></td>
	</tr>
		
	<!--- HOST FAMILY APPLICATION ---->
	<tr>
		<td><Cfif get_student_info.host_application EQ ''>
				<cfinput type="checkbox" name="check_host_app" OnClick="javascript:todaydate3();">
			<cfelse>
				<cfinput type="checkbox" name="check_host_app" OnClick="javascript:todaydate3();" checked="yes">		
			</cfif>
		</td>
		<td>Host Family Application</td>
		<td>Date:</td>
		<td><cfinput type="text" name="host_application" value="#DateFormat(get_student_info.host_application, 'mm/dd/yyyy')#" size="9" validate="date"></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td colspan="3">
			<table border=0 cellpadding=2 cellspacing=0 align="center">	
				<!--- School Acceptance ---->		
				<tr>
					<td width="25">
						<Cfif get_student_info.school_acceptance EQ ''>
							<cfinput type="checkbox" name="check_school" OnClick="javascript:todaydate4();">
						<cfelse>
							<cfinput type="checkbox" name="check_school" OnClick="javascript:todaydate4();" checked="yes">		
						</cfif>
					</td>
					<td width="330">School Acceptance</td>
					<td width="40">Date:</td>
					<td width="235"><cfinput type="text" name="school_acceptance" size="9" value="#DateFormat(get_student_info.school_acceptance, 'mm/dd/yyyy')#" validate="date"></td>
				</tr>
				<!--- Confidential Host Family Visit ---->		
				<tr>
					<td><Cfif get_student_info.confidential_visit EQ ''>
							<cfinput type="checkbox" name="check_confi" OnClick="javascript:todaydate5();">
						<cfelse>
							<cfinput type="checkbox" name="check_confi" OnClick="javascript:todaydate5();" checked="yes">		
						</cfif>
					</td>
					<td>Confidential Host Family Visit</td>
					<td>Date:</td>
					<td><cfinput type="text" name="confidential_visit" size="9" value="#DateFormat(get_student_info.confidential_visit, 'mm/dd/yyyy')#" validate="date"></td>
				</tr>
				<!--- Reference #1 ---->		
				<tr>
					<td><Cfif get_student_info.reference1 EQ ''>
							<cfinput type="checkbox" name="check_form1" OnClick="javascript:todaydate6();">
						<cfelse>
							<cfinput type="checkbox" name="check_form1" OnClick="javascript:todaydate6();" checked="yes">
						</cfif>
					</td>
					<td>Reference ##1</td>
					<td>Date:</td>
					<td><cfinput type="text" name="reference1" value="#DateFormat(get_student_info.reference1, 'mm/dd/yyyy')#" size="9" validate="date"></td>
				</tr>
				<!--- Reference #2 ---->		
				<tr>
					<td><Cfif get_student_info.reference2 EQ ''>
							<cfinput type="checkbox" name="check_form2" OnClick="javascript:todaydate7();">
						<cfelse>
							<cfinput type="checkbox" name="check_form2" OnClick="javascript:todaydate7();" checked="yes">
						</cfif>
					</td>
					<td>Reference ##2</td>
					<td>Date:</td>
					<td><cfinput type="text" name="reference2" value="#DateFormat(get_student_info.reference2, 'mm/dd/yyyy')#" size="9" validate="date"></td>
				</tr>
			</table>
		</td>
	</tr>
	<!--- Flight Information ---->			
	<tr>
		<cfif get_arrival.recordcount EQ '0'>
			<td><cfinput type="checkbox" name="flight_info"></td>
			<td>Flight Information </td>
			<td></td>
			<td>&nbsp;</td>
		<cfelse>
			<td><cfinput type="checkbox" name="flight_info" checked="yes"></td>
			<td>Flight Information &nbsp; <a href="student/index.cfm?action=flightInformation&uniqueID=#get_student_info.uniqueID#&programID=#get_student_info.programID#" class="jQueryModal">See Flight</a></td>
			<td></td>
			<td>&nbsp;</td>
		</cfif>
	</tr>
	<!--- Student Arrival Orientation Sign-off --->
	<tr>
		<td><Cfif get_student_info.student_orientation EQ ''>
				<cfinput type="checkbox" name="check_student_orientation" OnClick="javascript:StuOrientation();">		
			<cfelse>
				<cfinput type="checkbox" name="check_student_orientation" OnClick="javascript:StuOrientation();" checked="yes">	
			</cfif>		
		</td>
		<td>Student Arrival Orientation Sign-off</td>
		<td>Date:</td>
		<td><cfinput type="text" name="student_orientation" value="#DateFormat(get_student_info.student_orientation, 'mm/dd/yyyy')#" size="9" validate="date"></td>
	</tr>	
	<!--- Host Family Arrival Orientation Sign-off ---->		
	<tr>
		<td><Cfif get_student_info.host_orientation EQ ''>
				<cfinput type="checkbox" name="check_host_orientation" OnClick="javascript:HostOrientation();">		
			<cfelse>
				<cfinput type="checkbox" name="check_host_orientation" OnClick="javascript:HostOrientation();" checked="yes">	
			</cfif>
		</td>
		<td>Host Family Arrival Orientation Sign-off</td>
		<td>Date:</td>
		<td><cfinput type="text" name="host_orientation" size=9 value="#DateFormat(get_student_info.host_orientation, 'mm/dd/yyyy')#"></td>
	</tr>	
	<!--- Student Progress Reports ---->			
	<tr>
		<td>
			<cfif get_student_info.progress_reports EQ '1'>
				<cfinput type="checkbox" name="progress_reports" checked="yes">
			<cfelse>
				<cfinput type="checkbox" name="progress_reports">
			</cfif>
		</td>
		<td>Student Progress Reports</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td colspan="3">
			<table border=0 cellpadding=2 cellspacing=0 align="center">	
				<tr>
					<!--- OCTOBER ---->	
					<cfif get_report10.recordcount EQ '0'>
						<td width="25"><cfinput type="checkbox" name="report10"></td>
						<td width="100">October</td>
						<td width="140">Date: &nbsp; n/a</td>
						<td width="30"></td>
					<cfelse>
						<td width="25"><cfinput type="checkbox" name="report10" checked="yes"></td>
						<td width="100">October</td>
						<td width="140">Date: &nbsp; <a href="../index.cfm?curdoc=forms/view_progress_report&number=#get_report10.report_number#" target="main_win">#DateFormat(get_report10.date, 'mm/dd/yyyy')#</a></td>
						<td width="30"></td>
					</cfif>
					<!--- DECEMBER ---->	
					<cfif get_report12.recordcount EQ '0'>
						<td width="25"><cfinput type="checkbox" name="report12"></td>	
						<td width="100">December</td>
						<td width="140">Date: &nbsp; n/a</td>
						<td width="100"></td>
					<cfelse>
						<td width="25"><cfinput type="checkbox" name="report12" checked="yes"></td>	
						<td width="100">December</td>
						<td width="140">Date: &nbsp; <a href="../index.cfm?curdoc=forms/view_progress_report&number=#get_report12.report_number#" target="main_win">#DateFormat(get_report12.date, 'mm/dd/yyyy')#</a></td>
						<td width="100"></td>
					</cfif>
				</tr>
				<tr>
					<!--- FEBRUARY ---->	
					<cfif get_report2.recordcount EQ '0'>
						<td><cfinput type="checkbox" name="report2"></td>
						<td>February</td>
						<td>Date: &nbsp; n/a</td>
						<td></td>
					<cfelse>
						<td><cfinput type="checkbox" name="report2" checked="yes"></td>
						<td>February</td>
						<td>Date: &nbsp; <a href="../index.cfm?curdoc=forms/view_progress_report&number=#get_report2.report_number#" target="main_win">#DateFormat(get_report2.date, 'mm/dd/yyyy')#</a></td>
						<td></td>
					</cfif>
					<!--- APRIL ---->	
					<cfif get_report4.recordcount EQ '0'>
						<td><cfinput type="checkbox" name="report4"></td>	
						<td>April</td>
						<td>Date: &nbsp; n/a</td>
						<td></td>
					<cfelse>
						<td><cfinput type="checkbox" name="report4" checked="yes"></td>	
						<td>April</td>
						<td>Date: &nbsp; <a href="../index.cfm?curdoc=forms/view_progress_report&number=#get_report4.report_number#" target="main_win">#DateFormat(get_report4.date, 'mm/dd/yyyy')#</a></td>
						<td></td>
					</cfif>
				</tr>
				<tr>
					<!--- JUNE ---->	
					<cfif get_report6.recordcount EQ '0'>
						<td><cfinput type="checkbox" name="report6"></td>
						<td>June</td>
						<td>Date: &nbsp; n/a</td>
						<td></td>
					<cfelse>
						<td><cfinput type="checkbox" name="report6" checked="yes"></td>
						<td>June</td>
						<td>Date: &nbsp; <a href="../index.cfm?curdoc=forms/view_progress_report&number=#get_report6.report_number#" target="main_win">#DateFormat(get_report6.date, 'mm/dd/yyyy')#</a></td>
						<td></td>					
					</cfif>
					<!--- AUGUST ---->	
					<cfif get_report8.recordcount EQ '0'>
						<td><cfinput type="checkbox" name="report8"></td>	
						<td>August</td>
						<td>Date: &nbsp; n/a</td>
						<td></td>
					<cfelse>
						<td><cfinput type="checkbox" name="report8" checked="yes"></td>	
						<td>August</td>
						<td>Date: &nbsp; <a href="../index.cfm?curdoc=forms/view_progress_report&number=#get_report8.report_number#" target="main_win">#DateFormat(get_report8.date, 'mm/dd/yyyy')#</a></td>
						<td></td>
					</cfif>
				</tr>
			</table>
		</td>
	</tr>
	<!--- Double Placement Paperwork ---->		
	<tr>
		<td><cfinput type="checkbox" name="double_paperwork"></td>
		<td>Double Placement Paperwork</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td colspan="3">
			<table border=0 cellpadding=2 cellspacing=0 align="center">	
				<tr>
					<!--- Student ---->	
					<td width="25">
						<Cfif get_student_info.double_student EQ ''>
							<cfinput type="checkbox" name="check_double_doc_stu" OnClick="javascript:DoubleStudent();" >
						<cfelse>
							<cfinput type="checkbox" name="check_double_doc_stu" OnClick="javascript:DoubleStudent();"  checked="yes">		
						</cfif>
					</td>
					<td width="100">Student</td>
					<td width="140">Date: &nbsp; <cfinput type="text" name="double_student" size=8 value="#DateFormat(get_student_info.double_student, 'mm/dd/yyyy')#"></td>
					<td width="30"></td>
					<!--- Natural Family ---->	
					<td width="25">
						<Cfif get_student_info.double_natural EQ ''>
							<cfinput type="checkbox" name="check_double_doc_fam" OnClick="javascript:DoubleNatural();CheckDouble();" >
						<cfelse>
							<cfinput type="checkbox" name="check_double_doc_fam" OnClick="javascript:DoubleNatural();CheckDouble();"  checked="yes">		
						</cfif>
					</td>
					<td width="100">Natural Family</td>
					<td width="140">Date: &nbsp; <cfinput type="text" name="double_natural" size=8 value="#DateFormat(get_student_info.double_natural, 'mm/dd/yyyy')#"></td>
					<td width="100"></td>
				</tr>
				<tr>
					<!--- Host Family ---->	
					<td>
						<Cfif get_student_info.double_natural EQ ''>
							<cfinput type="checkbox" name="check_double_doc_host" OnClick="javascript:DoubleHost();CheckDouble();" >
						<cfelse>
							<cfinput type="checkbox" name="check_double_doc_host" OnClick="javascript:DoubleHost();CheckDouble();"  checked="yes">		
						</cfif>
					</td>
					<td>Host Family</td>
					<td>Date: &nbsp; <cfinput type="text" name="double_host" size=8 value="#DateFormat(get_student_info.double_host, 'mm/dd/yyyy')#"></td>
					<td></td>
					<!--- School ---->	
					<td>
						<Cfif get_student_info.double_school EQ ''>
							<cfinput type="checkbox" name="check_double_doc_school" OnClick="javascript:DoubleSchool();CheckDouble();">
						<cfelse>
							<cfinput type="checkbox" name="check_double_doc_school" OnClick="javascript:DoubleSchool();CheckDouble();" checked="yes">		
						</cfif>					
					</td>
					<td>School</td>
					<td>Date: &nbsp; <cfinput type="text" name="double_school" size=8 value="#DateFormat(get_student_info.double_school, 'mm/dd/yyyy')#"></td>
					<td></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td colspan="3">Notes :<br>
			<textarea name="compliance_notes" cols="63" rows="4">#get_student_info.compliance_notes#</textarea></td>
	</tr>
</table><br>
</div>
	
<table width="100%" border=0 cellpadding=2 cellspacing=0 align="center" class="section">	
	<tr>
		<cfif user_rights.compliance NEQ '1'>
		<td align="center">
			<input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()">
		</td>
		<cfelse>
		<td align="right" width="50%"><br>
		<input name="submit" type="image" src="../pics/update.gif" align="right" border=0>&nbsp;&nbsp;&nbsp;&nbsp;</form></td>
		<td align="left" width="50%">
			<Br>&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()">
		</td>
		</cfif>
	</tr>
</table>

<!----footer of table---->
<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign="bottom">
		<td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td>
		<td width=100% background="../pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td></tr>
</table>
</cfform>

</cfoutput>

<SCRIPT LANGUAGE="JavaScript">
<!-- Begin
// Double Placement Paperwork
if ((document.checklist.check_double_doc_stu.checked) && (document.checklist.check_double_doc_fam.checked) 
	&& (document.checklist.check_double_doc_host.checked) && (document.checklist.check_double_doc_school.checked)) {
	document.checklist.double_paperwork.checked = true; }
	else {
	document.checklist.double_paperwork.checked = false;
	}
//  End -->
</script>

</body>
</html>