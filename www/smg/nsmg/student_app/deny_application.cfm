<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>SMG - EXITS Online Application</title>
</head>
<body>

<style type="text/css">
.thin-border{ border: 1px solid #000000;
			  font:Arial, Helvetica, sans-serif;}
</style>

<script language="JavaScript"> 	
<!--//
function CheckCompany() {
   if (document.app_denial.companyid.value == '0') {
	alert("Please select a company which denied this student application.");
	document.app_denial.companyid.focus(); 
	return false; }
	if (document.app_denial.reason.value == '') {
	alert("Please enter a reason for denying this application.");
	document.app_denial.reason.focus(); 
	return false; }
	}
//-->
</script>

<cfif isDefined('url.unqid')>
	<!----Get student id  for office folks linking into the student app---->
	<cfquery name="get_student_id" datasource="MySQL">
		SELECT studentid
		from smg_students
		WHERE uniqueid = '#url.unqid#'
	</cfquery>
	<cfset client.studentid = get_student_id.studentid>
</cfif>

<cfinclude template="../querys/get_student_info.cfm">

<cfquery name="get_intrep" datasource="MySql">
	SELECT userid, businessname
	FROM smg_users 
	WHERE userid = '#get_student_info.intrep#'
</cfquery>

<cfquery name="app_programs" datasource="MySQL">
	SELECT app_programid, app_program 
	FROM smg_student_app_programs
	WHERE app_programid = '#get_student_info.app_indicated_program#'
</cfquery>
 
<cfquery name="app_other_programs" datasource="MySQL">
	SELECT app_programid, app_program 
	FROM smg_student_app_programs
	WHERE app_programid = '#get_student_info.app_additional_program#'
</cfquery> 

<cfquery name="states_requested" datasource="MySQL">
	SELECT state1, sta1.statename as statename1, state2, sta2.statename as statename2, state3, sta3.statename as statename3
	FROM smg_student_app_state_requested 
	LEFT JOIN smg_states sta1 ON sta1.id = state1
	LEFT JOIN smg_states sta2 ON sta2.id = state2
	LEFT JOIN smg_states sta3 ON sta3.id = state3
	WHERE studentid = '#get_student_info.studentid#'
</cfquery>

<!----Company and Region Assignment---->
<cfquery name="get_company" datasource="MySQL">
	SELECT companyid, companyname
	FROM smg_companies
	WHERE companyid <= '6'
</cfquery>

<cfset nsmg_directory = '/var/www/html/student-management/nsmg/uploadedfiles/web-students'>
<cfdirectory directory="#nsmg_directory#" name="file" filter="#client.studentid#.*">

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="../pics/students.gif"></td>
		<td class="tablecenter"><h2>Deny Application</h2></td>
		<td width="42" class="tableside"><img src="pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<cfoutput query="get_student_info">

<div class="section"><br>

