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

<!----If coming from User Profile, don't check for form vaiables--->
<Cfif isDefined('url.user')>
	<cfset form.supervising = #url.user#>
	<Cfset form.placeing = 0>
	<cfset form.student = 0>
<cfelse>
	<cfif form.placeing is 0 and form.supervising is 0 and form.student is 0>
		<cflocation url="?curdoc=forms/supervising_placement_payments&selected=0" addtoken="no">
	<cfelseif form.placeing gt 0 and (form.supervising gt 0 or form.student gt 0)>
		<cflocation url="?curdoc=forms/supervising_placement_payments&selected=2&s=#form.supervising#&p=#form.placeing#&st=#form.student#" addtoken="no">
	<cfelseif form.supervising gt 0 and (form.placeing gt 0 or form.student gt 0)> 
		<cflocation url="?curdoc=forms/supervising_placement_payments&selected=2&s=#form.supervising#&p=#form.placeing#&st=#form.student#" addtoken="no">
	<cfelseif form.student gt 0 and (form.placeing gt 0 or form.supervising gt 0)>
		<cflocation url="?curdoc=forms/supervising_placement_payments&selected=2&s=#form.supervising#&p=#form.placeing#&st=#form.student#" addtoken="no">
	</cfif>
	<!--- If student is selected it's redirected to another page --->
	<cfif IsDefined('form.student') and form.student gt 0 and form.placeing is 0 and form.supervising is 0>
		<cflocation url="?curdoc=forms/supervising_place_student&studentid=#form.student#" addtoken="no">
	</cfif>	
</cfif>

<Cfif isDefined('url.s')>
	<Cfset form.supervising = #url.s#>
	<cfset form.placeing = #url.p#>
	<cfset form.student = #url.st#>
</Cfif>

<!--- 
<Cfif not isDefined('url.order')>
	<cfset url.order='studentid'>
</Cfif>
---->

<cfquery name="payment_type_super" datasource="caseusa">
	SELECT id, type
	FROM smg_payment_types
	WHERE active = '1' AND (paymenttype = 'Supervision' or paymenttype = '')
</cfquery>

<cfquery name="payment_type_place" datasource="caseusa">
	SELECT id, type
	FROM smg_payment_types
	WHERE active = '1' AND (paymenttype = 'Placement' or paymenttype = '')
</cfquery>

<div class="application_section_header">Supervising & Placement Payments</div>

<!----Regardless of where rep selected, pull all students placed by that rep---->
<cfquery name="get_placed_students" datasource="caseusa">
	SELECT studentid, familylastname, firstname, smg_students.programid, programname
	FROM smg_students
	LEFT JOIN smg_programs p ON p.programid = smg_students.programid
	WHERE 1=1
	<Cfif form.placeing gt 0>
	AND	placerepid = #form.placeing#
	<cfelseif form.supervising gt 0>
	AND	placerepid = #form.supervising#
	</Cfif> 
	AND smg_students.companyid = #client.companyid#
	ORDER BY studentid DESC
</cfquery>

<!----Regardless of where rep selected, pull all students supervised by that rep---->
<cfquery name="get_supervised_students" datasource="caseusa">
	select studentid, familylastname, firstname, smg_students.programid, programname
	from smg_students
	LEFT JOIN smg_programs p ON p.programid = smg_students.programid
	where 1=1
	<Cfif form.placeing gt 0>
	AND arearepid = #form.placeing#
	<cfelseif form.supervising gt 0>
	AND arearepid = #form.supervising#
	</Cfif> 
	AND smg_students.companyid = #client.companyid#
	ORDER BY studentid DESC
</cfquery>

<cfoutput>
<Cfquery name="rep_info" datasource="caseusa">
	select firstname, lastname, userid
	from smg_users
	where 
	<Cfif form.placeing gt 0>
	userid = #form.placeing#
	<cfelseif form.supervising gt 0>
	userid = #form.supervising#
	</cfif>
</Cfquery>
<cfset rep = #rep_info.userid#>

