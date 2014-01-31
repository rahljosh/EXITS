<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="smg.css">
	<title>SMG - EXITS - Reactivate Application</title>
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
function CheckFields() {
  if (document.reactivate.companyid.value == 0) {
		alert("You must select a company in order to continue.");
		return false;  
  } else if (document.reactivate.reason.value == '') {
		alert("You must write a reason for reactivating this application..");
		return false;  
  }
}
function confirm_reactivate() { 
   if(confirm("You are about to reactivate this application. Click OK to continue")) { 
     form.submit(); 
        return true; 
   } else { 
        return false; 
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
	SELECT s.studentid, s.uniqueid, s.familylastname, s.firstname, s.middlename, s.dob, s.sex, s.countryresident, 
		s.active, s.app_current_status, s.app_indicated_program, s.dateapplication, s.companyid, s.randid,
		smg_countrylist.countryname,
		u.businessname,
		p.app_program,
		c.companyshort
	FROM smg_students s
	LEFT JOIN smg_companies c ON c.companyid = s.companyid
	LEFT JOIN smg_countrylist ON countryresident = smg_countrylist.countryid
	LEFT JOIN smg_student_app_programs p ON p.app_programid = s.app_indicated_program
	LEFT JOIN smg_users u ON u.userid = s.intrep
	WHERE s.studentid = <cfqueryparam value="#url.studentid#" cfsqltype="cf_sql_integer" maxlength="6">
</cfquery>

<cfquery name="get_company" datasource="MySQL">
	SELECT companyid, companyname, companyshort
	FROM smg_companies
	WHERE companyid IN (1,2,3,4,5,6,10,12)
</cfquery>

<cfdirectory directory="#AppPath.onlineApp.picture#" name="file" filter="#get_student_info.studentid#.*">

<!--- HEADER OF TABLE --->
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
		<td background="pics/header_background.gif"><h2>Reactivate Application</h2></td>
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

<cfform name="reactivate" method="post" action="?curdoc=app_process/qr_reactivate_app" onSubmit="return CheckFields();">
<cfinput type="hidden" name="studentid" value="#get_student_info.studentid#">
<table width="660" border=0 cellpadding=6 cellspacing=2 align="center" class="thin-border">	
	<tr><td colspan=2><h3><u>The following information is required to reactivate this application.</u></h3></td></tr>
	<tr>
		<td width="30%" align="right">Reactivated By: </td>
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
		<td align="right" valign="top">Reactivate Reason:</td>
		<td><cftextarea name="reason" cols="45" rows="5"></cftextarea></td>
	</tr>	
	<tr>
		<td align="center" colspan=2>
			<cfinput name="submit" type=image src="student_app/pics/reactivate.gif" alt='Reactivate Application' onClick="return confirm_reactivate()"> 
			&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 
			<a href="javascript:history.back();"><img src="student_app/pics/back.gif" border="0" alt="Go Back"></a>
		</td>
	</tr>	
</table><br>

<table width="660" border=0 cellpadding=4 cellspacing=2 align="center">	
	<tr><td align="center">Upon reactivation student will be set to received status. A notification will be sent to the finance deparment.</td></tr>
</table><br>
</cfform>
</div>

<cfinclude template="../table_footer.cfm">

</cfoutput>

</body>
</html>