<table width="660" border=0 cellpadding=4 cellspacing=2 align="center">	
	<tr>
		<td width="150" rowspan="10" align="left" valign="top">
			<cfif file.recordcount>
				<img src="../uploadedfiles/web-students/#file.name#" width="130" height="150"><br>
			<cfelse>
				<img src="pics/no_image.gif" border=0>
			</cfif>
		</td>
		<td colspan="3"><b>Student's Name</b></td>
	</tr>
	<tr>
		<td width="200"><em>Family Name</em></td>
		<td width="180"><em>First Name</em></td>
		<td width="140"><em>Middle Name</em></td>		
	</tr>
	<tr>
		<td valign="top">#familylastname#<br><img src="pics/line.gif" width="195" height="1" border="0" align="absmiddle"></td>
		<td valign="top">#firstname#<br><img src="pics/line.gif" width="175" height="1" border="0" align="absmiddle"></td>
		<td valign="top">#middlename#<br><img src="pics/line.gif" width="135" height="1" border="0" align="absmiddle"></td>
	</tr>
	<tr><td colspan="3">&nbsp;</td></tr>
	<tr><td colspan="3">
			<table width="100%" border=0 cellpadding=0 cellspacing=0 align="center">	
				<tr><td colspan="2"><b>Program Information</b></td></tr>
				<tr>
					<td><em>Program</em></td>
					<td><em>Additional Programs</em></td>
				</tr>
				<tr>
					<td>#app_programs.app_program#<br><img src="pics/line.gif" width="255" height="1" border="0" align="absmiddle"></td>
					<td><cfif app_other_programs.recordcount EQ '0'>None<cfelse>#app_other_programs.app_program#</cfif><br><img src="pics/line.gif" width="255" height="1" border="0" align="absmiddle"></td>
				</tr>
				<tr><td colspan="2">&nbsp;</td></tr>
			</table>
	</td></tr>
	<tr>
		<td><em>International Representative</em></td><td><em>Regional Guarantee</em></td><td><em>State Guarnatee</em></td>
	</tr>
	<tr>
		<td valign="bottom">#get_intrep.businessname#<br><img src="pics/line.gif" width="195" height="1" border="0" align="absmiddle"></td>
		<td valign="bottom">
			<cfif get_student_info.app_region_guarantee EQ '0'> n/a 
			<cfelseif get_student_info.app_region_guarantee EQ '1'>Region 1 - East
			<cfelseif get_student_info.app_region_guarantee EQ '2'>Region 2 - South
			<cfelseif get_student_info.app_region_guarantee EQ '3'>Region 3 - Central
			<cfelseif get_student_info.app_region_guarantee EQ '4'>Region 4 - Rocky Mountain
			<cfelseif get_student_info.app_region_guarantee EQ '5'>Region 5 - West
			</cfif>
			<br><img src="pics/line.gif" width="175" height="1" border="0" align="absmiddle">
		</td>
		<td valign="bottom">
			<cfif states_requested.state1 EQ '0' OR states_requested.recordcount EQ '0'>
				n/a
			<cfelse>
				1st Choice: #states_requested.statename1#<br>
				2nd Choice: #states_requested.statename2#<br>
				3rd Choice: #states_requested.statename3#
			</cfif>
			<br><img src="pics/line.gif" width="135" height="1" border="0" align="absmiddle">
		</td>
	</tr>
</table><br><br>

<cfform method="post" name="app_denial" action="querys/qr_deny_application.cfm" onSubmit="return CheckCompany();">
<cfinput type="hidden" name="studentid" value="#get_student_info.studentid#">
<table width="500" border=0 cellpadding=4 cellspacing=2 align="center" class="thin-border">	
	<tr><td colspan=2><h3><u>The following information is required to deny this student application.</u></h3></td></tr>
	<cfif client.usertype EQ '8' OR client.usertype EQ '11'>
			<cfset form.companyid = '0'>
	<cfelse>
	<tr>
		<td align="right">This application was denied by: </td>
		<td><cfselect name="companyid">
				<option value="0">Select Company</option>
				<cfloop query="get_company">
				<option value="#companyid#" <cfif get_student_info.companyid EQ companyid>selected</cfif>>#companyname#</option>
		 		</cfloop>
			</cfselect>
		</td>
	</tr>
	</cfif>
	<tr><td align="right">Reason:</td><td><cftextarea name="reason" rows="5" cols="35"></cftextarea></td></tr>
	<tr>
		<td align="center" colspan=2><br>
		<cfinput name="submit" type=image src="pics/deny.gif" alt='Deny Application'>		
		</td>
	</tr>
</table><br>

<table width="660" border=0 cellpadding=4 cellspacing=2 align="center">	
	<tr><td align="center">Upon denial a notification will be sent to the student (if an email is on file) and Intl. Agent that their application has been denied due to the reason stated above.<br></td></tr>
</table><br>

</cfform>

</div>

<cfinclude template="footer_table.cfm">

</cfoutput>