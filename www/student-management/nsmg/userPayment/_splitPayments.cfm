<SCRIPT LANGUAGE="JavaScript">
	<!-- Begin
	var checkflag = "false";
	function check(field) {
	if (checkflag == "false") {
	for (i = 0; i < field.length; i++) {
	field[i].checked = true;}
	checkflag = "true";
	return "Uncheck All"; }
	else {
	for (i = 0; i < field.length; i++) {
	field[i].checked = false; }
	checkflag = "false";
	return "Check All"; }
	}
	//  End -->
	<!-- Begin
	var checkflag2 = "false";
	function check2(field) {
	if (checkflag2 == "false") {
	for (i = 0; i < field.length; i++) {
	field[i].checked = true;}
	checkflag2 = "true";
	return "Uncheck All"; }
	else {
	for (i = 0; i < field.length; i++) {
	field[i].checked = false; }
	checkflag2 = "false";
	return "Check All"; }
	}
	//  End -->
</script>

<Cfif not isDefined('url.order')>
	<cfset url.order='studentid'>
</Cfif>

<Cfif isDefined('url.user')>
	<cfset form.user = '#url.user#'>
</Cfif>

<cfquery name="payment_type_super" datasource="MySql">
	SELECT id, type
	FROM smg_payment_types
	WHERE paymenttype = 'Supervision' or paymenttype = ''
</cfquery>

<cfquery name="payment_type_place" datasource="MySql">
	SELECT id, type
	FROM smg_payment_types
	WHERE paymenttype = 'Placement' or paymenttype = ''
</cfquery>

<div class="application_section_header">Supervising & Placement Payments</div>

<!----Regardless of where rep selected, pull all students supervised by that rep---->
<cfquery name="get_supervised_students" datasource="MySQL">
	SELECT DISTINCT s.studentid, s.familylastname, s.firstname, s.programid, programname
		FROM smg_students s
		LEFT JOIN smg_programs p ON p.programid = s.programid
		WHERE s.arearepid = '#form.user#' AND s.companyid = '#client.companyid#'
	UNION
	SELECT DISTINCT s.studentid, s.familylastname, s.firstname, s.programid, programname
		FROM smg_students s
		LEFT JOIN smg_programs p ON p.programid = s.programid
		INNER JOIN smg_hosthistory h ON h.studentid = s.studentid
		WHERE h.arearepid = '#form.user#' AND s.companyid = '#client.companyid#'
	GROUP BY studentid
	ORDER BY studentid DESC
</cfquery>

<!----Regardless of where rep selected, pull all students placed by that rep---->
<cfquery name="get_placed_students" datasource="mysql">
	SELECT DISTINCT s.studentid, s.familylastname, s.firstname, s.programid, programname
		FROM smg_students s
		LEFT JOIN smg_programs p ON p.programid = s.programid
		WHERE s.placerepid = '#form.user#' AND s.companyid = '#client.companyid#'
	UNION
	SELECT DISTINCT s.studentid, s.familylastname, s.firstname, s.programid, programname
		FROM smg_students s
		LEFT JOIN smg_programs p ON p.programid = s.programid
		INNER JOIN smg_hosthistory h ON h.studentid = s.studentid
		WHERE h.placerepid = '#form.user#' AND s.companyid = '#client.companyid#'
	GROUP BY studentid
	ORDER BY studentid DESC
</cfquery>

<Cfquery name="rep_info" datasource="MySQL">
	select firstname, lastname, userid
	from smg_users
	where userid = #form.user#
</Cfquery>

<cfoutput>
<cfset rep = #rep_info.userid#>
<h2>Representative: #rep_info.firstname# #rep_info.lastname# (#rep_info.userid#) &nbsp; <span class="get_attention"><b>::</b></span>
<a href="javascript:openPopUp('userPayment/index.cfm?action=paymentHistory&userid=#rep_info.userid#', 700, 500);" class="nav_bar">Payment History</a></h2>

<cfform method="post" action="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=processPayment&split=yes">

<input type="hidden" name="user" value="#rep#">
<table width=90% cellpadding=4 cellspacing=0>
	<tr><td colspan="6">Check each student you want to apply payments for.</td></tr>
	<tr>
		<td colspan="6">
		Please, select type of payment for the supervised students: 
		<cfselect name="payment_type_super" query="payment_type_super" value="id" display="type" queryPosition="below">
			<option value=""></option>
		</cfselect>
		</td>
	</tr>
	<tr>
		<td colspan=6 bgcolor="##010066"><font color="white"><strong>Supervised Students &nbsp; - &nbsp; #get_supervised_students.recordcount#</strong></font></td>
	</tr>
	<tr bgcolor="##CCCCCC">
		<td><input type="checkbox" value="Check All" onClick="this.value=check2(this.form.supervised_selected_student)"></td>
		<Td>ID</Td>
		<td>Last Name, First Name</td>
		<td>Program</td>
		<td>&nbsp;</td>
	</tr>
	<cfloop query="get_supervised_students">
	<tr>
		<td><input type="checkbox" name="supervised_selected_student" value=#studentid#></td>
		<Td>
			<a href="javascript:openPopUp('userPayment/index.cfm?action=studentPaymentHistory&studentid=#studentid#', 700, 500);" class="nav_bar">#studentid#</a>
        </Td>
		<td>
        	<a href="javascript:openPopUp('userPayment/index.cfm?action=studentPaymentHistory&studentid=#studentid#', 700, 500);" class="nav_bar">#familylastname#, #firstname#</a>
        </td>
		<Td>#programname#</Td>  
		<td>&nbsp;</td>
	</tr>
	</cfloop>
	<tr>
	 	<td colspan=6 align="right"> <input name="submit" type="image" src="pics/next.gif" align="right" border="0" alt="search"></td>
	</Tr>
	<!--- PLACED STUDENTS --->
	<tr>
		<td colspan="6">
		Please, select type of payment for the placed students: 
		<cfselect name="payment_type_place" query="payment_type_place" value="id" display="type" queryPosition="below">
			<option value=""></option>
		</cfselect>
		</td>
	</tr>
	<tr>
		<td colspan=6 bgcolor="##010066"><font color="white"><strong>Placed Students &nbsp; - &nbsp; #get_placed_students.recordcount#</strong></font></td>
	</tr>
	<tr bgcolor="##CCCCCC">
		<td><input type="checkbox" value="Check All" onClick="this.value=check(this.form.placed_selected_student)"></td>
		<Td>ID</Td>
		<td>Last Name, First Name</td>
		<td>Program</td>
		<td>&nbsp;</td>
	</tr>
	<cfloop query="get_placed_students">
	<tr>
		<td><input type="checkbox" name="placed_selected_student" value=#studentid#></td>
		<td>
        	<a href="javascript:openPopUp('userPayment/index.cfm?action=studentPaymentHistory&studentid=#studentid#', 700, 500);" class="nav_bar">#studentid#</a>
		</Td>
		<td>
        	<a href="javascript:openPopUp('userPayment/index.cfm?action=studentPaymentHistory&studentid=#studentid#', 700, 500);" class="nav_bar">#familylastname#, #firstname#</a>
	    </td>
		<Td>#programname#</Td>  
		<td>&nbsp;</td>
	</tr>
   </cfloop>
	<tr>
		<td colspan=6 align="right">  <input name="submit" type="image" src="pics/next.gif" align="right" border="0" alt="search"></td>
	</Tr>
</table>
</cfform>
</cfoutput>