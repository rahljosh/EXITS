<link rel="stylesheet" href="reports.css" type="text/css">

<cfif isdefined('url.studentid')>
	<cfset client.studentid = #url.studentid#>
</cfif>

<!--- Student Info --->
<cfinclude template="../querys/get_student_info.cfm">

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<!----Int. Rep Info---->
<cfquery name="GetIntlReps" datasource="MySQL">
	select companyid, businessname, fax, email, firstname, lastname, businessphone, master_accountid
	from smg_users 
	where userid = '#get_Student_info.intrep#'
</cfquery>

<!-----Program Name----->
<cfquery name="program_name" datasource="MySQL">
select programname, programtype
from smg_programs
INNER JOIN smg_program_type
ON type = programtypeid
where programid = #get_Student_info.programid#
</cfquery>

<!-----Intl. Agent----->
<cfquery name="int_Agent" datasource="MySQL">
	select companyid, businessname, fax, email	
	from smg_users 
	where userid = #get_Student_info.intrep#
</cfquery>

<cfquery name="get_current_user" datasource="MySql">
SELECT email, firstname, lastname
FROM smg_users
WHERE userid = #client.userid#
</cfquery>

<CFSET ImgScrPath = "#client.site_url#">

<cfoutput>
<CFMAIL SUBJECT="Receipt and Acceptance Letter for #get_student_info.firstname# #get_student_info.familylastname# ( #get_student_info.studentid# )"
TO=#int_agent.email#  
bcc=#get_current_user.email#
replyto="#get_current_user.email#"
FROM="""Acceptance Notification"" <#client.support_email#>"
TYPE="HTML">
<HTML>
<HEAD>

<style type="text/css">
<!--
.style1 {font-size: 13px}
.application_section_header{
	border-bottom: 1px dashed Gray;
	text-transform: uppercase;
	letter-spacing: 5px;
	width:100%;
	text-align:center;
	background;
	background: DCDCDC;
	font-size: small;
}
.acceptance_letter_header {
	border-bottom: 1px dashed Gray;
	text-transform: capitalize;
	letter-spacing: normal;
	width:100%;
	text-align:left;
}

-->
</style>
</HEAD>
<BODY>
<cfinclude template="email_intl_header.cfm">
<br>
<!--- <p>Please DO NOT reply to this message.<br>
If you are not able to read this e-mail please contact #companyshort.companyshort_nocolor#.</p> --->

<table  width=650 align="center" border=0 bgcolor="FFFFFF" >
	<tr>
	<td>
    <div align="justify"><span class="application_section_header"><font size=+1><b><u>RECEIPT AND ACCEPTANCE NOTIFICATION</u></b></font></span><br>
    <br><br>
		  The application for the following student(s) has been received. Not only is this a
		  notification of acceptance but it is also, in some cases, a notice that additional
		  information is needed in order to adhere to United States Department of State regulations
		  and to ensure that the student will be easily placed. Please send the requested information
		  <b>in English </b>as soon as possible. It is extremely important!!! If a student has been rejected you will be
		  notified with a separate letter. (If a student has scheduled dates written in for upcoming 
		  immunizations, please make sure that he/she obtains proof in writing from their doctor that
		  the immunizations have been completed and the date).
     <br><br>
	 </div></td></tr>
</table>

<table width=650 border=0 align="center" bgcolor="FFFFFF">
	<td><p><b>Program:</b> #program_name.programname# &nbsp; - &nbsp; #program_name.programtype#<p></td>
	<tr><td colspan=3><hr width=100% align="center"></td></tr>
	<tr><td valign="top" width=280><span class="acceptance_letter_header">
		Student's Name</span><br><br>
		<span class="style1">#get_Student_info.firstname# #get_Student_info.familylastname# (#get_Student_info.studentid#)</span>
	</td>
	<td valign="top" width=370><span class="acceptance_letter_header">
	Missing Documents</span><br><br>
	<span class="style1">#get_Student_info.other_missing_docs#</span>
	</td></tr>
	<td colspan=3><hr width=100% align="center"></td><br>
</table>

<table width=650 border=0 align="center" bgcolor="FFFFFF">
	<tr><td>
	<br>Thanks,<br><br>
	#companyshort.admission_person#<br> 
	Student Admissions Department
	</td></tr>
</body>
</html>
</CFMAIL>

<span class="application_section_header">Acceptance Letter</span>
<div class="row"><br>

<div align="center"><h2><u>#get_student_info.firstname# #get_student_info.familylastname# ( #get_student_info.studentid# )</u></h2></div>

<table border="0" align="center" width="99%" bordercolor="C0C0C0" valign="top" cellpadding="3" cellspacing="1">
<tr align="center" bgcolor="ACB9CD"><td><span class="get_Attention">The Acceptance Letter has been sent to #int_agent.businessname# at #int_agent.email#</span></td></tr>
<td align="center" bgcolor="ACB9CD">
	<input type="image" value="back" src="../pics/back.gif" onClick="javascript:history.back()">  &nbsp;  &nbsp;  &nbsp;  &nbsp;
	<input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()">
</td></tr>
</table>
</div>
</cfoutput>