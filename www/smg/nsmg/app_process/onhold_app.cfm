<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="smg.css">
	<title>SMG - EXITS - Application On Hold</title>
</head>
<script language="JavaScript"> 	
<!--// // show hidden forms
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
function ShowForms() {
  currentreason = document.onhold.onhold_reasonid.value;
  if ((currentreason == 0) || (currentreason == 1) || (currentreason == 4)) {
	document.getElementById('reason2').style.display = 'none';
	document.getElementById('reason3').style.display = 'none';
   } else if (currentreason == 2) {
	document.getElementById('reason2').style.display = 'inline';
	document.getElementById('reason3').style.display = 'none';
   } else if (currentreason == 3) {
	document.getElementById('reason3').style.display = 'inline';
	document.getElementById('reason2').style.display = 'none';
   }   
}
function CheckFields() {
  if (document.onhold.companyid.value == 0) {
		alert("You must select a company in order to continue.");
		return false;  
  } else if (document.onhold.onhold_reasonid.value == 0) {
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
function confirm_hold() { 
   if(confirm("You are about to put this application on hold. Click OK to continue")) { 
     form.submit(); 
        return true; 
   } else { 
        return false; 
   } 
} 
//-->
</script> 
<body onLoad="ShowForms()">

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
	SELECT s.studentid, s.uniqueid, s.familylastname, s.firstname, s.middlename, s.dob, s.sex, s.countryresident, 
		s.active, s.app_current_status, s.app_indicated_program, s.dateapplication, s.companyid, s.randid,
		smg_countrylist.countryname,
		u.businessname,
		p.app_program,
		c.companyshort
	FROM smg_students s
	INNER JOIN smg_companies c ON c.companyid = s.companyid
	LEFT JOIN smg_countrylist ON countryresident = smg_countrylist.countryid
	LEFT JOIN smg_student_app_programs p ON p.app_programid = s.app_indicated_program
	LEFT JOIN smg_users u ON u.userid = s.intrep
	WHERE s.studentid = <cfqueryparam value="#url.studentid#" cfsqltype="cf_sql_integer" maxlength="6">
</cfquery>

<cfquery name="get_company" datasource="MySQL">
	SELECT companyid, companyname, companyshort
	FROM smg_companies
	WHERE companyid <= '6'
</cfquery>

<cfquery name="onhold" datasource="MySql">
	SELECT holdid, hold_reason
	FROM smg_student_app_hold
	ORDER BY hold_reason
</cfquery>
 
<cfquery name="docs_checklist" datasource="MySql">
	SELECT docid, document 
	FROM smg_student_doc_checklist 
	ORDER BY document
</cfquery>
 
<cfset nsmg_directory = '/var/www/html/student-management/nsmg/uploadedfiles/web-students'>
<cfdirectory directory="#nsmg_directory#" name="file" filter="#get_student_info.studentid#.*">

<!--- HEADER OF TABLE --->
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
		<td background="pics/header_background.gif"><h2>Put Application On Hold</h2></td>
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

<cfform name="onhold" method="post" action="?curdoc=app_process/qr_onhold_app" onSubmit="return CheckFields();">
<cfinput type="hidden" name="studentid" value="#get_student_info.studentid#">
<table width="660" border=0 cellpadding=6 cellspacing=2 align="center" class="thin-border">	
	<tr><td colspan=2><h3><u>The following information is required to put this application On Hold.</u></h3></td></tr>
	<tr>
		<td width="30%" align="right">SMG company: </td>
		<td width="70%">
			<cfselect name="companyid">
				<option value="0">Select Company</option>
				<cfloop query="get_company">
				<option value="#companyid#" <cfif get_student_info.companyid EQ companyid>selected</cfif>>#companyshort#</option>
		 		</cfloop>
			</cfselect>
		</td>
	</tr>
	<tr>
		<td align="right">On Hold Reason:</td>
		<td>
			<cfselect name="onhold_reasonid" query="onhold" value="holdid" display="hold_reason" queryPosition="below" onChange="ShowForms();" onClick="ShowForms();">
				<option value="0">Select Reason</option>
			</cfselect>
		</td>
	</tr>
	<tr>
		<td align="right" valign="top">Notes:</td>
		<td><cftextarea name="onhold_notes" cols="45" rows="5"></cftextarea>
			<br>* Notes will be included in the email notification.
		</td>
	</tr>	
	<tr>
		<td colspan="2">&nbsp;
			<!--- REASON = 2 - English Interview --->
			<table width="100%" id="reason2" border="0" cellpadding="1" cellspacing="1">
				<tr bgcolor="e2efc7">
					<td colspan="2">English Interview</td>
				</tr>	
				<tr>
					<td width="30%" align="right">Interview Date: &nbsp;</td>
					<td width="70%"><cfinput type=text name="onhold_interview_date" size=8 value="" validate="date" validateat="onsubmit,onserver" maxlength="10" message="Please enter a date in this format mm/dd/yyyy"> mm/dd/yyyy</td>
				</tr>
				<tr>
					<td align="right">Interview Time: &nbsp;</td>
					<td><cfinput type=text name="onhold_interview_time" size=8 value="" validate="time" validateat="onsubmit,onserver" maxlength="7" message="Please enter a time in this format hh:mmtt"> 12:00am</td>
				</tr>
			</table>
			<!--- REASON = 3 - Missing Documents --->
			<table width="100%" id="reason3" border="0" cellpadding="1" cellspacing="1">
				<tr bgcolor="e2efc7"><td colspan="4">Please select missing documents below:</tr>
				<tr>
					<cfloop query="docs_checklist">	
						<td><cfinput type="checkbox" name="onhold_docs" value="#docid#"></td>
						<td>#document#</td>
					<cfif (currentrow MOD 2 ) EQ 0></tr><tr></cfif>
				</cfloop>
			</table>
		</td>
	</tr>
	<tr>
		<td align="center" colspan=2>
			<cfinput name="submit" type=image src="student_app/pics/hold.gif" alt='On Hold' onClick="return confirm_hold()"> 
			&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 
			<a href="javascript:history.back();"><img src="student_app/pics/back.gif" border="0" alt="Go Back"></a>
		</td>
	</tr>	
</table><br>

<table width="660" border=0 cellpadding=4 cellspacing=2 align="center">	
	<tr><td align="center">Upon On Hold, notification will be sent to #get_student_info.businessname#.<br></td></tr>
</table><br>
</cfform>

<script>
// hide fields for English Interview
document.getElementById('reason2').style.display = 'none';
// hide field for Missing Application Documents
document.getElementById('reason3').style.display = 'none';
</script>	
</div>

<cfinclude template="../table_footer.cfm">

</cfoutput>

</body>
</html>