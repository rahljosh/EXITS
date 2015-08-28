<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="smg.css">
	<title>Process Application</title>
</head>
<script>
<!--// 
// approve
function approve() { 
   if(confirm("You are about to approve this applicaton. Click OK to continue")) { 
     form.submit(); 
        return true; 
   } else { 
        return false; 
   } 
} 
// open online application 
function OpenApp(url)
{
	newwindow=window.open(url, 'Application', 'height=580, width=790, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); 
	if (window.focus) {newwindow.focus()}
}
var newwindow;
function OpenSmallW(url) {
	newwindow=window.open(url, 'Application', 'height=300, width=400, location=no, scrollbars=yes, menubar=no, toolbars=no, resizable=yes'); 
	if (window.focus) {newwindow.focus()}
}
//-->
</script>
<body>

<style type="text/css">
.thin-border{ border: 1px solid #000000;
			  font:Arial, Helvetica, sans-serif;}
</style>

<cfif NOT isdefined('url.studentid')>
	An error has ocurred. Please try again.
	<cfabort>
<cfelseif url.studentid EQ ''>
	You have not specified a valid studentid.
	<cfabort>
</cfif>

<cfquery name="get_student_info" datasource="mysql">
	SELECT s.studentid, s.uniqueid, s.familylastname, s.firstname, s.middlename, s.dob, s.sex, s.countryresident, s.active, 
		s.app_current_status, s.app_indicated_program, s.dateapplication, s.companyid, s.randid,
		smg_countrylist.countryname,
		u.businessname,
		p.app_program,
		c.companyshort
	FROM smg_students s
	INNER JOIN smg_users u ON u.userid = s.intrep
	LEFT JOIN smg_countrylist ON countryresident = smg_countrylist.countryid
	LEFT JOIN smg_student_app_programs p ON p.app_programid = s.app_indicated_program
	LEFT JOIN smg_companies c ON c.companyid = s.companyid
	WHERE s.studentid = <cfqueryparam value="#url.studentid#" cfsqltype="cf_sql_integer" maxlength="6">
</cfquery>

<cfquery name="onhold" datasource="MySql">
	SELECT holdid, hold_reason
	FROM smg_student_app_hold
	ORDER BY hold_reason
</cfquery>
 
<cfdirectory directory="#AppPath.onlineApp.picture#" name="file" filter="#get_student_info.studentid#.*">

<!--- HEADER OF TABLE --->
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
		<td background="pics/header_background.gif"><h2>Process Application</h2></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<cfoutput query="get_student_info">

<div class="section"><br>

<table width="660" border=0 cellpadding=4 cellspacing=2 align="center">	
	<tr>
		<td width="150" rowspan="10" align="left" valign="top">
			<cfif file.recordcount>
				<img src="uploadedfiles/web-students/#file.name#" width="130" height="150"><br>
			<cfelse>
				<img src="pics/no_stupicture.jpg" border=0>
			</cfif>
		</td>
		<td colspan="2"><b>Student's Name</b></td>
		<td><b>Student ID: &nbsp; </b> ###studentid#</td>
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
	<tr>
		<td colspan="3">
			<table width="100%" border=0 cellpadding=4 cellspacing=0 align="center">	
				<tr>
					<td><b>Program Information</b></td>	
					<td><b>Country of Legal Permanent Residence:</b></td>
				</tr>
				<tr>
					<td>#app_program#<br><img src="pics/line.gif" width="255" height="1" border="0" align="absmiddle"></td>	
					<td>#countryname#<br><img src="pics/line.gif" width="255" height="1" border="0" align="absmiddle"></td>
				</tr>
				<tr>
					<td><b>International Representative</b></td>
					<td><b>Company</b></td>
				</tr>
				<tr>
					<td>#businessname#<br><img src="pics/line.gif" width="255" height="1" border="0" align="absmiddle"></td>
					<td>#companyshort#<br><img src="pics/line.gif" width="255" height="1" border="0" align="absmiddle"></td>
				</tr>
				<tr>
					<td><b>Application Type</b></td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<cfif get_student_info.randid>
						<td valign="top">Online Application <br><img src="pics/line.gif" width="255" height="1" border="0" align="absmiddle"></td>
						<td valign="top" align="center">
							<a href="javascript:OpenApp('student_app/index.cfm?curdoc=section1&unqid=#get_student_info.uniqueid#&id=1');"><img src="pics/exits.jpg" border="0"></a>
							<br><a href="javascript:OpenSmallW('student_app/section4/page22print.cfm?unqid=#get_student_info.uniqueid#');"><img src="pics/attached-files.gif" border="0"></a>	<cfif client.userid eq 16718 or client.userid eq 314>
                                            <br><a href="javascript:OpenSmallW('student_app/email_form.cfm?unqid=#uniqueid#', 400, 450);"><img src="pics/send-email.gif" border="0"></a>	</cfif>
							<br><a href="javascript:OpenApp('virtualfolder/list_vfolder.cfm?unqid=#get_student_info.uniqueid#');">Virtual Folder</a>
						</td>
					<cfelse>
						<td>Paper Application <br><img src="pics/line.gif" width="255" height="1" border="0" align="absmiddle"></td>
						<td>&nbsp;</td>
					</cfif>
				</tr>
			</table>
		</td>
	</tr>
</table><br>

<table width="660" border=0 cellpadding=10 cellspacing=4 align="center" class="thin-border">	
	<cfif get_student_info.companyid NEQ 0>
		<tr>
			<!--- ONLINE APPLICATIOn --->
			<cfif get_student_info.randid>
				<td align="center"><a href="javascript:OpenApp('student_app/index.cfm?curdoc=approve_student_app&unqid=#get_student_info.uniqueid#');"><img src="student_app/pics/approve.gif" alt="Approve Application" border="0" align="top"></a></td>
				<td align="center"><a href="?curdoc=app_process/onhold_app&studentid=#get_student_info.studentid#"><img src="student_app/pics/hold.gif" alt="Put Application on Hold" border="0" align="top"></a></td>
				<td align="center"><a href="javascript:OpenApp('student_app/index.cfm?curdoc=deny_application&unqid=#get_student_info.uniqueid#');"><img src="student_app/pics/deny.gif" alt="Deny Application" border="0" align="top"></a></td>
                <td><A href="index.cfm?curdoc=app_process/transfer_app&studentid=#get_student_info.studentid#">
                <img src="student_app/pics/transfer_03.png" alt="Transfer Application" border="0" align="top"></a></td>
			<!--- PAPER APPLICATION --->
			<cfelse>
				<td align="center"><a href="?curdoc=app_process/qr_approve&studentid=#get_student_info.studentid#" onClick="return approve()"><img src="student_app/pics/approve.gif" alt="Approve Application" border="0" align="top"></a></td>
				<td align="center"><a href="?curdoc=app_process/onhold_app&studentid=#get_student_info.studentid#"><img src="student_app/pics/hold.gif" alt="Put Application on Hold" border="0" align="top"></a></td>
				<td align="center"><a href="?curdoc=app_process/deny_app&studentid=#get_student_info.studentid#"><img src="student_app/pics/deny.gif" alt="Deny Application" border="0" align="top"></a></td>
                <td><A href="index.cfm?curdoc=app_process/transfer_app&studentid=#get_student_info.studentid#">
                <img src="student_app/pics/transfer_03.png" alt="Transfer Application" border="0" align="top"></a></td>
			</cfif>
		</tr>
	<cfelse>
		<tr>
			<td align="center">
				#get_student_info.firstname# #get_student_info.familylastname# is not assigned to a company.<br><br>
				You must assign a student to a company first in order to approve, put it on hold or reject this student.<br><br>
				Please <a href="index.cfm?curdoc=apps_received&status=received">go back</a> and try again.<br><br>
			</td>
		</tr>
	</cfif>
</table><br>

</div>

<cfinclude template="../table_footer.cfm">

</cfoutput>