<h2>Representative: #rep_info.firstname# #rep_info.lastname# (#rep_info.userid#) &nbsp; <span class="get_attention"><b>::</b></span>
<a href="" class="nav_bar" onClick="javascript: win=window.open('forms/supervising_history.cfm?userid=#rep_info.userid#', 'Settings', 'height=300, width=650, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Payment History</a></h2>

<cfform method="post" action="?curdoc=forms/supervising_place_payment_details">

<input type="hidden" name="user" value="#rep#">
<table width=90% cellpadding=4 cellspacing=0>
	<tr><td colspan="5">Check each student you want to apply payments for.</td></tr>
	<tr>
		<td colspan="5">
		Please, select type of payment for the supervised students: 
		<cfselect name="payment_type_super" query="payment_type_super" value="id" display="type" queryPosition="below">
			<option value=""></option>
		</cfselect>
		</td>
	</tr>
	<tr>
		<td colspan=5 bgcolor="010066"><font color="white"><strong>Supervised Students &nbsp; - &nbsp; #get_supervised_students.recordcount#</strong></font></td>
	</tr>
	<tr bgcolor="CCCCCC">
		<td><input type="checkbox" value="Check All" onClick="this.value=check2(this.form.supervised_selected_student)"></td>
		<Td>ID</Td>
		<td>Last Name, First Name</td>
		<td>Program</td>
	    <td>&nbsp;</td>
	</tr>
	<cfloop query="get_supervised_students">
	<tr>
		<td><input type="checkbox" name="supervised_selected_student" value=#studentid#></td>
		<Td><a href="" class="nav_bar" onClick="javascript: win=window.open('forms/supervising_student_history.cfm?studentid=#studentid#', 'Settings', 'height=300, width=650, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">#studentid#</a></Td>
		<td><a href="" class="nav_bar" onClick="javascript: win=window.open('forms/supervising_student_history.cfm?studentid=#studentid#', 'Settings', 'height=300, width=650, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">#familylastname#, #firstname#</a></td>
		<Td>#programname#</Td>  
		<td>&nbsp;</td>
	</tr>
	</cfloop>
	<tr>
	 	<td colspan=5 align="right"> <input name="submit" type="image" src="pics/next.gif" align="right" border=0 alt="search"></td>
	</Tr>
	<!--- PLACED STUDENTS --->
	<tr>
		<td colspan="5">
		Please, select type of payment for the placed students: 
		<cfselect name="payment_type_place" query="payment_type_place" value="id" display="type" queryPosition="below">
			<option value=""></option>
		</cfselect>
		</td>
	</tr>
	<tr>
		<td colspan=5 bgcolor="010066"><font color="white"><strong>Placed Students &nbsp; - &nbsp; #get_placed_students.recordcount#</strong></font></td>
	</tr>
	<tr bgcolor="CCCCCC">
		<td><input type="checkbox" value="Check All" onClick="this.value=check(this.form.placed_selected_student)"></td>
		<Td>ID</Td>
		<td>Last Name>, First Name</td>
		<td>Program</td>
		<td>&nbsp;</td>
	</tr>
	<cfloop query="get_placed_students">
	<tr>
		<td><input type="checkbox" name="placed_selected_student" value=#studentid#></td>
		<td><a href="" class="nav_bar" onClick="javascript: win=window.open('forms/supervising_student_history.cfm?studentid=#studentid#', 'Settings', 'height=300, width=650, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">#studentid#</a></Td>
		<td><a href="" class="nav_bar" onClick="javascript: win=window.open('forms/supervising_student_history.cfm?studentid=#studentid#', 'Settings', 'height=300, width=650, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">#familylastname#, #firstname#</a></td>
		<Td>#programname#</Td>  
		<td>&nbsp;</td>
	</tr>
   </cfloop>
	<tr>
		<td colspan=5 align="right">  <input name="submit" type="image" src="pics/next.gif" align="right" border=0 alt="search"></td>
	</Tr>
</table>
</cfform>
</cfoutput>