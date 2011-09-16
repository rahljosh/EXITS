<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Email Acceptance Letter</title>
<link rel="stylesheet" href="reports.css" type="text/css">
</head>

<body>

<Cfif not isdefined ('client.userid')>
	<cflocation url="../axis.cfm?to" addtoken="no">
</Cfif>

<cfif NOT IsDefined('url.unqid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<cfquery name="get_student_unqid" datasource="MySql">
	SELECT s.studentid, s.firstname, s.middlename, s.familylastname, s.dob, s.sex, s.grades, s.uniqueid, s.other_missing_docs,
		sc.schoolid, sc.schoolname, sc.address, sc.city, sc.zip, sc.contact, sc.nonref_deposit, sc.refund_plan, s.php_grade_student,
		sta.state as schoolstate,
		p.programid, p.programname,
		c.countryname,
		u.businessname, u.fax as intfax, u.php_contact_email as intemail
	FROM smg_students s
	INNER JOIN php_students_in_program stu_prog ON stu_prog.studentid = s.studentid
	LEFT JOIN php_schools sc ON stu_prog.schoolid = sc.schoolid 
	LEFT JOIN smg_states sta ON sc.state = sta.id 
	LEFT JOIN smg_programs p ON stu_prog.programid = p.programid
	LEFT JOIN smg_countrylist c ON s.countryresident = c.countryid
	LEFT JOIN smg_users u ON s.intrep = u.userid
	WHERE s.uniqueid = <cfqueryparam value="#url.unqid#" cfsqltype="cf_sql_char">
	AND stu_prog.assignedid = <cfqueryparam value="#url.assignedid#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="get_current_user" datasource="MySql">
	SELECT email, firstname, lastname
	FROM smg_users
	WHERE userid = '#client.userid#'
</cfquery>

<CFSET ImgScrPath = "http://www.student-management.com">

<cfoutput query="get_student_unqid">

<CFMAIL SUBJECT="Receipt and Acceptance Letter for #firstname# #familylastname# ( #studentid# )"
	TO="#intemail#" bcc="#get_current_user.email#"
	FROM='"#companyshort.companyname#" <#get_current_user.email#>'
	TYPE="HTML">
<HTML>
<HEAD>

<style type="text/css">
<!--
.style1 {
	font-size:14px;
	text-align: justify;
}
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

<p>Please DO NOT reply to this message.<br>
If you are not able to read this e-mail please contact #companyshort.companyshort#.</p>

<table width="680" border=0 bgcolor="FFFFFF">
	<tr><td class="application_section_header">RECEIPT AND ACCEPTANCE NOTIFICATION</td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td class="style1">This application for the following student(s) have been received. Not Only is this a notification of
			acceptance into the DMD Private High School Program, but it is also, in some cases, a notice that additional information
			is needed in order to adhere to United States Department of State regulations. Please send the requested information as
			soon as possible. It is extremely important!!! If a student has been rejected you will be notified with a separate letter.
			(if a student has scheduled dates written in for upcoming immunizations, please make sure that he/she obtains proof in 
			writing from their doctor that the immunization(s) have been completed and the date) *** NEW THIS YEAR: Varicella
			(chickenpox) vaccine or proof that student had chickenpox is now required.
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>	
	<tr><td class="style1">We are awaiting the student's Acceptance letter from the Private High School, the acceptance from the School
			will be forwarded to you as soon as it is received.
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>	
	<tr><td class="style1"><b>Please review spelling of students name and students date of birth. Please confirm correct spelling for 
			I-20 and SEVIS fee.</td>
	</tr>
	<tr><td>&nbsp;</td></tr>		
</table><br />

<table width="680" border=0 cellpadding="1" cellspacing="1">
	<tr><td><span class="style2">Program: </span> &nbsp; <span class="style1">#programname#</span> <br><br> </td></tr>
    <tr><td><span class="style2">Grade Applying: </span> &nbsp; <span class="style1"> #get_student_unqid.php_grade_student#th </span></td></tr>
	<tr><td><hr width=100% ></td></tr>
</table><br />

<table width="680" border=0 cellpadding="1" cellspacing="1">
	<tr class="style2"><td width="250">Student's Name</td><td width="250">Missing Documents</td><td width="180">Non-Refundable Deposit</td></tr>
	<tr><td colspan="3"><hr width=100% ></td></tr>
	<tr>
		<td valign="top">#firstname# #middlename# #familylastname# (###studentid#)<br>
			DOB: #DateFormat(dob, 'mm/dd/yyyy')#</td>
		<td valign="top">#other_missing_docs#</td>
		<td>#nonref_deposit#</td>
	</tr>
	<tr>
    	<td colspan="3">
        	<p>
				<cfif schoolname NEQ ''>
                    Student has been applied to #schoolname# School.
                <cfelse>
                    Please be advised, no school has been selected for this student.
                </cfif>
			</p>                
		</td>
	</tr>	
	<cfif refund_plan EQ '1'>
	<tr><td colspan="3">Please be advised, the school this student has been applied offers a Tuition Refund Plan. If you wish to purchase the 
			Tuition Refund Plan please contact your private high school representative</td></tr>
	</cfif>
	<tr><td colspan="3"><hr width=100% ></td></tr>	
</table><br />

<table width="680" border=0 cellpadding="1" cellspacing="1">
	<tr><td>Thanks,</td></tr>	
	<tr><td>Luke Davis</td></tr>	
	<tr><td>#companyshort.companyname#</td></tr>			
</table><br />

</body>
</html>
</CFMAIL>

<br />
<table border="0" align="left" width="680" valign="top" frame="box">
	<tr><td align="left"><span class="application_section_header">Acceptance Letter</span></td></tr>
	<tr><td align="left"><h2><u>#firstname# #familylastname# ( #studentid# )</u></h2></td></tr>
	<tr align="left" bgcolor="ACB9CD"><td>The Acceptance Letter has been sent to #businessname# at #intemail#</td></tr>
	<tr><td align="left" bgcolor="ACB9CD">
		<input type="image" value="back" src="../pics/back.gif" onClick="javascript:history.back()">  &nbsp;  &nbsp;  &nbsp;  &nbsp;
		<input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()">
		</td>
	</tr>
</table>
</div>
</cfoutput>

</body>
</html>