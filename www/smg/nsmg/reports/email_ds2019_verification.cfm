<link rel="stylesheet" href="reports.css" type="text/css">
<cfif not IsDefined('form.programid')>
	<p>You must select at least 1 program or enter the deadline date in order to continue. <br> Please close this window and try again.</p>
	<div align="center"><input type="image" src="../pics/close.gif" value="Close" onClick="javascript:window.close()"></div>
	<cfabort>
</cfif>

<cfinclude template="../querys/get_company_short.cfm">

<cfquery name="get_programs" datasource="MYSQL">
	SELECT DISTINCT p.programid, p.programname, c.companyshort
	FROM 	smg_programs p
	INNER JOIN smg_companies c ON c.companyid = p.companyid
	WHERE <cfloop list=#form.programid# index='prog'>
			programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
		  </cfloop>
</cfquery>

<cfquery name="get_current_user" datasource="MySql">
	SELECT userid, firstname, lastname, email
	FROM smg_users
	WHERE userid = '#client.userid#'
</cfquery>

<cfquery name="GetIntlReps" datasource="MySql">
	SELECT DISTINCT userid, businessname, userid, u.email, u.email2, u.firstname, u.lastname
	FROM smg_students s
	INNER JOIN smg_users u 	ON s.intrep = u.userid
	INNER JOIN smg_programs p ON s.programid = p.programid
	WHERE  s.active = '1' 
		   AND s.verification_received IS NULL
		   AND s.ds2019_no = ''
		   AND s.companyid = '#client.companyid#' 
		   AND s.onhold_approved <= '4'
     	   <cfif form.intrep is 0><cfelse>AND s.intrep = #form.intrep#</cfif>
		   AND ( <cfloop list="#form.programid#" index="prog">
				s.programid = #prog# 
				<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
				</cfloop> )
	ORDER BY u.businessname
</cfquery>

<cfif GetIntlReps.recordcount is 0>
	<p>There is no students to populate the DS 2019 Verification Report for the programs selected.</p>
	<cfabort>
</cfif>

<cfloop query="GetIntlReps">

	<cfquery name="get_student" datasource="MySQL">
		SELECT studentid, familylastname, firstname, middlename, sex, dob, citybirth, intrep,
		birth.countryname as countrybirth, resident.countryname as countryresident, citizen.countryname as countrycitizen
		FROM 	smg_students
		LEFT JOIN smg_countrylist birth ON smg_students.countrybirth = birth.countryid
		LEFT JOIN smg_countrylist resident ON smg_students.countryresident = resident.countryid
		LEFT JOIN smg_countrylist citizen ON smg_students.countrycitizen = citizen.countryid
		WHERE   active = '1' 
		   AND verification_received IS NULL
		   AND ds2019_no = ''
		   AND companyid = '#client.companyid#' 
		   AND onhold_approved <= '4'
		   AND intrep = '#GetIntlReps.userid#'
		   AND ( <cfloop list="#form.programid#" index="prog">
				 programid = #prog# 
				<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
				</cfloop> )
		ORDER BY familylastname
	</cfquery>

	<!--- send email if the option is checked --->
	<cfquery name="fax_number" datasource="mysql">
	select fax
	from smg_companies
	where companyid = #client.companyid#
	</cfquery>
	<cfif IsDefined('form.send_email') AND GetIntlReps.email NEQ ''>
		
 		<cfif IsDefined('form.copy_email')>
			<cfset get_user_email = get_current_user.email>
		<cfelse>
			<cfset get_user_email = GetIntlReps.email>			
		</cfif>
		
		<cfmail to="#GetIntlReps.email#" bcc="#get_current_user.email#" 
        replyto="#get_current_user.email#"
