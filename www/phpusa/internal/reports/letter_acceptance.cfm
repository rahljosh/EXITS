<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Acceptance Letter</title>
<link rel="stylesheet" href="reports.css" type="text/css">
</head>

<body>

<cftry>

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
		sc.schoolid, sc.schoolname, sc.address, sc.city, sc.zip, sc.contact, sc.nonref_deposit, sc.refund_plan,
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
	AND stu_prog.assignedid = <cfqueryparam value="#url.assignedid#" cfsqltype="cf_sql_char">
</cfquery>

<cfoutput query="get_student_unqid">

<!--- Page Header --->

<table width=650 align="center" border=0 bgcolor="FFFFFF"> 
	<tr>
		<td>
		<table>
			<tr><td>TO:</td><td><cfif LEN(businessname) GT '30'>#Left(businessname,27)#...</a><cfelse>#businessname#</cfif></td></tr>
			<tr><td>FAX:</td><td>#intfax#</td></tr>
			<tr><td>E-MAIL:</td><td><a href="mailto:#intemail#">#intemail#</a></td></tr>
			<tr><td colspan="2">#DateFormat(now(), 'dddd, mmmm dd, yyyy')#</td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><cfform action="letter_acceptance_email.cfm?unqid=#url.unqid#&assignedid=#url.assignedid#" name="sendemail" method="post" onsubmit="return confirm ('Are you sure? This Acceptance Letter will be sent to #businessname#')">
						<cfinput name="send" type="image" src="../pics/send-email.gif" value="send email">
					</cfform>
				</td>
			</tr>
		</table>
		</td>
		<td valign="top" rowspan=4 align="center"><img src="../pics/dmd-logo.jpg"></td>
		<td valign="top" align="right" > 
			<b>#companyshort.companyname#</b><br>
			#companyshort.address#<br>
			#companyshort.city#, #companyshort.state# #companyshort.zip#<br><br>
			<cfif companyshort.phone NEQ ''> Phone: #companyshort.phone#<br></cfif>
			<cfif companyshort.toll_free NEQ ''> Toll Free: #companyshort.toll_free#<br></cfif>
			<cfif companyshort.fax NEQ ''> Fax: #companyshort.fax#<br></cfif>
		</td>
	</tr>
</table><br>

<table width="680" align="center" border=0>
	<tr><td><hr width=90% align="center"></td></tr>
</table><br>

<table width="680" align="center" border=0 cellpadding="1" cellspacing="1">
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
</table>

<table width="680" align="center" border=0 cellpadding="1" cellspacing="1">
	<tr><td><span class="style2">Program: </span> &nbsp; <span class="style1"> #programname# </span></td></tr>
	<tr><td><hr width=100% align="center"></td></tr>
</table>

<table width="680" align="center" border=0 cellpadding="1" cellspacing="1">
	<tr class="style2"><td width="250">Student's Name</td><td width="250">Missing Documents</td><td width="180">Non-Refundable Deposit</td></tr>
	<tr><td colspan="3"><hr width=100% align="center"></td></tr>
	<tr>
		<td>#firstname# #middlename# #familylastname# (###studentid#) <br />
			DOB: #DateFormat(dob, 'mm/dd/yyyy')#</td>
		<td>#other_missing_docs#</td>
		<td>#nonref_deposit#</td>
	</tr>
	<tr><td colspan="3">
		<cfif schoolname NEQ ''>
			Student has been applied to #schoolname# School.
		<cfelse>
			Please be advised, no school has been selected for this student.
		</cfif>
		</td>
	</tr>
	<cfif refund_plan EQ '1'>
	<tr><td colspan="3">Please be advised, the school this student has been applied offers a Tuition Refund Plan. If you wish to purchase the 
			Tuition Refund Plan please contact your private high school representative</td></tr>
	</cfif>	
	<tr><td colspan="3"><hr width=100% align="center"></td></tr>	
</table><br />

<table width="680" align="center" border=0 cellpadding="1" cellspacing="1">
	<tr><td>Thanks,</td></tr>	
	<tr><td>&nbsp;</td></tr>
	<tr><td><img src="../pics/lukesign.jpg" border="0"></td></tr>
	<tr><td>Luke Davis</td></tr>	
	<tr><td>#companyshort.companyname#</td></tr>			
</table><br />
</cfoutput>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>
</body>
</html>