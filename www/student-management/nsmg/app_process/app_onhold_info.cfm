<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="smg.css">
	<title>SMG - EXITS - Application On Hold Information</title>
</head>
<script language="JavaScript"> 	
<!--// // show hidden forms
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
function approve() { 
   if(confirm("You are about to approve this applicaton. Click OK to continue")) { 
     form.submit(); 
        return true; 
   } else { 
        return false; 
   } 
} 
function confirm_email() { 
   if(confirm("You are about to send this notification to the international agent. Click OK to continue")) { 
     form.submit(); 
        return true; 
   } else { 
        return false; 
   } 
}
function CheckFields() {
  if (document.onhold.onhold_reasonid.value == 0) {
		alert("You must select a reason in order to continue.");
		return false;  
  } else if ((document.onhold.onhold_reasonid.value == 2) && ((document.onhold.onhold_interview_date.value == '') || (document.onhold.onhold_interview_time.value == '')))  {
		alert("You must enter a interview date and time.");
		return false;
  } else if (document.onhold.onhold_reasonid.value == 3) {
	   var Counter = 0;
	   for (i=0; i<document.onhold.onhold_docs.length; i++){
		  if (document.onhold.onhold_docs[i].checked){
			 Counter++;
		  }
	   }
	   if (Counter == 0) {
		  alert("You must select at least one document that is missing.");
		  return false;
	   } 
  }
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
		s.onhold_reasonid, s.onhold_docs, s.onhold_notes, s.onhold_interview_date, s.onhold_interview_time,
		smg_countrylist.countryname,
		u.businessname,
		p.app_program,
		c.companyshort,
		hold.hold_reason
	FROM smg_students s
	INNER JOIN smg_users u ON u.userid = s.intrep
	INNER JOIN smg_companies c ON c.companyid = s.companyid
	INNER JOIN smg_student_app_hold hold ON hold.holdid = s.onhold_reasonid
	LEFT JOIN smg_countrylist ON countryresident = smg_countrylist.countryid
	LEFT JOIN smg_student_app_programs p ON p.app_programid = s.app_indicated_program
	WHERE s.studentid = <cfqueryparam value="#url.studentid#" cfsqltype="cf_sql_integer" maxlength="6">
</cfquery>

<!--- RELOCATE IF APPROVED THRU THE ONLINE APP FORM --->
<cfif get_student_info.app_current_status EQ 11>
	<cflocation url="?curdoc=app_process/apps_received&status=hold" addtoken="no">
</cfif>

<cfquery name="docs_checklist" datasource="MySql">
	SELECT docid, document 
	FROM smg_student_doc_checklist 
	ORDER BY document
</cfquery>

<cfquery name="onhold_history" datasource="MySql">
	SELECT hist.studentid, hist.status, hist.date,
		u.firstname, u.lastname, u.userid
	FROM smg_student_app_status hist
	INNER JOIN smg_users u ON u.userid = approvedby
	WHERE hist.studentid = '#get_student_info.studentid#'
		AND hist.status = '10'
	ORDER BY hist.date DESC
</cfquery>
 
<cfdirectory directory="#AppPath.onlineApp.picture#" name="file" filter="#get_student_info.studentid#.*">

<!--- HEADER OF TABLE --->
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
		<td background="pics/header_background.gif"><h2>Application On Hold Information</h2></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<cfoutput query="get_student_info">

<div class="section"><br>
<table width="660" border=0 cellpadding=4 cellspacing=2 align="center" background="pics/hold.jpg">	
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
					<td><b>SMG Company</b></td>
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
							<br><a href="javascript:OpenSmallW('student_app/section4/page22print.cfm?unqid=#get_student_info.uniqueid#');"><img src="pics/attached-files.gif" border="0"></a>	
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

<cfform name="onhold" method="post" action="?curdoc=app_process/qr_app_onhold_info" onSubmit="return CheckFields();">
<cfinput type="hidden" name="studentid" value="#get_student_info.studentid#">
<cfinput type="hidden" name="onhold_reasonid" value="#get_student_info.onhold_reasonid#">
<table width="660" border=0 cellpadding=6 cellspacing=2 align="center" class="thin-border">	
	<tr>
		<td><b>On Hold Reason:</b></td>
		<td><b>On Hold Since</b></td>
	</tr>
	<tr>
		<td valign="top">#get_student_info.hold_reason#<br><img src="pics/line.gif" width="255" height="1" border="0" align="absmiddle"></td>
		<td valign="top">#DateFormat(onhold_history.date, 'mm/dd/yyyy')#<br><img src="pics/line.gif" width="255" height="1" border="0" align="absmiddle"></td>
	</tr>
	<tr>
		<td><b>Put On Hold by:</b><br><br>
			#onhold_history.firstname# #onhold_history.lastname# (###onhold_history.userid#)<br><img src="pics/line.gif" width="255" height="1" border="0" align="absmiddle"><br><br>
			<b>Notification Letter:</b>
		</td>
		<td valign="top" rowspan="2"><b>Notes:</b><br><br>
			<cftextarea name="onhold_notes" cols="35" rows="5">#get_student_info.onhold_notes#</cftextarea>
			<br>* Notes will be included in the email notification.
		</td>
	</tr>
	<tr>
		<td valign="top">
			<cfif get_student_info.onhold_reasonid EQ 1>
				Allergy Information Form <a href="?curdoc=app_process/email_allergy&studentid=#get_student_info.studentid#" onClick="return confirm_email()"><img src="pics/email.gif" border="0" alt="Email Allergy Information Form"></a>
			<cfelseif get_student_info.onhold_reasonid EQ 2>
				Phone Interview Notification <a href="?curdoc=app_process/email_phone_interview&studentid=#get_student_info.studentid#" onClick="return confirm_email()"><img src="pics/email.gif" border="0" alt="Email Phone Interview Notification"></a>
			<cfelseif get_student_info.onhold_reasonid EQ 3>
				Missing Documents Notification <a href="?curdoc=app_process/email_missing_docs&studentid=#get_student_info.studentid#" onClick="return confirm_email()"><img src="pics/email.gif" border="0" alt="Email Missing Documents Notification"></a>
			<cfelseif get_student_info.onhold_reasonid EQ 4>
				Self Placement Notification <a href="?curdoc=app_process/email_self_placement&studentid=#get_student_info.studentid#" onClick="return confirm_email()"><img src="pics/email.gif" border="0" alt="Email Self Placement Notification"></a>
             <cfelseif get_student_info.onhold_reasonid EQ 5>
				See Notes Notification <a href="?curdoc=app_process/email_see_notes&studentid=#get_student_info.studentid#" onClick="return confirm_email()"><img src="pics/email.gif" border="0" alt="Email See Notes Notification"></a>
			</cfif>			
			<br><img src="pics/line.gif" width="255" height="1" border="0" align="absmiddle">
		</td>
	</tr>
	<!--- REASON = 2 - English Interview --->
	<cfif get_student_info.onhold_reasonid EQ 2>
		<tr bgcolor="e2efc7">
			<td colspan="2">English Interview</td>
		</tr>	
		<tr> 
			<td width="30%" align="right">Interview Date: &nbsp;</td>
			<td width="70%"><cfinput type=text name="onhold_interview_date" size=8 value="#DateFormat(get_student_info.onhold_interview_date, 'mm/dd/yyyy')#" validate="date" validateat="onsubmit,onserver" maxlength="10" message="Please enter a date in this format mm/dd/yyyy"> mm/dd/yyyy</td>
		</tr>
		<tr>
			<td align="right">Interview Time: &nbsp;</td> 
			<td><cfinput type=text name="onhold_interview_time" size=8 value="#TimeFormat(get_student_info.onhold_interview_time, 'hh:mm tt')#" validate="time" validateat="onsubmit,onserver" maxlength="7" message="Please enter a time in this format hh:mmtt"> 12:00am</td>
		</tr>
	</cfif>
	<!--- REASON = 3 - Missing Documents --->
	<cfif get_student_info.onhold_reasonid EQ 3>
	<tr>
		<td colspan="2">	
			<table width="100%" id="reason3" border="0" cellpadding="1" cellspacing="1">
				<tr bgcolor="e2efc7"><td colspan="4">Please select missing documents below:</tr>
				<tr>
					<cfloop query="docs_checklist">	
						<td><input type="checkbox" name="onhold_docs" value="#docid#" <cfif ListFind(get_student_info.onhold_docs, docid , ",")>checked</cfif>></td>
						<td>#document#</td>
					<cfif (currentrow MOD 2 ) EQ 0></tr><tr></cfif>
				</cfloop>
			</table>
		</td>
	</tr>
	</cfif>
	<tr>
		<td align="center" colspan="3">
			<table width="660" border=0 cellpadding=10 cellspacing=4 align="center">	
				<tr>
					<!--- ONLINE APPLICATIOn --->
					<cfif get_student_info.randid>
						<td align="center"><a href="javascript:OpenApp('student_app/index.cfm?curdoc=approve_student_app&unqid=#get_student_info.uniqueid#');"><img src="student_app/pics/approve.gif" alt="Approve Application" border="0" align="top"></a></td>
						<td align="center"><cfinput type="image" name="submit" src="student_app/pics/save.gif" alt="Update"></td>
						<td align="center"><a href="javascript:OpenApp('student_app/index.cfm?curdoc=deny_application&unqid=#get_student_info.uniqueid#');"><img src="student_app/pics/deny.gif" alt="Deny Application" border="0" align="top"></a></td>
					<!--- PAPER APPLICATION --->
					<cfelse>
						<td align="center"><a href="?curdoc=app_process/qr_approve&studentid=#get_student_info.studentid#" onClick="return approve()"><img src="student_app/pics/approve.gif" alt="Approve Application" border="0" align="top"></a></td>
						<td align="center"><cfinput type="image" name="submit" src="student_app/pics/save.gif" alt="Update"></td>
						<td align="center"><a href="?curdoc=app_process/deny_app&studentid=#get_student_info.studentid#"><img src="student_app/pics/deny.gif" alt="Deny Application" border="0" align="top"></a></td>
					</cfif>
				</tr>
			</table>
		</td>
	</tr>
</table><br>	
</cfform>
</div>

<cfinclude template="../table_footer.cfm">

</cfoutput>

</body>
</html>