FROM="""DS-2019 Verification"" <#client.support_email#>"
			subject="#companyshort.companyshort_nocolor# - DS 2019 Verification Report" type="html">
			<HTML>
			<HEAD>
				<style type="text/css">
				h3{
				 font: bold 100% Arial,sans-serif;
				 color: ##334d55;
				 margin: 0px;
				 padding: 0px;
				}
				h4{
				 font: 100% Arial,sans-serif;
				 color: ##333333;
				 margin: 0px;
				 padding: 0px;
				}
				pagecell_reports {
				  width:100%;
				  background-color: ##ffffff;
				  font-size:10pt;
				  position: absolute;
				}
				</style>
			</HEAD>	
			<BODY>
			<cfinclude template="email_intl_header.cfm">
			<div id="pagecell_reports">
			<hr width=80% color="000000">
			<div align="center"><h3>DS 2019 Verification Report</h3></div>
			<div align="center"><h4>Total of #get_student.recordcount# student(s).</h4></b></div>
			<div align="center"><font size="-2">PS: Better if printed in landscape format.</font></div>
			<hr width=80% color="000000">
			<table width="95%" cellpadding=10 cellspacing="0" align="center" frame="below">
				<tr>
					<td width=1% align="center"><u>Verified<br> (initial)</u></td>
					<td width=2%><u>ID</u></td>
					<td width=14%><u>Last Name</u></td>
					<td width=14%><u>First Name</u></td>
					<td width=14%><u>Middle Name</u></td>
					<td width=6%><u>Sex</u></td>
					<td width=9%><u>Date of Birth (mm/dd/yyyy)</u></td>
					<td width=10%><u>City of Birth</u></td>
					<td width=10%><u>Country of Birth</u></td>
					<td width=10%><u>Country of Citizenship</u></td>
					<td width=10%><u>Country of Residence</u></td> 
				</tr>
				<cfloop query="get_student">
				<tr bgcolor="#iif(get_student.currentrow MOD 2 ,DE("ededed") ,DE("white") )#" >
					<td>______</td>
					<td>#get_student.studentid#</td>
					<td>#get_student.familylastname#</td><td>#get_student.firstname#</td>
					<td>#get_student.middlename#</td><td>#get_student.sex#</td><td>#DateFormat(get_student.dob, 'mm/dd/yyyy')#</td>
					<td>#get_student.citybirth#</td><td>#get_student.countrybirth#</td><td>#get_student.countrycitizen#</td>
					<td>#get_student.countryresident#</td>
				</tr>
				</cfloop>
			</table>
			<br>			
			<table width="95%" cellpadding=2 cellspacing="0" align="center">
				<tr>
					<td valign="top"><div align="justify">
					Please verify that the information above is  correct by <strong>initialing next to each student ID</strong>. If there's anything wrong  or misspelled, please correct it ON THIS FORM. </div></td></tr>
				<tr><td>
					<table cellpadding=2 cellspacing="0" align="center">
						<tr><td valign="top">
							<div align="justify">
							  <p>By signing this form you are verifying that:<br>
							    1. Student has been personally interviewed (CSIET4)<br>
							    2. Student has not participated in F-1 or J-1  programs in the past (##14)<br>
							    3. Student was screened for background,  needs, experience and English							  </p>
							  After you have made the corrections, sign the form and  fax it back to me at #fax_number.fax#. Once I receive the corrected report, I can  issue the DS2019 forms for your students.<br>
                              <strong>In order for the forms to be sent out in our next mailing, I will need the  corrected verification report back  </strong><b> 
                              <cfif form.deadline NEQ ''>
                                by  #DateFormat(form.deadline, 'dddd mmmm dd')# at 5:00pm EST.
                                <cfelse>as soon as possible.</cfif><!---   by Wednesday May 17 at 6:00pm EST. ---></b><br>
							<br><b><strong>PS: Please, be sure to make all corrections visible,  readable and clear.</strong></b><br>
						  </div>
						</td>
						</tr>
					</table>
				</td>
				</tr>
			</table>
			<br>
			<table width="95%" align="center" cellpadding=2 cellspacing="0" frame="border">
              <tr>
                <td height="28" colspan="2"><u><strong>Verification:</strong></u></td>
              </tr>
              <tr>
                <td>Signature: ___________________________________________</td>
                <td>Date: _________________________________________</td>
              </tr>
            </table>
			<br>
			<table width="95%" align="center" cellpadding=2 cellspacing="0">
				<tr><td>Our best regards,</td></tr>
				<tr><td>#get_current_user.firstname# #get_current_user.lastname# <!---#companyshort.verification_letter#---></td></tr>
				<tr><td>Student Admissions Department</td></tr>
			</table>
			</BODY>
			</HTML>
		</cfmail>
	</cfif>

	<cfoutput>
		<hr width=80% color="000000">
		<div align="center"><h4>#GetIntlReps.businessname#</h4></div>
		<cfif GetIntlReps.email EQ ''><div align="center"><h4><font color="##FF0000">*** No email address on file. Report will not be emailed. ***</font></h4></div></cfif>
		<div align="center"><h3>DS 2019 Verification Report</h3></div>
		<div align="center"><h4>Total of #get_student.recordcount# student(s).</h4></b></div>
		<div align="center"><font size="-2">PS: Better if printed in landscape format.</font></div>
		<hr width=80% color="000000">
		<table width="95%" cellpadding=10 cellspacing="0" align="center" frame="below">
			<tr>
				<td width=3%><u>ID</u></td>
				<td width=14%><u>Last Name</u></td>
				<td width=14%><u>First Name</u></td>
				<td width=14%><u>Middle Name</u></td>
				<td width=6%><u>Sex</u></td>
				<td width=9%><u>Date of Birth mm/dd/yyyy</u></td>
				<td width=10%><u>City of Birth</u></td>
				<td width=10%><u>Country of Birth</u></td>
				<td width=10%><u>Country of Citizenship</u></td>
				<td width=10%><u>Country of Residence</u></td> 
			</tr>
			<cfloop query="get_student">
			<tr bgcolor="#iif(get_student.currentrow MOD 2 ,DE("ededed") ,DE("white") )#" >
				<td>#get_student.studentid#</td><td>#get_student.familylastname#</td><td>#get_student.firstname#</td>
				<td>#get_student.middlename#</td><td>#get_student.sex#</td><td>#DateFormat(get_student.dob, 'mm/dd/yyyy')#</td>
				<td>#get_student.citybirth#</td><td>#get_student.countrybirth#</td><td>#get_student.countrycitizen#</td>
				<td>#get_student.countryresident#</td>
			</tr>
			</cfloop>
		</table><br>
		<cfif IsDefined('form.send_email') AND GetIntlReps.email NEQ ''>
			<p><font color="3333CC"><u><b><center>DS2019 Report was sent to &nbsp; #GetIntlReps.email# &nbsp; on &nbsp; #dateformat(now(), 'mm/dd/yyyy')# &nbsp; at &nbsp; #timeformat(now(), 'hh:mm:ss tt')#</center></b></u></font></p>
			<hr width="80%" align="center"><br>
		</cfif><br><br>
	</cfoutput>
</cfloop>