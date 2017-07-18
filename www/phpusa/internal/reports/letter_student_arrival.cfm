<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Student Arrival Letter</title>
<link rel="stylesheet" href="reports.css" type="text/css">
</head>

<body>

<cfif NOT IsDefined('url.unqid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<cfinclude template="../querys/get_company_short.cfm">

<cfquery name="get_student_unqid" datasource="MySql">
	SELECT s.studentid, s.firstname, s.familylastname, s.uniqueid, s.intrep, s.sex,
		p.programid, p.programname, p.type,
		sc.schoolid, sc.schoolname,
		sc_dates.year_begins, sc_dates.semester_ends, sc_dates.semester_begins, sc_dates.year_ends,
		<!--- FROM THE NEW TABLE PHP_STUDENTS_IN_PROGRAM --->		
		stu_prog.assignedid, stu_prog.companyid, stu_prog.programid, stu_prog.hostid, stu_prog.schoolid, stu_prog.placerepid, stu_prog.arearepid,
		stu_prog.dateplaced, stu_prog.school_acceptance, stu_prog.active, stu_prog.i20no
	FROM smg_students s
	INNER JOIN php_students_in_program stu_prog ON stu_prog.studentid = s.studentid
	LEFT JOIN smg_programs p ON stu_prog.programid = p.programid
	LEFT JOIN php_schools sc ON stu_prog.schoolid = sc.schoolid 
	LEFT JOIN php_school_dates sc_dates ON (sc_dates.seasonid = p.seasonid AND sc_dates.schoolid = stu_prog.schoolid)
	WHERE s.uniqueid = <cfqueryparam value="#url.unqid#" cfsqltype="cf_sql_char">
	AND stu_prog.assignedid = <cfqueryparam value="#url.assignedid#" cfsqltype="cf_sql_integer">
</cfquery>

<cfoutput>

<!--- Page Header --->
<table width="660" align="center" border=0 bgcolor="##FFFFFF" cellpadding="2" style="font-size:13px"> 
	<tr>
		<td><img src="../pics/dmd-logo.jpg"></td>
		<td align="right" > 
			<b>#companyshort.companyname#</b><br>
			#companyshort.address#<br>
			#companyshort.city#, #companyshort.state# #companyshort.zip#<br><br>
			<cfif companyshort.phone NEQ ''> Phone: #companyshort.phone#<br></cfif>
			<cfif companyshort.toll_free NEQ ''> Toll Free: #companyshort.toll_free#<br></cfif>
			<cfif companyshort.fax NEQ ''> Fax: #companyshort.fax#<br></cfif>
		</td>
	</tr>
	<tr><td colspan="2"><hr width=100% align="center"></td></tr>
</table>

<!--- PROGRAM TYPES
1 AYP 10 months
2 AYP 12 months
3 AYP 1st semester
4 AYP 2nd semester
--->

<table width="660" align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
	<tr><td align="right">#DateFormat(now(), 'dddd, mmmm d, yyyy')#</td></tr>
	<tr><td align="right">School: #get_student_unqid.schoolname#</td></tr>
	<tr>
		<td align="right">
			From: 
			<cfif get_student_unqid.type EQ 4>
				<cfif get_student_unqid.semester_begins NEQ ''>#DateFormat(get_student_unqid.semester_begins, 'mmm. d, yyyy')#</cfif>
			<cfelse>
				<cfif get_student_unqid.year_begins NEQ ''>#DateFormat(get_student_unqid.year_begins, 'mmm. d, yyyy')#</cfif>
			</cfif>		
			thru
			<cfif get_student_unqid.type EQ 3>
				<cfif get_student_unqid.semester_ends NEQ ''>#DateFormat(get_student_unqid.semester_ends, 'mmm. d, yyyy')#</cfif>
			<cfelse>
				<cfif get_student_unqid.year_ends NEQ ''>#DateFormat(get_student_unqid.year_ends, 'mmm. d, yyyy')#</cfif>
			</cfif>						
		</td>
	</tr>			
</table><br><br>
	
<table width="660" align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
	<tr>	
		<td>
			<div align="justify">

			<p>Dear #get_student_unqid.firstname# #get_student_unqid.familylastname# (###get_student_unqid.studentid#).

			<p>On behalf of everyone at DMD, I would like to take this opportunity to welcome you to this exciting, 
			challenging and rewarding program.</p>
			
			<p>Everyone involved with our Private High School Program wants to assure you that we have worked hard to make sure that this
			experience will be memorable and beneficial. We are here to assist you in any way possible throughout your stay. 
			Your school is #get_student_unqid.schoolname# and they are very eager to greet you and ensure that your stay goes well.</p>
			
			<p>We take our mission statement, "Educating Tomorrow's Leaders" very seriously. Our staff is always available to you. 
			We are fully aware that your experience requires careful planning as well as care, love and attention.</p>
			
			<p>We know that we can all make a difference in this world when we all work together for our common goal. 
			We know our mission is only possible when we all join together to make this upcoming year a great success for everyone!!</p>
			
			<p>We look forward to seeing you in the States.</p>	
					
			</div>
		</td>
	</tr>
</table>

<!--- PAGE BOTTON --->	
<table width="660" align="center" border=0 cellpadding="1" cellspacing="1" style="font-size:13px">
	<tr><td>Best Regards,</td></tr>	
	<tr><td>&nbsp;</td></tr>
	<tr><td><img src="../pics/diana_signature.png" border="0"></td></tr>
	<tr><td>Diana DeClemente</td></tr>
	<tr><td>Program Director</td></tr>	
	<tr><td>#companyshort.companyname#</td></tr>			
</table><br />
</cfoutput>

</body>
</html>
