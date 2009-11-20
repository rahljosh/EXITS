<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Application Cover Letter</title>
<link rel="stylesheet" href="reports.css" type="text/css">
</head>

<body>

<cftry>

<Cfif not isdefined ('client.userid')>
	<cflocation url="../axis.cfm?to" addtoken="no">
</Cfif>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<cfif NOT IsDefined('form.extra_comments')>

	<cfif NOT IsDefined('url.unqid')>
		<cfinclude template="../error_message.cfm">
		<cfabort>
	</cfif>

	<cfquery name="get_student_unqid" datasource="MySql">
		SELECT studentid, firstname, middlename, familylastname
		FROM smg_students s
		WHERE uniqueid = <cfqueryparam value="#url.unqid#" cfsqltype="cf_sql_char">
	</cfquery>
	
	<cfoutput>
	<cfform name="comments" action="letter_app_cover.cfm" method="post">
		<cfinput type="hidden" name="unqid" value="#url.unqid#">
		<table align="center" width="680" cellpadding="1" cellspacing="1">
			<tr><td width="200" align="center"><img src="../pics/dmd-logo.jpg" alt="" border="0" align="center"></td><th><span class="application_section_header">Application Cover Letter </span> <br /><br /> Student: </span> &nbsp; #get_student_unqid.firstname# #get_student_unqid.middlename# #get_student_unqid.familylastname# (###get_student_unqid.studentid#)</th></tr>
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr><td align="center" colspan="2">Please use the box below to include any comments you wish to print on the letter:</td></tr>
			<tr><td colspan="2" align="center"><textarea name="extra_comments" cols="60" rows="3"></textarea></td></tr>
			<tr><td align="center" colspan="2"><cfinput type="submit" name="submit" value="Submit"></td></tr>
			<tr><td colspan="2">&nbsp;</td></tr>
		</table>
	</cfform>
	</cfoutput>

<cfelse>

	<cfif NOT IsDefined('form.unqid')>
		<cfinclude template="../error_message.cfm">
		<cfabort>
	</cfif>

	<cfquery name="get_student_unqid" datasource="MySql">
		SELECT s.studentid, s.firstname, s.middlename, s.familylastname, s.dob, s.sex, s.grades,
			sc.schoolid, sc.schoolname, sc.address, sc.city, sc.zip, sc.contact, s.php_wishes_graduate,
			sta.state as schoolstate,
			p.programid, p.programname,
			c.countryname
		FROM smg_students s
		INNER JOIN php_students_in_program stu_prog ON stu_prog.studentid = s.studentid
		LEFT JOIN php_schools sc ON stu_prog.schoolid = sc.schoolid 
		LEFT JOIN smg_states sta ON sc.state = sta.id 
		LEFT JOIN smg_programs p ON stu_prog.programid = p.programid
		LEFT JOIN smg_countrylist c ON s.countryresident = c.countryid
		WHERE uniqueid = <cfqueryparam value="#form.unqid#" cfsqltype="cf_sql_char">
	</cfquery>
	
	<cfoutput query="get_student_unqid">
	
	<!--- Page Header --->
	<table width="680" align="center" border=0> 
		<tr>
			<td align="left" width="130"><img src="../pics/dmd-logo.jpg"  alt="" border="0" align="left"></td>
			<td align="left" valign="top">
				<b>#companyshort.companyname#</b><br>
				#companyshort.address#<br>
				#companyshort.city#, #companyshort.state# #companyshort.zip#<br><br></td>
			<td align="right" valign="top">
				<cfif companyshort.phone NEQ ''> Phone: #companyshort.phone#<br></cfif>
				<cfif companyshort.toll_free NEQ ''> Toll Free: #companyshort.toll_free#<br></cfif>
				<cfif companyshort.fax NEQ ''> Fax: #companyshort.fax#<br></cfif></td>
		</tr>
	</table>
	
	<table width="680" align="center" border=0>
		<tr><td><hr width=90% align="center"></td></tr>
	</table><br>
	
	<table width="680" align="center" border=0 cellpadding="1" cellspacing="1">
		<tr><td align="right">#DateFormat(now(), 'dddd, mmmm dd, yyyy')#</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>#contact#</td></tr>
		<tr><td>#schoolname#</td></tr>
		<tr><td>#address#</td></tr>
		<tr><td>#city#, #schoolstate# - #zip#</td></tr>	
	</table><br /><br />
	
	<table width="680" align="center" border=0 cellpadding="1" cellspacing="1">
		<tr><td><span class="style2">Student: </span> &nbsp; #firstname# #middlename# #familylastname# (###studentid#)</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td><span class="style2">Gender: </span> &nbsp; #sex#</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td><span class="style2">DOB: </span> &nbsp; #DateFormat(dob, 'mm/dd/yyyy')#</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td><span class="style2">Last Grade Completed: </span> &nbsp; #grades#</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td><span class="style2">Country: </span> &nbsp; #countryname# </td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td><span class="style2">Program: </span> &nbsp; #programname#</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td><span class="style2">Wishes to Graduate: </span> &nbsp; <cfif php_wishes_graduate is ''>No<cfelse>Yes</cfif></td></tr>
	</table><br />	
		
	<table width="680" align="center" border=0 cellpadding="1" cellspacing="1">
		<tr><td class="style2">Comments:</td></tr>
		<tr><td class="style1">Please review this student's application and send me the acceptance form attached, 
					to the fax number above as soon as possible.
					If you have any questions or need further information, please email me at luke@phpusa.com.
					<cfif form.extra_comments NEQ ''><br /><br />#form.extra_comments#</cfif>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td class="style1">Attached, please find the student passport copy to assist in completion of the I-20 form.</td></tr>
		<tr><td>&nbsp;<br /></td></tr>
		<tr><td>Kind Regards,</td></tr>	
		<tr><td>&nbsp;<br /></td></tr>
		<tr><td><img src="../pics/lukesign.jpg" border="0"></td></tr>
		<tr><td>Luke Davis</td></tr>	
		<tr><td>Program Director</td></tr>	
		<tr><td>#companyshort.companyname#</td></tr>			
	</table><br /><br />
	</cfoutput>

</cfif>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>

</cftry>
</body>
</html>